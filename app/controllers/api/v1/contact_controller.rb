module Api
  module V1
    class ContactController < BaseController
      before_action :validate_email, only: :contact_thank_you

      def contact_thank_you
        if @errors
          @result = false
        else
          ContactMailer.contact(
            email:      contact_params[:email],
            first_name: contact_params[:first_name],
            last_name:  contact_params[:last_name],
            phone:      contact_params[:phone],
            message:    contact_params[:message]
          ).deliver_now
          @result = true
        end
      rescue Mailgun::CommunicationError => error
        p error
        @result = false
      end
      
      private

      def contact_params
        @contact_params ||= params.permit(:email, :first_name, :last_name, :phone, :message)
      end

      def validate_email
        email_regexp = /[a-zA-Z0-9.!\#$%&'*+\/=?^_`{|}~-]+@[a-zA-Z0-9](?:[a-zA-Z0-9-]{0,61}[a-zA-Z0-9])?(?:\.[a-zA-Z0-9](?:[a-zA-Z0-9-]{0,61}[a-zA-Z0-9])?)*/
        @errors = ['Invalid email'] if params[:email].blank? || !params[:email].match(email_regexp)
      end
    end
  end
end
