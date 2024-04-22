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
    can :show, User, id: current_user.id
    can :update, User, id: current_user.id

    cannot :index, UsersController
    cannot :manage, UsersRolesController
    cannot :manage, TransactionsController
  end

  def trader(current_user)
    can :manage, User, id: current_user.id
    #can :manage, Stock, index_stocks_on_user_id: current_user.id
    # can :manage, Transaction, index_transactions_on_user_id: current_user.id
    can :manage, Transaction, user_id: current_user.id


    cannot :manage, UsersRolesController
    cannot :index, UsersController
  end



  def admin(current_user)
    can :manage, User
    can :manage, UsersRolesController
    can :manage, Transaction
  end
end
