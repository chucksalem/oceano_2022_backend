class ApplicationController < ActionController::Base
  protect_from_forgery with: :exception

  helper :all
  helper_method :home?
  helper_method :property_detail?

  before_filter :weather

  private

  def weather
    @weather = Weather.get
  end

  def home?
    controller_name == 'home' && action_name == 'index'
  end

  def property_detail?
    controller_name == 'property' && action_name == 'view'
  end
end
