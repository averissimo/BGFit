# BGFit - Bacterial Growth Curve Fitting
# Copyright (C) 2012-2012  André Veríssimo
#
# This program is free software; you can redistribute it and/or
# modify it under the terms of the GNU General Public License
# as published by the Free Software Foundation; version 2
# of the License.
#
# This program is distributed in the hope that it will be useful,
# but WITHOUT ANY WARRANTY; without even the implied warranty of
# MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
# GNU General Public License for more details.
#
# You should have received a copy of the GNU General Public License
# along with this program; if not, write to the Free Software
# Foundation, Inc., 51 Franklin Street, Fifth Floor, Boston, MA  02110-1301, USA.

class Measurement < ActiveRecord::Base
  belongs_to :experiment
  
  has_many :lines, :dependent => :destroy
  has_many :proxy_dyna_models, :dependent => :destroy
 
  accepts_nested_attributes_for :lines
  
  scope :custom_sort, lambda { joins(:experiment => :model).order(Model.arel_table[:title],:date,:title) }
  scope :model_is, lambda { |model| joins(:experiment).where(:experiments => {:model_id=>model.id} ).order(:experiment_id) }
  scope :dyna_model_is, lambda { |dyna_model| joins(:proxy_dyna_models).where(:proxy_dyna_models => {:dyna_model_id=>dyna_model.id} ).order(:experiment_id) }
  scope :experiment_is, lambda { |experiment| where(:experiment_id=>experiment.id).order(:experiment_id) }
  scope :viewable, lambda { |user,only_mine=false| joins(:experiment).where( Experiment.arel_table[:model_id].in( Model.viewable(user,only_mine).map { |m| m.id } )) }
 
  scope :published, lambda { joins(:experiment).where( Experiment.arel_table[:model_id].in( Model.published.map { |m| m.id } )) }
 
  has_paper_trail :skip => [:original_data]

  public

    def change_original_data=(value)
      @change_original_data ||= value
    end

    def change_original_data
      @change_original_data
    end

    def build_proxy_dyna_model(dyna_model,log_flag=true,no_death_phase=true)
      p = self.proxy_dyna_models.build
      p.dyna_model_id = dyna_model.id
      p.log_flag = log_flag
      p.no_death_phase = no_death_phase
      p.save
    end

    def minor_step_cache
      determine_minor_step if minor_step.nil?
      result = read_attribute(:minor_step)
      result
    end
    
    def determine_minor_step
      prev_l = nil
      minor_step = nil
      lines_temp = lines_no_death_phase(false).each do |l|
        unless prev_l.nil?
          minor_step_temp = (l.x - prev_l.x).abs
          minor_step = minor_step_temp if minor_step.nil? || minor_step > minor_step_temp
        end
        prev_l = l    
      end
      self.minor_step = minor_step
      self.save
    end
  
    def remove_all_lines
      self.transaction do
        lines.each do |l|
          l.destroy
        end
      end

    end
  
    def get_proxy_dyna_model_with_dyna_model(dyna_model)
      ProxyDynaModel.where(:measurement_id=>self.id,:dyna_model_id=>dyna_model.id).first
    end
  
    def lines_no_death_phase(no_death_phase=true)
      p_l = p_2_l = nil
      finish = false
      result = self.lines.collect { |l|
        next if finish
        if no_death_phase 
          if p_l && p_2_l && l.y < p_l && p_l < p_2_l
            finish = true
            nil
          else
            p_2_l = p_l
            p_l = l.y
            l
          end
        else
          l
        end
      }.compact
      last = result.pop
      if no_death_phase && last.y < result.last.y
        result
      else
        result << last
      end
      
    end
  
    def x_array(log=false,no_death_phase=true)
      self.lines_no_death_phase(no_death_phase).sort.collect { |l|
        if log && l.ln_y.nil?
          nil
        else
          l.x
        end  
      }.compact.join(",")
    end
    
    def y_array(log=false,no_death_phase=true)
      self.lines_no_death_phase(no_death_phase).sort.collect { |l|
        if log && l.ln_y
          l.ln_y
        elsif log
          nil
        else
          l.y
        end  
      }.compact.join(",")
    end
  
    def end(no_death_phase=true)
      self.lines_no_death_phase(no_death_phase).max_by{ |l| 
        l.x 
      }.x * 1.1
      #25 # some simulators fail with the commented code
    end
    
    def end_title
      "end"
    end
  
    def x_0
      self.lines.min_by { |l|
        l.x
      }.x
    end
    
    def x_0_title
      "N"
    end
    
    def model
      self.experiment.model
    end
  
   def convert_original_data
     return if original_data.nil?
     self.original_data = original_data.gsub(/\r/,'')
     self.original_data.split(/\n/).each_with_index do |l,y|

       line = Line.new
       l.split(/\t/).each_with_index do |el , y2|

         el = el.gsub("," , ".")
         next if el.match(/N.*A/) || el == nil || el == ""
         begin
           case y2
            when 0 # time
              line.x = Float(el)
            when 1 # OD600 
              line.y = Float(el)
              line.ln_y = Math.log( line.y ) unless line.y == 0
            when 2 # pH
              line.z = Float(el)
            when 3 # notes
              line.note = el
            end
          rescue Exception => e
            #
            line.note = "Error importing line."
          end
       end
       self.lines << line
     end
  end
      
    def original_data_trimmed
      if original_data.length > 27
        return original_data[0..30] + "..." 
      else
        return original_data
      end
    end
    
    def <=>(o)
      
      model_cmp = self.model.title <=> o.model.title
      return model_cmp unless model_cmp == 0
      
      date_1 = (self.date == nil ? Date.new : self.date)
      date_2 = (o.date == nil ? Date.new : o.date)
      date_cmp = date_1 <=> date_2
      return date_cmp unless date_cmp == 0
      
      exp_cmp = self.experiment.title <=> o.experiment.title
      return exp_cmp unless exp_cmp == 0
            
      return self.title <=> o.title
    end
    
    def update_regression
      x = y = sum_x = sum_y = sum_xy = sum_x2 = count = 0
      self.lines.all.each do |l|
        next unless l.regression_flag
        next if l.x.nil? || l.ln_y.nil?
        
        x = l.x
        begin
          y = l.ln_y
        rescue Exception => e
          next
        end
          
        sum_x  += x
        sum_y  += y
        sum_xy += x * y
        sum_x2 += x * x
        count += 1
      end    
      
      return if count < 2
      
      a_top = sum_y * sum_x2 - sum_x * sum_xy # top of A
      a_bot = count * sum_x2 - sum_x * sum_x  # bottom of A
      b_top = count * sum_xy - sum_x * sum_y  # top of B
      b_bot = count * sum_x2 - sum_x * sum_x  # bottom of B
      a = a_top / a_bot
      b = b_top / b_bot
      
      self.regression_a = a
      self.regression_b = b
    end
    
    def can_view(user=nil)
      experiment.model.can_view(user)
    end
    
    def can_edit(user=nil)
      experiment.model.can_edit(user)
    end
end
