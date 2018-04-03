class ContractsController < ApplicationController
  def index
    @contracts = current_user.contracts
  end

  def new
    @guide = Guide.find(params[:guide_id])
    @contract = Contract.new
  end

  def create
    guide = Guide.find(params[:guide_id])
    @contract = guide.contracts.build(create_params)
    @contract.contractor = current_user
    if @contract.save
      flash[:success] = I18n.t('messages.contract_created')
      redirect_to contracts_path
    else
      render :new
    end
  end

  private
  def create_params
    params.require(:contract).permit(:start_date, :end_date, :goals)
  end
end
