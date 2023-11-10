# frozen_string_literal: true

json.unit do
  json.id @unit.code
  json.extract! @unit, :address, :name, :type, :bedrooms, :bathrooms, :occupancy, :position, :videos
  json.longDescription @unit.descriptions[:text][0][:description]
  json.availableAmenities @unit.amenities
  json.partial! 'api/v1/shared/stay'
  json.standardImages @unit.standard_images
  json.largeImages @unit.large_images
  json.previewAmount @unit.preview_amount
  json.reviews do
    json.array! @reviews do |review|
      json.partial! 'api/v1/shared/review', review:
    end
  end
  json.nearbyProperties do
    json.array! @random_units do |unit|
      json.partial! 'api/v1/shared/unit', unit:
    end
  end
end
