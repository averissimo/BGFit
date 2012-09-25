class Ability
  include CanCan::Ability

  def initialize(user)

    # Model
    can :read, :models, Model do |model|
      model.can_view(user)
    end
    can :access, :models, Model do |model|
      model.can_edit(user)
    end
    
    # Experiment
    can [:edit,:new,:update,:create], :experiments, Experiment do |exp|
      exp.can_edit(user)
    end
    can :read, :experiments, Experiment do |exp|
      exp.can_view(user)
    end
    
    # Measurement
    can [:edit,:new,:update,:create], :measurements, Measurement do |m|
      m.can_edit(user)
    end
    can :read, :measurements, Measurement do |m|
      m.can_view(user)
    end
    
    # Line 
    can [:edit,:new,:update,:create], :lines, Line do |l|
      l.can_edit(user)
    end
    can :read, :lines, Line do |l|
      l.can_view(user)
    end
    
    # Proxy Dyna Model
    can :access, :proxy_dyna_models, ProxyDynaModel do |pdm|
      pdm.can_edit(user)
    end
    can :read, :proxy_dyna_models, ProxyDynaModel do |pdm|
      pdm.can_view(user)
    end
    
    # Dyna Model
    can [:edit,:update,:destroy], :dyna_models, DynaModel do |dm|
      !user.nil? && ( !dm.only_owner_can_change || dm.owner_id == user.id )
    end
    
    # Params (for Dyna Models)
    can [:new,:create,:edit,:update,:destroy], :params, Param do |p|
      !user.nil? && ( !p.dyna_model.only_owner_can_change || p.dyna_model.owner_id == user.id )
    end
    
    # Group
    can :access, :groups, Group do |g|
      !user.nil? && g.can_access(user)
    end

    # Any user can do
    can :read, :dyna_models
  end
end
