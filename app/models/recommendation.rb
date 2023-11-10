# frozen_string_literal: true

class Recommendation < ApplicationRecord
  def self.get_all
    codes = Recommendation.all
    UnitRepository.get_multiple(codes)
  end
end
