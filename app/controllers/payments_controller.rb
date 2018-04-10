class PaymentsController < ApplicationController
  before_action :set_contract, only: [:new, :create]
  def new
    @payment = Payment.new(comission: Payment::COMISSION)
  end
 
  def create
    payment = @contract.build_payment(payment_params)
    payment.comission = Payment::COMISSION
    if payment.save
      @contract.paid!
      redirect_to contract_path(@contract)
    else
      render :new
    end
  end

  private
  def payment_params
    params.require(:payment).permit(:payment_type)
  end

  def set_contract
    @contract = Contract.find(params[:contract_id])
  end
end
