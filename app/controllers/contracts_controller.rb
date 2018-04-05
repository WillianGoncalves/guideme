class ContractsController < ApplicationController
  before_action :set_contract, only: [:show, :update]

  def index; end

  def show
    unless current_user.is_guide_of?(@contract) or current_user.is_contractor_of?(@contract)
      flash[:danger] = I18n.t('messages.access_denied_to_contract')
      redirect_to root_path
    end
  end

  def new
    @guide = Guide.find(params[:guide_id])
    @contract = Contract.new
  end

  def create
    @guide = Guide.find(params[:guide_id])
    @contract = @guide.contracts.build(create_params)
    @contract.contractor = current_user
    if @contract.save
      @contract.under_analysis!
      flash[:success] = I18n.t('messages.contract_created')
      redirect_to contracts_path
    else
      render :new
    end
  end

  def update
    if update_params[:price].present?
      @contract.update(update_params)
      @contract.waiting_confirmation!
    elsif update_params[:status].present? and update_params[:status] == "rejected"
      @contract.rejected!
    end
    redirect_to contract_path(@contract)
  end

  private
  def create_params
    params.require(:contract).permit(:start_date, :end_date, :goals)
  end

  def update_params
    if params[:status].present?
      params.permit(:status)
    else
      params.require(:contract).permit(:price)
    end
  end

  def set_contract
    @contract = Contract.find(params[:id])
  end
end
