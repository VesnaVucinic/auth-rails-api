class SessionsController < ApplicationController
    def create
        # byebug 
        @user = User.find_by(email: params[:user][:email])
        if @user && @user.authenticate(params[:user][:password])
            # if user is authenticated :
            # generete token
            # include token it the responseback to the client 
            # include the user in the response
            token = generate_token({id: @user.id})
            resp={
                user: user_serializer(@user),
                jwt: token
            }
            render json: resp
        else
            resp ={
                error: "Invalid credentials",
                details: @user.errors.full_messages
            }
            render json: resp, status: :unauthorized 
        end
    end


    def get_current_user
        if logged_in?
          render json: {
              user: user_serializer(current_user)
            }, status: :ok
        else
          render json: {error: "No current user"}
        end
    end

    def destroy
    end
end

# Rails flow:
# User login -> credentials -> authenticated -> session stores a unique ID->
# store the session in cookies including unique ID -> then with request for authorization Rail just looks and says 
# "is session holding an ID " if so "is it a right one"

# 1. Login
# -use bcrypt and 'AR#authenticate'  to authenticate the user
# 2. Use JWT to generate token 
# 3. Sent that token to the client
# 4. Store that token in localStorage on the client side
# 5. Include the token in subsequent request from the client back to the server
# 6. To log out we will simply clear the localStorage and reset any state around current_user 
