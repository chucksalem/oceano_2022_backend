module Api
  module V1
    class TriggersController < BaseController
      def create
        UnitsFetchJob.perform_now

        render json: { status: 200 }
      end
    end
  end
end
