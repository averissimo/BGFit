class Group < ActiveRecord::Base
  has_many :memberships, :dependent => :destroy
  has_many :accessibles, :dependent => :destroy

  has_many :users, :through => :memberships
  has_many :models, through: :accessibles, as: :accessible
  # TODO change models to accessibles
  validates :users, :presence => true
  validates :models, :presence => true
  
  scope :remove_model_groups, lambda { |model|
    if model.groups.blank?
      Group.all
    else
      where( Group.arel_table[:id].not_in( 
        Accessible.where(
          Accessible.arel_table[:accessible_id].eq(model.id).and(
            Accessible.arel_table[:accessible_type].eq(model.class.model_name)
          )
        ).map { |a| a.group_id } ))
    end 
      }
  scope :viewable, lambda { |user| joins( :memberships ).where( Membership.arel_table[:user_id].eq(user.id) ) }
  
  def can_access user
    self.users.include?(user)
  end
    
end
