require 'pages/community/admin'
require 'pages/community/home'

class Pages::Community::AdminReports < Pages::Community::Admin

  def initialize(config, options = {})
    super(config)
    @url = config.base_url + "/admin/#{@config.slug}/reporting"
  end

  def start!(user)
    # login starting from Home page
    @home_page = Pages::Community::Home.new(@config)
    @home_page.start!(user)

    navigate_in
  end

  report                          { link(:class => "ember-view", :text => "Reports") }
  report_keycharts_tab_link       { link(:text => "Key Charts") }
  report_pageview                 { link(:class => "report-sub-nav", :text => "Page Views") }

  pageview_daily                  { link(:href => "#page-views-daily", :text => "Daily") }
  pageview_weekly                 { link(:href => "#page-views-weekly", :text => "Weekly") }
  pageview_monthly                { link(:href => "#page-views-monthly", :text => "Monthly") }
  pageview_yearly                 { link(:href => "#page-views-yearly", :text => "Yearly") }
  pageview_daily_graph            { div(:id => "page-views-daily") }
  pageview_weekly_graph           { div(:id => "page-views-weekly") }
  pageview_monthly_graph          { div(:id => "page-views-monthly") }
  pageview_yearly_graph           { div(:id => "page-views-yearly") }
  pageview_export_button          { link(:class => "btn btn-primary", :text => "Export CSV") }

  pop_content                     { link(:class => "report-sub-nav", :text => "Popular Content") }
  pop_weekly                      { link(:href => "#popular-content-last-7days", :text => "Last 7 Days") }
  pop_monthly                     { link(:href => "#popular-content-last-30days", :text => "Last 30 Days") }

  pop_weekly_content              { div(:id => "popular-content-last-7days")  }
  pop_monthly_content             { div(:id => "popular-content-last-30days") }
  pop_weekly_conv_title           { p(:css => "#popular-content-last-7days > div.ember-view:nth-child(1) p") }
  pop_weekly_conv_chart             { div(:css => "#popular-content-last-7days > div.ember-view:nth-child(1) .chart") }
  pop_weekly_conv_1st_legend      { div(:css => "#popular-content-last-7days > div.ember-view:nth-child(1) .legend-col-1.col-lg-6") }
  pop_weekly_topic_title          { p(:css => "#popular-content-last-7days > div.ember-view:nth-child(2) p") }
  pop_weekly_topic_chart            { div(:css => "#popular-content-last-7days > div.ember-view:nth-child(2) .chart") }
  pop_weekly_topic_summary        { div(:class => "chart-summary", :text => /Total Page Views/) }

  pop_monthly_conv_title           { p(:css => "#popular-content-last-30days > div.ember-view:nth-child(1) p") }
  pop_monthly_conv_chart             { div(:css => "#popular-content-last-30days > div.ember-view:nth-child(1) .chart") }
  pop_monthly_conv_1st_legend      { div(:css => "#popular-content-last-30days > div.ember-view:nth-child(1) .legend-col-1.col-lg-6") }
  pop_monthly_topic_title          { p(:css => "#popular-content-last-30days > div.ember-view:nth-child(2) p") }
  pop_monthly_topic_chart            { div(:css => "#popular-content-last-30days > div.ember-view:nth-child(2) .chart") }
  pop_monthly_topic_summary        { div(:class => "chart-summary", :text => /Total Page Views/) }


  responsiveness                  { link(:href => "#responsiveness", :text => "Responsiveness") }
  resp_chart                      { div(:css => "#responsiveness .chart") }
  resp_pie_title                  { div(:class => "ember-view", :text => /Elapsed time between first post and response to that post/) }
  resp_text                       { div(:css => "#responsiveness .legend-col-1.col-lg-6") }

  traffic                         { link(:href => "#traffic", :text => "Traffic") }
  traffic_return_user             { link(:class => "report-sub-nav", :text => "Returning Users") }
  traffic_return_user_daily       { link(:href => "#returning-users-daily", :text => "Daily") }
  traffic_return_user_daily_graph { div(:id => "returning-users-daily") }

  business                        { link(:text => "Business Value") }
  business_comm_cta               { link(:href => "#cta-clicks", :text => "Community CTA") }
  business_community_cta_graph    { div(:id => "weekly-cta") }
  business_community_cta_weekly   { link(:href => "#weekly-cta", :text => "Weekly") }
  business_hybris_cta_link        { link(:href => "#hybris-cta-clicks", :text => "Hybris CTA") }
  business_hybris_cta_graph       { div(:id => "hybris-weekly-cta") }

  liveliness                      { link(:href => "#liveliness") }
  liveliness_table                { div(:id => "liveliness").table(:class => "table table-hover") }

  members                         { link(:href => "#members", :text => "Members") }
  members_new_regis_user          { link(:class => "report-sub-nav", :text => "New Registered Users") }
  members_new_regis_user_graph    { div(:id => "daily-registered-users") }
  members_new_regis_user_daily    { link(:href => "#daily-registered-users", :text => "Daily") }
  members_post_growth             { link(:class => "report-sub-nav", :text => "Posts Growth") }
  members_post_growth_graph       { div(:id => "weekly-registered-users-post-count") }
  members_post_growth_weekly      { link(:href => "#weekly-registered-users-post-count", :text => "Weekly") }

  interaction                     { link(:href => "#interaction", :text => "Interaction") }
  interaction_graph               { div(:id => "interaction") }

  report_export_button            { link(:class => "btn btn-primary", :text => "Export CSV") }
   
  def report_parent_css(group_name, subtab_name=nil, threelayertab_name=nil)
    result = "#" + group_name.downcase.gsub(/ /, '-')

    unless subtab_name.nil?
      # there are some pages whose id is not created by its tab label name exactly
      case subtab_name
      when "Referrers"
        subtab_name = "Referers"
      when "Community CTA"
        subtab_name = "CTA Clicks"
      when "Hybris CTA"
        subtab_name = "Hybris CTA Clicks"
      when "New Registered Users"
        subtab_name = "Registered Users" 
      when "Posts Growth"
        subtab_name = "Registered Users Post Count" 
      when "Topics"
        subtab_name = "unique-participants-per-topic" 
      when "Ideas & Votes"
        subtab_name = "number-of-ideas-and-votes"  
      end 
      result += " #" + subtab_name.downcase.gsub(/ /, '-')

      unless threelayertab_name.nil?
        if subtab_name == "Referers"
          result += " #" + subtab_name.downcase.gsub(/ /, '-') + '-'
          if threelayertab_name == "Last 7 Days"
            result += "weekly"
          else
            result += "monthly"
          end
        elsif subtab_name == "Registered Users" or subtab_name == "Registered Users Post Count"
          result += " ##{threelayertab_name.downcase}-" + subtab_name.downcase.gsub(/ /, '-')  
        elsif subtab_name == "CTA Clicks"
          result += " ##{threelayertab_name.downcase}-cta"
        elsif subtab_name == "Hybris CTA Clicks"
          result += " #hybris-#{threelayertab_name.downcase}-cta"   
        elsif subtab_name == "number-of-ideas-and-votes"
          result = "#ideas-and-votes-" + threelayertab_name.downcase                                
        else 
          result += " #" + subtab_name.downcase.gsub(/ /, '-') + '-'
          if threelayertab_name.downcase.include?("days")
            result += threelayertab_name.downcase.gsub(/ d/,'d').gsub(/ /, '-')
          else  
            result += threelayertab_name.downcase.gsub(/ /, '-')
          end
        end    
      end  
    end 

    result
  end

  def report_group_navigator
    ReportNavigator.new(@browser, ".nav-tabs")
  end 
    
  def report_sub_navigator(group_name)
    ReportNavigator.new(@browser, report_parent_css(group_name) + " .nav-pills")
  end 

  def page_views_piechart(group_name, subtab_name, threelayertab_name, content_type=nil) 
    ReportIndividualPage.new(@browser, report_parent_css(group_name, subtab_name, threelayertab_name)).piechart(content_type)
  end  

  def navigate_in
    super

    accept_policy_warning

    switch_to_sidebar_item(:reports)

    # Time out here because of the bug EN-1939 (poor performance for loading report page)
    # @browser.wait_until { pageview_graph.present? }
    @browser.wait_until(60*3) { pageview_daily_graph.present? }
  end 

  def export(group_name, subtab_name, threelayertab_name=nil)
    switch_to_tab(group_name, subtab_name, threelayertab_name)

    ReportIndividualPage.new(@browser, report_parent_css(group_name, subtab_name)).export
    report_page(group_name, subtab_name, threelayertab_name)
  end

  def export_pageviews_piechart(group_name, subtab_name, threelayertab_name, content_type)
    switch_to_tab(group_name, subtab_name, threelayertab_name)

    accept_policy_warning
    
    piechart = page_views_piechart(group_name, subtab_name, threelayertab_name, content_type)
    piechart.export
    piechart
  end 

  def report_page(group_name, subtab_name, threelayertab_name=nil)
    ReportIndividualPage.new(@browser, report_parent_css(group_name, subtab_name, threelayertab_name))
  end  

  def switch_to_tab(group_name, subtab_name=nil, threelayertab_name=nil)
    report_group_navigator.tab_at_name(group_name).click
    @browser.wait_until { ReportIndividualPage.new(@browser, report_parent_css(group_name)).active? }
    @browser.wait_until { !layout_loading_block.present? } #workaround for EN-4357
    unless subtab_name.nil?
      report_sub_navigator(group_name).tab_at_name(subtab_name).click
      @browser.wait_until { ReportIndividualPage.new(@browser, report_parent_css(group_name, subtab_name)).active? }
      unless threelayertab_name.nil?
        ReportIndividualPage.new(@browser, report_parent_css(group_name, subtab_name)).content_navigator.tab_at_name(threelayertab_name).click
        @browser.wait_until { ReportIndividualPage.new(@browser, report_parent_css(group_name, subtab_name, threelayertab_name)).active? }
      end
    end 

    report_page(group_name, subtab_name, threelayertab_name) 
  end 

  class ReportIndividualPage
    def initialize(browser, parent_css)
      @browser = browser
      @parent_css = parent_css
    end
 
    # ============ Only available for two level page e.g. Key Charts->Page Views ============
    def export_btn
      @browser.link(:css => @parent_css + " a.btn-primary")
    end  

    def export
      export_btn.when_present.click
    end 
    # =======================================================================================

    def active?
      @browser.div(:css => @parent_css).when_present.class_name.include?("active")
    end

    def content_navigator
      ReportNavigator.new(@browser, @parent_css + " .nav-pills")
    end 

    # ============ Only available for three level pages in Key Charts->Page Views.e.g. Daily ============
    def total_page_views_p
      @browser.p(:css => @parent_css + " .chart-summary p:nth-of-type(1)")
    end 

    def total_page_views
      total_page_views_p.when_present.text.gsub(/Total Page Views /, '')
    end
    # =======================================================================================

    def time_period_p
      @browser.p(:css => @parent_css + " .chart-summary p:last-child")
    end

    def start_date
      time_period_p.when_present.text.gsub(/ ~ .*/, '')
    end

    def end_date
      time_period_p.when_present.text.gsub(/.* ~ /, '').gsub(/ .*/, '')
    end

    def chart
      @browser.element(:css => @parent_css + " canvas")
    end

    def no_data_label
      @browser.div(:css => @parent_css + " .chart-no-data")
    end  

    def empty?
      @browser.wait_until { no_data_label.present? || chart.present? }

      no_data_label.present?
    end 

    def piechart(type=nil)
      parent_css = @parent_css
      case type
      when :conversation
        parent_css += " > div.ember-view:nth-child(1)"
      when :topic
        parent_css += " > div.ember-view:nth-child(2)"
      when :idea
        parent_css += " > div.ember-view:nth-child(3)"
      else
        parent_css += " > div.ember-view:first-child"
      end 

      case type
      when :conversation, :topic, :idea  
        PageViewsPieChart.new(@browser, parent_css)
      else
        PieChart.new(@browser, parent_css)
      end  
    end  
  end  

  class ReportNavigator
    def initialize(browser, parent_css)
      @browser = browser
      @parent_css = parent_css
    end 

    def tabs
      result = []
      @browser.lis(:css => @parent_css + " li").each_with_index do |item, index|
        result << NavTab.new(@browser, @parent_css + " li:nth-of-type(#{index+1})")
      end 

      result 
    end  

    def tab_at_name(name, exist_for_sure=true)
      @browser.wait_until { !tabs.find { |t| t.name == name }.nil? } if exist_for_sure
      tabs.find { |t| t.name == name }
    end 

    class NavTab 
      def initialize(browser, parent_css)
        @browser = browser
        @parent_css = parent_css
      end

      def name
        @browser.link(:css => @parent_css + " a").when_present.text
      end
      
      def active?
        @browser.li(:css => @parent_css).when_present.class_name.include?("active")
      end

      def click
        @browser.link(:css => @parent_css + " a").when_present.click unless active?
        @browser.wait_until { active? }
      end  
    end 
  end  

  class PieChart
    def initialize(browser, parent_css)
      @browser = browser
      @parent_css = parent_css
    end

    def present?
      @browser.div(:css => @parent_css).present?
    end  

    def chart
      @browser.div(:css => @parent_css + " .chart")
    end

    def no_data_label
      @browser.div(:css => @parent_css + " .chart-no-data")
    end  

    def empty?
      @browser.wait_until { no_data_label.present? || chart.present? }

      no_data_label.present?
    end  
  end  

  class PageViewsPieChart < PieChart
    def title
      @browser.p(:css => @parent_css + " .pie-chart-csv-download-link").when_present.text
    end  

    def export_link
      @browser.link(:css => @parent_css + " .pie-chart-csv-download-link a")
    end

    def first_content_link
      @browser.link(:css => @parent_css + " .pie-legend a")
    end 

    def first_content_title
      first_content_link.when_present.title.strip
    end  

    def first_content_views
      @browser.span(:css => @parent_css + " .pie-legend .metadata").when_present.text.gsub(/.*% \(/,'').gsub(/ Views\)/, '')
    end  

    def goto_first_content
      first_content_link.when_present.click
    end 

    def total_page_views_p
      @browser.p(:css => @parent_css + " .chart-summary p:nth-of-type(1)")
    end 

    def total_page_views
      total_page_views_p.when_present.text.gsub(/Total Page Views /, '')
    end

    def export
      export_link.when_present.click
    end 
  end  
end