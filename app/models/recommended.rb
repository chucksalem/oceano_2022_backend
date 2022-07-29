class Recommended < ApplicationRecord
  def self.get_all
    codes       = Recommended.all
    units       = UnitRepository.get_multiple(codes)
  end
end
