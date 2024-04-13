class UserAbility
    include CanCan::Ability

    def initializer(current_user)
        return unless current_user.present?

        cannot :show, User do |target_user|
            target_user.id != current_user.id # Non-admin users cannot view other user profiles
        end
        
        can :read, Stocks

        return unless current_user.trader

        can :read, User
        can :update, User, id: current_user.id
        can :manage, Stocks, user_id: current_user.id

        return unless current_user.admin?
        
        can :manage, User

    end
end