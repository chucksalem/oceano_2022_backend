class Deal < ApplicationRecord
  def self.get_all
    codes       = Deal.all
    units       = UnitRepository.get_multiple(codes)
  end
end
