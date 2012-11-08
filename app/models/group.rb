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
