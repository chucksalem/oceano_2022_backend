# frozen_string_literal: true

module Api
  module V1
    class HomeController < BaseController
      def index
        @random_units = Recommendation.get_all
        @random_units = UnitRepository.random_units(limit: 3, except: [@id]) if @random_units.empty?
      end

      def deals
        @random_units = Deal.get_all
      end
    end
  end
end
