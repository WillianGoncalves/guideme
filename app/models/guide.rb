class Guide < ApplicationRecord
  belongs_to :user
  has_one :academic_education
  validates :birthdate, presence: true
  validates :main_phone, presence: true, length: { minimum: 10 }
  validates :bio, presence: true, length: { minimum: 10 }
  validates :status, presence: true
  enum status: [:awaiting_for_approval, :approved, :denied]
end
