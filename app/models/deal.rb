# frozen_string_literal: true

class Deal < ApplicationRecord
  def self.get_all
    codes = Deal.all
    UnitRepository.get_multiple(codes)
  end
end
