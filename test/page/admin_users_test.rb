require 'watir_test'
require 'pages/community/admin'
require 'pages/community/layout'
require 'pages/community/admin_users'
require 'pages/mail_catcher'

class AdminUsersTest < WatirTest

  def setup
    super
    @admin_users_page = Pages::Community::AdminUsers.new(@config)
    @login_page = Pages::Community::Login.new(@config)
    @mail_catcher = Pages::MailCatcher.new(@config)

    # assigning @current_page helps error reporting
    #  give good contextual data
    @current_page = @admin_users_page
    puts "[[[ #{name} ::: #{user_for_test} ]]]" if @config.verbose?
    @browser = @config.browser
    @admin_users_page.start!(user_for_test)
  end

  def teardown
    super
  end

  p1

  user :network_admin
  def test_00010_inviate_and_delete_user
    user_email = "user#{get_timestamp}@test.com".downcase
    user_row = @admin_users_page.invite_user user_email, "#{get_timestamp} preview message" 
    assert user_row.text.include? "Pending"
    @browser.execute_script( "window.open('#{@config.mail_catcher_url}')" )
    #@browser.goto @config.mail_catcher_url   
    @browser.window(:url => /#{@config.mail_catcher_url}/).when_present.use do
      mail_link = @mail_catcher.goto_invitation_mail user_email
      @browser.goto mail_link
      @browser.wait_until{ @mail_catcher.register_link.present? }
      @browser.window.close
    end
    @admin_users_page.delete_user user_email
    @admin_users_page.search_user user_email, false
    assert @admin_users_page.user_list_empty_label.present?
  end

  def test_00020_view_user_profile
    @admin_users_page.switch_to_tab :list
    @admin_users_page.filter :active
    @admin_users_page.view_profile @config.users[:regular_user1].name
  end

  def test_00030_filter_user
    @admin_users_page.switch_to_tab :list
    @admin_users_page.filter :active
    @admin_users_page.filter :pending
    @admin_users_page.filter :banned
  end

  def test_00040_reset_user_password
    @admin_users_page.switch_to_tab :list
    @admin_users_page.filter :active
    @admin_users_page.reset_password @config.users[:regular_user7].username

    @browser.execute_script( "window.open('#{@config.mail_catcher_url}')" )
    #@browser.goto @config.mail_catcher_url   
    @browser.window(:url => /#{@config.mail_catcher_url}/).when_present.use do
      mail_link = @mail_catcher.goto_reset_mail @config.users[:regular_user7].email
      @browser.goto mail_link
      @browser.wait_until{ @mail_catcher.reset_pwd_link.present? }
      @browser.window.close
    end
  end

  def test_00050_ban_and_remove_ban_single_user
    @admin_users_page.switch_to_tab :list
    @admin_users_page.filter :active
    @admin_users_page.ban_user @config.users[:regular_user7].username, "ban at #{get_timestamp}"
    
    @login_page.logout!
    @login_page.click_signin_link
    @login_page.login_with_username_and_password(@config.users[:regular_user7])
    @browser.wait_until{ @login_page.login_error_msg.present? }
    assert @login_page.login_error_msg.text.include? "You no longer have access to this community."

    @login_page.about_login("network_admin", "logged")
    @admin_users_page.navigate_in

    @admin_users_page.switch_to_tab :list
    @admin_users_page.filter :banned
    @admin_users_page.remove_ban_user @config.users[:regular_user7].username

    @login_page.logout!
    @login_page.about_login("regular_user7", "logged")
  ensure
    @login_page.about_login("network_admin", "logged")
    @admin_users_page.navigate_in
    @admin_users_page.switch_to_tab :list
    @admin_users_page.ensure_remove_banned_user @config.users[:regular_user7].username
  end

  def test_00060_ban_and_remove_ban_multiple_users
    @admin_users_page.switch_to_tab :list
    @admin_users_page.filter :active
    @admin_users_page.ban_users [@config.users[:regular_user7].username,@config.users[:regular_user8].username], "ban at #{get_timestamp}"
    
    @login_page.logout!
    @login_page.click_signin_link
    @login_page.login_with_username_and_password(@config.users[:regular_user7])
    @browser.wait_until{ @login_page.login_error_msg.present? }
    assert @login_page.login_error_msg.text.include? "You no longer have access to this community."

    @login_page.click_signin_link
    @login_page.login_with_username_and_password(@config.users[:regular_user8])
    @browser.wait_until{ @login_page.login_error_msg.present? }
    assert @login_page.login_error_msg.text.include? "You no longer have access to this community."

    @login_page.about_login("network_admin", "logged")
    @admin_users_page.navigate_in

    @admin_users_page.switch_to_tab :list
    @admin_users_page.filter :banned
    @admin_users_page.remove_ban_users [@config.users[:regular_user7].username,@config.users[:regular_user8].username]

    @login_page.logout!
    @login_page.about_login("regular_user7", "logged")

    @login_page.logout!
    @login_page.about_login("regular_user8", "logged")
  ensure
    @login_page.about_login("network_admin", "logged")
    @admin_users_page.navigate_in
    @admin_users_page.switch_to_tab :list
    @admin_users_page.ensure_remove_banned_user @config.users[:regular_user7].username
    @admin_users_page.ensure_remove_banned_user @config.users[:regular_user8].username
  end

  def test_00070_pagination
    @admin_users_page.switch_to_tab :list
    @admin_users_page.filter :active
    @browser.wait_until{ @admin_users_page.pagination_bar.present? }
    assert @admin_users_page.first_btn.class_name.include? "disabled"
    assert @admin_users_page.pre_btn.class_name.include? "disabled"

    @admin_users_page.pagination_to 2
    assert !(@admin_users_page.first_btn.class_name.include? "disabled")
    assert !(@admin_users_page.pre_btn.class_name.include? "disabled")
    assert !(@admin_users_page.next_btn.class_name.include? "disabled")
    assert !(@admin_users_page.last_btn.class_name.include? "disabled")

    @admin_users_page.pagination_to :next
    assert !(@admin_users_page.first_btn.class_name.include? "disabled")
    assert !(@admin_users_page.pre_btn.class_name.include? "disabled")
    assert !(@admin_users_page.next_btn.class_name.include? "disabled")
    assert !(@admin_users_page.last_btn.class_name.include? "disabled")

    @admin_users_page.pagination_to :previous
    assert !(@admin_users_page.first_btn.class_name.include? "disabled")
    assert !(@admin_users_page.pre_btn.class_name.include? "disabled")
    assert !(@admin_users_page.next_btn.class_name.include? "disabled")
    assert !(@admin_users_page.last_btn.class_name.include? "disabled")

    @admin_users_page.pagination_to :first
    assert @admin_users_page.first_btn.class_name.include? "disabled"
    assert @admin_users_page.pre_btn.class_name.include? "disabled"
    assert !(@admin_users_page.next_btn.class_name.include? "disabled")
    assert !(@admin_users_page.last_btn.class_name.include? "disabled")

    @admin_users_page.pagination_to :last
    assert !(@admin_users_page.first_btn.class_name.include? "disabled")
    assert !(@admin_users_page.pre_btn.class_name.include? "disabled")
    assert @admin_users_page.next_btn.class_name.include? "disabled"
    assert @admin_users_page.last_btn.class_name.include? "disabled"
  end

  def test_00080_delete_multiple_users
    user1 = "1user#{get_timestamp}@test.com".downcase
    user2 = "2user#{get_timestamp}@test.com".downcase
    user_emails = [user1, user2]
    @admin_users_page.invite_users user_emails

    @admin_users_page.switch_to_tab :list
    @admin_users_page.delete_users user_emails 

    for user in user_emails
        @admin_users_page.search_user user, false
        assert @admin_users_page.user_list_empty_label.present?
    end
  end

end