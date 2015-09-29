require 'staging_mail_interceptor'

if Rails.env.staging?
  ActionMailer::Base.register_interceptor(StagingMailInterceptor)
end
