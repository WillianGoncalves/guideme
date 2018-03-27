class Location < ApplicationRecord
  acts_as_mappable :default_units => :kms,
    :default_formula => :sphere,
    :distance_field_name => :distance,
    :lat_column_name => :lat,
    :lng_column_name => :lng

  belongs_to :guide
  validates :address, presence: true, length: { minimum: 10 }
  validates_presence_of :lat, :lng, :radius
end
