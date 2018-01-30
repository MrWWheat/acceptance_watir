require 'pages/community/admin'
require 'pages/community/home'
require 'pages/community/idea_list'

class Pages::Community::AdminIdeas < Pages::Community::Admin

  def initialize(config, options = {})
    super(config)
    @url = config.base_url + "/admin/#{@config.slug}/ideas"
  end

  def start!(user)
    # login starting from Home page
    @idea_list_page = Pages::Community::IdeaList.new(@config)
    @home_page = Pages::Community::Home.new(@config)
    @home_page.start!(user)

    navigate_in
  end

  ideas_container                 { div(:class => "ideas-container") }
  export_csv_button               { div(:class => "ideas-container").link(:class => "btn-primary")}
  seven_days_button               { div(:class => "ideas-container").ul(:class => "nav-pills").lis[0].link }
  month_button                    { div(:class => "ideas-container").ul(:class => "nav-pills").lis[1].link }
  active_seven_days_button        { div(:class => "ideas-container").ul(:class => "nav-pills").li(:class => "active", :text => /Last 7 Days/) }
  active_month_button             { div(:class => "ideas-container").ul(:class => "nav-pills").li(:class => "active", :text => /Last 30 Days/) }

  nav_tabs                        { ul(:class => "nav-tabs").lis }

  idea_result_chart               { div(:class => "chart").canvas}

  def navigate_in
    super
    accept_policy_warning
    @browser.goto @url
    @browser.wait_until {ideas_container.present?}
  end

  def export_csv type
    case type
    when :seven
      seven_days_button.when_present.click
      sleep 2
      @browser.wait_until{ ideas_container.present? && active_seven_days_button.present? && idea_result_chart.present? }
      export_csv_button.when_present.click
    when :month
      month_button.when_present.click
      sleep 2
      @browser.wait_until{ ideas_container.present? && active_month_button.present? && idea_result_chart.present? }
      export_csv_button.when_present.click
    end
  end

  def filter filter_name
    return @idea_list_page.filter filter_name, true
  end
end