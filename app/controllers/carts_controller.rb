class CartsController < ApplicationController
  include AppHelpers::Cart
  
  def index
  end
  
  def checkout_summary
    @registration = Registration.new
  end
  
  def checkout
    error = false
    session[:cart].each do |ci|
      @registration = Registration.new(registration_params)
      @registration.expiration_year = @registration.expiration_year.to_i
      @registration.expiration_month = @registration.expiration_month.to_i
      @registration.camp_id = ci["ids"][0]
      @registration.student_id = ci["ids"][1]
      if @registration.save
        
      else
        error = true
      end
    end
    if (error)
      redirect_to checkout_summary_path, notice: "Credit card information is invalid."
    else
      clear_cart
      if current_user.role?(:parent)
        redirect_to family_path(current_user.family), notice: "Your payment was successful."
      else
        redirect_to camps_path, notice: "Registration(s) created."
      end
    end
  end
  
  def clear
    clear_cart
    redirect_to carts_path
  end

  def add_to_cart
    camp_id = params[:registration][:camp_id]
    student_id = params[:registration][:student_id]
    add_registration_to_cart(camp_id, student_id)
    @camp = Camp.find(camp_id)
    flash[:notice] = "Added #{@camp.name} to the cart."
    redirect_to @camp
  end
  
  def remove_from_cart
    camp_id = params[:camp_id]
    student_id = params[:student_id]
    remove_registration_from_cart(camp_id, student_id)
    @camp = Camp.find(camp_id)
    flash[:notice] = "Removed #{@camp.name} from the cart."
    redirect_to carts_path
  end
  
  private
    def registration_params
      params.require(:registration).permit(:camp_id, :student_id, :credit_card_number, :expiration_year, :expiration_month, :payment)
    end
end
