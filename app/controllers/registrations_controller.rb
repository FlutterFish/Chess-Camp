class RegistrationsController < ApplicationController
  before_action :set_registration, only: [:destroy]
  authorize_resource
  
  def index
    @ongoing_and_upcoming_registrations = Registration.ongoing_or_upcoming.paginate(:page => params[:page]).per_page(10)
    @pastregistrations = Registration.past.paginate(:page => params[:page]).per_page(10)
  end

  def destroy
    # camp_id = params[:id]
    # student_id = params[:student_id]
    # @registration = Registration.where(camp_id: camp_id, student_id: student_id).first
    # unless @registration.nil?
    #   @registration.destroy
    #   flash[:notice] = "Registraton was removed from the system."
    # end
    @registration.destroy
    redirect_to registrations_url, notice: "Registration was removed from the system."
  end
  
  private
    def set_registration
      @registration = Registration.find(params[:id])
    end
end
