class ContactMailer < ActionMailer::Base
  default from: 'info@oceano-rentals.com'
  default to: 'info@gooceano.com'

  def contact(email:, first_name:, last_name:, phone:, message:)
    mail(
      from: email,
      subject: 'Contact Form',
      text:
        <<-HEREDOC
First_name: #{first_name}"
Last_name: #{last_name}
Phone: #{phone}
Question: #{message}
        HEREDOC
    )
  end

  def work_order(email:, owner_name:, property_name:, message:)
    @email      = email
    @owner_name = owner_name
    @property_name = property_name
    @message    = message

    mail(subject: 'Work Order Form')
  end
end
