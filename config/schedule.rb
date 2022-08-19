ENV.each { |k, v| env(k, v) }

project_dir = File.expand_path(File.dirname(__FILE__) + "/..")
set :output, "#{path}/log/crontab.log"

every 1.hour do
  command "cd #{project_dir} && bundle exec rake oceano:cache:properties"
end
