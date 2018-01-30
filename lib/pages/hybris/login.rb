require 'pages/hybris'

class Pages::Hybris::Login < Pages::Hybris
  
  def initialize(config, options = {})
    super(config)
    @url = config.hybris_url
  end

  login_section			        { div(:class => "login-section") }
  email_field			          { text_field(:id => "j_username") }
  password_field		        { text_field(:id => "j_password") }

  login_btn                 { button(:text => /(LOG IN|LOGIN)/) }

  title_select              { select(:id => "register.title") }
  first_name_field          { text_field(:id => "register.firstName") }
  last_name_field           { text_field(:id => "register.lastName") }
  email_register_field      { text_field(:id => "register.email") }
  password_register_field   { text_field(:id => "password") }
  confirm_password_field    { text_field(:id => "register.checkPwd") }
  register_btn              { form(:id => "registerForm").button }

  def login!(user)
    #return if is_logged_in?(user)
    # logout! unless is_logged_out? # if we're logged in as someone else, logout first.
    # puts "actually logging in (#{user.username})..." if @config.verbose?
    # puts "failed to logout" unless is_logged_out? # no idea why sometimes fail. So add log here.

    @browser.wait_until { 
      logout! unless is_logged_out?
      puts "failed to logout" unless is_logged_out? # no idea why sometimes fail. So add log here./etc/pam.d/common-auth
      is_logged_out?
    }

    login_link.when_present.click
    @browser.wait_until { @browser.ready_state == "complete" }
    # @browser.wait_until { login_section.present? }
    @browser.wait_until { email_field.present? }
    @browser.wait_until { password_field.present? }
    @browser.wait_until { login_btn.present? }

    email_field.set(user.email)
    password_field.set(user.password)

    login_btn.when_present.click

    @browser.wait_until { @browser.ready_state == "complete" }
    @browser.wait_until { logout_link.present? }
  rescue Exception => e
    puts @browser.ready_state
    #byebug
    puts "How did we get here?"
    raise

  end

  def logout!
    logout_link.when_present.click
  end

  def register title:"Mr.", firstName:"Watir", lastName:"User", email:"WatirUser@watir.com", password:"password"
    logout! unless is_logged_out? # if we're logged in as someone else, logout first.
    puts "actually logging in (#{user.username})..." if @config.verbose?

    login_link.when_present.click
    @browser.wait_until { @browser.ready_state == "complete" }
    # @browser.wait_until { login_section.present? }
    @browser.wait_until { email_field.present? }
    @browser.wait_until { password_field.present? }
    @browser.wait_until { login_btn.present? }

    title_select.when_present.select title
    first_name_field.when_present.set firstName
    last_name_field.when_present.set lastName
    email_register_field.when_present.set email
    password_register_field.when_present.set password
    confirm_password_field.when_present.set password

    register_btn.when_present.click
    @browser.wait_until { logout_link.present? }
  end

end