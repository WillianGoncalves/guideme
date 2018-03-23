require 'rails_helper'

RSpec.describe Guide, type: :model do
  it { is_expected.to validate_presence_of :birthdate }
  it { is_expected.to validate_presence_of :main_phone }
  it { is_expected.to validate_length_of(:main_phone).is_at_least(10) }
  it { is_expected.to validate_presence_of :bio }
  it { is_expected.to validate_length_of(:bio).is_at_least(10) }
end
