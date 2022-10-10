class Recommendation < ApplicationRecord
  def self.get_all()
    codes       = Recommendation.all
    units       = UnitRepository.get_multiple(codes)
  end
end
