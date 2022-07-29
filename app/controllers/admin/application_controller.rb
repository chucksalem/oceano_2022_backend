module Admin
  class ApplicationController < Administrate::ApplicationController
    before_action :authenticate_user!

    def after_sign_out_path_for(resource_or_scope)
      request.referrer
    end
  end
end
