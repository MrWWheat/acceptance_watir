require 'watir_test'
require 'pages/community/admin'
require 'pages/community/layout'
require 'pages/community/account_settings'
require 'pages/api_doc'
require 'pages/mail_catcher'

class AccountSettingsTest < WatirTest
  @@user = nil
  def setup
    super
    @login_page = Pages::Community::Login.new(@config)
    @mail_catcher = Pages::MailCatcher.new(@config)
    @api_page = Pages::APIDoc.new(@config)
    @account_settings_page = Pages::Community::AccountSettings.new(@config)
    @topic_list_page = Pages::Community::TopicList.new(@config)
    @browser = @config.browser

    if !@@user
    	username = "user#{get_timestamp}".downcase
    	#username = "user20171211090708utc".downcase
  		email = "#{username}@test.com"
  		password = "Passw0rd!"
  		@@user = WatirConfig::User.new("", email, password, username)

  		status = @api_page.api_register_user @@user
  		assert status == 201
  		@mail_catcher.confirm_email email
  	end
  	@login_page.login_with("username", @@user)
  	@account_settings_page.goto_account_settings
  	@account_settings_page.fill_additional_info "test"
  end

  def teardown
  	#@account_settings.delete_self_user
    super
  end

  p1
  def test_00010_change_username
    msg = @account_settings_page.change_username "u"
    assert msg.include? "Username should be 2 to 40 characters."
    msg = @account_settings_page.change_username "user!"
    assert msg.include? "Username should only contain letters (A-Z or a-z), -, _, and numbers."

    ## wait for EN-4360 fixing
    #msg = @account_settings_page.change_username @config.users[:regular_user1].username
    #assert msg.include? ""

    new_username = "user#{get_timestamp}".downcase
    msg = @account_settings_page.change_username new_username
    assert msg.include? "Your information was successfully saved!"

    @login_page.logout!
    login_fail_check :username, @@user

    @@user.instance_variable_set(:@username, new_username)
    @login_page.login_with("username", @@user)
  end

  def test_00020_change_email
  	msg = @account_settings_page.change_email "user"
    assert msg.include? "The format is not valid."
    msg = @account_settings_page.change_email "user@test!.com"
    assert msg.include? "The format is not valid."
    msg = @account_settings_page.change_email "user@testcom"
    assert msg.include? "The format is not valid."

    ## wait for EN-4361 fixing
    #msg = @account_settings_page.change_email @config.users[:regular_user1].email
    #assert msg.include? ""

    new_email = "user#{get_timestamp.downcase}@test.com"
    origin_email = @@user.email
    msg = @account_settings_page.change_email new_email
    assert msg.include? "Your information was saved. As you changed your email, a confirm email was sent to your new email address. Please confirm it to activate your new email address"

    @login_page.logout!
    @login_page.login_with("email", @@user)

    @@user.instance_variable_set(:@email, new_email)
    @login_page.logout!
    login_fail_check :email, @@user

    @mail_catcher.confirm_email new_email

    @@user.instance_variable_set(:@email, origin_email)
    login_fail_check :email, @@user

    @@user.instance_variable_set(:@email, new_email)
    @login_page.login_with("email", @@user)
  end

  def test_00030_change_password
  	new_password = "Passw0rd!2"
  	msg = @account_settings_page.change_password "testpassword", "", ""
    assert msg.include? "Current password is not required unless you set a new password."
    msg = @account_settings_page.change_password "testpassword", new_password, new_password
    assert msg.include? "Current password is invalid."
    msg = @account_settings_page.change_password @@user.password, "12345", "12345"
    assert msg.include? "Should be 8 to 128 characters."
    msg = @account_settings_page.change_password @@user.password, "1234abcd", "1234abcd"
    assert msg.include? "Please provide a password containing the following four character classes: uppercase letters, lowercase letters, numeric and special characters."
    msg = @account_settings_page.change_password @@user.password, new_password, "abcd1234"
    assert msg.include? "Must match password."

    msg = @account_settings_page.change_password @@user.password, new_password, new_password
    assert msg.include? "Your information was successfully saved!"

    @login_page.logout!
    login_fail_check :username, @@user

    @@user.instance_variable_set(:@password, new_password)
    @login_page.login_with("username", @@user)
  end

  def test_00040_delete_account
  	@account_settings_page.delete_account
  	@browser.wait_until { @topic_list_page.topic_list.present? }
    login_fail_check :username, @@user
  end

  def login_fail_check type, user
  	@login_page.click_signin_link
  	if type == :username
    	@login_page.login_with_username_and_password(user)
    elsif type == :email
    	@login_page.login_with_email_and_password(@@user)
    end
    @browser.wait_until{ @login_page.login_error_msg.present? }
    assert @login_page.login_error_msg.text.include? "Invalid username, email address, or password."
  end

end