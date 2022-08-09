class ContactMailer < ActionMailer::Base

  default from: ENV['EMAIL_DEFAULT_FROM']
  default to: ENV['EMAIL_DEFAULT_TO']

  def contact(email:, first_name:, last_name:, phone:, message:)
    @email      = email
    @first_name = first_name
    @last_name  = last_name
    @message    = message
    @phone      = phone
    mail(
      from: email,
      subject: 'Contact Form'
    )
  end
end
