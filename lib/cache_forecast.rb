class CacheForecast
  def initialize(config:, logger:, redis:)
    @latitude  = config[:weather][:latitude]
    @longitude = config[:weather][:longitude]
    @logger    = logger
    @redis     = redis
  end

  def perform!
    logger.info('Fetching weather...')
    forecast = ForecastIO.forecast(latitude, longitude)
    return if forecast.nil?
    redis.set('weather', MultiJson.dump(forecast))
    logger.info('Done.')
  end

  private

  attr_reader :latitude, :longitude, :logger, :redis
end
