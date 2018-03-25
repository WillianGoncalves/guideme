class Guide < ApplicationRecord
  belongs_to :user
  has_many :academic_educations
  validates :birthdate, presence: true
  validates :main_phone, presence: true, length: { minimum: 10 }
  validates :bio, presence: true, length: { minimum: 10 }
  validates :status, presence: true
  enum status: [:awaiting_for_approval, :approved, :denied]

  accepts_nested_attributes_for :academic_educations, reject_if: :all_blank, allow_destroy: true
end
