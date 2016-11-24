role :app, %w(oceanorentals@184.168.146.56)

set :pty, true

set :user, 'oceanorentals'
set :deploy_to, -> { "/home/oceanorentals/app" }
