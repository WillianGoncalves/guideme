class AcademicEducation < ApplicationRecord
  belongs_to :guide
  validates :course, presence: true, length: { minimum: 5 }
  validates :institution, presence: true, length: { minimum: 5 }
  validates :level, presence: true
  enum level: [:elementary, :high_school, :technician, :bachelor, :master, :doctor, :phd]
end
