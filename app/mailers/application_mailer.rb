class ApplicationMailer < ActionMailer::Base
  default from: "mail@bffadmin"
  default to:   "mail@bffadmin"
  layout 'mailer'
end
