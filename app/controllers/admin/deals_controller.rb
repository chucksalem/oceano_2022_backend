module Admin
  class DealsController < Admin::ApplicationController
    def show
      redirect_to admin_deals_path
    end
  end
end
