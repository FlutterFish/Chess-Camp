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
      @ongoing_registrations = @family.registrations.ongoing.chronological.alphabetical.paginate(:page => params[:page])
      @upcoming_registrations = @family.registrations.upcoming.chronological.alphabetical.paginate(:page => params[:page])
      @past_registrations = @family.registrations.past.chronological.alphabetical.paginate(:page => params[:page])
    end
  end
  
end