class CacheProperties
  TTL_SECONDS = (24 * 60 * 60).freeze

  def initialize(config:, logger:, redis:)
    @config = config
    @redis  = redis
    @logger = logger
  end

  def perform!
    redis.del(all_units_key)
    units = fetch_all_units(fetch_all_codes)
    group_by_area(units)
    prune_groups(units)
  end

  private

  attr_reader :config, :logger, :redis

  def prune_groups(units)
    logger.info('Pruning uncached units from areas...')
    units.each do |unit|
      area_key  = area_key_from_name(unit.address.street)
      old_codes = redis.sdiff(area_key, all_units_key)
      next if old_codes.empty?
      redis.srem(area_key, old_codes)
    end
    logger.info('Done.')
  end

  def group_by_area(units)
    logger.info('Grouping by area...')
    touched_areas = []
    units.each do |unit|
      set_key = area_key_from_name(unit.address.street)
      redis.sadd(set_key, unit.code)
      touched_areas << set_key
    end

    touched_areas.uniq.each do |key|
      redis.expire(key, TTL_SECONDS)
    end
    logger.info('Done.')
  end

  def fetch_all_units(codes)
    logger.info('Fetching units...')
    units = codes.map do |code|
      logger.info(code)
      begin
        unit = Unit.get(code)
        redis.setex(unit_key(code), TTL_SECONDS, MultiJson.dump(unit))
        redis.sadd(all_units_key, code)
        unit
      rescue
        logger.error("skipping #{code}")
        nil
      end
    end

    units.compact.tap { |u| logger.info("Done. Found #{u.count} units.") }
  end

  def fetch_all_codes
    searches = config[:cache_population_searches]
    codes = searches.each_with_object([]) do |criteria, accum|
      accum.concat(Unit.search(criteria))
    end
    codes.uniq
  end

  def all_units_key
    'temp:units:all'
  end

  def unit_key(code)
    "units:#{code}"
  end

  def area_key(slug)
    "areas:#{slug}"
  end

  def area_key_from_name(name)
    area_key(name.tr(' ', '_').underscore)
  end
end
