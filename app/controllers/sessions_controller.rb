class SessionsController < ApplicationController
  CartItem = Struct.new(:camp_name, :student_name, :date, :cost, :ids)
  
  def new
  end
  
  
  def create
    user = User.authenticate(params[:username], params[:password])
    if user
      session[:user_id] = user.id
      redirect_to home_path, notice: "Logged in!"
      session[:cart] ||= Array.new
    else
      flash.now.alert = "Username and/or password is invalid"
      render "new"
    end
  end
  
  def addToCart
    camp_id = params[:camp_id]
    student_id = params[:student_id]
    # only add the registration if not already in the cart
      unless session[:cart].map{|ci| ci.ids}.include? [camp_id, student_id]
        # if not, create a cart item for easy display later
        camp = Camp.find(camp_id)
        camp_name = camp.name
        student_name = Student.find(student_id).first_name
        date = camp.start_date
        cost = camp.cost
        ids = [camp_id, student_id]
        ci = CartItem.new(camp_name, student_name, date, cost, ids)
        session[:cart].push(ci)
      end
  end
  
  def destroy
    session[:user_id] = nil
    session[:cart] = nil
    redirect_to home_path, notice: "Logged out!"
  end
  
  def cart 
    @reg_ids = nil
    unless session[:cart].nil? || session[:cart].empty?
      @reg_ids = session[:cart].map{|ci| ci.ids}
    end
  end
end