require File.expand_path('../boot', __FILE__)

require 'action_controller/railtie'
require 'action_mailer/railtie'
require 'action_view/railtie'
require 'sprockets/railtie'

# Require the gems listed in Gemfile, including any gems
# you've limited to :test, :development, or :production.
Bundler.require(*Rails.groups)

module OceanoRails
  class Application < Rails::Application
    config.autoload_paths << "#{Rails.root}/lib"
    config.assets.version = '1.0.1'
    config.middleware.use Rack::Attack
  end
end
