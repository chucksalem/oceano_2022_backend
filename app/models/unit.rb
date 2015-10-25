class Unit
  include Virtus.model

  class NotFound < StandardError; end

  attribute :address,      UnitAddress
  attribute :amenities,    UnitAmenities
  attribute :bathrooms,    Integer, default: 0
  attribute :bedrooms,     Integer, default: 0
  attribute :code,         String
  attribute :descriptions, UnitDescriptions
  attribute :name,         String
  attribute :num_floors,   Integer, default: 1
  attribute :occupancy,    Integer, default: 0
  attribute :position,     UnitPosition
  attribute :type,         Symbol
  attribute :reviews,      Array

  def self.from_hash(hash)
    new.tap do |unit|
      hash.each do |key, val|
        unit.send("#{key}=".to_sym, val)
      end
    end
  end

  def self.get(id)
    search   = Escapia::UnitDescriptiveInfo.new
    response = search.execute(unit_id: id)
    content  = response[:unit_descriptive_contents][:unit_descriptive_content]
    info     = content[:unit_info]

    create_from_results(
      address:       info[:address],
      amenities:     info[:unit_amenity],
      code:          content[:@unit_code],
      descriptions:  info[:descriptions],
      name:          info[:unit_name],
      num_floors:    info[:@num_floors],
      occupancy:     info[:@max_occupancy],
      position:      info[:position],
      reviews:       content[:unit_reviews],
      rooms:         info[:category_codes][:room_info],
      type_code:     info[:category_codes][:unit_category][:@code]
    )
  end

  def self.search(*criteria)
    search   = Escapia::UnitSearch.new
    response = search.execute(*criteria)

    if response[:units]
      return response[:units][:unit].map { |unit| unit[:@unit_code] }
    end

    []
  end

  def self.create_from_results(address:,
                               amenities:,
                               code:,
                               descriptions:,
                               name:,
                               num_floors:,
                               occupancy:,
                               position:,
                               reviews:,
                               rooms:,
                               type_code:)
    unit = new

    unit.type         = UnitType.from_code(type_code)
    unit.code         = code
    unit.name         = name
    unit.num_floors   = num_floors.to_i unless num_floors.nil?
    unit.occupancy    = occupancy.to_i
    unit.amenities    = UnitAmenities.from_codes(amenities)
    unit.bathrooms    = UnitRooms.count_for_code(:bathrooms, rooms)
    unit.bedrooms     = UnitRooms.count_for_code(:bedrooms, rooms)
    unit.descriptions = UnitDescriptions.from_descriptions(descriptions)
    unit.reviews      = UnitReviews.from_response(reviews)

    unit.address = {
      street:      address[:address_line],
      city:        address[:city_name],
      postal_code: address[:postal_code],
      state:       address[:state_prov],
      country:     address[:country_name]
    }

    unless position.nil?
      unit.position = {
        latitude:  position[:@latitude],
        longitude: position[:@longitude]
      }
    end

    unit
  end

  def stay(start_date:, end_date:, guests:)
    stay = Escapia::UnitStay.new
    response = stay.execute({
      date_range: { start: start_date, end: end_date, },
      guests:     [{ type: 10, count: guests }],
      unit_code:  code
    })
    response[:unit_stay][:unit_rates][:unit_rate]
  end

  def available_amenities
    amenities.to_h.select { |k,v| v }.keys
  end

  def standard_images
    descriptions.images.map { |i| i[:formats][2] }
  end

  def large_images
    descriptions.images.map { |i| i[:formats][4] }
  end

  def long_description
    descriptions.text[0][:description]
  end

  def videos
    descriptions.videos
  end
end
