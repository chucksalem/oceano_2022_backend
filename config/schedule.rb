project_dir = File.expand_path(File.dirname(__FILE__) + "/..")

every :hour do
  command "bash -l -c 'cd #{project_dir} && /home/#{ENV['USER']}/.rbenv/shims/bundle exec rake oceano:cache:properties'"
  command "bash -l -c 'cd #{project_dir} && /home/#{ENV['USER']}/.rbenv/shims/bundle exec rake oceano:cache:weather'"
end
