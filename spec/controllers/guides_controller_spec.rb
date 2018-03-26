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

    describe 'GET #index' do
      context 'search by status' do
        let!(:user1) { Fabricate :user }
        let!(:user2) { Fabricate :user }
        let!(:user3) { Fabricate :user }
        let!(:user4) { Fabricate :user }
        let!(:guide1) { Fabricate :guide, status: :awaiting_for_approval, user: user1 }
        let!(:guide2) { Fabricate :guide, status: :awaiting_for_approval, user: user2 }
        let!(:guide3) { Fabricate :guide, status: :approved, user: user3 }
        let!(:guide4) { Fabricate :guide, status: :denied, user: user4 }

        before { get :index, params: { status: "awaiting_for_approval" } }
        it { expect(assigns(:guides)).to match_array [guide1, guide2] }
        it { expect(response).to render_template :index }
      end
    end

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
        let!(:ae) { Fabricate.build :bachelor }
        let!(:academic_educations) { { academic_educations_attributes: [ ae.attributes ] } }
        let!(:guide) { Fabricate.build :guide }
        let!(:data) { guide.attributes.merge(academic_educations) }

        before { post :create, params: { user_id: user, guide: data } }
        it { expect(response).to redirect_to user_guide_path(user, assigns(:guide)) }
        it { expect(user.guide.status).to eq "awaiting_for_approval" }
        it { expect(user.guide.academic_educations.count).to eq 1 }
        it { expect(user.guide.academic_educations.first.level).to eq 'bachelor' }
      end

      context 'with invalid data' do
        let!(:ae) { Fabricate.build :bachelor }
        let!(:academic_educations) { { academic_educations_attributes: [ ae.attributes ] } }
        let!(:invalid_guide) { Fabricate.build :invalid_guide }
        let!(:data) { invalid_guide.attributes.merge(academic_educations) }

        before { post :create, params: { user_id: user, guide: data } }
        it { expect(response).to render_template :new }
        it { expect(user.guide).to be nil }
      end
    end

    describe 'PUT #update' do
      before(:each) do
        @guide = Fabricate :guide, status: :approved, user: user
        expect(@guide.academic_educations.count).to eq 0
        expect(@guide.status).to eq "approved"
      end

      context 'with valid data' do
        let!(:ae) { Fabricate.build :bachelor }
        let!(:academic_educations) { { academic_educations_attributes: [ ae.attributes ] } }
        let!(:updates) { Fabricate.build :guide }
        let!(:data) { updates.attributes.merge(academic_educations) }

        before { put :update, params: { user_id: user, id: @guide, guide: data } }
        it { expect(response).to redirect_to user_guide_path(user, @guide) }
        it { expect(@guide.academic_educations.count).to eq 1 }
        it { expect(@guide.reload.status).to eq "awaiting_for_approval" }
      end

      context 'with invalid data' do
        let!(:ae) { Fabricate.build :bachelor }
        let!(:academic_educations) { { academic_educations_attributes: [ ae.attributes ] } }
        let!(:updates) { Fabricate.build :invalid_guide }
        let!(:data) { updates.attributes.merge(academic_educations) }

        before { put :update, params: { user_id: user, id: @guide, guide: data } }
        it { expect(response).to render_template :edit }
        it { expect(@guide.academic_educations.count).to eq 0 }
        it { expect(@guide.reload.status).to eq "approved" }
      end
    end
  end
end
