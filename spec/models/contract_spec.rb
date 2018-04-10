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

  describe 'invalid start date' do
    context 'when after end date' do
      let!(:contract) { Fabricate.build :contract, start_date: 2.days.from_now, end_date: 1.day.from_now }
      before { contract.validate }
      it { expect(contract.valid?).to eq false }
      it { expect(contract.errors[:start_date]).to match_array [ I18n.t(:invalid_interval, scope: [:activerecord, :errors, :models, :contract, :attributes, :start_date]) ] }
    end

    context 'when before current date' do
      let(:contract) { Fabricate.build :contract, start_date: 1.day.ago, end_date: 1.day.from_now }
      before { contract.validate }
      it { expect(contract.valid?).to eq false }
      it { expect(contract.errors[:start_date]).to match_array [ I18n.t(:invalid_interval, scope: [:activerecord, :errors, :models, :contract, :attributes, :start_date]) ] }
    end
  end

  describe 'conflict with other contracts of a guide' do
    before(:all) do
      @guide = Fabricate :guide
      Fabricate :contract, start_date: 5.day.from_now, end_date: 7.days.from_now, guide: @guide, status: :rejected
      Fabricate :contract, start_date: 5.day.from_now, end_date: 7.days.from_now, guide: @guide, status: :under_analysis
    end

    context 'when there is conflict' do
      context 'start data invalid' do
        let(:conflicting_contract) { Fabricate.build :contract, start_date: 6.days.from_now, end_date: 8.days.from_now, guide: @guide }
        before { conflicting_contract.validate }
        it { expect(conflicting_contract.valid?).to eq false }
        it { expect(conflicting_contract.errors[:start_date]).to match_array [ I18n.t(:date_conflict, scope: [:activerecord, :errors, :models, :contract, :attributes, :start_date]) ] }
      end
      
      context 'end data invalid' do
        let(:conflicting_contract) { Fabricate.build :contract, start_date: 4.days.from_now, end_date: 6.days.from_now, guide: @guide }
        before { conflicting_contract.validate }
        it { expect(conflicting_contract.valid?).to eq false }
        it { expect(conflicting_contract.errors[:end_date]).to match_array [ I18n.t(:date_conflict, scope: [:activerecord, :errors, :models, :contract, :attributes, :end_date]) ] }
      end
    end

    context 'when there is no conflict' do
      context 'after existing contract' do
        let(:contract) { Fabricate.build :contract, start_date: 8.days.from_now, end_date: 9.days.from_now, guide: @guide }
        before { contract.validate }
        it { expect(contract.valid?).to eq true }
      end

      context 'before existing contract' do
        let(:contract) { Fabricate.build :contract, start_date: 3.days.from_now, end_date: 4.days.from_now, guide: @guide }
        before { contract.validate }
        it { expect(contract.valid?).to eq true }
      end
    end
  end
end
