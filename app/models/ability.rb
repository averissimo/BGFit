class Ability
  include CanCan::Ability

  def initialize(user)

    # Model
    can :access, :models, Model do |model|
      unless user.nil?
        !Model.where(Model.arel_table[:id].eq( model.id )).viewable( user ).blank?
      else
        model.is_published?
      end
    end
    
    # Experiment
    can :access, :experiments, Experiment do |exp|
      unless user.nil?
        !Model.where(Model.arel_table[:id].eq( exp.model_id )).viewable( user ).blank?
      else
        exp.model.is_published?
      end
    end
    
    # Measurement
    can :access, :measurements, Measurement do |m|
      unless user.nil?
        !Model.where(Model.arel_table[:id].eq( m.experiment.model_id )).viewable( user ).blank?
      else
        m.experiment.model.is_published?
      end
    end
    
    # Line 
    can :access, :lines, Line do |l|
      unless user.nil?
        !Model.where(Model.arel_table[:id].eq( l.measurement.experiment.model_id )).viewable( user ).blank?
      else
        l.measurement.experiment.model.is_published?
      end
    end
    
    # Proxy Dyna Model
    can :access, :proxy_dyna_models, ProxyDynaModel do |pdm|
      unless user.nil?
        !Model.where(Model.arel_table[:id].eq( pdm.measurement.experiment.model_id )).viewable( user ).blank?
      else
        pdm.measurement.experiment.model.is_published?
      end
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
    can :new, :all, :except => :params
  end
end
