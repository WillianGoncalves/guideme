require 'rails_helper'

RSpec.describe ContractsController, type: :controller do
  context 'authenticated user' do
    let!(:user) { Fabricate :user }

    before(:each) do
      another_user = Fabricate :user
      location = Fabricate.build :location
      @guide = Fabricate :guide, status: :approved, user: another_user, location: location
    end

    before { sign_in user }

    describe 'GET #new' do
      before { get :new, params: { guide_id: @guide } }
      it { expect(response).to render_template :new }
      it { expect(assigns(:guide)).to eq @guide }
    end
  end
end
