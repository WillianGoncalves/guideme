require 'rails_helper'

RSpec.describe ContractsController, type: :controller do
  context 'authenticated user' do
    let!(:user) { Fabricate :user }
    let!(:current_user_guide) { Fabricate :guide, user: user }
    before { sign_in user }

    describe 'GET #index' do
      let!(:under_analysis_contract) { Fabricate :contract, guide: current_user_guide, start_date: 1.day.from_now, end_date: 2.days.from_now, status: :under_analysis }
      let!(:rejected_contract) { Fabricate :contract, guide: current_user_guide, start_date: 3.days.from_now, end_date: 4.days.from_now, status: :rejected }
      let!(:waiting_confirmation_contract) { Fabricate :contract, guide: current_user_guide, start_date: 5.days.from_now, end_date: 6.days.from_now, status: :waiting_confirmation }
      let!(:canceled_contract) { Fabricate :contract, guide: current_user_guide, start_date: 7.days.from_now, end_date: 8.days.from_now, status: :canceled }
      let!(:waiting_payment_contract) { Fabricate :contract, guide: current_user_guide, start_date: 9.days.from_now, end_date: 10.days.from_now, status: :waiting_payment }

      context 'without search params' do
        before { get :index }
        it { expect(response).to render_template :index }
        it { expect(assigns(:contracts)).to match_array [ under_analysis_contract, rejected_contract, waiting_confirmation_contract, canceled_contract, waiting_payment_contract ] }
      end

      context 'filtering by status' do
        before { get :index, params: { statuses: 'under_analysis' } }
        it { expect(response).to render_template :index }
        it { expect(assigns(:contracts)).to match_array [ under_analysis_contract ] }
      end

      context 'filtering by an nonexistent status' do
        before { get :index, params: { statuses: 'finished' } }
        it { expect(response).to render_template :index }
        it { expect(assigns(:contracts)).to be_empty }
      end

      context 'filtering by date' do
        context 'with start and end dates' do
          before { get :index, params: { start_date: 7.days.from_now, end_date: 11.days.from_now } }
          it { expect(response).to render_template :index }
          it { expect(assigns(:contracts)).to match_array [ canceled_contract, waiting_payment_contract ] }
        end

        context 'with only start date' do
          before { get :index, params: { start_date: 3.days.from_now } }
          it { expect(response).to render_template :index }
          it { expect(assigns(:contracts)).to match_array [ rejected_contract, waiting_confirmation_contract, canceled_contract, waiting_payment_contract ] }
        end

        context 'with only end date' do
          before { get :index, params: { end_date: 5.days.from_now } }
          it { expect(response).to render_template :index }
          it { expect(assigns(:contracts)).to match_array [ under_analysis_contract, rejected_contract ] }
        end
      end
    end

    describe 'GET #show' do
      context 'when user is part of the contract' do
        let!(:contract) { Fabricate :contract, guide: current_user_guide }
        before { get :show, params: { id: contract } }
        it { expect(response).to render_template :show }
        it { expect(assigns(:contract)).to eq contract }
      end

      context 'when user is not part of the contract' do
        let!(:contract) { Fabricate :contract }
        before { get :show, params: { id: contract } }
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

      context 'with conflicting dates' do
        let!(:existing_contract) { Fabricate :contract, start_date: 1.day.from_now, end_date: 3.days.from_now, guide: guide }
        let!(:new_contract) { Fabricate.build :contract, start_date: 1.day.from_now, end_date: 3.days.from_now, guide: guide }
        before { post :create, params: { guide_id: guide, contract: new_contract.attributes } }
        it { expect(response).to render_template :new }
        it { expect(guide.contracts.count).to eq 1 }
        it { expect(user.contracts.count).to eq 0 }
      end
    end

    describe 'PUT #update' do
      context 'when the current user is the guide' do
        let!(:contract) { Fabricate :contract, guide: current_user_guide }
        let(:data) { { price: 100 } }
        before { put :update, params: { id: contract, contract: data } }
        it { expect(response).to redirect_to contract_path(contract) }
        it { expect(contract.reload.price).to eq 100 }
        it { expect(contract.reload.status).to eq "waiting_confirmation" }
      end

      context 'when the current user is not the guide' do
        let!(:contract) { Fabricate :contract }
        let(:data) { { price: 100 } }
        before { put :update, params: { id: contract, contract: data } }
        it { expect(response).to redirect_to root_path }
        it { expect(flash[:danger]).to be_present }
        it { expect(contract.reload.price).to be_nil }
        it { expect(contract.reload.status).to eq "under_analysis" }
      end
    end

    describe 'POST #reject' do
      context 'when the current user is the guide' do
        context 'and contract is under analysis' do
          let!(:contract) { Fabricate :contract, guide: current_user_guide, status: :under_analysis }
          before { post :reject, params: { id: contract } }
          it { expect(response).to redirect_to contract_path(contract) }
          it { expect(assigns(:contract).status).to eq "rejected" }
        end
        context 'and contract is not under analysis' do
          let!(:contract) { Fabricate :contract, guide: current_user_guide, status: :waiting_confirmation }
          before { post :reject, params: { id: contract } }
          it { expect(response).to redirect_to contracts_path }
          it { expect(assigns(:contract).status).to eq "waiting_confirmation" }
        end
      end

      context 'when the current user is not the guide' do
        let!(:contract) { Fabricate :contract, status: :under_analysis }
        before { post :reject, params: { id: contract } }
        it { expect(response).to redirect_to root_path }
        it { expect(assigns(:contract).status).to eq "under_analysis" }
      end
    end

    describe 'POST #cancel' do
      context 'when the current user is the contractor' do
        context 'and contract is waiting confirmation' do
          let!(:contract) { Fabricate :contract, contractor: user, status: :waiting_confirmation }
          before { post :cancel, params: { id: contract } }
          it { expect(response).to redirect_to contract_path(contract) }
          it { expect(assigns(:contract).status).to eq "canceled" }
        end
        context 'and contract is not waiting confirmation' do
          let!(:contract) { Fabricate :contract, contractor: user, status: :under_analysis }
          before { post :cancel, params: { id: contract } }
          it { expect(response).to redirect_to contracts_path }
          it { expect(assigns(:contract).status).to eq "under_analysis" }
        end
      end

      context 'when the current user is not the contractor' do
        let!(:contract) { Fabricate :contract, status: :under_analysis }
        before { post :cancel, params: { id: contract } }
        it { expect(response).to redirect_to root_path }
        it { expect(assigns(:contract).status).to eq "under_analysis" }
      end
    end

    describe 'POST #finish' do
      context 'when the current user is the guide' do
        context 'and contract can be finished' do
          let!(:contract) { Fabricate :contract, guide: current_user_guide, status: :paid, start_date: 1.day.from_now, end_date: 2.days.from_now }
          before { allow(DateTime).to receive(:now).and_return(3.days.from_now) }
          before { post :finish, params: { id: contract } }
          it { expect(response).to redirect_to contract_path(contract) }
          it { expect(flash[:danger]).to_not be_present }
          it { expect(contract.reload.status).to eq "finished" }
        end

        context 'and contract can not be finished' do
          context 'because of the status' do
            let!(:contract) { Fabricate :contract, guide: current_user_guide, status: :waiting_payment }
            before { post :finish, params: { id: contract } }
            it { expect(response).to redirect_to contracts_path }
            it { expect(flash[:danger]).to be_present }
            it { expect(contract.status).to eq "waiting_payment" }
          end

          context 'because of the end date' do
            let!(:contract) { Fabricate :contract, guide: current_user_guide, status: :paid, start_date: 1.day.from_now, end_date: 3.days.from_now }
            before { allow(DateTime).to receive(:now).and_return(2.days.from_now) }
            before { post :finish, params: { id: contract } }
            it { expect(response).to redirect_to contracts_path }
            it { expect(flash[:danger]).to be_present }
            it { expect(contract.status).to eq "paid" }
          end
        end
      end

      context 'when the current user is not the guide' do
        let!(:contract) { Fabricate :contract }
        before { post :finish, params: { id: contract } }
        it { expect(response).to redirect_to root_path }
        it { expect(flash[:danger]).to be_present }
      end
    end
  end
end
