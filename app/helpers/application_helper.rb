# frozen_string_literal: true

module ApplicationHelper
  def areas
    OceanoConfig[:areas].map do |a|
      { key: a.tr(' ', '').underscore, name: a }
    end
  end

  def sort_by
    [
      ['Guest Rating', 'G'],
      ['Price', 'P'],
      ['Location', 'L'],
      ['Name', 'N']
    ]
  end

  def ellipsis(str, length:)
    str[0..length].gsub(/\s\w+\s*$/, '...')
  end

  def trim_at(str, len)
    str[0..(len - 3)] + (len < str.length ? '...' : '')
  end
end
