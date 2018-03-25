class GuidesController < ApplicationController
  before_action :set_guide, only: [:show, :edit, :update]

  def show
  end

  def new
    @guide = current_user.build_guide
  end

  def edit
  end

  def create
    @guide = current_user.build_guide(guide_params)
    if @guide.save
      redirect_to user_guide_path(current_user, @guide)
    else
      render :new
    end
  end

  def update
    if @guide.update(guide_params)
      redirect_to user_guide_path(current_user, @guide)
    else
      render :edit
    end
  end

  private
  def guide_params
    params.require(:guide).permit(:birthdate, :main_phone, :secondary_phone, :bio, academic_educations_attributes: [:id, :course, :institution, :finished_in, :status])
  end

  def set_guide
    @guide = Guide.find(params[:id])
  end
end
