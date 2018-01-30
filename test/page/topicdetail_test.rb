require 'watir_test'
require 'pages/community/topicdetail'
require 'pages/community/login'
require 'pages/community/home'
require 'pages/community/profile'
require 'pages/community/conversationdetail'
require 'pages/hybris/detail'

class TopicDetailTest < WatirTest
  def setup
    super
    @browser = @config.browser
    @topiclist_page = Pages::Community::TopicList.new(@config)
    @topicdetail_page = Pages::Community::TopicDetail.new(@config)
    @login_page = Pages::Community::Login.new(@config)
    @home_page = Pages::Community::Home.new(@config)
    @profile_page = Pages::Community::Profile.new(@config)
    @convdetail_page = Pages::Community::ConversationDetail.new(@config)
    @hybris_detail_page = Pages::Hybris::Detail.new(@config)
    # assigning @current_page helps error reporting
    #  give good contextual data
    @current_page = @topicdetail_page
    puts "[[[ #{name} ::: #{user_for_test} ]]]" if @config.verbose?
   
    @topicdetail_page.start!(user_for_test)
  end

  def teardown
    super
  end

  user :anonymous
  p1

  def test_00010_goto_topic_page
    @browser.goto @topicdetail_page.topicpage_url
    @browser.wait_until { @topicdetail_page.topic_page.present? }
  end

  def test_00011_topicpage
    search_placeholder = @home_page.search_bar.placeholder
    expected_title = @c.network_name+" Topics"

    assert_all_keys({
      :body => @browser.body.present?,
      :top_button => @topicdetail_page.topic_page_top_button.present?,
      :search_bar => @home_page.search_bar.present?, 
      :footer => @home_page.footer.present?,
      :title_match => (@browser.title.downcase == expected_title.downcase),
    })      
  end

  def test_SET2_00020_topicdetailpage_support
    @topiclist_page.go_to_topic(@topicdetail_page.support_topicname)
    assert @topicdetail_page.topic_filter.present?
    assert @login_page.topnav.present?
  end

  def test_00030_topicdetailpage_engagement
    @topiclist_page.go_to_topic(@topicdetail_page.engagement_topicname)
    assert @topicdetail_page.topic_filter.present?
    assert @login_page.topnav.present?
  end

  def test_00040_topicdetailpage_browser_tab_title
    @topiclist_page.go_to_topic(@topicdetail_page.support_topicname)
    assert_match @browser.title, @topicdetail_page.support_topicname
  end

  def test_SET2_00050_topicdetailpage_check_topnav_anon
    @topiclist_page.go_to_topic(@topicdetail_page.engagement_topicname)
    if @login_page.user_dropdown.present?
     @login_page.logout!
    end
    if @login_page.user_dropdown.present?
     @topicdetail_page.about_login("regis2", "logged")
     @browser.wait_until { @login_page.topnav_notification.present? }
    else 

     @browser.wait_until { @login_page.topnav_home.present? }
     @browser.wait_until { @login_page.topnav_topic.present? }
     @browser.wait_until { @login_page.topnav_product.present? }
     @browser.wait_until { @login_page.topnav_about.present? }
     @browser.wait_until { @login_page.topnav_signin.present? }
     @browser.wait_until { @login_page.topnav_search.present? }
     @browser.wait_until { @login_page.topnav_logo.present? } 
     assert @login_page.topnav_home.present?
     assert @login_page.topnav_topic.present?
     assert @login_page.topnav_product.present? 
     assert @login_page.topnav_about.present?
     assert @login_page.topnav_signin.present?
     assert @login_page.topnav_search.present?
     assert @login_page.topnav_logo.present?
     assert !@login_page.topnav_notification.present?
    end
  end

  user :regular_user1
  def test_00060_topicdetailpage_check_topnav_reg
    @topiclist_page.go_to_topic(@topicdetail_page.engagement_topicname)
    @browser.wait_until { @login_page.topnav_notification.present? }
    
    @browser.wait_until { @profile_page.topnav_home.present? }
    @browser.wait_until { @profile_page.topnav_topic.present? }
    @browser.wait_until { @profile_page.topnav_product.present? }
    @browser.wait_until { @profile_page.topnav_about.present? }
    
    @browser.wait_until { @profile_page.topnav_search.present? }
    @browser.wait_until { @profile_page.topnav_logo.present? }
    
    assert @profile_page.topnav_home.present?
    assert @profile_page.topnav_topic.present?
    assert @profile_page.topnav_product.present? 
    assert @profile_page.topnav_about.present?
    assert !@login_page.topnav_signin.present?
    assert @profile_page.topnav_search.present?
    assert @profile_page.topnav_logo.present?
    assert @login_page.topnav_notification.present?
    @login_page.logout!
  end

  user :anonymous
  def test_SET2_00070_topicdetailpage_banner
    @topiclist_page.go_to_topic(@topicdetail_page.engagement_topicname)
    assert @topicdetail_page.topic_filter.present?
    assert @topicdetail_page.topic_banner.present?
  end

  def test_SET2_00080_topicdetailpage_topictitle
    @topicdetail_page.topic_and_sort_check
    @topiclist_page.go_to_topic(@topicdetail_page.engagement_topicname)
    @browser.wait_until { @topicdetail_page.topic_title.present? }
    topictitle = @topicdetail_page.topic_title.text
    assert @topicdetail_page.topic_title.text.include? topictitle
  end

  def test_SET2_00090_topicdetailpage_breadcrumb
    @topiclist_page.go_to_topic(@topicdetail_page.engagement_topicname)
    @browser.wait_until { @topicdetail_page.topic_breadcrumb.present? }
    @topicdetail_page.topic_topic_breadcrumb.click
    @browser.wait_until { @topicdetail_page.topic_page.present? }
    assert @topicdetail_page.topic_page.present?

    @topiclist_page.go_to_topic(@topicdetail_page.engagement_topicname)
    @browser.wait_until { @topicdetail_page.topic_breadcrumb.present? }
    @topicdetail_page.topic_network_breadcrumb.click
    @browser.wait_until { @home_page.home.present? }
    assert @home_page.home.present?
  end

  def test_SET2_00100_topicdetailpage_check_filter
    @topiclist_page.go_to_topic(@topicdetail_page.engagement_topicname)
    @browser.wait_until { @topicdetail_page.topic_filter.present? }
    assert @topicdetail_page.topic_filter.present?
    @browser.wait_until { @topicdetail_page.topic_create_new_button.present? }
    assert @topicdetail_page.topic_create_new_button.present?
  end

  def test_00110_topicdetailpage_check_topic_nav_annoymous
    @topicdetail_page = @topiclist_page.go_to_topic(@topicdetail_page.engagement_topicname)

    @browser.wait_until { @topicdetail_page.topic_navigator.selected_filter_type == :question }

    assert @topicdetail_page.topic_navigator.selected_filter_type == :question

    @browser.execute_script("window.scrollTo(0,document.documentElement.scrollTop)")

    assert !@topicdetail_page.topic_navigator.floated?

    @topicdetail_page.topic_navigator.select_filter_type(:blog)
    @browser.wait_until { @topicdetail_page.topic_navigator.floated? }
    assert @topicdetail_page.topic_navigator.selected_filter_type == :blog
    @topicdetail_page.topic_navigator.select_filter_type(:review)
    assert @topicdetail_page.topic_navigator.selected_filter_type == :blog || 
           @topicdetail_page.topic_navigator.selected_filter_type == :review

    assert @topicdetail_page.topic_navigator.follow_topic_btn.present? ||
           @topicdetail_page.topic_navigator.unfollow_topic_btn.present?
    @topicdetail_page.topic_navigator.create_new_btn.when_present.click
    @browser.wait_until { @topicdetail_page.topic_navigator.create_new_question_menu_item.present? } 
    @browser.wait_until { @topicdetail_page.topic_navigator.create_new_review_menu_item.present? } 
    assert_all_keys({
      :questions => @topicdetail_page.topic_navigator.create_new_question_menu_item.present?,
      :blogs => !@topicdetail_page.topic_navigator.create_new_blog_menu_item.present?,
      :reviews => @topicdetail_page.topic_navigator.create_new_review_menu_item.present?, 
    })  
  end  

  user :network_admin
  def test_00140_topicdetailpage_check_filter_register_user
    @topicdetail_page = @topiclist_page.go_to_topic(@topicdetail_page.engagement_topicname)

    @browser.wait_until { @topicdetail_page.topic_navigator.selected_filter_type == :question }

    assert @topicdetail_page.topic_navigator.selected_filter_type == :question

    #@browser.execute_script("window.scrollTo(0,document.documentElement.scrollTop)")

    assert !@topicdetail_page.topic_navigator.floated?

    @topicdetail_page.topic_navigator.select_filter_type(:blog)
    @browser.wait_until { @topicdetail_page.topic_navigator.floated? }
    assert @topicdetail_page.topic_navigator.selected_filter_type == :blog
    @topicdetail_page.topic_navigator.select_filter_type(:review)
    assert @topicdetail_page.topic_navigator.selected_filter_type == :blog || 
           @topicdetail_page.topic_navigator.selected_filter_type == :review

    assert @topicdetail_page.topic_navigator.follow_topic_btn.present? || 
           @topicdetail_page.topic_navigator.unfollow_topic_btn.present?
    @topicdetail_page.topic_navigator.create_new_btn.when_present.click
    @browser.wait_until { @topicdetail_page.topic_navigator.create_new_question_menu_item.present? } 
    @browser.wait_until { @topicdetail_page.topic_navigator.create_new_review_menu_item.present? } 
    assert_all_keys({
      :questions => @topicdetail_page.topic_navigator.create_new_question_menu_item.present?,
      :blogs => @topicdetail_page.topic_navigator.create_new_blog_menu_item.present?,
      :reviews => @topicdetail_page.topic_navigator.create_new_review_menu_item.present?, 
    })  
  end  

  user :anonymous
  def test_SET2_00150_topicdetailpage_create_new_anon
    @topiclist_page.go_to_topic(@topicdetail_page.engagement_topicname)
    @browser.wait_until { @topicdetail_page.topic_create_new_button.present? }
    assert @topicdetail_page.topic_create_new_button.present?
  end

  def test_00160_topicdetailpage_post_conv_anon
    @topiclist_page.go_to_topic(@topicdetail_page.engagement_topicname)
    @topicdetail_page.check_post_conv_anon
    assert @login_page.signin_page.present?
  end

  def test_SET2_00170_topicdetailpage_post_like_anon
    @topiclist_page.go_to_topic(@topicdetail_page.engagement_topicname)
    @topicdetail_page.check_post_like_anon
    assert @login_page.signin_page.present?
  end

  def test_00180_topicdetailpage_post_follow_anon
    @topiclist_page.go_to_topic(@topicdetail_page.engagement_topicname)
    @topicdetail_page.check_post_follow_anon
    assert @login_page.signin_page.present?
  end


  def test_SET2_00190_topicdetailpage_follow_topic_anon
    @topiclist_page.go_to_topic(@topicdetail_page.engagement_topicname)
    @browser.wait_until { @topicdetail_page.topic_follow_button.present? }
    assert @topicdetail_page.topic_follow_button.present?
    @topicdetail_page.topic_follow_button.click
    @browser.wait_until { @login_page.signin_page.present? }
    assert @login_page.signin_page.present?
  end

  def test_00200_topicdetailpage_no_topic_edit_anon
    @topiclist_page.go_to_topic(@topicdetail_page.engagement_topicname)
    @topicdetail_page.check_no_admin_button("anon")
    assert !@topicdetail_page.topic_edit_button.present?
    assert !@topicdetail_page.topic_feature_button.present?
    assert !@topicdetail_page.topic_deactivate_button.present?
  end

  user :regular_user2
  def test_SET2_00210_topicdetailpage_no_topic_edit_reg
    @topiclist_page.go_to_topic(@topicdetail_page.engagement_topicname)
    @topicdetail_page.check_no_admin_button("logged")
    assert !@topicdetail_page.topic_edit_button.present?
    assert !@topicdetail_page.topic_feature_button.present?
    assert !@topicdetail_page.topic_deactivate_button.present?
  end

  def test_00220_topicdetailpage_check_search_bar
    @topiclist_page.go_to_topic(@topicdetail_page.engagement_topicname)
    @browser.wait_until { @topicdetail_page.topic_search.present? }
    assert @topicdetail_page.topic_search.present?
  end

  def test_SET2_00230_topicdetailpage_search
    @topiclist_page.go_to_topic(@topicdetail_page.engagement_topicname)
    @topicdetail_page.check_topicdetail_search
    assert @topicdetail_page.search_result_page.present?
  end

  def test_00240_topicdetailpage_check_sort_by
    @topicdetail_page = @topiclist_page.go_to_topic(@topicdetail_page.engagement_topicname)
    @browser.execute_script("window.scrollTo(0,document.documentElement.scrollTop)")

    @browser.wait_until { @topicdetail_page.recent_q_gadget.present? }
    assert @topicdetail_page.recent_q_gadget.sort_by_toggle.when_present.text.include?('Newest')
    @topicdetail_page.recent_q_gadget.sort_by_toggle.when_present.click
    @browser.wait_until { @topicdetail_page.recent_q_gadget.sort_by_newest_menu_item.present? &&
                          @topicdetail_page.recent_q_gadget.sort_by_oldest_menu_item.present? }

    assert @topicdetail_page.recent_q_gadget.sort_by_newest_menu_item.present?
    assert @topicdetail_page.recent_q_gadget.sort_by_oldest_menu_item.present?
  end

  p2
  def test_00250_topicdetailpage_sort_by_new_post
    # go to a specific topic
    @topicdetail_page = @topiclist_page.go_to_topic(@topicdetail_page.engagement_topicname)

    # create a question
    convtitle = "Sort by new test created by Watir - #{get_timestamp}"
    @topicdetail_page.create_conversation(type: :question,
                                          title: convtitle,
                                          details: [{type: :text, content: "Watir test description"}])
    # go to topic
    @convdetail_page.conv_breadcrumbs_topic_link.when_present.click
    @browser.wait_until { @topicdetail_page.topic_post.present? }

    # select questions tab and click Sort by Newest
    @topicdetail_page.check_post_filter_button("ques", "anon")
    @browser.wait_until { @topicdetail_page.topic_post.present? }
    sleep 2
    @browser.execute_script("window.scrollBy(0,-1000)")

    @topicdetail_page.sort_post_by_newest

    assert @topicdetail_page.topic_sort_post_by_newest.present? || @topicdetail_page.topic_sort_post_by_newest_new.present?
    @browser.wait_until { !@topicdetail_page.questionlist_widget.post_with_title(convtitle).nil? }

    @login_page.logout!
  end

  def test_00260_topicdetailpage_sort_by_old_post
    @topiclist_page.go_to_topic(@topicdetail_page.engagement_topicname)
    convtitle = "Sort by old test created by Watir - #{get_timestamp}"
    @topicdetail_page.create_conversation(type: :question,
                                          title: convtitle,
                                          details: [{type: :text, content: "Watir test description"}])
    @topicdetail_page.conv_engagement_topic_breadcrumb.click

    @topicdetail_page.check_post_filter_button("ques", "anon")
    @browser.wait_until { @topicdetail_page.topic_post.present? }
    sleep 2
    @browser.execute_script("window.scrollBy(0,-1000)")

    @topicdetail_page.sort_post_by_oldest

    @browser.wait_until { @topicdetail_page.topic_post.present? }
    assert @topicdetail_page.topic_sort_post_by_oldest.present? || @topicdetail_page.topic_sort_post_by_oldest_new.present?
    assert ( !@topicdetail_page.topic_post.text.include? convtitle )
    @login_page.logout!
  end

  user :anonymous
  p1
  def test_SET2_00290_topicdetailpage_check_post_link
    @topiclist_page.go_to_topic(@topicdetail_page.engagement_topicname)
    @topicdetail_page.check_post_link
    assert @convdetail_page.conv_detail.present?
  end

  def test_00300_topidetailpage_check_post_author_title_icon_timestamp
    @topiclist_page.go_to_topic(@topicdetail_page.engagement_topicname)
    @topicdetail_page.check_post_filter("ques")
    @topicdetail_page.check_post_title_author_icon("ques")
  
    assert @topicdetail_page.topic_q_icon.present?
    assert @topicdetail_page.topic_post_author.present?
    assert @topicdetail_page.topic_post_timestamp.present?

    @topicdetail_page.check_post_like_icon_and_count
    assert @topicdetail_page.topic_post_like_icon.present?

    @topicdetail_page.check_post_reply_icon_and_count
    assert @topicdetail_page.topic_post_comment_icon.present?

    @topicdetail_page.check_post_view_icon_and_count
    assert @topicdetail_page.topic_post_view_icon.present?

  end

  p2
  def test_00310_topicdetailpage_show_more_post
    @topiclist_page.go_to_topic(@topicdetail_page.engagement_topicname)
    @topicdetail_page.check_post_filter("ques")
    @topicdetail_page.check_show_more_for_post
    assert @topicdetail_page.topic_post.present?
  end

  p1
  def test_SET2_00320_topicdetailpage_check_engagement_widget_anon
    @topiclist_page.go_to_topic(@topicdetail_page.engagement_topicname)
    @browser.execute_script("window.scrollBy(0,-200)")
    @topicdetail_page.check_post_filter("ques")
    @topicdetail_page.check_topic_signin_widget_for_anon
    assert @topicdetail_page.topic_signin_widget.present?
    if beta_feature_enabled?("fs_topcontri")
      @topicdetail_page.check_top_contributor_widget
      assert @topicdetail_page.topic_top_contributor_widget.present?
    end  
    @topicdetail_page.check_featured_topic_widget
    assert @topicdetail_page.topic_featured_topic_widget.present?
  end

  def test_00330_topicdetailpage_check_support_widget 
    @topicdetail_page = @topiclist_page.go_to_topic(@topicdetail_page.support_topicname)
    @browser.wait_until { @topicdetail_page.side_signin_gadget.present? }
    assert @topicdetail_page.side_signin_gadget.present? 
    @browser.wait_until { @topicdetail_page.side_popular_answers_gadget.present? }
    assert @topicdetail_page.side_popular_answers_gadget.present?
    if beta_feature_enabled?("fs_topcontri")
      @browser.wait_until { @topicdetail_page.side_top_contri_gadget.present? }
      assert @topicdetail_page.side_top_contri_gadget.present?
    end 
  end

  p2
  def test_00340_topicdetailpage_check_footer
    @topiclist_page.go_to_topic(@topicdetail_page.engagement_topicname)
    @browser.execute_script("window.scrollBy(0,10000)")
    @browser.wait_until { @home_page.footer.present? }
    assert @home_page.footer.present?
  end

  p1
  user :network_admin
  def test_00360_topicdetailpage_create_new_question_reg
    title = "Question created by Watir - #{get_timestamp}"
    @topiclist_page.go_to_topic(@topicdetail_page.engagement_topicname)
    @topicdetail_page.create_conversation(type: :question, 
                                          title: title, 
                                          details: [{type: :text, content: "Watir test description"}])


    @convdetail_page.conv_breadcrumbs_topic_link.click

    @browser.wait_until { @topicdetail_page.topic_post.present? }
    @topicdetail_page.check_post_filter_button("ques", "anon")
    @browser.wait_until { @topicdetail_page.topic_post.present? }
    assert @topicdetail_page.topic_post_link.text.include? title
  end

  def test_SET2_00370_topicdetailpage_post_comment_reg
    @login_page.login!(@c.users[:network_admin])
    @topiclist_page.go_to_topic(@topicdetail_page.engagement_topicname)
    @topicdetail_page.check_post_filter("ques")
    @convdetail_page.conversation_detail("question")
    @convdetail_page.post_comment("question")
  end

  def test_00380_create_question
    @login_page.login!(@c.users[:network_admin])
    @topiclist_page.go_to_topic(@topicdetail_page.engagement_topicname)
    @topicdetail_page.create_new_q_from_topic_detail
  end

  def test_SET2_00390_suggested_q_post
    @login_page.login!(@c.users[:network_admin])
    @topiclist_page.go_to_topic(@topicdetail_page.engagement_topicname)
    @topicdetail_page.suggested_q_post
  end

  def test_SET2_00400_suggested_q_post_link
    @login_page.login!(@c.users[:network_admin])
    @topiclist_page.go_to_topic(@topicdetail_page.engagement_topicname)
    @topicdetail_page.suggested_q_post_link
  end

  def test_00410_create_question_with_link
    @login_page.login!(@c.users[:network_admin])
    @topiclist_page.go_to_topic(@topicdetail_page.engagement_topicname)
    @topicdetail_page.create_new_q_with_link_from_topic_detail
  end

  def test_00411_create_question_with_image
    @login_page.login!(@c.users[:network_admin])
    @topiclist_page.go_to_topic(@topicdetail_page.engagement_topicname)
    @topicdetail_page.create_new_q_with_image_from_topic_detail
    image = @convdetail_page.post_content.img
    assert @browser.execute_script("return arguments[0].complete && typeof arguments[0].naturalWidth != \"undefined\" && arguments[0].naturalWidth > 0", image) == true

  end


  # p2
  # def test_00420_create_discussion_with_link
  #   #@login_page.login!(@c.users[:network_admin])
  #   @topicdetail_page.goto_topicdetail_page("engagement")
  #   @topicdetail_page.create_new_d_with_link_from_topic_detail
  # end

  # def test_00421_create_discussion_with_rte
  #   @topicdetail_page.goto_topicdetail_page("engagement")
  #   @topicdetail_page.create_new_d_with_rte_from_topic_detail
  # end

  # comment above cases related with discussion and add a question case for replacement
  p2
  def test_00421_create_question_with_rte
    @topiclist_page.go_to_topic(@topicdetail_page.engagement_topicname)
    @topicdetail_page.create_new_q_with_rte_from_topic_detail
  end

  p1
  def xtest_00430_create_blog_with_video #commenting the test for now as video functionality is now intentionally hidden
    @login_page.login!(@c.users[:network_admin])
    @topiclist_page.go_to_topic(@topicdetail_page.engagement_topicname)
    @topicdetail_page.create_new_b_with_video_from_topic_detail
  end

  def test_00440_create_blog 
    @login_page.login!(@c.users[:network_admin])
    @topiclist_page.go_to_topic(@topicdetail_page.engagement_topicname)
    @topicdetail_page.create_new_b_from_topic_detail
  end

  def test_00450_topicdetailpage_follow_topic_reg
    @login_page.login!(@c.users[:network_admin])

    @topiclist_page.go_to_topic(@topicdetail_page.engagement_topicname)
    if !@topicdetail_page.topic_follow_button.present?
      @topicdetail_page.topic_unfollow_button.present? 
      @topicdetail_page.unfollow_topic
      assert @topicdetail_page.topic_follow_button.present?
    end

    @topicdetail_page.follow_topic
    assert @topicdetail_page.topic_unfollow_button.present?
    @topicdetail_page.unfollow_topic #bringing state back
    assert @topicdetail_page.topic_follow_button.present?
  end

  user :regular_user2
  def test_SET2_00460_topicdetailpage_signin_widget_reg
    @login_page.login!(@c.users[:regular_user2])
    @topiclist_page.go_to_topic(@topicdetail_page.engagement_topicname)
    @topicdetail_page.check_post_filter("ques")
    assert !@topicdetail_page.topic_signin_widget.present?
  end

  user :network_admin
  def test_00470_topicdetailpage_check_top_contributor_widget_work
    @topicdetail_page = @topiclist_page.go_to_topic(@topicdetail_page.engagement2_topicname)
    @topicdetail_page.check_top_contributor_widget_work
  end

  def test_SET2_00480_topicdetailpage_check_featured_topic_widget_work
    @login_page.login!(@c.users[:network_admin])
    @topiclist_page.go_to_topic(@topicdetail_page.engagement2_topicname)
    @topicdetail_page.check_featured_topic_widget_work
  end

  user :anonymous
  def test_SET2_00490_topicdetailpage_check_featured_topic_link_img_and_widget_title
    @topiclist_page.go_to_topic(@topicdetail_page.engagement2_topicname)
    @topicdetail_page.check_featured_topic_widget
    @topicdetail_page.check_featured_topic_widget_title
    assert @topicdetail_page.topic_featured_topic_widget_title.present? 
    @topicdetail_page.check_featured_topic_widget_link_and_img
  end

  ################ ADMIN user test ###############
  user :network_admin
  def test_SET2_00590_topicdetailpage_check_admin_button
    @topiclist_page.go_to_topic(@topicdetail_page.engagement_topicname)
    @topicdetail_page.check_admin_button("logged")
    assert @topicdetail_page.topic_edit_button.present?
    assert @topicdetail_page.topic_feature_button.present? || @topicdetail_page.topic_unfeature_button.present?
    assert @topicdetail_page.topic_deactivate_button.present?
  end

  def test_00600_topicdetailpage_edit_a_topic
    # @login_page.login!(@c.users[:network_admin])
    @topiclist_page.go_to_topic(@topicdetail_page.engagement2_topicname)
    @topicdetail_page.edit_a_topic
  end

  def test_00610_topicdetailpage_feature_unfeature_a_topic
    @login_page.login!(@c.users[:network_admin])
    @topiclist_page.go_to_topic(@topicdetail_page.engagement_topicname)
    @topicdetail_page.feature_a_topic
    @topicdetail_page.unfeature_a_topic
    assert @topicdetail_page.topic_feature_button.present?
  end

  def xtest_00620_activate_deactivate_a_topic
    @login_page.login!(@c.users[:network_admin])
    @topiclist_page.go_to_topic(@topicdetail_page.engagement2_topicname)
    @topicdetail_page.deactivate_a_topic
    assert @topicdetail_page.topic_activate_button.present?
    @topicdetail_page.activate_a_topic
    assert @topicdetail_page.topic_deactivate_button.present?
  end   


end