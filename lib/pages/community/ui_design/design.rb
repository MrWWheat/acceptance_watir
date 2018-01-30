require 'pages/community'
require 'pages/community/ui_design/editors/base'
require 'pages/community/ui_design/editors/text'
require 'pages/community/ui_design/editors/image'
require 'pages/community/ui_design/editors/topnav_layout'
require 'pages/community/ui_design/editors/carousel_layout'
require 'pages/community/ui_design/editors/navigation_bar'
require 'pages/community/ui_design/editors/widget'
require 'pages/community/ui_design/editors/widget_labels'
require 'pages/community/gadgets/top_navigator'
require 'pages/community/gadgets/home_banner'
require 'pages/community/gadgets/footer'
require 'pages/community/gadgets/banner'
require 'pages/community/gadgets/topics_carousel'
require 'pages/community/gadgets/upcoming_events'
require 'pages/community/gadgets/home_conversations'
require 'pages/community/gadgets/text_element'
require 'pages/community/admin_ui_customization'

class Pages::Community::UICustomizationDesign < Pages::Community

  def initialize(config, options = {})
    super(config)
    @url = config.base_url + "/n/#{config.slug}"
  end
  
  uidesign_asidebar                   { element(:css => ".aside-bar") }
  uidesign_asidebar_exit_btn          { link(:css => ".aside-bar .bottom-menu .btn-exit") }
  uidesign_asidebar_preview_btn       { link(:css => ".aside-bar .bottom-menu .btn-preview") }
  uidesign_style_section              { element(:css => ".aside-bar .aside-section:nth-of-type(1)") }
  uidesign_style_section_header       { element(:css => ".aside-bar .aside-section:nth-of-type(1) header") }
  uidesign_logo_section               { element(:css => ".aside-bar .aside-section:nth-of-type(2)") }
  uidesign_logo_section_header        { element(:css => ".aside-bar .aside-section:nth-of-type(2) header") }
  uidesign_logo_editor                { div(:css => ".aside-bar .aside_allow_logo") }
  uidesign_asidebar_top_nav_link      { ul(:css => ".global-section-nav").link(:text => /Primary Navigation/) }
  uidesign_asidebar_footer_link       { ul(:css => ".global-section-nav").link(:text => /Footer/) }

  uidesign_content                    { element(:css => ".design-content") }
  uidesign_prop_editor                { element(:css => ".aside-bar.aside-prop") }

  btn_new_section                     { link(:css => ".btn-new-section") }
  new_column                          { element(:css => ".thumb img") }
  new_widget_about_banner             { div(:class => "thumb gadget")}
  new_widget_about_img                { element(:css => ".thumb.gadget img")}
  new_widget_home_banner              { div(:class => "thumb gadget", :index => 1)}
  new_widget                          { div(:css => ".gadget-home-banner")}
  home_link                           { link(:text => "Home") }
  delete_span                         { element(:css => ".button-confirm", :index => 1) }
  save_button                         { link(:css => ".aside-bar-container .btn-save") }
  delete_ok_button                    { button(:css => "#remove-gadget-modal .modal-footer .btn-primary")}

  search_box_widget                   { div(:css => ".gadget-search-box")}
  questions_widget                    { div(:css => ".gadget-featured-questions")}
  upcoming_events_widget              { div(:css => ".gadget-upcoming-events")}

  down_first                          { element(:css => ".button .icon-arrow-bottom") }
  down_middle                         { element(:css => ".button .icon-arrow-bottom", :index => 1) }

  ui_custom_banner_link               {link(:css => ".collapsible.active .section-nav-item .head a")}
  upload_img                          { element(:css => ".aside-section .prop-list .gadget-image-cropper") }

  def top_last
    pi_count = @browser.elements(:css => ".button .icon-arrow-top").size
    index = pi_count - 1
    @browser.element(:css => ".button .icon-arrow-top", :index => index)
  end

  def get_widget_index_by_name(name)
    
    pi_count = @browser.elements(:css => ".customization-home-heading").size - 1

    result = nil

    (0..pi_count).each do |i|
      
      if @browser.element(:css => ".customization-home-heading", :index => i).text.downcase == name
        result = i
        break
      end  
    end

    raise "Cannot find widget topic" if result.nil?

    result
  end

  def new_widget_number
    pi_count = @browser.divs(:css => ".gadget-home-banner").size
  end

  def new_widget_button
    pi_count = @browser.buttons(:css => ".btn-new-gadget").size
    index = pi_count - 1
    @browser.button(:css => ".btn-new-gadget", :index => index)
  end
  
  def navigation_panel
    NavigationPanel.new(@browser)
  end

  def sec_select_panel
    SectionTemplateSelectPanel.new(@browser)
  end

  def design_content_panel
    DesignContentPanel.new(@config)
  end 

  def propeditor_panel
    PropEditorPanel.new(@browser)
  end

  def widget_select_panel
    WidgetSelectPanel.new(@browser)
  end

  def logo_title_editor_panel
    LogoTitleEditorPanel.new(@browser)
  end  

  def exit
    navigation_panel.exit_btn.click

    admin_uicustom_page = Pages::Community::AdminUICustomization.new(@config)
    @browser.wait_until { admin_uicustom_page.present? }
  end

  def save_then_exit
    propeditor_panel.save
    exit
  end  

  class NavigationPanel
    def initialize(browser)
      @browser = browser
      @parent_css = ".aside-bar"
    end

    def present?
      @browser.element(:css => @parent_css).present?
    end  

    def navpage_list
      NavigationPageList.new(@browser)
    end  

    def top_navigation
      @browser.link(:text => "Primary Navigation")
    end

    def footer_navigation
      @browser.link(:text => "Footer")
    end

    def exit_btn
      @browser.link(:css => @parent_css + " .bottom-menu .btn-exit")
    end

    def preview_btn
      @browser.link(:css => @parent_css + " .bottom-menu .btn-preview")
    end

    def nav_groups
      s_count = @browser.elements(:css => @parent_css + " .aside-section").size

      result = []

      (1..s_count).each do |i|
        result << NavigationGroup.new(@browser, @parent_css + " .aside-section:nth-of-type(#{i})")
      end  

      result
    end

    def nav_groups_at_name(name)
      nav_groups.find { |s| s.name.downcase == name.downcase }
    end

    def page_name(type)
      case type
      when :home
        "Home"
      when :about
        "About"
      end  
    end  

    def page(type)
      navpage_list.page_at_name(page_name(type))
    end  

    def select_group(group="Style Editor")
      @browser.wait_until { !nav_groups_at_name(group).nil? }
      nav_groups_at_name(group).expand unless nav_groups_at_name(group).expanded?
    end  

    def select_page_section(group: "Style Editor", page:, section: nil)
      select_group(group)
      p_name = page_name(page)
      @browser.wait_until { !navpage_list.page_at_name(p_name).nil? }

      navpage_list.page_at_name(p_name).expand unless navpage_list.page_at_name(p_name).expanded?

      return if section.nil?

      navpage = navpage_list.page_at_name(p_name)

      @browser.wait_until { !navpage.section_at_name(section).nil? }

      navpage.section_at_name(section).select
    end  

    class NavigationGroup
      def initialize(browser, parent_css)
        @browser = browser
        @parent_css = parent_css
      end

      def parent
        @browser.element(:css => @parent_css)
      end  

      def name
        @browser.element(:css => @parent_css + " .collapsible-title").when_present.text
      end

      def expanded?
        parent.class_name.include?("expand")
      end

      def expand
        parent.click unless expanded?
      end

      def collapse
        parent.click if expanded?
      end  
    end

    class NavigationPageList
      def initialize(browser)
        @browser = browser
        @parent_css = "[class=aside-nav]"
      end 

      def pages
        pages_count = @browser.lis(:css => @parent_css + " li[id^=page]").size

        result = []

        (1..pages_count).each do |i|
          result << NavigationPage.new(@browser, @parent_css + " li[id^=page]:nth-of-type(#{i})")
        end

        result
      end

      def page_at_name(name)
        pages.find { |p| p.name.downcase == name.downcase }
      end 

      class NavigationPage
        def initialize(browser, parent_css)
          @browser = browser
          @parent_css = parent_css
        end

        def head
          @browser.link(:css => @parent_css + " .collapsible-title")
        end  

        def expanded?
          @browser.li(:css => @parent_css).when_present.class_name.include?("expand")
        end  

        def name
          head.when_present.text
        end  

        def new_section_btn
          @browser.link(:css => @parent_css + " .btn-new-section")
        end

        def select
          head.when_present.click
        end  

        def expand
          head.when_present.click unless expanded? 
        end

        def collapse
          head.when_present.click if expanded?
        end 

        def sections
          sections_count = @browser.lis(:css => @parent_css + " .section-nav-item").size

          result = []

          (1..sections_count).each do |i|
            result << PageSection.new(@browser, @parent_css + " .section-nav-item:nth-of-type(#{i})")
          end

          result
        end 

        def section_at_name(name)
          sections.find { |s| s.name.downcase == name.downcase }
        end

        def add_section(template_name)
          oldsections_count = sections.size
          new_section_btn.when_present.click
          sec_select_panel = SectionTemplateSelectPanel.new(@browser)
          @browser.wait_until { sec_select_panel.present? }

          sec_select_panel.select_template(template_name)

          @browser.wait_until { sections.size == oldsections_count + 1 }
          @browser.send_keys :enter
          @browser.wait_until { !section_at_name(template_name).nil? }
          section_at_name(template_name)
        end  

        class PageSection
          def initialize(browser, parent_css)
            @browser = browser
            @parent_css = parent_css
          end

          def section
            @browser.element(:css => @parent_css)
          end 

          def id
            section.id
          end 

          def name
            @browser.link(:css => @parent_css + " a").when_present.text
          end

          def name_input
            @browser.text_field(:css => @parent_css + " input")
          end  

          def select
            section.when_present.click
          end 

          def edit_icon
            @browser.element(:css => @parent_css + " .icon-edit")
          end 

          def delete_icon
            @browser.element(:css => @parent_css + " .icon-delete")
          end

          def rename(new_name) 
            section.when_present.hover
            edit_icon.when_present.click
            name_input.when_present.set(new_name)
            @browser.send_keys :enter 
            @browser.wait_until { name == new_name }
          end

          def delete
            section.when_present.hover
            delete_icon.when_present.click

            @browser.button(:css => "#remove-section-modal .btn-primary").when_present.click
            @browser.wait_until { !@browser.div(:css => ".modal-backdrop").exists? }
          end  
        end  
      end 
    end   
  end

  class SectionTemplateSelectPanel
    def initialize(browser)
      @browser = browser
      @parent_css = ".aside-allow-section"
    end

    def present?
      @browser.div(:css => @parent_css).present?
    end  

    def templates
      section_count = @browser.lis(:css => @parent_css + " .section-list li").size

      result = []
      (1..section_count).each do |i|
        result << SectionTemplate.new(@browser, @parent_css + " .section-list li:nth-of-type(#{i})")
      end

      result 
    end 

    def template_at_name(name)
      templates.find { |t| t.name.downcase == name.downcase }
    end  

    def select_template(name)
      @browser.wait_until { !template_at_name(name).nil? }

      template_at_name(name).select
    end

    class SectionTemplate
      def initialize(browser, parent_css)
        @browser = browser
        @parent_css = parent_css
      end

      def name
        @browser.element(:css => @parent_css + " h5").when_present.text
      end
      
      def select
        @browser.div(:css => @parent_css + " .thumb").when_present.click
      end 
    end  
  end

  class DesignContentPanel
    attr_reader :sections

    def initialize(config)
      @config = config
      @browser = @config.browser
      @parent_css = ".page-template.design-mode"
    end

    def present?
      @browser.div(:css => @parent_css).present? 
    end  

    def sections
      sec_count = @browser.lis(:css => @parent_css + " .s-section").size

      result = []

      (1..sec_count).each do |i|
        result << DesignContentSection.new(@browser, @parent_css + " .s-section:nth-of-type(#{i})")
      end

      result  
    end

    def section_at_id(id)
      DesignContentSection.new(@browser, @parent_css + " ##{id}")
    end  

    def active_section
      sections.find { |s| @browser.element(:css => s.parent_css + " .s-gadget.active").present? }
    end 

    def gadget(type, options = {})
      case type
      when :topnav
        Gadgets::Community::TopNavigator.new(@config)
      when :footer
        Gadgets::Community::Footer.new(@config)
      when :banner 
        Gadgets::Community::Banner.new(@config)
      when :home_topics_carousel
        Gadgets::Community::TopicsCarousel.new(@config)  
      when :home_banner
        Gadgets::Community::HomeBanner.new(@config)
      when :upcoming_events
        Gadgets::Community::UpcomingEvents.new(@config) 
      when :home_featuredq
        Gadgets::Community::FeaturedQ.new(@config)
      when :home_openq
        Gadgets::Community::OpenQ.new(@config)
      when :text_element
        Gadgets::Community::TextElement.new(@config, options)  
      else 
        raise "Gadget #{type} not supported yet"
      end  
    end 

    def gadget_container(type, options = {})
      container = nil
      @browser.lis(:css => @parent_css + " .s-gadget").each do |item|
        if item.element(:css => gadget(type).gadget_css).present?
          container = item
          break
        end  
      end 

      raise "Cannot find container for the gadget type #{type}" if container.nil?
      container
    end  

    def gadget_active?(type, options = {})
      gadget_container(type).class_name.include?("active")
    end

    def add_widget(type, name)
      @browser.wait_until { !active_section.nil? }

      add_widget_to_section(active_section, type, name)
    end 

    def add_widget_to_section(section, type, name)
      @browser.execute_script('arguments[0].scrollIntoView()', section.new_widget_btn)
      section.new_widget_btn.when_present.click

      gadget_select_panel = WidgetSelectPanel.new(@browser)
      @browser.wait_until { gadget_select_panel.present? }
      @browser.wait_until { !gadget_select_panel.widgets_at_name(name).nil? }
      gadget_select_panel.widgets_at_name(name).select

      @browser.wait_until { gadget(type).present? }
    end  

    def delete_widget(type)
      container = gadget_container(type)
      container.div(:css => ".gadget-container").when_present.hover
      container.element(:css => ".gadget-container .buttons .icon-decline").when_present.click

      @browser.wait_until { @browser.div(:id => "remove-gadget-modal").present? }
      @browser.button(:css => "#remove-gadget-modal .btn-primary").when_present.click
      @browser.wait_until { !@browser.div(:css => "#remove-gadget-modal.fade").present? }
      @browser.wait_until { !gadget(type).present? }
      @browser.wait_until { !@browser.div(:css => ".modal-backdrop").exists? }
    end 

    class DesignContentSection
      attr_reader :gadgets, :parent_css

      def initialize(browser, parent_css)
        @browser = browser
        @parent_css = parent_css
      end

      def new_widget_btn
        @browser.button(:css => @parent_css + " .s-gadget-create button")
      end 
    end   
  end

  class PropEditorPanel
    attr_reader :editors

    def initialize(browser)
      @browser = browser
      @parent_css = ".aside-bar.aside-prop .aside-prop-container"
    end

    def save_btn
      @browser.link(:css => @parent_css + " .bottom-menu .btn-save")
    end 

    def save_spinner
      @browser.link(:css => @parent_css + " .bottom-menu .fa-spinner")
    end  

    # e.g. format for info:
    # {name: "Styling", subname: "Navigator Text", type: :text} 
    def editor(info)
      case info[:type]
      when :text
        PropEditors::Community::Text.new(@browser, propeditor_css_by_name(info[:name]))
      when :navigation_bar
        PropEditors::Community::NavigatorBar.new(@browser, propeditor_css_by_name(info[:name]))
      when :footer_bar
        PropEditors::Community::NavigatorBar.new(@browser, propeditor_css_by_name(info[:name]))
      when :widget
        PropEditors::Community::Widget.new(@browser, propeditor_css_by_name(info[:name]))
      when :topnav_layout
        PropEditors::Community::TopNavLayout.new(@browser, propeditor_css_by_name(info[:name]))
      when :image
        PropEditors::Community::Image.new(@browser, propeditor_css_by_name(info[:name])) 
      when :carousel_layout
        PropEditors::Community::CarouselLayout.new(@browser, propeditor_css_by_name(info[:name]))
      when :widget_labels
        PropEditors::Community::WidgetLabels.new(@browser, propeditor_css_by_name(info[:name]))  
      else
        raise "PropEditor type #{info[:type]} not supported yet"
      end  
    end 

    def save(global_or_not=true)
      save_btn.when_present.click 

      if global_or_not
        @browser.button(:css => "#apply-modal .modal-footer .btn-primary").when_present.click
    
        @browser.wait_until { !@browser.div(:css => "#apply-modal").present? }
        @browser.wait_until { !@browser.div(:css => ".modal-backdrop").present? }
      else
        @browser.wait_until { !save_spinner.present? }
        @browser.wait_until { @browser.div(:css => ".single-toast.alert").present? }
      end
    end

    def propeditor_css_by_name(name)
      pe_count = @browser.elements(:css => @parent_css + " .aside-section").size

      result = nil
      (1..pe_count).each do |i|
        pe_css = @parent_css + " .aside-section:nth-of-type(#{i})"

        if @browser.element(:css => pe_css + " .collapsible-title").text.downcase == name.downcase
          result = pe_css
          break
        end 
      end

      result
    end 
  end

  class WidgetSelectPanel
    def initialize(browser)
      @browser = browser
      @parent_css = ".aside-bar.aside-prop .aside-allow-gadget"
    end

    def present?
      @browser.div(:css => @parent_css).present?
    end 

    def widgets
      g_count = @browser.lis(:css => @parent_css + " li").size

      result = []

      (1..g_count).each do |i|
        result << Widget.new(@browser, @parent_css + " li:nth-of-type(#{i})")
      end

      result
    end

    def widgets_at_name(name)
      widgets.find { |g| g.name.downcase == name.downcase }
    end 

    class Widget
      def initialize(browser, parent_css)
        @browser = browser
        @parent_css = parent_css
      end 

      def name
        @browser.element(:css => @parent_css + " h5").when_present.text
      end

      def select
        @browser.div(:css => @parent_css + " .thumb").when_present.click
      end  
    end  
  end

  class LogoTitleEditorPanel
    def initialize(browser)
      @browser = browser
      @parent_css = ".aside-allow-logo"
    end 

    def present?
      @browser.div(:css => @parent_css).present?
    end  

    def title_input
      @browser.text_field(:css => @parent_css + " .prop-item input")
    end 

    def logo_input
      @browser.text_field(:css => @parent_css + " .photo-browse-input")
    end

    def save_btn
      @browser.link(:css => @parent_css + " .btn-save")
    end  

    def set_title(title)
      title_input.when_present.set(title)
    end
    
    def set_logo(file)
      logo_input.when_present.set(file)
    end 

    def change_settings(settings) 
      settings.each do |s|
        case s[:type]
        when :title
          set_title(s[:value])
        when :logo
          set_logo(s[:value])
        else
          raise "Type #{s[:type]} not supported yet"
        end 
      end 

      save_btn.when_present.click
      @browser.wait_until { !present? }
    end  
  end  
end