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

class Model < ActiveRecord::Base
  has_many :experiments, :dependent => :destroy
  has_many :accessibles, :as => :permitable
  
  has_many :groups, through: :accessibles, as: :permitable

  accepts_nested_attributes_for :experiments
  
  has_many :permissions
  
  belongs_to :owner, :class_name => 'User'
   
  validates :title, :presence => {:message => 'Title cannot be blank'}
   
  # Fulltext support using sunspot
  #scope :search_is, lambda { |search| where(Model.arel_table[:id].in( search.hits.map(&:primary_key)) ) }
  scope :dyna_model_is, lambda { |dyna_model| 
    joins(:experiments => {:measurements => :proxy_dyna_models}).where(ProxyDynaModel.arel_table[:dyna_model_id].eq(dyna_model.id)).group(Model.arel_table[:id]).order(Model.arel_table[:id]) }
  
  scope :viewable, lambda { |user,only_mine=false| 
    if user.nil? then
      where( self.arel_table[:is_published].eq(true))
    else
      includes( Group.arel_table.name => Membership.arel_table.name ).where( 
          Model.arel_table[:owner_id].eq(user.id)
          .or( Model.arel_table[:is_published].eq(true).and(!only_mine) ) 
          .or( Membership.arel_table[:user_id].eq(user.id) )
          ).group( Model.arel_table[:id] )
    end
  }
  
  scope :published, lambda { |user=nil|
    if user.nil? || !user.admin then
      where( Model.arel_table[:is_published].eq( true ))
    end
  }
  
  has_paper_trail
  
  # Fulltext support using sunspot
  #searchable do
  #  text :title, :boost => 5
  #  text :description
  #end
  
  public
    def description_trimmed
      return "" if description.nil?
      if description.length > 97
        return description[0..97] + "..." 
      else
        return description
      end
    end
    
    def can_view(user=nil)
      is_published? || (!user.nil? && ( user.admin? || can?(user,GlobalConstants::PERMISSIONS[:read]) || can_edit(user) ) )
    end
    
    def can_edit(user=nil)
      user.present? && ( user.admin? || self.new_record? || (owner_id.present? && owner.id.equal?(user.id)) || can?(user,GlobalConstants::PERMISSIONS[:write]) )
    end
    
    def can?(user=nil,arg)
      return true if user.present? && user.admin?
      accessible = self.accessibles.find { |a| a.group.users.include?(user) }
       !accessible.nil? && !accessible.blank? && accessible.permission_level == arg
    end

end
