require 'rails_helper'

describe UnitDescriptions do
  describe 'fields' do
    it { expect(described_class).to have_attribute(:images).of_type(Array) }
    it { expect(described_class).to have_attribute(:videos).of_type(Array) }
    it { expect(described_class).to have_attribute(:text).of_type(Array) }
  end
end
