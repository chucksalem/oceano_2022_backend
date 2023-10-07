#!/bin/sh


service redis-server start &
bundle check || bundle install
bundle exec sidekiq