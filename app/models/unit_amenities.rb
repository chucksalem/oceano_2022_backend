class UnitAmenities
  include Virtus.model

  attribute :air_conditioning,      Boolean, default: false
  attribute :beach,                 Boolean, default: false
  attribute :boating,               Boolean, default: false
  attribute :fishing,               Boolean, default: false
  attribute :hot_tub,               Boolean, default: false
  attribute :internet_access,       Boolean, default: false
  attribute :kitchen,               Boolean, default: false
  attribute :pool,                  Boolean, default: false
  attribute :washer_dryer,          Boolean, default: false
  attribute :wheelchair_accessible, Boolean, default: false
  attribute :golf,                  Boolean, default: false

  CODES = {
    1  => :air_conditioning,
    2  => :wheelchair_accessible,
    3  => :internet_access,
    4  => :hot_tub,
    5  => :kitchen,
    6  => :pool,
    7  => :washer_dryer,
    8  => :beach,
    10 => :boating,
    11 => :fishing,
    12 => :golf,
  }

  AMENITIES = [
    'Beach',
    'Internet Access',
    'Pool',
    'Kitchen',
    'Air Conditioning',
    'Wheelchair Accessible',
    'Hot Tub',
    'Washer Dryer',
    'Boating',
    'Fishing',
    'Golf',
  ]
  
  def self.from_codes(codes)
    amenities = new
    return amenities unless codes.is_a?(Array)
    codes.each do |amenity|
      activate_amenity_with_code(amenities, amenity[:@code])
    end
    amenities
  end

  def self.activate_amenity_with_code(amenities, code)
    attribute = CODES[code.to_i]
    amenities.send("#{attribute}=".to_sym, true) unless attribute.nil?
  end
end
