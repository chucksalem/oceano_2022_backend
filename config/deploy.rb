# config valid only for current version of Capistrano
lock '3.4.0'

set :application, 'oceano'
set :repo_url, 'git@github.com:chucksalem/oceano-rentals.git'
set :branch, 'master'

set :linked_dirs, fetch(:linked_dirs, []).push('log', 'tmp/pids', 'tmp/cache', 'tmp/sockets', 'vendor/bundle', 'public/system', 'public/uploads')

set :port, 22
set :rbenv_type, :user
set :rbenv_ruby, File.read('.ruby-version').strip

set :whenever_identifier, ->{ "#{fetch(:application)}_#{fetch(:stage)}" }
set :whenever_roles,      ->{ :app }

namespace :deploy do
  after :restart, :clear_cache do
    on roles(:web), in: :groups, limit: 3, wait: 10 do
    end
  end

  after :publishing, :precompile do
    on roles(:app) do
      within release_path do
        execute :rbenv, :exec, "bundle exec rake assets:precompile RAILS_ENV=#{fetch(:stage)}"
      end
    end
  end
end

namespace :foreman do
  desc 'Export the Procfile to upstart'
  task :export do
    on roles(:app) do
      within current_path do
        execute :rbenv, :sudo, "bundle exec foreman export upstart /etc/init --procfile=./Procfile -a #{fetch(:application)} -u #{fetch(:user)} -l #{current_path}/log --template #{current_path}/upstart"
      end
    end
  end

  desc 'Start the application'
  task :start do
    on roles(:app) do
      within current_path do
        execute :rbenv, :sudo, "start #{fetch(:application)}"
      end
    end

  end

  desc 'Stop the application'
  task :stop do
    on roles(:app) do
      within current_path do
        execute :rbenv, :sudo, "stop #{fetch(:application)}"
      end
    end
  end

  desc 'Restart the application'
  task :restart do
    on roles(:app) do
      within current_path do
        execute :rbenv, :sudo, "restart #{fetch(:application)} || start #{fetch(:application)}"
      end
    end
  end
end

after 'deploy:publishing', 'foreman:export'
after 'deploy:publishing', 'foreman:restart'
