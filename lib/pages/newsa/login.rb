require 'pages/newsa/newsa'
require 'pages/newsa/communities'

class Pages::NewSuperAdmin::Login < Pages::NewSuperAdmin

  def initialize(config, options = {})
    super(config)
    @url = config.base_url
  end

  def start!(user)
    super(user, @url, newsa_login_email_field)
  end

  newsa_login_email_field       { text_field(:css => "input[type=text]") }
  newsa_login_password_field    { text_field(:css => "input[type=password]") }
  newsa_login_forgot_pwd_link   { link(:css => ".forgot-password") }
  newsa_login_sign_in_btn       { button(:css => ".btn-primary") }

  def login(user_email, user_pwd)
    newsa_login_email_field.when_present.set(user_email)
    newsa_login_password_field.when_present.set(user_pwd)

    newsa_login_sign_in_btn.when_present.click

    communities_page = Pages::NewSuperAdmin::Communities.new(@config)
    @browser.wait_until { communities_page.newsa_comm_table_title.present? }

    communities_page
  end  
end  