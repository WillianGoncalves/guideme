class Location < ApplicationRecord
  geocoded_by :full_address
  after_validation :geocode

  belongs_to :guide
  validates :street, presence: true, length: { minimum: 5 }
  validates :district, presence: true, length: { minimum: 5 }
  validates :city, presence: true, length: { minimum: 5 }
  validates :state, presence: true, length: { minimum: 2 }

  def full_address
    "#{self.street}, #{self.district}, #{self.city}, #{self.state}"
  end
end
