require 'watir_test'
require 'pages/community/conversationdetail'
require 'pages/community/topic_list'
require 'actions/community/api'
require 'time'

class ConversationDetailTest < WatirTest
  def setup
    super
    @topiclist_page = Pages::Community::TopicList.new(@config)
    @convdetail_page = Pages::Community::ConversationDetail.new(@config)
    @api_actions = Actions::CommunityAPI.new(@config)

    @topic_for_conv_test = "A Watir Topic For Feature 1"

    # assigning @current_page helps error reporting
    #  give good contextual data
    @current_page = @convdetail_page
    puts "[[[ #{name} ::: #{user_for_test} ]]]" if @config.verbose?
    @browser = @config.browser
    @convdetail_page.start!(user_for_test)
    @topicdetail_page = @topiclist_page.go_to_topic(@topic_for_conv_test)
    @topic_url = @browser.url
    @topic_id = @topic_url.match(/\/topic\/(\w+)\//)[1]
  end

  def teardown
    super
  end

  user :regular_user1
  p1
  def test_00010_conv_create_edit_delete_question
    create_question(user_for_test) do |question_id, conv_url, title|
      assert_equal @convdetail_page.conv_user_link.when_present.text, @config.users[user_for_test].name
      assert_equal @convdetail_page.conv_title.when_present.text, title, "Title is not expected"
      assert_equal @convdetail_page.conv_type_flag.when_present.text, "Question", "Type is incorrect"
      assert_equal @convdetail_page.root_post_actions_panel.likes_count, "0"
      assert_equal @convdetail_page.root_post_actions_panel.replies_count, "0"
      assert_equal @convdetail_page.root_post_actions_panel.follows_count, "1"

      new_title = title + "-rename"
      @convdetail_page.edit_conversation(title: new_title, details: [{type: :text, content: "New"}])
      assert_equal @convdetail_page.conv_title.when_present.text, new_title, "Title is not expected"
      assert_equal @convdetail_page.conv_des.when_present.text, "New\nWatir test description"

      @convdetail_page.delete_conversation
      assert_equal @topicdetail_page.topic_title.when_present.text, @topic_for_conv_test
      assert @topicdetail_page.questionlist_widget.post_with_title(new_title).nil?, "Question #{new_title} not deleted"
    end
  end
  
  def test_00020_conv_follow_like_reply_question
    create_question(user_for_test) do |question_id, conv_url, title|
      # login with user 2
      @convdetail_page.start!(:regular_user2)
      @browser.goto conv_url
      @browser.wait_until { @convdetail_page.conv_detail.present? }

      # like/follow/create a reply to the root post
      @convdetail_page.root_post_actions_panel.like
      @convdetail_page.root_post_actions_panel.follow
      reply_content = "Test reply created by Watir - #{get_timestamp}"
      @convdetail_page.create_reply(des: reply_content)
      @browser.wait_until { @convdetail_page.root_post_actions_panel.replies_count == "1" }

      # verify the like/replies/follower count changed
      assert_equal @convdetail_page.root_post_actions_panel.likes_count, "1"
      assert_equal @convdetail_page.root_post_actions_panel.follows_count, "2"
      assert_equal @convdetail_page.root_post_actions_panel.replies_count, "1"
      assert_equal @convdetail_page.replies_panel.replies_count, "1"

      # go to topic to verify like/replies/views count
      @browser.goto @topic_url
      @browser.wait_until { @topicdetail_page.topic_filter.present? }
      @browser.wait_until { !@topicdetail_page.questionlist_widget.post_with_title(title).nil? }
      assert_equal @topicdetail_page.questionlist_widget.post_with_title(title).likes_count, "1"
      assert_equal @topicdetail_page.questionlist_widget.post_with_title(title).replies_count, "1"
      assert_equal @topicdetail_page.questionlist_widget.post_with_title(title).views_count, "3"

      # go to the question to unlike/unfollow it
      @browser.goto conv_url
      @browser.wait_until { @convdetail_page.conv_detail.present? }

      @convdetail_page.root_post_actions_panel.unlike
      @convdetail_page.root_post_actions_panel.unfollow

      # verify like/follower count changed in conversation page
      assert_equal @convdetail_page.root_post_actions_panel.likes_count, "0"
      assert_equal @convdetail_page.root_post_actions_panel.follows_count, "1"

      # go to topic page to verify like/replies/views count updated for the question
      @browser.goto @topic_url
      @browser.wait_until { @topicdetail_page.topic_filter.present? }
      @browser.wait_until { !@topicdetail_page.questionlist_widget.post_with_title(title).nil? }
      assert_equal @topicdetail_page.questionlist_widget.post_with_title(title).likes_count, "0"
      assert_equal @topicdetail_page.questionlist_widget.post_with_title(title).replies_count, "1"
      assert_equal @topicdetail_page.questionlist_widget.post_with_title(title).views_count, "4"
    end
  end   

  def test_00030_conv_feature_unfeature_question
    create_question(user_for_test) do |question_id, conv_url, title|
      # login with admin user
      @convdetail_page.start!(:network_admin)
      @browser.goto conv_url
      @browser.wait_until { @convdetail_page.conv_detail.present? }

      # feature the question
      @convdetail_page.feature_root_post
      assert @convdetail_page.conv_featured_flag.present?

      # go to topic page to verify the question is flagged as Featured
      @browser.goto @topic_url
      @browser.wait_until { @topicdetail_page.topic_filter.present? }
      @browser.wait_until { !@topicdetail_page.questionlist_widget.post_with_title(title).nil? }
      assert @topicdetail_page.questionlist_widget.post_with_title(title).featured?

      # go to the question to unfeature it
      @browser.goto conv_url
      @browser.wait_until { @convdetail_page.conv_detail.present? }

      @convdetail_page.unfeature_root_post
      assert !@convdetail_page.conv_featured_flag.present?

      # go to topic page to verify it is not flagged as Featured
      @browser.goto @topic_url
      @browser.wait_until { @topicdetail_page.topic_filter.present? }
      @browser.wait_until { !@topicdetail_page.questionlist_widget.post_with_title(title).nil? }
      assert !@topicdetail_page.questionlist_widget.post_with_title(title).featured?
    end
  end  

  def test_00040_conv_create_edit_delete_reply_to_question
    create_question(user_for_test) do |question_id, conv_url, title|
      # login with user 2
      @convdetail_page.start!(:regular_user2)
      @browser.goto conv_url
      @browser.wait_until { @convdetail_page.conv_detail.present? }

      # create a reply
      reply_content = "Test reply created by Watir - #{get_timestamp}"
      @convdetail_page.create_reply(des: reply_content)
      @browser.wait_until { !@convdetail_page.replies_panel.reply_with_content(1, reply_content).nil? }

      # edit the reply
      newreply_content = "Test reply created by Watir - #{get_timestamp}-e"
      @convdetail_page.edit_reply(des: newreply_content)

      @browser.wait_until { !@convdetail_page.replies_panel.reply_with_content(1, newreply_content).nil? }
      assert !@convdetail_page.replies_panel.reply_with_content(1, newreply_content).nil?

      # delete the reply
      @convdetail_page.replies_panel.delete_reply(1, newreply_content)
      assert @convdetail_page.replies_panel.replies_at_depth(1).size == 0
    end 
  end 

  def test_00050_conv_like_2nd_level_replies_in_question
    create_question(user_for_test) do |question_id, conv_url, title|
      # login with user 2
      @convdetail_page.start!(:regular_user2)
      @browser.goto conv_url
      @browser.wait_until { @convdetail_page.conv_detail.present? }

      # create a reply
      reply1_content = "Test reply1 created by Watir - #{get_timestamp}"
      @convdetail_page.create_reply(des: reply1_content)
      @browser.wait_until { !@convdetail_page.replies_panel.reply_with_content(1, reply1_content).nil? }

      # create a reply to the reply
      reply1_1_content = "Test reply1.1 created by Watir - #{get_timestamp}"
      @convdetail_page.replies_panel.reply_with_content(1, reply1_content).reply([{type: :text, content: reply1_1_content}])
      @browser.wait_until { !@convdetail_page.replies_panel.reply_with_content(2, reply1_1_content).nil? }

      @convdetail_page.root_post_actions_panel.like
      @convdetail_page.replies_panel.reply_with_content(1, reply1_content).like
      @convdetail_page.replies_panel.reply_with_content(2, reply1_1_content).like

      # verify the likes/replies count in conversation page
      assert_equal @convdetail_page.root_post_actions_panel.likes_count, "1"
      assert_equal @convdetail_page.root_post_actions_panel.replies_count, "2" 
      assert_equal @convdetail_page.replies_panel.replies_count, "2"
      assert_equal @convdetail_page.replies_panel.reply_with_content(1, reply1_content).like_count, "1"
      assert_equal @convdetail_page.replies_panel.reply_with_content(2, reply1_1_content).like_count, "1"

      # go to topic page to verify like/replies count is counted by accumulating all posts including root post
      @browser.goto @topic_url
      @browser.wait_until { @topicdetail_page.topic_filter.present? }
      @browser.wait_until { !@topicdetail_page.questionlist_widget.post_with_title(title).nil? }
      assert_equal @topicdetail_page.questionlist_widget.post_with_title(title).likes_count, "3"
      assert_equal @topicdetail_page.questionlist_widget.post_with_title(title).replies_count, "2"

      # login with user 1
      @convdetail_page.start!(user_for_test)
      @browser.goto conv_url
      @browser.wait_until { @convdetail_page.conv_detail.present? }

      # create a reply to the 2nd level reply
      @browser.wait_until { !@convdetail_page.replies_panel.reply_with_content(2, reply1_1_content).nil? }
      reply1_1_1_content = "Test reply1.1.1 created by Watir - #{get_timestamp}"
      @convdetail_page.replies_panel.reply_with_content(2, reply1_1_content).reply([{type: :text, content: reply1_1_1_content}])
      @browser.wait_until { !@convdetail_page.replies_panel.reply_with_content(2, reply1_1_1_content).nil? }

      # 2nd level of replies are sorted by create time as ASC
      assert @convdetail_page.replies_panel.replies_at_depth(2).size == 2 # no 3nd level replies
      assert @convdetail_page.replies_panel.replies_at_depth(2)[0].content == reply1_1_content
      assert @convdetail_page.replies_panel.replies_at_depth(2)[1].content == reply1_1_1_content

      # user can like posts created by himself
      @convdetail_page.root_post_actions_panel.like
      @convdetail_page.replies_panel.reply_with_content(1, reply1_content).like
      @convdetail_page.replies_panel.reply_with_content(2, reply1_1_content).like
      @convdetail_page.replies_panel.reply_with_content(2, reply1_1_1_content).like

      # verify the likes/replies count in conversation page
      assert_equal @convdetail_page.root_post_actions_panel.likes_count, "2"
      assert_equal @convdetail_page.root_post_actions_panel.replies_count, "3" 
      assert_equal @convdetail_page.replies_panel.replies_count, "3"
      assert_equal @convdetail_page.replies_panel.reply_with_content(1, reply1_content).like_count, "2"
      assert_equal @convdetail_page.replies_panel.reply_with_content(2, reply1_1_content).like_count, "2"
      assert_equal @convdetail_page.replies_panel.reply_with_content(2, reply1_1_1_content).like_count, "1"

      # go to topic page to verify like/replies count is counted by accumulating all posts including root post
      @browser.goto @topic_url
      @browser.wait_until { @topicdetail_page.topic_filter.present? }
      @browser.wait_until { !@topicdetail_page.questionlist_widget.post_with_title(title).nil? }
      assert_equal @topicdetail_page.questionlist_widget.post_with_title(title).likes_count, "7"
      assert_equal @topicdetail_page.questionlist_widget.post_with_title(title).replies_count, "3"

      # go to conversation page to unlike posts
      @browser.goto conv_url
      @browser.wait_until { @convdetail_page.conv_detail.present? }

      @browser.wait_until { !@convdetail_page.replies_panel.reply_with_content(1, reply1_content).nil? }
      @convdetail_page.replies_panel.reply_with_content(1, reply1_content).unlike
      @convdetail_page.replies_panel.reply_with_content(2, reply1_1_content).unlike
      @convdetail_page.replies_panel.reply_with_content(2, reply1_1_1_content).unlike

      assert_equal @convdetail_page.replies_panel.reply_with_content(1, reply1_content).like_count, "1"
      assert_equal @convdetail_page.replies_panel.reply_with_content(2, reply1_1_content).like_count, "1"
      assert_equal @convdetail_page.replies_panel.reply_with_content(2, reply1_1_1_content).like_count_label.present?, false

      # go to topic page to verify like/replies count is counted by accumulating all posts including root post
      @browser.goto @topic_url
      @browser.wait_until { @topicdetail_page.topic_filter.present? }
      @browser.wait_until { !@topicdetail_page.questionlist_widget.post_with_title(title).nil? }
      assert_equal @topicdetail_page.questionlist_widget.post_with_title(title).likes_count, "4"
      assert_equal @topicdetail_page.questionlist_widget.post_with_title(title).replies_count, "3"
    end 
  end 

  def test_00060_conv_close_reopen_question
    create_question(user_for_test) do |question_id, conv_url, title|
      # user 2 create two answers
      create_replies_in_question(@config.users[:regular_user2], question_id, 2) 
      
      # user 1 refresh the page
      @browser.refresh
      @browser.wait_until { @convdetail_page.conv_detail.present? }

      # feature the 1st reply
      @convdetail_page.replies_panel.feature_reply_at_index(1, 0)

      # login with admin/moderator
      @convdetail_page.start!(:network_moderator)
      @browser.goto conv_url
      @browser.wait_until { @convdetail_page.conv_detail.present? }

      # close the conversation
      @convdetail_page.close_conversation

      assert @convdetail_page.replies_panel.closed_label.present?
      assert !@convdetail_page.reply_box.present?
      assert !@convdetail_page.root_post_actions_panel.reply_enabled?
      assert !@convdetail_page.replies_panel.replies_at_depth(1)[0].reply_enabled?

      # reopen the conversation
      @convdetail_page.reopen_conversation
      assert !@convdetail_page.replies_panel.closed_label.present?
      assert @convdetail_page.reply_box.present?
      assert @convdetail_page.root_post_actions_panel.reply_enabled?
      assert @convdetail_page.replies_panel.replies_at_depth(1)[0].reply_enabled?
    end    
  end

  def test_00070_conv_feature_unfeature_reply_in_question
    create_question(user_for_test) do |question_id, conv_url, title|
      # user 2 create two answers
      create_replies_in_question(@config.users[:regular_user2], question_id, 2) 
      
      # user 1 refresh the page
      @browser.refresh
      @browser.wait_until { @convdetail_page.conv_detail.present? }

      # feature the 1st reply
      @convdetail_page.replies_panel.feature_reply_at_index(1, 0)
      @browser.wait_until { @convdetail_page.replies_panel.featured_reply.present? }
      assert @convdetail_page.replies_panel.replies_at_depth(1)[0].featured?
      assert !@convdetail_page.replies_panel.replies_at_depth(1)[1].featured?
      assert_equal @convdetail_page.replies_panel.featured_reply.content, 
                    @convdetail_page.replies_panel.replies_at_depth(1)[0].content

      # feature the 2nd reply
      @convdetail_page.replies_panel.feature_reply_at_index(1, 1) 
      @browser.wait_until { @convdetail_page.replies_panel.featured_reply.present? }
      assert !@convdetail_page.replies_panel.replies_at_depth(1)[0].featured?
      assert @convdetail_page.replies_panel.replies_at_depth(1)[1].featured?
      assert_equal @convdetail_page.replies_panel.featured_reply.content, 
                    @convdetail_page.replies_panel.replies_at_depth(1)[1].content

      # unfeature the 2nd reply
      @convdetail_page.replies_panel.unfeature_reply_at_index(1, 1)
      @browser.wait_until { !@convdetail_page.replies_panel.featured_reply.present? }
      assert !@convdetail_page.replies_panel.replies_at_depth(1)[0].featured?
      assert !@convdetail_page.replies_panel.replies_at_depth(1)[1].featured?
    end 
  end

  def test_00080_conv_load_more_replies_in_question
    create_question(user_for_test) do |question_id, conv_url, title|
      # user 2 create two answers
      create_replies_in_question(@config.users[:regular_user2], question_id, 20) 
      
      # user 1 refresh the page
      @browser.refresh
      @browser.wait_until { @convdetail_page.conv_detail.present? }
      @browser.wait_until { !@convdetail_page.layout_loading_block.present? }

      assert !@convdetail_page.replies_panel.show_more_btn.present?

      # user 1 create a reply
      reply_content = "Test reply created by Watir - #{get_timestamp}"
      @convdetail_page.create_reply(des: reply_content)
      @browser.wait_until { !@convdetail_page.replies_panel.reply_with_content(1, reply_content).nil? }

      # user 1 refresh the page
      @browser.refresh
      @browser.wait_until { @convdetail_page.conv_detail.present? }
      @browser.wait_until { !@convdetail_page.layout_loading_block.present? }

      # click Show More button
      @convdetail_page.replies_panel.show_more_btn.when_present.click
      @browser.wait_until { @convdetail_page.replies_panel.replies_at_depth(1).size > 20 }
      assert @convdetail_page.replies_panel.replies_at_depth(1).size == 21
      assert !@convdetail_page.replies_panel.show_more_btn.present?

      create_replies_in_question(@config.users[:regular_user2], question_id, 20) 

      # user 1 refresh the page
      @browser.refresh
      @browser.wait_until { @convdetail_page.conv_detail.present? }
      @browser.wait_until { !@convdetail_page.layout_loading_block.present? }

      # click Show More button
      @convdetail_page.replies_panel.show_more_btn.when_present.click
      @browser.wait_until { @convdetail_page.replies_panel.replies_at_depth(1).size > 20 }

      # click Show More again
      @convdetail_page.replies_panel.show_more_btn.when_present.click
      @browser.wait_until { @convdetail_page.replies_panel.replies_at_depth(1).size == 41 }
      assert !@convdetail_page.replies_panel.show_more_btn.present?
    end  
  end 

  def test_00090_conv_show_older_2nd_level_replies_in_question
    create_question(user_for_test) do |question_id, conv_url, title|
      # login with user 2
      @convdetail_page.start!(:regular_user2)
      @browser.goto conv_url
      @browser.wait_until { @convdetail_page.conv_detail.present? }

      # create a reply
      reply1_content = "Test reply1 created by Watir - #{get_timestamp}"
      @convdetail_page.create_reply(des: reply1_content)
      @browser.wait_until { !@convdetail_page.replies_panel.reply_with_content(1, reply1_content).nil? }

      # create 4 replies to the reply
      reply1_1_content = "Test reply1.1 created by Watir - #{get_timestamp}"
      @convdetail_page.replies_panel.reply_with_content(1, reply1_content).reply([{type: :text, content: reply1_1_content}])
      @browser.wait_until { !@convdetail_page.replies_panel.reply_with_content(2, reply1_1_content).nil? }
      reply1_2_content = "Test reply1.2 created by Watir - #{get_timestamp}"
      @convdetail_page.replies_panel.reply_with_content(1, reply1_content).reply([{type: :text, content: reply1_2_content}])
      @browser.wait_until { !@convdetail_page.replies_panel.reply_with_content(2, reply1_2_content).nil? }
      reply1_3_content = "Test reply1.3 created by Watir - #{get_timestamp}"
      @convdetail_page.replies_panel.reply_with_content(1, reply1_content).reply([{type: :text, content: reply1_3_content}])
      @browser.wait_until { !@convdetail_page.replies_panel.reply_with_content(2, reply1_3_content).nil? }
      reply1_4_content = "Test reply1.4 created by Watir - #{get_timestamp}"
      @convdetail_page.replies_panel.reply_with_content(1, reply1_content).reply([{type: :text, content: reply1_4_content}])
      @browser.wait_until { !@convdetail_page.replies_panel.reply_with_content(2, reply1_4_content).nil? }

      # verify "Show older responses..." link appears
      @browser.wait_until { @convdetail_page.replies_panel.replies_at_depth(2).size == 3 }

      # click the link to show all responses
      @convdetail_page.replies_panel.reply_with_content(2, reply1_2_content).show_older_responses_link.when_present.click
      @browser.wait_until { @convdetail_page.replies_panel.replies_at_depth(2).size == 4 }
    end
  end 

  def test_00100_conv_create_edit_delete_review
    @api_actions.delete_review_by_user(@config.users[user_for_test], @topic_id)

    title = "Test conv r created by Watir - #{get_timestamp}"
    @topicdetail_page.create_review(title: title, 
                                    details: [{type: :text, content: "Watir test description"}],
                                    star: 4,
                                    recommended: false)
    review_id = @browser.url.match(/\/review\/(\w+)\//)[1]

    assert_equal @convdetail_page.conv_title.when_present.text, title, "Title is not expected"
    assert_equal @convdetail_page.conv_type_flag.when_present.text, "Review", "Type is incorrect"
    assert_equal @convdetail_page.root_post_actions_panel.likes_count, "0"
    assert_equal @convdetail_page.root_post_actions_panel.replies_count, "0"
    assert_equal @convdetail_page.root_post_actions_panel.follows_count, "1"
    @browser.wait_until { @convdetail_page.conv_review_rating_full_stars.size == 4 } 
    assert !@convdetail_page.conv_review_recommend_flag.present?

    new_title = title + "-rename"
    @convdetail_page.edit_review(title: new_title, details: [{type: :text, content: "New"}], star: 3, recommended: true)
    assert_equal @convdetail_page.conv_title.when_present.text, new_title, "Title is not expected"
    assert_equal @convdetail_page.conv_des.when_present.text, "New\nWatir test description"
    @browser.wait_until { @convdetail_page.conv_review_rating_full_stars.size == 3 }
    assert @convdetail_page.conv_review_recommend_flag.present?

    @convdetail_page.delete_conversation
    assert_equal @topicdetail_page.topic_title.when_present.text, @topic_for_conv_test
    assert @topicdetail_page.reviewlist_widget.post_with_title(new_title).nil?, "Review #{new_title} not deleted"
  ensure
    @api_actions.delete_review(@config.users[user_for_test], review_id) unless review_id.nil?
  end 

  p2
  def test_00110_conv_cannot_create_multi_reviews_by_same_user
    @api_actions.delete_review_by_user(@config.users[user_for_test], @topic_id)

    # create a review
    title = "Test conv r created by Watir - #{get_timestamp}"
    @topicdetail_page.create_review(title: title, 
                                    details: [{type: :text, content: "Watir test description"}],
                                    star: 4,
                                    recommended: false)
    review_id = @browser.url.match(/\/review\/(\w+)\//)[1]

    # go to topic page
    @browser.goto @topic_url
    @browser.wait_until { @topicdetail_page.topic_filter.present? }

    # try to create one more view. Verify restriction modal is prompted.
    @topicdetail_page.goto_conversation_create_page(:review)

    assert @topicdetail_page.topic_review_restrict_modal_link.when_present.text == title

    # verify the link is correctly redirected to the review.
    @topicdetail_page.topic_review_restrict_modal_link.click
    assert_equal @convdetail_page.conv_title.when_present.text, title, "Title is not expected as #{title}"

    # go to topic page again
    @browser.goto @topic_url
    @browser.wait_until { @topicdetail_page.topic_filter.present? }

    # create review and dismiss the restrict modal
    @topicdetail_page.goto_conversation_create_page(:review)
    @topicdetail_page.topic_review_restrict_modal_skip_btn.when_present.click
    @browser.wait_until { !@topicdetail_page.topic_review_restrict_modal.present? }
  ensure
    @api_actions.delete_review(@config.users[user_for_test], review_id) unless review_id.nil?
  end 

  user :network_blogger1
  p1
  def test_00120_conv_create_edit_delete_blog
    title = "Test conv b created by Watir - #{get_timestamp}"
    @topicdetail_page.create_conversation(type: :blog, 
                                          title: title, 
                                          details: [{type: :text, content: "Watir test description"}])
    blog_id = @browser.url.match(/\/blog\/(\w+)\//)[1]

    assert_equal @convdetail_page.conv_title.when_present.text, title, "Title is not expected."
    assert_equal @convdetail_page.conv_type_flag.when_present.text, "Blog Post", "Type is incorrect"
    assert @convdetail_page.conv_moderation_alert.present?, "Blog is not in pending approval status"
    assert !@convdetail_page.root_post_actions_panel.present?, "Root post actions is visible"

    new_title = title + "-rename"
    @convdetail_page.edit_conversation(type: :blog, title: new_title, details: [{type: :text, content: "New"}])
    assert_equal @convdetail_page.conv_title.when_present.text, new_title, "Title is not expected"
    assert_equal @convdetail_page.conv_des.when_present.text, "New\nWatir test description"

    @convdetail_page.delete_conversation
    assert_equal @topicdetail_page.topic_title.when_present.text, @topic_for_conv_test
    assert @topicdetail_page.bloglist_widget.post_with_title(new_title).nil?, "Blog #{new_title} not deleted"
  ensure
    @api_actions.delete_blog(@config.users[user_for_test], blog_id) unless blog_id.nil?
  end

  user :network_blogger1
  p2
  def test_00130_conv_change_scheduled_blog
    # create a blog scheduled at 5 days later
    title = "Test conv b created by Watir - #{get_timestamp}"
    schedule_time = Time.now+5*24*60*60 # 5 days later
    @topicdetail_page.create_blog(title: title, 
                                  details: [{type: :text, content: "Watir test description"}],
                                  publish_schedule: schedule_time.strftime("%m/%d/%Y %l:%M %p"))

    conv_url = @browser.url
    blog_id = @browser.url.match(/\/blog\/(\w+)\//)[1]

    # verify the schedule text is consistent with the input
    schedule_text = @convdetail_page.conv_blog_alert.p(:css => ".moderation-alert:nth-of-type(3)").when_present.text.match(/Scheduled for publishing: (.+) \(Change\)/)[1]

    assert Time.parse(schedule_text).strftime("%m-%d %H") == schedule_time.strftime("%m-%d %H"), "Schedule label is not expected as #{schedule_time.to_s}"

    # change the publish schedule to 1 day later
    @convdetail_page.change_blog_schedule((Time.now+24*60*60).strftime("%m/%d/%Y %l:%M %p"))

    @browser.wait_until { @convdetail_page.conv_blog_alert.text.include?("in a day") }
  ensure
    @api_actions.delete_blog(@config.users[user_for_test], blog_id) unless blog_id.nil?
  end   

  def create_question(user_sym)
    # create a new question
    title = "Test conv q created by Watir - #{get_timestamp}"
    @topicdetail_page.create_conversation(type: :question, 
                                          title: title, 
                                          details: [{type: :text, content: "Watir test description"}])

    conv_url = @browser.url
    question_id = @browser.url.match(/\/question\/(\w+)\//)[1]

    if block_given?
      yield(question_id, conv_url, title) # for subsequent test steps
    end
  ensure
    @api_actions.delete_question(@config.users[user_sym], question_id) unless question_id.nil?   
  end  

  def create_replies_in_question(user, question_id, count) 
    count.times do |i|
      reply_content = "Test reply #{i} created by Watir - #{get_timestamp}"
      @api_actions.create_reply_in_question(user, question_id, reply_content)
    end
  end  
end