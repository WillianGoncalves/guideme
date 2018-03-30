require 'rails_helper'

RSpec.describe User, type: :model do
  it { is_expected.to have_one :guide }
  it { is_expected.to have_many :contracts }
  it { is_expected.to validate_presence_of :email }
  it { is_expected.to validate_presence_of :password }
  it { is_expected.to validate_presence_of :name }
  it { is_expected.to validate_length_of(:name).is_at_least(5) }

  describe 'is guide?' do
    context 'awaiting_for_approval' do
      let!(:user) { Fabricate :user }
      let!(:guide) { Fabricate :guide, status: "awaiting_for_approval", user: user }
      it { expect(user.guide?).to eq false }
    end

    context 'approved' do
      let!(:user) { Fabricate :user }
      let!(:guide) { Fabricate :guide, status: "approved", user: user }
      it { expect(user.guide?).to eq true }
    end

    context 'denied' do
      let!(:user) { Fabricate :user }
      let!(:guide) { Fabricate :guide, status: "denied", user: user }
      it { expect(user.guide?).to eq false }
    end
  end

  describe 'is guide candidate?' do
    context 'awaiting_for_approval' do
      let!(:user) { Fabricate :user }
      let!(:guide) { Fabricate :guide, status: "awaiting_for_approval", user: user }
      it { expect(user.guide_candidate?).to eq true }
    end

    context 'approved' do
      let!(:user) { Fabricate :user }
      let!(:guide) { Fabricate :guide, status: "approved", user: user }
      it { expect(user.guide_candidate?).to eq false }
    end

    context 'denied' do
      let!(:user) { Fabricate :user }
      let!(:guide) { Fabricate :guide, status: "denied", user: user }
      it { expect(user.guide_candidate?).to eq true }
    end
  end
end
