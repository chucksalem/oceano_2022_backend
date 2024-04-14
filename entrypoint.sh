#! /bin/bash

echo '##  starting entrypoint'
echo '-----------------------'

echo 'making sure server .pid is gone'
rm -rf tmp/cache/assets
rm tmp/pids/server.pid
rm tmp/pids/puma.pid
echo 'run startup script'

set -ex


service redis-server start
bundle install
#bundle exec rails db:create
#bundle exec rails db:migrate
#bundle exec rails db:seed
#bundle exec rake oceano:cache:properties
#bundle exec whenever --update-crontab
cron && bundle exec rails s -b 0.0.0.0
