require 'rails_helper'

describe Escapia::UnitSearch do
  let(:username) { 'bob_username' }
  let(:password) { 'bob_password' }

  let(:opts) do
    { namespaces: { evrn: 'http://www.escapia.com/EVRN/2007/02' } }
  end

  subject { Escapia::UnitSearch.new(username: username, password: password) }

  context 'xml' do
    it 'builds address' do
      city     = 'Raleigh'
      state    = 'NC'
      country  = 'US'
      criteria = { address: { city: city, state: state, country: country } }
      body     = subject.payload(criteria).to_xml

      expect(body).to have_xpath(xpath: '//evrn:EVRN_UnitSearchRQ', opts: opts)
      expect(body).to have_xpath(xpath: '//evrn:CityName', value: city, opts: opts)
      expect(body).to have_xpath(xpath: %(//evrn:StateProv[@StateCode="#{state}"]), opts: opts)
      expect(body).to have_xpath(xpath: %(//evrn:CountryName[@Code="#{country}"]), opts: opts)
    end

    it 'builds date range' do
      start_date = Date.today
      end_date   = Date.tomorrow
      criteria   = { date_range: { start: start_date, end: end_date } }
      body       = subject.payload(criteria).to_xml

      expect(body).to have_xpath(xpath: '//evrn:EVRN_UnitSearchRQ', opts: opts)
      expect(body).to have_xpath(xpath: %(//evrn:StayDateRange[@Start="#{start_date.strftime('%m/%d/%Y')}"]), opts: opts)
      expect(body).to have_xpath(xpath: %(//evrn:StayDateRange[@End="#{end_date.strftime('%m/%d/%Y')}"]), opts: opts)
    end

    it 'builds rate range' do
      min      = 0
      max      = 1000
      criteria = { rate_range: { min: min, max: max } }
      body     = subject.payload(criteria).to_xml

      expect(body).to have_xpath(xpath: '//evrn:EVRN_UnitSearchRQ', opts: opts)
      expect(body).to have_xpath(xpath: %(//evrn:MaxRate), value: max.to_s, opts: opts)
      expect(body).to have_xpath(xpath: %(//evrn:MinRate), value: min.to_s, opts: opts)
    end

    it 'builds guests' do
      type     = 10
      count    = 4
      criteria = { guests: [{ type: type, count: count }] }
      body     = subject.payload(criteria).to_xml

      expect(body).to have_xpath(xpath: '//evrn:EVRN_UnitSearchRQ', opts: opts)
      expect(body).to have_xpath(xpath: %(//evrn:GuestCount[@AgeQualifyingCode="#{type}"]), opts: opts)
      expect(body).to have_xpath(xpath: %(//evrn:GuestCount[@Count="#{count}"]), opts: opts)
    end

    it 'builds rooms' do
      type     = 55 # bedrooms
      count    = 2
      criteria = { rooms: { type: type, count: count } }
      body     = subject.payload(criteria).to_xml

      expect(body).to have_xpath(xpath: '//evrn:EVRN_UnitSearchRQ', opts: opts)
      expect(body).to have_xpath(xpath: %(//evrn:Code), value: type.to_s, opts: opts)
      expect(body).to have_xpath(xpath: %(//evrn:Fixed), value: count.to_s, opts: opts)
    end

    it 'builds pets' do
      criteria = { pets: { allowed: true } }
      body     = subject.payload(criteria).to_xml

      expect(body).to have_xpath(xpath: '//evrn:EVRN_UnitSearchRQ', opts: opts)
      expect(body).to have_xpath(xpath: %(//evrn:PetsPolicies[@PetsAllowedCode="Pets Allowed"]), opts: opts)
    end
  end
end
