module Api
  module V1
    class PropertiesController < BaseController
      DATE_FORMAT = '%m/%d/%Y'.freeze

      def index
        @area       = params[:area] || 'all'
        @start_date = params[:start_date]
        @end_date   = params[:end_date]
        @adults     = params[:adults]
        @kids       = params[:kids]
        @pets       = params[:pets]
        @exact_dates  = params[:exact_dates]
        @sort         = params[:sort] || 'P'

        if is_search_request
          @units = search_results
        else
          @units = UnitRepository.all_units
        end
      end

      def filters
        @areas = UnitRepository.get_filters
        @amenities = UnitAmenities::AMENITIES
        @types = UnitType::TYPES
      end

      def show
        @id                = params[:id]
        @booking_id        = params[:id].to_str.split('-', 2).last
        @unit              = UnitRepository.get(@id)
        @unit.reviews      = @unit.reviews.compact
        @property_title    = @unit.name
        @address           = @unit.address
        @amenities         = @unit.available_amenities
        @guests            = (params[:adults] || 1)+ (params[:kids] || 0)
        @guest_amount_list = (1..@unit.occupancy).map { |v| v }
        @start_date        = !params[:start_date].blank? ? params[:start_date] : (Date.today + 1.day ).strftime(DATE_FORMAT)
        @end_date          = !params[:end_date].blank?   ? params[:end_date]   : (Date.today + 8.days).strftime(DATE_FORMAT)
        @random_units      = UnitRepository.random_units(limit: 3, except: [@id])
        @reviews           = Review.where(unit_id: @id)

        lookup_rates if [:start_date, :end_date, :adults].all? { |k| params.key?(k) && !params[k].nil? }
        get_images
      end

      def stay 
        @id = params[:id]
        @start_date        = params[:start_date].present? ? params[:start_date] : 1.day.from_now.strftime(DATE_FORMAT)
        @end_date          = params[:end_date].present?   ? params[:end_date]   : 8.days.from_now.strftime(DATE_FORMAT)
        @guests            = (params[:adults] || 1) + (params[:kids] || 0)
        lookup_rates
      end

      def calendar_availability
        @id = params[:id]
        @start_date = params[:start_date]
        @end_date = params[:end_date]
        @availability = Unit.get_availability(@id, @start_date, @end_date)
      end

      private

      def is_search_request
        [:area, :start_date, :end_date, :adults, :kids, :pets, :exact_dates].any? { |k| params.dig(k).present? }
      end

      def is_not_present?(param)
        [nil, '', 'all'].include?(param)
      end

      def search_results
        start_date, end_date = params[:start_date], params[:end_date]
        date_range =
          if [start_date, end_date].all?(&:present?)
            {
              start:  Date.strptime(start_date, DATE_FORMAT),
              end:    Date.strptime(end_date, DATE_FORMAT)
            }
          end

        values = []
        OceanoConfig[:cache_population_searches].each do |criteria|
          criteria[:sort] = params[:sort].present? && params[:sort] != '-' ? params[:sort] : 'G'
          exact_dates = params[:exact_dates].to_i
          if date_range
            criteria[:date_range] = date_range
          else
            criteria.delete(:date_range)
          end
          unless is_not_present?(params[:adults]) && is_not_present?(params[:kids])
            criteria[:guests] = [{type: 10, count: params[:adults]},{type: 8, count: params[:kids]}]
          end
          if date_range && exact_dates > 0
            start_at, end_at = [Date.strptime(start_date, DATE_FORMAT), Date.strptime(end_date, DATE_FORMAT)]
            
            if start_at > Date.today + 2.days
              exact_dates_list = (exact_dates*-1..exact_dates)
            else
              exact_dates_list = (1..exact_dates)
            end
            repeated_list = exact_dates_list.map{|item| {start: start_at + item.days, end:  end_at + item.days}}

            repeated_list.each do |item|
              criteria[:date_range] = item
              values += UnitRepository.search(criteria)
            end
          else
            values += UnitRepository.search(criteria)
          end
        end
        unless is_not_present?(params[:pets])
          values = pet_friendly_filter(values)
        end
        values = values.map {|v| v["code"]}
        values = values.uniq
        unless params[:area] == 'all' || params[:area].blank? || values.length == 0
          in_area_values = UnitRepository.units_in_area(params[:area])
          values = in_area_values.map {|code| values.select {|val| val == code }[0]}
        end
        values = values.compact
        units = []
        values.map do |value|
          begin
            unit = UnitRepository.get(value)
            units.push(unit)
          rescue Unit::NotFound
            next
          end      
        end
        units = units.compact
        units = apply_type_filter(units, params[:type])
        units = apply_amenities_filter(units, params[:amenities])
        units = min_filter(units, params[:min])
        units = max_filter(units, params[:max])
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
        @nightly_rate      = @rates.base_amount / @length_of_stay
        @base_amount       = @rates.base_amount
        @taxes             = @rates.taxes.map { |tax| tax.amount }
        @tax_amount        = @taxes.sum
        @fees              = @rates.fees
        @total_amount      = @rates.total_amount
      rescue Stay::Unavailable
        @available = false
      end

      def get_images
        @videos = @unit.videos
        @standard_images = @unit.standard_images
        @large_images = @unit.large_images
      end

      def apply_type_filter(units, types)
        return units if is_not_present?(types)
        units = units.select { |unit| types.include?(unit.type.to_s) }
      end

      def apply_amenities_filter(units, amenities)
        return units if is_not_present?(amenities)
        units = units.select { |unit| amenities.map {|amenity| unit.amenities[amenity]}.uniq == [true] }
      end

      def min_filter(units, min)
        return units if [nil, '', 'all'].include?(min)

        units = units.map do |unit|
          next unless unit.preview_amount >= min

          unit
        end
        units.compact
      end

      def max_filter(units, max)
        return units if [nil, '', 'all'].include?(max)
        
        units = units.map do |unit|
          next unless unit.preview_amount <= max

          unit
        end
        units.compact
      end

      def pet_friendly_filter(values)
        values.select { |value| value["pets"] }
      end

    end
  end
end
