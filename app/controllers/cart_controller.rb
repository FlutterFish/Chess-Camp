class CartController < ApplicationController
  include AppHelpers::Cart

  def addToCart
    #byebug
    add_registration_to_cart(params[:registration][:camp_id], params[:registration][:student_id])
  end
end
