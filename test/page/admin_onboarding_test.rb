require 'watir_test'
require 'pages/api_doc/swagger'
require 'pages/community/admin_permissions'
require 'pages/mail_catcher'
require 'pages/community/admin_onboarding'
require 'pages/community/admin_setup'
require 'pages/community/admin_topics'
require 'pages/community/admin_moderation'
require 'pages/community/admin_ui_customization'
require 'pages/community/admin_ecom_and_oauth'
require 'pages/community/admin_users'


class AdminOnBoardingTest < WatirTest
  def setup
    super
    #@swagger_page = Pages::APIDoc::Swagger.new(@config)
    @api_page = Pages::APIDoc.new(@config)
    @admin_perm_page = Pages::Community::AdminPermissions.new(@config)
    @about_page = Pages::Community::About.new(@config)
    @mail_catcher = Pages::MailCatcher.new(@config)
    @login_page = Pages::Community::Login.new(@config)
    @admin_on_boarding_page = Pages::Community::AdminOnBoarding.new(@config)
    @admin_setup_page = Pages::Community::AdminSetup.new(@config)
    @admin_topics_page = Pages::Community::AdminTopics.new(@config)
    @admin_mod_page = Pages::Community::AdminModeration.new(@config)
    @admin_integration_page = Pages::Community::AdminEcomAndOauth.new(@config)
    @admin_branding_page = Pages::Community::AdminUICustomization.new(@config)
    @admin_users_page = Pages::Community::AdminUsers.new(@config)
    # assigning @current_page helps error reporting
    #  give good contextual data
    puts "[[[ #{name} ::: #{user_for_test} ]]]" if @config.verbose?
    @browser = @config.browser
  end

  def teardown
    super
  end

  p1
  def test_00010_test_on_boarding
  	username = "user#{get_timestamp}".downcase
  	email = "#{username}@test.com"
  	password = "Passw0rd!"
  	user = WatirConfig::User.new("", email, password, username)

  	status = @api_page.api_register_user user
  	assert status == 201
  	@mail_catcher.confirm_email email
  	@admin_perm_page.promote_user_role(user, :net_admin)
 
  	# username = "user20171206062718utc".downcase
  	# email = "#{username}@test.com"
  	# password = "Passw0rd!"
  	# user = WatirConfig::User.new("", email, password, username)

  	@login_page.login_with("username", user)
	@admin_on_boarding_page.show_me_around_btn.when_present.click
 
  	@browser.wait_until { @admin_on_boarding_page.onboarding_container.present? }
  	@browser.wait_until { @admin_setup_page.community_name_input.present? }
  	assert @admin_on_boarding_page.task_is_actived :setup
  	assert @admin_on_boarding_page.task_is_new :feature_mgr
  	assert @admin_on_boarding_page.task_is_new :content_mod
  	assert @admin_on_boarding_page.task_is_new :integration
  	assert @admin_on_boarding_page.task_is_new :branding
  	assert @admin_on_boarding_page.task_is_new :user_mgr
  	assert @admin_on_boarding_page.step_desc.text == "Choose the language and the implementation method for your community."

  	@admin_on_boarding_page.go_to_task :feature_mgr
  	@browser.wait_until { @admin_topics_page.admin_topics_content.present? }
  	@browser.wait_until { @admin_on_boarding_page.task_is_actived :feature_mgr }
	@browser.wait_until { @admin_on_boarding_page.task_is_completed :setup }
	assert @admin_on_boarding_page.step_desc.text == "Create a topic to encourage engagement within your community."
  	
  	@admin_on_boarding_page.go_to_task :branding
  	@browser.wait_until { @admin_branding_page.ui_custom_create_new_tp_link.present? }
  	@browser.wait_until { @admin_on_boarding_page.task_is_actived :branding }
  	@browser.wait_until { @admin_on_boarding_page.task_is_completed :feature_mgr }
  	assert @admin_on_boarding_page.task_is_completed :setup
  	assert @admin_on_boarding_page.step_desc.text == "Customize the style and appearance of your community."

  	@admin_on_boarding_page.go_to_task :integration
  	@browser.wait_until { @admin_integration_page.ecomm_int_settings_active_prod_radio.present? }
  	@browser.wait_until { @admin_on_boarding_page.task_is_actived :integration }
  	@browser.wait_until { @admin_on_boarding_page.task_is_completed :branding }
  	assert @admin_on_boarding_page.task_is_completed :feature_mgr
  	assert @admin_on_boarding_page.step_desc.text == "Configure your e-commerce integration if applicable."
  
  	@admin_on_boarding_page.go_to_task :user_mgr
  	@admin_users_page.wait_until_admin_users_page_loaded
  	@browser.wait_until { @admin_on_boarding_page.task_is_actived :user_mgr }
  	@browser.wait_until { @admin_on_boarding_page.task_is_completed :integration }
  	assert @admin_on_boarding_page.task_is_completed :branding
  	assert @admin_on_boarding_page.step_desc.text == "Invite users to your community."

  	#test container exist after refreshing page
  	@browser.refresh
  	@admin_users_page.wait_until_admin_users_page_loaded
  	@browser.wait_until { @admin_on_boarding_page.onboarding_container.present? }

  	@admin_on_boarding_page.go_to_task :content_mod
  	@browser.wait_until { @admin_mod_page.mod_settings_tab_link.present? }
  	@browser.wait_until { @admin_on_boarding_page.task_is_actived :content_mod }
  	@browser.wait_until { @admin_on_boarding_page.task_is_completed :user_mgr }
  	assert @admin_on_boarding_page.task_is_completed :integration
  	assert @admin_on_boarding_page.step_desc.text == "Select the review level for content posted in your community."

  	@admin_on_boarding_page.go_to_task :setup
  	@browser.wait_until { @admin_setup_page.community_name_input.present? }
  	@browser.wait_until { @admin_on_boarding_page.task_is_completed :content_mod }
  	assert @admin_on_boarding_page.task_is_completed :setup
  	assert @admin_on_boarding_page.task_is_completed :feature_mgr
  	assert @admin_on_boarding_page.task_is_completed :integration
  	assert @admin_on_boarding_page.task_is_completed :branding
  	assert @admin_on_boarding_page.task_is_completed :user_mgr
  	assert @admin_on_boarding_page.step_desc.text == "Congratulations, you have completed the suggested setup steps."

  	@browser.refresh
  	@browser.wait_until { @admin_setup_page.community_name_input.present? }
  	assert !(@admin_on_boarding_page.onboarding_container.present?)

  	#### delete user ######
  	@login_page.logout!
  	@login_page.about_login("network_admin", "logged")
    @admin_users_page.navigate_in
    @admin_users_page.switch_to_tab :list
    @admin_users_page.delete_user email
  end

end
