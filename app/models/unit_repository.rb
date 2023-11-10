# frozen_string_literal: true

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
      redis.set(value['code'], MultiJson.dump(value['code']))
      raw = redis.get("units:#{value['code']}")
      next if raw.nil?

      hash = MultiJson.load(raw, symbolize_keys: true)
      unit = Unit.from_hash(hash)
      unit.preview_amount = value['preview_amount']
      unit.temporary_amount = value['preview_amount']
      redis.set("units:#{value['code']}", MultiJson.dump(unit))
      redis.sadd('temp:units:all', value['code'])
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

    raw = redis.mget(codes.map { |k| "units:#{k.unit_id}" })
    raw.map do |item|
      hash = MultiJson.load(item, symbolize_keys: true)
      unit = Unit.from_hash(hash)
      {
        unit:,
        text: codes.find { |c| c.unit_id == unit.code }.text
      }
    end
  end

  def self.get_filters
    keys = redis.keys('*')
    keys = keys.select { |key| key.include? 'areas:' }
    keys.map { |key| key.sub!('areas:', '') }
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
      unit.temporary_amount = unit.preview_amount
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

  def self.closest_units(amount, loc, except: [])
    except_keys = except.map { |code| "units:#{code}" }
    all         = redis.keys('units:*') - except_keys
    distances = []
    all.each do |key|
      unit = get(key.sub('units:', ''))
      unit.temporary_amount = unit.preview_amount
      unit.preview_amount = 0
      value = {
        unit:,
        distance: distance(loc, [unit.position.latitude, unit.position.longitude])
      }
      distances.push(value)
    end
    distances = distances.sort_by { |value| value[:distance] }
    units = distances.map { |value| value[:unit] }
    units.slice(0, amount)
  end

  def self.distance(loc1, loc2)
    rad_per_deg = Math::PI / 180
    rm = 6371 * 1000

    dlat_rad    = (loc2[0] - loc1[0]) * rad_per_deg
    dlon_rad    = (loc2[1] - loc1[1]) * rad_per_deg

    lat1_rad    = loc1.map { |i| i * rad_per_deg }.first
    lat2_rad    = loc2.map { |i| i * rad_per_deg }.first

    a           = Math.sin(dlat_rad / 2)**2 + Math.cos(lat1_rad) * Math.cos(lat2_rad) * Math.sin(dlon_rad / 2)**2
    c           = 2 * Math.atan2(Math.sqrt(a), Math.sqrt(1 - a))

    rm * c # Distance in meters
  end
end
