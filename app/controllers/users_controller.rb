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
        @user.password = params[:password]
        @user.skip_confirmation!
        @user.trader_approval = true

        respond_to do |format|
            if @user.save
                format
                #send email to welcome them add the features they can do like if they are admin or trader
            else 
                format.html { render :new, status: :unprocessable_entity }
            end
        end
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
        params.require(:user).permit(:first_name, :last_name, :address, :balance)
    end

    def current_ability
        @current_ability ||= UserAbility.new(current_user)
    end
end