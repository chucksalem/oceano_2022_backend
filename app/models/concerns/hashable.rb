# frozen_string_literal: true

module Hashable
  def self.included(base)
    base.extend(SingletonMethods)
  end

  module SingletonMethods
    def flatten_nested_hash(hash)
      hash.each_with_object({}) do |(key, val), h|
        if val.is_a?(Hash)
          flatten_nested_hash(val).map { |hk, hv| h["#{key}:#{hk}"] = hv }
        else
          h[key] = val
        end
      end
    end
  end
end
