require 'watir_test'
require 'pages/community/admin'
require 'pages/community/about'
require 'pages/community/layout'
require 'pages/community/admin_contributor_rating'
require 'pages/community/admin_moderation'
require 'actions/hybris/api'

class AdminModerationTest < WatirTest

  def setup
    super
   # @about_page = Pages::Community::About.new(@config)
   # @admin_page = Pages::Community::Admin.new(@config)
   # @layout_page = Pages::Community::Layout.new(@config)
    @admin_mod_page = Pages::Community::AdminModeration.new(@config)
    # assigning @current_page helps error reporting
    @community_page = Pages::Community.new(@config)
    @convdetail_page = Pages::Community::ConversationDetail.new(@config)
    @login_page = Pages::Community::Login.new(@config)
    @topiclist_page = Pages::Community::TopicList.new(@config)
    @profile_page = Pages::Community::Profile.new(@config)
    @topicdetail_page = Pages::Community::TopicDetail.new(@config)
    @admin_contri_rating_page = Pages::Community::AdminContributorRating.new(@config)
    @api_actions = Actions::Api.new(@config)
    #  give good contextual data
    @current_page = @admin_mod_page
    puts "[[[ #{name} ::: #{user_for_test} ]]]" if @config.verbose?
    @browser = @config.browser
    @admin_mod_page.start!(user_for_test)
  end

  def teardown
    super
  end

  p0

  user :network_admin
  def test_00010_check_mod_option
    assert @admin_mod_page.mod_settings_tab_link.present?
    assert @admin_mod_page.mod_flagged_tab_link.present?
    assert @admin_mod_page.mod_perm_removed_tab_link.present?
  end

  def test_00020_check_mod_threshold_tab
    # switch to Settings tab
    @admin_mod_page.switch_to_tab(:settings) 

    assert @admin_mod_page.mod_settings_save_btn.present?
    assert @admin_mod_page.mod_settings_threshold_field.present?
  end

  def test_00030_set_mod_threshold
    # go to Settings tab, set threshold to 1 and select Moderation on flagged posts policy
    @admin_mod_page.set_moderation_threshold("1", :low)
  end

  def test_00040_flag_a_post
    @admin_mod_page.flag_a_post 
  end

  def test_00041_user_cannot_flag_reinstated_post
    @admin_mod_page.reinstate_a_post
  end

  def test_00050_check_flagged_post_tab
    # switch to Flagged tab
    @admin_mod_page.switch_to_tab(:flagged)

    assert @admin_mod_page.mod_flagged_tab_link.present?
    assert @admin_mod_page.mod_flagged_post.present?
  end

  def test_00060_check_permanently_removed_post_tab
    @admin_mod_page.check_permanently_removed_post_tab
  end

  def test_00070_check_profanity_blocker_tab
    @admin_mod_page.check_profanity_blocker_tab 
    if !@admin_mod_page.enable_profanity_button.present?
     assert @admin_mod_page.profanity_blocker_tab_page.present?
     assert @admin_mod_page.profanity_disable_button.present? 
     assert @admin_mod_page.profanity_import_button.present? 
     assert @admin_mod_page.profanity_download_button.present?
    else
     assert @admin_mod_page.enable_profanity_button.present? 
    end
  end

  def test_00080_check_moderation_approve_on_immediate_posts
    @admin_mod_page.set_moderation_threshold("1", :medium)
    @admin_mod_page.about_login("regular_user1", "logged")
    
    @topicdetail_page = @topiclist_page.go_to_topic("A Watir Topic")
    root_post = "Q created by Watir for moderation medium level - #{get_timestamp}"
    @topicdetail_page.create_conversation(type: :question, 
                                          title: root_post, 
                                          details: [{type: :text, content: "Watir test description"}])
    conv_url = @browser.url

    @community_page.about_login("regular_user2", "logged")
    @convdetail_page.user_check_post_by_url (conv_url)
    assert @convdetail_page.root_post_title.text == root_post, "normal user cannot see the post when moderation on immediate posts."

    @admin_mod_page.start!("network_admin")
    @admin_mod_page.admin_check_post_in_pending_approval
    assert (@admin_mod_page.mod_posts.text.include?root_post), "admin cannot approve when modration on immediate posts."
    @admin_mod_page.admin_approve_post_pending_approval(root_post)
    @admin_mod_page.set_moderation_threshold("1", :low)

  end

  def test_00081_check_moderation_reject_on_immediate_posts
    @admin_mod_page.set_moderation_threshold("1", :medium)
    @admin_mod_page.about_login("regular_user1", "logged")
    
    @topicdetail_page = @topiclist_page.go_to_topic("A Watir Topic")
    root_post = "Q created by Watir for moderation medium level - #{get_timestamp}"
    @topicdetail_page.create_conversation(type: :question, 
                                          title: root_post, 
                                          details: [{type: :text, content: "Watir test description"}])
    conv_url = @browser.url

    @admin_mod_page.start!("network_admin")
    @admin_mod_page.admin_reject_post_pending_approval(root_post)

    @community_page.about_login("regular_user2", "logged")
    @convdetail_page.user_check_post_by_url(conv_url)

    mod_msg = "This post has been flagged as inappropriate by other users and permanently removed."
    assert @convdetail_page.conv_moderation_alert.text == mod_msg, "normal user can see the post after rejection."

    @admin_mod_page.start!("network_admin")
    @admin_mod_page.set_moderation_threshold("1", :low)

  end

  def test_00090_check_moderation_approve_on_posts_pending_approval
    @admin_mod_page.set_moderation_threshold("1", :high)
    @community_page.about_login("regular_user1", "logged")

    @topicdetail_page = @topiclist_page.go_to_topic("A Watir Topic")
    root_post = "Q created by Watir for moderation high level - #{get_timestamp}"
    @topicdetail_page.create_conversation(type: :question, 
                                          title: root_post, 
                                          details: [{type: :text, content: "Watir test description"}])
    conv_url = @browser.url

    @community_page.about_login("regular_user2", "logged")
    @convdetail_page.user_check_post_by_url (conv_url)
    mod_msg = "This post is pending approval. You will be able to see it once it is approved."
    assert @convdetail_page.conv_moderation_alert.text == mod_msg, "normal user can see the post when moderation on posts pending approval."

    @admin_mod_page.start!("network_admin")
    @admin_mod_page.admin_check_post_in_pending_approval
    assert (@admin_mod_page.mod_posts.text.include?root_post) , "admin cannot approve when modration on posts pending approval."
    @admin_mod_page.admin_approve_post_pending_approval(root_post)

    @community_page.about_login("regular_user2", "logged")
    @convdetail_page.user_check_post_by_url (conv_url)
    @browser.wait_until($t) { @convdetail_page.root_post_title.text == root_post }
    assert @convdetail_page.root_post_title.text == root_post, "normal user cannot see the post after approval."

    @admin_mod_page.start!("network_admin")
    @admin_mod_page.set_moderation_threshold("1", :low)


  end

  p2
  def test_00100_check_contributor_points_in_low_moderation
    # pre-requirements:
    # 1. set low moderation level with 2 threshold
    @admin_mod_page.set_moderation_threshold("2", :low)
    @admin_contri_rating_page.navigate_in_from_admin_page

    # 2. turn on the contributor switch if not
    @admin_contri_rating_page.switch_contri_rating(:on) 

    # 3. make sure "Ratings in profile" ticked on
    unless @admin_contri_rating_page.setting_option_checkbox_input(:display, "Ratings in profile").checked?
      @admin_contri_rating_page.switch_setting_option(:display, "Ratings in profile", :on)
      @admin_contri_rating_page.save
    end

    # 4. get event points settings required
    @admin_contri_rating_page.switch_to_tab(:points_and_ranking)

    points_set_for_post_q = @admin_contri_rating_page.event_points("Post a question")
    points_set_for_read_q = @admin_contri_rating_page.event_points("Read a question")

    # Step1: login with regular_user5
    @login_page.login!(@c.users[:regular_user5])
    
    # check current profile points
    @profile_page.goto_profile
    points_before = @profile_page.level_points

    # Step2: create a question
    @topicdetail_page = @topiclist_page.go_to_topic("A Watir Topic")
    title = "Test q created by Watir - #{get_timestamp}"
    @topicdetail_page.create_conversation(type: :question, 
                                          title: title, 
                                          details: [{type: :text, content: "Watir test description"}])

    question_url = @browser.url

    # go to profile page to verify the level points updated
    @profile_page.goto_profile
    expected_points_after = points_before + points_set_for_post_q + points_set_for_read_q
    points_after = @profile_page.wait_until_contri_rating_points_updated(expected_points_after) 
    assert expected_points_after == points_after, "Points incorrect after Post a question"
    
    # Step3: regular_user2 Flag the question
    @login_page.login!(@c.users[:regular_user2])

    @browser.goto question_url
    @browser.wait_until { @convdetail_page.conv_content.present? }

    @convdetail_page.flag_root_post

    # Step4: regular_user5 check current profile points
    @login_page.login!(@c.users[:regular_user5])
    @profile_page.goto_profile
    assert @profile_page.level_points == points_after, "Points changed after first flag"

    # Step5: regular_user3 Flag the question
    @login_page.login!(@c.users[:regular_user3])
    @browser.goto question_url
    @browser.wait_until { @convdetail_page.conv_content.present? }

    @convdetail_page.flag_root_post

    # Step6: regular_user5 check current profile points
    @login_page.login!(@c.users[:regular_user5])
    @profile_page.goto_profile
    assert @profile_page.level_points == (points_after - points_set_for_post_q), "Points incorrect after second flag"

    # Step7: admin approve the question
    @login_page.login!(@c.users[:network_admin])
    @admin_mod_page.navigate_in
    @admin_mod_page.approve_post_in_flagged_tab(title)

    # Step8: regular_user5 check current profile points
    @login_page.login!(@c.users[:regular_user5])
    @profile_page.goto_profile
    assert @profile_page.level_points == points_after, "Points incorrect after admin approve post"
  end
  
  def test_00101_check_contributor_points_in_medium_moderation
    # pre-requirements:
    # 1. set middle moderation level with 1 threshold
    @admin_mod_page.set_moderation_threshold("1", :medium)
    @admin_contri_rating_page.navigate_in_from_admin_page

    # 2. turn on the contributor switch if not
    @admin_contri_rating_page.switch_contri_rating(:on) 

    # 3. make sure "Ratings in profile" ticked on
    unless @admin_contri_rating_page.setting_option_checkbox_input(:display, "Ratings in profile").checked?
      @admin_contri_rating_page.switch_setting_option(:display, "Ratings in profile", :on)
      @admin_contri_rating_page.save
    end

    # 4. get event points settings required
    @admin_contri_rating_page.switch_to_tab(:points_and_ranking)

    points_set_for_post_r = @admin_contri_rating_page.event_points("Post a review")
    points_set_for_read_r = @admin_contri_rating_page.event_points("Read a review")

    # Step1: login with regular_user5
    @login_page.login!(@c.users[:regular_user5])
    
    # check current profile points
    @profile_page.goto_profile
    points_before = @profile_page.level_points

    # Step2: create a review
    @topicdetail_page = @topiclist_page.go_to_topic("A Watir Topic")
    title = "Test r created by Watir - #{get_timestamp}"
    @topicdetail_page.create_review(title: title, 
                                    details: [{type: :text, content: "Watir test description"}])
    review_url = @browser.url
    review_uuid = review_url.match(/\/review\/(\w+)\//)[1]

    # go to profile page to verify the level points updated
    @profile_page.goto_profile
    expected_points_after = points_before + points_set_for_post_r + points_set_for_read_r
    points_after = @profile_page.wait_until_contri_rating_points_updated(expected_points_after) 
    assert expected_points_after == points_after, "Points incorrect after Post a review"

    # Step5: admin approve the question
    @login_page.login!(@c.users[:network_admin])
    @admin_mod_page.navigate_in
    @admin_mod_page.admin_approve_post_pending_approval(title)

    # Step6: regular_user5 check current profile points
    @login_page.login!(@c.users[:regular_user5])
    @profile_page.goto_profile
    assert @profile_page.level_points == points_after, "Points incorrect after admin approve post"
  ensure
    # delete the review if no chance before because of error
    @api_actions.delete_review(@config.users[:network_admin], review_uuid) unless review_uuid.nil? 
  end

  def test_00102_check_contributor_points_in_high_moderation
    # pre-requirements:
    # 1. set high moderation level with 1 threshold
    @admin_mod_page.set_moderation_threshold("1", :high)
    @admin_contri_rating_page.navigate_in_from_admin_page

    # 2. turn on the contributor switch if not
    @admin_contri_rating_page.switch_contri_rating(:on) 

    # 3. make sure "Ratings in profile" ticked on
    unless @admin_contri_rating_page.setting_option_checkbox_input(:display, "Ratings in profile").checked?
      @admin_contri_rating_page.switch_setting_option(:display, "Ratings in profile", :on)
      @admin_contri_rating_page.save
    end

    # 4. get event points settings required
    @admin_contri_rating_page.switch_to_tab(:points_and_ranking)
    points_set_for_answer_q = @admin_contri_rating_page.event_points("Answer a question")
    points_set_for_read_q = @admin_contri_rating_page.event_points("Read a question")

    # Step1: login with regular_user5
    @login_page.login!(@c.users[:regular_user5])
    
    # check current profile points
    @profile_page.goto_profile
    points_before = @profile_page.level_points

    # Step2: go to the specific topic and answer to the first question
    @topicdetail_page = @topiclist_page.go_to_topic("A Watir Topic")
    @convdetail_page.conversation_detail("question")
    reply_desc = "Answer posted by Watir - #{get_timestamp}"
    @convdetail_page.create_reply(des: reply_desc)

    # go to profile page to verify the level points won't be changed
    @profile_page.goto_profile
    expected_points_after = points_before + points_set_for_read_q
    points_after = @profile_page.wait_until_contri_rating_points_updated(expected_points_after) 
    assert expected_points_after == points_after, "Points changed after Answer a question"
    
    # Step3: admin approve the post
    @login_page.login!(@c.users[:network_admin])
    @admin_mod_page.navigate_in
    @admin_mod_page.admin_approve_post_pending_approval(reply_desc)

    # Step4: regular_user5 check current profile points is increased by points_set_for_answer_q
    @login_page.login!(@c.users[:regular_user5])
    @profile_page.goto_profile
    assert @profile_page.level_points == points_after + points_set_for_answer_q, "Points incorrect after admin approve post"
  end

  def test_00103_check_contributor_points_reject_root_post
    # pre-requirements:
    # 1. set middle moderation level with 1 threshold
    @admin_mod_page.set_moderation_threshold("1", :medium)
    @admin_contri_rating_page.navigate_in_from_admin_page

    # 2. turn on the contributor switch if not
    @admin_contri_rating_page.switch_contri_rating(:on) 

    # 3. make sure "Ratings in profile" ticked on
    unless @admin_contri_rating_page.setting_option_checkbox_input(:display, "Ratings in profile").checked?
      @admin_contri_rating_page.switch_setting_option(:display, "Ratings in profile", :on)
      @admin_contri_rating_page.save
    end

    # 4. get event points settings required
    @admin_contri_rating_page.switch_to_tab(:points_and_ranking)

    points_set_for_post_q = @admin_contri_rating_page.event_points("Post a question")
    points_set_for_read_q = @admin_contri_rating_page.event_points("Read a question")
    points_set_for_answer_q = @admin_contri_rating_page.event_points("Answer a question")

    # Step1: login with regular_user5
    @login_page.login!(@c.users[:regular_user5])
    
    # check current profile points
    @profile_page.goto_profile
    points_before = @profile_page.level_points

    # Step2: create a question
    @topicdetail_page = @topiclist_page.go_to_topic("A Watir Topic")
    title = "Test q created by Watir - #{get_timestamp}"
    @topicdetail_page.create_conversation(type: :question, 
                                          title: title, 
                                          details: [{type: :text, content: "Watir test description"}])

    question_url = @browser.url
    reply_desc = "Answer posted by Watir - #{get_timestamp}"
    @convdetail_page.create_reply(des: reply_desc)

    # verify the level points updated
    @profile_page.goto_profile
    expected_points_after = points_before + points_set_for_post_q + points_set_for_read_q + points_set_for_answer_q
    points_after = @profile_page.wait_until_contri_rating_points_updated(expected_points_after) 
    assert expected_points_after == points_after, "Points incorrect after Post a question"

    # Step3: admin reject the post
    @login_page.login!(@c.users[:network_admin])
    @admin_mod_page.navigate_in
    @admin_mod_page.admin_approve_post_pending_approval(title) # approve the reply
    @admin_mod_page.admin_reject_post_pending_approval(title) # reject the question

    # Step4: regular_user5 check current profile points is increased by points_set_for_answer_q
    @login_page.login!(@c.users[:regular_user5])
    @profile_page.goto_profile
    assert @profile_page.level_points == points_after - points_set_for_post_q, "Points incorrect after admin reject post"
  end  


  p01
  def test_00200_create_reply_at_low_level_setting
    @admin_mod_page.set_moderation_threshold("2", :low)
    # user1 create a reply in low level
    reply_obj = @admin_mod_page.create_reply_in_post :low

    # user2 review the reply created by user1
    @admin_mod_page.about_login("regular_user2", "logged")
    @browser.goto reply_obj[:url]
    @admin_mod_page.assert_create_reply :setting_type => :low

    # admin review the reply created by user1
    @admin_mod_page.about_login("network_admin", "logged")
    @browser.goto reply_obj[:url]
    @admin_mod_page.assert_create_reply :is_admin => true

    assert ( @admin_mod_page.find_reply_by_title :title => reply_obj[:title], :answer_text => reply_obj[:answer_text],:descrip => reply_obj[:descrip]) == false
  end

  def test_00201_create_reply_at_mid_level_setting
    @admin_mod_page.set_moderation_threshold("2", :medium)
    # user1 create a reply in middle level
    reply_obj = @admin_mod_page.create_reply_in_post :medium

    # user2 review the reply created by user1
    @admin_mod_page.about_login("regular_user2", "logged")
    @browser.goto reply_obj[:url]
    @admin_mod_page.assert_create_reply :setting_type => :medium

    # admin review the reply created by user1
    @admin_mod_page.about_login("network_admin", "logged")
    @browser.goto reply_obj[:url]
    @admin_mod_page.assert_create_reply :is_admin => true, :setting_type => :medium

    assert ( @admin_mod_page.find_reply_by_title_and_tabtype reply_obj[:title], reply_obj[:answer_text], reply_obj[:descrip],:pending_approval) == true
  end

  def test_00202_create_reply_at_high_level_setting
    @admin_mod_page.set_moderation_threshold("2", :high)
    # user1 create a reply in high level
    reply_obj = @admin_mod_page.create_reply_in_post :high

    # user2 review the reply created by user1
    @admin_mod_page.about_login("regular_user2", "logged")
    @browser.goto reply_obj[:url]
    @admin_mod_page.assert_create_reply :setting_type => :high

    # admin review the reply created by user1
    @admin_mod_page.about_login("network_admin", "logged")
    @browser.goto reply_obj[:url]
    @admin_mod_page.assert_create_reply :is_admin => true, :setting_type => :high

    assert ( @admin_mod_page.find_reply_by_title_and_tabtype reply_obj[:title], reply_obj[:answer_text], reply_obj[:descrip], :pending_approval) == true
  end

  def test_00210_flag_reply_at_low_level_setting
    @admin_mod_page.set_moderation_threshold("2", :low)
    # user1 create reply to a post
    reply_obj = @admin_mod_page.create_reply_in_post :low

    # user2 flag the reply created by user1
    @admin_mod_page.about_login("regular_user2", "logged")
    @browser.goto reply_obj[:url]
    @admin_mod_page.flag_a_reply_in_post

    # no change for what user1 see
    @admin_mod_page.about_login("regular_user1", "logged")
    @browser.goto reply_obj[:url]
    @admin_mod_page.assert_create_reply :is_root_post_owner => true

    # no change for what user3 see
    @admin_mod_page.about_login("regular_user3", "logged")
    @browser.goto reply_obj[:url]
    @admin_mod_page.assert_create_reply

    # no change for what admin see
    @admin_mod_page.about_login("network_admin", "logged")
    @browser.goto reply_obj[:url]
    @admin_mod_page.assert_create_reply :is_admin => true

    assert ( @admin_mod_page.find_reply_by_title_and_tabtype reply_obj[:title], reply_obj[:answer_text], reply_obj[:descrip], :flagged) == false

    # user3 flag the reply to reach the thresholds
    @admin_mod_page.about_login("regular_user3", "logged")
    @browser.goto reply_obj[:url]
    @admin_mod_page.flag_a_reply_in_post :refresh_after_flag => true

    # user1 review the reply and can't see the reply content
    @admin_mod_page.about_login("regular_user1", "logged")
    @browser.goto reply_obj[:url]
    @admin_mod_page.root_post_owner_review_flagged_reply

    # admin review the flagged reply 
    @admin_mod_page.about_login("network_admin", "logged")
    @browser.goto reply_obj[:url]
    @admin_mod_page.admin_review_flagged_reply
    assert ( @admin_mod_page.find_reply_by_title_and_tabtype reply_obj[:title], reply_obj[:answer_text], reply_obj[:descrip], :flagged) == true
  end

  def test_00220_reinstate_reply_by_admin_in_low_level_setting
    @admin_mod_page.set_moderation_threshold("2", :low)
    # user1 create reply to a post
    reply_obj = @admin_mod_page.create_reply_in_post :low

    # user2 flag the reply created by user1
    @admin_mod_page.about_login("regular_user2", "logged")
    @browser.goto reply_obj[:url]
    @admin_mod_page.flag_a_reply_in_post

    # user3 flag the reply to reach the thresholds
    @admin_mod_page.about_login("regular_user3", "logged")
    @browser.goto reply_obj[:url]
    @admin_mod_page.flag_a_reply_in_post :refresh_after_flag => true

    # admin review the flagged reply 
    @admin_mod_page.about_login("network_admin", "logged")
    @browser.goto reply_obj[:url]
    @admin_mod_page.admin_review_flagged_reply
    assert ( @admin_mod_page.find_reply_by_title_and_tabtype reply_obj[:title], reply_obj[:answer_text], reply_obj[:descrip], :flagged) == true

    # admin reinstate the reply that is flagged twice
    @admin_mod_page.admin_reinstate_post_or_reply reply_obj[:title], reply_obj[:answer_text], reply_obj[:descrip], :flagged

    # admin can't find the reply in any tab of admin console page
    ( @admin_mod_page.find_reply_by_title :title => reply_obj[:title], :answer_text => reply_obj[:answer_text], :descrip => reply_obj[:descrip] ) == false

    # admin can't flag the reply again
    @browser.goto reply_obj[:url]
    @admin_mod_page.assert_create_reply :is_admin => true, :is_reinstate => true

    # ohter user sach user2 can't flag the reply after reinstate
    @admin_mod_page.about_login("regular_user2", "logged")
    @browser.goto reply_obj[:url]
    assert !@convdetail_page.reply_dropdown_toggle.present?

     # there is no action changed for user1
    @admin_mod_page.about_login("regular_user1", "logged")
    @browser.goto reply_obj[:url]
    @browser.refresh
    @admin_mod_page.assert_create_reply :is_root_post_owner => true, :is_reinstate => true

    # user1 edit the reply after reinstate
    @admin_mod_page.edit_reply_by_root_post_owner

    # user2 review the reply 
    @admin_mod_page.about_login("regular_user2", "logged")
    @browser.goto reply_obj[:url]
    @admin_mod_page.assert_create_reply

    # admin review the reply and flag the reply
    @admin_mod_page.about_login("network_admin", "logged")
    @admin_mod_page.navigate_in
    @admin_mod_page.set_moderation_threshold("2", :low)
    @browser.goto reply_obj[:url]
    @admin_mod_page.assert_create_reply :is_admin => true
    @admin_mod_page.flag_a_reply_in_post
    assert ( @admin_mod_page.find_reply_by_title_and_tabtype reply_obj[:title], reply_obj[:answer_text], reply_obj[:descrip], :flagged ) == true
  end

  def test_00221_reinstate_reply_after_flag_in_low_middle_setting
    @admin_mod_page.set_moderation_threshold("1", :medium)
    reply_obj = @admin_mod_page.create_reply_in_post :medium
    # admin approve the reply
    @admin_mod_page.about_login("network_admin", "logged")
    @admin_mod_page.admin_approve_reply_or_post reply_obj[:title], reply_obj[:answer_text], reply_obj[:descrip], :pending_approval
    # user2 flag the reply to reach the threashold
    @admin_mod_page.about_login("regular_user2", "logged")
    @browser.goto reply_obj[:url]
    @admin_mod_page.flag_a_reply_in_post :setting_type => :medium
    # admin search the flagged tab in admin page
    @admin_mod_page.about_login("network_admin", "logged")
    assert ( @admin_mod_page.admin_reinstate_post_or_reply reply_obj[:title], reply_obj[:answer_text], reply_obj[:descrip], :flagged ) == true
    @browser.goto reply_obj[:url]
    @admin_mod_page.assert_create_reply :is_admin => true, :setting_type => :low, :is_reinstate => true
    # user1 review the reinstate reply
    @admin_mod_page.about_login("regular_user1", "logged")
    @browser.goto reply_obj[:url]
    @admin_mod_page.assert_create_reply :is_root_post_owner => true, :setting_type => :low, :is_reinstate => true
    # user2 review the reinstate reply
    @admin_mod_page.about_login("regular_user2", "logged")
    @browser.goto reply_obj[:url]
    @admin_mod_page.assert_create_reply :setting_type => :low, :is_reinstate => true
  end

  def test_00222_reinstate_reply_after_flag_in_high_setting
    @admin_mod_page.set_moderation_threshold("1", :high)
    reply_obj = @admin_mod_page.create_reply_in_post :high
    # admin approve the reply
    @admin_mod_page.about_login("network_admin", "logged")
    @admin_mod_page.admin_approve_reply_or_post reply_obj[:title], reply_obj[:answer_text], reply_obj[:descrip], :pending_approval
    @admin_mod_page.admin_approve_reply_or_post reply_obj[:title], reply_obj[:answer_text], reply_obj[:descrip], :pending_approval
    # user2 flag the reply to reach the threashold
    @admin_mod_page.about_login("regular_user2", "logged")
    @browser.goto reply_obj[:url]
    @admin_mod_page.flag_a_reply_in_post :setting_type => :high
    # admin search the flagged tab in admin page
    @admin_mod_page.about_login("network_admin", "logged")
    assert ( @admin_mod_page.admin_reinstate_post_or_reply reply_obj[:title], reply_obj[:answer_text], reply_obj[:descrip], :flagged ) == true
    @browser.goto reply_obj[:url]
    @admin_mod_page.assert_create_reply :is_admin => true, :setting_type => :low, :is_reinstate => true
    # user1 review the reinstate reply
    @admin_mod_page.about_login("regular_user1", "logged")
    @browser.goto reply_obj[:url]
    @admin_mod_page.assert_create_reply :is_root_post_owner => true, :setting_type => :low, :is_reinstate => true
    # user2 review the reinstate reply
    @admin_mod_page.about_login("regular_user2", "logged")
    @browser.goto reply_obj[:url]
    @admin_mod_page.assert_create_reply :setting_type => :low, :is_reinstate => true
  end

  def test_00230_reject_reply_by_admin_in_low_level_setting
    @admin_mod_page.set_moderation_threshold("1", :low)
    reply_obj = @admin_mod_page.create_reply_in_post :low
    # user2 flag the reply
    @admin_mod_page.about_login("regular_user2", "logged")
    @browser.goto reply_obj[:url]
    @admin_mod_page.flag_a_reply_in_post 

    # admin reject the flagged reply 
    @admin_mod_page.about_login("network_admin", "logged")
    assert ( @admin_mod_page.admin_reject_post_or_reply reply_obj[:title], reply_obj[:answer_text], reply_obj[:descrip], :flagged ) == true
    assert ( @admin_mod_page.find_reply_by_title_and_tabtype reply_obj[:title], reply_obj[:answer_text], reply_obj[:descrip], :perm_removed ) == true
    # reply_obj = {:url => "https://ch-candidate-betaon.mo.sap.corp/question/sbRXnqIfdA9AqtlxVpGZEv/betaon/q-created-by-watir-for-flag-20171207080616utc" }
    @browser.goto reply_obj[:url]
    @admin_mod_page.review_rejected_reply :is_admin => true

    # user1 review the rejected reply
    @admin_mod_page.about_login("regular_user1", "logged")
    @browser.goto reply_obj[:url]
    @admin_mod_page.review_rejected_reply :is_root_post_owner => true

    # user2 review the rejected reply
    @admin_mod_page.about_login("regular_user2", "logged")
    @browser.goto reply_obj[:url]
    @admin_mod_page.review_rejected_reply
  end

  def test_00231_reject_reply_by_admin_in_middle_level_setting
    @admin_mod_page.set_moderation_threshold("2", :medium)
    reply_obj = @admin_mod_page.create_reply_in_post :medium
    # admin can see the reply in the pending approval tab
    @admin_mod_page.about_login("network_admin", "logged")
    assert ( @admin_mod_page.admin_reject_post_or_reply reply_obj[:title], reply_obj[:answer_text], reply_obj[:descrip], :pending_approval ) == true
    assert ( @admin_mod_page.find_reply_by_title_and_tabtype reply_obj[:title], reply_obj[:answer_text], reply_obj[:descrip], :perm_removed ) == true
    @browser.goto reply_obj[:url]
    @admin_mod_page.review_rejected_reply :is_admin => true
    # user1 review the rejected reply
    @admin_mod_page.about_login("regular_user1", "logged")
    @browser.goto reply_obj[:url]
    @admin_mod_page.review_rejected_reply :is_root_post_owner => true
    # user2 review the rejected reply
    @admin_mod_page.about_login("regular_user2", "logged")
    @browser.goto reply_obj[:url]
    @admin_mod_page.review_rejected_reply
  end

  def test_00232_reject_reply_after_flag_in_middle_level_setting
    @admin_mod_page.set_moderation_threshold("1", :medium)
    reply_obj = @admin_mod_page.create_reply_in_post :medium
    # admin can see the reply in the pending approval tab
    @admin_mod_page.about_login("network_admin", "logged")
    assert ( @admin_mod_page.admin_approve_reply_or_post reply_obj[:title], reply_obj[:answer_text], reply_obj[:descrip], :pending_approval ) == true

    # user2 flag the reply to reach the threshold
    @admin_mod_page.about_login("regular_user2", "logged")
    @browser.goto reply_obj[:url]
    @admin_mod_page.flag_a_reply_in_post :setting_type => :medium
    # admin reject the flagged reply
    @admin_mod_page.about_login("network_admin", "logged")
    assert ( @admin_mod_page.admin_reject_post_or_reply reply_obj[:title], reply_obj[:answer_text], reply_obj[:descrip], :flagged ) == true
    assert ( @admin_mod_page.find_reply_by_title_and_tabtype reply_obj[:title], reply_obj[:answer_text], reply_obj[:descrip], :perm_removed ) == true
    # user1 review the rejected reply
    @admin_mod_page.about_login("regular_user1", "logged")
    @browser.goto reply_obj[:url]
    @admin_mod_page.review_rejected_reply :is_root_post_owner => true
    # user2 review the rejected reply
    @admin_mod_page.about_login("regular_user2", "logged")
    @browser.goto reply_obj[:url]
    @admin_mod_page.review_rejected_reply
  end

  def test_00233_reject_reply_after_creation_in_high_level_setting
    @admin_mod_page.set_moderation_threshold("2", :high)
    reply_obj = @admin_mod_page.create_reply_in_post :high
    # admin can see the reply in the pending approval tab
    @admin_mod_page.about_login("network_admin", "logged")
    assert ( @admin_mod_page.admin_reject_post_or_reply  reply_obj[:title], reply_obj[:answer_text], reply_obj[:descrip], :pending_approval ) == true
    assert ( @admin_mod_page.admin_approve_reply_or_post reply_obj[:title], reply_obj[:answer_text], reply_obj[:descrip], :pending_approval ) == true
    @browser.goto reply_obj[:url]
    @admin_mod_page.review_rejected_reply :is_admin => true

    # user1 review the rejected reply
    @admin_mod_page.about_login("regular_user1", "logged")
    @browser.goto reply_obj[:url]
    @admin_mod_page.review_rejected_reply :is_root_post_owner => true
    # user2 review the rejected reply
    @admin_mod_page.about_login("regular_user2", "logged")
    @browser.goto reply_obj[:url]
    @admin_mod_page.review_rejected_reply :is_high_level => true
  end

  def test_00234_reject_reply_after_flag_in_high_level_setting
    @admin_mod_page.set_moderation_threshold("1", :high)
    reply_obj = @admin_mod_page.create_reply_in_post :high
    # admin can see the reply in the pending approval tab
    @admin_mod_page.about_login("network_admin", "logged")
    assert ( @admin_mod_page.admin_approve_reply_or_post reply_obj[:title], reply_obj[:answer_text], reply_obj[:descrip], :pending_approval ) == true
    assert ( @admin_mod_page.admin_approve_reply_or_post reply_obj[:title], reply_obj[:answer_text], reply_obj[:descrip], :pending_approval ) == true

    # user2 flag the reply to reach the threshold
    @admin_mod_page.about_login("regular_user2", "logged")
    @browser.goto reply_obj[:url]
    @admin_mod_page.flag_a_reply_in_post :setting_type => :high
    # admin reject the flagged reply
    @admin_mod_page.about_login("network_admin", "logged")
    assert ( @admin_mod_page.admin_reject_post_or_reply reply_obj[:title], reply_obj[:answer_text], reply_obj[:descrip], :flagged ) == true
    assert ( @admin_mod_page.find_reply_by_title_and_tabtype reply_obj[:title], reply_obj[:answer_text], reply_obj[:descrip], :perm_removed ) == true
    # admin view the rejected reply
    @browser.goto reply_obj[:url]
    @admin_mod_page.review_rejected_reply :is_admin => true
    # user1 review the rejected reply
    @admin_mod_page.about_login("regular_user1", "logged")
    @browser.goto reply_obj[:url]
    @admin_mod_page.review_rejected_reply :is_root_post_owner => true
    # user2 review the rejected reply
    @admin_mod_page.about_login("regular_user2", "logged")
    @browser.goto reply_obj[:url]
    @admin_mod_page.review_rejected_reply
  end

  def test_00240_approve_reply_by_admin_in_middle_level_setting
    @admin_mod_page.set_moderation_threshold("2", :medium)
    reply_obj = @admin_mod_page.create_reply_in_post :medium
    # admin approve the reply
    @admin_mod_page.about_login("network_admin", "logged")
    @admin_mod_page.admin_approve_reply_or_post reply_obj[:title], reply_obj[:answer_text], reply_obj[:descrip], :pending_approval
    # admin review the reply created by user1
    @browser.goto reply_obj[:url]
    @admin_mod_page.assert_create_reply :is_admin => true
    assert ( @admin_mod_page.find_reply_by_title :title => reply_obj[:title], :answer_text => reply_obj[:answer_text],:descrip => reply_obj[:descrip]) == false

    # user1 review the reply created by user1
    @admin_mod_page.about_login("regular_user1", "logged")
    @browser.goto reply_obj[:url]
    @admin_mod_page.assert_create_reply :setting_type => :low, :is_root_post_owner => true

    # user2 review the reply created by user1
    @admin_mod_page.about_login("regular_user2", "logged")
    @browser.goto reply_obj[:url]
    @admin_mod_page.assert_create_reply :setting_type => :low
  end

  def test_00241_approve_reply_by_admin_in_high_level_setting
    @admin_mod_page.set_moderation_threshold("2", :high)
    reply_obj = @admin_mod_page.create_reply_in_post :high
    # admin approve the reply
    @admin_mod_page.about_login("network_admin", "logged")
    @admin_mod_page.admin_approve_reply_or_post reply_obj[:title], reply_obj[:answer_text], reply_obj[:descrip], :pending_approval
    @admin_mod_page.admin_approve_reply_or_post reply_obj[:title], reply_obj[:answer_text], reply_obj[:descrip], :pending_approval
    # admin review the reply created by user1
    @browser.goto reply_obj[:url]
    @admin_mod_page.assert_create_reply :is_admin => true
    # no moderation hint????
    assert (!@convdetail_page.reply.style("background-color").include? "255, 252, 181")
    # user1 review the reply created by user1
    @admin_mod_page.about_login("regular_user1", "logged")
    @browser.goto reply_obj[:url]
    @admin_mod_page.assert_create_reply :setting_type => :low, :is_root_post_owner => true

    # user2 review the reply created by user1
    @admin_mod_page.about_login("regular_user2", "logged")
    @browser.goto reply_obj[:url]
    @admin_mod_page.assert_create_reply :setting_type => :low
  end

  p02
  def test_00251_create_conv_by_user_in_low_level_setting
    @admin_mod_page.set_moderation_threshold("2", :low)
    reply_obj = @admin_mod_page.create_reply_in_post :low, false
    # user2 review the reply created by user1
    @admin_mod_page.about_login("regular_user2", "logged")
    @browser.goto reply_obj[:url]
    @admin_mod_page.assert_create_conv :setting_type => :low

    # admin review the reply created by user1
    @admin_mod_page.about_login("network_admin", "logged")
    @browser.goto reply_obj[:url]
    @admin_mod_page.assert_create_conv :is_admin => true, :setting_type => :low
  end

  def test_00252_create_conv_by_user_in_middle_level_setting
    @admin_mod_page.set_moderation_threshold("2", :medium)
    reply_obj = @admin_mod_page.create_reply_in_post :medium, false
    # user2 review the reply created by user1
    @admin_mod_page.about_login("regular_user2", "logged")
    @browser.goto reply_obj[:url]
    @admin_mod_page.assert_create_conv :setting_type => :medium, :title => reply_obj[:title]

    # admin review the reply created by user1
    @admin_mod_page.about_login("network_admin", "logged")
    @browser.goto reply_obj[:url]
    @admin_mod_page.assert_create_conv :is_admin => true, :title => reply_obj[:title], :setting_type => :medium
    assert (@admin_mod_page.find_reply_by_title_and_tabtype reply_obj[:title], reply_obj[:answer_text], reply_obj[:descrip], :pending_approval, false) == true
  end

  def test_00253_create_conv_by_user_in_high_level_setting
    @admin_mod_page.set_moderation_threshold("2", :high)
    reply_obj = @admin_mod_page.create_reply_in_post :high, false
    # user2 review the reply created by user1
    @admin_mod_page.about_login("regular_user2", "logged")
    @browser.goto reply_obj[:url]
    @admin_mod_page.assert_create_conv :setting_type => :high

    # admin review the reply created by user1
    @admin_mod_page.about_login("network_admin", "logged")
    @browser.goto reply_obj[:url]
    @admin_mod_page.assert_create_conv :is_admin => true, :setting_type => :high
  end

  def test_00260_flag_conv_at_low_level_setting
    @admin_mod_page.set_moderation_threshold("2", :low)
    # user1 create reply to a post
    reply_obj = @admin_mod_page.create_reply_in_post :low

    # user2 flag the conv created by user1
    @admin_mod_page.about_login("regular_user2", "logged")
    @browser.goto reply_obj[:url]
    @admin_mod_page.flag_a_conversation
    assert ( @admin_mod_page.goto_conv_detail_from_topic_list_page :topic => "A Watir Topic", :title => reply_obj[:title] ) == true

    # no change for what user1 see
    @admin_mod_page.about_login("regular_user1", "logged")
    @browser.goto reply_obj[:url]
    @admin_mod_page.assert_create_conv :is_root_post_owner => true
    assert ( @admin_mod_page.goto_conv_detail_from_topic_list_page :topic => "A Watir Topic", :title => reply_obj[:title] ) == true

    # no change for what user3 see
    @admin_mod_page.about_login("regular_user3", "logged")
    @browser.goto reply_obj[:url]
    @admin_mod_page.assert_create_conv
    assert ( @admin_mod_page.goto_conv_detail_from_topic_list_page :topic => "A Watir Topic", :title => reply_obj[:title] ) == true

    # no change for what admin see
    @admin_mod_page.about_login("network_admin", "logged")
    @browser.goto reply_obj[:url]
    @admin_mod_page.assert_create_conv :is_admin => true
    assert ( @admin_mod_page.goto_conv_detail_from_topic_list_page :topic => "A Watir Topic", :title => reply_obj[:title] ) == true

    assert ( @admin_mod_page.find_reply_by_title_and_tabtype reply_obj[:title], reply_obj[:answer_text], reply_obj[:descrip], :flagged) == false
    #user3 flag the conv to reach the threshold 
    @admin_mod_page.about_login("regular_user3", "logged")
    @browser.goto reply_obj[:url]
    @admin_mod_page.flag_a_conversation :refresh_after_flag => true
    assert ( @admin_mod_page.goto_conv_detail_from_topic_list_page :topic => "A Watir Topic", :title => reply_obj[:title]) == false

    # user1 review the reply and can't see the reply content
    @admin_mod_page.about_login("regular_user1", "logged")
    @browser.goto reply_obj[:url]
    @admin_mod_page.root_post_owner_review_flagged_conv
    # no change for reply 
    # admin review the flagged reply 
    @admin_mod_page.about_login("network_admin", "logged")
    @browser.goto reply_obj[:url]
    @admin_mod_page.admin_review_flagged_conv
    assert ( @admin_mod_page.goto_conv_detail_from_topic_list_page :topic => "A Watir Topic", :title => reply_obj[:title] ) == false
    assert ( @admin_mod_page.find_reply_by_title_and_tabtype reply_obj[:title], reply_obj[:answer_text], reply_obj[:descrip], :flagged) == true
  end

  def test_00270_reinstate_conv_after_flag_in_low_level_setting
    @admin_mod_page.set_moderation_threshold("1", :low)
    # user1 create reply to a post
    reply_obj = @admin_mod_page.create_reply_in_post :low

    # user2 flag the conv created by user1
    @admin_mod_page.about_login("regular_user2", "logged")
    @browser.goto reply_obj[:url]
    @admin_mod_page.flag_a_conversation

    # admin reinstate the conv in admin moderation page
    @admin_mod_page.about_login("network_admin", "logged")
    @admin_mod_page.admin_reinstate_post_or_reply reply_obj[:title], reply_obj[:answer_text], reply_obj[:descrip], :flagged
    assert ( @admin_mod_page.find_reply_by_title_and_tabtype reply_obj[:title], reply_obj[:answer_text], reply_obj[:descrip],:flagged) == false
    @browser.goto reply_obj[:url]
    @admin_mod_page.assert_create_conv :is_admin => true, :setting_type => :low, :is_reinstate => true
    assert ( @admin_mod_page.goto_conv_detail_from_topic_list_page :topic => "A Watir Topic", :title => reply_obj[:title] ) == true
    @admin_mod_page.no_change_for_reply_after_operation_on_conv :is_admin => true
    # user1 review the conv and find no change
    @admin_mod_page.about_login("regular_user1", "logged")
    @browser.goto reply_obj[:url]
    @admin_mod_page.assert_create_conv :is_root_post_owner => true, :setting_type => :low, :is_reinstate => true

    # user2 reivew the 
    @admin_mod_page.about_login("regular_user2", "logged")
    @browser.goto reply_obj[:url]
    @admin_mod_page.assert_create_conv :setting_type => :low, :is_reinstate => true
    assert ( @admin_mod_page.goto_conv_detail_from_topic_list_page :topic => "A Watir Topic", :title => reply_obj[:title] ) == true
    @admin_mod_page.no_change_for_reply_after_operation_on_conv
  end

  def test_00271_reinstate_conv_after_flag_in_middle_level_setting
    @admin_mod_page.set_moderation_threshold("1", :medium)
    # user1 create reply to a post
    reply_obj = @admin_mod_page.create_reply_in_post :medium
    @admin_mod_page.about_login("network_admin", "logged")

    # admin approve both conv and reply
    assert ( @admin_mod_page.admin_approve_reply_or_post reply_obj[:title], nil, reply_obj[:descrip], :pending_approval ) == true
    assert ( @admin_mod_page.admin_approve_reply_or_post reply_obj[:title], reply_obj[:answer_text], reply_obj[:descrip], :pending_approval ) == true

    # user2 flag both conv and reply
    @admin_mod_page.about_login("regular_user2", "logged")
    @browser.goto reply_obj[:url]
    @admin_mod_page.flag_a_reply_in_post
    @admin_mod_page.flag_a_conversation

    # admin reinstate the conv
    @admin_mod_page.about_login("network_admin", "logged")
    assert ( @admin_mod_page.admin_reinstate_post_or_reply reply_obj[:title], reply_obj[:answer_text], reply_obj[:descrip], :flagged ) == true
    # admin review the rejected conv detail page
    @browser.goto reply_obj[:url]
    @admin_mod_page.assert_create_conv :is_admin => true, :setting_type => :low, :is_reinstate => true
    @admin_mod_page.admin_review_flagged_reply
    assert ( @admin_mod_page.goto_conv_detail_from_topic_list_page :topic => "A Watir Topic", :title => reply_obj[:title] ) == true

    # user1 review the reinstated conv
    @admin_mod_page.about_login("regular_user1", "logged")
    @browser.goto reply_obj[:url]
    @admin_mod_page.assert_create_conv :is_root_post_owner => true, :setting_type => :low, :is_reinstate => true
    @admin_mod_page.root_post_owner_review_flagged_reply
    assert ( @admin_mod_page.goto_conv_detail_from_topic_list_page :topic => "A Watir Topic", :title => reply_obj[:title] ) == true

    # user2 review the reinstated conv
    @admin_mod_page.about_login("regular_user2", "logged")
    @browser.goto reply_obj[:url]
    @admin_mod_page.assert_create_conv :setting_type => :low, :is_reinstate => true
    @admin_mod_page.root_post_owner_review_flagged_reply true
    assert ( @admin_mod_page.goto_conv_detail_from_topic_list_page :topic => "A Watir Topic", :title => reply_obj[:title] ) == true

    # user3 same as user2
    @admin_mod_page.about_login("regular_user3", "logged")
    @browser.goto reply_obj[:url]
    @admin_mod_page.assert_create_conv :setting_type => :low, :is_reinstate => true
    @admin_mod_page.root_post_owner_review_flagged_reply true
    assert ( @admin_mod_page.goto_conv_detail_from_topic_list_page :topic => "A Watir Topic", :title => reply_obj[:title] ) == true
  end

    def test_00272_reinstate_conv_after_flag_in_high_level_setting
    @admin_mod_page.set_moderation_threshold("1", :high)
    # user1 create reply to a post
    reply_obj = @admin_mod_page.create_reply_in_post :high
    @admin_mod_page.about_login("network_admin", "logged")

    # admin approve both conv and reply
    assert ( @admin_mod_page.admin_approve_reply_or_post reply_obj[:title], nil, reply_obj[:descrip], :pending_approval ) == true
    assert ( @admin_mod_page.admin_approve_reply_or_post reply_obj[:title], reply_obj[:answer_text], reply_obj[:descrip], :pending_approval ) == true

    # user2 flag both conv and reply
    @admin_mod_page.about_login("regular_user2", "logged")
    @browser.goto reply_obj[:url]
    @admin_mod_page.flag_a_reply_in_post
    @admin_mod_page.flag_a_conversation

    # admin reinstate the conv
    @admin_mod_page.about_login("network_admin", "logged")
    assert ( @admin_mod_page.admin_reinstate_post_or_reply reply_obj[:title], reply_obj[:answer_text], reply_obj[:descrip], :flagged ) == true
    # admin review the rejected conv detail page
    @browser.goto reply_obj[:url]
    @admin_mod_page.assert_create_conv :is_admin => true, :setting_type => :low, :is_reinstate => true
    @admin_mod_page.admin_review_flagged_reply
    assert ( @admin_mod_page.goto_conv_detail_from_topic_list_page :topic => "A Watir Topic", :title => reply_obj[:title] ) == true

    # user1 review the reinstated conv
    @admin_mod_page.about_login("regular_user1", "logged")
    @browser.goto reply_obj[:url]
    @admin_mod_page.assert_create_conv :is_root_post_owner => true, :setting_type => :low, :is_reinstate => true
    @admin_mod_page.root_post_owner_review_flagged_reply
    assert ( @admin_mod_page.goto_conv_detail_from_topic_list_page :topic => "A Watir Topic", :title => reply_obj[:title] ) == true

    # user2 review the reinstated conv
    @admin_mod_page.about_login("regular_user2", "logged")
    @browser.goto reply_obj[:url]
    @admin_mod_page.assert_create_conv :setting_type => :low, :is_reinstate => true
    @admin_mod_page.root_post_owner_review_flagged_reply true
    assert ( @admin_mod_page.goto_conv_detail_from_topic_list_page :topic => "A Watir Topic", :title => reply_obj[:title] ) == true

    # user3 same as user2
    @admin_mod_page.about_login("regular_user3", "logged")
    @browser.goto reply_obj[:url]
    @admin_mod_page.assert_create_conv :setting_type => :low, :is_reinstate => true
    @admin_mod_page.root_post_owner_review_flagged_reply true
    assert ( @admin_mod_page.goto_conv_detail_from_topic_list_page :topic => "A Watir Topic", :title => reply_obj[:title] ) == true
  end

  def test_00280_reject_conv_after_flag_in_low_level_setting
    @admin_mod_page.set_moderation_threshold("1", :low)
    # user1 create reply to a post
    reply_obj = @admin_mod_page.create_reply_in_post :low

    # user2 flag the conv created by user1
    @admin_mod_page.about_login("regular_user2", "logged")
    @browser.goto reply_obj[:url]
    @admin_mod_page.flag_a_conversation

    # admin reject the conv 
    @admin_mod_page.about_login("network_admin", "logged")
    assert ( @admin_mod_page.admin_reject_post_or_reply reply_obj[:title], reply_obj[:answer_text], reply_obj[:descrip], :flagged ) == true
    assert ( @admin_mod_page.find_reply_by_title_and_tabtype reply_obj[:title], reply_obj[:answer_text], reply_obj[:descrip], :perm_removed) == true
    # admin review the rejected conv
    @browser.goto reply_obj[:url]
    @admin_mod_page.review_rejected_conv  :is_admin => true
    @admin_mod_page.review_rejected_reply :is_admin => true
    # invisible for admin in the topic detail page
    assert ( @admin_mod_page.goto_conv_detail_from_topic_list_page :topic => "A Watir Topic", :title => reply_obj[:title] ) == false

    # user1 review the rejected conv
    @admin_mod_page.about_login("regular_user1", "logged")
    @browser.goto reply_obj[:url]
    @admin_mod_page.review_rejected_conv  :is_root_post_owner => true
    @admin_mod_page.review_rejected_reply :is_root_post_owner => true
    # visible for creator in the topic detail page
    assert ( @admin_mod_page.goto_conv_detail_from_topic_list_page :topic => "A Watir Topic", :title => reply_obj[:title] ) == true
    
    # user2 review the rejected conv
    @admin_mod_page.about_login("regular_user2", "logged")
    @browser.goto reply_obj[:url]
    @admin_mod_page.review_rejected_conv
    assert !@convdetail_page.conv_reply.present?
    # invisible for non-creator in the topic detail page
    assert ( @admin_mod_page.goto_conv_detail_from_topic_list_page :topic => "A Watir Topic", :title => reply_obj[:title] ) == false
  end

  def test_00281_reject_conv_after_creation_in_middle_level_setting
    @admin_mod_page.set_moderation_threshold("1", :medium)
    # user1 create reply to a post
    reply_obj = @admin_mod_page.create_reply_in_post :medium

    # admin reject the conv
    @admin_mod_page.about_login("network_admin", "logged")
    assert ( @admin_mod_page.admin_reject_post_or_reply reply_obj[:title], nil, reply_obj[:descrip], :pending_approval ) == true
    assert ( @admin_mod_page.find_reply_by_title_and_tabtype reply_obj[:title], reply_obj[:answer_text], reply_obj[:descrip], :perm_removed ) == true

    # admin review the conv detail page
    @browser.goto reply_obj[:url]
    @admin_mod_page.review_rejected_conv  :is_admin => true
    @admin_mod_page.review_rejected_reply :is_admin => true
    # invisible for admin in the topic detail page
    assert ( @admin_mod_page.goto_conv_detail_from_topic_list_page :topic => "A Watir Topic", :title => reply_obj[:title] ) == false

    # user1 review the conv detail page
    @admin_mod_page.about_login("regular_user1", "logged")
    @browser.goto reply_obj[:url]
    @admin_mod_page.review_rejected_conv  :is_root_post_owner => true
    @admin_mod_page.review_rejected_reply :is_root_post_owner => true
    # visible for creator in the topic detail page
    assert ( @admin_mod_page.goto_conv_detail_from_topic_list_page :topic => "A Watir Topic", :title => reply_obj[:title] ) == true

    # user2 review the rejected conv
    @admin_mod_page.about_login("regular_user2", "logged")
    @browser.goto reply_obj[:url]
    @admin_mod_page.review_rejected_conv
    assert !@convdetail_page.conv_reply.present?
    # invisible for non-creator in the topic detail page
    assert ( @admin_mod_page.goto_conv_detail_from_topic_list_page :topic => "A Watir Topic", :title => reply_obj[:title] ) == false
  end

  def test_00282_reject_conv_after_flag_in_middle_level_setting
    @admin_mod_page.set_moderation_threshold("1", :medium)
    # user1 create reply to a post
    reply_obj = @admin_mod_page.create_reply_in_post :medium

    # admin approve both conv and reply
    @admin_mod_page.about_login("network_admin", "logged")
    assert ( @admin_mod_page.admin_approve_reply_or_post reply_obj[:title], nil, reply_obj[:descrip], :pending_approval ) == true
    assert ( @admin_mod_page.admin_approve_reply_or_post reply_obj[:title], reply_obj[:answer_text], reply_obj[:descrip], :pending_approval ) == true

    # user2 flag the conv as inappretiate
    @admin_mod_page.about_login("regular_user2", "logged")
    @browser.goto reply_obj[:url]
    @admin_mod_page.flag_a_conversation

    # admin reject the conv
    @admin_mod_page.about_login("network_admin", "logged")
    assert ( @admin_mod_page.admin_reject_post_or_reply reply_obj[:title], reply_obj[:answer_text], reply_obj[:descrip], :flagged ) == true
    assert ( @admin_mod_page.find_reply_by_title_and_tabtype reply_obj[:title], reply_obj[:answer_text], reply_obj[:descrip], :perm_removed ) == true
    # admin review the conv detail page
    @browser.goto reply_obj[:url]
    @admin_mod_page.review_rejected_conv  :is_admin => true
    @browser.refresh
    @admin_mod_page.review_rejected_reply :is_admin => true
    # invisible for admin in the topic detail page
    assert ( @admin_mod_page.goto_conv_detail_from_topic_list_page :topic => "A Watir Topic", :title => reply_obj[:title] ) == false

    # user1 review the conv detail page
    @admin_mod_page.about_login("regular_user1", "logged")
    @browser.goto reply_obj[:url]
    @admin_mod_page.review_rejected_conv  :is_root_post_owner => true
    @admin_mod_page.review_rejected_reply :is_root_post_owner => true
    # visible for creator in the topic detail page
    assert ( @admin_mod_page.goto_conv_detail_from_topic_list_page :topic => "A Watir Topic", :title => reply_obj[:title] ) == true

    # user2 review the rejected conv
    @admin_mod_page.about_login("regular_user2", "logged")
    @browser.goto reply_obj[:url]
    @admin_mod_page.review_rejected_conv
    assert !@convdetail_page.conv_reply.present?
    # invisible for non-creator in the topic detail page
    assert ( @admin_mod_page.goto_conv_detail_from_topic_list_page :topic => "A Watir Topic", :title => reply_obj[:title] ) == false
  end

  def test_00283_reject_conv_after_creation_in_high_level_setting
    @admin_mod_page.set_moderation_threshold("2", :high)
    # user1 create reply to a post
    reply_obj = @admin_mod_page.create_reply_in_post :high

    # admin reject the conv
    @admin_mod_page.about_login("network_admin", "logged")
    assert ( @admin_mod_page.admin_reject_post_or_reply reply_obj[:title], nil, reply_obj[:descrip], :pending_approval ) == true
    assert ( @admin_mod_page.find_reply_by_title_and_tabtype reply_obj[:title], reply_obj[:answer_text], reply_obj[:descrip], :perm_removed ) == true

    # admin review the conv detail page
    @browser.goto reply_obj[:url]
    @admin_mod_page.review_rejected_conv  :is_admin => true
    @admin_mod_page.review_rejected_reply :is_admin => true
    # invisible for admin in the topic detail page
    assert ( @admin_mod_page.goto_conv_detail_from_topic_list_page :topic => "A Watir Topic", :title => reply_obj[:title] ) == false

    # user1 review the conv detail page
    @admin_mod_page.about_login("regular_user1", "logged")
    @browser.goto reply_obj[:url]
    @admin_mod_page.review_rejected_conv  :is_root_post_owner => true
    @admin_mod_page.review_rejected_reply :is_root_post_owner => true
    # visible for creator in the topic detail page
    assert ( @admin_mod_page.goto_conv_detail_from_topic_list_page :topic => "A Watir Topic", :title => reply_obj[:title] ) == true

    # user2 review the rejected conv
    @admin_mod_page.about_login("regular_user2", "logged")
    @browser.goto reply_obj[:url]
    @admin_mod_page.review_rejected_conv
    assert !@convdetail_page.conv_reply.present?
    # invisible for non-creator in the topic detail page
    assert ( @admin_mod_page.goto_conv_detail_from_topic_list_page :topic => "A Watir Topic", :title => reply_obj[:title] ) == false
  end

  def test_00284_reject_conv_after_flag_in_high_level_setting
    @admin_mod_page.set_moderation_threshold("1", :high)
    # user1 create reply to a post
    reply_obj = @admin_mod_page.create_reply_in_post :high

    # admin approve both conv and reply
    @admin_mod_page.about_login("network_admin", "logged")
    assert ( @admin_mod_page.admin_approve_reply_or_post reply_obj[:title], nil, reply_obj[:descrip], :pending_approval ) == true
    assert ( @admin_mod_page.admin_approve_reply_or_post reply_obj[:title], reply_obj[:answer_text], reply_obj[:descrip], :pending_approval ) == true

    # user2 flag the conv as inappretiate
    @admin_mod_page.about_login("regular_user2", "logged")
    @browser.goto reply_obj[:url]
    @admin_mod_page.flag_a_conversation

    # admin reject the conv
    @admin_mod_page.about_login("network_admin", "logged")
    assert ( @admin_mod_page.admin_reject_post_or_reply reply_obj[:title], reply_obj[:answer_text], reply_obj[:descrip], :flagged ) == true
    assert ( @admin_mod_page.find_reply_by_title_and_tabtype reply_obj[:title], reply_obj[:answer_text], reply_obj[:descrip], :perm_removed ) == true
    # admin review the conv detail page
    @browser.goto reply_obj[:url]
    @admin_mod_page.review_rejected_conv  :is_admin => true
    @browser.refresh
    @admin_mod_page.review_rejected_reply :is_admin => true
    # invisible for admin in the topic detail page
    assert ( @admin_mod_page.goto_conv_detail_from_topic_list_page :topic => "A Watir Topic", :title => reply_obj[:title] ) == false

    # user1 review the conv detail page
    @admin_mod_page.about_login("regular_user1", "logged")
    @browser.goto reply_obj[:url]
    @admin_mod_page.review_rejected_conv  :is_root_post_owner => true
    @admin_mod_page.review_rejected_reply :is_root_post_owner => true
    # visible for creator in the topic detail page
    assert ( @admin_mod_page.goto_conv_detail_from_topic_list_page :topic => "A Watir Topic", :title => reply_obj[:title] ) == true

    # user2 review the rejected conv
    @admin_mod_page.about_login("regular_user2", "logged")
    @browser.goto reply_obj[:url]
    @admin_mod_page.review_rejected_conv
    assert !@convdetail_page.conv_reply.present?
    # invisible for non-creator in the topic detail page
    assert ( @admin_mod_page.goto_conv_detail_from_topic_list_page :topic => "A Watir Topic", :title => reply_obj[:title] ) == false
  end

  def test_00290_approve_conv_by_admin_in_middle_level_setting
    @admin_mod_page.set_moderation_threshold("1", :medium)
    # user1 create reply to a post
    reply_obj = @admin_mod_page.create_reply_in_post :medium

    # admin approve the conv
    @admin_mod_page.about_login("network_admin", "logged")
    @admin_mod_page.admin_approve_reply_or_post reply_obj[:title], nil, reply_obj[:descrip], :pending_approval
    @browser.goto reply_obj[:url]
    # conv is approved and reply is still pending
    @admin_mod_page.assert_create_conv  :is_admin => true, :setting_type => :low
    @browser.refresh
    @admin_mod_page.assert_create_reply :is_admin => true, :setting_type => :medium
    # visible for admin in the topic detail page
    assert ( @admin_mod_page.goto_conv_detail_from_topic_list_page :topic => "A Watir Topic", :title => reply_obj[:title] ) == true

    # user1 review the conv 
    @admin_mod_page.about_login("regular_user1", "logged")
    @browser.goto reply_obj[:url]
    @admin_mod_page.assert_create_conv :is_root_post_owner => true, :setting_type => :low

    # user2 review the conv 
    @admin_mod_page.about_login("regular_user2", "logged")
    @browser.goto reply_obj[:url]
    @admin_mod_page.assert_create_conv  :setting_type => :low
    @admin_mod_page.assert_create_reply :setting_type => :medium
    assert ( @admin_mod_page.goto_conv_detail_from_topic_list_page :topic => "A Watir Topic", :title => reply_obj[:title] ) == true
  end

  def test_00291_approve_conv_by_admin_in_high_level_setting
    @admin_mod_page.set_moderation_threshold("2", :high)
    # user1 create reply to a post
    reply_obj = @admin_mod_page.create_reply_in_post :high

    # admin approve the conv
    @admin_mod_page.about_login("network_admin", "logged")
    @admin_mod_page.admin_approve_reply_or_post reply_obj[:title], nil, reply_obj[:descrip], :pending_approval

    @browser.goto reply_obj[:url]
    # conv is approved and reply is still pending
    @admin_mod_page.assert_create_conv  :is_admin => true, :setting_type => :low
    @browser.refresh
    @admin_mod_page.assert_create_reply :is_admin => true, :setting_type => :high
    # visible for admin in the topic detail page
    assert ( @admin_mod_page.goto_conv_detail_from_topic_list_page :topic => "A Watir Topic", :title => reply_obj[:title] ) == true

    # user1 review the conv 
    @admin_mod_page.about_login("regular_user1", "logged")
    @browser.goto reply_obj[:url]
    @admin_mod_page.assert_create_conv  :is_root_post_owner => true, :setting_type => :low
    @browser.refresh
    @admin_mod_page.assert_create_reply :is_root_post_owner => true, :setting_type => :high
    assert ( @admin_mod_page.goto_conv_detail_from_topic_list_page :topic => "A Watir Topic", :title => reply_obj[:title] ) == true

    # user2 review the conv 
    @admin_mod_page.about_login("regular_user2", "logged")
    @browser.goto reply_obj[:url]
    @admin_mod_page.assert_create_conv  :setting_type => :low
    assert ( @admin_mod_page.goto_conv_detail_from_topic_list_page :topic => "A Watir Topic", :title => reply_obj[:title] ) == true
  end

end
