class Param < ActiveRecord::Base
  belongs_to :dyna_model
  has_many :proxy_param, :dependent => :destroy
  
  has_paper_trail
  
  validates :code , presence: true
  validates :human_title , presence: true
  
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
