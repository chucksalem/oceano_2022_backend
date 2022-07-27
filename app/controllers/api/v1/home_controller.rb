module Api
  module V1
    class HomeController < BaseController
      def index
        @random_units = Recommended.get_all()
        @random_units = UnitRepository.random_units(limit: 3, except: [@id]) if @random_units.empty?
      end
    end
  end
end
