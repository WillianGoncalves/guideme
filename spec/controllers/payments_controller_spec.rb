require 'rails_helper'

RSpec.describe PaymentsController, type: :controller do
  context 'authenticated user' do
    let!(:user) { Fabricate :user }
    before { sign_in user }

    describe 'GET #new' do
      let!(:contract) { Fabricate :contract }
      before { get :new, params: { contract_id: contract } }
      it { expect(response).to render_template :new }
      it { expect(assigns(:contract)).to eq contract }
      it { expect(assigns(:payment)).to be_a_new Payment }
      it { expect(assigns(:payment).comission).to eq Payment::COMISSION }
    end

    describe 'POST #create' do
      let!(:contract) { Fabricate :contract }
      let!(:payment) { { payment_type: :credit_card } }
      before { post :create, params: { contract_id: contract, payment: payment } }
      it { expect(response).to redirect_to contract_path(contract) }
      it { expect(contract.reload.status).to eq "paid" }
      it { expect(contract.reload.payment).to_not be_nil }
      it { expect(contract.reload.payment.payment_type).to eq "credit_card" }
    end
  end
end
