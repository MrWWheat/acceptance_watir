require 'watir_test'
require 'pages/community/home'
require 'pages/community/layout'
require 'pages/community/searchpage'
require 'pages/community/event_list'
require 'pages/community/topic_list'
require 'pages/community/idea_list'
require 'pages/community/topicdetail'
require 'pages/community/admin_moderation'
require 'pages/community/conversationdetail'
require 'pages/community/topicdetail'

class UniversalSearchTest < WatirTest

  def setup
    super
    @community_home_page = Pages::Community::Home.new(@config)
    @community_search_page = Pages::Community::Search.new(@config)
    @topicdetail_page = Pages::Community::TopicDetail.new(@config)
    @topic_list_page = Pages::Community::TopicList.new(@config)
    @event_list_page = Pages::Community::EventList.new(@config)
    @idea_list_page = Pages::Community::IdeaList.new(@config)
    @admin_mod_page = Pages::Community::AdminModeration.new(@config)
    @convdetail_page = Pages::Community::ConversationDetail.new(@config)

    @browser = @c.browser
    @community_home_page.start!(user_for_test)
    @community_search_page.scroll_to_element @community_search_page.search_text_field

  end

  def test_00010_topnav_search_placeholder_exists
    @community_search_page.topnav_search_placeholder
    assert @community_search_page.topnav_search_bar_paceholder.present?
  end

  def test_00020_topnav_search_icon_exists
    @community_search_page.find_topnav_search_icon
    assert @community_search_page.topnav_search_icon.present?
  end

  def test_00030_search_dropdown_exists
    assert @community_search_page.search_dropdown("test")
  end

  def test_00040_search_dropdown_link_works
    assert @community_search_page.search_dropdown("test")
    first_search_suggestion = @community_search_page.all_search_dropdown_suggestions[0]
    search_keyword = first_search_suggestion.text
    first_search_suggestion.click
    @browser.send_keys :enter
    @browser.wait_until { @community_search_page.search_result_page.present? }
    assert @browser.wait_until { @community_search_page.results_page_search.text_field.present? }
    assert_equal search_keyword, @community_search_page.results_page_search.text_field.value
  end

  def test_00050_topnave_search_cancel_icon_works
    @community_search_page.search_input_cancel_icon
    assert @browser.wait_until {
      @community_search_page.search_cancel_icon.present?
    }
    @community_search_page.search_cancel_icon.click
    assert_equal "", @community_search_page.search_text_field.value
  end

  def test_00060_anypage_search_bar_cancel_icon_works
    @community_search_page.home_page_search_input_cancel_icon
    assert @browser.wait_until {
      @community_search_page.home_page_search_cancel_icon.present?
    }
    @community_search_page.home_page_search_cancel_icon.click
    assert_equal "", @community_search_page.home_page_search.text_field.value
  end

  def test_00070_search_results_found_text_on_search_results_page
    @community_search_page.search("test")
    assert @community_search_page.results_keyword.text.include?("test"), 'keyword should be present in count results found for: "test"'
  end

  def test_00080_searched_keyword_present_in_search_results
    keyword = "amrood_april"
    @community_search_page.search keyword
    @community_search_page.all_searched_result_items.each do |div|
      assert_match /#{keyword}/, div.text
    end
  end

  def test_00090_search_results_member_avatar_link
    @community_search_page.search "amrood_april"
    first_result = @community_search_page.all_searched_result_items[0]
    first_result_avatar = first_result.element(:css => ".media-object[alt*=person]")
    assert first_result_avatar.present?, "member avatar should be present"
    # assert first_result_avatar.href.include?("/profile/"), "link contains /profile/"
    first_result_avatar.when_present.click

    assert @browser.wait_until { @browser.url.include?("/profile/") }
    assert @browser.wait_until { @browser.div(:css => ".profile-box").present? }
  end

  def test_00100_search_results_conversation_member_link
    @community_search_page.search "amrood_april"
    first_result = @community_search_page.all_searched_result_items[0]

    first_result_member_link = first_result.link(:href => /profile/)
    assert first_result_member_link.present?, "member link should be present"
    first_result_member_link.when_present.click

    assert @browser.wait_until { @browser.url.include?("/profile/") }
    assert @browser.wait_until { @browser.div(:css => ".profile-box").present? }
  end

  def test_00110_search_results_conversation_title_link
    @community_search_page.search "amrood_april"
    first_result = @community_search_page.all_searched_result_items[0]
    conv_title_link = first_result.div(:class => "media-heading").link(:class=> "ember-view")
    assert conv_title_link.present?
    conv_title_link.when_present.click

    assert @browser.wait_until {
      @browser.h3(:class => "root-post-title").present?
    }
  end

  def test_00120_search_results_topic_title_link
    @community_search_page.search "amrood_april"
    first_result = @community_search_page.all_searched_result_items[0]

    topic_title_link = first_result.div(:class => "details").span(:class => "in-topic").link
    assert topic_title_link.present?
    topic_title_link_text = topic_title_link.text.strip

    topic_title_link.when_present.click
    assert @browser.wait_until {
      @browser.div(:class => "widget banner topic").present?
    }
    assert_equal topic_title_link_text, @browser.div(:class => "row title").h1s[0].text.strip
  end

  def test_00130_sort_default_sort_order_by_relevance
    @community_search_page.search "amrood_april"
    assert @community_search_page.sort_dropdown_toggle_link.present?
    assert_equal "Sorted by: Relevance", @community_search_page.sort_dropdown_toggle_link.text.strip
  end

  def test_00140_sort_dropdown_options_exist
    @community_search_page.search "amrood_april"
    @community_search_page.sort_dropdown_toggle_link.when_present.click
    assert_equal 4, @community_search_page.sort_dropdown_ul.lis.length
    assert_equal "Popular", @community_search_page.sort_dropdown_ul.lis[0].text
    assert_equal "Newest", @community_search_page.sort_dropdown_ul.lis[1].text
    assert_equal "Oldest", @community_search_page.sort_dropdown_ul.lis[2].text
    assert_equal "Relevance", @community_search_page.sort_dropdown_ul.lis[3].text
  end

  def test_00150_sort_search_results_by_newest
    results_list = [
        "amrood_april Quest one",
        "amrood_april Quest two",
        "amrood_april Quest three",
        "amrood_april Quest four"
    # Newest
    ].reverse

    @community_search_page.search "amrood_april"
    @community_search_page.click_sort_dropdown_option(1) # Newest
    @community_search_page.wait_results_load # For ui customization on. Ajax call instead of reloading page. 
    all_searched_result_items = @community_search_page.all_searched_result_items
    assert_equal results_list[0], all_searched_result_items[0].div(:class => "media-heading").text
    assert_equal results_list[1], all_searched_result_items[1].div(:class => "media-heading").text
    assert_equal results_list[2], all_searched_result_items[2].div(:class => "media-heading").text
    assert_equal results_list[3], all_searched_result_items[3].div(:class => "media-heading").text
  end

  def test_00160_sort_search_results_by_oldest

    results_list = [
        "amrood_april Quest one",
        "amrood_april Quest two",
        "amrood_april Quest three",
        "amrood_april Quest four"]

    @community_search_page.search "amrood_april"
    @community_search_page.click_sort_dropdown_option(2) #oldest
    all_searched_result_items = @community_search_page.all_searched_result_items
    @community_search_page.wait_results_load # For ui customization on. Ajax call instead of reloading page. 
    assert_equal results_list[0], all_searched_result_items[0].div(:class => "media-heading").text
    assert_equal results_list[1], all_searched_result_items[1].div(:class => "media-heading").text
    assert_equal results_list[2], all_searched_result_items[2].div(:class => "media-heading").text
    assert_equal results_list[3], all_searched_result_items[3].div(:class => "media-heading").text
  end

  def test_00170_recent_searches_widget
    search_keyword1 = "amrood_april"
    @community_search_page.search search_keyword1
    assert @browser.wait_until {
      @community_search_page.recent_search_widget.present?
    }
    assert @browser.wait_until {
      @community_search_page.recent_search_widget.links.length > 0
    }
    #EN-4117: saving search keywords to server and getting search keywords 
    # so as to show them onto Recent Search widget happen in random sequences.
    # So we have to refresh so that the search keywords retrieved for Recent Search widget are up to date.
    @browser.refresh 
    @community_search_page.wait_results_load
    # since recent searches widget would be updated by other cases in with search action made,
    # just verify the search text existing in the widget instead of the first one.
    @browser.wait_until { @community_search_page.recent_searches_widget.link(condition_val: search_keyword1).present? }
    # @browser.wait_until { search_keyword1 == @community_search_page.recent_search_widget.links(:css => ".media-list a")[0].text }
    # assert_equal search_keyword1, @community_search_page.recent_search_widget.links(:css => ".media-list a")[0].text
    search_keyword2 = "test"
    @community_search_page.search search_keyword2
    assert @browser.wait_until {
      @community_search_page.recent_search_widget.present?
    }
    assert @browser.wait_until {
      @community_search_page.recent_search_widget.links.length > 0
    }
    #EN-4117: saving search keywords to server and getting search keywords 
    # so as to show them onto Recent Search widget happen in random sequences.
    # So we have to refresh so that the search keywords retrieved for Recent Search widget are up to date.
    @browser.refresh 
    @community_search_page.wait_results_load
    @browser.wait_until { @community_search_page.recent_searches_widget.link(condition_val: search_keyword1).present? }
    @browser.wait_until { @community_search_page.recent_searches_widget.link(condition_val: search_keyword2).present? }

    # @browser.wait_until { search_keyword2 == @community_search_page.recent_search_widget.links(:css => ".media-list a")[0].text }
    # assert_equal search_keyword2, @community_search_page.recent_search_widget.links(:css => ".media-list a")[0].text
    # assert_equal search_keyword1, @community_search_page.recent_search_widget.links(:css => ".media-list a")[1].text
  end

  def test_00180_related_searches_widget
    search_keyword = "amrood_april"
    @community_search_page.search search_keyword
    assert @browser.wait_until {
      @community_search_page.related_search_widget.present?
    }
    assert @browser.wait_until {
      @community_search_page.related_search_widget.link(:text => search_keyword).present?
    }
  end
  
  def test_00190_pagination_links_state
    search_keyword = "watir"
    @community_search_page.search search_keyword
    assert @community_search_page.previous_page_link.present?
    assert @community_search_page.first_page_link.present?
    assert @community_search_page.next_page_link.present?
    assert @community_search_page.last_page_link.present?
    assert @community_search_page.page_link_number1.present?
    assert @community_search_page.page_link_number2.present?

    assert_equal "Previous Page", @community_search_page.previous_page_link.text.strip
    assert_equal "First", @community_search_page.first_page_link.text.strip
    assert_equal "Next Page", @community_search_page.next_page_link.text.strip
    assert_equal "Last", @community_search_page.last_page_link.text.strip
    assert_equal "1", @community_search_page.page_link_number1.text.strip
    assert_equal "2", @community_search_page.page_link_number2.text.strip

    assert_equal 20, @community_search_page.search_result_posts.length + @community_search_page.search_topic_results.length, "page size is 20"
    assert_match /disabled/, @community_search_page.previous_page_link.class_name, "Previous page link must be disabled on page1"
    assert_match /disabled/, @community_search_page.first_page_link.class_name, "First page link must be disabled on page1"
    assert_match /active/, @community_search_page.page_link_number1.class_name, "1 link must be disabled on page1"
    refute_match /active/, @community_search_page.page_link_number2.class_name
    refute_match /disabled/, @community_search_page.next_page_link.class_name
    refute_match /disabled/, @community_search_page.last_page_link.class_name
  end

  def test_00200_pagination_next_page_link_click
    search_keyword = "watir"
    @community_search_page.search search_keyword
    assert @browser.wait_until {
      @community_search_page.next_page_link.present?
    }
    assert_equal 20, @community_search_page.search_result_posts.length + @community_search_page.search_topic_results.length, "page size is 20"

    @browser.execute_script("window.scrollBy(0,4000)")
    @community_search_page.next_page_link.when_present.click
    @community_search_page.wait_results_load # For ui customization on. Ajax call instead of reloading page. 
    @browser.wait_until {
      @community_search_page.search_result_page.present?
    }
    refute_match /disabled/, @community_search_page.previous_page_link.class_name
    refute_match /disabled/, @community_search_page.first_page_link.class_name
    refute_match /active/, @community_search_page.page_link_number1.class_name, "1 link must not be disabled on page2"
    assert_match /active/, @community_search_page.page_link_number2.class_name, "2 link must be disabled"
  end

  def test_00210_pagination_last_page_link_click
    search_keyword = "watir"
    @community_search_page.search search_keyword

    assert @browser.wait_until {
      @community_search_page.last_page_link.present?
    }

    assert_equal 20, @community_search_page.search_result_posts.length + @community_search_page.search_topic_results.length, "page size is 20"
    @browser.execute_script("window.scrollBy(0,4000)")
    @community_search_page.last_page_link.when_present.click
    @community_search_page.wait_results_load # For ui customization on. Ajax call instead of reloading page. 
    @browser.wait_until {
      @community_search_page.search_result_page.present?
    }

    refute_match /disabled/, @community_search_page.previous_page_link.class_name
    refute_match /disabled/, @community_search_page.first_page_link.class_name
    refute_match /active/, @community_search_page.page_link_number1.class_name
    assert_match /disabled/, @community_search_page.last_page_link.class_name, "Last page link must be disabled"
    assert_match /disabled/, @community_search_page.next_page_link.class_name, "Next page link must be disabled"
  end

  def test_00220_pagination_first_page_link_click
    search_keyword = "watir"
    @community_search_page.search search_keyword
    assert @browser.wait_until {
      @community_search_page.last_page_link.present?
    }
    assert_equal 20, @community_search_page.search_result_posts.length + @community_search_page.search_topic_results.length, "page size is 20"
    @browser.execute_script("window.scrollBy(0,4000)")
    @community_search_page.next_page_link.when_present.click
    @community_search_page.wait_results_load # For ui customization on. Ajax call instead of reloading page. 
    @browser.wait_until {
      @community_search_page.search_result_page.present?
    }
    refute_match /disabled/, @community_search_page.previous_page_link.class_name
    refute_match /disabled/, @community_search_page.first_page_link.class_name
    refute_match /active/, @community_search_page.page_link_number1.class_name

    @browser.execute_script("window.scrollBy(0,4000)")
    @community_search_page.first_page_link.when_present.click
    @community_search_page.wait_results_load # For ui customization on. Ajax call instead of reloading page. 
    @browser.wait_until {
      @community_search_page.search_result_page.present?
    }

    assert_match /disabled/, @community_search_page.previous_page_link.class_name
    assert_match /disabled/, @community_search_page.first_page_link.class_name
    assert_match /active/, @community_search_page.page_link_number1.class_name
    refute_match /disabled/, @community_search_page.last_page_link.class_name, "Last page link must NOT be disabled"
    refute_match /disabled/, @community_search_page.next_page_link.class_name, "Next page link must NOT be disabled"
  end

  def test_00230_pagination_previous_page_link_click
    search_keyword = "watir"
    @community_search_page.search search_keyword
    assert @browser.wait_until {
      @community_search_page.last_page_link.present?
    }
    assert_equal 20, @community_search_page.search_result_posts.length + @community_search_page.search_topic_results.length, "page size is 20"
    @browser.execute_script("window.scrollBy(0,4000)")
    @community_search_page.next_page_link.when_present.click
    @community_search_page.wait_results_load # For ui customization on. Ajax call instead of reloading page. 
    @browser.wait_until {
      @community_search_page.search_result_page.present?
    }
    refute_match /disabled/, @community_search_page.previous_page_link.class_name
    refute_match /disabled/, @community_search_page.first_page_link.class_name
    refute_match /active/, @community_search_page.page_link_number1.class_name

    @browser.execute_script("window.scrollBy(0,4000)")
    @community_search_page.previous_page_link.when_present.click
    @community_search_page.wait_results_load # For ui customization on. Ajax call instead of reloading page. 
    @browser.wait_until {
      @community_search_page.search_result_page.present?
    }
    assert_match /disabled/, @community_search_page.previous_page_link.class_name
    assert_match /disabled/, @community_search_page.first_page_link.class_name
    assert_match /active/, @community_search_page.page_link_number1.class_name
    refute_match /disabled/, @community_search_page.last_page_link.class_name, "Last page link must NOT be disabled"
    refute_match /disabled/, @community_search_page.next_page_link.class_name, "Next page link must NOT be disabled"
  end

  def test_00240_pagination_next_page_link_URL
    search_keyword = "watir"
    @community_search_page.search search_keyword
    assert @browser.wait_until {
      @community_search_page.next_page_link.present?
    }
    @browser.execute_script("window.scrollBy(0,4000)")
    @community_search_page.next_page_link.when_present.click
    @browser.wait_until {
      @community_search_page.search_result_page.present?
    }
    assert_match /currentPage=2/, @browser.url
  end

  def test_00250_check_search_result_of_topic
    search_keyword = "A Watir Topic"
    @community_search_page.search search_keyword
    @browser.wait_until($t) { @community_search_page.search_result_page.present? }
    assert @community_search_page.search_topic_result.present?
  end

  def test_00270_check_type_filter_of_review_and_topic
    search_keyword = "A Watir Topic"
    @community_search_page.search search_keyword
    @browser.wait_until($t) { @community_search_page.search_result_page.present? }
    @community_search_page.search_type_filter(:reviews).check
    @browser.wait_until($t) { @community_search_page.search_result_page.present?}
    @community_search_page.search_result_detail.each_with_index do |div_item|
      assert div_item.text.include? ("Review")
    end
    @community_search_page.search_type_filter(:topics).check
    @browser.wait_until($t) { @community_search_page.search_topic_result.present?}
    assert @community_search_page.search_topic_result.text.include? (search_keyword)
  end

  def test_00280_check_type_filter_of_number
    search_keyword = "A Watir Topic"
    @community_search_page.search search_keyword
    @browser.wait_until($t) { @community_search_page.search_result_page.present? }
    @community_search_page.search_type_filter(:questions).check
    @browser.wait_until($t) { @community_search_page.search_result_page.present?}
    @browser.wait_until { @community_search_page.results_keyword.text.include? (@community_search_page.search_type_filter(:questions).results_count) }
    post_count = @community_search_page.search_type_filter(:questions).results_count
    assert @community_search_page.results_keyword.text.include? post_count
    @community_search_page.search_type_filter(:questions).expand
    @browser.wait_until { !@community_search_page.search_type_filter(:featured_q).nil? }
    @community_search_page.search_type_filter(:unanswered).check
    @browser.wait_until($t) { @community_search_page.search_result_page.present?}
    # @community_search_page.search_type_filter(:featured_q).check
    # @browser.wait_until($t) { @community_search_page.search_result_page.present?}
    # answered_post_count = @community_search_page.search_type_filter(:answered).results_count
    post_count_left = @community_search_page.search_type_filter(:questions).results_count.to_i - @community_search_page.search_type_filter(:answered).results_count.to_i

    @browser.wait_until { @community_search_page.results_keyword.text.include?(post_count_left.to_s) }
    # assert @community_search_page.results_keyword.text.include?(post_count_left.to_s), \
    #        "Number #{@community_search_page.results_keyword.text} not match #{post_count} - #{answered_post_count} "
  end

  def test_00300_view_all_link_from_homepage
    types = ["Question", "Blog", "Review"]
    for type_index in 0..2
      @community_home_page.navigate_in
      if !(@community_home_page.assert_view_all_link_present_and_click types[type_index])
        next
      end
      @browser.wait_until { @community_search_page.all_searched_result_items[0].present? || @community_search_page.search_no_results_text.present? }
      assert (@community_search_page.search_type_filter_panel.typegroup_at_name "#{types[type_index]}s").checked? == true
      @community_search_page.search_result_detail.each do |detail| 
        assert_match /#{types[type_index]}/, detail.text
      end
    end
  end

  def test_00310_search_from_topic_list_page
    @topic_list_page.navigate_in
    @community_search_page.universal_search_from_list_page "watir"
    @browser.wait_until { @community_search_page.search_topic_results[0].present? || @community_search_page.search_no_results_text.present? }
    assert (@community_search_page.search_type_filter :topics).checked? == true
    @community_search_page.search_topic_results[0].link(:class => "topic-detail-title").click unless @community_search_page.search_no_results_text.present?
    @browser.wait_until { (@browser.url.include? "/topic/") && @browser.div(:class => "widget banner topic").present? }
  end

# product list page didn't support ui customization
  # def test_00320_search_from_product_list_page
  #   # no product list page model
  #   @browser.goto @config.base_url + "/n/#{config.slug}/config"
  # end

  def test_00330_search_from_event_list_page
    # no product list page model
    skip unless beta_feature_enabled? "fs_events"
    @event_list_page.navigate_in
    @community_search_page.universal_search_from_list_page "test"
    @browser.wait_until { @community_search_page.search_result_events[0].present? || @community_search_page.search_no_results_text.present? }
    assert (@community_search_page.search_type_filter :event).checked? == true
    if @community_search_page.search_result_events[0].present?
      @community_search_page.search_result_events[0].element(:css => ".event-title a").click
      @browser.wait_until { (@browser.url.include? "/event/") && @browser.div(:class => /(event-description-container|gadget-event-detial-content)/).present? }
    end
  end

  def test_00340_search_from_idea_list_page
    # no product list page model
    skip unless beta_feature_enabled? "fs_ideas"
    @idea_list_page.navigate_in
    @community_search_page.universal_search_from_list_page "test"
    @browser.wait_until { @community_search_page.search_result_ideas[0].present? || @community_search_page.search_no_results_text.present? }
    assert (@community_search_page.search_type_filter :ideas).checked? == true
    if @community_search_page.search_result_ideas[0].present?
      @community_search_page.search_result_ideas[0].element(:css => "h4.media-heading a").click unless @community_search_page.search_no_results_text.present?
      @browser.wait_until { (@browser.url.include? "/idea/") && @browser.div(:class => "ideas-container").present? }
    end
  end

  def test_00350_search_from_topic_detail_page
    types = [:topic, :product]
    types.each do |type|
      @topic_list_page.navigate_in type
      begin
        @topic_list_page.goto_first_topic
      rescue
        puts "There is no topic or product"
        skip
      end
      @community_search_page.universal_search_from_list_page "test"
      @browser.wait_until { @community_search_page.all_searched_result_items[0].present? || @community_search_page.search_no_results_text.present? }
      assert (@community_search_page.search_type_filter :all).checked? == true

      size = @community_search_page.all_searched_result_items.size > 10 ? 10 : @community_search_page.all_searched_result_items.size
      result_list = @community_search_page.all_searched_result_items[0...size]
      result_list.each do |result|
        @browser.wait_until { result.link(:class => "customization-post-title").present? }
      end
    end
  end

  def test_00370_vote_in_search_idea_list_page
    skip unless beta_feature_enabled? "fs_ideas"
    # vote times
    @idea_list_page.about_login("regular_user1", "logged")
    @community_search_page.search "idea title"
    @browser.wait_until { @community_search_page.search_result_ideas[0].present? || @community_search_page.search_no_results_text.present? }
    if @community_search_page.search_result_ideas[0].present?
      @idea_list_page.vote_for_idea :is_voted => false, :vote_up => true
      @idea_list_page.vote_for_idea :is_voted => true, :vote_up =>false, :current_status => "up"
      @idea_list_page.vote_for_idea :is_voted => true, :vote_up => true, :current_status => "down"
      @idea_list_page.vote_for_idea :is_voted => true, :vote_up => true, :current_status => "up"
      # twice
      @idea_list_page.vote_for_idea :is_voted => false, :vote_up => false
      @idea_list_page.vote_for_idea :is_voted => true, :vote_up =>true, :current_status => "down"
      @idea_list_page.vote_for_idea :is_voted => true, :vote_up => false, :current_status => "up"
      @idea_list_page.vote_for_idea :is_voted => true, :vote_up => false, :current_status => "down"
    end
  end

  def test_00380_new_tag_in_conversation_is_searchable
    conv_detail = @topicdetail_page.create_conv_with_tag
    @browser.element(:css => ".customization-root-post-content a").when_present.click
    @browser.wait_until { (@community_search_page.results_searched_out? :keyword => conv_detail[:tag], :match_content => :details, :timeout => 5 * 60 ) == true }
  end

  def test_00390_like_and_reply_in_new_create_conv
    conv_detail = @topicdetail_page.create_conv_with_tag
    @community_search_page.search conv_detail[:title]
    @browser.wait_until { ( @community_search_page.results_searched_out? :keyword => conv_detail[:title], :timeout => 5 * 60 ) == true }

    like_link = @community_search_page.first_like_action_link.when_present
    # click like/unlike for search result
    for index in 1..2
      @browser.wait_until { like_link.present? }
      curr_like_count = like_link.text.to_i
      like_link.click
      @browser.wait_until { like_link.text.to_i == (curr_like_count + (index == 1 ? 1 : -1))  }
    end
    # click reply for search result
    @community_search_page.first_reply_action_link.when_present.click
    @browser.wait_until { @browser.text_field(:id => "wmd-input").present? }
  end

  def test_00400_diff_operation_on_conv
    reject_types = ["delete", "per_remove", "flag"]
    reject_types.each do |type|
      conv_detail = @topicdetail_page.create_conv_with_tag
      @community_search_page.search conv_detail[:title]
      search_url = @browser.url
      @admin_mod_page.about_login("network_admin", "logged")
      @browser.goto conv_detail[:url]
      case type
      when "flag"
        @admin_mod_page.navigate_in
        @admin_mod_page.set_moderation_threshold("1", :low)
        # admin flag the post
        @browser.goto conv_detail[:url]
        @convdetail_page.flag_root_post :reason => "test"
      when "per_remove"
        @convdetail_page.flag_root_post :reason => "test"
        @browser.refresh
        @convdetail_page.permanently_remove_flagged_root_post
      when "delete"
        @convdetail_page.delete_conversation
      end
      @browser.goto search_url
    @browser.wait_until { ( @community_search_page.wait_results__not_searched_out :keyword => conv_detail[:title], :timeout => 6 * 60 ) == false }
    end
  end

end