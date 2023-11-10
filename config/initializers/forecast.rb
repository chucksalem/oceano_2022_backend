# frozen_string_literal: true

ForecastIO.configure do |configuration|
  configuration.api_key = ENV['FORECASTIO_API_KEY']
end
