require 'pages/community/admin'
require 'pages/community/home'
require 'pages/community/login'
require 'pages/community/layout'
require 'watir_config'
#require 'pages/base'

class Pages::Community::AdminConsoleSetup < Pages::Community::Admin

  def initialize(config, options = {})
    super(config)
    # @url = config.base_url + "/n/#{config.slug}/home"
    @url = config.base_url + "/admin/#{@config.slug}/general_setup"
  end

  def start!(user)
    # login starting from Home page
    @home_page = Pages::Community::Home.new(@config)
    @home_page.start!(user)

    navigate_in
  end

  community_name_input        { text_field(:css => ".instance-name input") }
  language_input              { select(:name => "language") }
  save_btn                    { button(:css => ".submit button")}

  def navigate_in
    super
    accept_policy_warning
    switch_to_sidebar_item(:setup)
    wait_until_admin_setup_page_loaded
  end

  def wait_until_admin_setup_page_loaded
    @browser.wait_until($t) { community_name_input.present? }
  end

  def change_community_name name
    community_name_input.when_present.set name
    save_btn.when_present.click
    sleep 3
    wait_until_admin_setup_page_loaded
    @browser.wait_until{ community_name_input.present? }
    @browser.wait_until{ community_name_input.value == name }
  end

  def change_community_language value
    language_input.when_present.select_value value
    save_btn.when_present.click
    sleep 3
    wait_until_admin_setup_page_loaded
    @browser.wait_until{ language_input.present? }
    @browser.wait_until{ language_input.value == value }
  end
end
