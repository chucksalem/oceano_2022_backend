# frozen_string_literal: true

json.announcements do
  json.array! @announcements do |announcement|
    json.title announcement.title
    json.body announcement.body
  end
end
