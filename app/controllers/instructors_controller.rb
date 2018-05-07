class InstructorsController < ApplicationController
  before_action :set_instructor, only: [:show, :edit, :update, :destroy]
  authorize_resource
  
  def index
    @instructors = Instructor.all.alphabetical.paginate(:page => params[:page]).per_page(12)
  end

  def show
    @past_camps = @instructor.camps.past.chronological
    @upcoming_camps = @instructor.camps.upcoming.chronological
  end

  def edit
  end

  def new
    @instructor = Instructor.new
  end

  def create
    @instructor = Instructor.new(instructor_params)
    @user = User.new(user_params)
    @user.role = "instructor"
    if !@user.save
      @instructor.valid?
      render action: 'new'
    else
      @instructor.user_id = @user.id
      if @instructor.save
        flash[:notice] = "Instructor #{@instructor.name} was added to the system."
        redirect_to instructor_path(@instructor) 
      else
        render action: 'new'
      end  
    end
  end

  def update
    respond_to do |format|
      if @instructor.update_attributes(instructor_params) && @instructor.user.update_attributes(user_params)
        format.html { redirect_to(@instructor, :notice => "Instructor #{@instructor.name} was revised in the system.") }
        format.json { respond_with_bip(@instructor) }
      else
        format.html { render :action => "edit" }
        format.json { respond_with_bip(@instructor) }
      end
    end
  end

  def destroy
    @instructor.destroy
    redirect_to instructors_url, notice: "#{@instructor.first_name} #{@instructor.last_name} was deleted from the system."
  end

  private
    def set_instructor
      @instructor = Instructor.find(params[:id])
    end

    def instructor_params
      if current_user.role?(:admin)
        params.require(:instructor).permit(:first_name, :last_name, :bio, :picture, :active)
      else
        params.require(:instructor).permit(:bio, :picture)
      end
    end
    
    def user_params
      if current_user.role?(:admin)
        params.require(:instructor).permit(:username, :password, :password_confirmation, :email, :phone, :active)
      else
        params.require(:instructor).permit(:phone, :email, :password, :password_confirmation)
      end
    end
end