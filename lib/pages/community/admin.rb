require 'pages/community'

class Pages::Community::Admin < Pages::Community

  def initialize(config, options = {})
    super(config)
    @url = config.base_url + "/admin/#{config.slug}"
  end

  admin_sidebar                             { div(:id => "admin-accordion") }

  admin_sidebar_overview_link               { link(:css => "#admin-accordion a[href$=overview]") }
  admin_sidebar_advertising_link            { link(:css => "#admin-accordion a[href$=embedding]") }

  admin_accordion_toggle_branding           { div(:css => "#admin-accordion .accordion-toggle[data-target='#branding']") }

  admin_sidebar_branding_link               { link(:css => "#admin-accordion .admin-menu-branding a") }
  admin_sidebar_email_designer_link         { link(:css => "#admin-accordion .admin-menu-email-designer a") }
  admin_sidebar_widget_theme_link           { link(:css => "#admin-accordion .admin-menu-widget-theme a") }
  admin_sidebar_ui_custom_link              { link(:css => "#admin-accordion .admin-menu-ui-customization a") }

  admin_accordion_toggle_integrations       { div(:css => "#admin-accordion .accordion-toggle[data-target='#integrations']") }

  admin_sidebar_ecommerce_link              { link(:css => "#admin-accordion .admin-menu-ecommerce a") }
  admin_sidebar_marketing_link              { link(:css => "#admin-accordion .admin-menu-marketing a") }
  admin_sidebar_saml_link                   { link(:css => "#admin-accordion .admin-menu-sso a") }
  admin_sidebar_oauth_link                  { link(:css => "#admin-accordion .admin-menu-oauth a") }
  admin_sidebar_social_app_link             { link(:css => "#admin-accordion .admin-menu-social a") }
  admin_sidebar_webhooks_link               { link(:css => "#admin-accordion .admin-menu-webhooks a") }
  admin_sidebar_trusted_origin_link         { link(:css => "#admin-accordion .admin-trusted-origin a") }

  admin_accordion_toggle_prod_setup         { div(:css => "#admin-accordion .accordion-toggle[data-target='#productSetup']") } 

  admin_sidebar_topics_link                 { link(:css => "#admin-accordion .admin-menu-topics a") }
  admin_sidebar_events_link                  { link(:css => "#admin-accordion .admin-menu-events a") }
  admin_sidebar_tags_link                   { link(:css => "#admin-accordion .admin-menu-tags a") }
  admin_sidebar_home_link                   { link(:css => "#admin-accordion .admin-menu-home a") }
  admin_sidebar_about_link                  { link(:css => "#admin-accordion .admin-menu-about a") }
  admin_sidebar_profile_field_link          { link(:css => "#admin-accordion .admin-menu-profile-fields a") } 
  admin_sidebar_disclosures_link            { link(:css => "#admin-accordion a[href$=disclosures]") }
  # admin_sidebar_contributor_link            { link(:css => "#admin-accordion .admin-menu-social a") }
  admin_sidebar_contributor_link            { link(:href => /contributor_rating/) }

  # User Management
  admin_accordion_toggle_um                 { div(:css => "#admin-accordion .accordion-toggle[data-target='#userManagement']") } 
  # User Management -> Users
  admin_sidebar_users_link                  { link(:css => "#admin-accordion .admin-menu-user-management a") }
  # User Management -> Permissions
  admin_sidebar_permission_link             { link(:css => "#admin-accordion .admin-menu-permissions a") }

  admin_accordion_toggle_content_admin      { div(:css => "#admin-accordion .accordion-toggle[data-target='#contentAdmin']") }

  admin_sidebar_moderation_link             { link(:css => "#admin-accordion .admin-menu-moderation a") }
  admin_sidebar_profanity_blocker_link      { link(:css => "#admin-accordion .admin-menu-moderation-pb a") }

  admin_accordion_toggle_analytics          { div(:css => "#admin-accordion .accordion-toggle[data-target='#analytics']") }

  admin_sidebar_third_party_analytics_link  { link(:css => "#admin-accordion .admin-menu-analytics a")  }
  admin_sidebar_reports_link                { link(:css => "#admin-accordion .admin-menu-reports a")  }

  admin_sidebar_setup_link                  { link(:href => /general_setup/) }

  # needs css-selectors (-ALL-)
  modal                                      { div(:class => "modal-content") }
  # admin_page_table_header                    { div(:class => "shown col-lg-12 sap-table-header").div(:class => "btn-group pull-right").button(:type => "button", :value => "Date Modified") }
  spinner                                    { i(:class => /spinner/) }
 # admin_link                                 { link(:href => "/admin/#{$networkslug}") }

  # go to the default page of admin
  def navigate_in
    @browser.goto @config.base_url+ "/admin/#{@config.slug}"

    if @browser.div(:css => ".my-auto-show-modal").present?
      @browser.button(:css => ".my-auto-show-modal .btn-primary").when_present.click
      @browser.wait_until { !@browser.div(:css => ".my-auto-show-modal").present? }
    end

    @browser.wait_until($t) { sidebar_present? }
  end

  def navigate_in_from_ui
    user_dropdown.when_present.click
    @browser.wait_until($t) { user_dropdown_menu.present? }
    admin_link.when_present.click
    @browser.wait_until($t) { sidebar_present? }
  end

  def toggle_on_accordion(accordion_element, expected_item)
    accept_policy_warning

    # when go to admin page, sidebar would be flashed sometimes 
    # in which case the accordion might be expanded and then collapsed.
    begin
      @browser.wait_until(1) { accordion_element.when_present.attribute_value("class").include?("collapsed") }
    rescue
    end

    if accordion_element.when_present.attribute_value("class").include?("collapsed")
      scroll_to_element accordion_element
      @browser.execute_script("window.scrollBy(0,-200)") # in case overlapped by top navigator bar
      sleep(2)
      accordion_element.when_present.click
    end  

    @browser.wait_until($t) { !accordion_element.when_present.attribute_value("class").include?("collapsed") }
    sleep 1
  end

  def toggle_off_accordion(accordion_element)
    accept_policy_warning
    accordion_element.when_present.click unless accordion_element.when_present.attribute_value("class").include?("collapsed")
  end

  def sidebar_present?
    admin_sidebar.present?
  end  

  def sidebar_item(item)
    case item
    when :overview
      admin_sidebar_overview_link
    when :setup
      admin_sidebar_setup_link
    when :advertising
      admin_sidebar_advertising_link
    when :permissions
      admin_sidebar_permission_link
    when :users
      admin_sidebar_users_link
    when :branding
      admin_sidebar_branding_link
    when :email_designer
      admin_sidebar_email_designer_link
    when :widget_theme
      admin_sidebar_widget_theme_link
    when :ui_custom
      admin_sidebar_ui_custom_link
    when :ecommerce
      admin_sidebar_ecommerce_link
    when :marketing
      admin_sidebar_marketing_link
    when :saml
      admin_sidebar_saml_link
    when :oauth
      admin_sidebar_oauth_link
    when :social_app
      admin_sidebar_social_app_link
    when :webhooks
      admin_sidebar_webhooks_link
    when :trusted_origin
      admin_sidebar_trusted_origin_link
    when :tags
      admin_sidebar_tags_link
    when :topics
      admin_sidebar_topics_link
    when :events
      admin_sidebar_events_link
    when :home
      admin_sidebar_home_link
    when :about
      admin_sidebar_about_link
    when :profile_field
      admin_sidebar_profile_field_link
    when :disclosures
      admin_sidebar_disclosures_link
    when :contributor
      admin_sidebar_contributor_link
    when :moderation
      admin_sidebar_moderation_link
    when :profanity_blocker
      admin_sidebar_profanity_blocker_link  
    when :analytics
      admin_sidebar_third_party_analytics_link
    when :reports
      admin_sidebar_reports_link
    when :users
      admin_sidebar_users_link
    else 
      raise "Admin->#{item} not supported yet"  
    end
  end  

  def switch_to_sidebar_item(item)
    case item
    when :branding, :email_designer, :widget_theme, :ui_custom
      toggle_on_accordion(admin_accordion_toggle_branding, item)
    when :ecommerce
      toggle_on_accordion(admin_accordion_toggle_integrations, item)
    when :marketing
      toggle_on_accordion(admin_accordion_toggle_integrations, item)
    when :saml
      toggle_on_accordion(admin_accordion_toggle_integrations, item)
    when :oauth
      toggle_on_accordion(admin_accordion_toggle_integrations, item)
    when :social_app
      toggle_on_accordion(admin_accordion_toggle_integrations, item)
    when :webhooks
      toggle_on_accordion(admin_accordion_toggle_integrations, item)
    when :trusted_origin
      toggle_on_accordion(admin_accordion_toggle_integrations, item)
    when :tags
      toggle_on_accordion(admin_accordion_toggle_prod_setup, item)
    when :topics
      toggle_on_accordion(admin_accordion_toggle_prod_setup, item)
    when :events
      toggle_on_accordion(admin_accordion_toggle_prod_setup, item)
    when :home
      toggle_on_accordion(admin_accordion_toggle_prod_setup, item)
    when :about
      toggle_on_accordion(admin_accordion_toggle_prod_setup, item)
    when :profile_field
      toggle_on_accordion(admin_accordion_toggle_prod_setup, item)
    when :contributor
      toggle_on_accordion(admin_accordion_toggle_prod_setup, item)
    when :moderation
      toggle_on_accordion(admin_accordion_toggle_content_admin, item)
    when :profanity_blocker
      toggle_on_accordion(admin_accordion_toggle_content_admin, item)
    when :analytics
      toggle_on_accordion(admin_accordion_toggle_analytics, item)
    when :reports
      toggle_on_accordion(admin_accordion_toggle_analytics, item)
    when :advertising
    when :overview  
    when :permissions
      toggle_on_accordion(admin_accordion_toggle_um, item)
    when :users
      toggle_on_accordion(admin_accordion_toggle_um, item)
    when :setup
      admin_sidebar_setup_link.when_present.click 
    when :disclosures
      if @browser.div(:id => "policy-warning").present?
        @browser.execute_script("window.scrollTo(0,2000)")
      end
      admin_sidebar_disclosures_link.when_present.click 
    else
      raise "Admin->#{item} not supported yet"   
    end

    # sometime, the sidebar item is overlapped with the top nav bar
    @browser.wait_until { sidebar_item(item).present? }
    scroll_to_element sidebar_item(item)
    @browser.execute_script("window.scrollBy(0,-200)")
    sidebar_item(item).when_present.click
  end

  def can_see_admin_dropdown_option?
    @browser.wait_until { user_dropdown.present? }
    user_dropdown.click
    @browser.wait_until { user_dropdown_menu.present? }
    return admin_link.present?
  end

  def assert_all_admin_tabs_with_network_admin_capability
    # Overview
    # @browser.wait_until { sidebar_item(:overview).present? }
    # Disclosures
    @browser.wait_until { sidebar_item(:disclosures).present? }
    # Branding
    switch_to_sidebar_item(:branding)
    @browser.wait_until { sidebar_item(:branding).present? }
    @browser.wait_until { sidebar_item(:ui_custom).present? }
    @browser.wait_until { sidebar_item(:widget_theme).present? }
    @browser.wait_until { sidebar_item(:email_designer).present? }
    # User Management
    switch_to_sidebar_item(:permissions)
    @browser.wait_until { sidebar_item(:permissions).present? }
    @browser.wait_until { sidebar_item(:users).present? }
    # Analytics
    switch_to_sidebar_item(:analytics)
    @browser.wait_until { sidebar_item(:analytics).present? }
    @browser.wait_until { sidebar_item(:reports).present? }
    # Integrations
    switch_to_sidebar_item(:ecommerce)
    @browser.wait_until { sidebar_item(:ecommerce).present? }
    @browser.wait_until { sidebar_item(:marketing).present? }
    @browser.wait_until { sidebar_item(:saml).present? }
    @browser.wait_until { sidebar_item(:oauth).present? }
    @browser.wait_until { sidebar_item(:social_app).present? }
  end
end
