namespace :oceano do
  namespace :cache do
    task properties: :environment do
      c = CacheProperties.new(
        config: OceanoConfig,
        logger: Logger.new(STDOUT),
        redis:  RedisClientGlobal

      )
      c.perform!
    end

    task weather: :environment do
      c = CacheForecast.new(
        config: OceanoConfig,
        logger: Logger.new(STDOUT),
        redis:  RedisClientGlobal
      )
      c.perform!
    end
  end
end
