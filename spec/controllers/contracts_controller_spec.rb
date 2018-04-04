require 'rails_helper'

RSpec.describe ContractsController, type: :controller do
  context 'authenticated user' do
    let!(:user) { Fabricate :user }
    before { sign_in user }

    before(:each) do
      another_user = Fabricate :user
      location = Fabricate.build :location
      @guide = Fabricate :guide, status: :approved, user: another_user, location: location
    end

    describe 'GET #index' do
      let!(:contract) { Fabricate :contract, guide: @guide, contractor: user }
      before { get :index }
      it { expect(response).to render_template :index }
    end

    describe 'GET #new' do
      before { get :new, params: { guide_id: @guide } }
      it { expect(response).to render_template :new }
      it { expect(assigns(:guide)).to eq @guide }
      it { expect(assigns(:contract)).to be_a_new Contract }
    end

    describe 'POST #create' do
      context 'with valid data' do
        let!(:contract) { Fabricate.build :contract }
        before { post :create, params: { guide_id: @guide, contract: contract.attributes } }
        it { expect(response).to redirect_to contracts_path }
        it { expect(assigns(:contract).status).to eq "under_analysis" }
        it { expect(@guide.contracts.count).to eq 1 }
        it { expect(user.contracts.count).to eq 1 }
      end

      context 'with invalid data' do
        let!(:invalid_contract) { Fabricate.build :invalid_contract }
        before { post :create, params: { guide_id: @guide, contract: invalid_contract.attributes } }
        it { expect(response).to render_template :new }
        it { expect(@guide.contracts.count).to eq 0 }
        it { expect(user.contracts.count).to eq 0 }
      end
    end
  end
end
