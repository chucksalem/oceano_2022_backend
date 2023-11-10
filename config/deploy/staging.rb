# frozen_string_literal: true

server '104.237.159.94', user: 'deploy', roles: %w[web app]

set :pty, true

set :rails_env, 'staging'
set :user, 'deploy'
set :deploy_to, -> { '/home/apps/oceano_rentals' }

set :stage, 'production'
