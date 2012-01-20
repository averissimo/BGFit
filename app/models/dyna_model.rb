class DynaModel < ActiveRecord::Base
  has_many :params
  has_many :proxy_dyna_models
  
  validates_uniqueness_of :title

  public
    def description_trimmed
        if description.length > 97
          return description[0..97] + "..." 
        else
          return description
        end
      end
end
