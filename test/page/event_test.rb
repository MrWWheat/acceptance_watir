require 'watir_test'
require 'pages/community/admin'
require 'pages/community/about'
require 'pages/community/layout'

require 'pages/community/admin_events'
require 'pages/community/event_list'
require 'pages/community/event_detail'
require 'pages/community/topicdetail'
require 'pages/community/home'
require 'pages/community/searchpage'
require 'pages/community/conversationdetail'

class EventTest < WatirTest

  def setup
    super
   # @about_page = Pages::Community::About.new(@config)
   # @admin_page = Pages::Community::Admin.new(@config)
   # @layout_page = Pages::Community::Layout.new(@config)
    @admin_events_page = Pages::Community::AdminEvents.new(@config)
    @event_list_page = Pages::Community::EventList.new(@config)
    @event_detail_page = Pages::Community::EventDetail.new(@config)
    @home_page = Pages::Community::Home.new(@config)
    @search_page = Pages::Community::Search.new(@config)
    @profile_page = Pages::Community::Profile.new(@config)
    # assigning @current_page helps error reporting
    @community_page = Pages::Community.new(@config)
    @login_page = Pages::Community::Login.new(@config)
    @topic_detail_page = Pages::Community::TopicDetail.new(@config)
    @community_search_page = Pages::Community::Search.new(@config)
    @conversation_detail_page =  Pages::Community::ConversationDetail.new(@config)
    #  give good contextual data
    puts "[[[ #{name} ::: #{user_for_test} ]]]" if @config.verbose?
    @browser = @config.browser
    # @admin_events_page.start!(user_for_test)
  end

  def teardown
    super
  end

  p1

  user :network_admin
  def test_00010_new_upcoming_online_event
    @admin_events_page.start!(user_for_test)
    title = "event title - #{get_timestamp}"
  	desc = "event desc - #{get_timestamp}"
  	@admin_events_page.new_event :title => title, :desc => desc
    @browser.wait_until{@admin_events_page.pic_preview.present? || @admin_events_page.pic_view.present?}
    sleep 3
    @browser.wait_until{@admin_events_page.pic_preview.style("background-image").include? "/uploads/"}
    assert @admin_events_page.pic_preview.style("background-image").include? "/uploads/"

    @browser.wait_until{ @admin_events_page.content_view.present?}
    assert @admin_events_page.content_view.text.include? title
    assert @admin_events_page.content_view.text.include? desc
  end

  def test_00011_new_upcoming_location_event
    @admin_events_page.start!(user_for_test)
    title = "event title - #{get_timestamp}"
  	desc = "event desc - #{get_timestamp}"
  	location = "Shanghai China"
  	@admin_events_page.new_event :title => title, :desc => desc, :location => location
    @browser.wait_until{@admin_events_page.pic_preview.present? || @admin_events_page.pic_view.present?}
    sleep 3
    @browser.wait_until{ @admin_events_page.pic_preview.style("background-image").include? "/uploads/"}
    assert @admin_events_page.pic_preview.style("background-image").include? "/uploads/"

    @browser.wait_until{ @admin_events_page.content_view.present?}
    assert @admin_events_page.content_view.text.include? title
    assert @admin_events_page.content_view.text.include? desc
  end

  #if the first event is draft in event list page, this test will occur error 
  def test_00030_view_upcoming_event
    @admin_events_page.start!(user_for_test)
    check_events
  	@browser.wait_until{ @admin_events_page.first_event_item.present? }
  	title = @admin_events_page.first_event_title.text
  	# topics = @admin_events_page.first_event_topics.map{ |x|x.inner_html }
  	@admin_events_page.event_view.click
    @browser.wait_until{ @admin_events_page.pic_view.present? }
    assert @admin_events_page.content_view.text.include? title
    # topics_view = @admin_events_page.related_topics_view.map{ |x|x.inner_html }
    # assert topics.sort == topics_view.sort
  end

  def test_00040_edit_upcoming_event
    @admin_events_page.start!(user_for_test)
    check_events
  	title = "event title - #{get_timestamp} - edited"
  	desc = "event desc - #{get_timestamp} - edited"
  	location = "Beijing China"
  	@admin_events_page.edit_event :title => title, :desc => desc, :location => location
    @browser.wait_until{@admin_events_page.pic_preview.present? || @admin_events_page.pic_view.present?}
    sleep 3
    assert @admin_events_page.pic_preview.style("background-image").include? "/uploads/"

    assert @admin_events_page.content_view.text.include? title
    assert @admin_events_page.content_view.text.include? desc
  end

  def test_00050_feature_upcoming_event
    @admin_events_page.start!(user_for_test)
    check_events
  	@browser.wait_until{ @admin_events_page.first_event_item.present? }
  	title = @admin_events_page.first_event_title.text
  	topics = @admin_events_page.first_event_topics.map{ |x|x.inner_html }
    @admin_events_page.action_btn.when_present.click
    @browser.wait_until{ @admin_events_page.feature_btn.present?}
  	is_featured = @admin_events_page.feature_btn.parent.text.include? "Unfeature"
  	if is_featured
  		@admin_events_page.unfeature_by_icon
  	end
  	@admin_events_page.feature_by_icon
  	@event_list_page.navigate_in
    sleep 3
  	assert @event_list_page.contain_featured_event?(title)
  end

  def test_00060_filter_upcoming_event
    @admin_events_page.start!(user_for_test)
    check_events
    @browser.wait_until{ @admin_events_page.first_event_item.present? }
    @admin_events_page.filter_all
    @admin_events_page.filter_featured
    @admin_events_page.event_items.each do |item|
      assert item.span(:class => "icon-favorite").present?
    end
  end

  def test_00070_link_topic_in_event
    @admin_events_page.start!(user_for_test)
    title = "event with topic title - #{get_timestamp}"
    desc = "event with topic desc - #{get_timestamp}"
    location = "Beijing China"
    topic = "A Watir Topic"
    @admin_events_page.new_event :title => title, :desc => desc, :location => location, :topic => topic
    actural_topic_name = @admin_events_page.topic_badge_first_item.text
    assert actural_topic_name.include? topic
    # check topic link
    @admin_events_page.topic_badge_first_item.when_present.click
    @browser.window(:index => 1).when_present.use do
      @topic_detail_page.wait_until_page_loaded
      assert @topic_detail_page.topic_title.text == actural_topic_name
      # check upcoming event
      #TO-DO
    end
  end

  def test_00080_delete_event
    @admin_events_page.start!(user_for_test)
    check_events
    @browser.wait_until{ @admin_events_page.first_event_item.present? }
    before_title = @admin_events_page.first_event_title.text
    @admin_events_page.delete
    sleep 4
    @admin_events_page.wait_until_event_loaded
    if !@admin_events_page.empty_event_text.present?
      after_title = @admin_events_page.first_event_title.text
      @browser.wait_until{before_title!=after_title}
      assert before_title!=after_title
    end
  end

  def test_00090_new_btn_in_event_page
    @admin_events_page.start!(user_for_test)
    @event_list_page.navigate_in
    @browser.wait_until{ @event_list_page.new_event_btn.present? }
  end

  def test_00100_edit_btn_in_event_page
    @admin_events_page.start!(user_for_test)
    @event_list_page.navigate_in
    sleep(2)
    if @event_list_page.upcoming_events.size > 0
      @event_list_page.navigate_in_upcoming_event
      @event_detail_page.trigger_edit_event
      title = "event title - #{get_timestamp} - edited"
      desc = "event desc - #{get_timestamp} - edited"
      location = "Beijing China"
      @admin_events_page.event_step( :title => title, :location => location, :desc => desc, :is_edit => true)
      @browser.wait_until{@admin_events_page.pic_preview.present? || @admin_events_page.pic_view.present?}
      assert @admin_events_page.pic_preview.style("background-image").include? "/uploads/"
      assert @admin_events_page.content_view.text.include? title
      assert @admin_events_page.content_view.text.include? desc
    end
  end

  user :anonymous
  def test_00110_event_in_event_page
    @home_page.start!(user_for_test)
    @event_list_page.navigate_in
    @event_list_page.wait_until_upcoming_event_loaded
    @event_list_page.filter :all
    @event_list_page.filter :today
    @event_list_page.filter :this_week
    @event_list_page.filter :this_month
    @event_list_page.filter :all
    @event_list_page.sort :date
    @event_list_page.sort :title
  end

  def test_00120_event_in_homepage
    @home_page.start!(user_for_test)
    @event_list_page.navigate_in
    @browser.wait_until{ @home_page.empty_upcoming_events.present? || @home_page.upcoming_events.size > 0 }
    @home_page.event_view_all_link.when_present.click
    @event_list_page.wait_until_upcoming_event_loaded
  end

  def test_00130_event_in_searchpage
    @home_page.start!(user_for_test)
    @community_search_page.search "event"

    events = @community_search_page.search_result_events
    assert events.size > 0
    assert events[0].link(:css => ".event-card .event-info-container a").text.downcase.include? "event"
  end

  def test_00140_export_event
    @event_list_page.navigate_in
    @event_list_page.navigate_in_upcoming_event
    @event_detail_page.wait_until_loaded
    title = @event_detail_page.title.text
    desc = @event_detail_page.desc.text
    location = @event_detail_page.location_div.text
    downloaded_file = @event_detail_page.export_event
    File.open(downloaded_file).read.each_line.with_index do |line, index|
      if line.include? "DESCRIPTION"
        assert line.include? desc
      elsif line.include? "LOCATION"
        assert line.include? location
      elsif line.include? "SUMMARY"
        assert line.include? title
      end
    end
  ensure 
    File.delete(downloaded_file) unless downloaded_file.nil?
  end

  user :regular_user1
  def test_00210_attend_event
    @home_page.start!(user_for_test)
    @event_list_page.navigate_in
    @event_list_page.navigate_in_upcoming_event
    @event_detail_page.attend_event
    @event_detail_page.attending_lists[0].when_present.click
    @browser.wait_until{ @profile_page.user_profile_name_betaon.present? }
    assert @browser.url == @browser.li(:class => "my-profile").link.href
  end

  def test_00220_like_event
    @home_page.start!(user_for_test)
    @event_list_page.navigate_in
    @event_list_page.navigate_in_upcoming_event
    @event_detail_page.like_event
  end

  def test_00230_reply_event
    @home_page.start!(user_for_test)
    @event_list_page.navigate_in
    @event_list_page.navigate_in_upcoming_event
    reply = "reply"
    @conversation_detail_page.reply_text_field.when_present.set reply
    @conversation_detail_page.reply_submit_button.when_present.click
    @browser.wait_until { !@conversation_detail_page.reply_submit_button.present? }
    @browser.wait_until { @conversation_detail_page.conv_reply.present? }
    assert @conversation_detail_page.conv_reply.text == reply
  end

  def check_events
    @admin_events_page.wait_until_event_loaded
    if @admin_events_page.empty_event_text.present?
      title = "event title - #{get_timestamp}"
      desc = "event desc - #{get_timestamp}"
      @admin_events_page.new_event :title => title, :desc => desc
      @browser.goto @admin_events_page.url
    end
  end
  
end