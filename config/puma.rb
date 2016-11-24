environment ENV['RACK_ENV'] || 'production'
threads Integer(ENV['PUMA_THREAD_MIN'] || 0), Integer(ENV['PUMA_THREAD_MAX'] || 8)
workers Integer(ENV['PUMA_WORKERS'] || 2)

daemonize true
pidfile ENV['PID_PATH'] || 'tmp/pids/puma.pid'

port Integer(ENV['PORT'] || 5000)

preload_app!
