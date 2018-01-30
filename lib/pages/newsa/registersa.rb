require 'pages/base'
require 'pages/newsa/mail_catcher'
require 'pages/newsa/login'

class Pages::NewSuperAdmin::RegisterSA < Pages::NewSuperAdmin
  newsa_sa_register_email_field               { text_field(:css => ".block-body .form-group:nth-child(1) input") }
  newsa_sa_register_pwd_field                 { text_field(:css => "input[placeholder='Enter Password']") }
  newsa_sa_register_pwd_confirm_field         { text_field(:css => "input[placeholder='Enter Password Confirmation']") }
  newsa_sa_register_register_btn              { button(:css => ".block-body .foot-btn-group button.btn-primary") }
  newsa_sa_register_cancel_btn                { link(:css => ".block-body .foot-btn-group a.btn-default") }

  def register(sa_email, password, is_resend_invite=false)
    @browser.goto @config.mail_catcher_url
    @mail_catcher = Pages::MailCatcher::SAMailCatcher.new(@config)
    unless is_resend_invite
      mail_url = @mail_catcher.get_sa_invite_email(sa_email)
    else
      mail_url = @mail_catcher.get_sa_invite_emails(sa_email, 2)[0]
    end  
    @browser.goto mail_url
    register_url = @browser.link.when_present.href

    @browser.goto register_url

    newsa_sa_register_pwd_field.when_present.set password
    newsa_sa_register_pwd_confirm_field.set password

    newsa_sa_register_register_btn.when_present.click

    login_page = Pages::NewSuperAdmin::Login.new(@config)
    @browser.wait_until { login_page.newsa_toast_success.present? }
    @browser.wait_until { !login_page.newsa_toast_message.present? }
  end  
end