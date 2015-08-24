require 'rails_helper'

describe Unit do
  describe 'fields' do
    it { expect(described_class).to have_attribute(:address).of_type(UnitAddress) }
    it { expect(described_class).to have_attribute(:amenities).of_type(UnitAmenities) }
    it { expect(described_class).to have_attribute(:bathrooms).of_type(Integer) }
    it { expect(described_class).to have_attribute(:code).of_type(String) }
    it { expect(described_class).to have_attribute(:name).of_type(String) }
    it { expect(described_class).to have_attribute(:num_floors).of_type(Integer) }
    it { expect(described_class).to have_attribute(:occupancy).of_type(Integer) }
    it { expect(described_class).to have_attribute(:position).of_type(UnitPosition) }
    it { expect(described_class).to have_attribute(:type).of_type(Symbol) }
    it { expect(described_class).to have_attribute(:descriptions).of_type(UnitDescriptions) }
  end

  let(:fixtures_path) { Rails.root.join('spec', 'fixtures') }

  describe '#get' do
    let(:code) { '1911-89479' }
    let(:response) { File.read(File.join(fixtures_path, 'units', 'unit_descriptive_info.xml')) }

    it 'loads a single unit descriptive lookup' do
      stub_escapia(status: 200, body: response)
      unit = Unit.get(code)

      expect(unit.code).to eq(code)
      expect(unit.name).to eq('Hacienda del Mar - Courtyard')
      expect(unit.num_floors).to eq(1)
      expect(unit.bedrooms).to eq(1)
      expect(unit.bathrooms).to eq(1)
      expect(unit.type).to eq(:apartment)
      expect(unit.descriptions.videos.count).to eq(1)
      expect(unit.descriptions.images.count).to eq(9)
      expect(unit.descriptions.text.count).to eq(3)
    end
  end

  describe '#search' do
    let(:response) { File.read(File.join(fixtures_path, 'units', 'unit_search.xml')) }

    it 'loads a single unit descriptive lookup' do
      stub_escapia(status: 200, body: response)
      units = Unit.search(address: { country: 'MX' })

      expect(units.size).to eq(55)
      expect(units.first).to eq('1911-89479')
    end
  end
end
