Rack::Attack.throttle('req/ip', limit: 20, period: 1.minute) do |req|
  req.ip if req.path =~ %r{^\/api}
end

Rack::Attack.throttled_response = lambda do |_|
  body    = MultiJson.dump(errors: ['Whoa there, Dingus. Slow down.'])
  headers = { 'Content-Type' => 'application/json; encoding=utf8' }

  [429, headers, [body]]
end
