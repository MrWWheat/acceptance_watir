require 'pages/community/admin'
require 'pages/community/home'

class Pages::Community::AdminWidgetTheme < Pages::Community::Admin

  def initialize(config, options = {})
    super(config)
    @url = config.base_url + "/admin/#{@config.slug}/widget_theme"
  end

  def start!(user)
    # login starting from Home page
    @home_page = Pages::Community::Home.new(@config)
    @home_page.start!(user)

    navigate_in
  end

  # admin_preview                           { div(:id => "admin-preview-row") }
  widget_theme_edit_btn                   { link(:css => "#admin-preview-row a") }
  # widget_theme_page                       { div(:class => "col-sm-9").div(:class => "row") }
  widget_theme_page_head                  { div(:class => "toolbar-margin") }
  widget_theme_page_publish_btn           { div(:class => "toolbar-margin").button(:text => /Publish/) }
  widget_theme_page_reset_btn           { div(:class => "toolbar-margin").button(:text => /Reset/) }
  widget_theme_page_publish_modal         { div(:id => "publish-modal-footer") }
  widget_theme_page_header_font_size      { select_list(:id => "widget-header-font-size") }
  widget_theme_page_body_font_size        { select_list(:id => "widget-body-font-size") }
  widget_sample_preview                   { div(:id => "Excelsior-Controller-SimpleReview-preview-example")}
  widget_sample_preview_title             { p(:css => ".e-post-sample .e-post-title") }
  widget_sample_preview_content           { div(:css => ".e-post-sample .e-post-content") }
  widget_layout_selector                  { select(:id => "layout-selecter")}
  # widget_original_layout                  { select(:id => "layout-selecter").options[0]}
  # widget_simplified_layout                { select(:id => "layout-selecter").options[1]}

  widget_theme_page_reset_confirm_button   {button(:class => "btn btn-default",:text => /Reset/)}


  def navigate_in
    super

    accept_policy_warning

    switch_to_sidebar_item(:widget_theme)

    wait_until_widget_admin_page_loaded
  end

  def wait_until_widget_admin_page_loaded
    @browser.wait_until($t) { widget_theme_edit_btn.present? }
    @browser.wait_until($t) { widget_sample_preview.present? }
  end

  def reset_theme
    click_edit_widget_theme_btn

    current_title_font_size = widget_sample_preview_title.when_present.style("font-size")
    current_content_font_size = widget_sample_preview_content.when_present.style("font-size")

    widget_theme_page_reset_btn.when_present.click
    widget_theme_page_reset_confirm_button.when_present.click
    @browser.wait_until { toast_success_message.present? }

    default_font_size = "12px"

    if current_title_font_size != default_font_size
      @browser.wait_until($t) { widget_sample_preview_title.when_present.style("font-size") == default_font_size }
    end
    if current_content_font_size != default_font_size
      @browser.wait_until($t) { widget_sample_preview_content.when_present.style("font-size") == default_font_size }
    end

    publish_theme_changes

    @browser.wait_until($t) { widget_sample_preview_title.when_present.style("font-size") == default_font_size }
    @browser.wait_until($t) { widget_sample_preview_content.when_present.style("font-size") == default_font_size }
  end

  def change_theme font
    click_edit_widget_theme_btn

    widget_theme_page_header_font_size.when_present.select font
    widget_theme_page_body_font_size.when_present.select font

    @browser.wait_until($t) { widget_sample_preview_title.when_present.style("font-size") == font }
    @browser.wait_until($t) { widget_sample_preview_content.when_present.style("font-size") == font }
    
    publish_theme_changes

    @browser.wait_until($t) { widget_sample_preview_title.when_present.style("font-size") == font }
    @browser.wait_until($t) { widget_sample_preview_content.when_present.style("font-size") == font }
  end

  def publish_theme_changes
    # Sometimes, the Publish button is overlapped by navigation top bar
    @browser.execute_script("window.scrollTo(0,document.documentElement.scrollTop)")
    sleep 0.5
    @browser.wait_until { !toast_success_message.present? }
    widget_theme_page_publish_btn.when_present.click

    @browser.wait_until {widget_theme_page_publish_modal.present?}

    widget_theme_page_publish_modal.button(:text => /Publish/).when_present.click

    wait_until_widget_admin_page_loaded
  end  

  def click_edit_widget_theme_btn
    widget_theme_edit_btn.when_present.click

    @browser.wait_until($t) { widget_theme_page_head.present? }
  end

  def set_widget_theme_template(option)
    click_edit_widget_theme_btn
    widget_layout_selector.select_value(option)
    publish_theme_changes
    @browser.refresh
    wait_until_widget_admin_page_loaded
  end
end