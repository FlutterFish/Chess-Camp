class SessionsController < ApplicationController
  include AppHelpers::Cart
  def new
  end
  
  
  def create
    user = User.authenticate(params[:username], params[:password])
    if user
      session[:user_id] = user.id
      if user.role?(:admin)
        create_cart
        redirect_to home_path, notice: "Logged in!"
      elsif user.role?(:instructor)
        redirect_to instructor_path(user.instructor), notice: "Logged in!"
      elsif user.role?(:parent)
        create_cart
        redirect_to family_path(user.family), notice: "Logged in!"
      end
      
    else
      flash.now.alert = "Username and/or password is invalid"
      render "new"
    end
  end
  
  def destroy
    session[:user_id] = nil
    destroy_cart
    redirect_to home_path, notice: "Logged out!"
  end
end