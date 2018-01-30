require 'watir_test'
require 'pages/community'
require 'pages/community/admin'
require 'pages/community/about'
require 'pages/community/layout'
require 'pages/community/topic_list'
require 'actions/hybris/api'
require 'pages/community/profile'

require 'pages/community/admin_permissions'
class AdminPermissionsTest < WatirTest

  def setup
    super
    @about_page = Pages::Community::About.new(@config)
    @admin_page = Pages::Community::Admin.new(@config)
    @layout_page = Pages::Community::Layout.new(@config)
    @admin_perm_page = Pages::Community::AdminPermissions.new(@config)
    @admin_topics_page = Pages::Community::AdminTopics.new(@config)
    @convdetail_page = Pages::Community::ConversationDetail.new(@config)
    @admin_mod_page = Pages::Community::AdminModeration.new(@config)
    @login_page = Pages::Community::Login.new(@config)
    @community_page = Pages::Community.new(@config)
    @topicdetail_page = Pages::Community::TopicDetail.new(@config)
    @topiclist_page = Pages::Community::TopicList.new(@config)
    @profile_page = Pages::Community::Profile.new(@config)
    @api_actions = Actions::Api.new(@config)

    # prepare data for permission test
    @topic_for_permission_test = "A Watir Topic"
    @topic2_for_permission_test = "A Watir Topic With Many Posts"
    @topic1_id = @topiclist_page.get_topic_uuid_by_title(@topic_for_permission_test)
    @topic2_id = @topiclist_page.get_topic_uuid_by_title(@topic2_for_permission_test)
    @user6_id = @profile_page.get_user_uuid_by_name(:regular_user6)
    @api_actions.remove_user_role_from_topic_scope(admin: @config.users[:network_admin], user_id: @user6_id, topic_id: @topic1_id)
    @api_actions.remove_user_role_from_topic_scope(admin: @config.users[:network_admin], user_id: @user6_id, topic_id: @topic1_id, role: :moderator)
    @api_actions.remove_user_role_from_topic_scope(admin: @config.users[:network_admin], user_id: @user6_id, topic_id: @topic2_id)
    @api_actions.remove_user_role_from_topic_scope(admin: @config.users[:network_admin], user_id: @user6_id, topic_id: @topic2_id, role: :moderator)
    @api_actions.remove_user_role_from_network_scope(admin: @config.users[:network_admin], user_id: @user6_id)
    @api_actions.remove_user_role_from_network_scope(admin: @config.users[:network_admin], user_id: @user6_id, role: :moderator)

    # assigning @current_page helps error reporting
    #  give good contextual data
    @current_page = @admin_perm_page
    puts "[[[ #{name} ::: #{user_for_test} ]]]" if @config.verbose?
    @browser = @config.browser
    @about_page.start!(user_for_test)
  end

  def teardown
    super
  end

  p1

  user :regular_user2
  def test_00010_check_no_admin_for_reg
    @about_page.user_dropdown.when_present.click
    @browser.wait_until { @about_page.user_dropdown_menu.present? }

    # verify no Admin menu item for no-admin user
    assert !@layout_page.admin_link.present?
  end

  user :network_admin
  def test_00020_check_admin_role_and_option
    @about_page.user_dropdown.when_present.click
    @browser.wait_until { @about_page.user_dropdown_menu.present? }
    @browser.wait_until { @layout_page.admin_link.present? }

    # verify there appears Admin menu item for admin user
    assert @layout_page.admin_link.present?
  end

  def test_00040_goto_admin_page
    @admin_page.navigate_in_from_ui

    # verify admin user can go to Admin page
    assert @admin_page.sidebar_present?
  end

  p2
  def test_00050_check_default_on_admin_page
    @admin_page.navigate_in_from_ui

    @browser.wait_until { @admin_page.sidebar_item(:overview).class_name.include?("active") }
    assert_match /active/, @admin_page.sidebar_item(:overview).class_name
  end

  p1
  def test_00050_check_permission_option
    netadmin_tab = @admin_perm_page.navigate_in
    # assert @admin_perm_page.permission_card.present?
    @browser.wait_until { netadmin_tab.member_at_index(0).present? }

    # by default Community->Administrators tab selected and there at least exits an admin
    assert netadmin_tab.member_at_index(0).present?
  end

  def test_00060_promote_a_user_as_net_admin 
    # NOTE: Please DO NOT promote user1 to admin since it will go on-boarding process (beta feature 1711_on_boarding)
    # after promoted which will fail other cases using it. So, an isolated user needed here.
    # promote user 6 as network administrator
    @admin_perm_page.promote_user_role(@config.users[:regular_user6], :net_admin)

    @about_page.about_login("regular_user6", "logged")
    @admin_page.navigate_in
    assert @admin_page.sidebar_present?
    @admin_page.assert_all_admin_tabs_with_network_admin_capability
  ensure
    @api_actions.remove_user_role_from_network_scope(admin: @config.users[:network_admin], user_id: @user6_id)
  end

  def test_00070_promote_a_user_as_net_mod
    # promote user 1 as network moderator
    @admin_perm_page.promote_user_role(@config.users[:regular_user6], :net_mod)

    # login with user 1
    @about_page.about_login("regular_user6", "logged")

    # go to Admin
    @admin_page.navigate_in

    # go to Admin->Moderator
    @admin_page.accept_policy_warning
    @admin_page.switch_to_sidebar_item(:moderation)
    @browser.wait_until { @admin_mod_page.pending_approval_tab.present? }

    # verify only Admin->Moderator is available in the sidebar
    assert !@admin_page.sidebar_item(:topics).present?
    assert !@admin_page.sidebar_item(:home).present?
    assert !@admin_page.sidebar_item(:about).present?
    assert !@admin_page.sidebar_item(:analytics).present?
    assert !@admin_page.sidebar_item(:advertising).present?
    assert !@admin_page.sidebar_item(:disclosures).present?
    assert !@admin_page.sidebar_item(:branding).present?
    assert !@admin_page.sidebar_item(:email_designer).present?
    assert !@admin_page.sidebar_item(:profile_field).present?
    assert !@admin_page.sidebar_item(:permissions).present?
    assert !@admin_page.sidebar_item(:reports).present?

    # verify Pending Approval tab available but no Settings tab
    assert @admin_mod_page.pending_approval_tab.present?
    assert @admin_mod_page.mod_flagged_tab_link.present?
    assert @admin_mod_page.mod_perm_removed_tab_link.present?
    assert !@admin_mod_page.mod_settings_tab_link.present?
  ensure
    @api_actions.remove_user_role_from_network_scope(admin: @config.users[:network_admin], user_id: @user6_id, role: :moderator)
  end

  def test_00080_check_designated_network_admin_can_do_all_actions_as_network_admin
    @admin_perm_page.promote_user_role(@config.users[:regular_user6], :net_admin)
    @about_page.about_login("regular_user6", "logged")

    # verify the user can go to Admin page
    @admin_page.navigate_in
    assert @admin_page.sidebar_present?
    @admin_page.assert_all_admin_tabs_with_network_admin_capability

    # go to topic page: 1. +New Topic is visible 2. can create blog
    @topiclist_page.navigate_in
    @browser.wait_until { @topiclist_page.topic_create_link.present? }
    @topiclist_page.admins_and_moderators_with_network_scope_can_create_blog

    # remove user 6 from network administators
  ensure
    @api_actions.remove_user_role_from_network_scope(admin: @config.users[:network_admin], user_id: @user6_id)
  end

  def test_00090_check_designated_network_moderator_can_do_all_actions_as_network_moderator
    # promote user 1 as network moderator
    @admin_perm_page.promote_user_role(@config.users[:regular_user6], :net_mod)

    # login with user 1
    @about_page.about_login("regular_user6", "logged")

    # go to Admin
    @admin_page.navigate_in

    # go to Admin->Moderator
    @admin_page.accept_policy_warning
    @admin_page.switch_to_sidebar_item(:moderation)
    @browser.wait_until { @admin_mod_page.pending_approval_tab.present? }

    # verify only Admin->Moderator is available in the sidebar
    assert !@admin_page.sidebar_item(:topics).present?
    assert !@admin_page.sidebar_item(:home).present?
    assert !@admin_page.sidebar_item(:about).present?
    assert !@admin_page.sidebar_item(:analytics).present?
    assert !@admin_page.sidebar_item(:advertising).present?
    assert !@admin_page.sidebar_item(:disclosures).present?
    assert !@admin_page.sidebar_item(:branding).present?
    assert !@admin_page.sidebar_item(:email_designer).present?
    assert !@admin_page.sidebar_item(:profile_field).present?
    assert !@admin_page.sidebar_item(:permissions).present?
    assert !@admin_page.sidebar_item(:reports).present?

    # verify Pending Approval tab available but no Settings tab
    assert @admin_mod_page.pending_approval_tab.present?
    assert @admin_mod_page.mod_flagged_tab_link.present?
    assert @admin_mod_page.mod_perm_removed_tab_link.present?
    assert !@admin_mod_page.mod_settings_tab_link.present?

    # go to topiclist page, expect result: +New Topic is invisible
    @topiclist_page.navigate_in
    assert !@topiclist_page.topic_create_link.present?

    # Create New Blog is available. Moderator can create a blog
    @topiclist_page.admins_and_moderators_with_network_scope_can_create_blog
  ensure
    @api_actions.remove_user_role_from_network_scope(admin: @config.users[:network_admin], user_id: @user6_id, role: :moderator)
  end

  def test_00100_network_admin_can_remove_designated_network_admin
    @admin_perm_page.promote_user_role(@config.users[:regular_user6], :net_admin)
    @admin_perm_page.remove_user_role(@config.users[:regular_user6], :net_admin)

    # login with user 6
    @about_page.about_login("regular_user6", "logged")

    # For UI side, should not see "Admin" option
    assert !@admin_page.can_see_admin_dropdown_option?

    # For URLs side, should not have access to any admin sites
    @browser.goto @config.base_url+ "/admin/#{@config.slug}"
    @browser.wait_until { @topiclist_page.topic_list.present? }
    @browser.wait_until { !@topiclist_page.topic_list_placeholder.present? }
    @browser.wait_until { @topiclist_page.topiccard_list.topic_cards.size > 0 ||
                          @topiclist_page.topiclist_empty_text.present? }
    assert @topiclist_page.topic_list.present?
    assert !@admin_page.sidebar_present?
  end

  def test_00110_network_admin_can_remove_designated_network_moderator
    # promote user 1 as network moderator
    @admin_perm_page.promote_user_role(@config.users[:regular_user6], :net_mod)

    @admin_perm_page.remove_user_role(@config.users[:regular_user6], :net_mod)

    # login with user 6
    @about_page.about_login("regular_user6", "logged")

    # verify loggedin successfully or not
    @browser.wait_until { @about_page.user_dropdown.present? }
    @about_page.user_dropdown.click
    @browser.wait_until { @about_page.user_dropdown_menu.present? }

    # For UI side, should not see "Admin" option
    assert !@about_page.admin_link.present?

    # For URLs side, should not have access to any moderator sites
    @browser.goto @config.base_url+ "/admin/#{@config.slug}"

    @browser.wait_until { @topiclist_page.topic_list.present? }
    @browser.wait_until { !@topiclist_page.topic_list_placeholder.present? }
    @browser.wait_until { @topiclist_page.topiccard_list.topic_cards.size > 0 ||
                          @topiclist_page.topiclist_empty_text.present? }

    assert @topiclist_page.topic_list.present? 
    assert !@admin_page.sidebar_present?
  end

  def test_00120_check_blogger_under_modertion
    @admin_perm_page.promote_user_role(@config.users[:regular_user6], :net_blog)
    blogger_blog_title = "Blog created by Watir6 for blogger - #{get_timestamp}"

    @community_page.about_login("regular_user6","logged")

    @topiclist_page.go_to_topic(@topic_for_permission_test)
    @topicdetail_page.create_conversation(type: :blog,
                                          title: blogger_blog_title,
                                          details: [{type: :text, content: "Watir test description"}])
    conv_url = @browser.url
    @browser.refresh

    @community_page.about_login("regular_user2","logged")
    @convdetail_page.user_check_post_by_url(conv_url)
    mod_msg = "This post is pending approval. You will be able to see it once it is approved."
    assert @convdetail_page.conv_moderation_alert.text == mod_msg, "normal user can see the post when moderation on posts pending approval."

    @admin_mod_page.start!("network_admin")
    @admin_mod_page.admin_check_post_in_pending_approval
    assert (@admin_mod_page.mod_posts.text.include?blogger_blog_title) , "admin cannot approve the blog."
    @admin_mod_page.admin_approve_post_pending_approval(blogger_blog_title)

    @community_page.about_login("regular_user2","logged")
    @convdetail_page.user_check_post_by_url(conv_url)
    assert @convdetail_page.root_post_title.text == blogger_blog_title, "normal user cannot see the blog after approval."

    @admin_perm_page.remove_user_role(@config.users[:regular_user6], :net_blog)

    @community_page.about_login("regular_user6","logged")
    @topicdetail_page = @topiclist_page.go_to_topic(@topic_for_permission_test)

    @topicdetail_page.topic_create_new_button.when_present
    @browser.wait_until { !@topicdetail_page.topic_detail_loading_block.present? }
    @topicdetail_page.topic_create_new_button.click
    @topicdetail_page.topic_create_new_question_menu_item.when_present
    assert !@topicdetail_page.topic_create_new_blog_menu_item.present?, "norm user can still write a blog after revertion"
  ensure
    @api_actions.remove_user_role_from_network_scope(admin: @config.users[:network_admin], user_id: @user6_id, role: :blogger) 
  end

  def test_00130_network_admin_add_removed_user_back_as_network_admin
    # promote & remove network administrator for User6
    @admin_perm_page.promote_user_role(@config.users[:regular_user6], :net_admin)
    @admin_perm_page.remove_user_role(@config.users[:regular_user6], :net_admin)

    # again promote removed user 6 as network administrator
    @admin_perm_page.promote_user_role(@config.users[:regular_user6], :net_admin)

    # verify the user can go to Admin page
    @about_page.about_login("regular_user6", "logged")
    @admin_page.navigate_in
    assert @admin_page.sidebar_present?
    @admin_page.assert_all_admin_tabs_with_network_admin_capability
  ensure
    # remove user 6 from network admins
    @api_actions.remove_user_role_from_network_scope(admin: @config.users[:network_admin], user_id: @user6_id)
  end

  def test_00140_network_admin_add_removed_user_back_as_network_moderator
    # promote user6 as network moderator
    @admin_perm_page.promote_user_role(@config.users[:regular_user6], :net_mod)

    # remove user6 from network moderator list
    @admin_perm_page.remove_user_role(@config.users[:regular_user6], :net_mod)

    # promote user6 as network moderator
    @admin_perm_page.promote_user_role(@config.users[:regular_user6], :net_mod)

    # login with user6
    @about_page.about_login("regular_user6", "logged")

    # go to Admin
    @admin_page.navigate_in

    # go to Admin->Moderator
    @admin_page.accept_policy_warning
    @admin_page.switch_to_sidebar_item(:moderation)
    @browser.wait_until { @admin_mod_page.pending_approval_tab.present? }

    # verify only Admin->Moderator is available in the sidebar
    assert !@admin_page.sidebar_item(:topics).present?
    assert !@admin_page.sidebar_item(:home).present?
    assert !@admin_page.sidebar_item(:about).present?
    assert !@admin_page.sidebar_item(:analytics).present?
    assert !@admin_page.sidebar_item(:advertising).present?
    assert !@admin_page.sidebar_item(:disclosures).present?
    assert !@admin_page.sidebar_item(:branding).present?
    assert !@admin_page.sidebar_item(:email_designer).present?
    assert !@admin_page.sidebar_item(:profile_field).present?
    assert !@admin_page.sidebar_item(:permissions).present?
    assert !@admin_page.sidebar_item(:reports).present?

    # verify Pending Approval tab available but no Settings tab
    assert @admin_mod_page.pending_approval_tab.present?
    assert @admin_mod_page.mod_flagged_tab_link.present?
    assert @admin_mod_page.mod_perm_removed_tab_link.present?
    assert !@admin_mod_page.mod_settings_tab_link.present?

  ensure
    @api_actions.remove_user_role_from_network_scope(admin: @config.users[:network_admin], user_id: @user6_id, role: :moderator)
  end

  def test_00150_topic_admins_should_have_admin_options_for_related_topic_only
    # User6 (designated topic X admin) login
    @admin_perm_page.promote_user_role(@config.users[:regular_user6], :topic_admin, @topic_for_permission_test)
    @about_page.about_login("regular_user6", "logged")

    # can see admin option
    assert @admin_page.can_see_admin_dropdown_option?

    @admin_page.navigate_in
    assert @admin_page.sidebar_present?

    # only Topics sidebar, it including the priviledged topic list without New Topic btn
    @admin_page.switch_to_sidebar_item(:topics)
    assert @admin_page.sidebar_item(:topics).present?
    assert !@admin_page.sidebar_item(:events).present?
    assert !@admin_page.sidebar_item(:tags).present?
    assert !@admin_page.sidebar_item(:profile_field).present?
    @admin_topics_page.navigate_in
    assert !@admin_topics_page.topic_new.present?

    # only Post Moderation sidebar without Settings tab
    @admin_page.switch_to_sidebar_item(:moderation)
    assert @admin_page.sidebar_item(:moderation).present?
    assert !@admin_page.sidebar_item(:profanity_blocker).present?
    @browser.wait_until { @admin_mod_page.pending_approval_tab.present? } 
    assert @admin_mod_page.pending_approval_tab.present?
    assert @admin_mod_page.mod_flagged_tab_link.present?
    assert @admin_mod_page.mod_perm_removed_tab_link.present?
    assert !@admin_mod_page.mod_settings_tab_link.present?

    # only Permission sidebar with Topic tab (but no Community tab)
    @admin_page.switch_to_sidebar_item(:permissions)
    assert @admin_page.sidebar_item(:permissions).present?
    assert !@admin_page.sidebar_item(:users).present?
    topicadmin_tab = @admin_perm_page.navigate_in_from_admin_page(Pages::Community::AdminPermissions::MemberListTab.new(@browser, :topic_admin))
    assert topicadmin_tab.present?
    assert !@admin_perm_page.permission_netadmin_tab.present?

    # can do all topic admin actions like feature/unfeature
    @topiclist_page.navigate_in
    assert @topiclist_page.topic_list.present?
    conv_root_post = @topiclist_page.get_the_first_conv_root_post_for_specific_topic_and_conv_type
    @browser.wait_until { conv_root_post.link(:text => /Feature|Stop Featuring/).present? }

  ensure
    @api_actions.remove_user_role_from_topic_scope(admin: @config.users[:network_admin], user_id: @user6_id, topic_id: @topic1_id)
  end

  def test_00160_topic_moderators_can_permanently_remove_flagged_post
    @admin_perm_page.promote_user_role(@config.users[:regular_user6], :topic_mod, @topic_for_permission_test)

    # prepare a new created post to flag
    @about_page.about_login("regular_user4", "logged")
    conv_title = "Q created by Watir for flag - #{get_timestamp}"
    conv_desc = "Watir test description - #{get_timestamp}"
    reply_text = "Answered by Watir - #{get_timestamp}"
    conv_url = @convdetail_page.create_new_conv_and_reply_for_specific_topic(:reply_text => reply_text, :conv_title => conv_title, :conv_desc => conv_desc)

    # step 1: promoted user 6 loggedin
    @about_page.about_login("regular_user6", "logged")

    # step 2: can see admin option
    @browser.wait_until { @admin_page.can_see_admin_dropdown_option? }
    @admin_page.navigate_in
    assert @admin_page.sidebar_present?

    # step 3: assert Moderation without Setting tab
    @admin_page.switch_to_sidebar_item(:moderation)
    assert @admin_page.sidebar_item(:moderation).present?
    assert !@admin_page.sidebar_item(:profanity_blocker).present?
    @browser.wait_until { @admin_mod_page.pending_approval_tab.present? }
    assert @admin_mod_page.pending_approval_tab.present?
    assert @admin_mod_page.mod_flagged_tab_link.present?
    assert @admin_mod_page.mod_perm_removed_tab_link.present?
    assert !@admin_mod_page.mod_settings_tab_link.present?

    # step 4-5: find and flag the post that will be flagged
    @convdetail_page.user_check_post_by_url(conv_url)
    flag_reason_text = "Set by Watir - #{get_timestamp}"
    @convdetail_page.flag_reply(:reason => flag_reason_text, :post_name => reply_text)

    # step 6: verify the flagged post in Moderation -> flagged tab
    @admin_page.navigate_in
    assert @admin_page.sidebar_present?
    @admin_page.switch_to_sidebar_item(:moderation)
    assert @admin_page.sidebar_item(:moderation).present?
    @browser.wait_until { @admin_mod_page.pending_approval_tab.present? }
    refute_nil @admin_mod_page.post_exist_in_moderation_subtab?(post_title: reply_text)

    # step 7: permanently remove the flagged reply
    @convdetail_page.user_check_post_by_url(conv_url)
    @convdetail_page.permanently_remove_flagged_reply(post_name: reply_text)

    # step 8: # verify the permanently removed post in Moderation -> Permanently Remove tab
    @admin_page.navigate_in
    assert @admin_page.sidebar_present?
    @admin_page.switch_to_sidebar_item(:moderation)
    assert @admin_page.sidebar_item(:moderation).present?
    @browser.wait_until { @admin_mod_page.pending_approval_tab.present? }
    refute_nil @admin_mod_page.post_exist_in_moderation_subtab?(post_title: reply_text, tab: :perm_removed)

  ensure
    @api_actions.remove_user_role_from_topic_scope(admin: @config.users[:network_admin], user_id: @user6_id, topic_id: @topic1_id, role: :moderator)
  end

  def test_00161_topic_moderators_can_reinstate_flagged_post
    @admin_perm_page.promote_user_role(@config.users[:regular_user6], :topic_mod, @topic_for_permission_test)

    # prepare a new created post to flag
    @about_page.about_login("regular_user4", "logged")
    conv_title = "Q created by Watir for flag - #{get_timestamp}"
    conv_desc = "Watir test description - #{get_timestamp}"
    reply_text = "Answered by Watir - #{get_timestamp}"
    conv_url = @convdetail_page.create_new_conv_and_reply_for_specific_topic(:reply_text => reply_text, :conv_title => conv_title, :conv_desc => conv_desc)

    # step 1: promoted user 6 loggedin
    @about_page.about_login("regular_user6", "logged")

    # step 2: can see admin option
    @browser.wait_until { @admin_page.can_see_admin_dropdown_option? }
    @admin_page.navigate_in
    assert @admin_page.sidebar_present?

    # step 3: assert Moderation without Setting tab
    @admin_page.switch_to_sidebar_item(:moderation)
    assert @admin_page.sidebar_item(:moderation).present?
    assert !@admin_page.sidebar_item(:profanity_blocker).present?
    @browser.wait_until { @admin_mod_page.pending_approval_tab.present? }
    assert @admin_mod_page.pending_approval_tab.present?
    assert @admin_mod_page.mod_flagged_tab_link.present?
    assert @admin_mod_page.mod_perm_removed_tab_link.present?
    assert !@admin_mod_page.mod_settings_tab_link.present?

    # step 4-5: find and flag the post that will be flagged
    @convdetail_page.user_check_post_by_url(conv_url)
    flag_reason_text = "Set by Watir - #{get_timestamp}"
    @convdetail_page.flag_reply(:reason => flag_reason_text, :post_name => reply_text)

    # step 6: verify the flagged post in Moderation -> flagged tab
    @admin_page.navigate_in
    assert @admin_page.sidebar_present?
    @admin_page.switch_to_sidebar_item(:moderation)
    assert @admin_page.sidebar_item(:moderation).present?
    @browser.wait_until { @admin_mod_page.pending_approval_tab.present? }
    # skip "Blocked by EN-4356"
    refute_nil @admin_mod_page.post_exist_in_moderation_subtab?(post_title: reply_text)

    # step 7: reinstate the flagged post
    @convdetail_page.user_check_post_by_url(conv_url)
    @convdetail_page.reinstate_flagged_reply(post_name: reply_text)

  ensure
    @api_actions.remove_user_role_from_topic_scope(admin: @config.users[:network_admin], user_id: @user6_id, topic_id: @topic1_id, role: :moderator)
  end

  def test_00170_network_admin_can_remove_designated_topic_admin
    # promote user 4 as topic admin that related to "A Watir Topic"
    @admin_perm_page.promote_user_role(@config.users[:regular_user6], :topic_admin, @topic_for_permission_test)

    # remove user 4 from topic admin list
    @admin_perm_page.remove_user_role(@config.users[:regular_user6], :topic_admin, @topic_for_permission_test)

    @about_page.about_login("regular_user6", "logged")

    # can not see admin option
    @browser.wait_until { !@admin_page.can_see_admin_dropdown_option? }

    # can not Feature or Stop Featuring this conv
    conv_root_post = @topiclist_page.get_the_first_conv_root_post_for_specific_topic_and_conv_type
    @browser.wait_until { !conv_root_post.link(:text => /Feature|Stop Featuring/).present? }
  end

  def test_00180_network_admin_can_remove_designated_topic_moderator
    # Step 1: promote USER6 as Topic Moderator that related with topic X
    @admin_perm_page.promote_user_role(@config.users[:regular_user6], :topic_mod, @topic_for_permission_test)

    # Step 2.1: Prepare a new created posts to flag (belongs to topic X)
    @about_page.about_login("regular_user4", "logged")
    comment_text = "I am will flagged by User4 with Topic Moderator role - #{get_timestamp}"
    conv_url = @convdetail_page.create_new_reply_for_specific_topic_and_conv_type(comment_text: comment_text)

    # Step 2.2: USER6 (Topic Moderator) flags R1 as inappropriate
    @about_page.about_login("regular_user6", "logged")
    @browser.goto conv_url
    @browser.wait_until { !@convdetail_page.spinner.present? }
    @browser.wait_until { !@convdetail_page.replies_panel.reply_with_content(1, comment_text).nil? }

    @convdetail_page.replies_panel.reply_with_content(1, comment_text).actions_arrow.when_present.click
    @browser.wait_until { @convdetail_page.replies_panel.reply_with_content(1, comment_text).action_menu_item_flag.present? }
    @convdetail_page.replies_panel.reply_with_content(1, comment_text).action_menu_item_flag.click

    # Step 2.3: Remove USER6's Topic Moderator role
    @admin_perm_page.remove_user_role(@config.users[:regular_user6], :topic_mod, @topic_for_permission_test)

    # Step 3: Verify USER6's behavior as Normal User
    @about_page.about_login("regular_user6", "logged")

    # Step 3.1: Cannot see admin option if USER4 was moderator of topic X only;
    # Notice --- can see admin option if USER4 is still mod for other topic/s
    @browser.wait_until { !@admin_page.can_see_admin_dropdown_option? }

    # Step 3.2: Should not see Reinstate/Permanently Remove Post option for flagged posts in topic X
    @browser.goto conv_url
    @browser.wait_until { !@convdetail_page.spinner.present? }
    @browser.wait_until { !@convdetail_page.replies_panel.reply_with_content(1, comment_text).nil? }

    @convdetail_page.replies_panel.reply_with_content(1, comment_text).actions_arrow.when_present.click
    @browser.wait_until { @convdetail_page.replies_panel.reply_with_content(1, comment_text).actions_dropdown_menu.present? }
    @browser.wait_until { !@convdetail_page.replies_panel.reply_with_content(1, comment_text).action_menu_item_reinstate.present? }
    @browser.wait_until { !@convdetail_page.replies_panel.reply_with_content(1, comment_text).action_menu_item_permanently_remove.present? }
  end

  p2
  def test_00190_promote_a_user_as_topic_admin
    # promote user 4 as topic admin
    @admin_perm_page.promote_user_role(@config.users[:regular_user6], :topic_admin, @topic_for_permission_test)

    # login with user 4
    @about_page.about_login("regular_user6", "logged")

    # go to Admin->Permissions->Topic->Administrators
    @admin_page.navigate_in
    topicadmin_tab = @admin_perm_page.navigate_in_from_admin_page(Pages::Community::AdminPermissions::MemberListTab.new(@browser, :topic_admin))

    assert topicadmin_tab.present?
    assert !@admin_perm_page.permission_netadmin_tab.present?
    assert !@admin_page.sidebar_item(:home).exists?
    assert !@admin_page.sidebar_item(:about).exists?
    assert !@admin_page.sidebar_item(:analytics).exists?
    assert !@admin_page.sidebar_item(:advertising).exists?
    assert !@admin_page.sidebar_item(:disclosures).exists?
    assert !@admin_page.sidebar_item(:branding).exists?
    assert !@admin_page.sidebar_item(:email_designer).exists?
    assert !@admin_page.sidebar_item(:profile_field).exists?
    assert !@admin_page.sidebar_item(:reports).exists?
    assert @admin_page.sidebar_item(:topics).exists?
    assert @admin_page.sidebar_item(:moderation).exists?

  ensure
    # remove the user 4 from Topic Administrators
    @api_actions.remove_user_role_from_topic_scope(admin: @config.users[:network_admin], user_id: @user6_id, topic_id: @topic1_id)
  end

  def test_00200_promote_a_user_as_topic_mod
    # promote user 4 to Topic Moderator
    @admin_perm_page.promote_user_role(@config.users[:regular_user6], :topic_mod, @topic_for_permission_test)

    # login with user 4
    @about_page.about_login("regular_user6", "logged")

    # go to Admin and verify Pending Approval tab available but no Settings tab
    @admin_page.navigate_in
    @admin_page.switch_to_sidebar_item(:moderation)
    @browser.wait_until { @admin_mod_page.pending_approval_tab.present? }
    assert @admin_mod_page.pending_approval_tab.present?
    assert !@admin_mod_page.mod_settings_tab_link.present?

    comment_text = "Commented by Watir4 for moderation for test 200 - #{get_timestamp}"
    conv_url = @convdetail_page.create_new_reply_for_specific_topic_and_conv_type(comment_text: comment_text)

    # login with admin user
    @about_page.about_login("network_admin", "logged")

    # go to the question detail page
    @browser.goto conv_url
    @browser.wait_until { !@convdetail_page.spinner.present? }
    @browser.wait_until { !@convdetail_page.replies_panel.reply_with_content(1, comment_text).nil? }

    # verify Flag as inappropriate memu item is available
    @convdetail_page.replies_panel.reply_with_content(1, comment_text).actions_arrow.when_present.click
    @browser.wait_until { @convdetail_page.replies_panel.reply_with_content(1, comment_text).action_menu_item_flag.present? }
    assert @convdetail_page.replies_panel.reply_with_content(1, comment_text).action_menu_item_flag.present?

  ensure
    @api_actions.remove_user_role_from_topic_scope(admin: @config.users[:network_admin], user_id: @user6_id, topic_id: @topic1_id, role: :moderator)
  end

  def test_00210_network_admin_can_designate_himself_as_topic_admin
    @admin_perm_page.promote_user_role(@config.users[:regular_user6], :net_admin)

    @admin_perm_page.promote_user_role(@config.users[:regular_user6], :topic_admin, @topic_for_permission_test, "regular_user6")

    @about_page.about_login("regular_user6", "logged")
    @topiclist_page.navigate_in
    conv_root_post = @topiclist_page.get_the_first_conv_root_post_for_specific_topic_and_conv_type
    @browser.wait_until { conv_root_post.link(:text => /Feature|Stop Featuring/).present? }
  ensure
    @api_actions.remove_user_role_from_topic_scope(admin: @config.users[:network_admin], user_id: @user6_id, topic_id: @topic1_id)
    @api_actions.remove_user_role_from_network_scope(admin: @config.users[:network_admin], user_id: @user6_id)
  end

  p1
  user :network_admin
  def test_00220_moderator_to_different_topics_vs_moderator_to_single_topic_permission
    #prepare works
    @user4_id = @profile_page.get_user_uuid_by_name(:regular_user4)
    @api_actions.remove_user_role_from_topic_scope(admin: @config.users[:network_admin], user_id: @user4_id, topic_id: @topic1_id)
    @api_actions.remove_user_role_from_topic_scope(admin: @config.users[:network_admin], user_id: @user4_id, topic_id: @topic1_id, role: :moderator)
    @api_actions.remove_user_role_from_topic_scope(admin: @config.users[:network_admin], user_id: @user4_id, topic_id: @topic2_id)
    @api_actions.remove_user_role_from_topic_scope(admin: @config.users[:network_admin], user_id: @user4_id, topic_id: @topic2_id, role: :moderator)

    # prepare two new created post to flag
    # @topic_for_permission_test denotes Topic X; @topic2_for_permission_test denotes Topic Y
    @about_page.about_login("regular_user2", "logged")
    conv_title1 = "Question created for topic moderator test - #{get_timestamp} - 1"
    conv_desc1 = "Description - #{get_timestamp} - 1"
    reply_text1 = "Create a reply for topic moderator test - #{get_timestamp} - 1"
    conv_url1 = @convdetail_page.create_new_conv_and_reply_for_specific_topic(reply_text: reply_text1, conv_title: conv_title1, conv_desc: conv_desc1)

    conv_title2 = "Question created for topic moderator test - #{get_timestamp} - 2"
    conv_desc2 = "Description - #{get_timestamp} - 2"
    reply_text2 = "Create a reply for topic moderator test - #{get_timestamp} - 2"
    conv_url2 = @convdetail_page.create_new_conv_and_reply_for_specific_topic(reply_text: reply_text2, conv_title: conv_title2, conv_desc: conv_desc2, conv_type: :question, topic_title: @topic2_for_permission_test)
    @login_page.logout!

    # step 1: promote user6 as topic moderator
    # @admin_perm_page.promote_user_role(@config.users[:regular_user6], :topic_mod, [@topic_for_permission_test, @topic2_for_permission_test])
    @admin_perm_page.promote_user_role(@config.users[:regular_user6], :topic_mod, @topic_for_permission_test)
    @admin_perm_page.promote_user_role(@config.users[:regular_user6], :topic_mod, @topic2_for_permission_test)

    @about_page.about_login("regular_user6", "logged")

    # step 2: user6 find and flag the post that will be flagged, and verify it in Moderation->Flagged tab
    @convdetail_page.user_check_post_by_url(conv_url1)
    flag_reason_text1 = "Not good - #{get_timestamp} - 1"
    @convdetail_page.flag_reply(:reason => flag_reason_text1, :post_name => reply_text1)

    @admin_page.navigate_in
    assert @admin_page.sidebar_present?
    @admin_page.switch_to_sidebar_item(:moderation)
    assert @admin_page.sidebar_item(:moderation).present?
    @browser.wait_until { @admin_mod_page.pending_approval_tab.present? }
    skip "Blocked by EN-4356"
    refute_nil @admin_mod_page.post_exist_in_moderation_subtab?(post_title: reply_text1)

    @convdetail_page.user_check_post_by_url(conv_url2)
    flag_reason_text2 = "Not good - #{get_timestamp} - 2"
    @convdetail_page.flag_reply(:reason => flag_reason_text2, :post_name => reply_text2)

    @admin_page.navigate_in
    assert @admin_page.sidebar_present?
    @admin_page.switch_to_sidebar_item(:moderation)
    assert @admin_page.sidebar_item(:moderation).present?
    @browser.wait_until { @admin_mod_page.pending_approval_tab.present? }
    refute_nil @admin_mod_page.post_exist_in_moderation_subtab?(post_title: reply_text2)

    # step 3: user 6 permanently remove the flagged reply2 that related with topic Y
    @convdetail_page.user_check_post_by_url(conv_url2)
    @convdetail_page.permanently_remove_flagged_reply(post_name: reply_text2)

    @admin_page.navigate_in
    assert @admin_page.sidebar_present?
    @admin_page.switch_to_sidebar_item(:moderation)
    assert @admin_page.sidebar_item(:moderation).present?
    @browser.wait_until { @admin_mod_page.pending_approval_tab.present? }
    refute_nil @admin_mod_page.post_exist_in_moderation_subtab?(post_title: reply_text2, tab: :perm_removed)

    # step 4: remove user6's role
    @api_actions.remove_user_role_from_topic_scope(admin: @config.users[:network_admin], user_id: @user6_id, topic_id: @topic1_id, role: :moderator)
    @api_actions.remove_user_role_from_topic_scope(admin: @config.users[:network_admin], user_id: @user6_id, topic_id: @topic2_id, role: :moderator)

    # step 5: promote user4 as topic moderator
    @admin_perm_page.promote_user_role(@config.users[:regular_user4], :topic_mod, @topic_for_permission_test)

    # step 6.1: user4 only can see the flagged reply1 in Moderation->Flagged tab, but no reply2
    @about_page.about_login("regular_user4", "logged")
    @admin_page.navigate_in
    assert @admin_page.sidebar_present?
    @admin_page.switch_to_sidebar_item(:moderation)
    assert @admin_page.sidebar_item(:moderation).present?
    @browser.wait_until { @admin_mod_page.pending_approval_tab.present? }
    refute_nil @admin_mod_page.post_exist_in_moderation_subtab?(post_title: reply_text1)
    assert_nil @admin_mod_page.post_exist_in_moderation_subtab?(post_title: reply_text2)

    # step 6.2: user4 can not see the permanently removed reply2 that related with topic Y
    assert_nil @admin_mod_page.post_exist_in_moderation_subtab?(post_title: reply_text2, tab: :perm_removed)

    # step 7: remove user4's role
    @admin_perm_page.remove_user_role(@config.users[:regular_user4], :topic_mod, @topic_for_permission_test)
  ensure
    @api_actions.remove_user_role_from_topic_scope(admin: @config.users[:network_admin], user_id: @user6_id, topic_id: @topic1_id, role: :moderator)
    @api_actions.remove_user_role_from_topic_scope(admin: @config.users[:network_admin], user_id: @user6_id, topic_id: @topic2_id, role: :moderator)
    @api_actions.remove_user_role_from_topic_scope(admin: @config.users[:network_admin], user_id: @user4_id, topic_id: @topic1_id, role: :moderator)
  end
end
