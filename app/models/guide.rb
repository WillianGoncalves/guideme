class Guide < ApplicationRecord
  belongs_to :user
  has_many :academic_educations
  has_one :location
  validates :birthdate, presence: true
  validates :main_phone, presence: true, length: { minimum: 10 }
  validates :bio, presence: true, length: { minimum: 10 }
  validates :status, presence: true
  enum status: [:awaiting_for_approval, :approved, :denied]

  accepts_nested_attributes_for :academic_educations, reject_if: :all_blank, allow_destroy: true
  accepts_nested_attributes_for :location, reject_if: :all_blank, allow_destroy: true

  def display_status
    I18n.t("activerecord.attributes.guide.statuses.#{self.status}")
  end
end
