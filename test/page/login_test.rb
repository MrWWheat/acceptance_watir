require 'watir_test'
require 'pages/community/admin'
require 'pages/community/admin_social_app'
require 'pages/community/profile'
require 'pages/community/topicdetail'

class LoginTest < WatirTest
  def setup
    super
    @login_page = Pages::Community::Login.new(@config)
    @topicdetail_page = Pages::Community::TopicDetail.new(@config)
    @community_admin_page = Pages::Community::Admin.new(@config)
    @community_admin_social_app_page = Pages::Community::AdminSocialApp.new(@config)

    # assigning @current_page helps error reporting
    #  give good contextual data
    @current_page = @login_page
    puts "[[[ #{name} ::: #{user_for_test} ]]]" if @config.verbose?
    @browser = @config.browser

    @login_page.start!(user_for_test)
  end

  def teardown
    super
  end

  user :anonymous
  p1
  #============ ANON USER TESTS ==========================#
  #=================================================================#

  #======== login page, log in with username or email, register, social login, etc. tests ============#
  def test_00010_goto_login_page
    @login_page.click_signin_link
    assert @login_page.login_body.present?
  end

  def test_00020_goto_register_page
    @login_page.click_signin_register_link
    assert @login_page.register_body.present?
  end

  def test_00030_check_login_username_pass_field
    @login_page.check_username_field
    assert @login_page.member_login.present?

    @login_page.check_pass_field
    assert @login_page.member_password.present?
  end

  p2
  def test_00040_check_login_username_pass_placeholder
    @login_page.check_login_username_field_placeholder
    assert @login_page.login_username_placeholder.present?

    @login_page.check_login_pass_field_placeholder
    assert @login_page.login_password_placeholder.present?
  end

  p1
  def test_00050_check_login_button
    @login_page.check_signin_button
    assert @login_page.login_login_button.present?
  end

  def test_00060_check_login_page_title
    @login_page.check_login_page_title
    assert @login_page.login_page_title.present?
  end

  user :network_admin
  p1
  def test_00070_login
    @login_page.login!(@c.users[:network_admin])
    assert @login_page.user_dropdown.present?
    @login_page.logout!
  end

  user :anonymous
  p1
  def test_00080_check_forgot_pass_link_on_login
    @login_page.check_forgot_password_link
    assert @login_page.password_reset_page.present?
    assert @login_page.forgot_password_captcha.present?
  end

  def test_00090_check_social_login_button
    @login_page.check_social_login_button
    assert @login_page.login_facebook_button.present?
    assert @login_page.login_linkedin_button.present?
    assert @login_page.login_twitter_button.present?
    assert @login_page.login_gmail_button.present?
  end

  def test_00100_check_register_link_on_login
    @login_page.check_register_link_on_login
    assert @login_page.register_body.present?
  end

  def test_00110_check_register_link_text_on_login
    @login_page.check_register_link_text_on_login
    assert @login_page.login_page_register_text.present?
  end

  def test_00120_check_faq_link_on_login
    @login_page.check_faq_link
    assert @login_page.faq_body.present?
  end

  def test_00130_check_faq_link_text_on_login
    @login_page.check_faq_text
    assert @login_page.login_page_faq_text.present?
  end

  def test_00140_check_confirm_instrc_link_on_login
    @login_page.check_confirm_instrc_link
    assert @login_page.confirm_body.present?
  end

  user :social_facebook_user
  p1
  def test_00150_do_fb_social_login
    @login_page.do_social_login("Facebook")
    assert @login_page.user_dropdown.present?
    @login_page.logout!
  end

  user :social_twitter_user
  def test_00160_do_twi_social_login
    @login_page.do_social_login("Twitter")
    assert @login_page.user_dropdown.present?
    @login_page.logout!
  end

  user :social_linkedin_user
  def test_00170_do_linkedin_social_login
    @login_page.do_social_login("Linkedin")
    assert @login_page.user_dropdown.present?
    @login_page.logout!
  end

  user :social_google_user
  def xtest_00180_do_gmail_login
    @login_page.do_social_login("Google")
    assert @login_page.user_dropdown.present?
    @login_page.logout!
  end

  user :network_admin
  def test_00181_check_admin_social_login
    @community_admin_page.navigate_in
    @community_admin_page.switch_to_sidebar_item(:social_app)
    @browser.wait_until{ @community_admin_social_app_page.social_form.present? }
    assert @community_admin_social_app_page.social_form.text.include? "facebook"
    assert @community_admin_social_app_page.social_form.text.include? "google"
    assert @community_admin_social_app_page.social_form.text.include? "linkedin"
    assert @community_admin_social_app_page.social_form.text.include? "twitter"
    @community_admin_social_app_page.turn_on_off_btn_click("facebook")
    @login_page.logout!
    @login_page.click_signin_link
    assert !@login_page.login_facebook_button.present?
    @login_page.login!(@c.users[:network_admin])
    @community_admin_page.navigate_in
    @community_admin_page.switch_to_sidebar_item(:social_app)
    @browser.wait_until{ @community_admin_social_app_page.social_form.present? }
    @community_admin_social_app_page.turn_on_off_btn_click("facebook")
    @login_page.logout!
  end

  user :anonymous
  # def test_00190_check_register_page_title
  #   @login_page.check_register_page_title
  #   assert @login_page.register_page_title.present?
  # end
  #
  # def test_00200_check_register_username
  #   @login_page.check_register_username_field
  #   assert @login_page.register_page_username.present?
  # end
  #
  # def test_00210_check_register_pass
  #   @login_page.check_register_pass_field
  #   assert @login_page.register_page_password.present?
  # end
  #
  # def test_00220_check_register_email
  #   @login_page.check_register_email_field
  #   assert @login_page.register_page_email.present?
  # end
  #
  # def test_00230_check_register_captcha
  #   @login_page.check_register_captcha_field
  #   assert @login_page.register_page_captcha_code.present?
  # end

  def test_00240_check_register_button
    @login_page.check_register_button
    assert @login_page.register_page_register_button.present?
  end

  def test_00250_check_login_link_on_register
    @login_page.check_signin_link_from_register
    assert @login_page.login_body.present?
  end

  def test_00260_check_login_text_on_register
    @login_page.check_signin_link_text_from_register
    assert @login_page.register_page_signin_text.present?
  end

  def test_00270_check_faq_link_on_register
    @login_page.check_faq_link_from_register
    @browser.windows.last.use do
      assert @login_page.faq_body.present?
      @browser.window.close
    end
  end

  def test_00280_check_faq_link_text_on_register
    @login_page.check_faq_link_text_from_register
    assert @login_page.register_page_faq_text.present?
  end

  def test_00290_login_using_invalid_username
    @login_page.check_invalid_username_login
    assert @login_page.invalid_login.present?
  end

  def test_00300_login_using_invalid_pass
    @login_page.check_invalid_password_login
    assert @login_page.invalid_login.present?
  end

  user :network_admin
  def test_00310_login_with_email
    @login_page.login_with("email", @c.users[:network_admin])
    assert @login_page.user_dropdown.present?
    @login_page.logout!
  end

  user :regular_user1
  def test_00320_logout
   @login_page.login(@c.users[:regular_user1])
   @login_page.logout!
   assert !@login_page.signin.present?
  end

  def test_00330_login_with_username
    @login_page.login_with("username", @c.users[:regular_user1])
    assert @login_page.user_dropdown.present?
    @login_page.logout!
  end

  def test_00340_login_with_moderator
    @login_page.login_with("email", @c.users[:network_moderator])
    assert @login_page.user_dropdown.present?
    @login_page.logout!
  end

  def test_00350_login_with_blogger
    @login_page.login_with("username", @c.users[:nf_network_blogger])
    assert @login_page.user_dropdown.present?
    @login_page.logout!
  end

end