class Users::UsersController < ApplicationController
    load_and_authorize_resource

    def index
        @users = User.all
        render json: { users: @users }, status: 200
    end

    def show
        @user = User.find(params[:id])
        check_user_plan_expiry
        render json: { user: @user}, status: 200
    end

    def edit
        @user = User.find(params[:id])
        render json:@users
    end
    
    def update
        @user = User.find(params[:id])
    
        if @user.update(user_params)
            render json: {message: 'User Updated Successfully', user: @user}, status: 200
        else
            render json: { message: @user.error.message },status: 406
        end
    end
            
    def destroy
        @user = User.find(params[:id])
        if @user.active_plan
            active_plan = ActivePlan.find_by(user_id: @user.id)
            active_plan.destroy
        end
        @user.destroy
        render json: { message: 'User Deleted Successfully'},status: 200
    end

    private
    
    def user_params
        params.require(:user).permit(:name, :email, :age, :weight, :role)
    end

end