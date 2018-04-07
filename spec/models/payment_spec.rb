require 'rails_helper'

RSpec.describe Payment, type: :model do
  it { is_expected.to belong_to :contract }
  it { is_expected.to validate_presence_of :comission }
  it { is_expected.to validate_presence_of :payment_type }
end
