class CacheProperties
  def initialize(config:, logger:, redis:)
    @config = config
    @redis  = redis
    @logger = logger
  end

  def perform!
    delete_all_area_keys
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
      if !unit.address.street.nil?
        street = get_street_name(unit.address.street)
        area_key  = area_key_from_name(street)
        old_codes = redis.sdiff(area_key, all_units_key)
        next if old_codes.empty?
        redis.srem(area_key, old_codes)
      end
    end
    logger.info('Done.')
  end

  def group_by_area(units)
    logger.info('Grouping by area...')
    touched_areas = []
    units.each do |unit|
      if !unit.address.street.nil?
        street = get_street_name(unit.address.street)
        set_key = area_key_from_name(street)
        redis.sadd(set_key, unit.code)
        touched_areas << set_key
      end
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
      rescue
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

  def delete_all_area_keys
    keys = redis.keys('*')
    keys = keys.select {|key| key.include? "areas:"}
    keys.map { |key| redis.del(key) }
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
    if name.is_a?(Array)
      area_key(name.join('_').tr(' ', '_').underscore)
    else
      area_key(name.tr(' ', '_').underscore)
    end
  end

  def get_street_name(street)
    street = 'Las Conchas' if street == 'Section #7 Lot#106  Las Conchas'
    street = 'Playa Encanto' if street == 'Los Langostino, Playa Encanto'
    street
  end

  def get_street_name(street)
    street = 'Las Conchas' if street == 'Section #7 Lot#106  Las Conchas'
    street = 'Playa Encanto' if street == 'Los Langostino, Playa Encanto'
    street
  end
end
