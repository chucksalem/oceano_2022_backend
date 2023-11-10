# frozen_string_literal: true

ENV.each { |k, v| env(k, v) }

File.expand_path("#{File.dirname(__FILE__)}/..")
set :output, "#{path}/log/crontab.log"
