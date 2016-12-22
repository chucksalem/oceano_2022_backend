project_dir = File.expand_path(File.dirname(__FILE__) + "/..")
set :output, "#{path}/log/crontab.log"

every :hour do
  command "cd #{project_dir} && ~/.rvm/bin/rvm default do bundle exec rake oceano:cache:properties"
  command "cd #{project_dir} && ~/.rvm/bin/rvm default do bundle exec rake oceano:cache:weather"
end

