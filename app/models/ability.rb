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

class Ability
  include CanCan::Ability

  def initialize(user)
  
    # Model structure
    can :read, [:models,:experiments,:measurements,:lines,:proxy_dyna_models] do |obj|
      obj.can_view(user) # all classes have this method implemented
    end
    can [:update,:edit,:show,:new,:create,:destroy], [:models,:experiments,:measurements,:lines,:proxy_dyna_models] do |obj|
      obj.can_edit(user) # all classes have this method implemented
    end
    
    can [:summary], [:measurements] do |obj|
      obj.can_view(user) # all classes have this method implemented
    end
    
    can [:new], [:experiments,:measurements,:lines,:proxy_dyna_models] do |obj|
      obj.can_edit(user) # all classes have this method implemented
    end
    
    can :index, [:experiments,:measurements,:lines,:proxy_dyna_models]
    can [:new,:index],:models
    
    # Specific to ProxyDynaModel object
    can [:calculate] , :proxy_dyna_models do |obj|
      obj.can_edit(user) # all classes have this method implemented
    end

    # Specific to Measurement object
    can [:regression,:read], [:measurements] do |obj|
      obj.can_view(user) # all classes have this method implemented
    end
    can [:update_regression] , :measurements do |obj|
      obj.can_edit(user) # all classes have this method implemented
    end

    
    # Dyna Model
    can [:new,:create], :dyna_models, DynaModel do |dm|
      !user.nil?
    end
    
    can [:update,:edit,:destroy,:show,:index], :dyna_models, DynaModel do |dm|
      !user.nil? && ( !dm.only_owner_can_change || dm.owner_id == user.id )
    end
    
    # Params (for Dyna Models)
    can [:edit,:update,:destroy], :params, Param do |p|
      true
      #!user.nil? && ( !p.dyna_model.only_owner_can_change? || p.dyna_model.owner_id == user.id )
    end
    
    # Group
    can [:update,:edit,:show,:destroy], :groups, Group do |g|
      true #!user.nil? && g.can_access(user)
    end
   
    can [:new, :index,:create], :groups
    
    can [:new,:create,:destroy], :accessibles, Accessible do |acc|
      user.present? && acc.group.users.find{ |u| u.id == user.id}.present?
    end
    
    can [:destroy,:new,:create], :memberships, Membership do |memb|
      user.present? && memb.group.can_edit(user)
    end 

    # Any user can do
    can :read, :dyna_models
    can [:manage,:new_measurement], :all if user.present? && user.admin?
    
    can [:stats,:estimate,:calculate,:experiment_detail], :dyna_models do
      user.present?
    end
  end
end
