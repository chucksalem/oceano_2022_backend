#! /bin/bash

echo '##  starting entrypoint'
echo '-----------------------'

echo 'making sure server .pid is gone'
rm tmp/pids/server.pid
rm tmp/pids/puma.pid
echo 'run startup script'

set -ex

service redis-server start &
bundle check || bundle install
rake oceano:cache:properties
rails db:migrate db:seed
bundle exec rails s -b 0.0.0.0
