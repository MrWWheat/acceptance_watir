require File.expand_path(File.dirname(__FILE__) + "/excelsior_watir_test.rb")
require File.expand_path(File.dirname(__FILE__) + "/../lib/test_helper.rb")
require File.expand_path(File.dirname(__FILE__) + "/../lib/page_objects/community_home_page.rb")
require File.expand_path(File.dirname(__FILE__) + "/../lib/page_objects/community_search_page.rb")
require File.expand_path(File.dirname(__FILE__) + "/../lib/watir_lib.rb")
#require File.expand_path(File.dirname(__FILE__) + "/../lib/page_objects/page_object.rb")
require File.expand_path(File.dirname(__FILE__) + "/../lib/page_objects/community_search_page.rb")


class SearchPageTest < ExcelsiorWatirTest
  include WatirLib

  def setup
    super
    @home_page = CommunityHomePage.new(@browser)
    @home_page.goto_homepage
    @home_page_search = CommunitySearchPage.any_page_search_bar(@browser)
    @search_page = CommunitySearchPage.top_nav_search_bar(@browser) 
    @search_page.policy_warning     
  end

  def test_00010_topnav_search_placeholder_exists
    @search_page.topnav_search_placeholder
    assert @search_page.topnav_search_bar_paceholder.present?
  end

  def test_00020_topnav_search_icon_exists
    @search_page.find_topnav_search_icon
    assert @search_page.topnav_search_icon.present?
  end

  def test_00030_search_dropdown_exists
    assert @search_page.search_dropdown("test")
  end

  def test_00040_search_dropdown_link_works
    assert @search_page.search_dropdown("test")
    first_search_suggestion = @search_page.all_search_dropdown_suggestions[0]

    search_keyword = first_search_suggestion.text
    first_search_suggestion.click
    @browser.send_keys :enter
    @browser.wait_until { @search_page.search_result_page.present? }
    @search_results_page = CommunitySearchPage.results_page_search_bar(@browser)
    assert @browser.wait_until { @search_results_page.search_text_field.present? }
    assert_equal search_keyword, @search_results_page.search_text_field.value
  end

  def test_00050_topnave_search_cancel_icon_works
    @search_page.search_input_cancel_icon
    assert @browser.wait_until {
      @search_page.search_cancel_icon.present?
    }
    @search_page.search_cancel_icon.click
    assert_equal "", @search_page.search_text_field.value
  end

  def test_00060_anypage_search_bar_cancel_icon_works
    @home_page_search.search_input_cancel_icon
    assert @browser.wait_until {
      @home_page_search.search_cancel_icon.present?
    }
    @home_page_search.search_cancel_icon.click
    assert_equal "", @home_page_search.search_text_field.value
  end

  def test_00070_search_results_found_text_on_search_results_page
    @search_page.search("test")
    assert @search_page.results_keyword.text.include?("test"), 'keyword should be present in count results found for: "test"'
  end

  def test_00080_searched_keyword_present_in_search_results
    keyword = "amrood_april"
    @search_page.search keyword
    @search_page.all_searched_result_items.each do |div|
    assert_match /#{keyword}/, div.text
    end
  end

  def test_00090_search_results_member_avatar_link
    @search_page.search "amrood_april"
    first_result = @search_page.all_searched_result_items[0]
    first_result_avatar = first_result.link(:class => "pull-left")
    assert first_result_avatar.present?, "member avatar link should be present"
    assert first_result_avatar.href.include?("/profile/"), "link contains /profile/"
    first_result_avatar.when_present.click

    assert @browser.wait_until { @browser.url.include?("/profile/") }
    assert @browser.wait_until { @browser.div(:class => "member-info-col").present? }
  end

  def test_00100_search_results_conversation_member_link
    @search_page.search "amrood_april"
    first_result = @search_page.all_searched_result_items[0]

    first_result_member_link = first_result.link(:href => /profile/)
    assert first_result_member_link.present?, "member link should be present"
    first_result_member_link.when_present.click

    assert @browser.wait_until { @browser.url.include?("/profile/") }
    assert @browser.wait_until { @browser.div(:class => "member-info-col").present? }
  end

  def test_00110_search_results_conversation_title_link
    @search_page.search "amrood_april"
    first_result = @search_page.all_searched_result_items[0]
    conv_title_link = first_result.div(:class => "media-heading").link(:class=> "ember-view")
    assert conv_title_link.present?
    conv_title_link.when_present.click

    assert @browser.wait_until {
      @browser.h3(:class => "root-post-title").present?
    }
  end

  def test_00120_search_results_topic_title_link
    @search_page.search "amrood_april"
    first_result = @search_page.all_searched_result_items[0]

    topic_title_link = first_result.div(:class => "details").span(:class => "in-topic").link
    # topic_title_link = first_result.div(:class => "meta-row").link(:class=> "ember-view")      ---------1602 code--------------

    assert topic_title_link.present?
    topic_title_link_text = topic_title_link.text.strip

    topic_title_link.when_present.click
    assert @browser.wait_until {
      @browser.div(:class => "widget banner topic").present?
    }
    assert_equal topic_title_link_text, @browser.div(:class => "row title").h1s[0].text.strip
  end

  def test_00130_sort_default_sort_order_by_relevance
    @search_page.search "amrood_april"
    assert @search_page.sort_dropdown_toggle_link.present?
    assert_equal "Sorted by: Relevance", @search_page.sort_dropdown_toggle_link.text.strip
  end

  def test_00140_sort_dropdown_options_exist
    @search_page.search "amrood_april"
    @search_page.sort_dropdown_toggle_link.when_present.click
    assert_equal 4, @search_page.sort_dropdown_ul.lis.length
    assert_equal "Popular", @search_page.sort_dropdown_ul.lis[0].text
    assert_equal "Newest", @search_page.sort_dropdown_ul.lis[1].text
    assert_equal "Oldest", @search_page.sort_dropdown_ul.lis[2].text
    assert_equal "Relevance", @search_page.sort_dropdown_ul.lis[3].text
  end

  def test_00150_sort_search_results_by_newest
    results_list = [
      "amrood_april Quest one",
      "amrood_april Quest two",
      "amrood_april Quest three",
      "amrood_april Quest four",
      "amrood_april Disc one",
      "amrood_april Disc two",
      "amrood_april Disc three",
      "amrood_april Disc four"
      # Newest
    ].reverse

    @search_page.search "amrood_april"
    @search_page.click_sort_dropdown_option_newest # Newest

    all_searched_result_items = @search_page.all_searched_result_items
    assert_equal results_list[0], all_searched_result_items[0].div(:class => "media-heading").text
    assert_equal results_list[1], all_searched_result_items[1].div(:class => "media-heading").text
    assert_equal results_list[2], all_searched_result_items[2].div(:class => "media-heading").text
    assert_equal results_list[3], all_searched_result_items[3].div(:class => "media-heading").text
    assert_equal results_list[4], all_searched_result_items[4].div(:class => "media-heading").text
    assert_equal results_list[5], all_searched_result_items[5].div(:class => "media-heading").text
    assert_equal results_list[6], all_searched_result_items[6].div(:class => "media-heading").text
    assert_equal results_list[7], all_searched_result_items[7].div(:class => "media-heading").text
  end

  def test_00160_sort_search_results_by_oldest

    results_list = [
      "amrood_april Quest one",
      "amrood_april Quest two",
      "amrood_april Quest three",
      "amrood_april Quest four",
      "amrood_april Disc one",
      "amrood_april Disc two",
      "amrood_april Disc three",
      "amrood_april Disc four"]

    @search_page.search "amrood_april"
    @search_page.click_sort_dropdown_option_oldest #oldest
    all_searched_result_items = @search_page.all_searched_result_items

    assert_equal results_list[0], all_searched_result_items[0].div(:class => "media-heading").text
    assert_equal results_list[1], all_searched_result_items[1].div(:class => "media-heading").text
    assert_equal results_list[2], all_searched_result_items[2].div(:class => "media-heading").text
    assert_equal results_list[3], all_searched_result_items[3].div(:class => "media-heading").text
    assert_equal results_list[4], all_searched_result_items[4].div(:class => "media-heading").text
    assert_equal results_list[5], all_searched_result_items[5].div(:class => "media-heading").text
    assert_equal results_list[6], all_searched_result_items[6].div(:class => "media-heading").text
    assert_equal results_list[7], all_searched_result_items[7].div(:class => "media-heading").text
  end

  def test_00170_recent_searches_widget
    search_keyword1 = "amrood_april"
    @search_page.search search_keyword1
    assert @browser.wait_until {
      @search_page.recent_search_widget.present?
    }
    assert @browser.wait_until {
      @search_page.recent_search_widget.links.length > 0
    }
    assert_equal search_keyword1, @search_page.recent_search_widget.links[1].text
    search_keyword2 = "test"
    @search_page.search search_keyword2
    assert @browser.wait_until {
      @search_page.recent_search_widget.present?
    }
    assert @browser.wait_until {
      @search_page.recent_search_widget.links.length > 0
    }
    assert_equal search_keyword2, @search_page.recent_search_widget.links[1].text
    assert_equal search_keyword1, @search_page.recent_search_widget.links[2].text
  end

  def test_00180_related_searches_widget
    search_keyword = "amrood_april"
    @search_page.search search_keyword
    assert @browser.wait_until {
      @search_page.related_search_widget.present?
    }
    assert @browser.wait_until {
      @search_page.related_search_widget.link(:text => search_keyword).present?
    }
  end

  def test_00190_pagination_links_state
    search_keyword = "watir"
    @search_page.search search_keyword
    assert @search_page.previous_page_link.present?
    assert @search_page.first_page_link.present?
    assert @search_page.next_page_link.present?
    assert @search_page.last_page_link.present?
    assert @search_page.page_link_number1.present?
    assert @search_page.page_link_number2.present?

    assert_equal "Previous Page", @search_page.previous_page_link.text.strip
    assert_equal "First", @search_page.first_page_link.text.strip
    assert_equal "Next Page", @search_page.next_page_link.text.strip
    assert_equal "Last", @search_page.last_page_link.text.strip
    assert_equal "1", @search_page.page_link_number1.text.strip
    assert_equal "2", @search_page.page_link_number2.text.strip

    assert_equal 20, @search_page.search_result_posts.length, "page size is 20"
    assert_match /disabled/, @search_page.previous_page_link.class_name, "Previous page link must be disabled on page1"
    assert_match /disabled/, @search_page.first_page_link.class_name, "First page link must be disabled on page1"
    assert_match /active/, @search_page.page_link_number1.class_name, "1 link must be disabled on page1"
    refute_match /active/, @search_page.page_link_number2.class_name
    refute_match /disabled/, @search_page.next_page_link.class_name
    refute_match /disabled/, @search_page.last_page_link.class_name
  end

  def test_00200_pagination_next_page_link_click
    search_keyword = "watir"
    @search_page.search search_keyword
    assert @browser.wait_until {
      @search_page.next_page_link.present?
    }
    assert_equal 20, @search_page.search_result_posts.length, "page size is 20"

    @browser.execute_script("window.scrollBy(0,4000)")
    @search_page.next_page_link.when_present.click
    @browser.wait_until {
      @search_page.search_result_page.present?
    }
    refute_match /disabled/, @search_page.previous_page_link.class_name
    refute_match /disabled/, @search_page.first_page_link.class_name
    refute_match /active/, @search_page.page_link_number1.class_name, "1 link must not be disabled on page2"
    assert_match /active/, @search_page.page_link_number2.class_name, "2 link must be disabled"
  end

  def test_00210_pagination_last_page_link_click
    search_keyword = "watir"
    @search_page.search search_keyword

    assert @browser.wait_until {
      @search_page.last_page_link.present?
    }

    assert_equal 20, @search_page.search_result_posts.length, "page size is 20"
    @browser.execute_script("window.scrollBy(0,4000)")
    @search_page.last_page_link.when_present.click
    @browser.wait_until {
      @search_page.search_result_page.present?
    }

    refute_match /disabled/, @search_page.previous_page_link.class_name
    refute_match /disabled/, @search_page.first_page_link.class_name
    refute_match /active/, @search_page.page_link_number1.class_name
    assert_match /disabled/, @search_page.last_page_link.class_name, "Last page link must be disabled"
    assert_match /disabled/, @search_page.next_page_link.class_name, "Next page link must be disabled"
  end

  def test_00220_pagination_first_page_link_click
    search_keyword = "watir"
    @search_page.search search_keyword
    assert @browser.wait_until {
      @search_page.last_page_link.present?
    }
    assert_equal 20, @search_page.search_result_posts.length, "page size is 20"
    @browser.execute_script("window.scrollBy(0,4000)")
    @search_page.next_page_link.when_present.click
    @browser.wait_until {
      @search_page.search_result_page.present?
    }
    refute_match /disabled/, @search_page.previous_page_link.class_name
    refute_match /disabled/, @search_page.first_page_link.class_name
    refute_match /active/, @search_page.page_link_number1.class_name

    @browser.execute_script("window.scrollBy(0,4000)")
    @search_page.first_page_link.when_present.click
    @browser.wait_until {
      @search_page.search_result_page.present?
    }

    assert_match /disabled/, @search_page.previous_page_link.class_name
    assert_match /disabled/, @search_page.first_page_link.class_name
    assert_match /active/, @search_page.page_link_number1.class_name
    refute_match /disabled/, @search_page.last_page_link.class_name, "Last page link must NOT be disabled"
    refute_match /disabled/, @search_page.next_page_link.class_name, "Next page link must NOT be disabled"
  end

  def test_00230_pagination_previous_page_link_click
    search_keyword = "watir"
    @search_page.search search_keyword
    assert @browser.wait_until {
      @search_page.last_page_link.present?
    }
    assert_equal 20, @search_page.search_result_posts.length, "page size is 20"
    @browser.execute_script("window.scrollBy(0,4000)")
    @search_page.next_page_link.when_present.click
    @browser.wait_until {
      @search_page.search_result_page.present?
    }
    refute_match /disabled/, @search_page.previous_page_link.class_name
    refute_match /disabled/, @search_page.first_page_link.class_name
    refute_match /active/, @search_page.page_link_number1.class_name

    @browser.execute_script("window.scrollBy(0,4000)")
    @search_page.previous_page_link.when_present.click
    @browser.wait_until {
      @search_page.search_result_page.present?
    }
    assert_match /disabled/, @search_page.previous_page_link.class_name
    assert_match /disabled/, @search_page.first_page_link.class_name
    assert_match /active/, @search_page.page_link_number1.class_name
    refute_match /disabled/, @search_page.last_page_link.class_name, "Last page link must NOT be disabled"
    refute_match /disabled/, @search_page.next_page_link.class_name, "Next page link must NOT be disabled"
  end

  def test_00240_pagination_next_page_link_URL
    search_keyword = "watir"
    @search_page.search search_keyword
    assert @browser.wait_until {
      @search_page.next_page_link.present?
    }
    @browser.execute_script("window.scrollBy(0,4000)")
    @search_page.next_page_link.when_present.click
    @browser.wait_until {
      @search_page.search_result_page.present?
    }
    assert_match /currentPage=2/, @browser.url
  end

  def test_00260_check_topic_filter
    search_keyword = "A Watir Topic"
    @search_page.search search_keyword
    @browser.wait_until($t) { @search_page.search_result_page.present? }
    @search_page.topic_filter_checkbox_click(search_keyword)
    @browser.wait_until($t) { @search_page.search_result_page.present?}
    @search_page.search_result_detail.each_with_index do |div_item|
      assert div_item.link.text == search_keyword
    end
  end

  def test_00270_check_type_filter_of_review
    search_keyword = "A Watir Topic"
    @search_page.search search_keyword
    @browser.wait_until($t) { @search_page.search_result_page.present? }
    @search_page.type_filter_checkbox_click("Reviews")
    @browser.wait_until($t) { @search_page.search_result_page.present?}
    @search_page.search_result_detail.each_with_index do |div_item|
      assert div_item.text.include? ("Review")
    end
  end

  def test_00280_check_type_filter_of_number
    search_keyword = "A Watir Topic"
    @search_page.search search_keyword
    @browser.wait_until($t) { @search_page.search_result_page.present? }
    @search_page.type_filter_checkbox_click("Questions")
    @browser.wait_until($t) { @search_page.search_result_page.present?}
    post_count = @search_page.get_type_filter_count("Question")
    assert @search_page.results_keyword.text.include? post_count
    @search_page.type_filter_children_checkbox_click("Answered")
    @browser.wait_until($t) { @search_page.search_result_page.present?}
    answered_post_count = @search_page.get_children_type_filter_count("Answered")
    post_count_left = post_count.to_i - answered_post_count.to_i
    assert @search_page.results_keyword.text.include? post_count_left.to_s
  end



end