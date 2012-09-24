class Model < ActiveRecord::Base
  has_many :experiments, :dependent => :destroy
  has_many :models, through: :accessibles
  
  has_many :accessibles, :dependent => :destroy, as: :accessible
  has_many :groups, through: :accessibles, as: :accessible

  
  accepts_nested_attributes_for :experiments
  
  has_many :permissions
  
  belongs_to :owner, :class_name => 'User'
   
  scope :dyna_model_is, lambda { |dyna_model| joins(:experiments => {:measurements => :proxy_dyna_models}).where(:experiments=>{:measurements=>{:proxy_dyna_models=>{:dyna_model_id=>dyna_model.id}}}).group('models.id').order(:id) }
  scope :viewable, lambda { |user| 
    if user.nil? then
      where( self.arel_table[:is_published].eq(true))
    else
      includes(:groups => :memberships).where( Model.arel_table[:owner_id].eq(user.id).or(Model.arel_table[:is_published].eq(true)).or( Membership.arel_table[:user_id])  ).group( Model.arel_table[:id] )
    end
  }
  
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
