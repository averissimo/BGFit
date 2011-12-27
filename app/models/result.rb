class Result < ActiveRecord::Base
 validates :title, :presence => true
 
 has_many :lines, :dependent => :destroy
 
 public
   def convert_original_data
     self.original_data = original_data.gsub(/\r/,'')
     self.original_data.split(/\n/).each_with_index do |l,y|
       next if y == 0
       line = Line.new
       l.split(/\t/).each_with_index do |el , y2|

         el = el.gsub("," , ".")
         
         next if el.match(/N.*A/)
         
         case y2
          when 0 # time
            line.time = Float(el)
            print el + "\n"
            print line.time.to_s + "\n"
          when 1 # OD600 
            print el + "\n"
            print line.od600.to_s + "\n"
            line.od600 = Float(el)
          when 2 # ln( OD600 )
            print el + "\n"
            print line.ln_od600.to_s + "\n"
            line.ln_od600 = Math.log( line.od600 ) 
          when 3 # pH
            print el + "\n"
            print line.ph.to_s + "\n"
            line.ph = Float(el)
          end
          print "-------------\n"
       end
       self.lines << line
     end
    end
 
end
