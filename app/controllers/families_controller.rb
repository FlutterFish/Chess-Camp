class FamiliesController < ApplicationController
  before_action :set_family, only: [:show, :edit, :update, :destroy]
  before_action :check_login, only: [:index, :show, :edit, :update, :destroy]
  authorize_resource

  def index
    @families = Family.all.alphabetical.paginate(:page => params[:page]).per_page(12)
  end

  def show
    @students = @family.students.alphabetical
  end

  def edit
  end

  def new
    @family = Family.new
  end

  def create
    @family = Family.new(family_params)
    @user = User.new(user_params)
    @user.role = "parent"
    if !@user.save
      @family.valid?
      render action: 'new'
    else
      @family.user_id = @user.id
      if @family.save
        flash[:notice] = "Family #{@family.family_name} was added to the system."
        if current_user.nil?
          redirect_to login_path
        elsif current_user.role?(:admin)
          redirect_to family_path(@family) 
        else
          redirect_to login_path
        end
      else
        render action: 'new'
      end  
    end
    
  end

  def update
    respond_to do |format|
      if current_user.role?(:admin)
        if @family.update_attributes(family_params) && @family.user.update_attributes(user_params)
          format.html { redirect_to(@family, :notice => "Family #{@family.family_name} was revised in the system.") }
          format.json { respond_with_bip(@family) }
        else
          format.html { render :action => "edit" }
          format.json { respond_with_bip(@family) }
        end
      else
        if @family.user.update_attributes(user_params)
          format.html { redirect_to(@family, :notice => "Family #{@family.family_name} was revised in the system.") }
          format.json { respond_with_bip(@family) }
        else
          format.html { render :action => "edit" }
          format.json { respond_with_bip(@family) }
        end
      end
      
    end
  end

  def destroy
    #family can never be destroyed
  end

  private
    def set_family
      @family = Family.find(params[:id])
    end

    def family_params
      params.require(:family).permit(:family_name, :parent_first_name, :user_id, :active)
    end
    
    def user_params
      if logged_in? && current_user.role?(:admin)
        params.require(:family).permit(:username, :password, :password_confirmation, :email, :phone, :active)
      elsif logged_in? && current_user.role?(:parent)
        params.require(:family).permit(:phone, :email, :password, :password_confirmation)
      else
        params.require(:family).permit(:username, :password, :password_confirmation, :email, :phone)
      end
    end
end
