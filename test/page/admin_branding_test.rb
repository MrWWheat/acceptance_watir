require 'watir_test'
require 'pages/community/admin_branding'
require 'pages/community/topicdetail'
require 'pages/community/topic_list'
require 'pages/community/idea_list'
require 'pages/community/event_list'

class AdminBrandingTest < WatirTest

  def setup
    super
    @admin_branding_page = Pages::Community::AdminBranding.new(@config)
    @topic_list_page = Pages::Community::TopicList.new(@config)
    @topicdetail_page = Pages::Community::TopicDetail.new(@config)
    @idea_list_page = Pages::Community::IdeaList.new(@config)
    # assigning @current_page helps error reporting
    #  give good contextual data
    @current_page = @admin_branding_page
    puts "[[[ #{name} ::: #{user_for_test} ]]]" if @config.verbose?
    @browser = @config.browser
    @admin_branding_page.start!(user_for_test)
  end

  def teardown
    super
  end

  user :network_admin

  p1

  def test_00010_check_branding_tab
    assert @admin_branding_page.branding_chg_logo_heading.present?
    assert @admin_branding_page.branding_fonts_heading.present?
    assert @admin_branding_page.branding_normal_link_color_field.present?
  end

  def test_00020_set_branding_logo  
    assert @admin_branding_page.change_logo_button.present?
    #uploading sephora logo
    sephora_logo_file = File.expand_path(File.dirname(__FILE__)+"/../../seeds/development/images/sephora-logo.jpg")
    sephora_logo_name = "sephora-logo.jpg"

    @admin_branding_page.change_logo(sephora_logo_file, sephora_logo_name)
    assert @admin_branding_page.logo_img_by_name(sephora_logo_name).present?
    
    #uploading saplogo back
    sap_logo_file = File.expand_path(File.dirname(__FILE__)+"/../../seeds/development/images/saplogo.png")
    sap_logo_name = "saplogo.png"

    @admin_branding_page.change_logo(sap_logo_file, sap_logo_name)
    assert @admin_branding_page.logo_img_by_name(sap_logo_name).present?
  end

  def test_00030_change_link_color
    set_link_color = "#ff2f92"
    set_link_color_rgb = "rgba(255, 47, 146, 1)"

    # change link color settting
    @admin_branding_page.change_normal_link_color(set_link_color)

    # go to topic list page
    @browser.goto @topic_list_page.url
    @browser.wait_until($t) { @topic_list_page.topic_list_breadcrumb.present? }
    
    # verify the color change takes effect
    @browser.wait_until { @topic_list_page.topic_list_breadcrumb.style('color') == set_link_color_rgb }
    # breadcrumb_color = @topic_list_page.topic_list_breadcrumb.style('color')
    # assert_match set_link_color_rgb, breadcrumb_color, "Link color is not per branding settings"

    # go to Admin->Branding page
    @admin_branding_page.navigate_in_directly_from_url

    # restore the normal link color to default
    @admin_branding_page.change_normal_link_color("#0433ff")
  end

  def test_00040_change_button_color
    set_button_color = "#ffd479"
    set_button_color_rgb = "rgba(255, 212, 121, 1)"

    # change the button color setting
    @admin_branding_page.change_button_color("#ffd479")
    
    # go to topic list page
    @browser.goto @topic_list_page.url
    @browser.wait_until($t) { @topic_list_page.topic_list_breadcrumb.present? }

    # go to the first topic detail
    @topic_list_page.goto_first_topic
    @browser.wait_until($t) { @topicdetail_page.topic_filter.present? }

    # verify the color of Create New button in topic detail page
    create_new_button_color = @topicdetail_page.topic_detail_create_new_button.style('background-color')
    assert_match set_button_color_rgb, create_new_button_color, "Button color is not per branding settings"
    
    # go to Admin->Branding page
    @admin_branding_page.navigate_in_directly_from_url
    @browser.wait_until($t) { @admin_branding_page.branding_reset_button.present? }

    assert @admin_branding_page.branding_reset_button.present?

    # reset the change to default
    @admin_branding_page.branding_reset_button.when_present.click 
    @admin_branding_page.branding_publish_button.when_present.click

    @browser.wait_until(60) { @admin_branding_page.branding_publish_button.present? }
    assert @admin_branding_page.branding_publish_button.present?
    @browser.wait_until($t) { !@admin_branding_page.branding_publish_progress.present? }
    assert !@admin_branding_page.branding_publish_progress.present?
  end

  def test_00050_set_favicon
    # set favicon
    nike_favicon = "https://g.foolcdn.com/editorial/images/182320/nike_logo_02_large.jpg"

    @browser.execute_script("window.scrollBy(0,5000)")

    @admin_branding_page.favicon_field.focus
    @admin_branding_page.favicon_field.set nike_favicon

    # click publish button
    @browser.execute_script("window.scrollBy(0,7000)")
    @admin_branding_page.branding_publish_button.click

    @browser.wait_until(60) { @admin_branding_page.branding_publish_button.present? }
    assert @admin_branding_page.branding_publish_button.present?
    @browser.wait_until($t) { !@admin_branding_page.branding_publish_progress.present? }
    assert !@admin_branding_page.branding_publish_progress.present?

    # go to topic list page
    @browser.goto @topic_list_page.url
    @browser.wait_until($t) { @topic_list_page.topic_list_breadcrumb.present? }

    # verify the icon change takes effect
    @browser.wait_until($t) { @browser.html =~ /nike_logo/ }
    assert @browser.html =~ /nike_logo/
   
    # go to Admin->Branding page
    @admin_branding_page.navigate_in_directly_from_url

    @browser.wait_until($t) { @admin_branding_page.branding_reset_button.present? }
    assert @admin_branding_page.branding_reset_button.present?

    # reset the change to default
    @admin_branding_page.branding_reset_button.when_present.click 
    @admin_branding_page.branding_publish_button.when_present.click

    @browser.wait_until(60) { @admin_branding_page.branding_publish_button.present? }
    assert @admin_branding_page.branding_publish_button.present?
    @browser.wait_until($t) { !@admin_branding_page.branding_publish_progress.present? }
    assert !@admin_branding_page.branding_publish_progress.present?
  end

  # def test_00060_change_top_navigation_color
  #   set_link_color = "#ff2f92"
  #   set_link_color_rgb = "rgba(255, 47, 146, 1)"

  #   # change link color settting
  #   @admin_branding_page.change_navigation_bar_color(set_link_color)

  #   # go to topic list page
  #   @browser.goto @topic_list_page.url
  #   @browser.wait_until($t) { @topic_list_page.topic_list_breadcrumb.present? }
    
  #   # verify the color change takes effect
  #   breadcrumb_color = @browser.link(:text => "Topics").style('color')
    
  #   assert_match set_link_color_rgb, breadcrumb_color, "Link color is not per branding settings"

  #   # go to Admin->Branding page
  #   @admin_branding_page.navigate_in_directly_from_url

  #   # restore the normal link color to default
  #   @admin_branding_page.change_normal_link_color("#0433ff")
  # end

  def test_00070_change_sub_navigation_color
    set_link_color = "#ff2f92"
    set_link_color_rgb = "rgba(255, 47, 146, 1)"

    # change text color settting
    @admin_branding_page.change_sub_navigation_color(set_link_color)

    # go to topic list page
    @browser.goto @topic_list_page.url
    @browser.wait_until($t) { @topic_list_page.topic_list_breadcrumb.present? }

    # go to the first topic detail
    @topic_list_page.goto_first_topic
    @browser.wait_until($t) { @topicdetail_page.topic_filter.present? }
    
    # verify the color change takes effect
    breadcrumb_color = @browser.element(:text => "Questions").style('color')
    assert_match set_link_color_rgb, breadcrumb_color, "Link color is not per branding settings"

    # go to Admin->Branding page
    @admin_branding_page.navigate_in_directly_from_url

    # restore the normal link color to default
    @admin_branding_page.change_normal_link_color("#0433ff")
  end

  def test_00080_change_fonts
    set_fonts = "Verdana, Geneva, sans-serif"

    # change fonts settting
    @admin_branding_page.change_fonts(set_fonts)

    @browser.wait_until { @browser.element(:css => ".col-lg-12").present? && @browser.element(:css => ".col-lg-12").style("font-family") == set_fonts}
    assert @browser.element(:css => ".col-lg-12").style("font-family") == "Verdana, Geneva, sans-serif"

    # go to topic list page
    @browser.goto @topic_list_page.url
    @browser.wait_until($t) { @topic_list_page.topic_list_breadcrumb.present? }
    
    # verify the color change takes effect
    title_font = @browser.element(:css => ".customization-topic-content").when_present.style('font-family')
    
    assert_match set_fonts, title_font, "title text is not per branding settings"

    # go to Admin->Branding page
    @admin_branding_page.navigate_in_directly_from_url

    # restore the normal link color to default
    @admin_branding_page.change_normal_link_color("#0433ff")
  end

  def test_00090_change_header_title_fonts
    set_fonts = "Georgia, serif"
    set_color = "#ff2f92"
    set_color_rgb = "rgba(255, 47, 146, 1)"

    # change fonts settting
    @admin_branding_page.change_header_title_font_and_color(set_fonts,set_color)

    @browser.wait_until { @browser.element(:css => ".col-lg-12" , :index => 1).present? && @browser.element(:css => ".col-lg-12",:index => 1).style("font-family") == set_fonts}
    assert @browser.element(:css => ".col-lg-12", :index => 1).style("font-family") == set_fonts

    # go to topic list page
    @browser.goto @topic_list_page.url
    @browser.wait_until($t) { @topic_list_page.topic_list_breadcrumb.present? }
    
    # verify the color change takes effect
    title_font = @browser.element(:css => ".gadget-list-heading").when_present.style('font-family')
    assert_match set_fonts, title_font, "title text is not per branding settings"

    title_color = @browser.element(:css => ".gadget-list-heading").when_present.style('color')
    assert_match set_color_rgb, title_color, "title text is not per branding settings"

    # go to Admin->Branding page
    @admin_branding_page.navigate_in_directly_from_url

    # restore the normal link color to default
    @admin_branding_page.change_normal_link_color("#0433ff")
  end

  def test_00100_change_lines_color
    set_link_color = "#ff2f92"
    set_link_color_rgb = "1px solid rgb(255, 47, 146)"

    # change text color settting
    @admin_branding_page.change_lines_color(set_link_color)

    # go to topic list page
    @browser.goto @topic_list_page.url
    @browser.wait_until($t) { @topic_list_page.topic_list_breadcrumb.present? }

    # go to the first topic detail
    @topic_list_page.goto_first_topic
    @browser.wait_until($t) { @topicdetail_page.topic_filter.present? }

    @browser.element(:css => ".media-heading a").when_present.click
    
    @browser.wait_until($t) { @browser.element(:css => ".media-info hr").present? }
    
    # verify the color change takes effect
    breadcrumb_color = @browser.element(:css => ".media-info hr").style('border-top')

    assert_match set_link_color_rgb, breadcrumb_color, "Link color is not per branding settings"

    # go to Admin->Branding page
    @admin_branding_page.navigate_in_directly_from_url

    # restore the normal link color to default
    @admin_branding_page.change_normal_link_color("#0433ff")
  end
end