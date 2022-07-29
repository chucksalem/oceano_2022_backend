class ApplicationController < Administrate::ApplicationController
  before_action :authenticate_user! # use devise authentication
<<<<<<< HEAD

  def after_sign_out_path_for(resource_or_scope)
    request.referrer
  end
=======
>>>>>>> feature/admin-reviews
end
