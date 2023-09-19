class UnitsFetchJob < ApplicationJob
  queue_as :default

  def perform
    ::CacheProperties.new(
      config: OceanoConfig,
      logger: Logger.new(STDOUT),
      redis: RedisClientGlobal
    ).perform!
  end
end
