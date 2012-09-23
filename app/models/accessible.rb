class Accessible < ActiveRecord::Base
  belongs_to :model
  belongs_to :group
  
  validates_uniqueness_of :model_id, :scope => [:group_id]
end
