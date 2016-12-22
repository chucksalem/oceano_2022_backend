threads 0,8
workers 2
preload_app!

bind "unix://tmp/puma.sock"

daemonize true

pidfile 'tmp/pids/puma.pid'

