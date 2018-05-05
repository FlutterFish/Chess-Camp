class StudentsController < ApplicationController
  before_action :set_student, only: [:show, :edit, :update, :destroy]
  before_action :check_login
  authorize_resource
  
  def index
    #if current_user.role?(:admin)
      @students = Student.all.alphabetical.paginate(:page => params[:page]).per_page(12)
    #else
    #  @students = Student.taught_by(current_user.instructor.id).alphabetical.paginate(:page => params[:page]).per_page(12)
    #end
    
  end

  def show
  end

  def edit
    @family = Family.find(params[:family_id])
  end

  def new
    @student = Student.new
    @family = Family.find(params[:family_id])
  end

  def create
    @student = Student.new(student_params)
    if @student.save
      redirect_to student_path(@student), notice: "#{@student.first_name} #{@student.last_name} was added to the system."
    else
      @family = Family.find(params[:student][:family_id])
      render action: 'new', locals: { family: @family }
    end
  end

  def update
    if @student.update(student_params)
      redirect_to student_path(@student), notice: "#{@student.first_name} #{@student.last_name} was revised in the system."
    else
      @family = Family.find(params[:student][:family_id])
      render action: 'edit', locals: { family: @family }
    end
  end

  def destroy
    @family = @student.family
    @student.destroy
    if current_user.role?(:admin)
      redirect_to students_url, notice: "#{@student.first_name} #{@student.last_name} was deleted from the system."
    else
      redirect_to family_path(@family), notice: "#{@student.first_name} #{@student.last_name} was deleted from the system." 
    end
  end
  
  private
    def set_student
      @student = Student.find(params[:id])
    end

    def student_params
      params.require(:student).permit(:first_name, :last_name, :family_id, :date_of_birth, :rating, :active)
    end
end
