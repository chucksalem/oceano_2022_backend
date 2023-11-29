class BookingMailer < ApplicationMailer

  def booking_confirmation(user, booking)
    @user = user
    @booking = booking
    mail(to: @user.email, subject: 'Booking Confirmation')
  end
end
