module Admin
  class RecommendationsController < Admin::ApplicationController
    def show
      redirect_to admin_recommendations_path
    end
  end
end
