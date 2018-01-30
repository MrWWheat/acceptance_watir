require 'watir_test'
require 'pages/community/admin'
require 'pages/community/about'
require 'pages/community/layout'

require 'pages/community/home'
require 'pages/community/idea_list'
require 'pages/community/idea_detail'
require 'pages/community/idea'
require 'pages/community/searchpage'
require 'pages/community/topic_list'
require 'pages/community/admin_ideas'

class IdeaTest < WatirTest
  def setup
    super
    @home_page = Pages::Community::Home.new(@config)
    @idea_list_page = Pages::Community::IdeaList.new(@config)
    @idea_detail_page = Pages::Community::IdeaDetail.new(@config)
    @idea_page = Pages::Community::Idea.new(@config)
    @search_page = Pages::Community::Search.new(@config)
    @topic_list_page = Pages::Community::TopicList.new(@config)
    @admin_ideas_page = Pages::Community::AdminIdeas.new(@config)

    puts "[[[ #{name} ::: #{user_for_test} ]]]" if @config.verbose?
    @browser = @config.browser
  end

  def teardown
    super
  end

  p2
  user :regular_user1
  def test_00010_submit_new_idea
    @idea_list_page.start!(user_for_test)
    @idea_list_page.accept_policy_warning
    submit_new_idea :adding_product => true
  end

  p2
  def test_00020_view_all_idea
    @idea_list_page.start!(user_for_test)
    @idea_list_page.accept_policy_warning
    assert (@idea_list_page.filter :most_vote) == true
    assert (@idea_list_page.filter :least_vote) == true
    assert (@idea_list_page.filter :oldest) == true
    assert (@idea_list_page.filter :newest) == true
  end

  p2
  def test_00030_eidt_and_delete_idea
    @idea_list_page.start!(user_for_test)
    @idea_list_page.accept_policy_warning
    submit_new_idea
    @idea_list_page.first_idea_item_title.click
    @idea_detail_page.operate_idea :edit

    title = "edit idea title - #{get_timestamp}"
    desc = "edit idea desc #{get_timestamp}"
    topic = ["A Watir Topic", "A Watir Topic For Widgets", "A Watir Topic With Many Posts"]
    @idea_page.edit_idea :title => title, :desc => desc
    @idea_list_page.navigate_in
    assert (assert_idea_submit_right :topic => topic, :title => title, :desc => desc) == true

    @idea_list_page.first_idea_item_title.click
    @idea_detail_page.operate_idea :delete
  end

  p2
  def test_00040_user_search_idea
    @idea_list_page.start!(user_for_test)
    @idea_list_page.accept_policy_warning
    submit_new_idea
    title = @idea_list_page.first_idea_item_title.text
    desc  = @idea_list_page.first_idea_item_desc.text
    @search_page.search title

    # click like
    @browser.wait_until { @search_page.search_result_ideas[0].present? }
    search_like_link = @search_page.search_result_ideas[0].div(:class => "table-layout").links[1]
    old_like_count = search_like_link.text.to_i
    search_like_link.click
    @browser.wait_until{ search_like_link.text.to_i == (old_like_count + 1) }
    # click unlike
    old_like_count = search_like_link.text.to_i
    @browser.wait_until {search_like_link.present? }
    search_like_link.click
    @browser.wait_until{ search_like_link.text.to_i == (old_like_count - 1) }
    # reply once
    reply_content = "idea reply #{get_timestamp}"
    @search_page.search_result_ideas[0].when_present.div(:class => "table-layout").links[2].click
    assert (@idea_detail_page.write_reply reply_content) == true
    # reply twice
    reply_content = "idea reply #{get_timestamp} - twice"
    assert (@idea_detail_page.write_reply reply_content) == true

    # search by tag
    @browser.wait_until{ @idea_detail_page.idea_container.present? && @idea_detail_page.idea_desc_text.present? }
    @browser.execute_script("window.scrollBy(0,-1000)")
    @idea_detail_page.idea_desc_tag_link.when_present.click
    @search_page.click_sort_dropdown_option(1)
    # assert
    assert (assert_idea_in_search_page(title,desc)) == true
  end

  p2
  def test_00050_integration_with_others
    @idea_list_page.start!(user_for_test)
    @idea_list_page.accept_policy_warning
    if !@idea_list_page.first_idea_item.present?
      submit_new_idea
    end
    navigate_idea_list_page :topic
    navigate_idea_list_page :home
  end

  p2
  user :network_admin
  def test_00060_admin_review_ideas
    @admin_ideas_page.start!(user_for_test)
    file_entries_before_download = Dir.entries(@config.download_dir)

    download_csv_name_prefix = "#{@config.slug}_idea_status_overview"
    @admin_ideas_page.export_csv :seven
    downloaded_days_file = wait_file_download(@config.download_dir, file_entries_before_download, "#{download_csv_name_prefix}_last7_days_#{Time.now.strftime("%Y-%m-%d")}.csv", wait_time=30)
    assert !downloaded_days_file.nil?

    @admin_ideas_page.export_csv :month
    downloaded_month_file = wait_file_download(@config.download_dir, file_entries_before_download, "#{download_csv_name_prefix}_last30_days_#{Time.now.strftime("%Y-%m-%d")}.csv", wait_time=30)
    # test nav bars
    @browser.wait_until{ @admin_ideas_page.nav_tabs[1].present? }
    for i in 1..6
      @admin_ideas_page.nav_tabs[i].when_present.click
      @idea_list_page.wait_until_idea_load
      assert (@admin_ideas_page.filter :most_vote) == true
      assert (@admin_ideas_page.filter :least_vote) == true
      assert (@admin_ideas_page.filter :newest) == true
      assert (@admin_ideas_page.filter :oldest) == true
    end
  ensure
    File.delete(downloaded_days_file) unless downloaded_days_file.nil?
    File.delete(downloaded_month_file) unless downloaded_month_file.nil?
  end

  p2
  user :regular_user1
  def test_00070_operation_in_idea_detail_page
    @idea_list_page.start!(user_for_test)
    @idea_list_page.accept_policy_warning
    submit_new_idea
    # view times
    for i in 1..2
      @browser.wait_until { @idea_list_page.first_idea_item.present? }
      old_view_count = @idea_list_page.first_idea_item.span(:class => "icon-show").attribute_value("innerText").to_i
      @browser.wait_until { @idea_list_page.first_idea_item_title.present? }
      @idea_list_page.first_idea_item_title.click
      # like unlike in idea detail page
      @idea_detail_page.wait_until_load
      @idea_detail_page.wait_until_meta_action_load
      like_count = @idea_detail_page.like_count_text.attribute_value("innerText").split(/ /)[0].to_i
      @idea_detail_page.like_idea_button.click
      # follow unfollow in idea detai page
      follow_count = @idea_detail_page.follow_count_text.attribute_value("innerText").split(/ /)[0].to_i
      @idea_detail_page.follow_idea_button.click
      # assert
      @browser.wait_until{ @idea_detail_page.like_count_text.when_present.attribute_value("innerText").split(/ /)[0].to_i == like_count + (i == 1 ? 1 : -1) }
      @browser.wait_until{ @idea_detail_page.follow_count_text.when_present.attribute_value("innerText").split(/ /)[0].to_i == follow_count + (i == 2 ? 1 : -1) }
      # return list page
      @idea_list_page.navigate_in
      @browser.wait_until { @idea_list_page.first_idea_item.present? }
      @browser.wait_until { @idea_list_page.first_idea_item.span(:class => "icon-show").attribute_value("innerText").to_i == (old_view_count + 1) }
    end
    # vote times
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

  def submit_new_idea (adding_product: false)
    title = "idea title - #{get_timestamp}"
    desc = "idea desc #{get_timestamp}"
    topic = ["A Watir Topic", "A Watir Topic For Widgets", "A Watir Topic With Many Posts"]
    @idea_list_page.new_idea
    @idea_page.new_idea :topic => topic, :title => title, :desc => desc, :adding_product => adding_product

    @browser.wait_until { @idea_detail_page.idea_widget_view_all_link.present? }
    @idea_detail_page.idea_widget_view_all_link.click
    @browser.wait_until { @idea_list_page.idea_container.present? }
    @idea_list_page.wait_until_idea_load
    @idea_list_page.filter :newest
    assert( assert_idea_submit_right :topic => topic, :title => title, :desc => desc ) == true
  end

# navigate in
  def navigate_idea_list_page origin_page_type
    origin_page = nil
    origin_page_container_style = ""
    case origin_page_type
    when :home
      origin_page = @home_page
      origin_page_container_style = ".ideas-container"
    when :topic
      origin_page = @topic_list_page
      origin_page_container_style = ".gadget-popular-ideas"
    end
    if origin_page_type == :topic
      @idea_list_page.first_idea_item_topic.when_present.click
    else
      @home_page.navigate_in
    end

    missing_widget :widget => origin_page.idea_widget_view_all_link
    origin_page.accept_policy_warning
    @browser.wait_until { origin_page.idea_widget_view_all_link.present? }
    @browser.execute_script("window.scrollBy(0,$('#{origin_page_container_style} a')[0].getBoundingClientRect().top+document.documentElement.scrollTop - 300)")
    origin_page.idea_widget_view_all_link.click
    # assert
    @browser.wait_until { @idea_list_page.idea_container.present? }
    @browser.wait_until { @idea_list_page.wait_until_idea_load }
  end

  def assert_idea_in_search_page (title, desc)
    @browser.wait_until { @search_page.search_result_ideas[0].present? && @search_page.search_result_ideas[0].h4(:class => "media-heading").present? }
    for search_result_idea in @search_page.search_result_ideas
      if search_result_idea.h4(:class => "media-heading").link.when_present.text == title && search_result_idea.div(:class => "description").p.when_present.text == desc
        return true
      end
    end
    return false
  end

  def assert_idea_submit_right(topic: [], title:"", desc: "")
    for idea_item in @idea_list_page.idea_items
      if idea_item.h4(:class => "media-heading").link.when_present.text.include? title
        assert idea_item.div(:class => "description").p.when_present.text.include? desc
        for topic_item in idea_item.div(:class => "pre-heading").links[0..2]
          assert topic.join(",").include? topic_item.text
        end
        return true
      end
    end
    return false
  end

  def missing_widget (widget: nil, timeout: 10, gap: 2)
    while timeout > 0
      if !widget.present?
        sleep gap
        timeout -= gap
      else
        break
      end
    end
    if timeout == 0
      skip
    end
  end
end
