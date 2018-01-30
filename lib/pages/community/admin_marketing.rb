require 'pages/community/admin'
require 'pages/community/home'

class Pages::Community::AdminMarketing < Pages::Community::Admin

  def initialize(config, options = {})
    super(config)
    @url = config.base_url + "/admin/#{config.slug}/marketing_sync"
  end

  def start!(user)
    @home_page = Pages::Community::Home.new(@config)
    @home_page.start!(user)
    navigate_in # go to Admin default page
    accept_policy_warning
  end

  marketing_int_config_tab               { link(:text => "Configuration") }
  marketing_int_config_page              { form(:class => "form-horizontal integration-form")}
  marketing_int_config_sync_button       { button(:class => "btn btn-primary", :value => "Sync")}
  marketing_int_config_save_button       { button(:class => "btn btn-default", :value => "Save")}
  marketing_int_config_sync_suc_info     { div(:text => /In progress/)}

  marketing_int_history_tab              { link(:text => "History") }
  marketing_int_history_page             { div(:class => "integration-history-wrap") }
  marketing_int_history_resync_button    { button(:class => "btn btn-default", :value => "Re-Sync") }
  marketing_int_history_rows             { div(:class => "integration-history-wrap").divs(:class => "row")}
  marketing_int_history_content          { div(:class => /admin-grid integration-history/)}


  def navigate_to_marketing_int
    switch_to_sidebar_item(:marketing)

    @browser.wait_until($t) { sidebar_item(:marketing).attribute_value("class").include?("active") }
    @browser.wait_until($t) { marketing_int_config_page.present? }
  end

  def switch_to_marketing_int_tab(tab)
    case tab
      when :config
        marketing_int_config_tab.when_present.click
        @browser.wait_until($t) { marketing_int_config_page.present? }
        @browser.wait_until($t) { marketing_int_config_save_button.present? }
        @browser.wait_until($t) { marketing_int_config_sync_button.present? }
      when :history
        marketing_int_history_tab.when_present.click
        @browser.wait_until($t) { marketing_int_history_page.present? }
        @browser.wait_until($t) { marketing_int_history_resync_button.present? }
    end
  end


end