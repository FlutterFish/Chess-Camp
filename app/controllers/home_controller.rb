class HomeController < ApplicationController
  def index
  end

  def about
  end

  def contact
  end

  def privacy
  end
  
  def dashboard
    check_can_dashboard
    if current_user.role?(:parent)
      @family = current_user.family
      @ongoing_registrations = @family.registrations.ongoing.paginate(:page => params[:page])
      @upcoming_registrations = @family.registrations.upcoming.paginate(:page => params[:page])
      @past_registrations = @family.registrations.past.paginate(:page => params[:page])
    end
  end
  
end