class UsersRolesController < ApplicationController
    def admins
      @admins = User.admin
    end
  
    def traders
      @traders = User.trader
    end
  
    def new_users
      @new_users = User.user
    end
  
    def pending_traders
      @pending_traders = User.all.select do |user|
        !user.trader_approval? && user.confirmed? && user.first_name.present? && user.last_name.present? && user.address.present?
      end
    end

    private

    def current_ability
      @current_ability ||= UserAbility.new(current_user)
  end
end