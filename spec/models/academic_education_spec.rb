require 'rails_helper'

RSpec.describe AcademicEducation, type: :model do
  it { is_expected.to belong_to :guide }
  it { is_expected.to validate_presence_of :course }
  it { is_expected.to validate_length_of(:course).is_at_least(5) }
  it { is_expected.to validate_presence_of :institution }
  it { is_expected.to validate_length_of(:institution).is_at_least(5) }
  it { is_expected.to validate_presence_of :level }
end
