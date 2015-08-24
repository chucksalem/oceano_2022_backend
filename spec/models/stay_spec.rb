require 'rails_helper'

describe Stay do
  describe 'fields' do
    it { expect(described_class).to have_attribute(:base_amount).of_type(Float) }
    it { expect(described_class).to have_attribute(:total_amount).of_type(Float) }
    it { expect(described_class).to have_attribute(:fees).of_type(Array) }
    it { expect(described_class).to have_attribute(:taxes).of_type(Array) }
  end

  let(:fixtures_path) { Rails.root.join('spec', 'fixtures') }

  describe '#stay' do
    let(:response) { File.read(File.join(fixtures_path, 'units', 'unit_stay.xml')) }

    it 'loads a single unit descriptive lookup' do

      stub_escapia(status: 200, body: response)
      stay = Stay.lookup('123', start_date: Date.today, end_date: Date.tomorrow, guests: 1)
      expect(stay.base_amount).to eq(2999.99)
      expect(stay.fees.size).to eq(2)
      expect(stay.taxes.size).to eq(1)
    end
  end

  describe Stay::Tax do
    describe 'fields' do
      it { expect(described_class).to have_attribute(:amount).of_type(Float) }
    end
  end
  
  describe Stay::Fee do
    describe 'fields' do
      it { expect(described_class).to have_attribute(:name).of_type(String) }
      it { expect(described_class).to have_attribute(:amount).of_type(Float) }
      it { expect(described_class).to have_attribute(:currency_code).of_type(String) }
      it { expect(described_class).to have_attribute(:mandatory) }
    end
  end
end
