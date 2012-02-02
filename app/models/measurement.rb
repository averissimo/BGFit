class Measurement < ActiveRecord::Base
  belongs_to :experiment
  
  has_many :lines, :dependent => :destroy
  has_many :proxy_dyna_models, :dependent => :destroy
 
  accepts_nested_attributes_for :lines
  
  public
  
    def lines_no_death_phase
      p_l = nil
      p_2_l = nil
      finish = false
      result = self.lines.sort.collect { |l|
        next if finish
        
        if p_l && p_2_l
          if l.y < p_l && p_l < p_2_l  
            finish = true
          end
        end
        p_2_l = p_l
        p_l = l.y
        l
      }.compact
      last = result.pop
      if last.y < result.last.y
        result
      else
        result << last.y
      end
      
    end
  
    def x_array
      self.lines_no_death_phase.sort.collect { |l|
        l.x  
      } 
    end
    
    def y_array
      self.lines_no_death_phase.sort.collect { |l|
        l.y  
      }
    end
  
    def end
      self.lines.max_by{ |l| 
        l.x 
      }.x
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
      "x_0"
    end
    
    def model
      self.experiment.model
    end
  
   def convert_original_data
     self.original_data = original_data.gsub(/\r/,'')
     self.original_data.split(/\n/).each_with_index do |l,y|
       next if y == 0
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
