class Line < ActiveRecord::Base
  belongs_to :measurement
  
  def z_formatted
      if z == nil
        'null'
      else
        z
      end 
  end
end
