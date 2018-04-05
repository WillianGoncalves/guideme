require 'rails_helper'

RSpec.describe User, type: :model do
  it { is_expected.to have_one :guide }
  it { is_expected.to have_many :contracts }
  it { is_expected.to validate_presence_of :email }
  it { is_expected.to validate_presence_of :password }
  it { is_expected.to validate_presence_of :name }
  it { is_expected.to validate_length_of(:name).is_at_least(5) }

  describe 'is guide?' do
    let!(:user) { Fabricate :user }

    context 'awaiting_for_approval' do
      let!(:guide) { Fabricate :guide, status: "awaiting_for_approval", user: user }
      it { expect(user.guide?).to eq false }
    end

    context 'approved' do
      let!(:guide) { Fabricate :guide, status: "approved", user: user }
      it { expect(user.guide?).to eq true }
    end

    context 'denied' do
      let!(:guide) { Fabricate :guide, status: "denied", user: user }
      it { expect(user.guide?).to eq false }
    end
  end

  describe 'is guide candidate?' do
    let!(:user) { Fabricate :user }

    context 'awaiting_for_approval' do
      let!(:guide) { Fabricate :guide, status: "awaiting_for_approval", user: user }
      it { expect(user.guide_candidate?).to eq true }
    end

    context 'approved' do
      let!(:guide) { Fabricate :guide, status: "approved", user: user }
      it { expect(user.guide_candidate?).to eq false }
    end

    context 'denied' do
      let!(:guide) { Fabricate :guide, status: "denied", user: user }
      it { expect(user.guide_candidate?).to eq true }
    end
  end

  describe 'contracts' do
    let!(:user) { Fabricate :user }
    let!(:guide) { Fabricate :guide, status: :approved, user: user }

    let!(:current_user) { Fabricate :user }
    let!(:current_user_guide) { Fabricate :guide, status: :approved, user: current_user }

    let!(:first_contract) { Fabricate :contract, guide: guide, contractor: current_user }
    let!(:second_contract) { Fabricate :contract, guide: current_user_guide, contractor: user }

    context 'as contractor' do
      it { expect(current_user.contracts_as_contractor).to match_array [ first_contract ] }
    end
    context 'as guide' do
      it { expect(current_user.contracts_as_guide).to match_array [ second_contract ] }
    end
  end

  describe 'is part of a contract' do
    let!(:user) { Fabricate :user }
    let!(:guide) { Fabricate :guide, status: :approved, user: user }

    let!(:current_user) { Fabricate :user }
    let!(:current_user_guide) { Fabricate :guide, status: :approved, user: current_user }

    let!(:first_contract) { Fabricate :contract, guide: guide, contractor: current_user }
    let!(:second_contract) { Fabricate :contract, guide: current_user_guide, contractor: user }

    context 'as guide' do
      it { expect(current_user.is_guide_of?(first_contract)).to eq false }
      it { expect(current_user.is_guide_of?(second_contract)).to eq true }
    end

    context 'as contractor' do
      it { expect(current_user.is_contractor_of?(first_contract)).to eq true }
      it { expect(current_user.is_contractor_of?(second_contract)).to eq false }
    end
  end
end
