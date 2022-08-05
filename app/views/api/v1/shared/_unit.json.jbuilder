json.id unit.code
json.extract! unit, :address, :name, :type, :bedrooms, :bathrooms, :occupancy, :position, :beachfront, :pets
json.standardImages unit.standard_images
json.previewAmount unit.preview_amount
