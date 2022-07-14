class UnitRepository
  include Hashable

  TTL_SECONDS = (24 * 60 * 60).freeze

  def self.stay(code, criteria)
    Stay.lookup(code, criteria)
  end

  def self.search(criteria)
    key   = "search:#{hash_to_key(criteria)}"
    value = redis.get(key)
    return MultiJson.load(value) unless value.nil?
    values = Unit.search(criteria)
    values.each do |value|
      redis.setex(value["code"], TTL_SECONDS, MultiJson.dump(value["code"]))
      raw = redis.get("units:#{value["code"]}")
      next if raw.nil?
      hash = MultiJson.load(raw, symbolize_keys: true)
      unit = Unit.from_hash(hash)
      unit.preview_amount = value["preview_amount"]
      redis.setex("units:#{value["code"]}", TTL_SECONDS, MultiJson.dump(unit))
      redis.sadd('temp:units:all', value["code"])
    end
    values
  end

  def self.units_in_area(areas)
    keys = []
    areas.map do |key|
      key = redis.smembers("areas:#{key}")
      keys.push(key)
    end
    keys.flatten
  end

  def self.get(code)
    raw = redis.get("units:#{code}")
    raise Unit::NotFound if raw.nil?
    hash = MultiJson.load(raw, symbolize_keys: true)
    Unit.from_hash(hash)
  end

  def self.get_filters()
    keys = redis.keys('*')
    keys = keys.select {|key| key.include? "areas:"}
    keys.map {|key| key.sub!('areas:', '')} 
  end

  def self.random_units(limit: 2, except: [])
    except_keys = except.map { |code| "units:#{code}" }
    all         = redis.keys('units:*') - except_keys
    units       = all.sample(limit).map! { |k| self.get(k.sub('units:', '')) }
  end

  def self.hash_to_key(hash)
    flatten_nested_hash(hash).flatten.join(':')
  end

  def self.redis
    RedisClient
  end
end
