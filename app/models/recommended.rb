class Recommended < ApplicationRecord
  def self.get_all
    codes       = Recommended.all
    units       = codes.map { |k| UnitRepository.get(k.unit_id) }
  end
end
