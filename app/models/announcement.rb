class Announcement < ApplicationRecord
  scope :recents, -> { where("(start_at >= :today AND ended_at IS NULL) OR (start_at >= :today AND ended_at <= :today)", today: Time.now) }
end
