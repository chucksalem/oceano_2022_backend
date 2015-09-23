class PropertiesController < ApplicationController
  DATE_FORMAT = '%m/%d/%Y'.freeze

  def index
    @units      = []
    @area       = params[:area] || '-'
    @start_date = params[:start_date]
    @end_date   = params[:end_date]
    @guests     = params[:guests] || '-'
    search_results && return if is_search_request
  end

	def show
		@id                = params[:id]
		@unit              = UnitRepository.get(@id)
		@property_title    = @unit.name
		@property_subtitle = @unit.address[:street]
		@amenities         = @unit.available_amenities
		@guests            = params[:guests] || 1
		@guest_amount_list = (1..@unit.occupancy).map { |v| v }
		@start_date        = params[:start_date] || Date.today.strftime(DATE_FORMAT)
		@end_date          = params[:end_date] || (Date.today + 7).strftime(DATE_FORMAT)
    @random_units      = UnitRepository.random_units(limit: 3, except: [@id])

		lookup_rates if [:start_date, :end_date, :guests].all? { |k| params.key?(k) }
		get_images
	end

  private

  def is_search_request
		[:area, :start_date, :end_date, :guests].all? { |k| params.key?(k) }
  end

  def search_results
    start_date = Date.strptime(params[:start_date], DATE_FORMAT)
    end_date   = Date.strptime(params[:end_date], DATE_FORMAT)

    codes = []
    OceanoConfig[:cache_population_searches].each do |criteria|
      criteria = criteria.merge(date_range: { start: start_date, end: end_date })
      codes += UnitRepository.search(criteria)
    end

    in_area_codes  = UnitRepository.units_in_area(params[:area])
    filtered_codes = codes & in_area_codes

    @units = filtered_codes.map do |c|
      UnitRepository.get(c)
    end
  end

	def lookup_rates
    @lookup         = true
    @available      = true
    start_date      = Date.strptime(@start_date, DATE_FORMAT)
    end_date        = Date.strptime(@end_date, DATE_FORMAT)
		@length_of_stay = end_date.mjd - start_date.mjd

		@rates = Stay.lookup(@id, 
                        start_date: start_date, 
                        end_date: end_date, 
                        guests: @guests)

		@nightly_rate      = '%.2f' % (@rates.base_amount / @length_of_stay)
		@base_amount       = '%.2f' % @rates.base_amount
		@tax_amount        = '%.2f' % @rates.taxes[0].amount
		@fees              = @rates.fees
		@total_amount      = '%.2f' % @rates.total_amount
  rescue Stay::Unavailable
    @available = false
	end

	def get_images
		@videos = @unit.videos
		@standard_images = @unit.standard_images
		@large_images = @unit.large_images
	end
end
