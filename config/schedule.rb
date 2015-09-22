every :hour do
  rake 'oceano:cache:properties'
  rake 'oceano:cache:weather'
end
