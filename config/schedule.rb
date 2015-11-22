every :hour do
  command "bash -l -c '/home/#{ENV['USER']}/.rbenv/shims/bundle exec rake oceano:cache:properties'"
  command "bash -l -c '/home/#{ENV['USER']}/.rbenv/shims/bundle exec rake oceano:cache:weather'"
end
