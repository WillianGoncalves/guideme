class Contract < ApplicationRecord
  belongs_to :guide
  belongs_to :contractor, class_name: "User", foreign_key: "user_id"
  has_one :payment
  validates_presence_of :guide, :contractor, :start_date, :end_date, :status
  validates :goals, presence: true, length: { minimum: 10 }
  validate :start_date_must_be_before_end_date, :contracts_can_not_conflict
  enum status: [:under_analysis, :rejected, :waiting_confirmation, :canceled, :waiting_payment, :expired, :paid, :finished]

  def start_date_must_be_before_end_date
    if start_date.present? and end_date.present?
      if start_date > end_date
        errors.add(:start_date, :invalid_interval)
      end
    end
  end

  def contracts_can_not_conflict
    return if persisted?
    statuses_for_openned_contracts = [:under_analysis, :waiting_confirmation, :waiting_payment, :paid]
    if Contract.where("guide_id = ? AND end_date > ?", guide_id, start_date).where(status: statuses_for_openned_contracts).any?
      errors.add(:start_date, :date_conflict)
    end
  end

  def display_status
    I18n.t("activerecord.attributes.contract.statuses.#{self.status}")
  end
end
