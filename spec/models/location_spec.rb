require 'rails_helper'

RSpec.describe Location, type: :model do
  it { is_expected.to belong_to :guide }
  it { is_expected.to validate_presence_of :street }
  it { is_expected.to validate_length_of(:street).is_at_least(5) }
  it { is_expected.to validate_presence_of :district }
  it { is_expected.to validate_length_of(:district).is_at_least(5) }
  it { is_expected.to validate_presence_of :city }
  it { is_expected.to validate_length_of(:city).is_at_least(5) }
  it { is_expected.to validate_presence_of :state }
  it { is_expected.to validate_length_of(:state).is_at_least(2) }
end
