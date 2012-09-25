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
          !Model.where(Model.arel_table[:id].eq( exp.model.id )).viewable( user ).blank?
        else
          exp.model.is_published?
        end
      end
      
      # Measurement
      can :access, :measurements, Measurement do |m|
        unless user.nil?
          !Model.where(Model.arel_table[:id].eq( m.experiment.model.id )).viewable( user ).blank?
        else
          m.experiment.model.is_published?
        end
      end
      
      # 
      can :access, :lines, Line do |l|
        unless user.nil?
          !Model.where(Model.arel_table[:id].eq( model.id )).viewable( user ).blank?
        else
          l.measurement.experiment.model.is_published?
        end
      end
      
      can :access, :groups, Group do |g|
        
      end

      can :new, :lines # has to be next to :access authorization
      can :new, :models # has to be next to :access authorization
      can :new, :experiments # has to be next to :access authorization
      can :new, :measurements # has to be next to :access authorization
    end
      #can :show, Model do |model|
      #  true
      #  #model.is_published || model.owner == user.id
      #end

    # Define abilities for the passed in (current) user. For example:
    #
    #   if user
    #     can :access, :all
    #   else
    #     can :access, :home
    #     can :create, [:users, :sessions]
    #   end
    #
    # Here if there is a user he will be able to perform any action on any controller.
    # If someone is not logged in he can only access the home, users, and sessions controllers.
    #
    # The first argument to `can` is the action the user can perform. The second argument
    # is the controller name they can perform that action on. You can pass :access and :all
    # to represent any action and controller respectively. Passing an array to either of
    # these will grant permission on each item in the array.
    #
    # See the wiki for details: https://github.com/ryanb/cancan/wiki/Defining-Abilities
end
