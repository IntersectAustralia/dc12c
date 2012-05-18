class Notifier < ActionMailer::Base

  PREFIX = "Papyri Data Capture - "

  def notify_user_that_they_cant_reset_their_password(user)
    @user = user
    mail( :to => @user.email,
          :from => APP_CONFIG['password_reset_email_sender'],
          :reply_to => APP_CONFIG['password_reset_email_sender'],
          :subject => PREFIX + "Reset password instructions")
  end

  def notify_superusers_of_papyrus_access_request(access_request)
    superusers_emails = User.get_superuser_emails
    @user = access_request.user
    @papyrus = access_request.papyrus
    @access_request = access_request
    mail( :to => superusers_emails,
          :from => APP_CONFIG['papyrus_access_request_email_sender'],
          :reply_to => APP_CONFIG['papyrus_access_request_email_sender'],
          :subject => PREFIX + "Papyrus access request")
   
  end

end
