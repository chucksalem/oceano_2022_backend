require 'rails_helper'

describe Escapia::UnitStay do
  let(:username) { 'bob_username' }
  let(:password) { 'bob_password' }
  let(:unit_id)  { 'abc123' }

  let(:opts) do
    { namespaces: { evrn: 'http://www.escapia.com/EVRN/2007/02' } }
  end

  subject { Escapia::UnitStay.new(username: username, password: password) }

  context 'xml' do
    it 'builds unit lookup' do
      body = subject.payload(unit_id: unit_id).to_xml
      expect(body).to have_xpath(xpath: '//evrn:EVRN_UnitStayRQ', opts: opts)
    end
  end
end
