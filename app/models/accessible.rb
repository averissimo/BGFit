class Accessible < ActiveRecord::Base
  belongs_to :group
  belongs_to :accessible, :polymorphic => true
  
  validates_uniqueness_of :accessible_id, :scope => [:group_id,:accessible_type]
end
