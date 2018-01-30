require File.expand_path(File.dirname(__FILE__) + "/excelsior_watir_test.rb")
require File.expand_path(File.dirname(__FILE__) + "/../lib/test_helper.rb")
#require File.expand_path(File.dirname(__FILE__) + "/../lib/page_objects/community_profile_page.rb")
require File.expand_path(File.dirname(__FILE__) + "/../lib/watir_lib.rb")

class LoginPageTest < ExcelsiorWatirTest
  include WatirLib
  def setup
    super
    @loginpage = CommunityLoginPage.new(@browser)
  end

  #============ ANON USER TESTS ==========================#
  #=================================================================#

  #======== login page, log in with username or email, register, social login, etc. tests ============#
  def test_p1_00010_goto_login_page
  	@loginpage.click_signin_link
  	assert @loginpage.login_body.present?
    @loginpage.newline
  end

  def test_p1_00020_goto_register_page
  	@loginpage.click_signin_register_link
  	assert @loginpage.register_body.present?
    @loginpage.newline
  end

  def test_p1_00030_check_login_username_pass_field
  	@loginpage.check_username_field 
  	assert @loginpage.login_user_field.present?

  	@loginpage.check_pass_field 
  	assert @loginpage.login_password_field.present?
    @loginpage.newline
  end

  def test_00040_check_login_username_pass_placeholder
  	@loginpage.check_login_username_field_placeholder
  	assert @loginpage.login_username_placeholder.present?

  	@loginpage.check_login_pass_field_placeholder
  	assert @loginpage.login_password_placeholder.present?
    @loginpage.newline
  end

  def test_p1_00050_check_login_button
  	@loginpage.check_signin_button
  	assert @loginpage.login_login_button.present?
    @loginpage.newline
  end

  def test_p1_00060_check_login_page_title
  	@loginpage.check_login_page_title
  	assert @loginpage.login_page_title.present?
    @loginpage.newline
  end

  def test_p1_00070_login
  	@loginpage.login($user1)
  	assert @loginpage.username_dropdown.present?
    @loginpage.newline
  end

  def test_p1_00080_check_forgot_pass_link_on_login
  	@loginpage.check_forgot_password_link
  	assert @loginpage.password_reset_page.present?
  	assert @loginpage.forgot_password_captcha.present?
    @loginpage.newline
  end

  def test_p1_00090_check_social_login_button
  	@loginpage.check_social_login_button
  	assert @loginpage.login_facebook_button.present? 
  	assert @loginpage.login_linkedin_button.present? 
  	assert @loginpage.login_twitter_button.present? 
  	assert @loginpage.login_gmail_button.present? 
    @loginpage.newline
  end

  def test_p1_00100_check_register_link_on_login
  	@loginpage.check_register_link_on_login
  	assert @loginpage.register_body.present?
    @loginpage.newline
  end

  def test_p1_00110_check_register_link_text_on_login
  	@loginpage.check_register_link_text_on_login
  	assert @loginpage.login_page_register_text.present?
    @loginpage.newline
  end

  def test_p1_00110_check_faq_link_on_login
  	@loginpage.check_faq_link
  	assert @loginpage.faq_body.present?
    @loginpage.newline
  end

  def test_p1_00120_check_faq_link_text_on_login
  	@loginpage.check_faq_text
  	assert @loginpage.login_page_faq_text.present?
    @loginpage.newline
  end

  def test_p1_00130_check_confirm_instrc_link_on_login
  	@loginpage.check_confirm_instrc_link
  	assert @loginpage.confirm_body.present?
    @loginpage.newline
  end

  def test_p1_00140_do_fb_social_login
  	@loginpage.do_social_login("Facebook")
  	assert @loginpage.username_dropdown.present?
    @loginpage.signout
    @loginpage.newline
  end

  def test_p1_00150_do_twi_social_login
  	@loginpage.do_social_login("Twitter")
  	assert @loginpage.username_dropdown.present?
    @loginpage.signout
    @loginpage.newline
  end

  def test_p1_00160_do_linkedin_social_login
  	@loginpage.do_social_login("Linkedin")
  	assert @loginpage.username_dropdown.present?
    @loginpage.signout
    @loginpage.newline
  end

  def test_p1_00170_do_gmail_login
  	@loginpage.do_social_login("Google")
  	assert @loginpage.username_dropdown.present?
    @loginpage.signout
    @loginpage.newline
  end

  def test_p1_00180_check_register_page_title
  	@loginpage.check_register_page_title
  	assert @loginpage.register_page_title.present?
    @loginpage.newline
  end

  def test_p1_00190_check_register_username
  	@loginpage.check_register_username_field
  	assert @loginpage.register_page_username.present?
    @loginpage.newline
  end

  def test_p1_00200_check_register_pass
  	@loginpage.check_register_pass_field
  	assert @loginpage.register_page_password.present?
    @loginpage.newline
  end

  def test_p1_00210_check_register_email
  	@loginpage.check_register_email_field
  	assert @loginpage.register_page_email.present?
    @loginpage.newline
  end

  def test_p1_00220_check_register_captcha
  	@loginpage.check_register_captcha_field
  	assert @loginpage.register_page_captcha_code.present?
    @loginpage.newline
  end

  def test_p1_00230_check_register_button
  	@loginpage.check_register_button
  	assert @loginpage.register_page_register_button.present?
    @loginpage.newline
  end

  def test_p1_00240_check_login_link_on_register
  	@loginpage.check_signin_link_from_register
  	assert @loginpage.login_body.present?
    @loginpage.newline
  end

  def test_p1_00250_check_login_text_on_register
  	@loginpage.check_signin_link_text_from_register
  	assert @loginpage.register_page_signin_text.present?
    @loginpage.newline
  end

  def test_p1_00260_check_faq_link_on_register
  	@loginpage.check_faq_link_from_register
  	assert @loginpage.faq_body.present?
    @loginpage.newline
  end

  def test_p1_00270_check_faq_link_text_on_register
  	@loginpage.check_faq_link_text_from_register
  	assert @loginpage.register_page_faq_text.present?
    @loginpage.newline
  end

  def test_p1_00280_login_using_invalid_username
  	@loginpage.check_invalid_username_login
  	assert @loginpage.invalid_login.present?
    @loginpage.newline
  end

  def test_p1_00290_login_using_invalid_pass
  	@loginpage.check_invalid_password_login
  	assert @loginpage.invalid_login.present?
    @loginpage.newline
  end

  def test_p1_00300_login_with_email
  	@loginpage.login_with("email", $user1)
  	assert @loginpage.username_dropdown.present?
    @loginpage.newline
  end

  def test_p1_00400_signout
   @loginpage.signout 
   assert !@loginpage.username_dropdown.present?
   @loginpage.newline
  end

end