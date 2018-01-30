require 'watir_test'
require 'pages/community/admin_contributor_rating'
require 'pages/community/profile'
require 'pages/community/topic_list'
require 'pages/community/admin'
require 'pages/community/topicdetail'
require 'pages/community/conversationdetail'
require 'actions/hybris/api'
require 'pages/community/login'
require 'pages/community/conversation/conversation_create'

# Note!!!
# regular_user5 is specificly used for calculating contributor rating. 
# Please do not use it in other places.

class AdminContributorRatingTest < WatirTest

  def setup
    super
    @admin_contri_rating_page = Pages::Community::AdminContributorRating.new(@config)
    @profile_page = Pages::Community::Profile.new(@config)
    @topiclist_page = Pages::Community::TopicList.new(@config)
    @topicdetail_page = Pages::Community::TopicDetail.new(@config)
    @convcreate_page = Pages::Community::ConversationCreate.new(@config)
    @admin_page = Pages::Community::Admin.new(@config)
    @convdetail_page = Pages::Community::ConversationDetail.new(@config)
    @api_actions = Actions::Api.new(@config)
    @login_page = Pages::Community::Login.new(@config)

    @level_icon_css = ".contributor-level-meta [class^=contributor-level]"

    @current_page = @admin_contri_rating_page
    puts "[[[ #{name} ::: #{user_for_test} ]]]" if @config.verbose?
    @browser = @config.browser
    @admin_contri_rating_page.start!(user_for_test) if user_for_test == :network_admin
    @login_page.login!(@config.users[user_for_test]) if user_for_test != :network_admin
  end

  def teardown
    super
  end

  # =================== common methods ====================
  def goto_profile_page_verify_contri_visibility(expected_visibility = false)
    @profile_page.goto_profile
    @browser.wait_until { @browser.ready_state == "complete" }
    @profile_page.switch_to_tab(:about)
    assert !@profile_page.contri_level_progress.present?
  end
  # =================== end common methods ====================

  user :network_admin
  p1
  def test_00010_check_contributor_rating_ui
    # Step1: turn off the contributor switch if not
    @admin_contri_rating_page.switch_contri_rating(:off)

    # check display and timeframe settings are disabled
    assert @admin_contri_rating_page.contri_rating_setup_display_div.class_name.include?('setup-disabled')
    assert @admin_contri_rating_page.contri_rating_setup_timeframe_div.class_name.include?('setup-disabled')
    assert @admin_contri_rating_page.contri_rating_points_and_ranking_tab_header.parent.class_name.include?('setup-disabled')

    # Step2: turn on the contributor switch if not
    @admin_contri_rating_page.switch_contri_rating(:on)

    # check display and timeframe settings are enabled
    assert !@admin_contri_rating_page.contri_rating_setup_display_div.class_name.include?('setup-disabled')
    assert !@admin_contri_rating_page.contri_rating_setup_timeframe_div.class_name.include?('setup-disabled')
    assert !@admin_contri_rating_page.contri_rating_points_and_ranking_tab_header.parent.class_name.include?('setup-disabled')


    # switch on/off display setting options
    @admin_contri_rating_page.switch_setting_option(:display, "Product topic details", :off)
    assert !@admin_contri_rating_page.setting_option_checkbox_input(:display, "Product topic details").checked?
    @admin_contri_rating_page.switch_setting_option(:display, "Single item view", :off)
    assert !@admin_contri_rating_page.setting_option_checkbox_input(:display, "Single item view").checked?
    @admin_contri_rating_page.switch_setting_option(:display, "Widgets", :off)
    assert !@admin_contri_rating_page.setting_option_checkbox_input(:display, "Widgets").checked?
    @admin_contri_rating_page.switch_setting_option(:display, "Ratings in profile", :off)
    assert !@admin_contri_rating_page.setting_option_checkbox_input(:display, "Ratings in profile").checked?

    @admin_contri_rating_page.switch_setting_option(:display, "Product topic details", :on)
    assert @admin_contri_rating_page.setting_option_checkbox_input(:display, "Product topic details").checked?
    @admin_contri_rating_page.switch_setting_option(:display, "Single item view", :on)
    assert @admin_contri_rating_page.setting_option_checkbox_input(:display, "Single item view").checked?
    @admin_contri_rating_page.switch_setting_option(:display, "Widgets", :on)
    assert @admin_contri_rating_page.setting_option_checkbox_input(:display, "Widgets").checked?
    @admin_contri_rating_page.switch_setting_option(:display, "Ratings in profile", :on)
    assert @admin_contri_rating_page.setting_option_checkbox_input(:display, "Ratings in profile").checked?
    # switch on/off timeframe setting
    @admin_contri_rating_page.switch_timeframe(:off)

    assert @admin_contri_rating_page.contri_rating_setup_timeframe_options_div.class_name.include?('setup-disabled')

    @admin_contri_rating_page.switch_timeframe(:on)

    assert !@admin_contri_rating_page.contri_rating_setup_timeframe_options_div.class_name.include?('setup-disabled')

    # switch on/off timeframe setting options
    @admin_contri_rating_page.switch_setting_option(:timeframe, "Last 30 days", :on)
    assert @admin_contri_rating_page.setting_option_checkbox_input(:timeframe, "Last 30 days").checked?
    assert !@admin_contri_rating_page.setting_option_checkbox_input(:timeframe, "Last 90 days").checked?
    assert !@admin_contri_rating_page.setting_option_checkbox_input(:timeframe, "Last 180 days").checked?

    @admin_contri_rating_page.switch_setting_option(:timeframe, "Last 90 days", :on)
    assert !@admin_contri_rating_page.setting_option_checkbox_input(:timeframe, "Last 30 days").checked?
    assert @admin_contri_rating_page.setting_option_checkbox_input(:timeframe, "Last 90 days").checked?
    assert !@admin_contri_rating_page.setting_option_checkbox_input(:timeframe, "Last 180 days").checked?

    @admin_contri_rating_page.switch_setting_option(:timeframe, "Last 180 days", :on)
    assert !@admin_contri_rating_page.setting_option_checkbox_input(:timeframe, "Last 30 days").checked?
    assert !@admin_contri_rating_page.setting_option_checkbox_input(:timeframe, "Last 90 days").checked?
    assert @admin_contri_rating_page.setting_option_checkbox_input(:timeframe, "Last 180 days").checked?

    # verify the settings saved after refresh
    @admin_contri_rating_page.save
    @browser.refresh

    skip "Blocked by bug EN-2934"
    @browser.wait_until { @admin_contri_rating_page.contri_rating_setup_timeframe_options_div.present? }
    assert @admin_contri_rating_page.setting_option_checkbox_input(:timeframe, "Last 180 days").checked?
  end 

  user :network_admin
  p1
  def test_00020_check_contributor_rating_switch_off
    # Step1: turn off the contributor switch if not
    @admin_contri_rating_page.switch_contri_rating(:off)

    # Step2: go to profile page to verify no level and points
    goto_profile_page_verify_contri_visibility 

    # Step3: check no level icon n Conversation detail page (include widgets)
    @profile_page.goto_first_conversation

    @convdetail_page.conv_detail_creator_pills.each_with_index do |item, index|
      assert !item.element(:css => @level_icon_css).present?
    end  

    # Step4: check icon level in Topic detail page (include widgets)
    @topiclist_page.go_to_topic("A Watir Topic")
    @topicdetail_page.wait_until_page_loaded

    @topicdetail_page.topic_detail_creator_pills.each_with_index do |item, index|
      assert !item.element(:css => @level_icon_css).present?
    end

    # Step3: turn on the contributor switch if not
    @admin_contri_rating_page.navigate_in
    @admin_contri_rating_page.switch_contri_rating(:on)   
  end

  user :network_admin
  p2
  def test_00030_check_display_options_off
    # turn on the contributor switch if not
    @admin_contri_rating_page.switch_contri_rating(:on) 

    # Step1: tick off "Widgets"
    @admin_contri_rating_page.switch_setting_option(:display, "Widgets", :off)
    @admin_contri_rating_page.switch_setting_option(:display, "Product topic details", :on)
    @admin_contri_rating_page.save

    # go to topic detail page
    @topiclist_page.go_to_topic("A Watir Topic")
    @topicdetail_page.wait_until_page_loaded

    # verify level is not displayed in widget
    # @topicdetail_page.topic_detail_widget_creator_pills.each_with_index do |item, index|
    #   assert !item.element(:css => @level_icon_css).present?
    # end
    @topicdetail_page.topic_detail_site_widgets_avatars.each_with_index do |item, index|
      assert !item.element(:css => @level_icon_css).present?
    end
    # verify level is displayed for posts in topic detail page
    # @topicdetail_page.topic_detail_posts_creator_pills.each_with_index do |item, index|
    #   @browser.wait_until { item.element(:css => @level_icon_css).present? }  
    #   assert item.element(:css => @level_icon_css).present?
    # end
    @topicdetail_page.topic_detail_posts_avatars.each_with_index do |item, index|
      @browser.wait_until { item.element(:css => @level_icon_css).present? }  
      assert item.element(:css => @level_icon_css).present?
    end

    # Step2: tick off other display options
    @admin_contri_rating_page.navigate_in
    @admin_contri_rating_page.switch_setting_option(:display, "Product topic details", :off)
    @admin_contri_rating_page.switch_setting_option(:display, "Single item view", :off)
    @admin_contri_rating_page.switch_setting_option(:display, "Ratings in profile", :off)
    @admin_contri_rating_page.save

    # verify no level in profile page
    goto_profile_page_verify_contri_visibility 

    # verify no level in conversation detail page (include widgets)
    @profile_page.goto_first_conversation
    # @convdetail_page.conv_detail_creator_pills.each_with_index do |item, index|
    #   assert !item.element(:css => @level_icon_css).present?
    # end 
    @convdetail_page.conv_detail_posts_avatars.each_with_index do |item, index|
      assert !item.element(:css => @level_icon_css).present?
    end 
    @convdetail_page.conv_detail_site_widgets_avatars.each_with_index do |item, index|
      assert !item.element(:css => @level_icon_css).present?
    end  

    # verify no level in Topic detail page (include widgets)
    @topiclist_page.go_to_topic("A Watir Topic")
    @topicdetail_page.wait_until_page_loaded

    # @topicdetail_page.topic_detail_creator_pills.each_with_index do |item, index|
    #   assert !item.element(:css => @level_icon_css).present?
    # end
    @topicdetail_page.topic_detail_posts_avatars.each_with_index do |item, index|
      assert !item.element(:css => @level_icon_css).present?
    end
    @topicdetail_page.topic_detail_site_widgets_avatars.each_with_index do |item, index|
      assert !item.element(:css => @level_icon_css).present?
    end

    # Step3: tick on all display options
    @admin_contri_rating_page.navigate_in
    @admin_contri_rating_page.switch_setting_option(:display, "Product topic details", :on)
    @admin_contri_rating_page.switch_setting_option(:display, "Single item view", :on)
    @admin_contri_rating_page.switch_setting_option(:display, "Widgets", :on)
    @admin_contri_rating_page.switch_setting_option(:display, "Ratings in profile", :on)
    @admin_contri_rating_page.save
  end

  user :network_admin
  p1
  def test_00040_check_icon_consistent_in_different_pages
    # turn on the contributor switch if not
    @admin_contri_rating_page.switch_contri_rating(:on) 

    # Step1: tick on all display options
    @admin_contri_rating_page.switch_setting_option(:display, "Product topic details", :on)
    @admin_contri_rating_page.switch_setting_option(:display, "Single item view", :on)
    @admin_contri_rating_page.switch_setting_option(:display, "Widgets", :on)
    @admin_contri_rating_page.switch_setting_option(:display, "Ratings in profile", :on)
    @admin_contri_rating_page.save

    # Step2: get current icon and level name in Profile page
    @profile_page.goto_profile
    # level = @profile_page.profile_level.text
    icon_level = @profile_page.contri_level_icon_level
    name = @profile_page.user_name

    # Step3: check icon level in Conversation detail page (include widgets)
    @profile_page.goto_first_conversation

    # @convdetail_page.conv_detail_creator_pills.each_with_index do |item, index|
    #   @browser.wait_until { item.element(:css => @level_icon_css).present? }   
    #   assert item.element(:css => @level_icon_css).present?
    #   # verify the same level displayed for the same specific user
    #   assert item.element(:css => @level_icon_css).class_name.include?(icon_level) if item.link(:text => name).exists?
    # end  
    @convdetail_page.conv_detail_posts_avatars.each_with_index do |item, index|
      @browser.wait_until { item.element(:css => @level_icon_css).present? }   
      assert item.element(:css => @level_icon_css).present?
      # verify the same level displayed for the same specific user
      assert item.element(:css => @level_icon_css).class_name.include?(icon_level) if item.link(:text => name).exists?
    end 
    @convdetail_page.conv_detail_site_widgets_avatars.each_with_index do |item, index|
      @browser.wait_until { item.element(:css => @level_icon_css).present? }   
      assert item.element(:css => @level_icon_css).present?
      # verify the same level displayed for the same specific user
      assert item.element(:css => @level_icon_css).class_name.include?(icon_level) if item.link(:text => name).exists?
    end 

    # Step4: check icon level in Topic detail page (include widgets)
    @topiclist_page.go_to_topic("A Watir Topic")
    @topicdetail_page.wait_until_page_loaded
    @browser.wait_until { @browser.element(:css => @level_icon_css).present? } 
    # @topicdetail_page.topic_detail_creator_pills.each_with_index do |item, index|
    #   @browser.wait_until { item.element(:css => @level_icon_css).present? }
    #   assert item.element(:css => @level_icon_css).present?
    #   # verify the same level displayed for the same specific user
    #   assert item.element(:css => @level_icon_css).class_name.include?(icon_level) if item.link(:text => name).exists?
    # end
    @topicdetail_page.topic_detail_posts_avatars.each_with_index do |item, index|
      @browser.wait_until { item.element(:css => @level_icon_css).present? }
      assert item.element(:css => @level_icon_css).present?
      # verify the same level displayed for the same specific user
      assert item.element(:css => @level_icon_css).class_name.include?(icon_level) if item.link(:text => name).exists?
    end
    @topicdetail_page.topic_detail_site_widgets_avatars.each_with_index do |item, index|
      @browser.wait_until { item.element(:css => @level_icon_css).present? }
      assert item.element(:css => @level_icon_css).present?
      # verify the same level displayed for the same specific user
      assert item.element(:css => @level_icon_css).class_name.include?(icon_level) if item.link(:text => name).exists?
    end
  end

  user :network_admin
  p1
  def test_00050_check_review_events_points
    # Step1: admin modify the points for post review event
    @admin_contri_rating_page.switch_to_tab(:points_and_ranking)

    points_set_for_read = @admin_contri_rating_page.event_points("Read a review")
    old_points_set_for_post = @admin_contri_rating_page.event_points("Post a review")    

    # set new points for Post a review 
    new_points_set_for_post = 8
    @admin_contri_rating_page.set_event_points("Post a review", new_points_set_for_post)
    @admin_contri_rating_page.save

    # Step2: login with regular_user5
    @login_page.login!(@c.users[:regular_user5])
    
    # check current profile points
    @profile_page.goto_profile
    points_before = @profile_page.level_points

    # Step3: create a review
    @topicdetail_page = @topiclist_page.go_to_topic("A Watir Topic")
    title = "review-#{get_timestamp}"
    @topicdetail_page.create_review(title: title, details: [{type: :text, content: "Watir test description"}])
    review_uuid = @browser.url.match(/\/review\/(\w+)\//)[1]
    @browser.wait_until { @convdetail_page.conv_content.present? }

    # verify the new points added by points set for Post a review and Read a review
    @profile_page.goto_profile
    # since the point for Read a review won't be accumulated immediately, 
    # retry several times here.
    expected_points_after = points_before + new_points_set_for_post + points_set_for_read
    points_after = @profile_page.wait_until_contri_rating_points_updated(expected_points_after) 
    assert expected_points_after == points_after

    # Step4: delete the review
    @api_actions.delete_review(@config.users[:network_admin], review_uuid)
    review_uuid = nil

    # verify the new points decreased by points set for Post a review
    expected_points_after = points_before + points_set_for_read
    points_after_delete = @profile_page.wait_until_contri_rating_points_updated(expected_points_after) 
    assert expected_points_after == points_after_delete

    # Step5: admin sets point to default
    @admin_contri_rating_page.start! (:network_admin)
    @admin_contri_rating_page.switch_to_tab(:points_and_ranking)
    @admin_contri_rating_page.set_event_points("Post a review", old_points_set_for_post)
    @admin_contri_rating_page.save
  ensure
    # delete the review if no chance before because of error
    @api_actions.delete_review(@config.users[:network_admin], review_uuid) unless review_uuid.nil? 
  end

  user :network_admin
  p1
  def test_00060_check_question_events_points
    # Step1: admin modify points for some question events
    @admin_contri_rating_page.switch_to_tab(:points_and_ranking)

    points_set_for_post_q = @admin_contri_rating_page.event_points("Post a question")
    points_set_for_read_q = @admin_contri_rating_page.event_points("Read a question")
    points_set_for_answer_q = @admin_contri_rating_page.event_points("Answer a question")
    points_set_for_mark_best = @admin_contri_rating_page.event_points("Marked as best answer")

    new_points_set_for_answer_q = 4
    new_points_set_for_mark_best = 4
    @admin_contri_rating_page.set_event_points("Answer a question", new_points_set_for_answer_q)
    @admin_contri_rating_page.set_event_points("Marked as best answer", new_points_set_for_mark_best)
    @admin_contri_rating_page.save

    # Step2: login with regular_user5
    @login_page.login!(@c.users[:regular_user5])
    
    # check current profile points
    @profile_page.goto_profile
    points_before = @profile_page.level_points

    # Step3: create a question
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
    assert expected_points_after == points_after, "Points incorrect after Read a question"

    # Step4: create a reply to the question
    @browser.goto question_url
    reply_content = "Commented by #{@c.users[:regular_user5].name} for Contributor Rating - #{get_timestamp}"
    @convdetail_page.create_reply(des: reply_content)

    # go to profile page to verify the level points updated
    @profile_page.goto_profile
    expected_points_after = points_after + points_set_for_read_q + new_points_set_for_answer_q
    points_after = @profile_page.wait_until_contri_rating_points_updated(expected_points_after) 
    assert expected_points_after == points_after, "Points incorrect after Answer a question"

    # Step5: login with admin
    @login_page.login!(@c.users[:network_admin])

    # Mark the reply as best answer
    @browser.goto question_url
    @browser.wait_until { @convdetail_page.conv_content.present? }
    @convdetail_page.replies_panel.feature_reply(1, reply_content, :answer)

    # Step6: login with regular_user5
    @login_page.login!(@c.users[:regular_user5])

    # go to profile page to verify the level points updated
    @profile_page.goto_profile
    expected_points_after = points_after + new_points_set_for_mark_best
    points_after = @profile_page.wait_until_contri_rating_points_updated(expected_points_after) 
    assert expected_points_after == points_after, "Points incorrect after Mark as best answer"

    # Step7: admin sets point to default
    @admin_contri_rating_page.start! (:network_admin)
    @admin_contri_rating_page.switch_to_tab(:points_and_ranking)
    @admin_contri_rating_page.set_event_points("Answer a question", points_set_for_answer_q)
    @admin_contri_rating_page.set_event_points("Marked as best answer", points_set_for_mark_best)
    @admin_contri_rating_page.save
  end 

  # pre-condition: there must exist a blog in the specific topic "A Watir Topic"
  user :network_admin
  p1
  def test_00070_check_blog_like_events_points
    # Step1: admin modify the points settings for some blog events done later
    @admin_contri_rating_page.switch_to_tab(:points_and_ranking)

    points_set_for_read_b = @admin_contri_rating_page.event_points("Read a blog")
    points_set_for_comment_b = @admin_contri_rating_page.event_points("Comment on a blog")
    points_set_for_like = @admin_contri_rating_page.event_points("Like")

    new_points_set_for_read_b = 2
    new_points_set_for_comment_b = 4
    new_points_set_for_like = 2
    @admin_contri_rating_page.set_event_points("Read a blog", new_points_set_for_read_b)
    @admin_contri_rating_page.set_event_points("Comment on a blog", new_points_set_for_comment_b)
    @admin_contri_rating_page.set_event_points("Like", new_points_set_for_like)
    @admin_contri_rating_page.save

    # Step2: login with regular_user5
    @login_page.login!(@c.users[:regular_user5])

    # check current profile points
    @profile_page.goto_profile
    points_before = @profile_page.level_points
    @user_id = @browser.url.match(/\/profile\/(\w+)$/)[1]
    @api_actions.promote_user_as_blogger(@config.users[:network_admin], @user_id)
    # must restore the session for regular_user5. otherwise 403 error happen later.
    @api_actions.establish_session(@config.users[:regular_user5])

    # Step3: create a blog
    @topicdetail_page = @topiclist_page.go_to_topic("A Watir Topic")
    title = "Test b created by Watir - #{get_timestamp}"
    @topicdetail_page.create_conversation(type: :blog, 
                                          title: title, 
                                          details: [{type: :text, content: "Watir test description"}])

    blog_url = @browser.url

    # verify the level points updated
    @profile_page.goto_profile
    expected_points_after = points_before + new_points_set_for_read_b
    points_after = @profile_page.wait_until_contri_rating_points_updated(expected_points_after) 
    assert expected_points_after == points_after, "Points incorrect after Create blog"

    # Step4: read the first blog
    @browser.goto blog_url
    @browser.wait_until { @convdetail_page.conv_content.present? }

    # verify the level points updated
    @profile_page.goto_profile
    expected_points_after = points_after + new_points_set_for_read_b
    points_after = @profile_page.wait_until_contri_rating_points_updated(expected_points_after) 
    assert expected_points_after == points_after, "Points incorrect after Read a blog"

    # Step5: create a reply to the blog
    @browser.goto blog_url
    reply_content = "Commented by #{@c.users[:regular_user5].name} for Contributor Rating - #{get_timestamp}"
    @convdetail_page.create_reply(des: reply_content)

    # verify the level points updated
    @profile_page.goto_profile
    expected_points_after = points_after + new_points_set_for_read_b + new_points_set_for_comment_b
    points_after = @profile_page.wait_until_contri_rating_points_updated(expected_points_after) 
    assert expected_points_after == points_after, "Points incorrect after Comment on a blog"

    # Step6: login with admin to like the blog
    @login_page.login!(@c.users[:network_admin])
    @browser.goto blog_url
    @browser.wait_until { @convdetail_page.conv_content.present? }
    # admin approve the blog first
    @browser.wait_until { !@convdetail_page.layout_loading_block.present? }
    @convdetail_page.conv_mod_action_approve_btn.when_present.click 
    @browser.wait_until { !@convdetail_page.conv_moderation_alert.present? }
    @browser.refresh # Have to refresh to see Like like because of bug EN-3410
    @browser.wait_until { @convdetail_page.conv_content.present? }
    @convdetail_page.like_root_post
    sleep 1 # sometimes fail without this sleep

    # Step7: login with regular_user5
    @login_page.login!(@c.users[:regular_user5])

    # verify the level points updated
    @profile_page.goto_profile
    expected_points_after = points_after + new_points_set_for_like
    points_after = @profile_page.wait_until_contri_rating_points_updated(expected_points_after) 
    assert expected_points_after == points_after, "Points incorrect after Like a blog"

    # Step8: login with admin to unlike the blog
    @login_page.login!(@c.users[:network_admin])
    @browser.goto blog_url
    @browser.wait_until { @convdetail_page.conv_content.present? }
    @convdetail_page.unlike_root_post
    sleep 1

    # Step9: login with regular_user5
    @login_page.login!(@c.users[:regular_user5])

    # verify the level points updated
    @profile_page.goto_profile
    expected_points_after = points_after - new_points_set_for_like
    points_after = @profile_page.wait_until_contri_rating_points_updated(expected_points_after) 
    assert expected_points_after == points_after, "Points incorrect after Unlike a blog"

    # Step10: admin sets point to default
    @admin_contri_rating_page.start! (:network_admin)
    @admin_contri_rating_page.switch_to_tab(:points_and_ranking)
    @admin_contri_rating_page.set_event_points("Read a blog", points_set_for_read_b)
    @admin_contri_rating_page.set_event_points("Comment on a blog", points_set_for_comment_b)
    @admin_contri_rating_page.set_event_points("Like", points_set_for_like)
    @admin_contri_rating_page.save
  ensure
    @api_actions.remove_user_from_blogger(@config.users[:network_admin], @user_id) unless @user_id.nil?
  end

  user :regular_user5
  p1
  def test_00070_check_promot_ranking_level
    # Step1: login with regular_user5 to check old level points
    # @login_page.login!(@c.users[:regular_user5])
    @profile_page.goto_profile
    points_before = @profile_page.level_points

    # Step2:login with admin to set points for Level 4 = old level points + points for Read a question
    @login_page.login!(@c.users[:network_admin])
    @admin_contri_rating_page.navigate_in
    @admin_contri_rating_page.switch_to_tab(:points_and_ranking)

    points_set_for_read_q = @admin_contri_rating_page.event_points("Read a question")
    points_set_for_level_1 = @admin_contri_rating_page.level_points("Level 1")
    points_set_for_level_2 = @admin_contri_rating_page.level_points("Level 2")
    points_set_for_level_3 = @admin_contri_rating_page.level_points("Level 3")
    points_set_for_level_4 = @admin_contri_rating_page.level_points("Level 4")
    points_set_for_level_5 = @admin_contri_rating_page.level_points("Level 5")

    new_points_set_for_level_4 = points_before + points_set_for_read_q

    # make sure level points for Level 5 is greater than Level 4
    if points_set_for_level_5 <= new_points_set_for_level_4
      @admin_contri_rating_page.set_level_points("Level 5", new_points_set_for_level_4 * 10) 
      points_set_for_level_5 = new_points_set_for_level_4 * 10
    end 

    # make sure level points for lower levels are less than level 4
    if points_set_for_level_3 >= new_points_set_for_level_4
      new_points_set_for_level_3 = new_points_set_for_level_4 / 2
      @admin_contri_rating_page.set_level_points("Level 3", new_points_set_for_level_3)
      if points_set_for_level_2 >= new_points_set_for_level_3
        new_points_set_for_level_2 = new_points_set_for_level_3 / 2
        @admin_contri_rating_page.set_level_points("Level 2", new_points_set_for_level_2)

        if points_set_for_level_1 >= new_points_set_for_level_2
          new_points_set_for_level_1 = new_points_set_for_level_2 / 2
          @admin_contri_rating_page.set_level_points("Level 1", new_points_set_for_level_1)
        end
      end 
    end  

    @admin_contri_rating_page.set_level_points("Level 4", new_points_set_for_level_4)
    @admin_contri_rating_page.save

    # Step3: login with regular_user5 to read a question
    @login_page.login!(@c.users[:regular_user5])

    @topicdetail_page = @topiclist_page.go_to_topic("A Watir Topic")
    @topicdetail_page.goto_conversation(type: :question, title: nil)
    question_url = @browser.url

    # verify the points level is promoted to Level 4
    @profile_page.goto_profile
    expected_points_after = points_before + points_set_for_read_q
    points_after = @profile_page.wait_until_contri_rating_points_updated(expected_points_after) 
    assert expected_points_after == points_after, "Points incorrect after Read a question"
    assert @profile_page.contri_current_level == "Level 4"

    # verify the level info popover is displayed correctly for mid level
    @browser.wait_until { @profile_page.contri_level_progress.level_progress.present? }
    assert @profile_page.contri_level_progress.level_progress.present?
    assert !@profile_page.contri_level_progress.level_max.present?
    assert @profile_page.contri_level_progress.total_points == points_after
    assert @profile_page.contri_level_progress.current_level.text == "Level 4"
    points_to_next_level = @profile_page.contri_level_progress.points_to_next_level.text
    assert points_to_next_level.match(/^([0-9,.]+) /)[1].gsub(/[,.]/,'').to_i == points_set_for_level_5-new_points_set_for_level_4

    # Step4: login with admin to set points for Level 5 = current points + points for Read a question
    @login_page.login!(@c.users[:network_admin])

    @admin_contri_rating_page.navigate_in
    @admin_contri_rating_page.switch_to_tab(:points_and_ranking)
    new_points_set_for_level_5 = new_points_set_for_level_4 + 1
    @admin_contri_rating_page.set_level_points("Level 5", new_points_set_for_level_5)
    @admin_contri_rating_page.save

    # Step5: login with regular_user5 to read the question again
    @login_page.login!(@c.users[:regular_user5])
    @browser.goto question_url
    @browser.wait_until { @convdetail_page.conv_content.present? }

    # verify the points level is promoted to Level 5
    @profile_page.goto_profile
    expected_points_after = points_after + points_set_for_read_q
    points_after = @profile_page.wait_until_contri_rating_points_updated(expected_points_after) 
    assert expected_points_after == points_after, "Points incorrect after Read a question"
    assert @profile_page.contri_current_level == "Level 5"

    # verify the level info popover is displayed correctly for max level
    @browser.wait_until { @profile_page.contri_level_progress.level_max.present? }
    assert !@profile_page.contri_level_progress.level_progress.present?
    assert @profile_page.contri_level_progress.level_max.present?
    assert @profile_page.contri_level_progress.total_points == points_after
    assert @profile_page.contri_level_progress.max_level.text == "Level 5"

    # verify contributor setting info displayed in a new window after click learnmore link
    @browser.wait_until { !@profile_page.layout_loading_block.present? && !@profile_page.layout_loading_spinner.present?}
    @profile_page.scroll_to_element @profile_page.contri_level_progress.learnmore_link
    sleep 1
    @browser.execute_script("window.scrollTo(0, 500)")
    @profile_page.contri_level_progress.learnmore_link.when_present.click
 
    @browser.window(:url => /contributor_settings/).when_present.use do
      @browser.wait_until { @profile_page.profile_level_learnmore_psettings.present? }
      @browser.wait_until { @profile_page.profile_level_learnmore_lsettings.present? }
      assert @profile_page.profile_level_learnmore_psettings.present?
      assert @profile_page.profile_level_learnmore_lsettings.present?
      @browser.window.close
    end

    # Step6: login with admin to increase points for Level 5 greater than current points
    @login_page.login!(@c.users[:network_admin])

    @admin_contri_rating_page.navigate_in
    @admin_contri_rating_page.switch_to_tab(:points_and_ranking)
    new_points_set_for_level_5 += 1
    @admin_contri_rating_page.set_level_points("Level 5", new_points_set_for_level_5)
    @admin_contri_rating_page.save

    # Step7: login with regular_user5 to verify the level is decreased to Level 4
    @login_page.login!(@c.users[:regular_user5])
    # go to profile page to check the level points updated
    @profile_page.goto_profile
    assert @profile_page.contri_current_level == "Level 4"

    # Step8: admin restore the old level settings
    @admin_contri_rating_page.start! (:network_admin)
    @admin_contri_rating_page.switch_to_tab(:points_and_ranking)
    @admin_contri_rating_page.set_level_points("Level 4", points_set_for_level_4)
    @admin_contri_rating_page.set_level_points("Level 5", points_set_for_level_5)
  end

  user :network_admin
  p1
  def test_00080_check_points_after_delete_root_post
    @admin_contri_rating_page.switch_to_tab(:points_and_ranking)

    points_set_for_post_q = @admin_contri_rating_page.event_points("Post a question")
    points_set_for_read_q = @admin_contri_rating_page.event_points("Read a question")
    points_set_for_answer_q = @admin_contri_rating_page.event_points("Answer a question")
    points_set_for_like = @admin_contri_rating_page.event_points("Like")

    @login_page.logout!
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
    @convdetail_page.like_root_post
    reply_desc = "Answer posted by Watir - #{get_timestamp}"
    @convdetail_page.create_reply(des: reply_desc)

    # verify the level points updated
    @profile_page.goto_profile
    expected_points_after = points_before + points_set_for_post_q + points_set_for_read_q + 
                            points_set_for_like + points_set_for_answer_q
    points_after = @profile_page.wait_until_contri_rating_points_updated(expected_points_after) 
    assert expected_points_after == points_after, "Points incorrect after Post a question"
    
    # Step3: delete the question
    @browser.goto question_url
    @browser.wait_until { @convdetail_page.convdetail.present? }
    @convdetail_page.delete_conversation

    # verify the level points updated:
    # points for replies won't be decreased after delete root post
    @profile_page.goto_profile
    expected_points_after = points_after + points_set_for_read_q - points_set_for_post_q
    points_after = @profile_page.wait_until_contri_rating_points_updated(expected_points_after) 
    assert expected_points_after == points_after, "Points incorrect after delete a question"
  end   
end