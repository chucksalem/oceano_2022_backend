class PagesController < ApplicationController
  def resources
    render
  end

  def contact
    render
  end

  def contact_thank_you
    ContactMailer.contact(
      email:      params[:email],
      first_name: params[:firstname],
      last_name:  params[:lastname],
      phone:      params[:phone],
      message:    params[:message]
    ).deliver_now
  end

  def owners_thank_you
    ContactMailer.work_order(
      email:      params[:email],
      first_name: params[:firstname],
      last_name:  params[:lastname],
      phone:      params[:phone],
      message:    params[:message]
    ).deliver_now
  end

  def testimonials
    render
  end

  def faq
    render
  end

  def maps
    render
  end

  def owners
    render
  end

  def trip_cancellation_insurance
    render
  end

end
