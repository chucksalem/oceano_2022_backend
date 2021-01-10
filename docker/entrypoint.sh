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
bundle exec foreman start
