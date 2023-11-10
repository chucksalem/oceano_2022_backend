# frozen_string_literal: true

namespace :oceano do
  namespace :cache do
    task properties: :environment do
      c = CacheProperties.new(
        config: OceanoConfig,
        logger: Logger.new($stdout),
        redis: RedisClient
      )
      c.perform!
    end

    task weather: :environment do
      c = CacheForecast.new(
        config: OceanoConfig,
        logger: Logger.new($stdout),
        redis: RedisClient
      )
      c.perform!
    end
  end
end
