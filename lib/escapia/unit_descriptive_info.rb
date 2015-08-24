module Escapia
  class UnitDescriptiveInfo < Request
    def operation
      :unit_descriptive_info
    end

    def payload(unit_id:)
      builder do |xml|
        envelope(xml) do
          unit_descriptive_info(xml) do
            auth(xml)
            xml.UnitDescriptiveInfos do
              xml.UnitDescriptiveInfo('UnitCode' => unit_id) do
                xml.UnitInfo
                xml.Policies
                xml.UnitReviews('SendReviews' => true)
                xml.Promotions('SendPromotions' => true)
              end
            end
          end
        end
      end
    end

    private

    def unit_descriptive_info(xml, &blk)
      attrs = {
        'TransactionIdentifier' => identifier,
        'EchoToken'             => 'request',
        'Version'               => '1.0',
        'xmlns'                 => 'http://www.escapia.com/EVRN/2007/02'
      }

      xml.EVRN_UnitDescriptiveInfoRQ(attrs, &blk)
    end
  end
end
