class UserController < ApplicationController
    before_action :authenticate_user!

    def index
    end

    def edit
        @user = current_user
    end

    def update
        @user = current_user
        if @user.update(user_params)
        redirect_to root_path, notice: 'User details updated successfully.'
        else
        render :edit
        end
    end

    def destroy
    end

    private

    def user_params
        params.require(:user).permit(:first_name, :last_name, :address)
    end
end