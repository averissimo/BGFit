class Group < ActiveRecord::Base
  has_many :memberships, :dependent => :destroy
  has_many :accessibles, :dependent => :destroy

  has_many :users, :through => :memberships
  has_many :permitables, through: :accessibles
  
  # TODO change models to accessibles
  validates :users, :presence => true
   
  scope :remove_model_groups, lambda { |obj|
    return Group.all if obj.groups.blank?
    where( Group.arel_table[:id].not_in( Accessible.permitable_is(obj).map { |a| a.group_id } )) 
  }
  scope :viewable, lambda { |user| joins( :memberships ).where( Membership.arel_table[:user_id].eq(user.id) ) }
  
  def can_view(user=nil) can_access(user) end
  
  def can_edit(user=nil) can_access(user) end
  
  private
  
  def can_access user
    !user.nil? && self.users.present? && self.users.include?(user)
  end
    
end
