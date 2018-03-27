class AcademicEducation < ApplicationRecord
  belongs_to :guide
  validates :course, presence: true, length: { minimum: 5 }
  validates :institution, presence: true, length: { minimum: 5 }
  validates :level, presence: true
  enum level: [:elementary, :high_school, :technician, :bachelor, :master, :doctor, :phd]

  def display_level
    I18n.t("activerecord.attributes.academic_education.levels.#{self.level}")
  end
end
