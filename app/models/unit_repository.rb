class UnitRepository
  include Hashable

  def self.stay(code, criteria)
    Stay.lookup(code, criteria)
  end

  def self.search(criteria)
    key   = "search:#{hash_to_key(criteria)}"
    value = redis.get(key)
    return MultiJson.load(value) unless value.nil?
    values = Unit.search(criteria)
    values.each do |value|
      redis.set(value["code"], MultiJson.dump(value["code"]))
      raw = redis.get("units:#{value["code"]}")
      next if raw.nil?
      hash = MultiJson.load(raw, symbolize_keys: true)
      unit = Unit.from_hash(hash)
      unit.preview_amount = value["preview_amount"]
      redis.set("units:#{value["code"]}", MultiJson.dump(unit))
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

  def self.get_multiple(codes)
    return [] if codes.empty?
    raw = redis.mget(codes.map { |k| "units:#{k.unit_id}"})
    units = raw.map do |item|
      hash = MultiJson.load(item, symbolize_keys: true)
      unit = Unit.from_hash(hash) 
      {
        unit: unit,
        text: codes.find { |c| c.unit_id == unit.code }.text
      }
    end
  end

  def self.get_filters()
    keys = redis.keys('*')
    keys = keys.select {|key| key.include? "areas:"}
    keys.map {|key| key.sub!('areas:', '')} 
  end

  def self.random_units(limit: 2, except: [])
    except_keys = except.map { |code| "units:#{code}" }
    all         = redis.keys('units:*') - except_keys
    all.sample(limit).map do |k|
      {
        unit: get(k.sub('units:', '')),
        text: ''
      }
    end
  end

  def self.all_units
    all = redis.keys('units:*')
    all.map do |key|
      unit = get(key.sub('units:', ''))
      unit.preview_amount = 0
      unit
    end
  end

  def self.hash_to_key(hash)
    flatten_nested_hash(hash).flatten.join(':')
  end

  def self.redis
    RedisClient
  end
end
