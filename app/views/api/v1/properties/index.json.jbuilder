# frozen_string_literal: true

json.units do
  json.array! @units do |unit|
    json.partial! 'api/v1/shared/unit', unit:
  end
end
