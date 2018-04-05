class ContractsController < ApplicationController
  before_action :set_contract, only: [:show, :update, :reject, :cancel]
  before_action :set_guide, only: [:new, :create]
  before_action :require_guide_or_contractor, only: [:show]
  before_action :require_guide, only: [:update, :reject]
  before_action :require_contractor, only: [:cancel]

  def index; end

  def show; end

  def new
    @contract = Contract.new
  end

  def create
    @contract = @guide.contracts.build(create_params)
    @contract.contractor = current_user
    if @contract.save
      @contract.under_analysis!
      flash[:success] = I18n.t('messages.contract.created')
      redirect_to contracts_path
    else
      render :new
    end
  end

  def update
    @contract.update(update_params)
    @contract.waiting_confirmation!
    redirect_to contract_path(@contract)
  end

  def reject
    if @contract.under_analysis?
      @contract.rejected!
      redirect_to contract_path(@contract)
    else
      redirect_to contracts_path
    end
  end

  def cancel
    if @contract.waiting_confirmation?
      @contract.canceled!
      redirect_to contract_path(@contract)
    else
      redirect_to contracts_path
    end
  end

  private
  def create_params
    params.require(:contract).permit(:start_date, :end_date, :goals)
  end

  def update_params
    params.require(:contract).permit(:price)
  end

  def set_contract
    @contract = Contract.find(params[:id])
  end

  def set_guide
    @guide = Guide.find(params[:guide_id])
  end

  def require_guide
    unless current_user.is_guide_of?(@contract)
      flash[:danger] = I18n.t('messages.contract.guide_required')
      redirect_to root_path
    end
  end

  def require_guide_or_contractor
    unless current_user.is_guide_of?(@contract) or current_user.is_contractor_of?(@contract)
      flash[:danger] = I18n.t('messages.contract.guide_or_contractor_required')
      redirect_to root_path
    end
  end

  def require_contractor
    unless current_user.is_contractor_of?(@contract)
      flash[:danger] = I18n.t('messages.contract.contractor_required')
      redirect_to root_path
    end
  end
end
