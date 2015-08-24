require 'rails_helper'

describe UnitAddress do
  describe 'fields' do
    it { expect(described_class).to have_attribute(:street).of_type(String) }
    it { expect(described_class).to have_attribute(:city).of_type(String) }
    it { expect(described_class).to have_attribute(:state).of_type(String) }
    it { expect(described_class).to have_attribute(:postal_code).of_type(String) }
    it { expect(described_class).to have_attribute(:country).of_type(String) }
  end
end
