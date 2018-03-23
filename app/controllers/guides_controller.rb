class GuidesController < ApplicationController
  before_action :set_guide, only: [:show]

  def show
  end

  def new
    @guide = Guide.new
  end

  def create
    @guide = Guide.new(guide_params)
    @guide.user = current_user
    if @guide.save
      redirect_to user_guide_path(current_user, @guide)
    else
      render :new
    end
  end

  private
  def guide_params
    params.require(:guide).permit(:birthdate, :main_phone, :secondary_phone, :bio)
  end

  def set_guide
    @guide = Guide.find(params[:id])
  end
end
