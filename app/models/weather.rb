class Weather
  def self.get
    raw = RedisClientGlobal.get('weather')
    return {} if raw.nil?
    MultiJson.load(raw, symbolize_keys: true)
  end
end
