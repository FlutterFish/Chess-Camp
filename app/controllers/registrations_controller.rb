class RegistrationsController < ApplicationController
  authorize_resource
  
  def new
    @registration = Registration.new
    @camp = Camp.find(params[:camp_id])
    @other_students = @camp.students
  end

  def create
    @registration = Registration.new(registration_params)
    if @registration.save
      flash[:notice] = "Registration was added to the system."
      redirect_to camp_path(@registration.camp)
    else
      @camp = Camp.find(params[:registration][:camp_id])
      @other_students = @camp.students
      render action: 'new', locals: { camp: @camp, other_students: @other_students }
    end
  end

  def destroy
    camp_id = params[:id]
    student_id = params[:student_id]
    @registration = Registration.where(camp_id: camp_id, student_id: student_id).first
    unless @registration.nil?
      @registration.destroy
      flash[:notice] = "Registraton was removed from the system."
    end
  end
  
  private
    def registration_params
      params.require(:registration).permit(:camp_id, :student_id, :payment)
    end
  
end
