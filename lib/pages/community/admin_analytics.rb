require 'pages/community/admin'
require 'pages/community/home'

class Pages::Community::AdminAnalytics < Pages::Community::Admin

  def initialize(config, options = {})
    super(config)
    # @url = config.base_url+"/n/#{config.slug}/home"
    @url = config.base_url+ "/admin/#{@config.slug}/analytics"
  end

  def start!(user)
    # login starting from Home page
    @home_page = Pages::Community::Home.new(@config)
    @home_page.start!(user)

    navigate_in
  end

  analytic                  { link(:class => "ember-view", :text => "3rd Party Analytics") }
  analytic_page             { div(:class => "form-group", :text => /Analytics Provider/) }
  analytic_submit_btn       { button(:css => ".analytics button[type='submit']") }
  analytic_provider_btn           { button(:css => ".analytics .sap-regular-dropdown[data-toggle='dropdown']") } 
  analytic_provider_no_menu_item  { link(:css => ".analytics .dropdown-menu > li:nth-child(1) a") }
  analytic_provider_gg_menu_item  { link(:css => ".analytics .dropdown-menu > li:nth-child(2) a") }
  analytic_provider_adb_menu_item { link(:css => ".analytics .dropdown-menu > li:nth-child(3) a") }

  def navigate_in
    super

    switch_to_sidebar_item(:analytics)

    # wait until 3rd Party Analytics option is selected
    @browser.wait_until($t) { sidebar_item(:analytics).attribute_value("class").include?("active") }
    @browser.wait_until($t) { analytic_submit_btn.present? }
  end  
end