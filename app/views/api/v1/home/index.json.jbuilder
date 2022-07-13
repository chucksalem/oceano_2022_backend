json.units do
  json.array! @random_units do |unit|
    json.partial! 'api/v1/shared/unit', unit: unit
  end
end