# frozen_string_literal: true

class UpdateUnitsJob < ApplicationJob
  queue_as :default

  def perform(*_args)
    c = CacheProperties.new(
      config: OceanoConfig,
      logger: Logger.new($stdout),
      redis: RedisClient
    )
    c.perform!
  end
end
