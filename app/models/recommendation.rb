class Recommendation < ApplicationRecord
  def self.get_all()
    codes       = Recommendation.all
    units       = codes.map { |k| UnitRepository.get(k.unit_id) }
  end
end
