require 'pages/community/admin'
require 'pages/community/home'

class Pages::Community::AdminEvents < Pages::Community::Admin

  def initialize(config, options = {})
    super(config)
    @url = config.base_url + "/admin/#{@config.slug}/events"
  end

  def start!(user)
    # login starting from Home page
    @home_page = Pages::Community::Home.new(@config)
    @home_page.start!(user)

    navigate_in
  end

  upcoming_event_tab        { ul(:id => "eventTabs").lis[0] }
  past_event_tab            { ul(:id => "eventTabs").lis[1] }

  empty_event_text          { h4(:class => "empty-container-text") }
  first_event_item					{ div(:class => "topics-table-body") }
  event_items               { divs(:class => "topics-table-body")}
  first_event_title					{ p(:class => "admin-event-title") }
  first_event_topics				{ links(:class => "event-topic-title") }
  event_view                { div(:class => "row topics-table-body").link}
  action_btn							  { div(:class => "row topics-table-body").button(:text => /Action/) }
  view_btn								  { span(:class => "icon-show event-action-icon") }
  edit_btn								  { span(:class => "icon-edit event-action-icon") }
  feature_btn							  { span(:class => /favorite event-action-icon/) }
  delete_btn							  { span(:class => "icon-delete event-action-icon")}
  unfeature_icon            { div(:class => "row topics-table-body").span(:class => "icon-unfavorite")}
  feature_icon              { div(:class => "row topics-table-body").span(:class => "icon-favorite")}
  filter_btn                { button(:id => "admin-topics-list-filter") }
  #filter_all                { ul(:css => "ul[aria-labelledby='admin-topics-list-filter']").link(:text => /All/)}
  #filter_featured           { ul(:css => "ul[aria-labelledby='admin-topics-list-filter']").link(:text => /Featured/)}
  new_btn								    { link(:href => /events\/create/) }

  pic_input								  { file_field(:class => /photo-browse-input/) }
  pic_select_btn						{ button(:class => /file-upload-select-button/)}
  title_input							  { text_field(:class => /ember-text-field/,:placeholder=>/event/) }
  #all_day_input							  { div(:class => /all-day/) }
  location_radio						{ input(:id => "in-person-radio") }
  location_input						{ text_field(:id => "adress-input") }
  location_map_placeholder	{ div(:class => "map-placeholder")}
  location_suggestion				{ div(:class => "pac-container pac-logo")}
  desc_input						    { div(:class => /note-editable/) }

  topic_input							  { div(:class => /event-configuration-container/).text_field }
  topic_list_first_item     { ul(:class => "dropdown-menu topic-dropdown").li }
  topic_badge_first_item    { div(:class => "topic-badge").link }

  next_btn								  { button(:id => "next-btn")}
  publish_event_btn         { button(:class => "btn btn-primary ", :text => /Publish Event/)}

  pic_view                  { div(:class => "event-thumbnail")} 
  content_view						  { div(:class => /(event-description-container|gadget-event-detial-content)/) }
  related_topics_view				{ links(:class=> "title")}
  pic_preview               { div(:class => " event-thumbnail")}
  
  def navigate_in
    super

    accept_policy_warning

    switch_to_sidebar_item(:events)

    wait_until_event_admin_page_loaded
  end

  def wait_until_event_admin_page_loaded
    @browser.wait_until($t) { upcoming_event_tab.present? }
    @browser.wait_until($t) { past_event_tab.present? }
  end

  def wait_until_event_loaded
    @browser.wait_until{ empty_event_text.present? || first_event_item.present? }
  end

  def click_action action_name
  	action_btn.when_present.click
  	@browser.wait_until {delete_btn.present? }
  	case action_name
    when :view
      view_btn.when_present.click
    when :edit
      edit_btn.when_present.click
    when :feature
      feature_btn.when_present.click
    when :delete
      delete_btn.when_present.click
    else 
      raise "#{action_name} not supported yet"  
    end
  end

  def filter filter_name
    wait_until_event_loaded
    #before_filter = filter_btn.text
    before_number = event_items.size
    filter_btn.when_present.click
    @browser.wait_until{ @browser.ul(:css => "ul[aria-labelledby='admin-topics-list-filter']") }
    @browser.ul(:css => "ul[aria-labelledby='admin-topics-list-filter']").link(:text => "#{filter_name}").when_present.click
    wait_until_event_loaded
    after_number = event_items.size
    if filter_name == "Featured"
      @browser.wait_until{ before_number >= after_number }
    else
      @browser.wait_until{ before_number <= after_number }
    end
  end

  def filter_all
    filter "All"
  end

  def filter_featured
    filter "Featured"
  end

  def feature_by_icon
    unfeature_icon.when_present.click
    @browser.wait_until { feature_icon.present? }
  end

  def unfeature_by_icon
    feature_icon.when_present.click
    @browser.wait_until { unfeature_icon.present? }
  end

  def delete
    @browser.wait_until{ first_event_title.present? }
    click_action :delete
    wait_until_event_loaded
  end

  def feature_by_menu
    click_action :feature
    @browser.wait_until { feature_icon.present? }
    @browser.wait_until { feature_btn.text.include? "Unfeature" }
  end

  def unfeature_by_menu
    click_action :feature
    @browser.wait_until { unfeature_icon.present? }
    @browser.wait_until { feature_btn.text.include? "Feature" }
  end

  def new_event( title: "event title - #{get_timestamp}", location: nil, desc: "event desc - #{get_timestamp}", topic: nil )
  	new_btn.when_present.click
  	event_step( :title => title, :location => location, :desc => desc, :topic => topic)
  end

  def edit_event( title: "event title - #{get_timestamp}", location: nil, desc: "event desc - #{get_timestamp}", topic: nil )
  	@browser.wait_until{ first_event_item.present? }
    click_action :edit
  	event_step( :title => title, :location => location, :desc => desc, :topic => topic, :is_edit => true)
  end

  def event_step( title: "event title - #{get_timestamp}", location: nil, desc: "event desc - #{get_timestamp}", topic: nil, is_edit: false, origin_title: nil)
  	@browser.wait_until{ pic_input.exist? }
  	pic_input.set "#{@c.data_dir}/attachment/test.png"
  	@browser.wait_until { pic_select_btn.present? }
  	sleep 2
  	pic_select_btn.when_present.click
  	@browser.wait_until { !pic_select_btn.present? }
    if is_edit
      @browser.wait_until{ title_input.value != "" }
      if origin_title
        @browser.wait_until{ title_input.value == origin_title }
      end
    end
    sleep 2
  	title_input.when_present.set title
  	#if(all_day) all_day_input.when_present.click
  	# if location
   #    # if location_radio.when_present.value == "false"
   #    #   location_radio.when_present.click
   #    # end
   #    if !is_edit
  	# 	  @browser.wait_until { location_map_placeholder.present? }
   #    end
  	# 	location_input.when_present.set location
  	# 	@browser.wait_until { location_suggestion.present? }
  	# 	@browser.send_keys :down
  	# 	@browser.send_keys :enter
  	# 	@browser.wait_until { !location_map_placeholder.present? }
   #  end
    desc_input.when_present.click
    @browser.send_keys desc
    if topic
    	topic_input.when_present.set topic
      @browser.wait_until{ topic_list_first_item.present? }
      @browser.send_keys :enter
      @browser.wait_until{ topic_badge_first_item.present? }
      @browser.wait_until{ topic_badge_first_item.text.include? topic }
    end
    @browser.execute_script("window.scrollBy(0,1000)")
    sleep 3
    next_btn.when_present.click

    @browser.wait_until{ pic_view.present? }
    @browser.wait_until{ pic_view.style("background-image").include? "/uploads/" }
    @browser.wait_until{ content_view.present? }
    @browser.wait_until{ content_view.text.include? title }
    @browser.wait_until{ content_view.text.include? desc }

    publish_event_btn.when_present.click
    @browser.wait_until{ pic_view.present? }
    @browser.wait_until{ content_view.present? }
  end
end