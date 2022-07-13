module Api
  module V1
    class HomeController < BaseController
      def index
        @random_units = UnitRepository.random_units(limit: 3, except: [@id])
      end
    end
  end
end