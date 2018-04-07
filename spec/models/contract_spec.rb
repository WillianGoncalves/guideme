require 'rails_helper'

RSpec.describe Contract, type: :model do
  it { is_expected.to belong_to :contractor }
  it { is_expected.to belong_to :guide }
  it { is_expected.to have_one :payment }
  it { is_expected.to validate_presence_of :guide }
  it { is_expected.to validate_presence_of :contractor }
  it { is_expected.to validate_presence_of :start_date }
  it { is_expected.to validate_presence_of :end_date }
  it { is_expected.to validate_presence_of :goals }
  it { is_expected.to validate_presence_of :status }
  it { is_expected.to validate_length_of(:goals).is_at_least(10) }

  describe 'invalid interval' do
    let!(:contract) { Fabricate.build :contract, start_date: 2.days.from_now, end_date: 1.day.from_now }
    before { contract.validate }
    it { expect(contract.valid?).to eq false }
    it { expect(contract.errors[:start_date]).to match_array [ I18n.t(:invalid_interval, scope: [:activerecord, :errors, :models, :contract, :attributes, :start_date]) ] }
  end

  describe 'conflict with other contracts of a guide' do
    before(:all) do
      user = Fabricate :user
      @guide = Fabricate :guide, user: user
      first_contractor = Fabricate :user
      Fabricate :contract, start_date: 1.day.from_now, end_date: 3.days.from_now, guide: @guide, contractor: first_contractor, status: :under_analysis
      second_contractor = Fabricate :user
      Fabricate :contract, start_date: 4.day.from_now, end_date: 6.days.from_now, guide: @guide, contractor: second_contractor, status: :rejected
    end

    let(:third_contractor) { Fabricate :user }

    context 'when there is conflict' do
      let(:conflicting_contract) { Fabricate.build :contract, start_date: 2.days.from_now, end_date: 4.days.from_now, guide: @guide, contractor: third_contractor }
      before { conflicting_contract.validate }
      it { expect(conflicting_contract.valid?).to eq false }
      it { expect(conflicting_contract.errors[:start_date]).to match_array [ I18n.t(:date_conflict, scope: [:activerecord, :errors, :models, :contract, :attributes, :start_date]) ] }
    end

    context 'when there is no conflict' do
      let(:contract) { Fabricate.build :contract, start_date: 4.days.from_now, end_date: 6.days.from_now, guide: @guide, contractor: third_contractor }
      before { contract.validate }
      it { expect(contract.valid?).to eq true }
    end
  end
end
