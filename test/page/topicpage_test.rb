require 'watir_test'
require 'pages/community/home'
require 'pages/community/topic_list'
require 'pages/community/topicdetail'
require 'pages/community/searchpage'

class TopicTest < WatirTest

  def setup
    super
    @community_home_page = Pages::Community::Home.new(@config)
    @community_topiclist_page = Pages::Community::TopicList.new(@config)
    @community_topicdetail_page = Pages::Community::TopicDetail.new(@config)
    @community_search_page = Pages::Community::Search.new(@config)
    @community_login_page = Pages::Community::Login.new(@config)

    puts "[[[ #{name} ::: nil ]]]" if @config.verbose?
    @browser = @c.browser
    @community_home_page.start!(user_for_test)

    @num_topics_in_page = 12
    @follow_text = "Follow"
    @following_text = "Following"
    @unfollow_text = "Unfollow"
  end

  def teardown
    super
  end

  def test_00010_topicspage_loads
    @community_topiclist_page.navigate_in
    assert @browser.body.present?
    assert @community_topiclist_page.topics_grid_view.present?
  end

  def test_00020_topicspage_network_breadcrumb
    @community_topiclist_page.navigate_in
    @community_topiclist_page.check_breadcrumb_link
    assert @community_home_page.home.present?
  end

  def test_00030_topicspage_search_bar_present
    @community_topiclist_page.navigate_in
    @community_topiclist_page.check_page_search_bar
    assert @community_home_page.search_bar.present?
  end

  def test_00040_topicspage_search_works
    @community_topiclist_page.navigate_in
    @community_search_page.search("test")
    assert @community_search_page.results_keyword.text.include?("test"), 'keyword should be present in count results found for: "test"'
  end

  def test_00050_topic_sort_by_name
    @community_topiclist_page.navigate_in
    @browser.wait_until($t) { @community_topiclist_page.topic_tile.present? }
    @community_topicdetail_page.topic_sort_by_name
  end

  def test_00060_check_topics_list_view
    @community_topiclist_page.goto_topics_list_view
    assert @community_topiclist_page.topics_list_view_link_selected.present?
    assert @community_topiclist_page.topic_listed_row.present?
  end

  def test_00070_go_to_topic_detail_from_grid_view
    @community_topiclist_page.navigate_in
    @community_topiclist_page.goto_topic_detail_page_from_topictile_on_grid_view
    assert @community_topicdetail_page.topicdetail.present?
  end

  def test_00080_go_to_topic_detail_from_list_view
    @community_topiclist_page.goto_topics_list_view
    @community_topiclist_page.goto_topic_detail_page_from_topicname_on_list_view
    assert @community_topicdetail_page.topicdetail.present?
  end

  def test_00090_no_activated_topics_filter_for_anon_users
    @community_topiclist_page.navigate_in
    if @community_login_page.user_dropdown.present?
      @community_login_page.logout!
    end
    assert_equal false, @community_topiclist_page.activated_topics_filter_button.present?
  end

  def test_00100_topicspage_follow_or_unfollow_topic_for_anon_user
    @community_topiclist_page.navigate_in
    if @community_login_page.user_dropdown.present?
      @community_login_page.logout!
    end
    follow_unfollow_button = @community_topiclist_page.all_topic_follow_unfollow_buttons[0]
    assert_includes [@follow_text,@following_text, @unfollow_text], follow_unfollow_button.text
    follow_unfollow_button.click
    @browser.wait_until($t) { @community_login_page.login_body.present? }
    assert @community_login_page.login_body.present?
  end

  def test_00200_no_new_topic_create_button_for_anon_user
    @community_topiclist_page.navigate_in
    if @community_login_page.user_dropdown.present?
      @community_login_page.logout!
    end
    assert_equal false, @community_topiclist_page.topic_create_link.present?
  end

  user :regular_user1
  def test_00300_no_activated_topics_filter_for_reg_users
    @community_topiclist_page.navigate_in
    assert_equal false, @community_topiclist_page.activated_topics_filter_button.present?
  end

  user :regular_user1
  def test_00400_no_new_topic_create_button_for_reg_user
    @community_topiclist_page.navigate_in
    assert_equal false, @community_topiclist_page.topic_create_link.present?
  end

  def test_00500_topicspage_show_more_not_present
    @community_topiclist_page.navigate_in
    if @community_topiclist_page.all_topic_tiles.length < @num_topics_in_page
      assert_equal false, @community_topiclist_page.show_more_button.present?
    end
  end

  def test_00600_topicspage_show_more_works
    @community_topiclist_page.navigate_in
    if @community_topiclist_page.show_more_button.present?
      num_existing_topics = @community_topiclist_page.all_topic_tiles.length
      assert_equal @num_topics_in_page, num_existing_topics, "should have 12 topics at least"
      @community_topiclist_page.show_more_button.click
      @browser.wait_until {
        @community_topiclist_page.all_topic_tiles.length > num_existing_topics
      }
      num_total_topics = @community_topiclist_page.all_topic_tiles.length
      assert_operator num_total_topics, :>, num_existing_topics, "total topics should be more than existing topics or show more button should not be present"
    end
  end

  user :network_admin
  def test_00900_new_topic_create_button_for_admin_user
    @community_topiclist_page.navigate_in
    assert @community_topiclist_page.topic_create_link.present?
  end

  def test_01000_create_new_engagement_topic
    @community_topiclist_page.navigate_in
    @community_topiclist_page.click_new_topic_create_link
    assert @community_topicdetail_page.new_topic_title.present?
    @community_topiclist_page.set_new_topic_details("engagement", false)
    @community_topiclist_page.image_set("filetile")
    @community_topiclist_page.topic_create_steps_after_image_set("filetile")
    @browser.wait_until($t) { @community_topiclist_page.image_upload_link.present? }
    @community_topiclist_page.image_set("filebanner")
    @community_topiclist_page.topic_create_steps_after_image_set("filebanner")
  end

  def test_01100_topicspage_follow_topic_reg_user
    @community_topiclist_page.navigate_in
    topic_title = "A Watir Topic With Many Posts"
    @community_topiclist_page.show_topic(topic_title)
    @community_topiclist_page.topiccard_list.follow_topic(topic_title)
    topicdetail_page = @community_topiclist_page.go_to_topic(topic_title)
    @browser.wait_until { topicdetail_page.topic_unfollow_button.present? }
    assert topicdetail_page.topic_unfollow_button.present?
  end

  def test_01200_topicspage_unfollow_topic
    @community_topiclist_page.navigate_in
    topic_title = "A Watir Topic With Many Posts"
    @community_topiclist_page.show_topic(topic_title)
    @community_topiclist_page.topiccard_list.unfollow_topic(topic_title)
    topicdetail_page = @community_topiclist_page.go_to_topic(topic_title)
    @browser.wait_until { topicdetail_page.topic_follow_button.present? }
    assert topicdetail_page.topic_follow_button.present?
  end

  def test_01300_topicspage_activated_topics
    @community_topiclist_page.goto_topics_page
    @community_topiclist_page.topics_filter_by_activated_button
    topic_title = @community_topiclist_page.goto_topic_detail_page_from_topictile_on_grid_view
    assert @community_topicdetail_page.topic_deactivate_button.present?

  end
end