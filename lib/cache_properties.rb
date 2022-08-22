class CacheProperties
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
      street = unit.address.street
      if street == 'section #7 lot#106  las conchas'
        street = 'Las Conchas'
      end
      if street == 'Los Langostino, Playa Encanto'
        street = 'Playa Encanto'
      end
      area_key  = area_key_from_name(street)
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
      street = unit.address.street
      if street == 'section #7 lot#106  las conchas'
        street = 'Las Conchas'
      end
      if street == 'Los Langostino, Playa Encanto'
        street = 'Playa Encanto'
      end
      set_key = area_key_from_name(street)
      redis.sadd(set_key, unit.code)
      touched_areas << set_key
    end

    logger.info('Done.')
  end

  def fetch_all_units(values)
    logger.info('Fetching units...')
    units = values.map do |value|
      logger.info(value["code"])
      begin
        unit = Unit.get(value["code"], value["preview_amount"])
        redis.set(unit_key(value["code"]), MultiJson.dump(unit))
        redis.sadd(all_units_key, value["code"])
        unit
      rescue => error
        p error
        logger.error("skipping #{value["code"]}")
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
    "areas:#{slug.gsub('_', ' ').gsub('/ ', '/')}"
  end

  def area_key_from_name(name)
    area_key(name.tr(' ', '_').underscore)
  end
end
