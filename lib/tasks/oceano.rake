namespace :oceano do
  namespace :cache do
    task properties: :environment do
      c = CacheProperties.new(
        config: OceanoConfig, 
        logger: Rails.logger,
        redis:  RedisClient
      )
      c.perform!
    end

    task weather: :environment do
      c = CacheForecast.new(
        config: OceanoConfig, 
        logger: Rails.logger,
        redis:  RedisClient
      )
      c.perform!
    end
  end
end
