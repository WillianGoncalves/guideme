class ContractsController < ApplicationController
  def new
    @guide = Guide.find(params[:guide_id])
  end
end
