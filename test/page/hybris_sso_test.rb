require 'watir_test'
require 'pages/hybris/home'
require 'pages/hybris/login'
require 'pages/hybris/detail'
require 'pages/community/conversationdetail'
require 'pages/community/login'
require 'pages/super_admin'
require 'actions/hybris/common'
require 'actions/hybris/api'
require 'pages/mail_catcher'
require 'pages/community/reset_password'
require 'watir_config'
require 'pages/community/layout'

class HybrisSsoTest < WatirTest

  def setup
    super
    @hybris_home_page = Pages::Hybris::Home.new(@config)
    @hybris_login_page = Pages::Hybris::Login.new(@config)
    @hybris_detail_page = Pages::Hybris::Detail.new(@config)
    @community_conversationdetail_page = Pages::Community::ConversationDetail.new(@config)
    @community_login_page = Pages::Community::Login.new(@config)
    @super_admin = Pages::SuperAdmin.new(@config)
    @mail_catcher = Pages::MailCatcher.new(@config)
    @community_reset_page = Pages::Community::ResetPassword.new(@config)
    @community_layout_page = Pages::Community::Layout.new(@config)

    @common_actions = Actions::Common.new(@config)
    @api_actions = Actions::Api.new(@config)
    # @current_page = @hybris_search_page
    puts "[[[ #{name} ::: nil ]]]" if @config.verbose?
    @browser = @c.browser
    # @browser.goto @c.superadmin_url
    # @super_admin.login_super_admin
    # @super_admin.go_to_community_tab @c.slug
    # @super_admin.toggle_sso_switch :up, "SSO"
    # @super_admin.logout!
    @hybris_home_page.start!(user_for_test)
    @uuid = nil
    @email = nil
  end

  def teardown
    super
    @api_actions.delete_review(@config.users[:network_admin], @uuid) if @uuid
  end

  user :hybris_user1
  p1
  def test_00010_b2b_login_user_sso

    @common_actions.go_to_product_detail @c.product_id_write
    @hybris_detail_page.recent_review_title.when_present.click
    @browser.wait_until($t) {@browser.windows.length != 1}
    @browser.window(:url => /#{@c.base_url}/).when_present.use do
      @common_actions.go_to_settings_page
      assert @browser.text_field(:id => "member_email").when_present.value == @c.users["hybris_user1"].email, "no SSO"
      @community_login_page.logout!
      @browser.window.close
    end
    @hybris_login_page.logout!
  end

  user :hybris_user1
  p1
  def test_00020_b2b_login_user_write_review_sso
    title = "title#{Time.now.utc.to_i}"
    des = "description#{Time.now.utc.to_i}"
    @common_actions.go_to_product_detail @c.product_id_write
    @uuid = @common_actions.write_review :link, 5, title, des, false

    @browser.wait_until($t) {@hybris_detail_page.recent_review_title.text == title}
    assert @hybris_detail_page.recent_review_title.text == title, "recent review title doesn't match"
    assert @hybris_detail_page.most_recent_review_content_field.text == des, "recent review description doesn't match"

    @hybris_detail_page.recent_review_title.when_present.click
    @browser.wait_until($t) {@browser.windows.length != 1}
    @browser.window(:url => /#{@c.base_url}/).when_present.use do
      @common_actions.go_to_settings_page
      assert @browser.text_field(:id => "member_email").when_present.value == @c.users["hybris_user1"].email, "no SSO"
      @community_login_page.logout!
      @browser.window.close
    end

    @hybris_login_page.logout!
  end

  def register_user_write_review
    @title = "title#{Time.now.utc.to_i}"
    @des = "description#{Time.now.utc.to_i}"

    @email = "watiruser@#{Time.now.utc.to_i}.com"
    @hybris_login_page.register :email => @email
    @common_actions.go_to_product_detail @c.product_id_write
    @uuid = @common_actions.write_review :link, 5, @title, @des, false

    @browser.wait_until($t) {@hybris_detail_page.recent_review_title.when_present.text == @title}
  end

  user :anonymous
  p1
  def test_00030_register_user_write_review_sso
    register_user_write_review
    assert @hybris_detail_page.recent_review_title.text == @title, "recent review title doesn't match"
    assert @hybris_detail_page.most_recent_review_content_field.text == @des, "recent review description doesn't match"
    @hybris_detail_page.recent_review_title.when_present.click
    @browser.wait_until($t) {@browser.windows.length != 1}
    @browser.window(:url => /#{@c.base_url}/).use do
      @common_actions.go_to_settings_page
      assert @browser.text_field(:id => "member_email").when_present.value == @email, "no SSO"
      @community_login_page.logout!
      @browser.window.close
    end

    @hybris_login_page.logout!
  end

  def test_00040_register_user_cannot_log_in_before_reset_password_sso
    register_user_write_review
    @browser.goto @config.base_url
    @community_login_page.logout!
    @community_layout_page.login_link.when_present.click
    user1 = WatirConfig::User.new("", @email, "password", @email)
    @community_login_page.login_with_username_and_password(user1)
    @browser.wait_until($t) { @community_login_page.invalid_login.present?}
    assert @community_login_page.invalid_login.present?
  end

  def test_00100_register_user_reset_password_sso
    register_user_write_review
    @browser.goto @config.mail_catcher_url_with_credit if @config.mail_catcher_url_with_credit
    @browser.goto @config.mail_catcher_url
    mail_link = @mail_catcher.goto_reset_mail @email
    @browser.goto mail_link
    @browser.link.click
    @community_reset_page.reset_password "newPassw0rd!"
    @browser.wait_until($t) { @community_reset_page.sign_in_btn.present?}
    assert @browser.text.include? "Password Successfully Reset"

    @community_reset_page.sign_in_btn.when_present.click
    invaliduser = WatirConfig::User.new("", @email, "invalidPassw0rd!", @email)
    @community_login_page.login_with_username_and_password(invaliduser)
    @browser.wait_until ($t) { @community_login_page.invalid_login.present?}
    assert @community_login_page.invalid_login.present?

    validuser = WatirConfig::User.new("", @email, "newPassw0rd!", @email)
    @community_login_page.login!(validuser)
    assert @community_login_page.user_dropdown.present?
  end


end