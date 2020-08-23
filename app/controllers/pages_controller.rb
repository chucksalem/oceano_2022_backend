class PagesController < ApplicationController
  before_action :validate_email, only: :contact_thank_you

  def resources
    render
  end

  def contact
    render
  end

  def contact_thank_you
    if @errors
      render :contact
    else
      ContactMailer.contact(
        email:      params[:email],
        first_name: params[:firstname],
        last_name:  params[:lastname],
        phone:      params[:phone],
        message:    params[:message]
      ).deliver_now
    end
  rescue Mailgun::CommunicationError
    render plain: 'Something goes wrong with email delivery service, please try back later.'
  rescue Exception
    render plain: 'Sorry something goes wrong, try again later.'
  end

  def owners_thank_you
    ContactMailer.work_order(
      email:         params[:email],
      owner_name:    params[:owner_name],
      property_name: params[:property_name],
      message:       params[:message],
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

  private

  def validate_email
    email_regexp = /[a-zA-Z0-9.!\#$%&'*+\/=?^_`{|}~-]+@[a-zA-Z0-9](?:[a-zA-Z0-9-]{0,61}[a-zA-Z0-9])?(?:\.[a-zA-Z0-9](?:[a-zA-Z0-9-]{0,61}[a-zA-Z0-9])?)*/
    @errors = ['Invalid email'] if params[:email].blank? || !params[:email].match(email_regexp)
  end
end
