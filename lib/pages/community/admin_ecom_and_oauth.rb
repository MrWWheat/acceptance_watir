require 'pages/community/admin'
require 'pages/community/home'

class Pages::Community::AdminEcomAndOauth < Pages::Community::Admin

  def initialize(config, options = {})
    super(config)
    @url = config.base_url + "/admin/#{@config.slug}/integration"
  end

  def start!(user)
    # login starting from Home page
    @home_page = Pages::Community::Home.new(@config)
    @home_page.start!(user)

    navigate_in # go to Admin default page
    accept_policy_warning
  end

  hybris_ecomm                      { link(:class => "ember-view", :text => "E-commerce Integration") }
  ecomm_int_settings_tab            { link(:text => "Settings") }
  ecomm_int_settings_page           { div(:class => "col-md-11 settings-item") }
  ecomm_int_settings_active_prod_radio       { input(:css => ".integration .row div:nth-child(1) input") }
  ecomm_int_settings_active_prod_radio_text  { div(:class => "col-md-11 settings-item", :text => /Active Products/) }
  ecomm_int_settings_all_prod_radio          { input(:css => ".integration .row div:nth-child(3) input") }
  ecomm_int_settings_all_prod_radio_text     { div(:class => "col-md-11 settings-item", :text => /All Products/) }

  ecomm_int_config_tab              { link(:text => "Configuration") }
  ecomm_int_config_page             { form(:class => "form-horizontal integration-form") }
  ecomm_int_config_sync_button             { button(:class => "btn btn-primary", :value => "Sync") }
  ecomm_int_config_save_button             { button(:class => "btn btn-default", :value => "Save") }

  ecomm_int_history_tab             { link(:text => "History") }
  ecomm_int_history_page            { div(:class => "integration-history-wrap") }
  ecomm_int_history_rows            { div(:class => "integration-history-wrap").divs(:class => "row")}
  ecomm_int_history_resync_button   { button(:class => "btn btn-default", :value => "Re-Sync") }

  oauth_configuration               { link(:class => "ember-view", :text => "OAuth Configuration") }
  oauth_page                        { div(:class => "admin-grid admin-auth-grid col-md-12") }
  oauth_page_new_app_button         { button(:class => "btn btn-primary", :value => "New Application") }
  oauth_new_app_dialog              { div(:class => "form-group") }
  oauth_new_app_name_field          { input(:placeholder => "Enter Name") }
  oauth_new_app_callback_field      { input(:placeholder => "Enter Callback") }
  oauth_new_app_create_button       { button(:class => "btn btn-primary", :text=>"Create") }
  oauth_new_app_cancel_button       { button(:class => "btn btn-default", :text=>"Cancel") }
  
  oauth_app_row                     { div(:class => "cell cell-title col-xs-6 col-sm-4") }

  def navigate_to_ecomm_int
    switch_to_sidebar_item(:ecommerce)

    @browser.wait_until($t) { sidebar_item(:ecommerce).attribute_value("class").include?("active") }
    @browser.wait_until($t) { ecomm_int_settings_page.present? } 
  end
  
  def navigate_to_oauth_config
    switch_to_sidebar_item(:oauth)

    @browser.wait_until($t) { sidebar_item(:oauth).attribute_value("class").include?("active") }
    @browser.wait_until($t) { oauth_page.present? }
    @browser.wait_until($t) { oauth_page_new_app_button.present? }
  end

  def switch_to_ecomm_int_tab(tab)
    case tab
    when :settings
      ecomm_int_settings_tab.when_present.click
      @browser.wait_until($t) { ecomm_int_settings_page.present? }
    when :config 
      ecomm_int_config_tab.when_present.click
      @browser.wait_until($t) { ecomm_int_config_page.present? }
      @browser.wait_until($t) { ecomm_int_config_save_button.present? }
      @browser.wait_until($t) { ecomm_int_config_sync_button.present? }
    when :history
      ecomm_int_history_tab.when_present.click
      @browser.wait_until($t) { ecomm_int_history_page.present? }
      @browser.wait_until($t) { ecomm_int_history_resync_button.present? }
    when :custom
    end  
  end  
end
