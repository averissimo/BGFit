class Group < ActiveRecord::Base
  has_many :memberships, :dependent => :destroy
  has_many :accessibles, :dependent => :destroy

  has_many :users, :through => :memberships
  has_many :models, through: :accessibles, as: :accessible
  
  scope :remove_model_groups, lambda { |model| where( Group.arel_table[:id].not_in( Accessible.where(Accessible.arel_table[:model_id].eq(model.id)).collect { |a| a.group_id } )) } 
end
