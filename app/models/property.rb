class Property < ApplicationRecord
  validates :name, :address, :code, :type, presence: true
  validates :bathrooms, :bedrooms, :num_floors, :occupancy, numericality: { only_integer: true, greater_than_or_equal_to: 0 }
  validates :type, inclusion: { in: %w(apartment house villa) } 
  validates :beachfront, :pets, inclusion: { in: [true, false] }

  has_many :bookings
end
