class ContactMailer < ActionMailer::Base
  default from: 'info@gooceano.com'

  def contact(email:, first_name:, last_name:, phone:, message:)
    @email      = email
    @first_name = first_name
    @last_name  = last_name
    @message    = message
    @phone      = phone

    mail(to: email, subject: 'Contact Form')
  end
end
