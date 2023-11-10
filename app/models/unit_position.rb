# frozen_string_literal: true

class UnitPosition
  include Virtus.model

  attribute :latitude,  Float
  attribute :longitude, Float
end
