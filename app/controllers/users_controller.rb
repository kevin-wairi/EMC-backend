class UsersController < ApplicationController
    def add_to_cart
        user = User.find(params[:user_id])
        product = Product.find(params[:product_id])
        cart = Cart.new(user: user, product: product)
        if cart.save
          render json: cart, status: :created
        else
          render json: { errors: cart.errors.full_messages }, status: :unprocessable_entity
        end
    end
    
    def remove_from_cart
        cart = Cart.find_by(user_id: params[:user_id], product_id: params[:product_id])
        if cart
            cart.destroy
            head :no_content
        else
            render json: { error: "Cart item not found" }, status: :not_found
        end
    end
    
rescue_from ActiveRecord::RecordNotFound, with: :render_not_found_response
skip_before_action :authorized, only: [:create, :show]
 
# get /users
    # def index 
    #     users = User.all
    #     render json: users
    # end

    # get /users/:id - single user 

    def show 
        user = User.find_by(id: session[:user_id]) #had to chane method for this coz am using session not params
        # currentUser = user_find
        render json: user, status: 200
    end

    # post /users

    def create
        user = User.create!(user_params)
        session[:user_id] = user.id
        render json: user,status: :created
        rescue ActiveRecord::RecordInvalid => e
            render json: {errors: e.record.errors.full_messages},status: :unprocessable_entity
      end

    # update /users/:id
    def update
        user = user_find
        user.update(user_params)
        render json: user, status: 200
    end

    # delete /users/:id

    def destroy
        user = user_find
        user.destroy
        render json: {} , status: 204
    end

    private
    def user_find
        user = User.find(params[:id])
    end

    def user_params
        params.permit(:name, :email, :password, :password_confirmation , :profile_picture)
    end

    def render_not_found_response
        render json: {error: "User not found"}, status: 404
    end

    
end
