class Model < ActiveRecord::Base
  has_many :experiments, :dependent => :destroy
  accepts_nested_attributes_for :experiments
  
  has_many :permissions
  
  has_one :owner, :class_name => "User"
   
  scope :dyna_model_is, lambda { |dyna_model| joins(:experiments => {:measurements => :proxy_dyna_models}).where(:experiments=>{:measurements=>{:proxy_dyna_models=>{:dyna_model_id=>dyna_model.id}}}).group('models.id').order(:id) }
  
  has_paper_trail
  
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
