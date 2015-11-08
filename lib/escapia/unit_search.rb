module Escapia
  class UnitSearch < Request
    def operation
      :unit_search
    end

    def payload(criteria)
      builder do |xml|
        envelope(xml) do
          unit_search(xml, criteria) do
            auth(xml)
            search_criteria(xml, criteria)
          end
        end
      end
    end

    private

    def unit_search(xml, criteria, &blk)
      attrs = {
        'TransactionIdentifier' => identifier,
        'EchoToken'             => 'request',
        'Version'               => '1.0',
        'MaxResponses'          => '2147483647',
        'SortOrder'             => criteria[:sort],
        'xmlns'                 => 'http://www.escapia.com/EVRN/2007/02',
        'xmlns:xsi'             => 'http://www.w3.org/2001/XMLSchema-instance',
        'xmlns:xsd'             => 'http://www.w3.org/2001/XMLSchema'
      }

      xml.EVRN_UnitSearchRQ(attrs, &blk)
    end

    def search_criteria(xml, criteria)
      xml.Criteria('AvailableOnlyIndicator' => true) do
        xml.Criterion do
          address(xml, criteria)
          guests(xml, criteria)
          date_range(xml, criteria)
          rate_range(xml, criteria)
          rooms(xml, criteria)
          pets(xml, criteria)
        end
      end
    end

    def address(xml, criteria)
      return if criteria[:address].nil?

      city    = criteria[:address][:city]
      state   = criteria[:address][:state]
      country = criteria[:address][:country]

      xml.Address do
        xml.CityName(city)                  unless city.nil?
        xml.StateProv('StateCode' => state) unless state.nil?
        xml.CountryName('Code' => country)  unless country.nil?
      end
    end

    def rate_range(xml, criteria)
      return if criteria[:rate_range].nil?

      min = criteria[:rate_range][:min]
      max = criteria[:rate_range][:max]

      xml.RateRange do
        xml.MinRate(min) unless min.nil?
        xml.MaxRate(max) unless max.nil?
      end
    end

    def date_range(xml, criteria)
      return if criteria[:date_range].nil?

      start_date = criteria[:date_range][:start]
      end_date   = criteria[:date_range][:end]

      xml.StayDateRange('Start' => start_date.strftime('%-m/%-d/%Y'),
                        'End'   => end_date.strftime('%-m/%-d/%Y')) do
      end
    end

    def pets(xml, criteria)
      return if criteria[:pets].nil?

      allowed  = criteria[:pets][:allowed] || true
      policies = criteria[:pets][:policies] || []

      xml.PetsPolicies('PetsAllowedCode' => allowed ? 'Pets Allowed' : 'Pets Not Allowed') do
        policies.each do |policy|
          xml.PetsPolicy('Code' => policy)
        end
      end
    end

    def guests(xml, criteria)
      return if criteria[:guests].nil?

      xml.UnitStayCandidate do
        xml.GuestCounts do
          criteria[:guests].each do |guest|
            xml.GuestCount('AgeQualifyingCode' => guest[:type], 'Count' => guest[:count])
          end
        end
      end
    end

    def rooms(xml, criteria)
      return if criteria[:rooms].nil?

      type  = criteria[:rooms][:type]
      count = criteria[:rooms][:count]

      xml.UnitStayCandidate do
        xml.RoomCounts do
          xml.RoomCount do
            xml.Code(type)   unless type.nil?
            xml.Fixed(count) unless count.nil?
          end
        end
      end
    end
  end
end
