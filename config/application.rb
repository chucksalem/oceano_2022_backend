require File.expand_path('../boot', __FILE__)
require 'rails'
require 'rails/all'
require 'action_controller/railtie'
require 'action_mailer/railtie'
require 'action_view/railtie'
require 'sprockets/railtie'

# Require the gems listed in Gemfile, including any gems
# you've limited to :test, :development, or :production.
Bundler.require(*Rails.groups)

module OceanoRails
  class Application < Rails::Application
    config.load_defaults 5.2
    config.autoload_paths << "#{Rails.root}/lib"
    config.assets.version = '1.0.1'
    config.middleware.use Rack::Attack
    config.active_job.queue_adapter = :sidekiq

    config.action_mailer.delivery_method = :mailgun
    config.action_mailer.mailgun_settings = {
      api_key: ENV['MAILGUN_API_KEY'],
      domain: ENV['MAILGUN_BASE_URL']
    }
  end
end
