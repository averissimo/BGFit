class Line < ActiveRecord::Base
  belongs_to :measurement
  
  def formatted(input)
    if input == nil
      'null'
    else
      input
    end
  end
  
  def z_formatted
      if z == nil
        'null'
      else
        z
      end 
  end
end
