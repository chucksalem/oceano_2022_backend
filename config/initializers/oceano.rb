# frozen_string_literal: true

OceanoConfig = HashWithIndifferentAccess.new(YAML.load_file(Rails.root.join('config/oceano.yml')))
