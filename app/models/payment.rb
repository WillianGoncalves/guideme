class Payment < ApplicationRecord
  COMISSION = 5
  belongs_to :contract
  validates :comission, presence: true, numericality: { greater_than: 0 }
  validates :payment_type, presence: true
  enum payment_type: [:bank_slip, :credit_card, :debit_card]
end
