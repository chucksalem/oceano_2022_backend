# Be sure to restart your server when you modify this file.

# Avoid CORS issues when API is called from the frontend app.
# Handle Cross-Origin Resource Sharing (CORS) in order to accept cross-origin AJAX requests.

# Read more: https://github.com/cyu/rack-cors

Rails.application.config.middleware.insert_before 0, Rack::Cors do
  allow do
    origins 'oceano-rentals.com', 'www.oceano-rentals.com','172.235.39.37:3001', '172.233.153.77:3001','localhost:3001', 'oceano-rentals.com', 'rails', '/.*\.oceano-rentals\.com/', '.oceano-rentals.com'

    resource '*',
             headers: :any,
             methods: [:get, :post, :patch, :put, :delete, :options, :head],
             credentials: false
  end
end
