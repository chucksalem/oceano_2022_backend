Rails.application.config.middleware.insert_before 0, Rack::Cors do
  allow do
    origins 'http://http://localhost:3001/'
    resource '*', headers: :any, methods: [:get, :post, :patch, :put]
  end
end