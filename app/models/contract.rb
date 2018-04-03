class Contract < ApplicationRecord
  belongs_to :guide
  belongs_to :user
  validates_presence_of :guide, :user, :start_date, :end_date
  validates :goals, presence: true, length: { minimum: 10 }
  validate :start_date_must_be_before_end_date, :contracts_can_not_conflict

  def start_date_must_be_before_end_date
    if start_date.present? and end_date.present?
      if start_date > end_date
        errors.add(:start_date, :invalid_interval)
      end
    end
  end

  def contracts_can_not_conflict
    if Contract.where("guide_id = ? AND end_date > ?", guide_id, start_date).any?
      errors.add(:start_date, :date_conflict)
    end
  end
end
