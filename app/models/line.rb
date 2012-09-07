class Line < ActiveRecord::Base
  belongs_to :measurement
  
  has_paper_trail
    
  def y_value(log=false)
    if log
      Math.log(self.y)
    else
      self.y
    end
  end
  
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
  
  def <=>(o)
    return self.x <=> o.x unless self.x.nil? || o.x.nil?
    return 0

  end
end
