class ApplicationMailer < ActionMailer::Base
  default from: ENV['EMAIL_DEFAULT_FROM']
  default to: ENV['EMAIL_DEFAULT_TO']

  layout 'mailer'
end

