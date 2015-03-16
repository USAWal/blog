class ApplicationMailer < ActionMailer::Base
  default from: "owner@blog.co.uk"
  layout 'mailer'
end
