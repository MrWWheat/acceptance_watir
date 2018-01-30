require 'pages/mail_catcher'
require 'pages/newsa/invite_email'

class Pages::MailCatcher::SAMailCatcher < Pages::MailCatcher
  def initialize(config, options = {})
    super(config)
    @url = config.mail_catcher_url
  end

  def get_sa_invite_email(sa_email)
    mail_subject = "<" + sa_email + "> SAP Jam Communities Invitation instructions"
    get_mail_url(mail_subject)
  end 

  def get_sa_invite_emails(sa_email, expected_num)
    mail_subject = "<" + sa_email + "> SAP Jam Communities Invitation instructions"
    get_mail_urls(mail_subject, expected_num)
  end

  def get_admin_invite_emails(admin_email, expected_num, timeout=2*60)
    mail_subject = "<" + admin_email + "> SAP Jam Communities Invitation instructions"
    get_mail_urls(mail_subject, expected_num, timeout)
  end 

  def goto_admin_invite_email(invite_email_url)
    @browser.goto invite_email_url
    # register_url = @browser.link.when_present.href
    Pages::NewSuperAdmin::CommAdminInviteEmail.new(@config)
  end 
end  