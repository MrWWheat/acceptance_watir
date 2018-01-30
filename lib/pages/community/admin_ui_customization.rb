require 'pages/community/admin'
require 'pages/community/home'
require 'pages/community/ui_design/design'

class Pages::Community::AdminUICustomization < Pages::Community::Admin

  def initialize(config, options = {})
    super(config)
    @url = config.base_url + "/admin/#{config.slug}/ui_customization"
  end

  def start!(user)
    @home_page = Pages::Community::Home.new(@config)
    @home_page.start!(user)

    navigate_in
  end

  ui_custom_create_new_tp_link        { link(:css => ".admin-page-customization .clone-template a") }
  ui_custom_no_template               { div(:css => ".no-template") }
  ui_custom_customise_button          { link(:css => ".preview-btn .btn-primary")}
  ui_custom_create_tp_modal           { div(:css => ".create-new-template-dialog .modal-dialog") }
  ui_custom_create_tp_name_text_field { text_field(:css => ".create-new-template-dialog input") }
  ui_custom_create_tp_modal_create_btn { button(:css => ".create-new-template-dialog .modal-footer .btn-primary")}

  us_custom_prview_activate           {button(:css => ".customization-preview .btn-primary")}
  us_custom_prview_link               {link(:css => ".nav-list-menu a")}
  us_custom_prview_customize          {link(:css => ".actions a")}

  def default_templatelist
    DefaultTemplateList.new(@browser)
  end

  def cloned_templatelist
    ClonedTemplateList.new(@browser)
  end

  def present?
    ui_custom_create_new_tp_link.present? || default_templatelist.present?
  end 

  def customize_present?
    us_custom_prview_customize.present?
  end 

  def delete_all_inactivated_templates
    cloned_templatelist.delete_all if cloned_templatelist.present?

    #@browser.wait_until { ui_custom_no_template.present? }
  end  

  def clone_template(existing_count=nil)
    existing_count = cloned_templatelist.templates.size if existing_count.nil?

    design_page = create_new_tp

    if block_given?
      yield(design_page) # for verification purpose
    end
    
    design_page.exit
    @browser.wait_until { cloned_templatelist.templates.size - existing_count == 1 }
  end  

  # def clone_template(name, existing_count=nil)
  #   existing_count = cloned_templatelist.templates.size if existing_count.nil?

  #   design_page = customize_default_template(name)

  #   if block_given?
  #     yield(design_page) # for verification purpose
  #   end
    
  #   design_page.exit
  #   @browser.wait_until { cloned_templatelist.templates.size - existing_count == 1 }
  # end 

  def customize_default_template(name)
    # goto_default_templatelist_page

    # default_templatelist.template_at_name(name).customize
    # design_page = Pages::Community::UICustomizationDesign.new(@config)
    # @browser.wait_until { design_page.design_content_panel.present? }
    # design_page

    create_new_tp
  end  

  def customize_cloned_template_at_index(index)
    cloned_templatelist.templates[index].customize

    design_page = Pages::Community::UICustomizationDesign.new(@config)
    @browser.wait_until { design_page.design_content_panel.present? }
    design_page
  end 

  def navigate_in
    super

    switch_to_sidebar_item(:ui_custom)
    @browser.wait_until { present? }
  end

  # def goto_default_templatelist_page
  #   ui_custom_create_new_tp_link.click if ui_custom_create_new_tp_link.present?
  #   @browser.wait_until { default_templatelist.present? }
  # end  
  # def click_create_new_tp_link
  def create_new_tp(tp_name=nil)
    ui_custom_create_new_tp_link.click if ui_custom_create_new_tp_link.present?
    @browser.element(:css => "li.page-template").when_present.hover
    ui_custom_customise_button.when_present.click
    @browser.wait_until { ui_custom_create_tp_modal.present? }
    tp_name = "Watir Test Template - #{get_timestamp}" if tp_name.nil?
    ui_custom_create_tp_name_text_field.when_present.set tp_name
    ui_custom_create_tp_modal_create_btn.when_present.click
    @browser.wait_until { !ui_custom_create_tp_modal.present? }

    design_page = Pages::Community::UICustomizationDesign.new(@config)
    @browser.wait_until { design_page.design_content_panel.present? }
    design_page
  end  

  class DefaultTemplateList
    def initialize(browser)
      @browser = browser
    end

    def present?
      @browser.div(:css => ".default-templates").present?
    end  
    
    def templates
      tp_count = @browser.elements(:css => ".default-templates .page-template").size

      result = []
      (1..tp_count).each do |i|
        result << DefaultTemplate.new(@browser, ".default-templates .page-template:nth-of-type(#{i})")
      end

      result 
    end

    def template_at_name(name)
      templates.find { |t| t.name.downcase == name.downcase }
    end

    class DefaultTemplate
      def initialize(browser, parent_css)
        @browser = browser
        @parent_css = parent_css
      end

      def template_div
        @browser.element(:css => @parent_css)
      end  

      def present?
        template_div.present?
      end  

      def name
        # the following code always return empty string 
        # @browser.h5(:css => @parent_css + " h5").text
        @browser.h5(:css => @parent_css + " h5").attribute_value("innerText")
      end

      def thumb_file
        template_div.img.when_present.attribute_value("src").match(/template\/(.*)\z/)[1]
      end  

      def template_id
        template_div.link(:css => ".btn-default").attribute_value("href").match(/template_id=(.*)/)[1]
      end  
      
      def customize
        template_div.when_present.hover

        template_div.link(:css => ".btn-primary").when_present.click
      end

      def preview
        template_div.when_present.hover

        template_div.link(:css => ".btn-default").when_present.click
      end  
    end 
  end 

  class ClonedTemplateList
    def initialize(browser)
      @browser = browser
    end

    def present?
      @browser.div(:css => ".my-templates").present?
    end  
    
    def templates
      tp_count = @browser.elements(:css => ".my-templates .template-item").size

      result = []
      (1..tp_count).each do |i|
        result << ClonedTemplate.new(@browser, ".my-templates .template-item:nth-of-type(#{i})")
      end

      result 
    end

    def template_at_name(name)
      templates.find { |t| t.name.downcase == name.downcase }
    end

    def delete_all
      while (templates.size > 1)
        old_size = templates.size
        templates[1].delete

        @browser.wait_until { (old_size - templates.size) == 1 }
      end
    end

    def rename_template_at_index(index, new_name)
      templates[index].rename(new_name)
      @browser.wait_until { templates[index].name == new_name }
    end

    def copy_template_at_index(index, new_name=nil)
      existing_count = templates.size
      new_name = "Copy Watir Test Template - #{Time.now.utc.to_s.gsub(/[-: ]/,'')}" if new_name.nil?
      templates[index].copy(new_name)
      @browser.wait_until { templates.size == existing_count + 1 }
    end

    def first_inactive_template
      templates.each do |t|
        return t unless t.activated?
      end  
    end  

    class ClonedTemplate
      def initialize(browser, parent_css)
        @browser = browser
        @parent_css = parent_css
      end 

      def name_field
        @browser.element(:css => @parent_css + " .name span")
      end

      def name_input
        @browser.text_field(:css => @parent_css + " .name input")
      end

      def active_icon
        @browser.span(:css => @parent_css + " .name .active-icon")
      end 

      def customize_btn
        @browser.link(:css => @parent_css + " .actions .icon-edit")
      end
      
      def activate_btn
        @browser.link(:css => @parent_css + " .actions .btn-default")
      end

      def actions_dropdown
        @browser.link(:css => @parent_css + " .template-actions a")
      end 

      def preview_menuitem
        @browser.link(:css => @parent_css + " .dropdown-menu .icon-show")
      end

      def copy_menuitem
        @browser.link(:css => @parent_css + " .dropdown-menu .icon-duplicate")
      end
      
      def delete_menuitem
        @browser.link(:css => @parent_css + " .dropdown-menu .icon-delete")
      end 

      def activate_menuitem
        @browser.link(:css => @parent_css + " .dropdown-menu [data-target='.activate-confirm']")
      end

      def deactivate_menuitem
        @browser.link(:css => @parent_css + " .dropdown-menu [data-target='.deactivate-confirm']")
      end 

      def customize_menuitem
        @browser.link(:css => @parent_css + " .dropdown-menu .icon-edit")
      end  

      def thumb_file
        @browser.div(:css => @parent_css + " .detail").when_present.style.match(/template\/(.*)"\)\;/)[1]
      end
        
      def name
        name_field.when_present.text
      end  

      def rename(new_name)
        name_field.when_present.click
        # comment this following code. No idea why it doesn't work.
        # name_input.when_present.set new_name
        # @browser.send_keys :enter
        @browser.execute_script('$("' + @parent_css + ' .name input").val("' + new_name + '")')
        @browser.div(:css => @parent_css + " .status").when_present.click
      end

      def customize
        if customize_btn.present?
          customize_btn.click
        else
          actions_dropdown.when_present.click
          customize_menuitem.when_present.click
        end  
      end  

      def activated?
        active_icon.present?
      end  

      def activate
        return if activate_btn.present? and activate_btn.text.downcase == "deactivate"

        unless activate_btn.present?
          actions_dropdown.when_present.click
          @browser.wait_until { activate_menuitem.present? || deactivate_menuitem.present? }

          return if deactivate_menuitem.present?

          activate_menuitem.when_present.click
        else  
          activate_btn.when_present.click
        end  

        @browser.div(:css => ".modal.activate-confirm").when_present

        @browser.button(:css => ".modal.activate-confirm .btn-primary").when_present.click

        active_icon.when_present
      end

      # No Deactivate button now. User have to activate other template so as to deactivate the current activated one
      def deactivate
        return unless activate_btn.text.downcase == "deactivate"

        activate_btn.when_present.click

        @browser.div(:css => ".modal.deactivate-confirm").when_present

        @browser.button(:css => ".modal.deactivate-confirm .btn-primary").when_present.click

        @browser.wait_until { !active_icon.present? }
      end 

      def preview
        actions_dropdown.when_present.click
        preview_menuitem.when_present.click
      end  

      def copy(new_name)
        actions_dropdown.when_present.click
        copy_menuitem.when_present.click

        duplicate_modal = DuplicateTemplateModal.new(@browser)
        @browser.wait_until { duplicate_modal.present? }
        duplicate_modal.name_field.when_present.set new_name
        duplicate_modal.duplicate_btn.when_present.click
      end 

      def delete
        actions_dropdown.when_present.click
        delete_menuitem.when_present.click

        @browser.div(:css => ".modal.delete-confirm").when_present
        @browser.button(:css => ".modal.delete-confirm .btn-primary").when_present.click

        @browser.wait_until { !@browser.div(:css => ".modal.delete-confirm").present? }
      end 
    end
  end 

  class DuplicateTemplateModal
    def initialize(browser)
      @browser = browser
      @parent_css = ".duplicate-template-dialog"
    end 

    def name_field
      @browser.text_field(:css => @parent_css + " .modal-body input")
    end 

    def duplicate_btn
      @browser.button(:css => @parent_css + " .btn-primary")
    end  

    def present?
      @browser.div(:css => @parent_css).present?
    end 
  end  
end