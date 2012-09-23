class User < ActiveRecord::Base
  has_many :memberships, :dependent => :destroy
  has_many :groups, :through => :memberships
  
  #todo: use pluck in 3.2
  scope :remove_group_members, lambda { |group| User.where( User.arel_table[:id].not_in( Membership.where(Membership.arel_table[:group_id].eq(group.id)).collect { |a| a.user_id } )) }
  
  # Include default devise modules. Others available are:
  # :token_authenticatable, :confirmable,
  # :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable

  # Setup accessible (or protected) attributes for your model
  attr_accessible :email, :password, :password_confirmation, :remember_me
  
end
