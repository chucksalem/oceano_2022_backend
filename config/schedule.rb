set :command_with_env, "bash -l -c ':job'"

every :hour do
  command_with_env "/home/#{ENV['USER']}/.rbenv/shims/bundle exec rake oceano:cache:properties"
  command_with_env "/home/#{ENV['USER']}/.rbenv/shims/bundle exec rake oceano:cache:weather"
end
