require 'pages/community/admin'
require 'pages/community/home'

class Pages::Community::EventList < Pages::Community

  def initialize(config, options = {})
    super(config)
    @url = config.base_url + "/n/#{@config.slug}/events"
  end

  upcoming_filter_all          { button(:text => "All") }
  upcoming_filter_today		     { button(:text => "Today") }
  upcoming_filter_this_week    { button(:text => "This Week") }
  upcoming_filter_this_month   { button(:text => "This Month") }
  
  sort_by                    { button(:class => "filter-dropdown") }
  sort_by_date               { link(:text => "Date") }
  sort_by_title              { link(:text => "Title") }

  new_event_btn              { link(:href => /events\/create/) }

  upcoming_events_container  { div(:class => "upcoming-events") }
  load_upcoming_events       { div(:class => "upcoming-events").div(:class => "loading-block") }
  empty_upcoming_events      { div(:class => "upcoming-events").h4(:class =>"empty-container-text")}
  upcoming_events            { div(:class => "upcoming-events").divs(:class => "event-card") }
  past_events_container      { div(:class => "past-event-list") }
  empty_past_events          { div(:class => "past-event-list").h4(:class =>"empty-container-text") }
  past_events                { div(:class => "past-event-list").divs(:class => "event-card") }
  featured_events_container  { div(:class => "featured-events") }
  featured_events            { div(:class => "featured-events").lis}
  empty_featured_events      { div(:class => "featured-events").h4(:class =>"empty-container-text") }

  def navigate_in
    @browser.goto @url
    @browser.wait_until { upcoming_events_container.present? }
  end

  def navigate_in_upcoming_event
    wait_until_upcoming_event_loaded
    upcoming_events[0].link.when_present.click
  end

  def wait_until_upcoming_event_loaded
    @browser.wait_until{ empty_upcoming_events.present? || upcoming_events.size > 0 }
  end

  def wait_until_featured_event_loaded
    @browser.wait_until{ empty_featured_events.present? || featured_events.size > 0 }
  end

  def wait_until_past_event_loaded
    @browser.wait_until{ empty_past_events.present? || past_events.size > 0 }
  end

  def contain_featured_event? event_title
  	@browser.wait_until { featured_events_container.present? }
  	feature_titles = featured_events.map{ |x|x.inner_html }
    feature_titles.any? { |s| s.include? event_title }
  end

  def filter filter_name
    wait_until_upcoming_event_loaded
    case filter_name
    when :all
      upcoming_filter_all.when_present.click
    when :today
      upcoming_filter_today.when_present.click
    when :this_week
      upcoming_filter_this_week.when_present.click
    when :this_month
      upcoming_filter_this_month.when_present.click
    else 
      raise "#{action_name} not supported yet"  
    end
    #TO-DO how to check
    @browser.wait_until { !load_upcoming_events.present? }
    wait_until_upcoming_event_loaded
  end

  def sort sort_name
    sort_by.when_present.click
    case sort_name
    when :date
      sort_by_date.when_present.click
    when :title
      sort_by_title.when_present.click
    else 
      raise "#{action_name} not supported yet"  
    end
    #TO-DO how to check
    # @browser.wait_until { load_upcoming_events.present? }
    wait_until_upcoming_event_loaded
  end
end