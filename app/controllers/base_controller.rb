class BaseController < ActionController::Base
  skip_before_action :verify_authenticity_token
  
  respond_to :json
  helper :all
  helper_method :home?
  helper_method :property_detail?
  before_action :set_default_response_format
    
  private


  def set_default_response_format
    request.format = :json
  end

  def render_error(status, messages)
    render json: { errors: messages }, status: status
  end

  def home?
    controller_name == 'home' && action_name == 'index'
  end

  def property_detail?
    controller_name == 'property' && action_name == 'view'
  end
end
