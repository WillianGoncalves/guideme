class GuidesController < ApplicationController
  before_action :set_guide, only: [:show, :edit, :update, :update_status]

  def index
    if params[:status].present?
      @title = I18n.t('guides.index.titles.awaiting_for_approval')
      @guides = Guide.where("status = ?", Guide.statuses[params[:status]])
    else
      @title = I18n.t('guides.index.titles.all')
      @guides = Guide.all
    end
  end

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
      @guide.awaiting_for_approval!
      redirect_to user_guide_path(current_user, @guide)
    else
      render :edit
    end
  end

  def update_status
    if @guide.update(update_status_params)
      flash[:success] = I18n.t('messages.guide_status_updated', status: @guide.display_status)
    end
    redirect_to guides_path
  end

  def search_by_location
    @guides = Location.near(params[:coordinates], params[:radius]).map(&:guide)
    respond_to do |format|
      format.js { render partial: "guides/result" }
    end
  end

  private
  def guide_params
    params.require(:guide).permit(:birthdate, :main_phone, :secondary_phone, :bio, academic_educations_attributes: [:id, :course, :institution, :finished_in, :level])
  end

  def update_status_params
    params.permit(:status)
  end

  def set_guide
    @guide = Guide.find(params[:id])
  end

  def require_admin
    unless current_user.admin?
      flash[:danger] = I18n.t('errors.admin_required')
      redirect_to root_path
    end
  end
end
