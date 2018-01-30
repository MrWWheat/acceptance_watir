require 'watir_test'
require 'pages/community/admin_ui_customization'
require 'pages/community/profile'
require 'pages/community/topic_list'
require 'pages/community/admin'
require 'pages/community/topicdetail'
require 'pages/community/conversationdetail'
require 'pages/community/gadgets/home_conversations'
require 'pages/community/gadgets/about_nav'
require 'pages/community/searchpage'
require 'pages/community/notification'

class AdminUICustomizationTest < WatirTest

  def setup
    super

    @admin_uicustom_page = Pages::Community::AdminUICustomization.new(@config)
    @uidesign_page = Pages::Community::UICustomizationDesign.new(@config)
    @home_page = Pages::Community::Home.new(@config)
    @about_page = Pages::Community::About.new(@config)
    @topic_page = Pages::Community::TopicList.new(@config)
    @profile_page = Pages::Community::Profile.new(@config)
    @layout_page = Pages::Community::Layout.new(@config)
    @search_page = Pages::Community::Search.new(@config)
    @notification_page = Pages::Community::Notification.new(@config)

    @service_t_name = "services community"
    @simple_t_name = "simple template"

    @font_family_to_test = "Times New Roman"
    @red_rgb = "rgba(255, 0, 0, 1)"
    @test_image_filename = "Nike1Banner.jpg"
    @test_image_file = File.join(@config.data_dir, "images/#{@test_image_filename}")
    @test_bklogo_filename = "saplogo.png"
    @test_bklogo_file = File.join(@config.data_dir, "images/#{@test_bklogo_filename}")

    @current_page = @admin_uicustom_page
    puts "[[[ #{name} ::: #{user_for_test} ]]]" if @config.verbose?
    @browser = @config.browser
    @admin_uicustom_page.start!(user_for_test)
  end

  def teardown
    super
  end

  user :network_admin
  p1
  # def test_00010_check_cloned_template_thumbnail
  #   existing_count = @admin_uicustom_page.cloned_templatelist.templates.size
    
  #   # Step 1: Go to template select page.
  #   @admin_uicustom_page.click_create_new_tp_link

  #   # save the template information
  #   thumb_srv = @admin_uicustom_page.default_templatelist.template_at_name(@service_t_name).thumb_file
  #   tid_srv = @admin_uicustom_page.default_templatelist.template_at_name(@service_t_name).template_id
  #   thumb_sml = @admin_uicustom_page.default_templatelist.template_at_name(@simple_t_name).thumb_file
  #   tid_sml = @admin_uicustom_page.default_templatelist.template_at_name(@simple_t_name).template_id

  #   # Step 2: Clone "Service Community" template
  #   @admin_uicustom_page.clone_template(@service_t_name, existing_count) do |design_page|
  #     # verify the Home banner background is consistent with the current template
  #     expected_color = "rgba(64, 165, 232, 1)" ##40a5e8;
  #     @browser.wait_until { design_page.design_content_panel.gadget(:home_banner).background_color == expected_color }
  #     assert design_page.design_content_panel.gadget(:home_banner).background_color == expected_color
  #   end

  #   assert @admin_uicustom_page.cloned_templatelist.templates.size - existing_count == 1
  #   existing_count += 1 

  #   # verify the new cloned template's thumbnail is correct
  #   first_new_template = @admin_uicustom_page.cloned_templatelist.first_inactive_template
  #   assert first_new_template.thumb_file == thumb_srv, "Thumbnail file is inconsistent with template"

  #   # Step 3: Go to template select page again and clone "Simple Community" template
  #   @admin_uicustom_page.clone_template(@simple_t_name) do |design_page|
  #     expected_color = "rgba(255, 255, 255, 1)" ##FFFFFF
  #     @browser.wait_until { design_page.design_content_panel.gadget(:home_banner).background_color == expected_color }
  #     assert design_page.design_content_panel.gadget(:home_banner).background_color == expected_color
  #   end

  #   assert @admin_uicustom_page.cloned_templatelist.templates.size - existing_count == 1

  #   # verify the new cloned template's thumbnail is correct
  #   first_new_template = @admin_uicustom_page.cloned_templatelist.first_inactive_template
  #   assert first_new_template.thumb_file == thumb_sml, "Thumbnail file is inconsistent with template"
  # end

  def test_00020_interact_cloned_templates
    # Step 1: Clean existing inactivated templates if existing (at least one activated template left).
    @admin_uicustom_page.delete_all_inactivated_templates

    # Step 2: clone a simple template.
    @admin_uicustom_page.clone_template

    # Step 3: rename a template
    new_template_name = "Watir Test Template - #{get_timestamp}"
    @admin_uicustom_page.cloned_templatelist.rename_template_at_index(1, new_template_name)
    assert @admin_uicustom_page.cloned_templatelist.templates[1].name == new_template_name

    # Step 4: copy a template
    @admin_uicustom_page.cloned_templatelist.copy_template_at_index(1)
    assert @admin_uicustom_page.cloned_templatelist.templates.size == 3

    # Step 5: preview a template
    @admin_uicustom_page.cloned_templatelist.templates[1].preview
    verify_after_preview_template

    # delete template
    @admin_uicustom_page.delete_all_inactivated_templates
    assert @admin_uicustom_page.cloned_templatelist.templates.size == 1
  end 

  p1
  def test_00030_activate_cloned_template
    # Step 1: Clean existing templates if existing
    @admin_uicustom_page.delete_all_inactivated_templates

    topnav_gadget = Gadgets::Community::TopNavigator.new(@config)
    old_link_background_rgb = topnav_gadget.topics_link.when_present.style("color")

    # Step 2: clone a template
    @admin_uicustom_page.create_new_tp

    # Step 3: change the color setting for top navigator
    topnv_gadget = @uidesign_page.design_content_panel.gadget(:topnav)
    topnv_gadget.select

    text_editor = @uidesign_page.propeditor_panel.editor(name: "Styling", subname: "Navigator Text", type: :text)
    @browser.wait_until { text_editor.present? }
    text_editor.expand

    text_editor.set_color("#ff0000")
    @uidesign_page.save_then_exit

    # Step 4: activate the template
    @admin_uicustom_page.cloned_templatelist.templates[1].activate
    sleep(2)
    # verify the color setting take effect in Home page
    @browser.goto @home_page.url
    @browser.refresh # sometimes the setting won't take effect unless refresh
    @browser.wait_until { topnav_gadget.present? }

    red_rgb = "rgba(255, 0, 0, 1)"
    @browser.wait_until { topnav_gadget.topics_link.when_present.style("color") == red_rgb }
    assert topnav_gadget.topics_link.style("color") == red_rgb

    # Step 5: deactivate the template
    @admin_uicustom_page.navigate_in
    @admin_uicustom_page.cloned_templatelist.templates[1].activate

    # verify the color setting reverted in Home page
    sleep(2)
    @browser.goto @home_page.url
    @browser.wait_until { topnav_gadget.present? }

    @browser.wait_until { topnav_gadget.topics_link.when_present.style("color") == old_link_background_rgb }
    assert topnav_gadget.topics_link.style("color") == old_link_background_rgb
  end  

  p1
  def test_00031_customize_cloned_template
    # Step 1: Clean existing templates if existing
    @admin_uicustom_page.delete_all_inactivated_templates

    # Step 2: clone a template
    @admin_uicustom_page.create_new_tp

    # Step 3: change the color setting for top navigator
    topnv_gadget = @uidesign_page.design_content_panel.gadget(:topnav)
    topnv_gadget.select

    text_editor = @uidesign_page.propeditor_panel.editor(name: "Styling", subname: "Navigator Text", type: :text)
    @browser.wait_until { text_editor.present? }
    text_editor.expand

    text_editor.set_color("#ff0000")
    @uidesign_page.save_then_exit

    # Step 4: preview and verify the template
    @admin_uicustom_page.cloned_templatelist.templates[1].preview

    sleep(2)
    red_rgb = "rgba(255, 0, 0, 1)"
    @browser.windows.last.use
    #byebug
    @browser.wait_until { @admin_uicustom_page.us_custom_prview_link.when_present.style("color") == red_rgb }
    assert @admin_uicustom_page.us_custom_prview_link.when_present.style("color") == red_rgb

    # Step 5: activate and verify the template
    @admin_uicustom_page.us_custom_prview_activate.when_present.click

    @browser.wait_until { @admin_uicustom_page.us_custom_prview_link.when_present.style("color") == red_rgb }
    assert @admin_uicustom_page.us_custom_prview_link.when_present.style("color") == red_rgb

    # Step 6: verify the template is displayed as activated.
    @browser.windows.last.close
    @browser.goto @admin_uicustom_page.url
    @browser.wait_until { @admin_uicustom_page.customize_present? }
    assert @admin_uicustom_page.customize_present?

  end

  # p2
  # def test_00040_preview_default_templatelist
  #   # Step 1: Go to template select page.
  #   @admin_uicustom_page.goto_default_templatelist_page

  #   # Step 2: Preview for service community template.
  #   @admin_uicustom_page.default_templatelist.template_at_name(@service_t_name).preview

  #   verify_after_preview_template do
  #     home_content_gadget =  Gadgets::Community::HomeContent.new(@config)
  #     @browser.wait_until { home_content_gadget.present? }
  #     assert home_content_gadget.present?
  #   end

  #   # Step 3: Preview for simple template
  #   @admin_uicustom_page.default_templatelist.template_at_name(@simple_t_name).preview

  #   verify_after_preview_template
  # end

  p2
  def test_00041_preview_design_page
    # Step 1: clone a simple template if no existing
    @admin_uicustom_page.clone_template \
    if @admin_uicustom_page.cloned_templatelist.templates.size == 0

    # Step 2: Customize the first cloned template
    @admin_uicustom_page.customize_cloned_template_at_index(0)

    # Step 3: Click Preview button in design page
    @uidesign_page.navigation_panel.preview_btn.when_present.click

    verify_after_preview_template
  end

  p1
  def test_00050_customize_top_navigator
    customize_and_activate_template(
      pages: [{page: :default, 
        gadgets: [{type: :topnav, 
          editors: [{name: "Styling", subname: "Navigator Text", type: :text},
                    {name: "Widget Labels", type: :topnav_layout}]}]}])

    # verify the color setting take effect in Home page
    @browser.goto @home_page.url
    @browser.refresh # sometimes the setting won't take effect unless refresh
    topnav_gadget = Gadgets::Community::TopNavigator.new(@config)
    @browser.wait_until { topnav_gadget.present? }

    @browser.wait_until { topnav_gadget.home_link.when_present.style("color") == @red_rgb }
    assert_all_keys({
      :color => topnav_gadget.home_link.style("color") == @red_rgb,
      # :font_family => topnav_gadget.home_link.style("font-family") == @font_family_to_test, # ""\"Times New Roman\"""
      :font_family => topnav_gadget.home_link.style("font-family").include?(@font_family_to_test),
      :font_weight => ["bold", "700"].include?(topnav_gadget.home_link.style("font-weight")),
      :font_style => topnav_gadget.home_link.style("font-style") == "italic",
      :font_size => topnav_gadget.home_link.style("font-size") == "16px",
      :text_transform => topnav_gadget.home_link.style("text-transform") == "uppercase",
      :line_height => topnav_gadget.home_link.style("line-height") == "30px",
      :text_decoration => topnav_gadget.home_link.style("text-decoration").include?("underline")
      })

    assert_all_keys({
      :home_label => topnav_gadget.home_link.text == "主页",
      :events_toggle => !topnav_gadget.events_link.present?,
      :ideas_toggle => !topnav_gadget.ideas_link.present?
      })

    @browser.goto @about_page.url
    @browser.refresh
    @browser.wait_until { topnav_gadget.present? }

    @browser.wait_until { topnav_gadget.home_link.when_present.style("color") == @red_rgb }
    assert_all_keys({
      :color => topnav_gadget.home_link.style("color") == @red_rgb,
      :font_family => topnav_gadget.home_link.style("font-family").include?(@font_family_to_test),
      :font_weight => ["bold", "700"].include?(topnav_gadget.home_link.style("font-weight")),
      :font_style => topnav_gadget.home_link.style("font-style") == "italic",
      :font_size => topnav_gadget.home_link.style("font-size") == "16px",
      :text_transform => topnav_gadget.home_link.style("text-transform") == "uppercase",
      :line_height => topnav_gadget.home_link.style("line-height") == "30px",
      :text_decoration => topnav_gadget.home_link.style("text-decoration").include?("underline")
      })
  end  

  def test_00060_customize_footer
    customize_and_activate_template(
      pages: [{page: :default, gadgets: [{type: :footer, editors: [{name: "Styling", subname: "Footer Text", type: :text}]}]}])

    # verify the color setting take effect in Home page
    @browser.goto @home_page.url
    @browser.refresh # sometimes the setting won't take effect unless refresh
    footer_gadget = Gadgets::Community::Footer.new(@config)
    @browser.wait_until { footer_gadget.present? }
    @browser.wait_until { footer_gadget.footer.when_present.style("color") == @red_rgb }
    assert footer_gadget.footer.style("color") == @red_rgb

    @browser.goto @about_page.url
    @browser.refresh
    @browser.wait_until { footer_gadget.present? }
    @browser.wait_until { footer_gadget.footer.when_present.style("color") == @red_rgb }
    assert footer_gadget.footer.style("color") == @red_rgb
  end  

  def test_00070_customize_about_banner
    customize_and_activate_template(
      pages: [{page: :about, gadgets: [{type: :banner, editors: [{name: "Styling", subname: "Image", type: :image}]}]}]) 

    @browser.goto @about_page.url
    @browser.refresh # sometimes the setting won't take effect unless refresh
    banner_gadget = Gadgets::Community::Banner.new(@config)
    @browser.wait_until { banner_gadget.bg_image =~ /#{@test_image_filename}/ }
    assert_all_keys({
      :bgcolor => banner_gadget.bg_color == @red_rgb,
      :bg_image => banner_gadget.bg_image =~ /#{@test_image_filename}/
      })
  end 

  def test_00071_customize_about_content
    new_about_text_title = "My Title"
    new_about_text_content = "My content"
    customize_and_activate_template(
      pages: [{page: :about, section: "Content",
        gadgets: [{type: :text_element, type_options: {title: "title"}, action: :add, from_widget: "Text Element",
          editors: [{name: "Widget Labels", type: :widget_labels, 
                      settings: [{type: :title, value: new_about_text_title},
                                 {type: :content, value: "My content"}]}]}]}])
    @browser.goto @about_page.url
    @browser.refresh 

    text_gadget = Gadgets::Community::TextElement.new(@config, { title: "My Title" })
    @browser.wait_until { text_gadget.present? }
    aboutnav_gagdet = Gadgets::Community::AboutNavigator.new(@config)
    @browser.wait_until { aboutnav_gagdet.present? }

    assert_equal text_gadget.title.when_present.text, new_about_text_title
    assert_equal text_gadget.content.when_present.text, "My content" 
    assert_equal aboutnav_gagdet.item_at_index(2).when_present.text, new_about_text_title
  end  

  def test_00080_customize_home_topics_carousel
    customize_and_activate_template(
      pages: [{page: :home, section: "Search", 
        gadgets: [{type: :home_topics_carousel, 
          editors: [{name: "Styling", subname: "Heading", type: :text},
                    {name: "Styling", subname: "Title", type: :text},
                    {name: "Widget Labels", type: :carousel_layout}]}]}])

    @browser.goto @home_page.url
    @browser.wait_until { @home_page.homebanner.present? } # without this wait, the later refresh will stay in admin page
    @browser.refresh # sometimes the setting won't take effect unless refresh
    carousel_gadget = Gadgets::Community::TopicsCarousel.new(@config)
    @browser.wait_until { carousel_gadget.header.when_present.style("color") == @red_rgb }

    assert_all_keys({
      :color => carousel_gadget.header.style("color") == @red_rgb,
      :font_family => carousel_gadget.header.style("font-family").include?(@font_family_to_test),
      :font_weight => ["bold", "700"].include?(carousel_gadget.header.style("font-weight")),
      :font_style => carousel_gadget.header.style("font-style") == "italic",
      :font_size => carousel_gadget.header.style("font-size") == "16px",
      :text_transform => carousel_gadget.header.style("text-transform") == "uppercase",
      :line_height => carousel_gadget.header.style("line-height") == "30px",
      :text_decoration => carousel_gadget.header.style("text-decoration").include?("underline")
      }) 

    @browser.wait_until { carousel_gadget.topic_title.when_present.style("color") == @red_rgb }
    assert_all_keys({
      :color => carousel_gadget.topic_title.style("color") == @red_rgb,
      :font_family => carousel_gadget.topic_title.style("font-family").include?(@font_family_to_test),
      :font_weight => ["bold", "700"].include?(carousel_gadget.topic_title.style("font-weight")),
      :font_style => carousel_gadget.topic_title.style("font-style") == "italic",
      :font_size => carousel_gadget.topic_title.style("font-size") == "16px",
      :text_transform => carousel_gadget.topic_title.style("text-transform") == "uppercase",
      :line_height => carousel_gadget.topic_title.style("line-height") == "30px",
      :text_decoration => carousel_gadget.topic_title.style("text-decoration").include?("underline")
      })

    @browser.wait_until { carousel_gadget.page_count == 6 }
    assert carousel_gadget.page_count == 6
  end 

  def test_00081_customize_home_delete_gadgets
    customize_and_activate_template(
      pages: [{page: :home, gadgets: [{type: :home_topics_carousel, action: :delete}]}])

    @browser.goto @home_page.url
    @browser.refresh # sometimes the setting won't take effect unless refresh
    topics_gadget = Gadgets::Community::TopicsCarousel.new(@config)

    assert !topics_gadget.present?
  end  

  def test_00082_customize_home_add_gadgets
    customize_and_activate_template(
      pages: [{page: :home, section: "Content", 
        gadgets: [{type: :home_openq, from_widget: "Open Questions"}]}])
    sleep(2)
    @browser.wait_until { @browser.goto @home_page.url }
    @browser.refresh # sometimes the setting won't take effect unless refresh
    openq_gadget = Gadgets::Community::OpenQ.new(@config)

    @browser.wait_until { openq_gadget.present? }
    assert openq_gadget.present?
  end 

  def test_00083_customize_home_add_rename_delete_section
    # Step 1: Clean existing templates if existing
    @admin_uicustom_page.delete_all_inactivated_templates

    # Step 2: Customize the default simple template
    @admin_uicustom_page.customize_default_template(@simple_t_name)

    # Step 3: Select Home page to add a new section and add a widget to it
    @uidesign_page.navigation_panel.select_page_section(page: :home)
    home_page = @uidesign_page.navigation_panel.page(:home)
    new_navsection = home_page.add_section("One column")
    new_contentsection_id = new_navsection.id.gsub(/^section-nav/,"section")
    new_contentsection = @uidesign_page.design_content_panel.section_at_id(new_contentsection_id)
    @uidesign_page.design_content_panel.add_widget_to_section(new_contentsection, :home_openq, "Open Questions")

    new_section_name = "My new section"
    new_navsection.rename(new_section_name)

    @uidesign_page.exit

    # Step 4: activate the template
    @admin_uicustom_page.cloned_templatelist.templates[1].activate
    sleep(2)
    # Step 5: go to Home page to check Open Questions widget is visible.
    @browser.wait_until { @browser.goto @home_page.url }
    @browser.refresh # sometimes the setting won't take effect unless refresh
    openq_gadget = Gadgets::Community::OpenQ.new(@config)

    @browser.wait_until { openq_gadget.present? }
    assert openq_gadget.present?

    # Step 6: go to Admin to delete the new section
    @admin_uicustom_page.navigate_in
    @admin_uicustom_page.customize_cloned_template_at_index(0)
    @uidesign_page.navigation_panel.select_page_section(page: :home)
    home_page = @uidesign_page.navigation_panel.page(:home)
    home_page.section_at_name(new_section_name).delete
    @browser.wait_until { home_page.section_at_name(new_section_name).nil? }

    # Step 7: go to Home page to check Open Questions widget is gone.
    @browser.wait_until { @browser.goto @home_page.url }
    @browser.refresh # sometimes the setting won't take effect unless refresh
    openq_gadget = Gadgets::Community::OpenQ.new(@config)

    assert !openq_gadget.present?
  end 

  def xtest_00090_customize_logo_title
    # Step 1: Clean existing templates if existing
    @admin_uicustom_page.delete_all_inactivated_templates

    # Step 2: Customize the default simple template
    @admin_uicustom_page.customize_default_template(@simple_t_name)

    @uidesign_page.navigation_panel.select_group("Logo & Title")
    @browser.wait_until { @uidesign_page.logo_title_editor_panel.present? }

    @uidesign_page.logo_title_editor_panel.change_settings(
      [{type: :title, value: "My Company"}, {type: :logo, value: @test_image_file}])

    @uidesign_page.exit

    # Step 4: activate the template
    @admin_uicustom_page.cloned_templatelist.templates[1].activate
  end 

  p1
  def test_00100_custom_style_header
    # Step 1: Clean existing templates if existing
    @admin_uicustom_page.delete_all_inactivated_templates

    # Step 2: Customize the default simple template
    @admin_uicustom_page.customize_default_template(@simple_t_name)

    # Step 3: Click the top_navigation
    @uidesign_page.navigation_panel.top_navigation.when_present.click
    #@browser.wait_until { @uidesign_page.propeditor_panel.present? }

    navigation_bar = @uidesign_page.propeditor_panel.editor(name: "Navigation Bar", subname: "Navigation Bar", type: :navigation_bar)
    @browser.wait_until { navigation_bar.present? }
    navigation_bar.expand unless navigation_bar.expanded?

    # Step 4: Choose e-commerce  option
    navigation_bar.ecommunity.when_present.click
    @browser.wait_until { @uidesign_page.toast_success_message.present? }
    @browser.wait_until { !@uidesign_page.toast_message.present? }

    # Step 5: Change the setting for top navigator
    text_editor = @uidesign_page.propeditor_panel.editor(name: "Styling", subname: "Navigator Text", type: :text)
    @browser.wait_until { text_editor.present? }
    text_editor.expand
    change_style(text_editor)

    text_editor.select_style("Top Background")
    text_editor.set_background("#dde9d9")

    text_editor.select_style("Middle")
    change_style(text_editor)

    text_editor.select_style("Middle Background")
    text_editor.set_background("#cfe925")

    text_editor.select_style("Bottom")
    change_style(text_editor)

    text_editor.select_style("Bottom Background")
    text_editor.set_background("#4634e9")

    @uidesign_page.save_then_exit

    # Step 6: activate the template
    @admin_uicustom_page.cloned_templatelist.templates[1].activate

    sleep(2)
    # Step 7: verify the setting take effect in Home page
    @browser.goto @home_page.url
    @browser.refresh # sometimes the setting won't take effect unless refresh

    red_rgb = "rgba(255, 0, 0, 1)"
    top_rgb = "rgba(221, 233, 217, 1)"
    middle_rgb = "rgba(207, 233, 37, 1)"
    bottom_rgb = "rgba(70, 52, 233, 1)"
  
    assert @browser.element(:css => ".navigation.navigation-top").when_present.style("color") == red_rgb
    assert @browser.element(:css => ".navigation.navigation-top").when_present.style("font-family") == "Verdana"
    assert @browser.element(:css => ".navigation.navigation-top").when_present.style("font-size") == "8px"
    assert @browser.element(:css => ".navigation.navigation-top").when_present.style("text-transform") == "uppercase"
    assert @browser.element(:css => ".navigation.navigation-top").when_present.style("line-height") == "10px"
    assert @browser.element(:css => ".navigation.navigation-top").when_present.style("background-color") == top_rgb


    assert @browser.element(:css => ".navigation.navigation-middle").when_present.style("color") == red_rgb
    assert @browser.element(:css => ".navigation.navigation-middle").when_present.style("font-family") == "Verdana"
    assert @browser.element(:css => ".navigation.navigation-middle").when_present.style("font-size") == "8px"
    assert @browser.element(:css => ".navigation.navigation-middle").when_present.style("text-transform") == "uppercase"
    assert @browser.element(:css => ".navigation.navigation-middle").when_present.style("line-height") == "10px"
    assert @browser.element(:css => ".navigation.navigation-middle").when_present.style("background-color") == middle_rgb

    topnav_gadget = Gadgets::Community::TopNavigator.new(@config)
    @browser.wait_until { topnav_gadget.present? }
    assert topnav_gadget.topics_link.style("color") == red_rgb
    assert topnav_gadget.topics_link.style("font-family") == "Verdana"
    assert topnav_gadget.topics_link.style("font-size") == "8px"
    assert topnav_gadget.topics_link.style("text-transform") == "uppercase"
    assert topnav_gadget.topics_link.style("line-height") == "10px"

    assert @browser.element(:css => ".navigation.navigation-bottom").when_present.style("background-color") == bottom_rgb

    # Step 8: deactivate the template
    @admin_uicustom_page.navigate_in
    @admin_uicustom_page.cloned_templatelist.templates[1].activate

  end

  def change_style(text_editor)
    text_editor.set_color("#ff0000")
    text_editor.select_font("Verdana")
    text_editor.set_font_size(8)
    text_editor.select_charstyle("uppercase")
    text_editor.set_line_height(10)
  end

  p1
  def test_00101_custom_style_footer
    # Step 1: Clean existing templates if existing
    @admin_uicustom_page.delete_all_inactivated_templates

    # Step 2: Customize the default simple template
    @admin_uicustom_page.customize_default_template(@simple_t_name)

    # Step 3: Click the footer_navigation
    @uidesign_page.navigation_panel.footer_navigation.when_present.click
    #@browser.wait_until { @uidesign_page.propeditor_panel.present? }

    navigation_bar = @uidesign_page.propeditor_panel.editor(name: "Footer Bar", subname: "Footer Bar", type: :footer_bar)
    @browser.wait_until { navigation_bar.present? }
    navigation_bar.expand unless navigation_bar.expanded?

    # Step 4: Choose e-commerce  option
    navigation_bar.ecommunityFooter.when_present.click
    @browser.wait_until { @uidesign_page.toast_success_message.present? }
    @browser.wait_until { !@uidesign_page.toast_message.present? }

    # Step 5: Change the setting for top navigator
    text_editor = @uidesign_page.propeditor_panel.editor(name: "Styling", subname: "Navigator Text", type: :text)
    @browser.wait_until { text_editor.present? }
    text_editor.expand

    change_style(text_editor)

    text_editor.select_style("Top Background")
    text_editor.set_background("#dde9d9")

    text_editor.select_style("Bottom")
    change_style(text_editor)

    text_editor.select_style("Bottom Background")
    text_editor.set_background("#4634e9")

    @uidesign_page.save_then_exit

    # Step 6: activate the template
    @admin_uicustom_page.cloned_templatelist.templates[1].activate
    sleep(2)

    # Step 7: verify the setting take effect in Home page
    @browser.goto @home_page.url
    @browser.refresh # sometimes the setting won't take effect unless refresh

    red_rgb = "rgba(255, 0, 0, 1)"
    top_rgb = "rgba(221, 233, 217, 1)"
    bottom_rgb = "rgba(70, 52, 233, 1)"
  
    assert @browser.div(:class => "footer-top").when_present.style("color") == red_rgb
    assert @browser.div(:class => "footer-top").when_present.style("font-family") == "Verdana"
    assert @browser.div(:class => "footer-top").when_present.style("font-size") == "8px"
    assert @browser.div(:class => "footer-top").when_present.style("text-transform") == "uppercase"
    assert @browser.div(:class => "footer-top").when_present.style("line-height") == "10px"
    assert @browser.div(:class => "footer-top").when_present.style("background-color") == top_rgb


    assert @browser.div(:class => "footer-bottom").when_present.style("color") == red_rgb
    assert @browser.div(:class => "footer-bottom").when_present.style("font-family") == "Verdana"
    assert @browser.div(:class => "footer-bottom").when_present.style("font-size") == "8px"
    assert @browser.div(:class => "footer-bottom").when_present.style("text-transform") == "uppercase"
    assert @browser.div(:class => "footer-bottom").when_present.style("line-height") == "10px"
    assert @browser.div(:class => "footer-bottom").when_present.style("background-color") == bottom_rgb

    # Step 8: deactivate the template
    @admin_uicustom_page.navigate_in
    @admin_uicustom_page.cloned_templatelist.templates[1].activate

  end

  p1
  def test_00102_enable_hybris_style
    # Step 1: Clean existing templates if existing
    @admin_uicustom_page.delete_all_inactivated_templates

    # Step 2: Customize the default simple template
    @admin_uicustom_page.customize_default_template(@simple_t_name)

    # Step 3: Click the top_navigation
    @uidesign_page.navigation_panel.top_navigation.when_present.click
    
    navigation_bar = @uidesign_page.propeditor_panel.editor(name: "Navigation Bar", subname: "Navigation Bar", type: :navigation_bar)
    @browser.wait_until { navigation_bar.present? }

    navigation_bar.expand unless navigation_bar.expanded?

    # Step 4: Choose e-commerce  option
    navigation_bar.ecommunity.when_present.click
    @browser.wait_until { @uidesign_page.toast_success_message.present? }
    @browser.wait_until { !@uidesign_page.toast_message.present? }

    # Step 5: Click the footer_navigation
    @uidesign_page.navigation_panel.footer_navigation.when_present.click
    navigation_bar = @uidesign_page.propeditor_panel.editor(name: "Footer Bar", subname: "Footer Bar", type: :footer_bar)
    @browser.wait_until { navigation_bar.present? }

    navigation_bar.expand unless navigation_bar.expanded?

    # Step 6: Choose e-commerce  option
    navigation_bar.ecommunityFooter.when_present.click
    @browser.wait_until { @uidesign_page.toast_success_message.present? }
    @browser.wait_until { !@uidesign_page.toast_message.present? }
    @uidesign_page.exit

    # Step 7: activate the template
    @admin_uicustom_page.cloned_templatelist.templates[1].activate

    sleep(2)

    # Step 8: verify the setting take effect in Home page
    @browser.goto @home_page.url
    @browser.refresh
    @browser.wait_until { @home_page.search_bar.present? }
    assert @browser.element(:css => ".navigation.navigation-top").present?
    assert @browser.div(:class => "footer-top").present?

    # Step 9: verify the setting take effect in About page
    @browser.goto @about_page.url
    @browser.refresh
    @browser.wait_until { @home_page.search_bar.present? }
    assert @browser.element(:css => ".navigation.navigation-top").present?
    assert @browser.div(:class => "footer-top").present?

    # Step 10: verify the setting take effect in Topic page
    @browser.goto @topic_page.url
    @browser.refresh
    @browser.wait_until { @home_page.search_bar.present? }
    assert @browser.element(:css => ".navigation.navigation-top").present?
    assert @browser.div(:class => "footer-top").present?

    # Step 11: verify the setting take effect in Profile page
    @browser.goto @profile_page.url
    @browser.refresh
    @browser.wait_until { @home_page.search_bar.present? }
    assert @browser.element(:css => ".navigation.navigation-top").present?
    assert @browser.div(:class => "footer-top").present?

    # Step 12: deactivate the template
    @admin_uicustom_page.navigate_in
    @admin_uicustom_page.cloned_templatelist.templates[1].activate

  end

  p1
  def test_00103_disable_hybris_style
    # Step 1: Clean existing templates if existing
    @admin_uicustom_page.delete_all_inactivated_templates

    # Step 2: Customize the default simple template
    @admin_uicustom_page.customize_default_template(@simple_t_name)

    # Step 3: Click the top_navigation
    @uidesign_page.navigation_panel.top_navigation.when_present.click
    
    navigation_bar = @uidesign_page.propeditor_panel.editor(name: "Navigation Bar", subname: "Navigation Bar", type: :navigation_bar)
    @browser.wait_until { navigation_bar.present? }
    navigation_bar.expand unless navigation_bar.expanded?

    # Step 4: Choose commerce  option
    navigation_bar.community.when_present.click

    # Step 5: Click the footer_navigation
    @uidesign_page.navigation_panel.footer_navigation.when_present.click
    navigation_bar = @uidesign_page.propeditor_panel.editor(name: "Footer Bar", subname: "Footer Bar", type: :footer_bar)
    @browser.wait_until { navigation_bar.present? }
    navigation_bar.expand unless navigation_bar.expanded?

    # Step 6: Choose commerce  option
    navigation_bar.communityFooter.when_present.click

    # Step 7: save the template
    @uidesign_page.propeditor_panel.save_btn.click
    @uidesign_page.exit

    # Step 8: activate the template
    @admin_uicustom_page.cloned_templatelist.templates[1].activate

    # Step 9: verify the setting take effect in Home page
    @browser.goto @home_page.url
    @browser.refresh
    @browser.wait_until { @home_page.search_bar.present? }
    assert !@browser.element(:css => ".navigation.navigation-top").present?
    assert !@browser.div(:class => "footer-top").present?

    # Step 10: verify the setting take effect in About page
    @browser.goto @about_page.url
    @browser.refresh
    @browser.wait_until { @home_page.search_bar.present? }
    assert !@browser.element(:css => ".navigation.navigation-top").present?
    assert !@browser.div(:class => "footer-top").present?

    # Step 11: verify the setting take effect in Topic page
    @browser.goto @topic_page.url
    @browser.refresh
    @browser.wait_until { @home_page.search_bar.present? }
    assert !@browser.element(:css => ".navigation.navigation-top").present?
    assert !@browser.div(:class => "footer-top").present?

    # Step 12: verify the setting take effect in Profile page
    @browser.goto @profile_page.url
    @browser.refresh
    @browser.wait_until { @home_page.search_bar.present? }
    assert !@browser.element(:css => ".navigation.navigation-top").present?
    assert !@browser.div(:class => "footer-top").present?

    # Step 13: deactivate the template
    @admin_uicustom_page.navigate_in
    @admin_uicustom_page.cloned_templatelist.templates[1].activate

  end

  p2
  def test_00200_hybris_style_header
    # Step 1: Clean existing templates if existing
    @admin_uicustom_page.delete_all_inactivated_templates

    # Step 2: Customize the default simple template
    @admin_uicustom_page.customize_default_template(@simple_t_name)

    # Step 3: Click the top_navigation
    @uidesign_page.navigation_panel.top_navigation.when_present.click
    
    navigation_bar = @uidesign_page.propeditor_panel.editor(name: "Navigation Bar", subname: "Navigation Bar", type: :navigation_bar)
    @browser.wait_until { navigation_bar.present? }

    navigation_bar.expand unless navigation_bar.expanded?

    # Step 4: Choose e-commerce  option
    navigation_bar.ecommunity.when_present.click
    @browser.wait_until { @uidesign_page.toast_success_message.present? }
    @browser.wait_until { !@uidesign_page.toast_message.present? }

    @uidesign_page.exit

    # Step 5: activate the template
    @admin_uicustom_page.cloned_templatelist.templates[1].activate

    # Step 6: verify the search bar take effect in Home page
    @browser.goto @home_page.url
    @browser.refresh
    sleep(2)
    search_keyword = "watir"
    @layout_page.search_at_topnav(search_keyword)
    assert @search_page.results_searched_out?(keyword: search_keyword)

    # Step 7: verify the notification bell icon/shopping icon take effect in Home page
    @browser.goto @home_page.url
    @browser.refresh

    @notification_page.notification.when_present.click
    assert @notification_page.notification_dropdown.present?

    @layout_page.shopping_cart_icon.click
    assert @layout_page.shopping_cart_popup.present?

    @layout_page.shopping_cart_icon.click
    
    @layout_page.user_avatar.when_present.click
    @browser.wait_until { @home_page.search_bar.present? }
    assert @browser.element(:css => ".navigation.navigation-top").present?

    # Step 8: deactivate the template
    @admin_uicustom_page.navigate_in
    @admin_uicustom_page.cloned_templatelist.templates[1].activate

  end

  p2
  def test_00201_hybris_style_footer
    # Step 1: Clean existing templates if existing
    @admin_uicustom_page.delete_all_inactivated_templates

    # Step 2: Customize the default simple template
    @admin_uicustom_page.customize_default_template(@simple_t_name)

    # Step 3: Click the footer_navigation
    @uidesign_page.navigation_panel.footer_navigation.when_present.click
    navigation_bar = @uidesign_page.propeditor_panel.editor(name: "Footer Bar", subname: "Footer Bar", type: :footer_bar)
    @browser.wait_until { navigation_bar.present? }

    navigation_bar.expand unless navigation_bar.expanded?

    # Step 4: Choose e-commerce  option
    
    navigation_bar.ecommunityFooter.when_present.click
    @browser.wait_until { @uidesign_page.toast_success_message.present? }
    @browser.wait_until { !@uidesign_page.toast_message.present? }

    # Step 5: Set widget url
    footer_url = "https://www.sap.com/index.html"

    widget_labels = @uidesign_page.propeditor_panel.editor(name: "Widget Labels", subname: "Widget Labels", type: :widget)
    @browser.wait_until { widget_labels.present? }
    widget_labels.expand
    widget_labels.e_commerce_terms_of_use_url.when_present.set footer_url
    widget_labels.e_commerce_privacy_policy_url.when_present.set footer_url
    widget_labels.e_commerce_imprint_url.when_present.set footer_url
    widget_labels.e_commerce_contact_us_url.when_present.set footer_url

    @uidesign_page.propeditor_panel.save(false)
    @uidesign_page.exit

    # Step 6: activate the template
    @admin_uicustom_page.cloned_templatelist.templates[1].activate

    sleep(2)
    # Step 7: verify the footer url take effect in Home page
    @browser.goto @home_page.url
    @browser.refresh
    @layout_page.terms_of_use.when_present.click

    assert @browser.url==footer_url

    @browser.goto @home_page.url
    @browser.refresh
    @layout_page.privacy_policy.when_present.click
    assert @browser.url==footer_url

    @browser.goto @home_page.url
    @browser.refresh
    @layout_page.imprint.when_present.click
    assert @browser.url==footer_url

    @browser.goto @home_page.url
    @browser.refresh
    @layout_page.contact_us.when_present.click
    assert @browser.url==footer_url

    @browser.goto @home_page.url
    @browser.refresh
    @layout_page.footer_home.when_present.click
    assert @browser.url == @home_page.url

    @browser.goto @home_page.url
    @browser.refresh
    @layout_page.footer_topics.when_present.click
    assert @browser.wait_until{ @browser.url == @topic_page.url }

    @browser.goto @home_page.url
    @browser.refresh
    @layout_page.footer_about.when_present.click
    assert @browser.wait_until{ @browser.url == @about_page.url }

    @browser.goto @home_page.url
    @browser.refresh
    @browser.wait_until { !@layout_page.select_lan.value.nil? }
    
    @layout_page.select_lan.when_present.select_value("zh-CN")
    assert @browser.element(:class => "customization-home-heading").when_present.text=="主题"

    @layout_page.select_lan.when_present.select_value("en")

    # Step 8: deactivate the template
    @admin_uicustom_page.navigate_in
    @admin_uicustom_page.cloned_templatelist.templates[1].activate

  end

  def test_00300_interact_section_in_design_page
    # Step 1: Clean existing templates if existing
    @admin_uicustom_page.delete_all_inactivated_templates

    # Step 2: Customize the default simple template
    @admin_uicustom_page.customize_default_template(@simple_t_name)

    # Step 3: add a section
    @uidesign_page.btn_new_section.when_present.click
    @uidesign_page.new_column.when_present.click
    @browser.wait_until { !@uidesign_page.new_column.present? }

    # Step 4: add a widget
    @uidesign_page.new_widget_button.when_present.click
    @browser.wait_until { @uidesign_page.new_widget_about_img.present? }

    @uidesign_page.new_widget_about_banner.when_present.click

    # Step 5: save the template
    @uidesign_page.exit

    # Step 6: activate the template
    @admin_uicustom_page.cloned_templatelist.templates[1].activate
    sleep(2)
    @browser.wait_until { @browser.goto @about_page.url }

    @browser.wait_until { @uidesign_page.new_widget.present? }
    
    assert @uidesign_page.new_widget_number == 2
  end

  def test_00400_interact_widget_in_design_page
    # Step 1: Clean existing templates if existing
    @admin_uicustom_page.delete_all_inactivated_templates

    # Step 2: Customize the default simple template
    @admin_uicustom_page.customize_default_template(@simple_t_name)

    # Step 3: choose a section
    @uidesign_page.home_link.when_present.click

    # Step 4: delete a widget
    # text_editor = @uidesign_page.propeditor_panel.editor(name: "Styling", subname: "Navigator Text", type: :text)
    @browser.wait_until { @uidesign_page.search_box_widget.present? }
    
    @uidesign_page.search_box_widget.when_present.hover
    
    @uidesign_page.delete_span.click

    @uidesign_page.delete_ok_button.when_present.click
    @browser.wait_until { !@browser.div(:css => "#remove-gadget-modal").present? }
    @browser.wait_until { !@browser.div(:css => ".modal-backdrop").present? }

    # Step 5: add a widget

    @uidesign_page.new_widget_button.when_present.click
    @browser.wait_until { @uidesign_page.new_widget_home_banner.present? }
    @uidesign_page.new_widget_home_banner.when_present.click

    sleep(2)
    # Step 6: preview the page
    @uidesign_page.uidesign_asidebar_preview_btn.click
    @browser.windows.last.use
    
    # Step 7: activate the page
    @admin_uicustom_page.us_custom_prview_activate.when_present.click

    @browser.wait_until { @browser.link(:css => ".new-topic-button a").present? }
    @browser.goto @home_page.url

    @browser.wait_until { @uidesign_page.new_widget.present? }

    assert @uidesign_page.new_widget_number == 2
  end

  def test_00500_order_widget_in_design_page
    # Step 1: Clean existing templates if existing
    @admin_uicustom_page.delete_all_inactivated_templates

    # Step 2: Customize the default simple template
    @admin_uicustom_page.customize_default_template(@simple_t_name)

    # Step 3: choose a section
    @uidesign_page.home_link.when_present.click

    # Step 4: move down a widget
    @browser.wait_until { @uidesign_page.search_box_widget.present? }
    
    @uidesign_page.search_box_widget.when_present.hover
    @uidesign_page.down_first.click

    # Step 5: move up a widget
    @browser.wait_until { @uidesign_page.questions_widget.present? }
  
    @uidesign_page.questions_widget.when_present.hover
    @uidesign_page.top_last.click

    # Step 5: move down a middle widget
    if @uidesign_page.upcoming_events_widget.present?
      @browser.wait_until { @uidesign_page.upcoming_events_widget.present? }
  
      @uidesign_page.upcoming_events_widget.when_present.hover
      sleep(2)
      @uidesign_page.down_middle.when_present.click
    end

    # Step 6: preview the page
    @uidesign_page.uidesign_asidebar_preview_btn.click
    @browser.windows.last.use
    
    @browser.wait_until { @browser.element(:css => ".customization-home-heading").present? }
    topic_index = @uidesign_page.get_widget_index_by_name("topics")
    questions_index = @uidesign_page.get_widget_index_by_name("questions")

    if @browser.element(:text => "reviews").present?
      reviews_index = @uidesign_page.get_widget_index_by_name("reviews")
      if @browser.element(:text => "Upcoming Events").present?
        @browser.wait_until { @browser.element(:text => "Upcoming Events").present? }
        events_index = @uidesign_page.get_widget_index_by_name("upcoming events")
        
        assert topic_index < questions_index
        assert questions_index < events_index
        assert events_index < reviews_index
      else
        assert topic_index < questions_index
        assert questions_index < reviews_index
      end
    else
      assert topic_index < questions_index
    end
  end

  def test_00500_upload_home_banner_image
    # Step 1: Clean existing templates if existing
    customize_and_activate_template(
      pages: [{page: :home, gadgets: [{type: :banner, editors: [{name: "Styling", subname: "Image", type: :image}]}]}]) 
    sleep(2)
    @browser.wait_until { @browser.goto @home_page.url }
    @browser.refresh # sometimes the setting won't take effect unless refresh
    banner_gadget = Gadgets::Community::Banner.new(@config)

    @browser.wait_until { banner_gadget.bg_image =~ /#{@test_image_filename}/ }
    assert_all_keys({
      :bgcolor => banner_gadget.bg_color == @red_rgb,
      :bg_image => banner_gadget.bg_image =~ /#{@test_image_filename}/
      })
    
  end

  def test_00600_customize_footer_style
    # Step 1: Clean existing templates if existing
    @admin_uicustom_page.delete_all_inactivated_templates

    # Step 2: Customize the default simple template
    @admin_uicustom_page.customize_default_template(@simple_t_name)

    # Step 3: Click the footer_navigation
    @uidesign_page.navigation_panel.footer_navigation.when_present.click

    widget_labels = @uidesign_page.propeditor_panel.editor(name: "Widget Labels", subname: "Widget Labels", type: :widget)
    @browser.wait_until { widget_labels.present? }

    footer_url = "https://www.sap.com/index.html"

    widget_labels.expand
    widget_labels.terms_of_use_url.when_present.set footer_url
    widget_labels.privacy_policy_url.when_present.set footer_url
    widget_labels.imprint_url.when_present.set footer_url
    widget_labels.contact_us_url.when_present.set footer_url

    @uidesign_page.propeditor_panel.save(false)
    @uidesign_page.exit

    # Step 6: activate the template
    @admin_uicustom_page.cloned_templatelist.templates[1].activate

    sleep(2)
    # Step 7: verify the footer url take effect in Home page
    @browser.goto @home_page.url
    @browser.refresh
    @layout_page.terms_of_use.when_present.click

    assert @browser.url==footer_url

    @browser.goto @home_page.url
    @browser.refresh
    @layout_page.privacy_policy.when_present.click
    assert @browser.url==footer_url

    @browser.goto @home_page.url
    @browser.refresh
    @layout_page.imprint.when_present.click
    assert @browser.url==footer_url

    @browser.goto @home_page.url
    @browser.refresh
    @layout_page.contact_us.when_present.click
    assert @browser.url==footer_url
  end

# Test Case #4
# Step 1: Add the simple template if no existing
# Step 2: Customize the template.
# Step 3: Customize Conversation detail page
# Step 4: Go to Community check.

  # =============== common methods not test cases =================
  def verify_after_preview_template
    @browser.wait_until{ @browser.windows.size > 1 }

    @browser.windows.last.use
    @browser.wait_until { @browser.url =~ /template_id/ }
    template_id = @browser.url.match(/template_id=(.*)/)[1]
    @browser.wait_until { @browser.link(:href => /#{template_id}/).present? }
    assert @browser.link(:href => /#{template_id}/).present?

    if block_given?
      yield # for more verification purpose
    end

    @browser.windows.last.close
  end 
  
  # param format as below:
  # pages: [{page: nil, section: nil, gadgets: [{type:, action: :add, from_widget: "Upcoming Events", editors: [{name:, type:}]}]}]
  def customize_and_activate_template(pages:)
    # Step 1: Clean existing templates if existing
    @admin_uicustom_page.delete_all_inactivated_templates

    default_tp_name = @admin_uicustom_page.cloned_templatelist.templates[0].name
    # Step 2: Create a new template
    @admin_uicustom_page.create_new_tp

    # Step 3: Select each page and customize the specified gadgets
    pages.each do |page|
      @uidesign_page.navigation_panel.select_page_section(page: page[:page], section: page[:section]) unless page[:page] == :default
      
      page[:gadgets].each do |gadget|
        expected_gadget = @uidesign_page.design_content_panel.gadget(gadget[:type], gadget[:type_options])

        unless gadget[:from_widget].nil?
          raise "Gadget #{gadget[:type]} already exists" if expected_gadget.present?

          @uidesign_page.design_content_panel.add_widget(gadget[:type], gadget[:from_widget])
          @browser.wait_until { expected_gadget.present? }
        end

        expected_gadget.select unless @uidesign_page.design_content_panel.gadget_active?(gadget[:type], gadget[:type_options])

        if gadget[:action] == :delete
          @uidesign_page.design_content_panel.delete_widget(gadget[:type]) 
          next
        end  

        next if gadget[:editors].nil?

        global_editor_included = false
        gadget[:editors].each do |editor|
          expected_editor = @uidesign_page.propeditor_panel.editor(editor)
          @browser.wait_until { expected_editor.present? }
          expected_editor.set_gadget(expected_gadget)
          expected_editor.expand unless expected_editor.expanded?
          expected_editor.select_subname(editor[:subname]) unless editor[:subname].nil?

          settings = !editor[:settings].nil? ? editor[:settings] : case editor[:type]
                 when :text
                    [{type: :font, value: @font_family_to_test},
                    {type: :bold, value: :on},
                    {type: :italic, value: :on},
                    {type: :underline, value: :on},
                    {type: :size, value: 16},
                    {type: :color, value: "#ff0000"},
                    {type: :charstyle, value: "Uppercase"},
                    {type: :height, value: 30}]
                 when :image
                    [{type: :bgcolor, value: "#ff0000"},
                    {type: :upload, value: @test_image_file}]
                 when :carousel_layout
                    [{type: :page, value: "6"}] 
                 when :topnav_layout
                    [{type: :home_label, value: "主页"},
                    {type: :events_toggle, value: :off},
                    {type: :ideas_toggle, value: :off}]   
                 end

          expected_editor.change_settings(settings)
          global_editor_included = true if expected_editor.global? and !global_editor_included
        end 
        @uidesign_page.propeditor_panel.save(global_editor_included)
      end   
    end  

    @uidesign_page.exit

    # Step 4: activate the template
    @admin_uicustom_page.cloned_templatelist.templates[1].activate

    sleep(2) # system will auto-refresh web page after change template to activate
    @browser.wait_until { !@admin_uicustom_page.cloned_templatelist.templates[1].nil? && @admin_uicustom_page.cloned_templatelist.templates[1].name == default_tp_name }
  end 
end  