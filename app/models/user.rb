class User < ActiveRecord::Base
  has_many :memberships, :dependent => :destroy
  has_many :groups, :through => :memberships
  has_many :owned_models, :class_name => 'Model'
  has_many :owned_dyna_models, :class_name => 'DynaModel'
  
  #todo: use pluck in 3.2
  scope :remove_group_users, lambda { |group| where( User.arel_table[:id].not_in( Membership.where(Membership.arel_table[:group_id].eq(group.id)).collect { |a| a.user_id } )) }
  scope :groups_from, lambda { |user|
    joins( :memberships ).where( Membership.arel_table[:user_id].eq(user.id) )  
  }
  
  # Include default devise modules. Others available are:
  # :token_authenticatable, :confirmable,
  # :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable

  # Setup accessible (or protected) attributes for your model
  attr_accessible :email, :password, :password_confirmation, :remember_me
  
  
  def email_at
    email.gsub(/@/,' (at) ').gsub(/\./,' (dot) ')
  end
end
