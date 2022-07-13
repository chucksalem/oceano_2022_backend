json.units do
  json.array! @units do |unit|
    json.partial! 'api/v1/shared/unit', unit: unit
  end
end