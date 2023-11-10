# frozen_string_literal: true

require 'rails_helper'

describe Escapia::UnitDescriptiveInfo do
  let(:username) { 'bob_username' }
  let(:password) { 'bob_password' }
  let(:unit_id)  { 'abc123' }

  let(:opts) do
    { namespaces: { evrn: 'http://www.escapia.com/EVRN/2007/02' } }
  end

  subject { Escapia::UnitDescriptiveInfo.new(username:, password:) }

  context 'xml' do
    it 'builds unit lookup' do
      body = subject.payload(unit_id:).to_xml
      expect(body).to have_xpath(xpath: '//evrn:EVRN_UnitDescriptiveInfoRQ', opts:)
      expect(body).to have_xpath(xpath: %(//evrn:UnitDescriptiveInfo[@UnitCode="#{unit_id}"]), opts:)
    end
  end
end
