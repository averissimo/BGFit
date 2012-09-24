class Measurement < ActiveRecord::Base
  belongs_to :experiment
  
  has_many :lines, :dependent => :destroy
  has_many :proxy_dyna_models, :dependent => :destroy
 
  accepts_nested_attributes_for :lines
  
  scope :model_is, lambda { |model| joins(:experiment).where(:experiments => {:model_id=>model.id} ).order(:experiment_id) }
  scope :dyna_model_is, lambda { |dyna_model| joins(:proxy_dyna_models).where(:proxy_dyna_models => {:dyna_model_id=>dyna_model.id} ).order(:experiment_id) }
  scope :experiment_is, lambda { |experiment| where(:experiment_id=>experiment.id).order(:experiment_id) }
  scope :viewable, lambda { |user| joins(experiment: :model).where( Model.arel_table[:is_published].eq true ) }
 
  has_paper_trail :skip => [:original_data]

  public

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
      self.save unless get_log
    end
  
    def get_proxy_dyna_model_with_dyna_model(dyna_model)
      ProxyDynaModel.where(:measurement_id=>self.id,:dyna_model_id=>dyna_model.id).first
    end
  
    def lines_no_death_phase(no_death_phase=true)
      p_l = nil
      p_2_l = nil
      finish = false
      result = self.lines.sort_by{|l| l.x}.collect { |l|
        next if finish
        
        if p_l && p_2_l
          if no_death_phase && l.y < p_l && p_l < p_2_l  
            finish = true
          end
        end
        p_2_l = p_l
        p_l = l.y
        l
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
        if log
          Math.log( l.x )
        else
          l.x
        end  
      }.join(",")
    end
    
    def y_array(log=false,no_death_phase=true)
      self.lines_no_death_phase(no_death_phase).sort.collect { |l|
        if log
          Math.log( l.y )
        else
          l.y
        end  
      }.join(",")
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
     self.original_data = original_data.gsub(/\r/,'')
     self.original_data.split(/\n/).each_with_index do |l,y|
# removes header from data
#       next if y == 1
#       if y == 0
#         self.title = l
#         next
#       end
       line = Line.new
       l.split(/\t/).each_with_index do |el , y2|

         el = el.gsub("," , ".")
         next if el.match(/N.*A/) || el == nil || el == ""
         
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
       end
       self.lines << line
     end
    #temp_date = title.gsub(/ \(.\)/,"")
    begin
#      self.date = Date.strptime self.title, '%d-%m-%Y'
    rescue
#      self.date = Date.strptime self.title, '%d/%m/%Y'
    end
 #   self.title = self.title.strip
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
      
      date_cmp = self.date <=> o.date
      return date_cmp unless date_cmp == 0
      
      return self.title <=> o.title
    end
end
