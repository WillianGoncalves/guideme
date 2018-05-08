class WelcomeController < ApplicationController
  skip_before_action :authenticate_user!, only: [:index]
  def index
    render :index, layout: 'blank' if !current_user
  end
end
