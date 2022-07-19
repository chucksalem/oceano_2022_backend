class ContactMailer < ActionMailer::Base
  # default from: 'info@oceano-rentals.com'
  # default to: 'info@gooceano.com'

  default from: 'julidubra15@gmail.com'
  default to: 'julietadubra@neocoast.com'

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
