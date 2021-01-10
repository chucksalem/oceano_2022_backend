threads 0,8
workers 2
preload_app!

if ENV['RAILS_ENV'] == 'development'
  bind "tcp://0.0.0.0:3000"
  daemonize false
else
  bind "unix://tmp/puma.sock"
  daemonize true
end

pidfile 'tmp/pids/puma.pid'

