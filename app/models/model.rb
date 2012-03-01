class Model < ActiveRecord::Base
  has_many :experiments, :dependent => :destroy
  versioned
  accepts_nested_attributes_for :experiments
  
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
