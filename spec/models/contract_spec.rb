require 'rails_helper'

RSpec.describe Contract, type: :model do
  it { is_expected.to belong_to :user }
  it { is_expected.to belong_to :guide }
  it { is_expected.to validate_presence_of :guide }
  it { is_expected.to validate_presence_of :user }
  it { is_expected.to validate_presence_of :start_date }
  it { is_expected.to validate_presence_of :end_date }
  it { is_expected.to validate_presence_of :goals }
  it { is_expected.to validate_length_of(:goals).is_at_least(10) }
end
