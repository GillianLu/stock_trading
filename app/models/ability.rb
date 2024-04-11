class Ability
    include CanCan::Ability

    def initializer(current_user)
        return unless current_user.present?
        
        return unless current_user.trader

        can :read, User
        can :update, User, id: current_user.id

        return unless current_user.admin?
        
        can :manage, User
    end
end