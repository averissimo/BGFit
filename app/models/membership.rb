class Membership < ActiveRecord::Base
  belongs_to :user
  belongs_to :group
  
  validates_uniqueness_of :user_id, :scope => [:group_id]
  validate :validate_user_email
  validates :group, :presence => {:message => 'Group must not be empty. contact site administrator.'}

  
  def user_email
    return nil if user.nil?
    user.email 
  end
  
  def user_email=(email)
    self.user = User.where( User.arel_table[:email].eq(email) ).uniq.first
  end
    
  def can_edit(user)
    group.can_edit(user)
  end  
  
private
  
    def validate_user_email
      self.user.nil?
      errors.add(:user_email, "User does not exist.") if self.user.nil?
    end
end
