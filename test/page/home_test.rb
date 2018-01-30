require 'watir_test'
require 'pages/community/home'
require 'pages/community/searchpage'
require 'pages/community/login'
require 'pages/community/topicdetail'
require 'pages/community/conversationdetail'
require 'pages/community/topic_list'
require 'pages/community/profile'

class HomeTest < WatirTest
  attr_reader :t
  def setup
    super
    @home_page = Pages::Community::Home.new(@config)
    @search_page = Pages::Community::Search.new(@config)
    @login_page = Pages::Community::Login.new(@config)
    @layout_page = Pages::Community::Layout.new(@config)
    @topicdetail_page = Pages::Community::TopicDetail.new(@config)
    @topiclist_page = Pages::Community::TopicList.new(@config)
    @convdetail_page = Pages::Community::ConversationDetail.new(@config)
    @profile_page = Pages::Community::Profile.new(@config)

    @topic_for_home_test = "A Watir Topic"

    # assigning @current_page helps error reporting
    #  give good contextual data
    @current_page = @home_page
    puts "[[[ #{name} ::: #{user_for_test} ]]]" if @config.verbose?
    @browser = @config.browser

    @home_page.start!(user_for_test)
  end

  def teardown
    super
  end

  user :anonymous
  p1
  def test_00010_homepage
    search_placeholder = @home_page.search_bar.when_present.placeholder

    title = @c.network_name + " Home"

    assert_all_keys({
      :body => @browser.body.present?,
      :banner => @home_page.homebanner.present? || @home_page.home_inverted_banner.present?,
      :search_bar => @home_page.search_bar.present?, ## TO DO Community name in search bar in a variable to ensure test pass with locale change ##
      :footer => @home_page.footer.present?,
      :title_match => title,
    })
  end

  def test_00020_homepage_search
    @browser.wait_until {@home_page.search_middle_input.present? }
    @browser.wait_until {@home_page.search_bar.present? }
    
    img_position=@home_page.get_img_position_by_css
    input_position=@home_page.get_input_position_by_css
    topic_postion=@home_page.get_topic_position_by_css
    assert input_position > img_position
    assert topic_postion > input_position

    search_keyword = "watir"
    @layout_page.search_at_topnav(search_keyword)
    assert @search_page.results_searched_out?(keyword: search_keyword)
  end

  #============= homepage featured topic widget tests ==============#
  def test_00030_homepage_topic_widget
    @browser.wait_until { @home_page.home_featured_topic_row.present? }
    assert @home_page.home_featured_topic.present?
  end

  def test_00040_homepage_topic_widget_viewall
    @home_page.accept_policy_warning
    @browser.wait_until { @home_page.featured_topic_viewall.present? }
    @home_page.accept_policy_warning
    @home_page.featured_topic_viewall.click
    @browser.wait_until { @home_page.topic_page.present?}
    assert @home_page.topic_page.present?
  end

  def test_00050_homepage_topic_detail
    @browser.wait_until { @home_page.home_featured_topic_row.present? }
    # @browser.execute_script("window.scrollBy(0,3000)")
    @browser.wait_until { @home_page.home_featured_topic_link.present? }
    @home_page.home_featured_topic_link.when_present.click
    @browser.wait_until { @home_page.topicdetail.present? }
    assert @home_page.topicdetail.present?
  end

  def test_00060_homepage_topic_widget_post_count
    @browser.wait_until { @home_page.home_featured_topic_row.present? }
    @browser.wait_until { @home_page.home_featured_topic_post_count.present? }
    assert @home_page.home_featured_topic_post_count.present?
  end

  def test_00070_homepage_topic_widget_last_post
    @browser.wait_until { @home_page.home_featured_topic_row.present? }
    @browser.wait_until { @home_page.home_featured_topic_last_post.present? }
    assert @home_page.home_featured_topic_last_post.present?
  end

  #================ homepage open questions widget tests ========#
  def test_00090_homepage_open_q_conv_link
    @browser.wait_until { @home_page.open_questions_widget.present? }
    @browser.wait_until { @home_page.open_questions_widget.posts.size > 0 }

    # verify the title link would redirect to conversation page.
    q_title = @home_page.open_questions_widget.posts[0].title
    @home_page.open_questions_widget.posts[0].click_title_link
    @browser.wait_until { @convdetail_page.conv_detail.present? }
    assert_equal @convdetail_page.conv_title.when_present.text, q_title, "title doesn't match"

    @home_page.navigate_in
    @browser.wait_until { @home_page.open_questions_widget.posts.size > 0 }

    # verify avatar link would redirect to profile page
    @home_page.open_questions_widget.posts[0].click_avatar
    @browser.wait_until { @profile_page.profile_page.present? }
    author_name = @profile_page.profile_page_author_name_betaon.when_present.text

    @home_page.navigate_in
    @browser.wait_until { @home_page.open_questions_widget.posts.size > 0 }

    # verify author link would redirect to profile page
    @home_page.open_questions_widget.posts[0].click_author_link
    @browser.wait_until { @profile_page.profile_page.present? }
    assert_equal @profile_page.profile_page_author_name_betaon.when_present.text, author_name, "Author doesn't match"

    @home_page.navigate_in
    @browser.wait_until { @home_page.open_questions_widget.posts.size > 0 }

    # verify topic link would redirect to the correct topic page
    post_in_topic = @home_page.open_questions_widget.posts[0].in_topic_link.when_present.text

    @home_page.open_questions_widget.posts[0].click_topic_link
    @browser.wait_until { @topicdetail_page.topic_filter.present? }
    assert_equal @topicdetail_page.topic_title.when_present.text, post_in_topic, "Title doesn't match"
  end

  user :anonymous
  p2
  def test_00100_homepage_open_q_widget_action_icons_anonymous
    @browser.wait_until { @home_page.open_questions_widget.present? }
    @browser.wait_until { @home_page.open_questions_widget.posts.size > 0 }

    # verify like icon clickable
    liked_before = @home_page.open_questions_widget.posts[0].liked?
    @home_page.open_questions_widget.posts[0].click_like_icon

    @browser.wait_until { @login_page.login_body.present? }

    @home_page.navigate_in
    @browser.wait_until { @home_page.open_questions_widget.posts.size > 0 }

    # verify reply icon redirect to conversation page
    q_title = @home_page.open_questions_widget.posts[0].title
    @home_page.open_questions_widget.posts[0].click_reply_icon
    @browser.wait_until { @convdetail_page.conv_detail.present? }
    assert_equal @convdetail_page.conv_title.when_present.text, q_title, "title doesn't match"
  end

  user :regular_user3
  p2
  def test_00101_homepage_open_q_widget_action_icons_regular
    @browser.wait_until { @home_page.open_questions_widget.present? }
    @browser.wait_until { @home_page.open_questions_widget.posts.size > 0 }

    # verify like icon clickable
    liked_before = @home_page.open_questions_widget.posts[0].liked?
    @home_page.open_questions_widget.posts[0].click_like_icon

    if liked_before
      @browser.wait_until { !@home_page.open_questions_widget.posts[0].nil? && !@home_page.open_questions_widget.posts[0].liked? }
    else
      @browser.wait_until { !@home_page.open_questions_widget.posts[0].nil? && @home_page.open_questions_widget.posts[0].liked? }
    end  

    # verify reply icon redirect to conversation page
    q_title = @home_page.open_questions_widget.posts[0].title
    @home_page.open_questions_widget.posts[0].click_reply_icon
    @browser.wait_until { @convdetail_page.conv_detail.present? }
    assert_equal @convdetail_page.conv_title.when_present.text, q_title, "title doesn't match"
  end  

  user :anonymous
  p1
  def test_00110_homepage_open_q_viewall
    @browser.wait_until { @home_page.open_questions_widget.present? }
    @browser.wait_until { @home_page.open_questions_widget.posts.size > 0 }

    # verify view all link redirect to search page
    @home_page.open_questions_widget.click_view_all_link
    @browser.wait_until { @search_page.search_result_posts.size > 0 }
    assert @search_page.search_type_filter(:unanswered).checked?
  end

  #============ homepage featured questions widget tests =============#
  def test_00140_homepage_featured_q_widget_conv_links
    @browser.wait_until { @home_page.featured_q_widget.present? }
    @browser.wait_until { @home_page.featured_q_widget.posts.size > 0 }

    # verify the title link would redirect to conversation page.
    q_title = @home_page.featured_q_widget.posts[0].title
    @home_page.featured_q_widget.posts[0].click_title_link
    @browser.wait_until { @convdetail_page.conv_detail.present? }
    assert_equal @convdetail_page.conv_title.when_present.text, q_title, "title doesn't match"

    @home_page.navigate_in
    @browser.wait_until { @home_page.featured_q_widget.posts.size > 0 }

    # verify avatar link would redirect to profile page
    @home_page.featured_q_widget.posts[0].click_avatar
    @browser.wait_until { @profile_page.profile_page.present? }
    author_name = @profile_page.profile_page_author_name_betaon.when_present.text

    @home_page.navigate_in
    @browser.wait_until { @home_page.featured_q_widget.posts.size > 0 }

    # verify author link would redirect to profile page
    @home_page.featured_q_widget.posts[0].click_author_link
    @browser.wait_until { @profile_page.profile_page.present? }
    assert_equal @profile_page.profile_page_author_name_betaon.when_present.text, author_name, "Author doesn't match"

    @home_page.navigate_in
    @browser.wait_until { @home_page.featured_q_widget.posts.size > 0 }

    # verify topic link would redirect to the correct topic page
    post_in_topic = @home_page.featured_q_widget.posts[0].in_topic_link.when_present.text

    @home_page.featured_q_widget.posts[0].click_topic_link
    @browser.wait_until { @topicdetail_page.topic_filter.present? }
    assert_equal @topicdetail_page.topic_title.when_present.text, post_in_topic, "Title doesn't match"
  end

  def test_00150_homepage_featured_q_widget_viewall
    @browser.wait_until { @home_page.featured_q_widget.present? }
    @browser.wait_until { @home_page.featured_q_widget.posts.size > 0 }

    # verify view all link redirect to search page
    @home_page.featured_q_widget.click_view_all_link

    # if @home_page.search_no_match.present?
    #   #@login_page = Pages::Community::Login.new(@config)
    #   @login_page.login!(@c.users[:network_admin])
    #   @topicdetail_page = @topiclist_page.go_to_topic(@topic_for_home_test)
    #   # Open the first question)
    #   @topicdetail_page.goto_conversation(type: :question)
    #   @convdetail_page.feature_a_conv
    #   @home_page.logout!
    #   @browser.goto @home_page.home_url
    #   @browser.wait_until { @home_page.featured_question_viewall.present? }
    #   @home_page.featured_question_viewall.click
    # end
    @browser.wait_until { @search_page.search_result_posts.size > 0 }
    assert @search_page.search_type_filter(:questions).collapsed?
    @search_page.search_type_filter(:questions).expand
    @browser.wait_until { !@search_page.search_type_filter(:featured_q).nil? }
    assert !@search_page.search_type_filter(:featured_q).checked?
  end

  #============ homepage featured blogs widget tests ==============#
  def test_00160_homepage_featured_b_widget
    # # @browser.execute_script("window.scrollBy(0,8000)")
    # @browser.wait_until { @home_page.home_featured_blog.present? }
    # assert @home_page.home_featured_blog.present?
    # assert @home_page.home_featured_b_desc.present?
    @browser.wait_until { @home_page.featured_b_widget.present? }
    @browser.wait_until { @home_page.featured_b_widget.posts.size > 0 }

    # verify the title link would redirect to conversation page.
    q_title = @home_page.featured_b_widget.posts[0].title
    @home_page.featured_b_widget.posts[0].click_title_link
    @browser.wait_until { @convdetail_page.conv_detail.present? }
    assert_equal @convdetail_page.conv_title.when_present.text, q_title, "title doesn't match"

    @home_page.navigate_in
    @browser.wait_until { @home_page.featured_b_widget.posts.size > 0 }

    # verify avatar link would redirect to profile page
    @home_page.featured_b_widget.posts[0].click_avatar
    @browser.wait_until { @profile_page.profile_page.present? }
    author_name = @profile_page.profile_page_author_name_betaon.when_present.text

    @home_page.navigate_in
    @browser.wait_until { @home_page.featured_b_widget.posts.size > 0 }

    # verify author link would redirect to profile page
    @home_page.featured_b_widget.posts[0].click_author_link
    @browser.wait_until { @profile_page.profile_page.present? }
    assert_equal @profile_page.profile_page_author_name_betaon.when_present.text, author_name, "Author doesn't match"

    @home_page.navigate_in
    @browser.wait_until { @home_page.featured_b_widget.posts.size > 0 }

    # verify topic link would redirect to the correct topic page
    post_in_topic = @home_page.featured_b_widget.posts[0].in_topic_link.when_present.text

    @home_page.featured_b_widget.posts[0].click_topic_link
    @browser.wait_until { @topicdetail_page.topic_filter.present? }
    assert_equal @topicdetail_page.topic_title.when_present.text, post_in_topic, "Title doesn't match"
  end

  def test_00170_homepage_featured_b_widget_viewall
    @browser.wait_until { @home_page.featured_b_widget.present? }
    @browser.wait_until { @home_page.featured_b_widget.posts.size > 0 }

    # verify view all link redirect to search page
    @home_page.featured_b_widget.click_view_all_link

    # if @home_page.search_no_match.present?
    #  # @login_page = Pages::Community::Login.new(@config)
    #   @login_page.login!(@c.users[:network_admin])
    #   @topicdetail_page = @topiclist_page.go_to_topic(@topic_for_home_test)
    #   # Open the first blog
    #   @topicdetail_page.goto_conversation(type: :blog)
    #   @convdetail_page.feature_a_conv
    #   @home_page.logout!
    #   @browser.goto @home_page.home_url
    #   @browser.execute_script("window.scrollBy(0,12000)")
    #   @browser.wait_until { @home_page.featured_blog_viewall.present? }
    #   @home_page.featured_blog_viewall.click
    # end
    @browser.wait_until { @search_page.search_result_posts.size > 0 }
    assert @search_page.search_type_filter(:blogs).collapsed?
    @search_page.search_type_filter(:blogs).expand
    @browser.wait_until { !@search_page.search_type_filter(:featured_b).nil? }
    assert !@search_page.search_type_filter(:featured_b).checked?
  end

  #============ homepage reviews widget tests ==============#

  def test_00171_homepage_featured_review_widget
    @browser.wait_until { @home_page.featured_r_widget.present? }
    @browser.wait_until { @home_page.featured_r_widget.posts.size > 0 }

    # verify the title link would redirect to conversation page.
    q_title = @home_page.featured_r_widget.posts[0].title
    @home_page.featured_r_widget.posts[0].click_title_link
    @browser.wait_until { @convdetail_page.conv_detail.present? }
    assert_equal @convdetail_page.conv_title.when_present.text, q_title, "title doesn't match"

    @home_page.navigate_in
    @browser.wait_until { @home_page.featured_r_widget.posts.size > 0 }

    # verify avatar link would redirect to profile page
    @home_page.featured_r_widget.posts[0].click_avatar
    @browser.wait_until { @profile_page.profile_page.present? }
    author_name = @profile_page.profile_page_author_name_betaon.when_present.text

    @home_page.navigate_in
    @browser.wait_until { @home_page.featured_r_widget.posts.size > 0 }

    # verify author link would redirect to profile page
    @home_page.featured_r_widget.posts[0].click_author_link
    @browser.wait_until { @profile_page.profile_page.present? }
    assert_equal @profile_page.profile_page_author_name_betaon.when_present.text, author_name, "Author doesn't match"

    @home_page.navigate_in
    @browser.wait_until { @home_page.featured_r_widget.posts.size > 0 }

    # verify topic link would redirect to the correct topic page
    post_in_topic = @home_page.featured_r_widget.posts[0].in_topic_link.when_present.text

    @home_page.featured_r_widget.posts[0].click_topic_link
    @browser.wait_until { @topicdetail_page.topic_filter.present? }
    assert_equal @topicdetail_page.topic_title.when_present.text, post_in_topic, "Title doesn't match"
  end

  def test_00172_homepage_featured_review_widget_viewall
    @browser.wait_until { @home_page.featured_r_widget.present? }
    @browser.wait_until { @home_page.featured_r_widget.posts.size > 0 }

    # verify view all link redirect to search page
    @home_page.featured_r_widget.click_view_all_link

    # if @home_page.search_no_match.present?
    #   @login_page.login!(@c.users[:network_admin])
    #   @topicdetail_page = @topiclist_page.go_to_topic(@topic_for_home_test)
    #   # Open the first review
    #   @topicdetail_page.goto_conversation(type: :review)
    #   @convdetail_page.feature_a_conv
    #   @home_page.logout!
    #   @browser.goto @home_page.home_url
    #   @browser.wait_until { @home_page.featured_review_viewall.present? }
    #   @home_page.featured_review_viewall.click
    # end

    @browser.wait_until { @search_page.search_result_posts.size > 0 }
    assert @search_page.search_type_filter(:reviews).checked?
  end

  #============== homepage footer tests ===================#
  def test_00180_homepage_footer
    # @browser.execute_script("window.scrollBy(0,10000)")
    @browser.wait_until { @home_page.footer.present? }
    assert @home_page.footer.present?
  end

  user :regular_user3
  p1
  def test_00190_home_page_edit_banner_button_for_regular
    @browser.goto @home_page.home_url
    @browser.wait_until { @home_page.home_featured_topic_row.present? }
    assert @home_page.home_edit.present? != true
  end

 ###########################################TO DO ###################################
  #========== ADMIN USER HOMEPAGE TESTS ===================#
  #===========================================================#

  # Comment this case because discussion is removed.
 # user :network_admin
 # p1
 # def test_00200_homepage_feature_a_disc
 #    #@login_page = Pages::Community::Login.new(@config)
 #    @login_page.login!(@c.users[:network_admin])
 #    @topicdetail_page = Pages::Community::TopicDetail.new(@config)
 #    @topicdetail_page.topic_detail("A Watir Topic")
 #    @topicdetail_page.choose_post_type("discussion")
 #    @convdetail_page = Pages::Community::ConversationDetail.new(@config)
 #    @convdetail_page.conversation_detail("discussion")
 #    conv_title = @convdetail_page.conv_title.text
 #    if @convdetail_page.conv_feature.present?
 #      @convdetail_page.unfeature_root_post
 #    end
 #    @convdetail_page.feature_root_post
 #    @browser.goto @home_page.home_url
 #    # @browser.execute_script("window.scrollBy(0,5000)")
 #    @browser.wait_until { @home_page.home_featured_discussion.present? }
 #    @browser.wait_until { @home_page.featured_discussion_icon.present? }
 #    @browser.wait_until { @home_page.featured_discussion_conv.present? }
 #    assert @home_page.featured_discussion_conv.text.include? conv_title

 #    conv_title = @home_page.home_featured_d_link.text
 #    @browser.wait_until { @home_page.home_featured_d_link.present? }
 #    @home_page.home_featured_d_link.click
 #    @convdetail_page = Pages::Community::ConversationDetail.new(@config)
 #    @browser.wait_until { @convdetail_page.conv_detail.present? }
 #    @convdetail_page.unfeature_root_post
 #    @browser.goto @home_page.home_url
 #    @browser.wait_until { @home_page.home_featured_discussion.present? }
 #    @browser.wait_until { @home_page.featured_discussion_conv.present? }
 #    assert (@home_page.featured_discussion_conv.text.include?(conv_title) != true)
 #    end

  user :network_admin
  p1
  def test_00200_homepage_feature_a_question
    @topicdetail_page = @topiclist_page.go_to_topic(@topic_for_home_test)
    # Open the first question
    @topicdetail_page.goto_conversation(type: :question)
    conv_title = @convdetail_page.conv_title.text
    if @convdetail_page.conv_feature.present?
      @convdetail_page.unfeature_root_post
    end
    @convdetail_page.feature_root_post
    @browser.goto @home_page.home_url
    # @browser.execute_script("window.scrollBy(0,5000)")
    @browser.wait_until { @home_page.home_featured_question.present? }
    @browser.wait_until { @home_page.featured_question_icon.present? }
    @browser.wait_until { @home_page.featured_question_conv.present? }
    assert @home_page.featured_question_conv.text.include? conv_title

    conv_title = @home_page.home_featured_q_link.text
    @browser.wait_until { @home_page.home_featured_q_link.present? }
    @home_page.home_featured_q_link.click
    @browser.wait_until { @convdetail_page.conv_detail.present? }
    @convdetail_page.unfeature_root_post
    @browser.goto @home_page.home_url
    @browser.wait_until { @home_page.home_featured_question.present? }
    @browser.wait_until { @home_page.featured_question_conv.present? }
    assert (@home_page.featured_question_conv.text.include?(conv_title) != true)
  end

  def test_00210_homepage_feature_a_blog
    @topicdetail_page = @topiclist_page.go_to_topic(@topic_for_home_test)
    # Open the first blog
    @topicdetail_page.goto_conversation(type: :blog)
    conv_title = @convdetail_page.conv_title.text
    if @convdetail_page.conv_feature.present?
      @convdetail_page.unfeature_root_post
    end
    @convdetail_page.feature_root_post
    @browser.goto @home_page.home_url
    # @browser.execute_script("window.scrollBy(0,8000)")

    @browser.wait_until { @home_page.featured_b_widget.present? }
    @browser.wait_until { !@home_page.featured_b_widget.posts[0].nil? && @home_page.featured_b_widget.posts[0].featured? }
    
    conv_title = @home_page.featured_b_widget.posts[0].title
    @home_page.featured_b_widget.posts[0].click_title_link
    @browser.wait_until { @convdetail_page.conv_detail.present? }
    assert @convdetail_page.conv_title.when_present.text.include? conv_title

    @convdetail_page.unfeature_root_post
    @browser.goto @home_page.home_url
    @browser.wait_until { @home_page.featured_b_widget.present? }
    @browser.wait_until { @home_page.featured_b_widget.posts.size > 0 }

    @home_page.featured_b_widget.posts.each do |b|
      puts "post #{b.title} is featured: #{b.featured?}"
      assert b.title != conv_title || !b.featured?
    end 
  end

  def test_00220_homepage_feature_topic_and_check_widget
    @topicdetail_page = @topiclist_page.go_to_topic(@topic_for_home_test)
    @browser.wait_until { @topicdetail_page.topic_filter.present? }
    topicname = @topicdetail_page.click_topic_feature
    @browser.wait_until { @topicdetail_page.topic_unfeature.present? }
    @browser.goto @home_page.home_url
    @browser.wait_until { @home_page.home_featured_topic_row.present? }
    assert topicname.include?(@home_page.home_featured_topic_link.when_present.text.chomp('...'))
    @browser.wait_until { @home_page.home_featured_topic_link.present? }
    @home_page.home_featured_topic_link.when_present.click
    @topicdetail_page = Pages::Community::TopicDetail.new(@config)
    @browser.wait_until { @topicdetail_page.topic_filter.present? }
    @topicdetail_page.click_topic_unfeature
  end

  user :network_admin
  p1

 def xtest_00240_homepage_locale_change
  #@login_page = Pages::Community::Login.new(@config)
  @login_page.login!(@c.users[user])  
  @home_page.change_home_locale("de") 
 end

  def test_00250_check_topic_carousel
    assert @home_page.carousel_topic_list.present?
    assert @home_page.carousel_left_page_btn.present?
    assert @home_page.carousel_right_page_btn.present?
    assert @home_page.carousel_pagination.present?
    @browser.wait_until { @home_page.carousel_left_topic.present?}
    carousel_left_topic_name = @home_page.carousel_left_topic_name
    @home_page.carousel_right_page_btn.when_present.click
    # @browser.wait_until { @home_page.carousel_active_topic.present?}
    sleep(2)
    assert carousel_left_topic_name != @home_page.carousel_left_topic_name
    @home_page.carousel_left_page_btn.when_present.click
    # @browser.wait_until { @home_page.carousel_active_topic.present?}
    sleep(2)
    assert carousel_left_topic_name == @home_page.carousel_left_topic_name
  end
end