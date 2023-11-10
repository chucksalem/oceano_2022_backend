# frozen_string_literal: true

server '192.155.86.203', user: 'deploy', roles: %w[web app]

set :pty, true

set :user, 'deploy'
set :deploy_to, -> { '/home/apps/oceano_rentals' }

set :stage, 'production'
