class CartsController < ApplicationController
  include AppHelpers::Cart
  
  def index
    @items = get_array_of_ids_for_generating_registrations
    @total_cost = calculate_total_cart_registration_cost
  end
  
  def show
    @items = get_array_of_ids_for_generating_registrations
  end
  
  def destroy
    camp_id = params[:registration][:camp_id]
    student_id = params[:registration][:student_id]
    remove_registration_from_cart(camp_id, student_id)
  end

  def add_to_cart
    camp_id = params[:registration][:camp_id]
    student_id = params[:registration][:student_id]
    add_registration_to_cart(camp_id, student_id)
    @camp = Camp.find(camp_id)
    flash[:notice] = "Added #{@camp.name} to the cart."
    redirect_to @camp
  end
end
