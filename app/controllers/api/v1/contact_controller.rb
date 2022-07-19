module Api
  module V1
    class ContactController < BaseController
      before_action :validate_email, only: :contact_thank_you

      def contact_thank_you
        if @errors
          render :contact
        else
          ContactMailer.contact(
            email:      contact_params[:email],
            first_name: contact_params[:firstname],
            last_name:  contact_params[:lastname],
            phone:      contact_params[:phone],
            message:    contact_params[:message]
          ).deliver_now
        end
        @result = true
      rescue Mailgun::CommunicationError
        @result = false
      rescue Exception
        @result = false
      end

      private

      def contact_params
        @contact_params ||= params.permit(:email, :firstname, :lastname, :phone, :message)
      end

      def validate_email
        email_regexp = /[a-zA-Z0-9.!\#$%&'*+\/=?^_`{|}~-]+@[a-zA-Z0-9](?:[a-zA-Z0-9-]{0,61}[a-zA-Z0-9])?(?:\.[a-zA-Z0-9](?:[a-zA-Z0-9-]{0,61}[a-zA-Z0-9])?)*/
        @errors = ['Invalid email'] if params[:email].blank? || !params[:email].match(email_regexp)
      end
    end
  end
end
