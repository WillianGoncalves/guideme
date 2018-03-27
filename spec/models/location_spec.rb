require 'rails_helper'

RSpec.describe Location, type: :model do
  it { is_expected.to belong_to :guide }
  it { is_expected.to validate_presence_of :address }
  it { is_expected.to validate_length_of(:address).is_at_least(10) }
  it { is_expected.to validate_presence_of :lat }
  it { is_expected.to validate_presence_of :lng }
  it { is_expected.to validate_presence_of :radius }
end
