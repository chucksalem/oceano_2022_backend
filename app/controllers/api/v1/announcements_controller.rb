module Api
  module V1
    class AnnouncementsController < BaseController
      def index
        @announcements = Announcement.recentsq
      end
    end
  end
end
