class Weather
  def self.get
    raw = RedisClient.get('weather')
    return {} if raw.nil?
    MultiJson.load(raw, symbolize_keys: true)
  end
end
