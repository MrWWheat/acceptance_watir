require 'watir_test'
require 'pages/community/login'
require 'pages/community/profile'
require 'pages/community/topicdetail'
require 'pages/community/topic_list'
require 'pages/community/notification'
require 'pages/community/conversationdetail'
require 'pages/community/admin_permissions'
require 'actions/community/api'

class NotificationTest < WatirTest
  def setup
    super
    @notification_page = Pages::Community::Notification.new(@config)
    @topicdetail_page = Pages::Community::TopicDetail.new(@config)
    @convdetail_page = Pages::Community::ConversationDetail.new(@config)
    @login_page = Pages::Community::Login.new(@config)
    @profile_page = Pages::Community::Profile.new(@config)
    @about_page = Pages::Community::About.new(@config)
    @topiclist_page = Pages::Community::TopicList.new(@config)
    @api_actions = Actions::CommunityAPI.new(@config)

    @name_nfuser1 = @config.users[:nf_regular_user1].name
    @name_nfuser2 = @config.users[:nf_regular_user2].name
    @name_user1 = @config.users[:regular_user1].name
    @name_topic_admin = @config.users[:nf_topic_admin].name


    @topic_for_notification_test = 'A Watir Topic For Notification'
    # assigning @current_page helps error reporting
    #  give good contextual data
    @current_page = @login_page
    puts "[[[ #{name} ::: #{user_for_test} ]]]" if @config.verbose?
    @browser = @config.browser

    @notification_page.start!(user_for_test)
  end

  def teardown
    super
  end

  user :anonymous
  p1

  #============ ANON USER TESTS ==========================#
  #=================================================================#

  #======== login page, log in with username or email, register, social login, etc. tests ============#
  def test_00010_check_no_notification_for_anon
    @notification_page.check_no_notification_for_anon
    assert !@notification_page.notification.present?
  end

#============ REGULAR USER TESTS ==========================#

  user :nf_topic_admin
  def test_00020_check_notification_present
    @notification_page.check_notification
    assert @notification_page.notification.present?

    @notification_page.check_notification_bell
    assert @notification_page.notification_bell.present?

    @notification_page.check_notification_count
    assert @notification_page.notification_count.present?
  end

  def test_00040_check_notification_dropdown
    # invoke notification popup
    @notification_page.click_notification_for_dropdown
    @browser.wait_until { @notification_page.notification_dp_open.present? }
    assert @notification_page.notification_dp_open.present?

    # verify the title in notification popup as Notifications
    @notification_page.check_notification_dp_label
    assert @notification_page.notification_dp_label.present?

    # verify the row content format for the items in notification popup
    @notification_page.wait_until_dp_row_present
    assert @notification_page.notification_dp_row.present?
    assert @notification_page.notification_dp_row_txt.present?
    assert @notification_page.notification_dp_row_date.present?

    # verify "Mark All Read" link available
    @browser.wait_until { @notification_page.notification_dp_read_all.present? }
    assert @notification_page.notification_dp_read_all.present?

    # verify "View All" link available
    @browser.wait_until { @notification_page.notification_dp_view_all.present? }
    assert @notification_page.notification_dp_view_all.present?
  end

  # This case is combined into test_00100_XXX below
  # def test_00050_check_user_img_in_notification_dp
  #   # click on the user image will navigate user to the related converstation detail page
  #   @notification_page.check_notification_dp_user_img
  #   assert @convdetail_page.root_post.present? || @convdetail_page.convdetail.present?
  # end

  p1
  def test_00091_click_view_all_in_notification_dp
    @notification_page.click_view_all_in_notification_dp 
    assert @notification_page.notification_pg.present?
  end

  user :nf_topic_admin
  def test_00100_goto_conv_detail_from_notification
    # go to the specific topic
    @topiclist_page = Pages::Community::TopicList.new(@config)
    @topicdetail_page = @topiclist_page.go_to_topic(@topic_for_notification_test)

    # open the first existing blog created by admin user
    @topicdetail_page.goto_conversation(type: :blog)
    title = @convdetail_page.conv_title.text

    @convdetail_page.follow_root_post

    convdetail_url = @browser.url

    # logout
    @login_page.logout!

    # login with admin user who created the blog
    @login_page.about_login("nf_regular_user2", "logged")

    # go to the specific topic
    @topiclist_page = Pages::Community::TopicList.new(@config)
    @topicdetail_page = @topiclist_page.go_to_topic(@topic_for_notification_test)

    # open the first existing blog created by admin user
    @browser.goto convdetail_url
    @browser.wait_until { @convdetail_page.conv_content.present? }
    title = @convdetail_page.conv_title.when_present.text

    # create a reply to the blog
    @convdetail_page.accept_policy_warning # ui overlapped sometimes
    reply = "Reply on root posted by #{@config.users[:nf_regular_user2].name} - #{get_timestamp}"
    @convdetail_page.reply_box.when_present.focus
    @browser.wait_until { @convdetail_page.reply_submit.present? }
    @convdetail_page.reply_box.when_present.set reply
    @convdetail_page.reply_submit_button.when_present.click
    @browser.wait_until { !@convdetail_page.spinner.present? }
    @convdetail_page.sort_comments(by: :newest)
    @browser.wait_until { @convdetail_page.conv_reply_input.present? }

    # logout
    @login_page.logout!

    # login with admin user who created the blog
    @login_page.about_login("nf_topic_admin", "logged")

    # click notification popup
    @notification_page.notification.when_present.click
    @browser.wait_until { @notification_page.notification_panel_footer.present? }

    # open the first notification item
    @notification_page.notification_dp_row.when_present.click

    # verify the conversation title is the same as before
    @browser.wait_until { @convdetail_page.convdetail.present? }
    @browser.wait_until { @convdetail_page.convdetail.text =~ /#{title}/ }
    assert @convdetail_page.convdetail.text =~ /#{title}/

    # click on the user image will navigate user to the related converstation detail page
    @notification_page.check_notification_dp_user_img
    assert @convdetail_page.root_post.present? || @convdetail_page.convdetail.present?
  end

  user :nf_topic_admin
  def test_00110_goto_notification_detail
    @notification_page.goto_notification_detail_pg
    assert @notification_page.notification_pg.present? 
    #assert @notification.notification_pg_block.present? 
    assert @notification_page.notification_pg_row.present? 
    assert @notification_page.notification_pg_read_all.present? 
  end

  def test_00120_check_notification_pg_title
    @notification_page.check_notification_detail_pg_title
    assert @notification_page.notification_pg_title.present?
  end

  def test_00130_check_row_in_notification_pg
    @notification_page.check_notification_detail_row
    assert @notification_page.notification_pg_row.present?
  end

  def test_00140_check_user_img_in_notification_pg
    @notification_page.check_notification_detail_user_img
    assert @notification_page.notification_pg_row_img.present?
  end

  def test_00150_check_user_link_in_notification_pg
    @notification_page.check_notification_detail_user_link
    assert @profile_page.profile_page.present?
  end

  def test_00160_check_topic_link_in_notification_pg
    @notification_page.check_notification_detail_topic_link
  end

  def test_00170_check_show_more_in_notification_pg
    @notification_page.check_notification_detail_show_more
    assert (@notification_page.notification_pg_row.present?) || ( !@notification_page.notification_pg_show_all.present?)
  end

  def test_00180_post_comment_highlevel_notification
    @notification_page.post_comment_highlevel_notification
  end

  def test_00190_stop_highlevel_notification
    @notification_page.stop_highlevel_notification
  end

  def test_00200_check_aggregated_like_notification
    @notification_page.check_aggregated_like_notification
  end

  user :nf_regular_user1
  def test_00210_check_featured_post_notification
   @notification_page.check_featured_post_notification
  end

  # only run blogger notification test when 1605_blogger is GAed. not GAed as of 1611
  user :nf_topic_admin
  def xtest_00220_check_blogger_notification
   @notification_page.check_blogger_notification
  end

  user :nf_regular_user1
  def test_00230_check_aggregated_like_reply
    # step 1: user1 create a reply to the conv
    conv_title = "Question for aggregated like reply notification - #{get_timestamp}"
    conv_desc = "details for aggregated like reply notification - #{get_timestamp}"
    reply_text = "Create a answer by user1 - #{get_timestamp}"
    conv_url = @convdetail_page.create_new_conv_and_reply_for_specific_topic(reply_text: reply_text, 
                                                                             conv_title: conv_title, 
                                                                             conv_desc: conv_desc, 
                                                                             conv_type: :question, 
                                                                             topic_title: @topic_for_notification_test)
    @login_page.logout!

    # step 2: user2 like this reply
    @about_page.about_login(:nf_regular_user2, 'logged')
    @convdetail_page.user_check_post_by_url(conv_url)
    @convdetail_page.like_reply(post_name: reply_text)

    # step 3: check user1's notifications
    act1 = @notification_page.get_first_popup_notification_text(user: :nf_regular_user1)
    exp1 = "#{@name_nfuser2} liked your post: \"#{reply_text}\""
    assert_equal_case_insensitive exp1, act1

    # step 4: user1 like this reply
    @notification_page.check_notification_count
    assert @notification_page.notification_count.present?
    @notification_page.click_notification_for_dropdown

    @convdetail_page.user_check_post_by_url(conv_url)
    @convdetail_page.like_reply(post_name: reply_text)

    # step 5: refresh and check user1's notificaitons
    @browser.refresh
    act2 = @notification_page.get_first_popup_notification_text
    exp2 = "#@name_nfuser2 and #@name_nfuser1 liked your post: \"#{reply_text}\""
    assert_equal_case_insensitive exp2, act2

    # step 6: user3 like this reply
    @about_page.about_login(:regular_user1, 'logged')
    @convdetail_page.user_check_post_by_url(conv_url)
    @convdetail_page.like_reply(post_name: reply_text)

    # step 7: check user1's notifications
    act3 = @notification_page.get_first_popup_notification_text(user: :nf_regular_user1)
    exp3 = "#@name_nfuser2 , #@name_nfuser1 and 1 other(s) liked your post: \"#{reply_text}\""
    assert_equal_case_insensitive exp3, act3
  end

  user :nf_regular_user1
  def test_00240_check_aggregated_like_conversation
    # step 1: user1 create a conv
    conv_title = "Question for aggregated like reply notification - #{get_timestamp}"
    conv_desc = "details for aggregated like reply notification - #{get_timestamp}"
    reply_text = "Create a answer by user1 - #{get_timestamp}"
    conv_url = @convdetail_page.create_new_conv_for_specific_topic(conv_title: conv_title, 
                                                                   conv_desc: conv_desc)
    @login_page.logout!

    # step 2: user2 like this conv
    @about_page.about_login(:nf_regular_user2, 'logged')
    @convdetail_page.user_check_post_by_url(conv_url)
    @convdetail_page.like_conversation

    # step 3: check user1's notificaiton
    act1 = @notification_page.get_first_popup_notification_text(user: :nf_regular_user1)
    exp1 = "#@name_nfuser2 liked your post: \"#{conv_title}\""
    assert_equal_case_insensitive exp1, act1

    # step 4: user1 like his conv
    @notification_page.check_notification_count
    assert @notification_page.notification_count.present?
    @notification_page.click_notification_for_dropdown

    @convdetail_page.user_check_post_by_url(conv_url)
    @convdetail_page.like_conversation

    # step 5: refresh and check user1's notification
    @browser.refresh
    act2 = @notification_page.get_first_popup_notification_text
    exp2 = "#@name_nfuser2 and #@name_nfuser1 liked your post: \"#{conv_title}\""
    assert_equal_case_insensitive exp2, act2

    # step 6: user3 like this conv
    @about_page.about_login(:regular_user1, 'logged')
    @convdetail_page.user_check_post_by_url(conv_url)
    @convdetail_page.like_conversation

    # step 7: check user1's notification
    act3 = @notification_page.get_first_popup_notification_text(user: :nf_regular_user1)
    exp3 = "#@name_nfuser2 , #@name_nfuser1 and 1 other(s) liked your post: \"#{conv_title}\""
    assert_equal_case_insensitive exp3, act3

    # step 8: user3 unlike the conv
    @about_page.about_login(:regular_user1, 'logged')
    @convdetail_page.user_check_post_by_url(conv_url)
    @convdetail_page.unlike_conversation

    # step 9: check user1's notification
    act4 = @notification_page.get_first_popup_notification_text(user: :nf_regular_user1)
    exp4 = "#@name_nfuser2 and #@name_nfuser1 liked your post: \"#{conv_title}\""
    assert_equal_case_insensitive exp4, act4
  end

  user :network_admin
  def test_00250_check_feature_reply_notification
    # step 1: network_admin create blog
    conv_title = "Blog for featuring reply notification - #{get_timestamp}"
    conv_desc = "details for featuring reply notification - #{get_timestamp}"
    conv_url = @convdetail_page.create_new_conv_for_specific_topic(conv_title: conv_title, 
                                                                   conv_desc: conv_desc, 
                                                                   conv_type: :blog)
    @login_page.logout!

    # step 2: user1 reply it
    @about_page.about_login(:regular_user1, 'logged')
    @convdetail_page.user_check_post_by_url(conv_url)
    reply_text = "Create a blog reply by user2 - #{get_timestamp}"
    @convdetail_page.create_new_reply_for_specific_conv_url(conv_url: conv_url, reply_text: reply_text)

    # step 3: nfuser1 follow this conv
    @about_page.about_login(:nf_regular_user1, 'logged')
    @convdetail_page.user_check_post_by_url(conv_url)
    @convdetail_page.follow_root_post

    # step 4: nfuser2 follow this topic
    @about_page.about_login(:nf_regular_user2, 'logged')
    @topicdetail_page = @topiclist_page.go_to_topic(@topic_for_notification_test)
    @topicdetail_page.unfollow_topic if @topicdetail_page.topic_unfollow_button.present?
    assert @topicdetail_page.topic_follow_button.present?
    @topicdetail_page.follow_topic
    assert @topicdetail_page.topic_unfollow_button.present?

    # step 5: nftopicadmin feature this reply
    @about_page.about_login(:nf_topic_admin, 'logged')
    @convdetail_page.user_check_post_by_url(conv_url)
    @convdetail_page.feature_reply reply_text

    # step 6: check network admin's notification
    act1 = @notification_page.get_first_popup_notification_text(user: :network_admin)
    exp1 = "#@name_topic_admin Featured The Post: \"#{reply_text}\" For #{conv_title}"
    assert_equal_case_insensitive exp1, act1

    # step 7: check user1's notification
    act2 = @notification_page.get_first_popup_notification_text(user: :regular_user1)
    exp2 = "#@name_topic_admin Featured Your Post: \"#{reply_text}\" For #{conv_title}"
    assert_equal_case_insensitive exp2, act2

    # step 8: check nfuser1's notification
    act3 = @notification_page.get_first_popup_notification_text(user: :nf_regular_user1)
    exp3 = "#@name_topic_admin Featured The Post: \"#{reply_text}\" For #{conv_title}"
    assert_equal_case_insensitive exp3, act3

    # step 9: check nfuser2's notification
    act4 = @notification_page.get_first_popup_notification_text(user: :nf_regular_user2)
    exp4 = "#@name_topic_admin Featured The Post: \"#{reply_text}\" For #{conv_title}"
    assert_equal_case_insensitive exp4, act4

  ensure
    # step 10: reset state - nfuser2 unfollow this topic
    @about_page.about_login(:nf_regular_user2, 'logged')
    @topicdetail_page = @topiclist_page.go_to_topic(@topic_for_notification_test)
    @topicdetail_page.unfollow_topic if @topicdetail_page.topic_unfollow_button.present?
    assert @topicdetail_page.topic_follow_button.present?
  end

  def test_00260_check_feature_conversation_notification
    # step 1: network_admin create Question
    conv_title = "Question for featuring conv notification - #{get_timestamp}"
    conv_desc = "details for featuring conv notification - #{get_timestamp}"
    conv_url = @convdetail_page.create_new_conv_for_specific_topic(conv_title: conv_title, 
                                                                   conv_desc: conv_desc)
    @login_page.logout!

    # step 2: user1 unfollow this topic
    @about_page.about_login(:regular_user1, 'logged')
    @topicdetail_page = @topiclist_page.go_to_topic(@topic_for_notification_test)
    @topicdetail_page.unfollow_topic if @topicdetail_page.topic_unfollow_button.present?
    assert @topicdetail_page.topic_follow_button.present?

    # step 3: nfuser1 follow this conv
    @about_page.about_login(:nf_regular_user1, 'logged')
    @convdetail_page.user_check_post_by_url(conv_url)
    @convdetail_page.follow_root_post

    # step 4: nfuser2 follow this topic
    @about_page.about_login(:nf_regular_user2, 'logged')
    @topicdetail_page = @topiclist_page.go_to_topic(@topic_for_notification_test)
    @topicdetail_page.unfollow_topic if @topicdetail_page.topic_unfollow_button.present?
    assert @topicdetail_page.topic_follow_button.present?
    @topicdetail_page.follow_topic
    assert @topicdetail_page.topic_unfollow_button.present?

    # step 5: nftopic_admin feature this conv
    @about_page.about_login(:nf_topic_admin, 'logged')
    @convdetail_page.user_check_post_by_url(conv_url)
    @convdetail_page.feature_root_post

    # step 6: check network admin's notification
    act1 = @notification_page.get_first_popup_notification_text(user: :network_admin)
    exp1 = "#@name_topic_admin Featured Your Post: \"#{conv_title}\""
    assert_equal_case_insensitive exp1, act1

    # step 7: check user1's notification
    act2 = @notification_page.get_first_popup_notification_text(user: :regular_user1)
    exp2 = "#@name_topic_admin Featured A Post \"#{conv_desc.slice(0...50)}\" In #@topic_for_notification_test"
    assert_not_equal_case_insensitive exp2, act2

    # step 8: check nfuser1's notification
    act3 = @notification_page.get_first_popup_notification_text(user: :nf_regular_user1)
    exp3 = "#@name_topic_admin Featured The Post: \"#{conv_title}\""
    assert_equal_case_insensitive exp3, act3

    # step 9: check nfuser2's notification
    act4 = @notification_page.get_first_popup_notification_text(user: :nf_regular_user2)
    exp4 = "#@name_topic_admin Featured A Post \"#{conv_desc.slice(0...50)}\" In #@topic_for_notification_test"
    assert_equal_case_insensitive exp4, act4

  ensure
    # step 10: reset state - nfuser2 unfollow this topic
    @about_page.about_login(:nf_regular_user2, 'logged')
    @topicdetail_page = @topiclist_page.go_to_topic(@topic_for_notification_test)
    @topicdetail_page.unfollow_topic if @topicdetail_page.topic_unfollow_button.present?
    assert @topicdetail_page.topic_follow_button.present?
  end

  def test_00270_check_mark_reply_as_best_answer_notification
    # step 1: network_admin create Question
    conv_title = "Question for marking reply as best answer notification - #{get_timestamp}"
    conv_desc = "details for marking reply as best answer notification - #{get_timestamp}"
    conv_url = @convdetail_page.create_new_conv_for_specific_topic(conv_title: conv_title, 
                                                                   conv_desc: conv_desc)
    
    # step 2: network_admin unfollow this topic and this conv
    @convdetail_page.unfollow_root_post
    @topicdetail_page = @topiclist_page.go_to_topic(@topic_for_notification_test)
    @topicdetail_page.unfollow_topic if @topicdetail_page.topic_unfollow_button.present?
    assert @topicdetail_page.topic_follow_button.present?
    @login_page.logout!

    # step 3: user1 reply it
    @about_page.about_login(:regular_user1, 'logged')
    @convdetail_page.user_check_post_by_url(conv_url)
    reply_text = "Create a answer by user1 - #{get_timestamp}"
    @convdetail_page.create_new_reply_for_specific_conv_url(conv_url: conv_url, reply_text: reply_text)

    # step 3: nfuser1 follow this conv
    @about_page.about_login(:nf_regular_user1, 'logged')
    @convdetail_page.user_check_post_by_url(conv_url)
    @convdetail_page.follow_root_post

    # step 4: nfuser2 follow this topic
    @about_page.about_login(:nf_regular_user2, 'logged')
    @topicdetail_page = @topiclist_page.go_to_topic(@topic_for_notification_test)
    @topicdetail_page.unfollow_topic if @topicdetail_page.topic_unfollow_button.present?
    assert @topicdetail_page.topic_follow_button.present?
    @topicdetail_page.follow_topic
    assert @topicdetail_page.topic_unfollow_button.present?

    # step 5: nftopicadmin feature this reply
    @about_page.about_login(:nf_topic_admin, 'logged')
    @convdetail_page.user_check_post_by_url(conv_url)
    @convdetail_page.feature_reply reply_text

    # step 6: check network admin's notification
    act1 = @notification_page.get_first_popup_notification_text(user: :network_admin)
    exp1 = "#@name_topic_admin Marked The Post #{reply_text} In #@topic_for_notification_test As Best Answer"
    assert_not_equal_case_insensitive exp1, act1

    # step 7: check user1's notification
    act2 = @notification_page.get_first_popup_notification_text(user: :regular_user1)
    exp2 = "#@name_topic_admin Marked Your Post \"#{reply_text}\" As Best Answer For #{conv_title}"
    assert_equal_case_insensitive exp2, act2

    # step 8: check nfuser1's notification
    act3 = @notification_page.get_first_popup_notification_text(user: :nf_regular_user1)
    exp3 = "#@name_topic_admin Marked The Post \"#{reply_text}\" As Best Answer For #{conv_title}"
    assert_equal_case_insensitive exp3, act3

    # step 9: check nfuser2's notification
    act4 = @notification_page.get_first_popup_notification_text(user: :nf_regular_user2)
    exp4 = "#@name_topic_admin Marked The Post #{reply_text} In #@topic_for_notification_test As Best Answer"
    assert_equal_case_insensitive exp4, act4

  ensure
    # step 10: reset state - nfuser2 unfollow this topic
    @about_page.about_login(:nf_regular_user2, 'logged')
    @topicdetail_page = @topiclist_page.go_to_topic(@topic_for_notification_test)
    @topicdetail_page.unfollow_topic if @topicdetail_page.topic_unfollow_button.present?
    assert @topicdetail_page.topic_follow_button.present?
  end

  user :nf_regular_user1
  def test_00280_check_create_depth1_reply_notification
    # step 1: nf_user1 create a conv and a reply
    conv_title = "Question for aggregated like reply notification - #{get_timestamp}"
    conv_desc = "details for aggregated like reply notification - #{get_timestamp}"
    reply_text = "Create a answer by user1 - #{get_timestamp}"
    conv_url = @convdetail_page.create_new_conv_and_reply_for_specific_topic(reply_text: reply_text, 
                                                                             conv_title: conv_title, 
                                                                             conv_desc: conv_desc, 
                                                                             conv_type: :question, 
                                                                             topic_title: @topic_for_notification_test)

    # step 2: check nf_user1's notifications, it should get:
    act1 = @notification_page.get_first_popup_notification_text
    exp1 = "#@name_user1 Replied To My Post: \"#{reply_text}\""
    assert_not_equal_case_insensitive exp1, act1

    # step 3: nfuser2 follow this conv
    @about_page.about_login(:nf_regular_user2, 'logged')
    @convdetail_page.user_check_post_by_url(conv_url)
    @convdetail_page.follow_root_post

    # step 4: user1 create another reply to nf_user1's conv
    @about_page.about_login(:regular_user1, 'logged')
    @convdetail_page.user_check_post_by_url(conv_url)
    reply_text = "Create a blog reply by user1 - #{get_timestamp}"
    @convdetail_page.create_new_reply_for_specific_conv_url(conv_url: conv_url, reply_text: reply_text)

    # step 5: check nf_user1's notification
    act2 = @notification_page.get_first_popup_notification_text(user: :nf_regular_user1)
    exp2 = "#@name_user1 Replied To Your Post: \"#{reply_text}\""
    assert_equal_case_insensitive exp2, act2

    # step 6: check nf_user2's notification
    act3 = @notification_page.get_first_popup_notification_text(user: :nf_regular_user2)
    exp3 = "#@name_user1 Replied To The Post #{conv_title}: \"#{reply_text}\""
    assert_equal_case_insensitive exp3, act3
  ensure
    # step 10: reset state - nfuser2 unfollow this topic
    @about_page.about_login(:nf_regular_user1, 'logged')
    @topicdetail_page = @topiclist_page.go_to_topic(@topic_for_notification_test)
    @topicdetail_page.unfollow_topic if @topicdetail_page.topic_unfollow_button.present?
    assert @topicdetail_page.topic_follow_button.present?
  end

  def test_00290_check_create_depth2_reply_notification
    # step 1: nf_user1 create a conv and a reply
    conv_title = "Question for aggregated like reply notification - #{get_timestamp}"
    conv_desc = "details for aggregated like reply notification - #{get_timestamp}"
    reply_text = "Create a answer by nfuser1 - #{get_timestamp}"
    conv_url = @convdetail_page.create_new_conv_and_reply_for_specific_topic(reply_text: reply_text, 
                                                                             conv_title: conv_title, 
                                                                             conv_desc: conv_desc, 
                                                                             conv_type: :question, 
                                                                             topic_title: @topic_for_notification_test)

    # step 2: nf_user2 response nf_user1'reply
    @about_page.about_login(:nf_regular_user2, 'logged')
    depth2_reply_text = "Create a depth2 answer by nfuser1 - #{get_timestamp}"
    @convdetail_page.create_new_child_reply_for_specific_conv_and_parent_reply(conv_url: conv_url, parent_reply_text: reply_text, reply_text: depth2_reply_text)

    # step 3: check nf_user1's notification
    act1 = @notification_page.get_first_popup_notification_text(user: :nf_regular_user1)
    exp1 = "#@name_nfuser2 Replied To Your Post: \"#{depth2_reply_text.slice(0...50)}\""
    assert_equal_case_insensitive exp1, act1
  end

  user :network_admin
  def test_00300_check_create_new_convs_notification
    # step 1: network_admin create a topic
    random_num = rand.to_s[2..10]
    @topic_for_creating_new_convs_Nt = "notification-for-new-convs-#{random_num}"
    desc = "topic detail for notification with creating new convs - #{get_timestamp}"
    topic_uuid = @api_actions.create_topic(@config.users[:network_admin], @topic_for_creating_new_convs_Nt, desc, 'engagement')
    @api_actions.activate_topic(@config.users[:network_admin], topic_uuid)
    topic_link = @config.base_url + "/topic/#{topic_uuid}/#{@config.slug}/#@topic_for_creating_new_convs_Nt"
    @login_page.logout!

    # step 2: nfuser2 follow this topic
    @about_page.about_login(:nf_regular_user2, 'logged')
    @topicdetail_page = @topiclist_page.go_to_topic_by_url topic_link
    @topicdetail_page.unfollow_topic if @topicdetail_page.topic_unfollow_button.present?
    @browser.wait_until { @topicdetail_page.topic_follow_button.present? }
    @topicdetail_page.follow_topic
    @browser.wait_until { @topicdetail_page.topic_unfollow_button.present? }

    # step 3: user1 create a conv
    @about_page.about_login(:regular_user1, 'logged')
    conv_title = "Create new conv for testing notification - #{get_timestamp}"
    conv_desc = "details for testing notification - #{get_timestamp}"
    conv_url = @convdetail_page.create_new_conv_for_specific_topic(conv_title: conv_title, 
                                                                   conv_desc: conv_desc,
                                                                   conv_type: :question,
                                                                   topic_title: nil,
                                                                   topic_link: topic_link)


    # step 4: check network admin's notifications
    act1 = @notification_page.get_first_popup_notification_text user: :network_admin
    exp1 = "#@name_user1 Posted A New Conversation In #@topic_for_creating_new_convs_Nt: \"#{conv_title}\""
    assert_not_equal_case_insensitive exp1, act1

    # step 5: check nfuser2's notifications
    act2, act3 = @notification_page.get_first_two_popup_notifications_text user: :nf_regular_user2
    exp2 = "#@name_user1 Posted A New Conversation In #@topic_for_creating_new_convs_Nt: \"#{conv_title}\""
    assert_equal_case_insensitive exp2, act2
    new_convs_msg = /there (is|are) \d+ new conversation(s)?/i
    assert_match new_convs_msg, act3.downcase
    assert act3.downcase.include? @topic_for_creating_new_convs_Nt

    # step 6: check user1's notifications
    act4 = @notification_page.get_first_popup_notification_text user: :regular_user1
    exp4 = "#@name_user1 Posted A New Conversation In #@topic_for_creating_new_convs_Nt: \"#{conv_title}\""
    assert_not_equal_case_insensitive exp1, act1

    # step 7: nfuser2 unfollow this topic and check notifications
    @about_page.about_login(:nf_regular_user2, 'logged')
    @topicdetail_page = @topiclist_page.go_to_topic_by_url topic_link
    @topicdetail_page.unfollow_topic if @topicdetail_page.topic_unfollow_button.present?
    assert @topicdetail_page.topic_follow_button.present?

    @browser.refresh
    act5, act6 = @notification_page.get_first_two_popup_notifications_text
    exp5 = "#@name_user1 Posted A New Conversation In #@topic_for_creating_new_convs_Nt: \"#{conv_title}\""
    assert_equal_case_insensitive exp5, act5
    # should not have this notification
    assert_nil new_convs_msg =~ act6.downcase

    # step 8: nfuser2 follow this topic and check notifications
    @browser.refresh
    @topicdetail_page.unfollow_topic if @topicdetail_page.topic_unfollow_button.present?
    @browser.wait_until { @topicdetail_page.topic_follow_button.present? }
    @topicdetail_page.follow_topic
    @browser.wait_until { @topicdetail_page.topic_unfollow_button.present? }

    @browser.refresh
    act7, act8 = @notification_page.get_first_two_popup_notifications_text
    exp8 = "#@name_user1 Posted A New Conversation In #@topic_for_creating_new_convs_Nt: \"#{conv_title}\""
    assert_equal_case_insensitive exp8, act8
    # should have this notification
    assert_match new_convs_msg, act7.downcase

    # step 9: nfuser2 mark this notification as read
    @notification_page.mark_first_popup_notification_as_read

    @browser.refresh
    act9 = @notification_page.get_first_popup_notification_text user: :nf_regular_user2
    exp9 = "#@name_user1 Posted A New Conversation In #@topic_for_creating_new_convs_Nt: \"#{conv_title}\""
    assert_equal_case_insensitive exp9, act9

    # step 10: user1 delete this conv
    @about_page.about_login(:regular_user1, 'logged')
    @convdetail_page.user_check_post_by_url(conv_url)
    @convdetail_page.delete_conversation

    # step 11: nfuser2 check notifications
    act10 = @notification_page.get_first_popup_notification_text user: :nf_regular_user2
    exp10 = "#@name_user1 Posted A New Conversation In #@topic_for_creating_new_convs_Nt: \"#{conv_title}\""
    assert_not_equal_case_insensitive exp10, act10

  ensure
    @api_actions.unfollow_topic(@config.users[:nf_regular_user2], topic_uuid) unless topic_uuid.nil?
    @api_actions.unfollow_topic(@config.users[:regular_user1], topic_uuid) unless topic_uuid.nil?
    @api_actions.delete_topic(@config.users[:network_admin], topic_uuid) unless topic_uuid.nil?
  end

  user :network_admin
  def test_00310_check_stop_notification
    # step 1: network_admin create a topic
    random_num = rand.to_s[2..10]
    @topic_for_creating_new_convs_Nt = "notification-for-new-convs-#{random_num}"
    desc = "topic detail for notification with creating new convs - #{get_timestamp}"
    topic_uuid = @api_actions.create_topic(@config.users[:network_admin], @topic_for_creating_new_convs_Nt, desc, 'engagement')
    @api_actions.activate_topic(@config.users[:network_admin], topic_uuid)
    topic_link = @config.base_url + "/topic/#{topic_uuid}/#{@config.slug}/#@topic_for_creating_new_convs_Nt"
    @login_page.logout!

    # step 2: nfuser2 follow this topic
    @about_page.about_login(:nf_regular_user2, 'logged')
    @topicdetail_page = @topiclist_page.go_to_topic_by_url topic_link
    @topicdetail_page.unfollow_topic if @topicdetail_page.topic_unfollow_button.present?
    @browser.wait_until { @topicdetail_page.topic_follow_button.present? }
    @topicdetail_page.follow_topic
    @browser.wait_until { @topicdetail_page.topic_unfollow_button.present? }

    # step 3: user1 create a conv
    @about_page.about_login(:regular_user1, 'logged')
    conv_title = "Create new conv for testing notification - #{get_timestamp}"
    conv_desc = "details for testing notification - #{get_timestamp}"
    conv_url = @convdetail_page.create_new_conv_for_specific_topic(conv_title: conv_title, 
                                                                   conv_desc: conv_desc,
                                                                   conv_type: :question,
                                                                   topic_title: nil,
                                                                   topic_link: topic_link)
    # step 4: check nfuser2's notifications
    act2, act3 = @notification_page.get_first_two_popup_notifications_text user: :nf_regular_user2
    exp2 = "#@name_user1 Posted A New Conversation In #@topic_for_creating_new_convs_Nt: \"#{conv_title}\""
    assert_equal_case_insensitive exp2, act2
    new_convs_msg = /there (is|are) \d+ new conversation(s)?/i
    assert_match new_convs_msg, act3.downcase
    assert act3.downcase.include? @topic_for_creating_new_convs_Nt

    # step 5: nfuser2 reply it
    @convdetail_page.user_check_post_by_url(conv_url)
    reply_text = "Create a blog reply by user2 - #{get_timestamp}"
    @convdetail_page.create_new_reply_for_specific_conv_url(conv_url: conv_url, reply_text: reply_text)

    # step 6: check user1's notification
    act2 = @notification_page.get_first_popup_notification_text(user: :regular_user1)
    exp2 = "#@name_nfuser2 Replied To Your Post: \"#{reply_text}\""
    assert_equal_case_insensitive exp2, act2

    # step 7: nfuser2 like this conv
    @about_page.about_login(:nf_regular_user2, 'logged')
    @convdetail_page.user_check_post_by_url(conv_url)
    @convdetail_page.like_conversation

    # step 8: check user1's notificaiton
    act1 = @notification_page.get_first_popup_notification_text(user: :regular_user1)
    exp1 = "#@name_nfuser2 liked your post: \"#{conv_title}\""
    assert_equal_case_insensitive exp1, act1

    # step 9: user1 feature this reply
    @convdetail_page.user_check_post_by_url(conv_url)
    @convdetail_page.feature_reply reply_text

    # step 10: check nfuser2's notification
    act2 = @notification_page.get_first_popup_notification_text(user: :nf_regular_user2)
    exp2 = "#@name_user1 Marked Your Post \"#{reply_text}\" As Best Answer For #{conv_title}"
    assert_equal_case_insensitive exp2, act2

    # step 11: nftopic_admin feature this conv
    @about_page.about_login(:network_admin, 'logged')
    @convdetail_page.user_check_post_by_url(conv_url)
    @convdetail_page.feature_root_post

    # step 12: check nfuser2's notification
    act4 = @notification_page.get_first_popup_notification_text(user: :nf_regular_user2)
    @name_admin = @config.users[:network_admin].name
    exp4 = "#@name_admin Featured The Post: \"#{conv_title}\""
    assert_equal_case_insensitive exp4, act4
  end

  user :nf_regular_user1
  def test_00320_check_stop_conversation_msg
    # step 1: user1 create a conv
    conv_title = "Question for aggregated like reply notification - #{get_timestamp}"
    conv_desc = "details for aggregated like reply notification - #{get_timestamp}"
    conv_url = @convdetail_page.create_new_conv_for_specific_topic(conv_title: conv_title, 
                                                                   conv_desc: conv_desc)
    @login_page.logout!

    # step 2: nfuser2 reply it
    @about_page.about_login(:nf_regular_user2, 'logged')
    @convdetail_page.user_check_post_by_url(conv_url)
    reply_text = "Create a blog reply by user2 - #{get_timestamp}"
    @convdetail_page.create_new_reply_for_specific_conv_url(conv_url: conv_url, reply_text: reply_text)

    # step 3: user1 response nfuser2'reply
    @about_page.about_login(:nf_regular_user1, 'logged')
    depth2_reply_text = "Create a depth2 answer by nfuser1 - #{get_timestamp}"
    @convdetail_page.create_new_child_reply_for_specific_conv_and_parent_reply(conv_url: conv_url, parent_reply_text: reply_text, reply_text: depth2_reply_text)

    # step 4: check nfuser2's notification
    act1 = @notification_page.get_first_popup_notification_text(user: :nf_regular_user2)
    exp1 = "#@name_nfuser1 Replied To Your Post: \"#{depth2_reply_text.slice(0...50)}\""
    assert_equal_case_insensitive exp1, act1

  end

  user :network_admin
  def test_00330_check_reply_to_reply_notification
    # step 1: network_admin create Question
    conv_title = "Question for marking reply as best answer notification - #{get_timestamp}"
    conv_desc = "details for marking reply as best answer notification - #{get_timestamp}"
    conv_url = @convdetail_page.create_new_conv_for_specific_topic(conv_title: conv_title, 
                                                                   conv_desc: conv_desc)

    # step 2: user1 reply it
    @about_page.about_login(:nf_regular_user1, 'logged')
    @convdetail_page.user_check_post_by_url(conv_url)
    reply_text = "Create a blog reply by user1 - #{get_timestamp}"
    @convdetail_page.create_new_reply_for_specific_conv_url(conv_url: conv_url, reply_text: reply_text)

    # step 3: user2 response user1'reply
    @about_page.about_login(:nf_regular_user2, 'logged')
    depth2_reply_text = "Create a depth2 answer by user2 - #{get_timestamp}"
    @convdetail_page.create_new_child_reply_for_specific_conv_and_parent_reply(conv_url: conv_url, parent_reply_text: reply_text, reply_text: depth2_reply_text)

    # step 4: user3 response user2'reply
    @about_page.about_login(:regular_user1, 'logged')
    depth3_reply_text = "Create a depth3 answer by user3 - #{get_timestamp}"
    @convdetail_page.create_new_child_reply_for_specific_conv_and_specific_reply(conv_url: conv_url, parent_reply_text: depth2_reply_text, reply_text: depth3_reply_text, level: 2)

    # step 5: check user1's notification
    act4, act5 = @notification_page.get_first_two_popup_notifications_text user: :nf_regular_user1
    exp5 = "#@name_nfuser2 Replied To Your Post: \"#{depth2_reply_text.slice(0...50)}\""
    assert_equal_case_insensitive exp5, act5

    exp4 = "#@name_user1 Replied To The Post #{conv_title}: \"#{depth3_reply_text.slice(0...50)}\""
    assert_equal_case_insensitive exp4, act4

    # step 6: check user2's notification
    act1 = @notification_page.get_first_popup_notification_text(user: :nf_regular_user2)
    exp1 = "#@name_user1 Replied To Your Post: \"#{depth3_reply_text.slice(0...50)}\""
    assert_equal_case_insensitive exp1, act1

    # step 7: user1 unfollow this topic
    @about_page.about_login(:nf_regular_user1, 'logged')
    @convdetail_page.user_check_post_by_url(conv_url)
    @convdetail_page.unfollow_root_post
    
    # step 8: user3 response user2'reply
    @about_page.about_login(:regular_user1, 'logged')
    depth4_reply_text = "Create a depth4 answer by user3 - #{get_timestamp}"
    @convdetail_page.create_new_child_reply_for_specific_conv_and_specific_reply(conv_url: conv_url, parent_reply_text: depth2_reply_text, reply_text: depth4_reply_text, level: 2)

    # step 9: check user1's notification
    act6 = @notification_page.get_first_popup_notification_text(user: :nf_regular_user1)
    exp6 = "#@name_user1 Replied To The Post #{conv_title}: \"#{depth4_reply_text.slice(0...50)}\""
    assert_not_equal_case_insensitive exp6, act6

  end

  user :network_admin
  def test_00340_check_reply_to_reply_parent_notification
    # step 1: network_admin create Question
    conv_title = "Question for marking reply as best answer notification - #{get_timestamp}"
    conv_desc = "details for marking reply as best answer notification - #{get_timestamp}"
    conv_url = @convdetail_page.create_new_conv_for_specific_topic(conv_title: conv_title, 
                                                                   conv_desc: conv_desc)

    # step 2: user1 reply it
    @about_page.about_login(:nf_regular_user1, 'logged')
    @convdetail_page.user_check_post_by_url(conv_url)
    reply_text = "Create a blog reply by user1 - #{get_timestamp}"
    @convdetail_page.create_new_reply_for_specific_conv_url(conv_url: conv_url, reply_text: reply_text)

    # step 3: user2 response user1'reply
    @about_page.about_login(:nf_regular_user2, 'logged')
    depth2_reply_text = "Create a depth2 answer by user2 - #{get_timestamp}"
    @convdetail_page.create_new_child_reply_for_specific_conv_and_parent_reply(conv_url: conv_url, parent_reply_text: reply_text, reply_text: depth2_reply_text)

    # step 4: user3 response user1'reply
    @about_page.about_login(:regular_user1, 'logged')
    depth3_reply_text = "Create a depth3 answer by user3 - #{get_timestamp}"
    @convdetail_page.create_new_child_reply_for_specific_conv_and_parent_reply(conv_url: conv_url, parent_reply_text: reply_text, reply_text: depth3_reply_text)

    # step 5: check user1's notification
    act4, act5 = @notification_page.get_first_two_popup_notifications_text user: :nf_regular_user1
    exp5 = "#@name_nfuser2 Replied To Your Post: \"#{depth2_reply_text.slice(0...50)}\""
    assert_equal_case_insensitive exp5, act5

    exp4 = "#@name_user1 Replied To Your Post: \"#{depth3_reply_text.slice(0...50)}\""
    assert_equal_case_insensitive exp4, act4

    # step 6: check user2's notification
    act6 = @notification_page.get_first_popup_notification_text(user: :nf_regular_user2)
    exp6 = "#@name_user1 Replied To The Post #{conv_title}: \"#{depth3_reply_text.slice(0...50)}\""
    assert_not_equal_case_insensitive exp6, act6

    # step 7: user2 follow this conv
    @about_page.about_login(:nf_regular_user2, 'logged')
    @convdetail_page.user_check_post_by_url(conv_url)
    @convdetail_page.follow_root_post

    # step 8: user3 response user1'reply
    @about_page.about_login(:regular_user1, 'logged')
    depth4_reply_text = "Create a depth4 answer by user3 - #{get_timestamp}"
    @convdetail_page.create_new_child_reply_for_specific_conv_and_parent_reply(conv_url: conv_url, parent_reply_text: reply_text, reply_text: depth4_reply_text)

    # step 9: check user2's notification
    act7 = @notification_page.get_first_popup_notification_text(user: :nf_regular_user2)
    exp7 = "#@name_user1 Replied To The Post #{conv_title}: \"#{depth4_reply_text.slice(0...50)}\""
    assert_equal_case_insensitive exp7, act7
  end
end