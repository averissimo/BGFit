class Measurement < ActiveRecord::Base
  belongs_to :experiment
  
  has_many :measurement_lines, :dependent => :destroy
 
  accepts_nested_attributes_for :measurement_lines
  
  public
   def convert_original_data
     self.original_data = original_data.gsub(/\r/,'')
     self.original_data.split(/\n/).each_with_index do |l,y|
       next if y == 0
       line = MeasurementLine.new
       l.split(/\t/).each_with_index do |el , y2|

         el = el.gsub("," , ".")
         
         next if el.match(/N.*A/)
         
         case y2
          when 0 # time
            line.x = Float(el)
          when 1 # OD600 
            line.y = Float(el)
            line.ln_y = Math.log( line.y )
          when 2 # pH
            line.z = Float(el)
          when 3 # notes
            line.note = el
          end
       end
       self.measurement_lines << line
     end
    end
    
    def original_data_trimmed
      if original_data.length > 27
        return original_data[0..30] + "..." 
      else
        return original_data
      end
    end
end
