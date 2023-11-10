# frozen_string_literal: true

class ApplicationController < Administrate::ApplicationController
  before_action :authenticate_user! # use devise authentication

  def after_sign_out_path_for(_resource_or_scope)
    request.referer
  end
end
