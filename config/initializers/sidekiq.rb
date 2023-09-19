Sidekiq.configure_server do |config|
  config.redis = { url: "redis://#{ENV.fetch('REDIS_HOST', '127.0.0.1')}:#{ENV.fetch('REDIS_PORT', '6379')}/1" }
end

Sidekiq.configure_client do |config|
  config.redis = { url: "redis://#{ENV.fetch('REDIS_HOST', '127.0.0.1')}:#{ENV.fetch('REDIS_PORT', '6379')}/1"  }
end
