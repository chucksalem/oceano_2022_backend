# config valid only for current version of Capistrano
lock '3.4.0'

set :branch, ENV['BRANCH'] || 'master'

set :application, 'oceano_rentals/'
set :repo_url, 'git@github.com:chucksalem/oceano-rentals.git'
set :branch, 'master'

set :linked_dirs, fetch(:linked_dirs, []).push('log', 'tmp/pids', 'tmp/cache', 'tmp/sockets', 'vendor/bundle', 'public/system', 'public/uploads')
set :linked_files, %w{config/application.yml config/secrets.yml}

set :whenever_identifier, ->{ "#{fetch(:application)}_#{fetch(:stage)}" }
set :whenever_roles,      ->{ :app }

set :puma_workers, 2
set :puma_preload_app, true
set :assets_roles, [:web, :app]
