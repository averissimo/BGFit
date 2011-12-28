class Line < ActiveRecord::Base
  belongs_to :result
  
  def ph_formatted
      if ph == nil
        'null'
      else
        ph
      end 
  end
end
