class SessionsController < ApplicationController
    def create
        # byebug 
        @user = User.find_by(email: params[:user][:email])
        if @user && @user.authenticate(params[:user][:password])
            render json: @user
        else
            render json:{
                error: "Invalid credentials"
            }, status: :unauthorized
        end
    end

    def destroy
    end
end