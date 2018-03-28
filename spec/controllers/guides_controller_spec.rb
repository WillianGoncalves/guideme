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
        before(:all) do
          @user1 = Fabricate :user
          @user2 = Fabricate :user
          @user3 = Fabricate :user
          @user4 = Fabricate :user
          @guide1 = Fabricate :guide, status: :awaiting_for_approval, user: @user1
          @guide2 = Fabricate :guide, status: :awaiting_for_approval, user: @user2
          @guide3 = Fabricate :guide, status: :approved, user: @user3
          @guide4 = Fabricate :guide, status: :denied, user: @user4
        end

        context 'with status param' do
          before { get :index, params: { status: "awaiting_for_approval" } }
          it { expect(assigns(:guides)).to match_array [@guide1, @guide2] }
          it { expect(response).to render_template :index }
        end

        context 'without status param' do
          before { get :index }
          it { expect(assigns(:guides)).to match_array [@guide1, @guide2, @guide3, @guide4] }
          it { expect(response).to render_template :index }
        end
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

    describe 'PUT #update_status' do
      before(:each) do
        @guide = Fabricate :guide, status: :awaiting_for_approval, user: user
        expect(@guide.academic_educations.count).to eq 0
        expect(@guide.status).to eq "awaiting_for_approval"
      end

      context 'approve a guide' do
        before { put :update_status, params: { id: @guide, status: "approved" } }
        it { expect(response).to redirect_to guides_path }
        it { expect(@guide.reload.status).to eq "approved" }
      end

      context 'deny a guide' do
        before { put :update_status, params: { id: @guide, status: "denied" } }
        it { expect(response).to redirect_to guides_path }
        it { expect(@guide.reload.status).to eq "denied" }
      end

      context 'if status not provided' do
        before { put :update_status, params: { id: @guide, status: "" } }
        it { expect(response).to redirect_to guides_path }
        it { expect(@guide.reload.status).to eq "awaiting_for_approval" }
      end
    end

    describe 'GET #search_by_location' do
      let!(:near_user) { Fabricate :user }
      let!(:near_location) { Location.new(street: "Rua Manlio de Araujo Silva", district: "Olaria", city: "Nova Friburgo", state: "RJ") }
      let!(:near_guide) { Fabricate :guide, location: near_location, user: near_user }
      let!(:far_user) { Fabricate :user }
      let!(:far_location) { Location.new(street: "Rua Juca Barroso", district: "Lumiar", city: "Nova Friburgo", state: "RJ") }
      let!(:far_guide) { Fabricate :guide, location: far_location, user: far_user }
      let!(:selected_location) { { coordinates: [-22.3049091, -42.5405217], radius: 2 } }

      # [-22.3049091, -42.5405217] = Rua Presidente Getulio Vargas, Olaria, Nova Friburgo, RJ
      before { get :search_by_location, xhr: true, params: { format: :js, coordinates: [-22.3049091, -42.5405217], radius: 2 } }
      it { expect(response).to render_template(partial: "guides/_result") }
      it { expect(assigns(:guides)).to match_array [near_guide] }
    end
  end
end
