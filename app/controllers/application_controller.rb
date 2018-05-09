class ApplicationController < ActionController::Base
  protect_from_forgery with: :exception
  helper AppHelpers::Cart
  
  # just show a flash message instead of full CanCan exception
  rescue_from CanCan::AccessDenied do |exception|
    flash[:error] = "Sorry, but you are unauthorized to access this page."
    redirect_to home_path
  end

  # handle 404 errors with an exception as well
  rescue_from ActiveRecord::RecordNotFound do |exception|
    flash[:error] = "Sorry, but the page you requested is not found."
    redirect_to home_path
  end
  
  private
  # Handling authentication
  def current_user
    @current_user ||= User.find(session[:user_id]) if session[:user_id]
  end
  helper_method :current_user
  
  def logged_in?
    current_user
  end
  helper_method :logged_in?
  
  def check_login
    redirect_to login_path, alert: "You need to log in to view this page." if current_user.nil?
  end
  
  def check_can_dashboard
    unless logged_in? && (current_user.role?(:admin) || current_user.role?(:parent))
      redirect_to login_path, alert: "You need to log in to view this page."
    end
  end
  
  def display_date(date)
    date.strftime("%b %d, %Y")
  end
  helper_method :display_date
end
