require 'pages/community/admin'
require 'pages/community/home'

class Pages::Community::AdminBranding < Pages::Community::Admin

  def initialize(config, options = {})
    super(config)
    @url = config.base_url+"/admin/#{config.slug}/branding"
  end

  def start!(user)
    # login starting from Home page
    @home_page = Pages::Community::Home.new(@config)
    @home_page.start!(user)

    navigate_in
  end

  # branding                          { link(:class => "ember-view", :text => "Branding") }
  #branding_url = $base_url + "/admin/#{$networkslug}/branding"
  branding_chg_logo_heading         { h5(:css => ".admin-branding-panel h5.text-primary:nth-of-type(1)") }
  branding_fonts_heading            { h5(:css => ".admin-branding-panel h5.text-primary:nth-of-type(2)")  }
  # branding_page                     { div(:class => "col-lg-4", :text => /Main Body Font/) }
  # branding_heading                  { h5(:text => "Change Logo") }
  change_logo_button                { button(:class => "btn btn-default", :value => "Browse your device") }
  change_logo_file_field            { file_field(:css=> ".admin-branding-panel .photo-browse-input") }
  logo_cropper                      { div(:css => ".cropper-canvas.cropper-modal.cropper-crop") }
  logo_select_photo_btn             { button(:css => ".modal-footer .file-upload-select-button") }
  logo_img                          { img(:class => "nav-logo") }
  sephora_logo_img                  { img(:class => "nav-logo" , :src => /sephora-logo.jpg/) }
  sap_logo_img                      { img(:class => "nav-logo", :src => /saplogo.png/) }

  # branding_normal_link_color_field  { div(:class => "col-lg-8") }
  branding_normal_link_color_field  { div(:css => ".admin-branding-panel h5.text-primary:nth-of-type(3) + div.row .col-lg-8") }
  branding_preview_button           { button(:class => "btn btn-primary ", :value => "Preview") }
  branding_publish_button           { button(:class => "btn btn-primary ", :value => "Publish") }
  branding_reset_button             { button(:class => "btn btn-default ", :value => "Reset to Default") }
  branding_publish_progress         { div(:class => "progress-bar") }
  branding_publish_spinner          { i(:class => "fa fa-spinner fa-spin") }
  profile_link_color                { link(:href => /profile/) }

  branding_button_color_field       { div(:class => "row", :index => 12).div(:class => "col-lg-8").text_field(:class => "ember-view ember-text-field") }#@browser.text_field(:class => "ember-view ember-text-field", :index=> 8)
  lines_color_field                 { div(:class => "row", :index => 14).div(:class => "col-lg-8").text_field(:class => "ember-view ember-text-field") }#@browser.text_field(:class => "ember-view ember-text-field", :index=> 8)
  favicon_field                     { div(:class => "row", :index => 29).div(:class => "col-lg-8").text_field(:class => "ember-view ember-text-field") }#  :index=> 22)
  navigation_bar_color_field        { div(:class => "row", :index => 19).div(:class => "col-lg-8").text_field(:class => "ember-view ember-text-field") }#@browser.text_field(:class => "ember-view ember-text-field", :index=> 8)
  sub_navigation_color_field        { div(:class => "row", :index => 22).div(:class => "col-lg-8").text_field(:class => "ember-view ember-text-field") }#@browser.text_field(:class => "ember-view ember-text-field", :index=> 8)
  fonts_select                      { select_list(:css => ".col-lg-8 select") }
  header_title_font_select          { select_list(:css => ".col-lg-8 select", :index => 1) }
  header_title_color_field          { div(:class => "row", :index => 11).div(:class => "col-lg-8").text_field(:class => "ember-view ember-text-field") }#@browser.text_field(:class => "ember-view ember-text-field", :index=> 8)
  

  def navigate_in
    super

    switch_to_sidebar_item(:branding)

    wait_until_page_loaded

    accept_policy_warning
  end

  def navigate_in_directly_from_url
    @browser.goto @url

    wait_until_page_loaded

    accept_policy_warning
  end 

  def wait_until_page_loaded
    @browser.wait_until($t) { branding_chg_logo_heading.present? }
    @browser.wait_until($t) { change_logo_button.present?}
    @browser.wait_until($t) { branding_normal_link_color_field.present? }
  end  

  def logo_img_by_name(logo_file_name)
    @browser.element(:css => ".nav-logo[src$='#{logo_file_name}']")
  end  

  def change_logo(logo_file, logo_file_name)
    @browser.wait_until($t) { change_logo_button.present? }
    
    #uploading sephora logo
    if $os == "windows"
      @browser.execute_script('$(".photo-upload-browse").removeClass("photo-upload-browse")')
    end

    change_logo_file_field.set logo_file
    @browser.wait_until($t) { logo_cropper.present? }
    
    logo_select_photo_btn.click
    @browser.wait_until { !logo_cropper.present? }

    @browser.refresh # for asserting img src
    @browser.wait_until($t) { logo_img_by_name(logo_file_name).present? }
  end

  def change_normal_link_color(new_color)
    @browser.wait_until($t) { branding_normal_link_color_field.present? }
   
    @browser.execute_script('$("div.col-lg-8 input:first").focus()')
    @browser.execute_script("$('div.col-lg-8 input:first').val('#{new_color}')")
    @browser.execute_script("window.scrollBy(0,7000)")

    branding_publish_button.when_present.click

    @browser.wait_until { branding_publish_progress.present? }
    @browser.wait_until(90) { !branding_publish_progress.present? }
    @browser.wait_until(60) { !branding_publish_spinner.present? }
  end

  def change_header_title_font_and_color(font, new_color)
    @browser.wait_until($t) { header_title_font_select.present? }

    @browser.execute_script("window.scrollBy(0,2000)")

    header_title_font_select.when_present.select_value(font)
    header_title_color_field.focus
    header_title_color_field.set new_color
    @browser.execute_script("window.scrollBy(0,7000)")

    branding_publish_button.when_present.click

    @browser.wait_until(90) { !branding_publish_progress.present? }
  end

  def change_button_color(new_color)
    @browser.wait_until($t) { branding_button_color_field.present? }

    @browser.execute_script("window.scrollBy(0,2000)")

    branding_button_color_field.focus
    branding_button_color_field.set new_color
    @browser.execute_script("window.scrollBy(0,7000)")

    branding_publish_button.when_present.click

    @browser.wait_until(60) { !branding_publish_progress.present? }
  end

  def change_lines_color(new_color)
    @browser.wait_until($t) { lines_color_field.present? }

    @browser.execute_script("window.scrollBy(0,2000)")

    lines_color_field.focus
    lines_color_field.set new_color
    @browser.execute_script("window.scrollBy(0,7000)")

    branding_publish_button.when_present.click

    @browser.wait_until(60) { !branding_publish_progress.present? }
  end

  def change_navigation_bar_color(new_color)
    @browser.wait_until($t) { navigation_bar_color_field.present? }

    @browser.execute_script("window.scrollBy(0,2000)")

    navigation_bar_color_field.focus
    navigation_bar_color_field.set new_color
    @browser.execute_script("window.scrollBy(0,7000)")

    branding_publish_button.when_present.click

    @browser.wait_until(60) { !branding_publish_progress.present? }
  end


  def change_fonts(font)
    @browser.wait_until($t) { fonts_select.present? }

    @browser.execute_script("window.scrollBy(0,2000)")

    fonts_select.when_present.select_value(font)
    @browser.execute_script("window.scrollBy(0,7000)")

    branding_publish_button.when_present.click

    @browser.wait_until(90) { !branding_publish_progress.present? }
  end

  def change_sub_navigation_color(new_color)
    @browser.wait_until($t) { sub_navigation_color_field.present? }

    @browser.execute_script("window.scrollBy(0,2000)")

    sub_navigation_color_field.focus
    sub_navigation_color_field.set new_color
    @browser.execute_script("window.scrollBy(0,7000)")
    sleep(2)
    branding_publish_button.when_present.click

    @browser.wait_until(90) { !branding_publish_progress.present? }
  end
end
