require 'will_paginate/array'

class ContractsController < ApplicationController
  before_action :set_contract, only: [:show, :update, :reject, :cancel, :finish]
  before_action :set_guide, only: [:new, :create]
  before_action :require_guide_or_contractor, only: [:show]
  before_action :require_guide, only: [:update, :reject, :finish]
  before_action :require_contractor, only: [:cancel]

  def index
    @statuses = params[:statuses] || []
    @start_date = search_params[:start_date]
    @end_date = search_params[:end_date]

    @contracts = current_user.contracts_as_contractor
    @contracts += current_user.contracts_as_guide if current_user.guide.present?

    #filter by status
    @contracts = @contracts.where(status: @statuses) unless @statuses.blank?

    #filter by date
    @contracts = @contracts.where('start_date >= ?', @start_date) if @start_date.present?
    @contracts = @contracts.where('end_date <= ?', @end_date) if @end_date.present?

    #paginate
    @contracts = @contracts.paginate(page: params[:page], per_page: 5)
  end

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

  def finish
    if @contract.end_date > DateTime.now
      flash[:danger] = I18n.t('messages.contract.finish.invalid_date')
      return redirect_to contracts_path
    elsif !@contract.paid?
      flash[:danger] = I18n.t('messages.contract.finish.invalid_status')
      return redirect_to contracts_path
    else
      @contract.finished!
      redirect_to contract_path(@contract)
    end
  end

  private
  def search_params
    params.permit(:start_date, :end_date, statuses: [])
  end

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
