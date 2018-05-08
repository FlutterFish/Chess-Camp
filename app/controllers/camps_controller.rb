class CampsController < ApplicationController
  before_action :set_camp, only: [:show, :edit, :update, :destroy, :instructors]
  authorize_resource

  def index
    @active_camps = Camp.all.active.alphabetical.paginate(:page => params[:active_camps]).per_page(10)
    @inactive_camps = Camp.all.inactive.alphabetical.paginate(:page => params[:inactive_camps]).per_page(1)
  end

  def show
    @instructors = @camp.instructors.alphabetical
    @students = @camp.students.alphabetical
    if current_user.role?(:parent) || current_user.role?(:admin)
      @family = current_user.family
      max_rating = @camp.curriculum.max_rating
      min_rating = @camp.curriculum.min_rating
      students_busy_at_this_time = []
      for c in Camp.at_time(@camp.start_date, @camp.time_slot)
        students_busy_at_this_time += c.students
      end
      #adding students in the cart with conflicting schedule 
      #to students_busy_at_this_time
      unless (session[:cart].nil? || session[:cart].empty?)
        session[:cart].each do |ci|
          ciCampId = ci["ids"][0].to_i
          ciStudentId = ci["ids"][1].to_i
          if (Camp.at_time(@camp.start_date, @camp.time_slot).map{|c1| c1.id}.include?(ciCampId))
            ciStudent = Student.where(id: ciStudentId)
            students_busy_at_this_time += ciStudent
          end
          
        end
      end
      if current_user.role?(:parent)
        @qualified_students = @family.students.active.below_rating(max_rating + 1).at_or_above_rating(min_rating).alphabetical
      else
        @qualified_students = Student.active.below_rating(max_rating + 1).at_or_above_rating(min_rating).alphabetical
      end
      @eligilble_students = @qualified_students.select{|s| !@students.include?(s)} - students_busy_at_this_time
    end
  end

  def edit
  end

  def new
    @camp = Camp.new
  end

  def create
    @camp = Camp.new(camp_params)
    if @camp.save
      redirect_to camp_path(@camp), notice: "#{@camp.name} was added to the system."
    else
      render action: 'new'
    end
  end

  def update
    @camp.update(camp_params)
    if @camp.save
      redirect_to camp_path(@camp), notice: "#{@camp.name} was revised in the system."
    else
      render action: 'edit'
    end
  end

  def destroy
    @camp.destroy
    redirect_to camps_url, notice: "#{@camp.name} was removed from the system."
  end

  def instructors
    @instructors = Instructor.for_camp(@camp).alphabetical
  end
  
  #def students
  #  @students = Student.
  #end

  private
    def set_camp
      @camp = Camp.find(params[:id])
    end

    def camp_params
      params.require(:camp).permit(:curriculum_id, :location_id, :cost, :start_date, :end_date, :time_slot, :max_students, :active)
    end
end