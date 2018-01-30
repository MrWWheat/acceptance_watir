require 'pages/yaas'
require 'watir_config'

class Pages::Yaas::Login < Pages::Yaas

  def initialize(config, options = {})
    super(config)
    @url = config.yaas_url
  end

  def start!(user)
    super(user, @url, logo_homepage_btn)
  end

  email_field			          { text_field(:id => "usernameInput") }
  password_field		        { text_field(:id => "passwordInput") }


  def is_logged_out?
    login_link.present?
  end

  def login!(user)
    @browser.wait_until {
      logout! unless is_logged_out?
      puts "failed to logout" unless is_logged_out?
      is_logged_out?
    }
    login_link.when_present.click
    @browser.wait_until { @browser.ready_state == "complete" }
    @browser.wait_until { email_field.present? }
    @browser.wait_until { password_field.present? }
    @browser.wait_until { signin_btn.present? }
    email_field.set(user.email)
    password_field.set(user.password)
    signin_btn.when_present.click
    @browser.wait_until { @browser.ready_state == "complete" }
    @browser.wait_until { profile_link.present? }
    sleep(3)

  rescue Exception => e
    puts @browser.ready_state
    puts "How did we get here?"
    raise
  end

  # def logout!
  #   profile_link.when_present.click
  #   logout_btn.when_present.click
  # end

  def logout!
    @browser.execute_script("window.scrollBy(0,-10000)")
    return if is_logged_out?

    puts "actually logging out..." if @config.verbose?

    @browser.wait_until { profile_link.present? }
    profile_link.click  #From Pages::Yaas::Layout
    logout_btn.when_present.click
    @browser.wait_until { !profile_link.present? }
    @browser.wait_until { login_link.present? }
  end

end