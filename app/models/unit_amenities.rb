class UnitAmenities
  include Virtus.model

  attribute :air_conditioning,      Boolean, default: false
  attribute :boating,               Boolean, default: false
  attribute :fishing,               Boolean, default: false
  attribute :hot_tub,               Boolean, default: false
  attribute :internet_access,       Boolean, default: false
  attribute :kitchen,               Boolean, default: false
  attribute :pool,                  Boolean, default: false
  attribute :washer_dryer,          Boolean, default: false
  attribute :wheelchair_accessible, Boolean, default: false
  attribute :golf,                  Boolean, default: false
  attribute :patio,                 Boolean, default: false
  attribute :balcony,               Boolean, default: false
  attribute :grill,                 Boolean, default: false
  attribute :parking,               Boolean, default: false
  attribute :linens_provided,       Boolean, default: false
  attribute :towels_provided,       Boolean, default: false
  attribute :telephone,             Boolean, default: false
  attribute :television,            Boolean, default: false
  attribute :heating,               Boolean, default: false
  attribute :beachfront,            Boolean, default: false
  attribute :dishwasher,            Boolean, default: false
  attribute :coffee_maker,          Boolean, default: false
  attribute :dishes_and_utensils,   Boolean, default: false
  attribute :microwave,             Boolean, default: false
  attribute :refrigerator,          Boolean, default: false
  attribute :stove,                 Boolean, default: false
  attribute :toaster,               Boolean, default: false
  attribute :pets,                  Boolean, default: false

  CODES = {
    1  => :air_conditioning,
    2  => :wheelchair_accessible,
    3  => :internet_access,
    4  => :hot_tub,
    5  => :kitchen,
    6  => :pool,
    7  => :washer_dryer,
    10 => :boating,
    11 => :fishing,
    12 => :golf,
  }.freeze

  FROM_SERVICES = [
    { patio: ['Patio', 'Deck / Patio'] },
    { balcony: ['Balcony'] },
    { grill: ['BBQ Grill', 'Outdoor Grill'] },
    { parking: ['Parking'] },
    { linens_provided: ['Linens', 'Linens Provided'] },
    { towels_provided: ['Towels', 'Towels Provided'] },
    { telephone: ['Telephone'] },
    { television: ['Television'] },
    { heating: ['Heating'] },
    { beachfront: ['Beachfront'] },
    { dishwasher: ['Dishwasher'] },
    { coffee_maker: ['Coffee Maker'] },
    { dishes_and_utensils: ['Dishes & Utensils'] },
    { microwave: ['Microwave'] },
    { refrigerator: ['Refrigerator'] },
    { stove: ['Stove'] },
    { toaster: ['Toaster'] },
    { pool: ['Communal Pool', 'Community pool']}
  ].freeze

  AMENITIES = [
    'Beachfront',
    'Internet Access',
    'Pets',
    'Pool',
    'Air Conditioning',
    'Heating',
    'Grill',
    'Hot Tub',
    'Television',
    'Washer Dryer',
    'Wheelchair Accessible',
    'Boating',
    'Fishing',
    'Golf',
    'Patio',
    'Balcony',
    'Parking',
    'Linens Provided',
    'Kitchen',
    'Towels Provided',
    'Telephone',
    'Dishwasher',
    'Coffee Maker',
    'Dishes and Utensils',
    'Microwave',
    'Refrigerator',
    'Stove',
    'Toaster',
  ].freeze
  
  def self.from_codes(codes, services, pets)
    amenities = new
    return amenities unless codes.is_a?(Array)
    codes.each do |amenity|
      activate_amenity_with_code(amenities, amenity[:@code])
    end
    FROM_SERVICES.each do |amenity|
      key = amenity.keys[0]
      amenities[key] = (amenity[key] & services).any?
    end
      amenities['pets'] = pets
    amenities
  end

  def self.activate_amenity_with_code(amenities, code)
    attribute = CODES[code.to_i]
    amenities.send("#{attribute}=".to_sym, true) unless attribute.nil?
  end
end
