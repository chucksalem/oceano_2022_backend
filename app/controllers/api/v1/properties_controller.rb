module Api
  module V1
    class PropertiesController < BaseController
      DATE_FORMAT = '%m/%d/%Y'.freeze

      def index
        @area       = params[:area] || 'all'
        @start_date = params[:start_date]
        @end_date   = params[:end_date]
        @guests     = params[:guests]
        @beachfront = params[:beachfront] || 'all'
        @sort       = params[:sort] || 'P'

        if is_search_request
          @units = search_results
        else
          @units = UnitRepository.random_units(limit: 10)
        end
      end

      def properties
        @sort = params[:sort] || 'P'

        if is_search_request
          search_results
        else
          @units = UnitRepository.random_units(limit: 100)
        end
      end

      def show
        @id                = params[:id]
        @booking_id        = params[:id].to_str.split('-', 2).last
        @unit              = UnitRepository.get(@id)
        @property_title    = @unit.name
        @address           = @unit.address
        @amenities         = @unit.available_amenities
        @guests            = params[:guests] || 1
        @guest_amount_list = (1..@unit.occupancy).map { |v| v }
        @start_date        = !params[:start_date].blank? ? params[:start_date] : (Date.today + 1.day ).strftime(DATE_FORMAT)
        @end_date          = !params[:end_date].blank?   ? params[:end_date]   : (Date.today + 8.days).strftime(DATE_FORMAT)
        @random_units      = UnitRepository.random_units(limit: 3, except: [@id])

        lookup_rates if [:start_date, :end_date, :guests].all? { |k| params.key?(k) && !params[k].blank? }
        get_images
      end

      private

      def is_search_request
        [:area, :start_date, :end_date, :guests, :beachfront].any? { |k| params.dig(k).present? }
      end

      def search_results
        start_date, end_date, guests = params[:start_date], params[:end_date], params[:guests]
        date_range =
          if [start_date, end_date].all?(&:present?)
            {
              start:  Date.strptime(start_date, DATE_FORMAT),
              end:    Date.strptime(end_date, DATE_FORMAT)
            }
          end

        values = []
        OceanoConfig[:cache_population_searches].each do |criteria|
          criteria[:sort]       = params[:sort] || 'G'
          criteria[:sort]       = 'G' if criteria[:sort] == '-'
          if date_range
            criteria[:date_range] = date_range
          else
            criteria.delete(:date_range)
          end
          unless [nil, '', 'all'].include?(params[:guests])
            criteria[:guests] = [{type: 10, count: params[:guests]}]
          end
          values += UnitRepository.search(criteria)
        end

        values = values.uniq

        unless params[:area] == 'all' || params[:area].blank?
          in_area_codes = UnitRepository.units_in_area(params[:area])
          codes = codes & in_area_codes
        end
        units = []
        values.map do |value|
          begin
            unit = UnitRepository.get(value["code"])
            units.push(unit)
          rescue Unit::NotFound
            next
          end      
        end
        units = units.compact
        units = apply_beachfront_filter(units, params[:beachfront])
        @units = units
      end

      def lookup_rates
        @lookup         = true
        @available      = true
        start_date      = Date.strptime(@start_date, DATE_FORMAT)
        end_date        = Date.strptime(@end_date, DATE_FORMAT)
        @length_of_stay = end_date.mjd - start_date.mjd
        @guests         = @guests == "all" ? 1 : @guests

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

      def apply_beachfront_filter(units, beachfront)
        return units if %w(true false).exclude?(beachfront)

        method = beachfront == "true" ? :select : :reject
        units.public_send(method, &:beachfront)
      end
    end
  end
end