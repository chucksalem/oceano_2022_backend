class UpdateUnitsJob < ApplicationJob
  queue_as :default

  def perform(*args)
    c = CacheProperties.new(
      config: OceanoConfig, 
      logger: Logger.new(STDOUT),
      redis:  RedisClient
    )
    c.perform!
  end
end
