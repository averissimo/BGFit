class MeasurementLine < ActiveRecord::Base
  belongs_to :measurement
  
  def ph_formatted
      if z == nil
        'null'
      else
        z
      end 
  end
end
