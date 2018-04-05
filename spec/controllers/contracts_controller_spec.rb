require 'rails_helper'

RSpec.describe ContractsController, type: :controller do
  context 'authenticated user' do
    let!(:user) { Fabricate :user }
    let!(:current_user_guide) { Fabricate :guide, user: user }
    let!(:contractor) { Fabricate :user }
    before { sign_in user }

    describe 'GET #index' do
      before { get :index }
      it { expect(response).to render_template :index }
    end

    describe 'GET #show' do
      context 'when user is part of the contract' do
        let!(:contract) { Fabricate :contract, guide: current_user_guide, contractor: contractor }
        before { get :show, params: { id: contract } }
        it { expect(response).to render_template :show }
        it { expect(assigns(:contract)).to eq contract }
      end

      context 'when use is not part of the contract' do
        let!(:another_guide) { Fabricate :guide }
        let!(:another_contract) { Fabricate :contract, guide: another_guide, contractor: contractor }
        before { get :show, params: { id: another_contract } }
        it { expect(flash[:danger]).to be_present }
        it { expect(response).to redirect_to root_path }
      end
    end

    describe 'GET #new' do
      let!(:guide) { Fabricate :guide }
      before { get :new, params: { guide_id: guide } }
      it { expect(response).to render_template :new }
      it { expect(assigns(:guide)).to eq guide }
      it { expect(assigns(:contract)).to be_a_new Contract }
    end

    describe 'POST #create' do
      let!(:guide) { Fabricate :guide }
      context 'with valid data' do
        let!(:contract) { Fabricate.build :contract }
        before { post :create, params: { guide_id: guide, contract: contract.attributes } }
        it { expect(response).to redirect_to contracts_path }
        it { expect(assigns(:contract).status).to eq "under_analysis" }
        it { expect(guide.contracts.count).to eq 1 }
        it { expect(user.contracts.count).to eq 1 }
      end

      context 'with invalid data' do
        let!(:invalid_contract) { Fabricate.build :invalid_contract }
        before { post :create, params: { guide_id: guide, contract: invalid_contract.attributes } }
        it { expect(response).to render_template :new }
        it { expect(guide.contracts.count).to eq 0 }
        it { expect(user.contracts.count).to eq 0 }
      end
    end

    describe 'PUT #update' do
      context 'when the current user is the guide' do
        let!(:contract) { Fabricate :contract, guide: current_user_guide, contractor: contractor }
        let(:data) { { price: 100 } }
        before { put :update, params: { id: contract, contract: data } }
        it { expect(response).to redirect_to contract_path(contract) }
        it { expect(contract.reload.price).to eq 100 }
        it { expect(contract.reload.status).to eq "waiting_confirmation" }
      end

      context 'when the current user is not the guide' do
        let!(:another_guide) { Fabricate :guide }
        let!(:contract) { Fabricate :contract, guide: another_guide, contractor: contractor }
        let(:data) { { price: 100 } }
        before { put :update, params: { id: contract, contract: data } }
        it { expect(response).to redirect_to root_path }
        it { expect(flash[:danger]).to be_present }
        it { expect(contract.reload.price).to be_nil }
        it { expect(contract.reload.status).to eq "under_analysis" }
      end
    end

    describe 'GET #reject' do
      context 'when the current user is the guide' do
        context 'and contract is under analysis' do
          let!(:contract) { Fabricate :contract, guide: current_user_guide, contractor: contractor, status: :under_analysis }
          before { get :reject, params: { id: contract } }
          it { expect(response).to redirect_to contract_path(contract) }
          it { expect(assigns(:contract).status).to eq "rejected" }
        end
        context 'and contract is not under analysis' do
          let!(:contract) { Fabricate :contract, guide: current_user_guide, contractor: contractor, status: :waiting_confirmation }
          before { get :reject, params: { id: contract } }
          it { expect(response).to redirect_to contracts_path }
          it { expect(assigns(:contract).status).to eq "waiting_confirmation" }
        end
      end

      context 'when the current user is not the guide' do
        let!(:guide) { Fabricate :guide }
        let!(:contract) { Fabricate :contract, guide: guide, contractor: contractor, status: :under_analysis }
        before { get :reject, params: { id: contract } }
        it { expect(response).to redirect_to root_path }
        it { expect(assigns(:contract).status).to eq "under_analysis" }
      end
    end
  end
end
