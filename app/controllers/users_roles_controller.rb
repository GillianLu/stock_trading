class UsersRolesController < ApplicationController
    load_and_authorize_resource :user

    def admins
      @users = User.admin
      render 'users/index'
    end
  
    def traders
      @users = User.trader
      render 'users/index'
    end
  
    def new_users
      @users = User.user
      render 'users/index'
    end
  
    def pending_traders
      @users = User.all.select do |user|
        !user.trader_approval? && user.confirmed? && user.first_name.present? && user.last_name.present? && user.address.present?
      end
      render 'users/index'
    end

    private

    def current_ability
      @current_ability ||= UserAbility.new(current_user)
  end
end