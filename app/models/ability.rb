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
    can [:update,:edit,:destroy,:show,:index,:new,:create], :dyna_models, DynaModel do |dm|
      !user.nil? && ( !dm.only_owner_can_change || dm.owner_id == user.id )
    end
    
    # Params (for Dyna Models)
    can [:new,:create,:edit,:update,:destroy], :params, Param do |p|
      !user.nil? && ( !p.dyna_model.only_owner_can_change? || p.dyna_model.owner_id == user.id )
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
    
    can [:stats,:experiment_detail], :dyna_models
  end
end
