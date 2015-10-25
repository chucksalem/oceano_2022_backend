module Escapia
  class UnitStay < Request
    def operation
      :unit_stay
    end

    def payload(criteria)
      builder do |xml|
        envelope(xml) do
          unit_stay(xml) do
            auth(xml)
            stay_criteria(xml, criteria)
          end
        end
      end
    end

    private

    def unit_stay(xml, &blk)
      attrs = {
        'TransactionIdentifier' => identifier,
        'EchoToken'             => 'request',
        'Version'               => '1.0',
        'MaxResponses'          => '2147483647',
        'SortOrder'             => 'P',
        'xmlns'                 => 'http://www.escapia.com/EVRN/2007/02',
        'xmlns:xsi'             => 'http://www.w3.org/2001/XMLSchema-instance',
        'xmlns:xsd'             => 'http://www.w3.org/2001/XMLSchema'
      }

      xml.EVRN_UnitStayRQ(attrs, &blk)
    end

    def stay_criteria(xml, criteria)
      xml.UnitStay('AvailabilityOnlyIndicator' => false) do
        xml.UnitRef('UnitCode' => criteria[:unit_code])
        guests(xml, criteria)
        date_range(xml, criteria)
      end
    end

    def date_range(xml, criteria)
      return if criteria[:date_range].nil?

      start_date = criteria[:date_range][:start]
      end_date   = criteria[:date_range][:end]
      xml.StayDateRange('Start' => start_date.strftime('%-m/%-d/%Y'), 'End' => end_date.strftime('%-m/%-d/%Y'))
    end

    def guests(xml, criteria)
      return if criteria[:guests].nil?

      xml.GuestCounts do
        criteria[:guests].each do |guest|
          xml.GuestCount('AgeQualifyingCode' => guest[:type], 'Count' => guest[:count])
        end
      end
    end
  end
end
