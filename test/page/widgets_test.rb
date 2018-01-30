require 'watir_test'
require 'pages/community/conversationdetail'
require 'pages/community/topic_list'
require 'pages/community/topicdetail'
require 'actions/community/api'
require 'pages/community/gadgets/side'
require 'pages/community/register'
require 'pages/community/gadgets/search_input'

class WidgetsTest < WatirTest
  def setup
    super
    @topiclist_page = Pages::Community::TopicList.new(@config)
    @topicdetail_page = Pages::Community::TopicDetail.new(@config)
    @convdetail_page = Pages::Community::ConversationDetail.new(@config)
    @api_actions = Actions::CommunityAPI.new(@config)
    @login_page = Pages::Community::Login.new(@config)

    @topic_for_widgets_test = "A Watir Topic For Widgets"

    # assigning @current_page helps error reporting
    #  give good contextual data
    puts "[[[ #{name} ::: #{user_for_test} ]]]" if @config.verbose?
    @browser = @config.browser
    return if user_for_test == :none
    @topiclist_page.start!(user_for_test)
    @topiclist_page.go_to_topic(@topic_for_widgets_test)
    @current_page = @topicdetail_page

    @topic_url = @browser.url
    @topic_id = @topic_url.match(/\/topic\/(\w+)\//)[1]
  end

  def teardown
    super
  end

  user :anonymous
  p1
  def test_00010_topicdetail_login_widget_anonymous
    login_widget = Gadgets::Community::SideSignIn.new(@config)
    @browser.wait_until { login_widget.present? }
    click_widget_link(page_obj: @topicdetail_page, 
                      widget_obj: login_widget, 
                      link_type: :signin)

    login_page = Pages::Community::Login.new(@config)
    @browser.wait_until { login_page.member_login.present? }

    @browser.goto @topic_url
    @browser.wait_until { login_widget.present? }
    click_widget_link(page_obj: @topicdetail_page, 
                      widget_obj: login_widget, 
                      link_type: :register)

    register_page = Pages::Community::Register.new(@config)
    @browser.wait_until { register_page.register_signup_field.present? }
  end

  user :regular_user1
  def test_00020_topicdetail_join_conv_widget_normal_user
    joinconv_widget = Gadgets::Community::SideJoinConversation.new(@config)
    @browser.wait_until { joinconv_widget.present? && joinconv_widget.ask_question_link.present?}

    assert !joinconv_widget.add_blog_link.present?

    click_widget_link(page_obj: @topicdetail_page, 
                      widget_obj: joinconv_widget, 
                      link_type: :question)

    convcreate_page = Pages::Community::ConversationCreate.new(@config)
    assert convcreate_page.question_type_picker.when_present.class_name.include?("chosen")

    newconv_title = "Test widget q created by Watir - #{get_timestamp}"
    convcreate_page.fill_in_fields_then_submit_conversation(type: :question, 
                                          title: newconv_title, 
                                          details: [{type: :text, content: "Watir test description"}])
    assert_match @convdetail_page.conv_title.when_present.text, newconv_title
    question_id = @browser.url.match(/\/question\/(\w+)\//)[1]
  ensure
    @api_actions.delete_question(@config.users[user_for_test], question_id) unless question_id.nil?   
  end

  user :network_blogger1
  def test_00030_topicdetail_join_conv_widget_blogger_user
    joinconv_widget = Gadgets::Community::SideJoinConversation.new(@config)
    @browser.wait_until { joinconv_widget.present? }
    @browser.wait_until { joinconv_widget.ask_question_link.present? }

    click_widget_link(page_obj: @topicdetail_page, 
                      widget_obj: joinconv_widget, 
                      link_type: :blog)

    convcreate_page = Pages::Community::ConversationCreate.new(@config)
    assert convcreate_page.blog_type_picker.when_present.class_name.include?("chosen"), "Blog type should be selected by default"
    newconv_title = "Test widget b created by Watir - #{get_timestamp}"
    convcreate_page.fill_in_fields_then_submit_conversation(type: :blog, 
                                          title: newconv_title, 
                                          details: [{type: :text, content: "Watir test description"}])
    assert_match @convdetail_page.conv_title.when_present.text, newconv_title
    blog_id = @browser.url.match(/\/blog\/(\w+)\//)[1]
  ensure
    @api_actions.delete_blog(@config.users[user_for_test], blog_id) unless blog_id.nil?   
  end 

  user :anonymous
  def test_00040_convdetail_login_widget_anonymous
    @topicdetail_page.goto_conversation(type: :question)
    conv_url = @browser.url

    login_widget = Gadgets::Community::SideSignIn.new(@config)
    @browser.wait_until { login_widget.present? }

    click_widget_link(page_obj: @convdetail_page, 
                      widget_obj: login_widget, 
                      link_type: :signin)

    login_page = Pages::Community::Login.new(@config)
    @browser.wait_until { login_page.member_login.present? }

    @browser.goto conv_url
    @browser.wait_until { login_widget.present? }
    click_widget_link(page_obj: @convdetail_page, 
                      widget_obj: login_widget, 
                      link_type: :register)

    register_page = Pages::Community::Register.new(@config)
    @browser.wait_until { register_page.register_signup_field.present? }
  end 

  user :regular_user1
  def test_00050_convdetail_join_conv_widget_normal_user
    @topicdetail_page.goto_conversation(type: :question)
    conv_url = @browser.url

    joinconv_widget = Gadgets::Community::SideJoinConversation.new(@config)
    @browser.wait_until { joinconv_widget.present? && joinconv_widget.ask_question_link.present? }

    assert !joinconv_widget.add_blog_link.present?
    click_widget_link(page_obj: @convdetail_page, 
                      widget_obj: joinconv_widget, 
                      link_type: :question)

    convcreate_page = Pages::Community::ConversationCreate.new(@config)
    assert convcreate_page.question_type_picker.when_present.class_name.include?("chosen")

    newconv_title = "Test widget q created by Watir - #{get_timestamp}"
    convcreate_page.fill_in_fields_then_submit_conversation(type: :question, 
                                          title: newconv_title, 
                                          details: [{type: :text, content: "Watir test description"}])
    assert_match @convdetail_page.conv_title.when_present.text, newconv_title
    question_id = @browser.url.match(/\/question\/(\w+)\//)[1]
  ensure
    @api_actions.delete_question(@config.users[user_for_test], question_id) unless question_id.nil?   
  end

  user :network_blogger1
  def test_00060_convdetail_join_conv_widget_blogger_user
    @topicdetail_page.goto_conversation(type: :question)

    joinconv_widget = Gadgets::Community::SideJoinConversation.new(@config)
    @browser.wait_until { joinconv_widget.present? && joinconv_widget.ask_question_link.present? }

    click_widget_link(page_obj: @convdetail_page, 
                      widget_obj: joinconv_widget, 
                      link_type: :blog)

    convcreate_page = Pages::Community::ConversationCreate.new(@config)
    assert convcreate_page.blog_type_picker.when_present.class_name.include?("chosen"), "Blog type should be selected by default"
  end 

  user :anonymous
  def test_00070_live_chat_widget
    livechat_widget = Gadgets::Community::SideLiveChat.new(@config)
    @browser.wait_until { livechat_widget.present? }

    @topicdetail_page.goto_conversation(type: :question)
    @browser.wait_until { livechat_widget.present? }
  end 

  user :anonymous
  def test_00080_trending_tags_widget_anonymous
    @topicdetail_page.goto_conversation(type: :question)

    trendingtags_widget = Gadgets::Community::SideTrendingTags.new(@config)
    unless trendingtags_widget.present?
      login_widget = Gadgets::Community::SideSignIn.new(@config)
      @browser.wait_until { login_widget.present? }

      click_widget_link(page_obj: @convdetail_page, 
                      widget_obj: login_widget, 
                      link_type: :signin)

      login_page = Pages::Community::Login.new(@config)

      login_page.login!(@config.users[:regular_user1])

      goto_topic(@topic_url)

      new_tag = "tag#{Time.now.utc.to_i}"
      @topicdetail_page.create_conversation(type: :question, 
                                            title: "Test widget q created by Watir - #{get_timestamp}", 
                                            details: [{type: :tag, content: new_tag}])
      start_time = Time.now
      loop do 
        @browser.refresh
        @browser.wait_until { @convdetail_page.conv_detail.present? }
        @browser.wait_until { !@convdetail_page.layout_loading_block.present? }
        @browser.wait_until { !@convdetail_page.layout_loading_spinner.present? }
        break if trendingtags_widget.present? || (Time.now - start_time) > 2*60
        sleep 5
      end
    end 

    # in conversation page, click the first tag in trending tags widget to go to search page
    @browser.wait_until { trendingtags_widget.present? && trendingtags_widget.tag_items.size > 0 }
    tag_content = trendingtags_widget.tag_items[0].when_present.text
    click_widget_link(page_obj: @convdetail_page, 
                      widget_obj: trendingtags_widget, 
                      link_type: nil, 
                      condition_type: :index, 
                      condition_val: 0)
    searchinput_widget = Gadgets::Community::SearchInput.new(@config)
    @browser.wait_until { searchinput_widget.present? }
    assert_equal searchinput_widget.input_field.when_present.value, "#{tag_content}", "Search keywords should be correct"
  
    # in topic page, click the first tag in trending tags widget to go to search page
    goto_topic(@topic_url)
    @browser.wait_until { trendingtags_widget.present? && trendingtags_widget.tag_items.size > 0 }
    tag_content = trendingtags_widget.tag_items[0].when_present.text
    click_widget_link(page_obj: @topicdetail_page, 
                      widget_obj: trendingtags_widget, 
                      link_type: nil, 
                      condition_type: :index, 
                      condition_val: 0)
    searchinput_widget = Gadgets::Community::SearchInput.new(@config)
    @browser.wait_until { searchinput_widget.present? }
    assert_equal searchinput_widget.input_field.when_present.value, "#{tag_content}", "Search keywords should be correct"
  end 

  user :none
  def test_00090_top_contributor_popular_answer_widgets
    # prepare test data
    # A new topic - Admin
    # -- question 1 - User 1
    # -----reply from User 2
    # -----reply from Admin
    # -- question 2 - User 2
    # -----reply form User 1
    title = "test-tcpa-widget-topic-" + Time.now.utc.to_i.to_s
    description = "topic for testing widget"
    topic_id = @api_actions.create_topic(@config.users[:network_admin], title, description, "engagement")

    raise "Fail to create topic" if topic_id.nil?

    q1_title = "question 1"
    q2_title = "question 2"
    q3_title = "question 3"
    q1_id = @api_actions.create_question(@config.users[:regular_user1], topic_id, q1_title, "test widget")
    q2_id = @api_actions.create_question(@config.users[:regular_user2], topic_id, q2_title, "test widget")
    q3_id = @api_actions.create_question(@config.users[:regular_user1], topic_id, q3_title, "test widget")
    @api_actions.create_reply_in_question(@config.users[:regular_user2], q1_id, "reply to q1 from user 2")
    @api_actions.create_reply_in_question(@config.users[:network_admin], q1_id, "reply to q1 from admin")
    @api_actions.create_reply_in_question(@config.users[:regular_user1], q2_id, "reply to q2 from user 1")

    # go to topic page
    @topiclist_page.start!(:network_admin)
    topic_url = @config.base_url + "/topic/#{topic_id}/#{@config.slug}/#{title}"
    goto_topic(topic_url)

    topcontri_widget = Gadgets::Community::SideTopContributors.new(@config)
    popanswers_widget = Gadgets::Community::SidePopularAnswers.new(@config)
    ## sometimes, the widgets would flash out and then disappear.
    sleep 0.5
    @browser.wait_until { !topcontri_widget.present? && !popanswers_widget.present?} # for assert

    # go to question 1 created by user 1
    @topicdetail_page.goto_conversation(title: q1_title)
    sleep 0.5
    @browser.wait_until { !topcontri_widget.present? && !popanswers_widget.present?} # for assert
    q1_url = @browser.url

    # like question 1
    @convdetail_page.like_root_post

    # refresh to verify top contributor widget appears with User 1 listed as top contributor
    @browser.refresh
    @browser.wait_until { topcontri_widget.present? }
    @convdetail_page.layout.wait_until_loading_complete

    @browser.wait_until { !popanswers_widget.present? }
    @browser.wait_until { topcontri_widget.user_items.size == 1 }
    assert_equal topcontri_widget.user_item_at_index(0).when_present.text, @config.users[:regular_user1].name

    # like the reply from user 2
    @convdetail_page.replies_panel.reply_with_content(1, "reply to q1 from user 2").like

    # refresh to verify top contributor widget appears with User 2 listed as 1st top contributor
    @browser.refresh
    @browser.wait_until { topcontri_widget.present? }
    @convdetail_page.layout.wait_until_loading_complete

    @browser.wait_until { !popanswers_widget.present? }
    @browser.wait_until { topcontri_widget.user_items.size == 2 }
    assert_equal topcontri_widget.user_item_at_index(0).when_present.text, @config.users[:regular_user2].name
    assert_equal topcontri_widget.user_item_at_index(1).when_present.text, @config.users[:regular_user1].name

    # go to topic page
    goto_topic(topic_url)

    # verify top contributor widget in topic detail page looks the same as conversation page
    @browser.wait_until { topcontri_widget.present? && !popanswers_widget.present? }
    assert !popanswers_widget.present?
    @browser.wait_until { topcontri_widget.user_items.size == 2 }
    assert_equal topcontri_widget.user_item_at_index(0).when_present.text, @config.users[:regular_user2].name
    assert_equal topcontri_widget.user_item_at_index(1).when_present.text, @config.users[:regular_user1].name

    # go to question 2 created by user 2
    @topicdetail_page.goto_conversation(title: q2_title)
    q2_url = @browser.url

    # verify topic contributor widget looks the same across different conversations
    @browser.wait_until { topcontri_widget.present? && !popanswers_widget.present? }
    assert !popanswers_widget.present?
    @browser.wait_until { topcontri_widget.user_items.size == 2 }
    assert_equal topcontri_widget.user_item_at_index(0).when_present.text, @config.users[:regular_user2].name
    assert_equal topcontri_widget.user_item_at_index(1).when_present.text, @config.users[:regular_user1].name

    # like the user 1's reply post
    @convdetail_page.replies_panel.reply_with_content(1, "reply to q2 from user 1").like
    
    # refresh to verify top contributor widget updated with user 1 listed as 1st top contributor
    @browser.refresh
    @browser.wait_until { topcontri_widget.present? }
    @convdetail_page.layout.wait_until_loading_complete

    @browser.wait_until { !popanswers_widget.present? }
    @browser.wait_until { topcontri_widget.user_items.size == 2 }
    assert_equal topcontri_widget.user_item_at_index(0).when_present.text, @config.users[:regular_user1].name
    assert_equal topcontri_widget.user_item_at_index(1).when_present.text, @config.users[:regular_user2].name

    # go to topic page
    goto_topic(topic_url)

    # verify topic contributor widget updated as well in topic page
    @browser.wait_until { topcontri_widget.present? && !popanswers_widget.present? }
    @browser.wait_until { topcontri_widget.user_items.size == 2 }
    assert_equal topcontri_widget.user_item_at_index(0).when_present.text, @config.users[:regular_user1].name
    assert_equal topcontri_widget.user_item_at_index(1).when_present.text, @config.users[:regular_user2].name

    # go to question 1 to feature a reply
    @topicdetail_page.goto_conversation(title: q1_title)
    @convdetail_page.replies_panel.feature_reply(1, "reply to q1 from user 2")
    
    # refresh to verify popular answers widget appear with question 1 listed.
    @browser.refresh
    @browser.wait_until { popanswers_widget.present? }
    @convdetail_page.layout.wait_until_loading_complete

    @browser.wait_until { popanswers_widget.answers.size == 1 }
    assert_equal popanswers_widget.answers[0].title, q1_title
    assert_equal popanswers_widget.answers[0].like_count, "2"

    # go to topic page to verify popular answers widget in topic page looks the same as conversation page
    goto_topic(topic_url)

    @browser.wait_until { popanswers_widget.present? }
    @browser.wait_until { popanswers_widget.answers.size == 1 }
    assert_equal popanswers_widget.answers[0].title, q1_title

    # go to question 2 to feature a reply
    @topicdetail_page.goto_conversation(title: q2_title)
    @convdetail_page.replies_panel.feature_reply(1, "reply to q2 from user 1")

    # refresh to verify popular answers widget in both conversation and topic page
    @browser.refresh
    @browser.wait_until { popanswers_widget.present? }
    @convdetail_page.layout.wait_until_loading_complete

    @browser.wait_until { popanswers_widget.answers.size == 2 }
    assert_equal popanswers_widget.answers[0].title, q1_title
    assert_equal popanswers_widget.answers[1].title, q2_title
    assert_equal popanswers_widget.answers[0].author, @config.users[:regular_user1].name
    assert_equal popanswers_widget.answers[1].author, @config.users[:regular_user2].name
    assert_equal popanswers_widget.answers[0].like_count, "2"
    assert_equal popanswers_widget.answers[1].like_count, "1"

    goto_topic(topic_url)
    @browser.wait_until { popanswers_widget.present? }
    @browser.wait_until { popanswers_widget.answers.size == 2 }
    assert_equal popanswers_widget.answers[0].title, q1_title
    assert_equal popanswers_widget.answers[1].title, q2_title
    assert_equal popanswers_widget.answers[0].author, @config.users[:regular_user1].name
    assert_equal popanswers_widget.answers[1].author, @config.users[:regular_user2].name
    assert_equal popanswers_widget.answers[0].like_count, "2"
    assert_equal popanswers_widget.answers[1].like_count, "1"

    # verify the links in top contributors widget are valid
    @browser.wait_until { topcontri_widget.present? && topcontri_widget.user_items.size == 2 }
    click_widget_link(page_obj: @topicdetail_page, 
                      widget_obj: topcontri_widget, 
                      link_type: nil, 
                      condition_type: :index, 
                      condition_val: 0)
    profile_page = Pages::Community::Profile.new(@config)
    assert_equal profile_page.profile_page_author_name_betaon.when_present.text, 
                 @config.users[:regular_user1].name, "Not same user profile"

    goto_conversation(q1_url)
    @browser.wait_until { topcontri_widget.present? && topcontri_widget.user_items.size == 2 }
    click_widget_link(page_obj: @convdetail_page, 
                      widget_obj: topcontri_widget, 
                      link_type: nil, 
                      condition_type: :index, 
                      condition_val: 1)
    assert_equal profile_page.profile_page_author_name_betaon.when_present.text, 
                 @config.users[:regular_user2].name, "Not same user profile"

    # verify the links in popular answers widget are valid
    goto_topic(topic_url)
    @browser.wait_until { popanswers_widget.present? && popanswers_widget.answers.size == 2 }
    click_widget_link(page_obj: @topicdetail_page, 
                      widget_obj: popanswers_widget, 
                      link_type: :title, 
                      condition_type: :index, 
                      condition_val: 0)
    assert_equal @convdetail_page.conv_title.when_present.text, q1_title, "Not expected question opened"

    goto_topic(topic_url)
    @browser.wait_until { popanswers_widget.present? && popanswers_widget.answers.size == 2 }
    click_widget_link(page_obj: @topicdetail_page, widget_obj: popanswers_widget, link_type: :author, condition_type: :index, condition_val: 0)
    assert_equal profile_page.profile_page_author_name_betaon.when_present.text, 
                 @config.users[:regular_user1].name, "Not same user profile"

    goto_conversation(q1_url)
    @browser.wait_until { popanswers_widget.present? && popanswers_widget.answers.size == 2 }
    click_widget_link(page_obj: @convdetail_page, widget_obj: popanswers_widget, link_type: :title, condition_type: :index, condition_val: 1)
    assert_equal @convdetail_page.conv_title.when_present.text, q2_title, "Not expected question opened"

    goto_conversation(q1_url)
    @browser.wait_until { popanswers_widget.present? && popanswers_widget.answers.size == 2 }
    click_widget_link(page_obj: @convdetail_page, widget_obj: popanswers_widget, link_type: :author, condition_type: :index, condition_val: 1)
    assert_equal profile_page.profile_page_author_name_betaon.when_present.text, 
                 @config.users[:regular_user2].name, "Not same user profile"
  ensure
    @api_actions.delete_topic(@config.users[:network_admin], topic_id) unless topic_id.nil? 
  end

  user :none
  def test_product_00100_conv_related_products_widget
    @topiclist_page.start!(:regular_user1)

    # Note: there are no related products for some products. So try 5 products here.  
    verify_success = false
    5.times.each_with_index do |index|
      if goto_topic_verify_related_products_widget(index)
        verify_success = true
        break
      end  
    end

    assert verify_success, "No Related Products widget appearing for at least 5 products"  
  end 

  def goto_topic_verify_related_products_widget(index)
    @topiclist_page.navigate_in(:product)
    @topiclist_page.goto_topic_at_index(index)

    @topicdetail_page.layout.wait_until_loading_complete

    if @topicdetail_page.questionlist_widget.posts.size > 0
      @topicdetail_page.goto_conversation(type: :question)
    elsif @topicdetail_page.bloglist_widget.posts.size > 0
      @topicdetail_page.goto_conversation(type: :blog)
    elsif @topicdetail_page.reviewlist_widget.posts.size > 0
      @topicdetail_page.goto_conversation(type: :review)
    else
      # create a question when there is no any conversations in the product.
      title = "Test q created by Watir - #{get_timestamp}"
      @topicdetail_page.create_conversation(type: :question, 
                                            title: title, 
                                            details: [{type: :text, content: "Watir test description"}])
    end  

    @browser.wait_until { @convdetail_page.conv_detail.present? }
    @convdetail_page.layout.wait_until_loading_complete

    relateprods_widget = Gadgets::Community::SideRelatedProducts.new(@config)

    begin
      @browser.wait_until(5) { relateprods_widget.present? }
    rescue
      return false
    end
      
    @browser.wait_until { relateprods_widget.present? && relateprods_widget.product_links.size > 0 }  
    first_product_name_in_widget = relateprods_widget.product_links[0].when_present.text
    click_widget_link(page_obj: @convdetail_page, widget_obj: relateprods_widget, link_type: nil, condition_type: :index, condition_val: 0)
    @browser.wait_until { @browser.url.include?(@config.hybris_url) }

    assert @browser.div(:class => "name").when_present.text.include? first_product_name_in_widget 
    return true
  end  

  def test_00110_featured_topics_widget
    title = "test-ft-widget-topic-" + Time.now.utc.to_i.to_s
    description = "topic for testing featured topics widget"
    topic_id = @api_actions.create_topic(@config.users[:network_admin], title, description, "engagement")

    raise "Fail to create topic" if topic_id.nil?
    q1_title = "question 1"
    q1_id = @api_actions.create_question(@config.users[:regular_user1], topic_id, q1_title, "test widget")

    # go to topic page
    @topiclist_page.start!(:network_admin)
    topic_url = @config.base_url + "/topic/#{topic_id}/#{@config.slug}/#{title}"
    goto_topic(topic_url)

    @topicdetail_page.feature_topic
    @browser.refresh
    @browser.wait_until { @topicdetail_page.topic_filter.present? }
    @convdetail_page.layout.wait_until_loading_complete

    featuredtopics_widget = Gadgets::Community::SideFeaturedTopics.new(@config)
    @browser.wait_until { featuredtopics_widget.present? && featuredtopics_widget.topics.size > 1 }
    @browser.wait_until { !featuredtopics_widget.topic_at_title(title).nil? }
    assert_equal featuredtopics_widget.topic_at_title(title).followers_count, "1", "Follower count incorrect"

    click_widget_link(page_obj: @topicdetail_page, widget_obj: featuredtopics_widget, link_type: :title, condition_type: :title, condition_val: title)
    assert_equal @topicdetail_page.topic_title.when_present.text, title, "Wrong topic is opened"

    goto_topic(topic_url)

    @topicdetail_page.goto_conversation
    @browser.wait_until { featuredtopics_widget.present? && featuredtopics_widget.topics.size > 1 }
    @browser.wait_until { !featuredtopics_widget.topic_at_title(title).nil? }

    click_widget_link(page_obj: @convdetail_page, widget_obj: featuredtopics_widget, link_type: :avatar, condition_type: :title, condition_val: title)
    assert_equal @topicdetail_page.topic_title.when_present.text, title, "Wrong topic is opened"

    goto_topic(topic_url)
    @topicdetail_page.unfeature_topic
    @browser.refresh
    @browser.wait_until { @topicdetail_page.topic_filter.present? }
    @convdetail_page.layout.wait_until_loading_complete

    @browser.wait_until { !featuredtopics_widget.present? || featuredtopics_widget.topic_at_title(title).nil? }

    @topicdetail_page.goto_conversation
    @browser.wait_until { !featuredtopics_widget.present? || featuredtopics_widget.topic_at_title(title).nil? }
  ensure
    @api_actions.delete_topic(@config.users[:network_admin], topic_id) unless topic_id.nil? 
  end

  def test_00110_featured_posts_widget
    title = "test-fp-widget-post-" + Time.now.utc.to_i.to_s
    description = "topic for testing featured posts widget"
    topic_id = @api_actions.create_topic(@config.users[:network_admin], title, description, "engagement")

    raise "Fail to create topic" if topic_id.nil?
    q1_title = "question 1"
    q1_id = @api_actions.create_question(@config.users[:regular_user1], topic_id, q1_title, "test widget")

    # go to conversation page
    @topiclist_page.start!(:network_admin)
    #topic_url = @config.base_url + "/topic/#{topic_id}/#{@config.slug}/#{title}"
    conversation_url = @config.base_url + "/question/#{q1_id}/#{@config.slug}/#{q1_title}"
    goto_conversation(conversation_url)
    author = @convdetail_page.conv_user_link.when_present.text
    @convdetail_page.feature_root_post

    @convdetail_page.conv_breadcrumbs_topic_link.when_present.click
    @topicdetail_page.layout.wait_until_loading_complete
    
    featuredposts_widget = Gadgets::Community::SideFeaturedPosts.new(@config)
    @browser.wait_until { featuredposts_widget.present? && featuredposts_widget.posts.size == 1 }
    @browser.wait_until { !featuredposts_widget.posts_at_title(q1_title).nil? }

    click_widget_link(page_obj: @topicdetail_page, widget_obj: featuredposts_widget, link_type: :title, condition_type: :title, condition_val: q1_title)
    assert_equal @convdetail_page.conv_title.when_present.text, q1_title, "Wrong conversation is opened"

    @convdetail_page.conv_breadcrumbs_topic_link.when_present.click
    @topicdetail_page.layout.wait_until_loading_complete

    profile_page = Pages::Community::Profile.new(@config)
    click_widget_link(page_obj: @topicdetail_page, widget_obj: featuredposts_widget, link_type: :author, condition_type: :title, condition_val: q1_title)
    assert_equal profile_page.profile_user_name.when_present.text, author, "Wrong profile is opened"

    goto_conversation(conversation_url)
    @convdetail_page.unfeature_root_post

    @convdetail_page.conv_breadcrumbs_topic_link.when_present.click
    @topicdetail_page.layout.wait_until_loading_complete

    @browser.wait_until { !featuredposts_widget.present? || featuredposts_widget.posts_at_title(q1_title).nil? }
  ensure
    @api_actions.delete_topic(@config.users[:network_admin], topic_id) unless topic_id.nil? 
  end

  def test_00120_open_questions_widget
    # prepare test data
    # A new topic - Admin
    # -- question 1 - User 1
    # -----reply from User 2
    title = "test-tcpa-widget-topic-" + Time.now.utc.to_i.to_s
    description = "topic for testing widget"
    topic_id = @api_actions.create_topic(@config.users[:network_admin], title, description, "engagement")

    raise "Fail to create topic" if topic_id.nil?

    q1_title = "question 1"
    q2_title = "question 2"
    q1_id = @api_actions.create_question(@config.users[:regular_user1], topic_id, q1_title, "test widget")
    q2_id = @api_actions.create_question(@config.users[:regular_user2], topic_id, q2_title, "test widget")

    # go to topic page
    @topiclist_page.start!(:network_admin)
    topic_url = @config.base_url + "/topic/#{topic_id}/#{@config.slug}/#{title}"
    goto_topic(topic_url)
    # like question 1
    @topicdetail_page.goto_conversation(title: q1_title)
    q1_url = @browser.url
    @convdetail_page.like_root_post
    # go to topic page
    @convdetail_page.conv_breadcrumbs_topic_link.when_present.click

    open_questions_widget = Gadgets::Community::SideOpenQuestions.new(@config)
    @browser.wait_until { open_questions_widget.present? } # for assert
    @browser.wait_until { open_questions_widget.posts.size == 2 }
    @browser.wait_until { !open_questions_widget.posts_at_title(q1_title).nil? }
    @browser.wait_until { !open_questions_widget.posts_at_title(q2_title).nil? }
    assert open_questions_widget.posts_at_title(q1_title).like_count == "1"
    assert open_questions_widget.posts_at_title(q2_title).like_count == "0"

    click_widget_link(page_obj: @topicdetail_page, widget_obj: open_questions_widget, link_type: :title, condition_type: :title, condition_val: q1_title)
    assert_equal @convdetail_page.conv_title.when_present.text, q1_title, "Wrong conversation is opened"

    @convdetail_page.conv_breadcrumbs_topic_link.when_present.click
    @topicdetail_page.layout.wait_until_loading_complete

    profile_page = Pages::Community::Profile.new(@config)
    click_widget_link(page_obj: @topicdetail_page, widget_obj: open_questions_widget, link_type: :author, condition_type: :title, condition_val: q1_title)
    assert_equal profile_page.profile_user_name.when_present.text, @config.users[:regular_user1].name, "Wrong profile is opened"

    # make a reply and mark it as best answer
    @api_actions.create_reply_in_question(@config.users[:regular_user2], q1_id, "reply to q1 from user 2")
    @browser.goto q1_url
    @convdetail_page.feature_post(1)

    # go to topic page and re-check widgets
    @convdetail_page.conv_breadcrumbs_topic_link.when_present.click
    @browser.wait_until { open_questions_widget.present? } # for assert
    @browser.wait_until { open_questions_widget.posts.size == 1 }
    @browser.wait_until { open_questions_widget.posts_at_title(q1_title).nil? }
    @browser.wait_until { !open_questions_widget.posts_at_title(q2_title).nil? }

  ensure
    @api_actions.delete_topic(@config.users[:network_admin], topic_id) unless topic_id.nil? 
  end

  def goto_topic(topic_url)
    @browser.goto topic_url
    @browser.wait_until { @topicdetail_page.topic_filter.present? }
    @topicdetail_page.layout.wait_until_loading_complete
  end 

  def goto_conversation(conv_url)
    @browser.goto conv_url
    @browser.wait_until { @convdetail_page.conv_detail.present? }
    @convdetail_page.layout.wait_until_loading_complete
  end

  def click_widget_link(page_obj:, widget_obj:, link_type:, condition_type: nil, condition_val: nil)
    @browser.wait_until { widget_obj.link(type: link_type, condition_type: condition_type, condition_val: condition_val).present? }
    begin
      page_obj.scroll_to_element widget_obj.link(type: link_type, condition_type: condition_type, condition_val: condition_val)
    rescue Selenium::WebDriver::Error::StaleElementReferenceError
      puts "Selenium::WebDriver::Error::StaleElementReferenceError happen. Wait a while and retry"
      sleep 2
      page_obj.scroll_to_element widget_obj.link(type: link_type, condition_type: condition_type, condition_val: condition_val)
    end
    @browser.execute_script("window.scrollBy(0,-200)") 
    sleep 2 # without this sleep, will fail sometimes due to the flying topic filter
    begin
      widget_obj.link(type: link_type, condition_type: condition_type, condition_val: condition_val).when_present.click
    rescue
      sleep 2 # sometimes click will fail due to overlapped by its parent or other elements. so retry here
      widget_obj.link(type: link_type, condition_type: condition_type, condition_val: condition_val).when_present.click
    end
  end  
end  