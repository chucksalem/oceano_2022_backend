namespace :oceano do
  namespace :cache do
    task update: :environment do
      c = CachePopulator.new(
        config: OceanoConfig, 
        logger: Rails.logger,
        redis:  RedisClient
      )
      c.perform!
    end
  end
end
