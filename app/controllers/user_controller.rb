class UserController < ApplicationController
    before_action :authenticate_user!

    # GET /user
    # only admin can access
    def index
        @users = User.all
    end

    # GET /user/1
    def show

    end

    # GET /user/new
    def new
    end
    
    # POST /user
    # only admin can access
    def create
    end

    # GET /user/1/edit
    def edit
        @user = current_user
    end

    # PATCH /user/1
    def update
        @user = current_user
        if @user.update(user_params)
        redirect_to root_path, notice: 'User details updated successfully.'
        else
        render :edit
        end
    end

    # DELETE /user/1
    def destroy
    end

    private

    def set_user
    end
    
    def user_params
        params.require(:user).permit(:first_name, :last_name, :address)
    end
end