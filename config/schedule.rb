ENV.each { |k, v| env(k, v) }

project_dir = File.expand_path(File.dirname(__FILE__) + "/..")
set :output, "#{path}/log/crontab.log"