require File.expand_path(File.dirname(__FILE__) + "/excelsior_watir_test.rb")
require File.expand_path(File.dirname(__FILE__) + "/../lib/test_helper.rb")
require File.expand_path(File.dirname(__FILE__) + "/../lib/page_objects/page_object.rb")
require File.expand_path(File.dirname(__FILE__) + "/../lib/page_objects/community_topicdetail_page.rb")
require File.expand_path(File.dirname(__FILE__) + "/../lib/watir_lib.rb")
#require File.expand_path(File.dirname(__FILE__) + "/../lib/fixtures.rb")

class TopicDetailPageTest < ExcelsiorWatirTest
  include WatirLib
  #include Fixtures
  def setup
    super
    @topicdetailpage = CommunityTopicDetailPage.new(@browser)
    
  end
  
  #end

  #============ ANON USER TESTS ==========================#
  #=================================================================#

  #======== topic detail page, topic breadcrumb, banner, search, topic filters, sort by, featured posts recent posts, widgets, etc. tests ============#
  def test_p1_SET2_00010_topicdetailpage_support
    @topicdetailpage.goto_topicdetail_page("support")
  	assert @topicdetailpage.topic_filter.present?
    @loginpage = CommunityLoginPage.new(@browser)
    assert @loginpage.topnav.present?
    @topicdetailpage.newline
  end

  def test_p1_00020_topicdetailpage_engagement
    @topicdetailpage.goto_topicdetail_page("engagement")
    assert @topicdetailpage.topic_filter.present?
    @loginpage = CommunityLoginPage.new(@browser)
    assert @loginpage.topnav.present?
    @topicdetailpage.newline
  end

  def test_00021_topicdetailpage_browser_tab_title
    @topicdetailpage.goto_topicdetail_page("support")
    @topicdetailpage.check_topicdetail_browser_tab_title
    @topicdetailpage.newline
  end

  def test_p1_SET2_00021_topicdetailpage_check_topnav_anon
    @topicdetailpage.goto_topicdetail_page("engagement")
    @topicdetailpage.check_topnav("visitor")
    @profilepage = CommunityProfilePage.new(@browser)
    assert @profilepage.topnav_home.present?
    assert @profilepage.topnav_topic.present?
    assert @profilepage.topnav_product.present? 
    assert @profilepage.topnav_about.present?
    @loginpage = CommunityLoginPage.new(@browser)
    assert @loginpage.topnav_signin.present?
    @profilepage = CommunityProfilePage.new(@browser)
    assert @profilepage.topnav_search.present?
    assert @profilepage.topnav_logo.present?
    @loginpage = CommunityLoginPage.new(@browser)
    assert !@loginpage.topnav_notification.present?
    @topicdetailpage.newline
  end

  def test_p1_00022_topicdetailpage_check_topnav_reg
    @topicdetailpage.goto_topicdetail_page("engagement")
    @topicdetailpage.check_topnav("logged")
    @profilepage = CommunityProfilePage.new(@browser)
    assert @profilepage.topnav_home.present?
    assert @profilepage.topnav_topic.present?
    assert @profilepage.topnav_product.present? 
    assert @profilepage.topnav_about.present?
    @loginpage = CommunityLoginPage.new(@browser)
    assert !@loginpage.topnav_signin.present?
    @profilepage = CommunityProfilePage.new(@browser)
    assert @profilepage.topnav_search.present?
    assert @profilepage.topnav_logo.present?
    @loginpage = CommunityLoginPage.new(@browser)
    assert @loginpage.topnav_notification.present?
    @topicdetailpage.signout
    @topicdetailpage.newline
  end

  def test_p1_SET2_00030_topicdetailpage_banner
    @topicdetailpage.goto_topicdetail_page("engagement")
    assert @topicdetailpage.topic_filter.present?
    @topicdetailpage.check_topicdetail_banner
    assert @topicdetailpage.topic_banner.present?
    @topicdetailpage.newline
  end

  def test_p1_SET2_00040_topicdetailpage_topictitle
    @topicdetailpage.topic_and_sort_check
    @topicdetailpage.check_topic_title("engagement")
    assert @topicdetailpage.topic_title.text.include? $topictitle
    @topicdetailpage.newline
  end

  def test_p1_SET2_00050_topicdetailpage_breadcrumb
    @topicdetailpage.goto_topicdetail_page("engagement")
    @topicdetailpage.check_topicdetail_topic_breadcrumb_link
    assert @topicdetailpage.topic_page.present?

    @topicdetailpage.goto_topicdetail_page("engagement")
    @topicdetailpage.check_topicdetail_network_breadcrumb_link
    @homepage = CommunityHomePage.new(@browser)
    assert @homepage.home.present?
    @topicdetailpage.newline
  end

  def test_p1_SET2_00060_topicdetailpage_check_filter
    @topicdetailpage.goto_topicdetail_page("engagement")
    @topicdetailpage.check_topicdetail_filter
    assert @topicdetailpage.topic_filter.present?
    @topicdetailpage.check_topicdetail_create_new_button
    assert @topicdetailpage.topic_create_new_button.present?
    @topicdetailpage.newline
  end

  def test_p1_00070_topicdetailpage_check_q_filter
    @topicdetailpage.goto_topicdetail_page("engagement")
    @topicdetailpage.check_post_filter("ques")

    assert @topicdetailpage.topic_post_desc.present?
    @browser.wait_until($t) { @topicdetailpage.topic_q_icon.present? || @topicdetailpage.topic_best_answer_q_icon.present? }
    assert @topicdetailpage.topic_q_icon.present? || @topicdetailpage.topic_best_answer_q_icon.present?
    @topicdetailpage.check_post_filter_button("ques", "anon")
    assert @topicdetailpage.topic_new_q_button.present?
    @topicdetailpage.newline
  end

  def test_p1_00080_topicdetailpage_check_d_filter
    @topicdetailpage.goto_topicdetail_page("engagement")
    @topicdetailpage.check_post_filter("disc")
    assert @topicdetailpage.topic_post_desc.present?
    assert @topicdetailpage.topic_d_icon.present?

    @topicdetailpage.check_post_filter_button("disc", "anon")
    assert @topicdetailpage.topic_new_d_button.present?
    @topicdetailpage.newline
  end

  def test_p1_00090_topicdetailpage_check_b_filter
    @topicdetailpage.goto_topicdetail_page("engagement")
    @topicdetailpage.check_post_filter("blog")
    assert @topicdetailpage.topic_post_desc.present?
    assert @topicdetailpage.topic_b_icon.present?

    @topicdetailpage.check_post_filter_button("blog", "anon")
    assert !@topicdetailpage.topic_new_b_button.present?
    @topicdetailpage.newline
  end


  def test_p1_00100_topicdetailpage_check_r_filter
    @topicdetailpage.goto_topicdetail_page("engagement")
    @topicdetailpage.check_post_filter("review")
    if @topicdetailpage.no_topic_post.present?
      @topicdetailpage.main_landing("regular", "logged")
      @topicdetailpage.goto_topicdetail_page("engagement")
      @topicdetailpage.check_post_filter("review")
      @topicdetailpage.check_post_filter_button("review", "anon")
      create_conversation($network, $networkslug, "A Watir Topic", "review", "Test review created by Watir - #{get_timestamp}", false)
      @topicdetailpage.goto_topicdetail_page("engagement")
      @topicdetailpage.check_post_filter("review")
    end
    assert @topicdetailpage.topic_post_desc.present?
    assert @topicdetailpage.topic_r_icon.present?

    @topicdetailpage.check_post_filter_button("review", "anon")
    assert @topicdetailpage.topic_new_r_button.present?
    @topicdetailpage.newline
  end

  def test_p1_SET2_00110_topicdetailpage_create_new_anon
    @loginpage = CommunityLoginPage.new(@browser)
    if @loginpage.topnav_notification.present? || @loginpage.username_dropdown.present?
     signout
    end
    @topicdetailpage.goto_topicdetail_page("engagement")
    @topicdetailpage.check_topicdetail_create_new_button
    assert @topicdetailpage.topic_create_new_button.present?
    @topicdetailpage.newline
  end

  def test_p1_00111_topicdetailpage_post_conv_anon
    @loginpage = CommunityLoginPage.new(@browser)
    if @loginpage.topnav_notification.present? || @loginpage.username_dropdown.present?
     @loginpage.signout
    end
    @topicdetailpage.goto_topicdetail_page("engagement")
    @topicdetailpage.check_post_conv_anon
    @loginpage = CommunityLoginPage.new(@browser)
    assert @loginpage.signin_page.present?
    @topicdetailpage.newline
  end

  def test_p1_SET2_00112_topicdetailpage_post_like_anon
    @loginpage = CommunityLoginPage.new(@browser)
    if @loginpage.topnav_notification.present? || @loginpage.username_dropdown.present?
     @loginpage.signout
    end
    @topicdetailpage.goto_topicdetail_page("engagement")
    @topicdetailpage.check_post_like_anon
    @loginpage = CommunityLoginPage.new(@browser)
    assert @loginpage.signin_page.present?
    @topicdetailpage.newline
  end

  def test_p1_00113_topicdetailpage_post_follow_anon
    @loginpage = CommunityLoginPage.new(@browser)
    if @loginpage.topnav_notification.present? || @loginpage.username_dropdown.present?
     @loginpage.signout
    end
    @topicdetailpage.goto_topicdetail_page("engagement")
    @topicdetailpage.check_post_follow_anon
    @loginpage = CommunityLoginPage.new(@browser)
    assert @loginpage.signin_page.present?
    @topicdetailpage.newline
  end


  def test_p1_SET2_00120_topicdetailpage_follow_topic_anon
    @loginpage = CommunityLoginPage.new(@browser)
    if @loginpage.topnav_notification.present? || @loginpage.username_dropdown.present?
     @loginpage.signout
    end
    @topicdetailpage.goto_topicdetail_page("engagement")
    @topicdetailpage.check_topicdetail_follow_topic_button
    assert @topicdetailpage.topic_follow_button.present?
    @topicdetailpage.topic_follow_button.click
    @loginpage = CommunityLoginPage.new(@browser)
    @browser.wait_until($t) { @loginpage.signin_page.present? }
    assert @loginpage.signin_page.present?
    @topicdetailpage.newline
  end

  def test_p1_00130_topicdetailpage_no_topic_edit_anon
    @topicdetailpage.goto_topicdetail_page("engagement")
    @topicdetailpage.check_no_admin_button("anon")
    assert !@topicdetailpage.topic_edit_button.present?
    assert !@topicdetailpage.topic_feature_button.present?
    assert !@topicdetailpage.topic_deactivate_button.present?
    @topicdetailpage.newline
  end

  def test_p1_SET2_00140_topicdetailpage_no_topic_edit_reg
    @topicdetailpage.goto_topicdetail_page("engagement")
    @topicdetailpage.check_no_admin_button("logged")
    assert !@topicdetailpage.topic_edit_button.present?
    assert !@topicdetailpage.topic_feature_button.present?
    assert !@topicdetailpage.topic_deactivate_button.present?
    @topicdetailpage.newline
  end

  def test_p1_00150_topicdetailpage_check_search_bar
    @topicdetailpage.goto_topicdetail_page("engagement")
    @topicdetailpage.check_topicdetail_search_bar
    assert @topicdetailpage.topic_search.present?
    @topicdetailpage.newline
  end

  def test_p1_SET2_00160_topicdetailpage_search
    @topicdetailpage.goto_topicdetail_page("engagement")
    @topicdetailpage.check_topicdetail_search
    assert @topicdetailpage.search_result_page.present?
    @topicdetailpage.newline
  end

  def test_p1_00170_topicdetailpage_check_sort_by
    @topicdetailpage.goto_topicdetail_page("engagement")
    @topicdetailpage.check_post_filter("disc")
    @topicdetailpage.check_sort_link
    assert @topicdetailpage.topic_sort_post_by_newest.present? || @topicdetailpage.topic_sort_by_newest_link.present?
    @topicdetailpage.newline
  end

  def test_00180_topicdetailpage_sort_by_new_post
    @topicdetailpage.goto_topicdetail_page("engagement")
    convtitle = PageObject.new(@browser).create_conversation($network, $networkslug, "A Watir Topic", "disc", "Sort by new test created by Watir - #{get_timestamp}", false)
    @topicdetailpage.conv_engagement_topic_breadcrumb.click
    @browser.wait_until($t) { @topicdetailpage.topic_post.present? }
    
    @topicdetailpage.check_post_filter_button("disc", "anon")
    @browser.wait_until($t) { @topicdetailpage.topic_post.present? }
    @topicdetailpage.sort_post_by_newest 

    assert @topicdetailpage.topic_sort_post_by_newest.present? || @topicdetailpage.topic_sort_post_by_newest_new.present? 
    assert @topicdetailpage.topic_post.text.include? convtitle
    @topicdetailpage.signout
    @topicdetailpage.newline
  end

  def test_00190_topicdetailpage_sort_by_old_post
    @topicdetailpage.goto_topicdetail_page("engagement")
    convtitle = PageObject.new(@browser).create_conversation($network, $networkslug, "A Watir Topic", "question", "Sort by old test created by Watir - #{get_timestamp}", false)
    @topicdetailpage.conv_engagement_topic_breadcrumb.click

    @topicdetailpage.check_post_filter_button("ques", "anon")
    @browser.wait_until($t) { @topicdetailpage.topic_post.present? }
    @topicdetailpage.sort_post_by_oldest
    
    @browser.wait_until($t) { @topicdetailpage.topic_post.present? }
    assert @topicdetailpage.topic_sort_post_by_oldest.present? || @topicdetailpage.topic_sort_post_by_oldest_new.present?
    assert ( !@topicdetailpage.topic_post.text.include? convtitle )
    @topicdetailpage.signout
    @topicdetailpage.newline
  end

  def test_p1_SET2_00200_topicdetailpage_overview_default
    @topicdetailpage.goto_topicdetail_page("engagement")
    @topicdetailpage.check_overview_tab_default
    assert @topicdetailpage.topic_overview_selected.present?
    @topicdetailpage.newline
  end

  def test_p1_00210_topicdetailpage_overview_post
    @topicdetailpage.goto_topicdetail_page("engagement")
    @browser.wait_until($t) { (@topicdetailpage.topic_featuredq.present?) || (@topicdetailpage.topic_recentq.present?) ||
                              (@topicdetailpage.topic_featuredd.present?) || (@topicdetailpage.topic_recentd.present?) ||
                              (@topicdetailpage.topic_featuredb.present?) || (@topicdetailpage.topic_recentb.present?) 
                            }
    if @topicdetailpage.topic_featuredq.present?
      @topicdetailpage.check_featured_post_present("ques")
      @topicdetailpage.check_featured_post_title("ques")
      @topicdetailpage.check_featured_post_author_name("ques")
      @topicdetailpage.check_featured_post_feature_icon("ques")
      @topicdetailpage.check_featured_post_icon("ques")
    end

    if @topicdetailpage.topic_featuredd.present?
      @topicdetailpage.check_featured_post_present("disc")
      @topicdetailpage.check_featured_post_title("disc")
      @topicdetailpage.check_featured_post_author_name("disc")
      @topicdetailpage.check_featured_post_feature_icon("disc")
      @topicdetailpage.check_featured_post_icon("disc")
    end

    if @topicdetailpage.topic_featuredb.present?
      @topicdetailpage.check_featured_post_present("blog")
      @topicdetailpage.check_featured_post_title("blog")
      @topicdetailpage.check_featured_post_author_name("blog")
      @topicdetailpage.check_featured_post_feature_icon("blog")
      @topicdetailpage.check_featured_post_icon("blog")
    end

    if @topicdetailpage.topic_recentq.present?
      @topicdetailpage.check_recent_post_present("ques")
      @topicdetailpage.check_recent_post_title("ques")
      @topicdetailpage.check_recent_post_author_name("ques")
      @topicdetailpage.check_recent_post_icon("ques")
    end

    if @topicdetailpage.topic_recentd.present?
      @topicdetailpage.check_recent_post_present("disc")
      @topicdetailpage.check_recent_post_title("disc")
      @topicdetailpage.check_recent_post_author_name("disc")
      @topicdetailpage.check_recent_post_icon("disc")
    end

    if @topicdetailpage.topic_recentb.present?
      @topicdetailpage.check_recent_post_present("blog")
      @topicdetailpage.check_recent_post_title("blog")
      @topicdetailpage.check_recent_post_author_name("blog")
      @topicdetailpage.check_recent_post_icon("blog")
    end
    @topicdetailpage.newline
  end

  def test_p1_SET2_00220_topicdetailpage_check_post_link
    @topicdetailpage.goto_topicdetail_page("engagement")
    @topicdetailpage.check_post_link
    assert @topicdetailpage.conv_detail.present?
    @topicdetailpage.newline
  end

  def test_p1_00230_topidetailpage_check_post_author_title_icon_timestamp
    @topicdetailpage.goto_topicdetail_page("engagement")
    @topicdetailpage.check_post_filter("disc")
    @topicdetailpage.check_post_title_author_icon("disc")
  
    assert @topicdetailpage.topic_d_icon.present?
    assert @topicdetailpage.topic_post_author.present?
    assert @topicdetailpage.topic_post_timestamp.present?

    @topicdetailpage.check_post_like_icon_and_count
    assert @topicdetailpage.topic_post_like_icon.present?

    @topicdetailpage.check_post_reply_icon_and_count
    assert @topicdetailpage.topic_post_comment_icon.present?
    @topicdetailpage.newline
  end

  def test_00240_topicdetailpage_show_more_post
    @topicdetailpage.goto_topicdetail_page("engagement")
    @topicdetailpage.check_post_filter("disc")
    @topicdetailpage.check_show_more_for_post
    assert @topicdetailpage.topic_post.present?
    @topicdetailpage.newline
  end

  def test_p1_SET2_00250_topicdetailpage_check_engagement_widget_anon
    @loginpage = CommunityLoginPage.new(@browser)
    if @loginpage.topnav_notification.present? || @loginpage.username_dropdown.present?
     @loginpage.signout
    end
    @topicdetailpage.goto_topicdetail_page("engagement")
    @topicdetailpage.check_post_filter("disc")
    @topicdetailpage.check_topic_signin_widget_for_anon
    assert @topicdetailpage.topic_signin_widget.present?
    @topicdetailpage.check_top_contributor_widget
    assert @topicdetailpage.topic_top_contributor_widget.present?
    @topicdetailpage.check_featured_topic_widget
    assert @topicdetailpage.topic_featured_topic_widget.present?
    @topicdetailpage.check_popular_discussion_widget
    assert @topicdetailpage.topic_popular_disc_widget.present?
    @topicdetailpage.newline
  end

  def test_p1_00260_topicdetailpage_check_support_widget
    @loginpage = CommunityLoginPage.new(@browser)
    if @loginpage.topnav_notification.present? || @loginpage.username_dropdown.present?
     @loginpage.signout
    end
    @topicdetailpage.goto_topicdetail_page("support")
    @topicdetailpage.check_post_filter("ques")
    @topicdetailpage.check_topic_signin_widget_for_anon
    assert @topicdetailpage.topic_signin_widget.present?
    @topicdetailpage.check_popular_answer_widget
    assert @topicdetailpage.topic_popular_answer_widget.present?
    @topicdetailpage.check_featured_post_widget
    assert @topicdetailpage.topic_featured_post_widget.present?
    @topicdetailpage.check_top_contributor_widget
    assert @topicdetailpage.topic_top_contributor_widget.present?
    @topicdetailpage.check_open_question_widget
    assert @topicdetailpage.topic_open_q_widget.present?
    @topicdetailpage.newline
  end

  def test_00270_topicdetailpage_check_footer
    @topicdetailpage.goto_topicdetail_page("engagement")
    @browser.execute_script("window.scrollBy(0,10000)")
    @homepage = CommunityHomePage.new(@browser)
    @browser.wait_until($t) { @homepage.footer.present? }
    assert @homepage.footer.present?
    @topicdetailpage.newline
  end

  def test_p1_SET2_00280_topicdetailpage_signin_widget_title_action_anon
    @loginpage = CommunityLoginPage.new(@browser)
    if @loginpage.topnav_notification.present? || @loginpage.username_dropdown.present?
     @loginpage.signout
    end
    @topicdetailpage.goto_topicdetail_page("engagement")
    @topicdetailpage.check_post_filter("ques")
    @topicdetailpage.check_topic_signin_widget_for_anon
    assert @topicdetailpage.topic_signin_widget.present?
    @topicdetailpage.check_topic_signin_widget_title
    assert @topicdetailpage.topic_signin_widget_title.present?
    @topicdetailpage.check_topic_signin_widget_action
    @loginpage = CommunityLoginPage.new(@browser)
    assert @loginpage.signin_page.present?
    @topicdetailpage.goto_topic_page
    @topicdetailpage.goto_topicdetail_page("engagement")
    @topicdetailpage.check_post_filter("ques")
    @topicdetailpage.check_topic_signin_widget_action_for_register
    @loginpage = CommunityLoginPage.new(@browser)
    assert @loginpage.register_page.present?
    @topicdetailpage.newline
  end

  ################ REGULAR user test ###############

  def test_p1_00290_topicdetailpage_create_new_discussion_reg
    @topicdetailpage.main_landing("regular", "logged")
    @topicdetailpage.goto_topicdetail_page("engagement")
    @topicdetailpage.check_topicdetail_create_new_button
    title = PageObject.new(@browser).create_conversation($network, $networkslug, "A Watir Topic", "discussion", "Discussion created by Watir - #{get_timestamp}", false)
    
    @topicdetailpage.conv_engagement_topic_breadcrumb.click

    @browser.wait_until($t) { @topicdetailpage.topic_post.present? }
    @topicdetailpage.check_post_filter_button("disc", "anon")
    @browser.wait_until($t) { @topicdetailpage.topic_post.present? }
    assert @topicdetailpage.topic_post_link.text.include? title
    @topicdetailpage.newline
  end

  def test_p1_SET2_00291_topicdetailpage_post_comment_reg
    @topicdetailpage.main_landing("regular", "logged")
    @topicdetailpage.goto_topicdetail_page("engagement")
    @topicdetailpage.check_post_filter("disc")
    @topicdetailpage.conversation_detail("discussion")
    @topicdetailpage.post_comment("discussion")
    @topicdetailpage.newline

  end

  def test_p1_00292_create_question
    @loginpage = CommunityLoginPage.new(@browser)
    if !@loginpage.username.present?
     @topicdetailpage.main_landing("regular", "logged")
    end
    @topicdetailpage.goto_topicdetail_page("engagement")
    @topicdetailpage.create_new_q_from_topic_detail
    @topicdetailpage.newline
  end

  def test_p1_SET2_00293_suggested_q_post
    @loginpage = CommunityLoginPage.new(@browser)
    if !@loginpage.username.present?
     @topicdetailpage.main_landing("regular", "logged")
    end
    @topicdetailpage.goto_topicdetail_page("engagement")
    @topicdetailpage.suggested_q_post
    @topicdetailpage.newline
  end

  def test_p1_SET2_00294_suggested_q_post_link
    @loginpage = CommunityLoginPage.new(@browser)
    if !@loginpage.username.present?
     @topicdetailpage.main_landing("regular", "logged")
    end
    @topicdetailpage.goto_topicdetail_page("engagement")
    @topicdetailpage.suggested_q_post_link
    @topicdetailpage.newline
  end

  def test_p1_00295_create_question_with_link
    @loginpage = CommunityLoginPage.new(@browser)
    if !@loginpage.username.present?
     @topicdetailpage.main_landing("regular", "logged")
    end
    @topicdetailpage.goto_topicdetail_page("engagement")
    @topicdetailpage.create_new_q_with_link_from_topic_detail
    @topicdetailpage.newline
  end

  def test_00296_create_discussion_with_link
    @loginpage = CommunityLoginPage.new(@browser)
    if !@loginpage.username.present?
     @topicdetailpage.main_landing("regular", "logged")
    end
    @topicdetailpage.goto_topicdetail_page("engagement")
    @topicdetailpage.create_new_d_with_link_from_topic_detail
    @topicdetailpage.newline
  end

  def xtest_p1_00297_create_blog_with_video #commenting the test for now as video functionality is now intentionally hidden
    @topicdetailpage.main_landing("regular", "logged")
    @topicdetailpage.goto_topicdetail_page("engagement")
    @topicdetailpage.create_new_b_with_video_from_topic_detail
    @topicdetailpage.newline
  end

  def test_00298_create_blog 
    @topicdetailpage.main_landing("regular", "logged")
    @topicdetailpage.goto_topicdetail_page("engagement")
    @topicdetailpage.create_new_b_from_topic_detail
    @topicdetailpage.newline
  end

  def test_p1_00300_topicdetailpage_follow_topic_reg
    @topicdetailpage.main_landing("regis2", "logged")

    @topicdetailpage.goto_topicdetail_page("engagement")
    if !@topicdetailpage.topic_follow_button.present?
      @topicdetailpage.check_topicdetail_unfollow_topic_button
      @topicdetailpage.unfollow_topic
      assert @topicdetailpage.topic_follow_button.present?
    end

    @topicdetailpage.follow_topic
    assert @topicdetailpage.topic_unfollow_button.present?
    @topicdetailpage.unfollow_topic #bringing state back
    assert @topicdetailpage.topic_follow_button.present?
    @topicdetailpage.newline
  end

  def test_p1_SET2_00310_topicdetailpage_signin_widget_reg
    @topicdetailpage.main_landing("regis2", "logged")
    @topicdetailpage.goto_topicdetail_page("engagement")
    @topicdetailpage.check_post_filter("ques")
    assert !@topicdetailpage.topic_signin_widget.present?
    @topicdetailpage.newline
  end

  def test_p1_00320_topicdetailpage_check_top_contributor_widget_work
    @topicdetailpage.goto_topicdetail_page("engagement2")
    @topicdetailpage.check_top_contributor_widget_work
    @topicdetailpage.newline
  end

  def test_p1_SET2_00330_topicdetailpage_check_featured_topic_widget_work
    @topicdetailpage.main_landing("regular", "logged")
    @topicdetailpage.goto_topicdetail_page("engagement2")
    @topicdetailpage.check_featured_topic_widget_work
    @topicdetailpage.newline
  end

  def test_p1_SET2_00340_topicdetailpage_check_featured_topic_link_img_and_widget_title
    @topicdetailpage.goto_topicdetail_page("engagement2")
    @topicdetailpage.check_featured_topic_widget
    @topicdetailpage.check_featured_topic_widget_title
    assert @topicdetailpage.topic_featured_topic_widget_title.present? 
    @topicdetailpage.check_featured_topic_widget_link_and_img
    @topicdetailpage.newline
  end

  def test_p1_00350_topicdetailpage_check_popular_discussion_widget_work
    @topicdetailpage.goto_topicdetail_page("engagement2")
    @topicdetailpage.check_popular_discussion_widget_work
    @topicdetailpage.newline
  end

  def test_p1_00360_topicdetailpage_check_popular_discussion_widget_like_author_link_img_and_title
    @topicdetailpage.goto_topicdetail_page("engagement2")
    @topicdetailpage.check_popular_discussion_widget_title
    assert @topicdetailpage.topic_popular_disc_widget_title.present?
    @topicdetailpage.check_popular_discussion_widget_like_icon_and_author_link_and_img
    @topicdetailpage.newline
  end


  def test_p1_SET2_00370_topicdetailpage_check_popular_answer_widget_work
    @topicdetailpage.goto_topicdetail_page("support")
    @topicdetailpage.check_popular_answer_widget_work
    @topicdetailpage.newline
  end

  def test_p1_SET2_00380_topicdetailpage_check_popular_answer_widget_like_author_link_img_and_title
    @topicdetailpage.goto_topicdetail_page("support")
    @topicdetailpage.check_popular_answer_widget_title
    assert @topicdetailpage.topic_popular_answer_widget_title.present?
    @topicdetailpage.check_popular_answer_widget_like_icon_and_author_link_and_img
    @topicdetailpage.newline
  end

  def test_p1_SET2_00390_topicdetailpage_check_featured_post_widget_work
    @topicdetailpage.main_landing("regular", "logged")
   
    @topicdetailpage.goto_topicdetail_page("support")
    @topicdetailpage.check_featured_post_widget_work
    @topicdetailpage.newline
  end

  def test_p1_SET2_00400_topicdetailpage_check_featured_post_widget_author_link_img_and_title
    @topicdetailpage.goto_topicdetail_page("support")
    @topicdetailpage.check_featured_post_widget_title
    assert @topicdetailpage.topic_featured_post_widget_title.present?
    @topicdetailpage.check_featured_post_widget_author_link_and_img
    @topicdetailpage.newline
  end

  def test_p1_SET2_00410_topicdetailpage_check_open_question_widget_work
    @topicdetailpage.goto_topicdetail_page("support")
    @topicdetailpage.check_open_question_widget_work
    @topicdetailpage.newline
  end

  def test_p1_SET2_00420_topicdetailpage_check_open_question_widget_author_link_img_and_title
    @topicdetailpage.goto_topicdetail_page("support")
    @topicdetailpage.check_open_question_widget_title
    assert @topicdetailpage.topic_open_q_widget_title.present?
    @topicdetailpage.check_open_question_widget_author_link_and_img
    @topicdetailpage.newline
  end

  ################ ADMIN user test ###############

  def test_p1_00421_topicdetailpage_check_b_filter_admin
    @topicdetailpage.main_landing("regular", "logged")
    @topicdetailpage.goto_topicdetail_page("engagement")
    @topicdetailpage.check_post_filter("blog")
    assert @topicdetailpage.topic_post.present?
    assert @topicdetailpage.topic_b_icon.present?

    @topicdetailpage.check_post_filter_button("blog", "logged")
    assert @topicdetailpage.topic_new_b_button.present?
    @topicdetailpage.newline
  end
  
  def test_p1_SET2_00430_topicdetailpage_check_admin_button
    @topicdetailpage.goto_topicdetail_page("engagement")
    @topicdetailpage.check_admin_button("logged")
    assert @topicdetailpage.topic_edit_button.present?
    assert @topicdetailpage.topic_feature_button.present? || @topicdetailpage.topic_unfeature_button.present?
    assert @topicdetailpage.topic_deactivate_button.present?
    @topicdetailpage.newline
  end

  def test_p1_00440_topicdetailpage_edit_a_topic
    @topicdetailpage.main_landing("regular", "logged")
    @topicdetailpage.goto_topicdetail_page("engagement2")
    @topicdetailpage.edit_a_topic
    @topicdetailpage.newline
  end

  def test_p1_00450_topicdetailpage_feature_unfeature_a_topic
    @topicdetailpage.main_landing("regular", "logged")
    @topicdetailpage.goto_topicdetail_page("engagement")
    @topicdetailpage.feature_a_topic
    assert @topicdetailpage.topic_unfeature_button.present?
    @topicdetailpage.unfeature_a_topic
    assert @topicdetailpage.topic_feature_button.present?
    @topicdetailpage.newline
  end

  def xtest_00460_activate_deactivate_a_topic
    @topicdetailpage.main_landing("regular", "logged")
    @topicdetailpage.goto_topicdetail_page("engagement2")
    @topicdetailpage.deactivate_a_topic
    assert @topicdetailpage.topic_activate_button.present?
    @topicdetailpage.activate_a_topic
    assert @topicdetailpage.topic_deactivate_button.present?
    @topicdetailpage.newline
  end
end

  
