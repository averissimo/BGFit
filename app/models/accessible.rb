# BGFit - Bacterial Growth Curve Fitting
# Copyright (C) 2012-2012  André Veríssimo
#
# This program is free software; you can redistribute it and/or
# modify it under the terms of the GNU General Public License
# as published by the Free Software Foundation; version 2
# of the License.
#
# This program is distributed in the hope that it will be useful,
# but WITHOUT ANY WARRANTY; without even the implied warranty of
# MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
# GNU General Public License for more details.
#
# You should have received a copy of the GNU General Public License
# along with this program; if not, write to the Free Software
# Foundation, Inc., 51 Franklin Street, Fifth Floor, Boston, MA  02110-1301, USA.

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
