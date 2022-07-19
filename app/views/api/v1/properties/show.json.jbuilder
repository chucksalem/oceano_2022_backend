json.unit do
  json.id @unit.code
  json.extract! @unit, :address, :name, :type, :pets, :bedrooms, :bathrooms, :occupancy, :position, :reviews, :videos
  json.longDescription @unit.descriptions[:text][0][:description]
  json.availableAmenities @unit.amenities
  json.partial! 'api/v1/shared/stay'
  json.standardImages @unit.standard_images
  json.largeImages @unit.large_images
  json.nearbyProperties do
    json.array! @random_units do |unit|
      json.partial! 'api/v1/shared/unit', unit: unit
    end
  end
end
