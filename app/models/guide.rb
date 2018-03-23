class Guide < ApplicationRecord
  belongs_to :user
  validates :birthdate, presence: true
  validates :main_phone, presence: true, length: { minimum: 10 }
  validates :bio, presence: true, length: { minimum: 10 }
  enum status: [:awaiting_for_approval, :approved, :denied]
end
