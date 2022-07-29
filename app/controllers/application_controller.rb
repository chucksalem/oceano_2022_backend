class ApplicationController < Administrate::ApplicationController
  before_action :authenticate_user! # use devise authentication
end
