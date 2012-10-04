class Accessible < ActiveRecord::Base
  belongs_to :group
  belongs_to :permitable, :polymorphic => true
  
  validates_uniqueness_of :permitable_id, :scope => [:group_id,:permitable_type]

  validates :group, :presence => true
  validates :permitable, :presence => true
  validates :permission_level, :presence => true

  scope :permitable_is, lambda { |obj| 
    where(
      Accessible.arel_table[:permitable_id].eq(obj.id).and(
      Accessible.arel_table[:permitable_type].eq(obj.class.model_name)))
   }
    
  def permissions
    return GlobalConstants::PERMISSIONS
  end

  def permission_human
    permissions.find { |d| d[1] == permission_level }.uniq[0]
  end

end
