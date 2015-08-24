require 'rails_helper'

describe UnitAmenities do
  describe 'fields' do
    it { expect(described_class).to have_attribute(:air_conditioning) }
    it { expect(described_class).to have_attribute(:beach) }
    it { expect(described_class).to have_attribute(:biking) }
    it { expect(described_class).to have_attribute(:fishing) }
    it { expect(described_class).to have_attribute(:hot_tub) }
    it { expect(described_class).to have_attribute(:internet_access) }
    it { expect(described_class).to have_attribute(:kitchen) }
    it { expect(described_class).to have_attribute(:pool) }
    it { expect(described_class).to have_attribute(:skiing) }
    it { expect(described_class).to have_attribute(:washer_dryer) }
    it { expect(described_class).to have_attribute(:wheelchair_accessible) }
    it { expect(described_class).to have_attribute(:golf) }
  end
end
