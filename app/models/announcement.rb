# frozen_string_literal: true

class Announcement < ApplicationRecord
  scope :recents, lambda {
                    where('(start_at >= :today AND ended_at IS NULL) OR (start_at >= :today AND ended_at <= :today)', today: Time.zone.now)
                  }
end
