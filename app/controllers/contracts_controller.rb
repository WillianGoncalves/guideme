class ContractsController < ApplicationController
  def new
    @guide = Guide.find(params[:guide_id])
  end

  def create
    guide = Guide.find(params[:guide_id])
    @contract = guide.contracts.build(create_params)
    @contract.user = current_user
    if @contract.save
      flash[:success] = I18n.t('messages.contract_created')
      redirect_to contracts_path(current_user)
    else
      render :new
    end
  end

  private
  def create_params
    params.require(:contract).permit(:start_date, :end_date, :goals)
  end
end
