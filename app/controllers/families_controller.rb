class FamiliesController < ApplicationController
  before_action :set_family, only: [:show, :edit, :update, :destroy]

  def index
    @families = Family.all.alphabetical.paginate(:page => params[:page]).per_page(12)
  end

  def show
  end

  def edit
  end

  def new
    @family = Family.new
  end

  def create
    @user = User.new(user_params)
    if @user.save
      @family = Family.new(family_params)
      @family.user_id = @user.id
      if @family.save
        redirect_to family_path(@family), notice: "Family #{@family.family_name} was added to the system."
      else
        @user.destroy
        @family = Family.new
        render action: 'new'
      end
    else
      @family = Family.new
      render action: 'new'
    end
    
  end

  def update
    if @family.update(family_params)
      redirect_to family_path(@family), notice: "Family #{@family.family_name} was revised in the system."
    else
      render action: 'edit'
    end
  end

  def destroy
    user = @family.user
    @family.destroy
    user.destroy
    redirect_to families_url, notice: "#Family #{@family.family_name} was deleted from the system."
  end

  private
    def set_family
      @family = Family.find(params[:id])
    end

    def family_params
      params.require(:family).permit(:family_name, :parent_first_name, :user_id)
    end
    
    def user_params
      params.require(:family).permit(:username, :password, :password_confirmation, :email, :phone)
    end
end
