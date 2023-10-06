class UpdateForecastJob < ApplicationJob
  queue_as :default

  def perform(*args)
    c = CacheForecast.new(
      config: OceanoConfig, 
      logger: Logger.new(STDOUT),
      redis:  RedisClient
    )
    c.perform!
  end
end
