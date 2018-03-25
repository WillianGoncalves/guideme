require 'rails_helper'

RSpec.describe GuidesController, type: :controller do
  context 'unauthenticated user' do
    describe 'GET #new' do
      before { get :new, params: { user_id: 1 } }
      it { expect(response).to redirect_to user_session_path }
    end
  end

  context 'authenticated user' do
    let!(:user) { Fabricate :user }
    before { sign_in user }

    describe 'GET #new' do
      before { get :new, params: { user_id: user } }
      it { expect(assigns(:guide)).to be_a_new Guide }
      it { expect(response).to render_template :new }
    end

    describe 'GET #edit' do
      let!(:guide) { Fabricate :guide, user: user }
      before { get :edit, params: { user_id: user, id: guide } }
      it { expect(response).to render_template :edit }
    end

    describe 'POST #create' do
      context 'with valid data' do
        let!(:guide) { Fabricate.build :guide }
        before { post :create, params: { user_id: user, guide: guide.attributes } }
        it { expect(response).to redirect_to user_guide_path(user, assigns(:guide)) }
        it { expect(user.reload.guide.status).to eq "awaiting_for_approval" }
      end

      context 'with invalid data' do
        let!(:invalid_guide) { Fabricate.build :invalid_guide }
        before { post :create, params: { user_id: user, guide: invalid_guide.attributes } }
        it { expect(response).to render_template :new }
        it { expect(user.reload.guide).to be nil }
      end
    end

    describe 'PUT #update' do
      context 'with valid data' do
        let!(:guide) { Fabricate :guide, user: user }
        let!(:updates) { Fabricate.build :guide }
        before { put :update, params: { user_id: user, id: guide, guide: updates.attributes } }
        it { expect(response).to redirect_to user_guide_path(user, guide) }
        it { expect(guide.reload.academic_educations.count).to eq 1 }
      end

      context 'with invalid data' do
      end
    end
  end
end
