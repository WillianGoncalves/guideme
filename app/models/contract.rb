class Contract < ApplicationRecord
  belongs_to :guide
  belongs_to :user
  validates_presence_of :guide, :user, :start_date, :end_date
  validates :goals, presence: true, length: { minimum: 10 }
end
