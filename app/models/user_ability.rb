class UserAbility
  include CanCan::Ability

  def initialize(current_user)
    if current_user.present?
      if current_user.trader?
        trader(current_user)
      elsif current_user.admin?
        admin(current_user)
      else
        user(current_user)
      end
    else
      # Handle the case when there's no current user
    end
  end

  def user(current_user)
    #cannot :show, User do |target_user|
      #target_user.id != current_user.id # Non-admin users cannot view other user profiles
    #end
    can :show, User, id: current_user.id
    can :update, User, id: current_user.id
    cannot :index, UsersController
    cannot :manage, UsersRolesController
  end

  def trader(current_user)
    can :manage, User, id: current_user.id
    can :manage, Stock, user_id: current_user.id
    cannot :manage, UsersRolesController
  end

  def admin(current_user)
    can :manage, User
    can :manage, UsersRolesController
  end
end