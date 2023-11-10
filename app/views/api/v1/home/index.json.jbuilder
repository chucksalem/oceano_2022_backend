# frozen_string_literal: true

json.units do
  json.array! @random_units do |unit|
    json.partial! 'api/v1/shared/unit', unit: unit[:unit]
    json.text unit[:text]
  end
end
