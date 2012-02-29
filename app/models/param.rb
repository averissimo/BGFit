class Param < ActiveRecord::Base
  belongs_to :dyna_model
  
  public
    def description_trimmed
        return "" if description.nil?
        if description.length > 97
          return description[0..97] + "..." 
        else
          return description
        end
      end
end
