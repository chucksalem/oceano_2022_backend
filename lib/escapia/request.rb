require 'securerandom'

module Escapia
  class Request
    class Error < StandardError; end

    def initialize(username: ENV['ESCAPIA_USERNAME'], password: ENV['ESCAPIA_PASSWORD'], client: EscapiaClient)
      @username = username
      @password = password
      @client   = client
    end

    def execute(*kwargs)
      response = client.call(operation, xml: payload(*kwargs).to_xml)

      if ENV['RECORD_ESCAPIA']
        File.open(Rails.root.join('tmp', "#{operation}-#{Time.now.iso8601}.xml"), 'w') do |f|
          f.write(response.http.raw_body.force_encoding('UTF-8'))
        end
      end

      body = response.body["evrn_#{operation}_rs".to_sym]
      fail Error.new(body[:errors][:error]) if body.key?(:errors)
      body
    end

    def payload
      fail NotImplementedError.new('requests must implement payload')
    end

    def operation
      fail NotImplementedError.new('requests must implement operation')
    end

    private

    def builder(&blk)
      Nokogiri::XML::Builder.new(&blk)
    end

    def identifier
      SecureRandom.uuid
    end

    def envelope(xml, &blk)
      xml['s'].Envelope('xmlns:s' => 'http://schemas.xmlsoap.org/soap/envelope/') do
        xml['s'].Body(&blk)
      end
    end

    def auth(xml)
      xml.POS do
        xml.Source do
          xml.RequestorID('ID' => username, 'MessagePassword' => password)
        end
      end
    end

    attr_reader :username, :password, :client
  end
end
