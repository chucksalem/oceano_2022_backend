module ApplicationHelper
  def areas
    OceanoConfig[:areas].map do |a|
      { key: a.tr(' ', '').underscore, name: a }
    end
  end
end
