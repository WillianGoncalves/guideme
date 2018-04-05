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

    describe 'GET #show' do
      context 'when use is part of the contract' do
        let!(:contract) { Fabricate :contract, guide: @guide, contractor: user }
        before { get :show, params: { id: contract } }
        it { expect(response).to render_template :show }
        it { expect(assigns(:contract)).to eq contract }
      end

      context 'when use is not part of the contract' do
        let!(:another_user) { Fabricate :user }
        let!(:another_contract) { Fabricate :contract, guide: @guide, start_date: 5.days.from_now, end_date: 6.days.from_now, contractor: another_user }
        before { get :show, params: { id: another_contract } }
        it { expect(response).to redirect_to root_path }
      end
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

    describe 'PUT #update' do
      let!(:contract) { Fabricate :contract, guide: @guide, contractor: user }

      context 'when the guide accepts the contract' do
        let(:data) { { price: 100 } }
        before { put :update, params: { id: contract, contract: data } }
        it { expect(response).to redirect_to contract_path(contract) }
        it { expect(contract.reload.price).to eq 100 }
        it { expect(contract.reload.status).to eq "waiting_confirmation" }
      end

      context 'when the guide rejects the contract' do
        before { put :update, params: { id: contract, status: "rejected" } }
        it { expect(response).to redirect_to contract_path(contract) }
        it { expect(contract.reload.status).to eq "rejected" }
      end
    end
  end
end
