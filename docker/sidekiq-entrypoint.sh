#!/bin/sh
echo '-----------------------'
echo '-----------------------'
echo '-----------------------'
echo '-----------------------'
echo '##  starting sidekiq entrypoint'
echo '-----------------------'
echo '-----------------------'
echo '-----------------------'
echo '-----------------------'
service redis-server start &
bundle check || bundle install
bundle exec sidekiq