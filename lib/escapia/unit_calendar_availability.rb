module Escapia
  class UnitCalendarAvailability < Request
    def operation
      :unit_calendar_avail
    end

    def payload(unit_id:, start_date:, end_date:)
      builder do |xml|
        envelope(xml) do
          unit_calendar_avail(xml) do
            auth(xml)
            xml.UnitRef('UnitCode' => unit_id)
            xml.CalendarDateRange('Start' => start_date,
                                  'End'   => end_date)
          end
        end
      end
    end

    private

    def unit_calendar_avail(xml, &blk)
      attrs = {
        'TransactionIdentifier' => identifier,
        'EchoToken'             => 'request',
        'Version'               => '1.0',
        'xmlns'                 => 'http://www.escapia.com/EVRN/2007/02'
      }

      xml.EVRN_UnitCalendarAvailRQ(attrs, &blk)
    end
  end
end
