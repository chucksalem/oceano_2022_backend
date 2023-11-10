# frozen_string_literal: true

class UpdateForecastJob < ApplicationJob
  queue_as :default

  def perform(*_args)
    c = CacheForecast.new(
      config: OceanoConfig,
      logger: Logger.new($stdout),
      redis: RedisClient
    )
    c.perform!
  end
end
