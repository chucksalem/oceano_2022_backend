module Api
  module V1
    class AnnouncementsController < BaseController
      def index
        @announcements = Announcement.recents
      end
    end
  end
end
