class UsersController < ApplicationController
    before_action :set_user, only: [:show, :edit, :update, :destroy]
    load_and_authorize_resource
    
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
        @user = User.new
    end
    
    # POST /user
    # only admin can access

    def create
        @user = User.new(user_params)
    end

    # GET /user/1/edit
    def edit
    end

    # PATCH /user/1
    def update
        if @user.update(user_params)
            if @user.saved_change_to_role? # Check if role attribute has been changed
                if @user.admin?
                  AdminMailer.admin_role_email(@user).deliver_now
                elsif @user.trader?
                  AdminMailer.trader_approval_email(@user).deliver_now
                end
              end
            redirect_to user_path(@user), notice: 'User details updated successfully.'
        else
            render :edit
        end
    end

    # DELETE /user/1
    def destroy
        @user.destroy!
        
        respond_to do |format|
            format.html { redirect_to users_path, notice: "User was successfully destroyed"}
        end
    end

    private

    def set_user
        @user = User.find(params[:id])
    end
    
    def user_params
        params.require(:user).permit(:first_name, :last_name, :address, :balance, :role)
    end

    def current_ability
        @current_ability ||= UserAbility.new(current_user)
    end
end