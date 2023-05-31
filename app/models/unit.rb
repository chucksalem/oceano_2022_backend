class Unit
  include Virtus.model
  include Hashable

  class NotFound < StandardError; end

  attribute :address,         UnitAddress
  attribute :amenities,       UnitAmenities
  attribute :bathrooms,       Integer, default: 0
  attribute :bedrooms,        Integer, default: 0
  attribute :code,            String
  attribute :descriptions,    UnitDescriptions
  attribute :name,            String
  attribute :num_floors,      Integer, default: 1
  attribute :occupancy,       Integer, default: 0
  attribute :position,        UnitPosition
  attribute :type,            Symbol
  attribute :reviews,         Array
  attribute :beachfront,      Boolean, default: false
  attribute :pets,            Boolean, default: false
  attribute :preview_amount,  Float, default: 0.0

  def self.from_hash(hash)
    new.tap do |unit|
      hash.each do |key, val|
        unit.send("#{key}=".to_sym, val)
      end
    end
  end

  def self.get_availability(id, start_date, end_date)
    search = Escapia::UnitCalendarAvailability.new
    response = search.execute(
      unit_id: id,
      start_date: start_date,
      end_date: end_date
    )
    response[:unit_calendar_avail_segments][:unit_calendar_avail_segment][:daily_availability]
  end

  def self.get(id, amount)
    search   = Escapia::UnitDescriptiveInfo.new
    response = search.execute(unit_id: id)
    content  = response[:unit_descriptive_contents][:unit_descriptive_content]
    info     = content[:unit_info]
    create_from_results(
      address:       info[:address],
      amenities:     info[:unit_amenity],
      services:      info[:services].nil? ? [] : info[:services][:service].map { |service| service[:descriptive_text] },
      code:          content[:@unit_code],
      descriptions:  info[:descriptions],
      name:          info[:unit_name],
      num_floors:    info[:@num_floors],
      occupancy:     info[:@max_occupancy],
      position:      info[:position],
      reviews:       content[:unit_reviews],
      rooms:         info[:category_codes][:room_info],
      type_code:     info[:category_codes][:unit_category][:@code],
      beachfront:    has_beachfront?(info),
      pets:          allows_pets?(content[:policies][:policy][:pets_policies][:@pets_allowed_code]),
      preview_amount:   amount
    )
  end

  def self.search(*criteria)
    search   = Escapia::UnitSearch.new
    response = search.execute(*criteria)
    if response[:units]
      record = response[:units][:unit]
      if record.is_a?(Array)
        return record.map do |unit|
          {
            code: unit[:@unit_code],
            preview_amount: unit[:rate_range][:@fixed_rent].present? && !criteria[0][:date_range].nil? ? unit[:rate_range][:@fixed_rent] : 0.0,
            pets: unit[:unit_summary][:pets_policies][:@pets_allowed_code] != "Pets Not Allowed"
          }.with_indifferent_access
        end
      else
        [
          {
            code: record[:@unit_code],
            preview_amount: record[:rate_range][:@fixed_rent].present? && !criteria[0][:date_range].nil? ? record[:rate_range][:@fixed_rent] : 0.0,
            pets: record[:unit_summary][:pets_policies][:@pets_allowed_code] != "Pets Not Allowed"
          }.with_indifferent_access
        ]
      end
    end
    []
  end

  def self.create_from_results(address:,
                               amenities:,
                               services:,
                               code:,
                               descriptions:,
                               name:,
                               num_floors:,
                               occupancy:,
                               position:,
                               reviews:,
                               rooms:,
                               type_code:,
                               beachfront:,
                               pets:,
                               preview_amount:)
    unit = new
    unit.type         = UnitType.from_code(type_code)
    unit.code         = code
    unit.name         = name
    unit.num_floors   = num_floors.to_i unless num_floors.nil?
    unit.occupancy    = occupancy.to_i
    unit.amenities    = UnitAmenities.from_codes(amenities, services, pets)
    unit.descriptions = UnitDescriptions.from_descriptions(descriptions)
    unit.bathrooms    = UnitRooms.count_for_code(:bathrooms, rooms)
    unit.bedrooms     = UnitRooms.count_for_code(:bedrooms, rooms)
    unit.reviews      = UnitReviews.from_response(reviews)
    unit.beachfront   = beachfront
    unit.pets         = pets
    unit.preview_amount  = preview_amount 

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
    descriptions.videos.map { |i| i[:formats] }
  end

  private

  def self.has_beachfront?(info)
    info[:category_codes][:custom_category_group].any? do |custom_category|
      flatten_nested_hash(custom_category).has_value?("Beachfront")
    end
  end

  def self.allows_pets?(info)
    info == 'Pets Allowed'
  end
end
