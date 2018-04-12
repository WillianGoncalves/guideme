class Contract < ApplicationRecord
  belongs_to :guide
  belongs_to :contractor, class_name: "User", foreign_key: "user_id"
  has_one :payment
  validates_presence_of :guide, :contractor, :start_date, :end_date, :status
  validates :goals, presence: true, length: { minimum: 10 }
  validate :validate_start_date, :contracts_can_not_conflict
  enum status: [:under_analysis, :rejected, :waiting_confirmation, :canceled, :waiting_payment, :expired, :paid, :finished]

  def validate_start_date
    return if persisted?
    if start_date.present? and end_date.present?
      if start_date > end_date or start_date < DateTime.now
        errors.add(:start_date, :invalid_interval)
      end
    end
  end

  def contracts_can_not_conflict
    return if persisted?
    statuses_for_openned_contracts = [:under_analysis, :waiting_confirmation, :waiting_payment, :paid]
    openned_contracts = Contract.where("guide_id = ?", guide_id).where(status: statuses_for_openned_contracts)
    if openned_contracts.where("start_date <= ? AND end_date >= ?", start_date, start_date).any?
      errors.add(:start_date, :date_conflict)
    end
    if openned_contracts.where("start_date <= ? AND end_date >= ?", end_date, end_date).any?
      errors.add(:end_date, :date_conflict)
    end
  end

  def display_status
    I18n.t("activerecord.attributes.contract.statuses.#{self.status}")
  end
end
