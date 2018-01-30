require 'pages/newsa/newsa'
require 'pages/newsa/community_create'
require 'pages/newsa/details_view'
require 'pages/newsa/details_edit'
require 'pages/newsa/clone'

class Pages::NewSuperAdmin::Communities < Pages::NewSuperAdmin
  def initialize(config, options = {})
    super(config)
    @url = config.base_url
  end

  def start!(user)
    super(user, @url, newsa_comm_table_title)
  end

  newsa_comm_create_btn           { link(:css => ".header-section .btn-primary[href='#/communities/create/']") }
  newsa_comm_table_title          { element(:class => "list-table-title", :text => "Communities") }
  newsa_comm_total_count_label    { p(:text => /Total Count/) }

  newsa_comm_search_field         { text_field(:css => ".table-title-section input[placeholder^='Search by']") }
  newsa_comm_list_tab_link        { ul(:css => ".nav-tabs").link(:text => "Communities") }
  newsa_template_list_tab_link    { ul(:css => ".nav-tabs").link(:text => "Templates") }

  newsa_comm_load_more_btn        { button(:css => ".load-more button") }

  newsa_comm_delete_modal         { div(:id => "del_com") }
  newsa_comm_delete_modal_input   { text_field(:css => "#del_com input") }
  newsa_comm_delete_modal_confirm_btn { button(:css => "#del_com .btn-primary") }

  def prod_community_list
    community_list(:prod)
  end 

  def total_count
    newsa_comm_total_count_label.when_present.text.gsub(/Total Count: /, "").to_i
  end  

  def community_list(site_type=:demo)
    (site_type == :demo) ? CommunityList.new(@browser) : CommunityList.new(@browser, true)
  end

  def load_more
    return unless newsa_comm_load_more_btn.present?

    newsa_comm_load_more_btn.when_present.click
    @browser.wait_until { !newsa_table_spinner.present? }
  end  

  def switch_to_tab(tab)
    @browser.wait_until { !newsa_table_spinner.present? } 
  	case tab
    when :communities
      unless newsa_comm_list_tab_link.when_present.class_name.include?("active")
        # newsa_comm_search_field.set "" unless newsa_comm_search_field.when_present.value == "" # to workaround for EN-4323
        newsa_comm_list_tab_link.click
      end
    when :templates
      unless newsa_template_list_tab_link.when_present.class_name.include?("active")
        # newsa_comm_search_field.set "" unless newsa_comm_search_field.when_present.value == "" # to workaround for EN-4323
        newsa_template_list_tab_link.click 
      end  
    else
      raise "tab #{tab} is not supported yet"
    end

    sleep 1
    @browser.wait_until { !newsa_table_spinner.present? }
  end	

  def search(keyword)
    newsa_comm_search_field.when_present.set keyword
    @browser.send_keys :enter
    sleep 1
    @browser.wait_until { !newsa_table_spinner.present? }
  end 

  def find_community(site_type, name, domain=nil, throw_exception_when_fail=false, is_template = false)
    if site_type == :demo
      is_template ? switch_to_tab(:templates) : switch_to_tab(:communities)
    end  
    
    comm = domain.nil? ? community_list(site_type).find_comm_by_name(name) : community_list(site_type).find_comm_by_domain(domain)

    if comm.nil?
      search(name)

      comm = domain.nil? ? community_list(site_type).find_comm_by_name(name) : community_list(site_type).find_comm_by_domain(domain)
      raise "Cannot find the community with name #{name} and doamin #{domain}" if comm.nil? && throw_exception_when_fail
    end

    comm
  end 

  def create_community(site_type, field_infos, admin_email=nil, schedule=nil)
    newsa_comm_create_btn.when_present.click
    comm_create_page = Pages::NewSuperAdmin::CommunityCreate.new(@config)
    comm_create_page.create(site_type, field_infos, admin_email, schedule)
    details_view_page = Pages::NewSuperAdmin::DetailsView.new(@config)
    @browser.wait_until { details_view_page.newsa_details_header.present? }
    details_view_page
  end 

  def delete_community(site_type, name, domain=nil, is_template = false)
    comm = find_community(site_type, name, domain, true, is_template)

    comm.delete
    newsa_comm_delete_modal_input.when_present.set "delete"
    newsa_comm_delete_modal_confirm_btn.when_present.click
    @browser.wait_until { newsa_toast_success.present? }
    start_time = Time.now
    while (Time.now - start_time < 80) && !find_community(site_type, name, domain, false, is_template).nil?
      sleep 10
      @browser.refresh
      @browser.wait_until { newsa_comm_table_title.present? }
    end  
  end 

  def view_community(site_type, name, domain=nil)
    comm = find_community(site_type, name, domain, true)

    case site_type
    when :demo
      comm.view
    when :prod
      comm.view_prod_copy
    when :preview
      comm.view_preview_copy 
    else
      raise "site type #{site_type} not supported yet"
    end

    details_view_page = Pages::NewSuperAdmin::DetailsView.new(@config)
    @browser.wait_until { details_view_page.newsa_details_header.present? }
    details_view_page
  end  

  def edit_community(site_type, name, domain=nil)
    comm = find_community(site_type, name, domain, true)

    case site_type
    when :demo
      comm.edit
    when :prod
      comm.edit_prod_copy
    when :preview
      comm.edit_preview_copy 
    else
      raise "site type #{site_type} not supported yet"
    end

    details_edit_page = Pages::NewSuperAdmin::DetailsEdit.new(@config)
    @browser.wait_until { details_edit_page.newsa_edit_name_field.present? }
    details_edit_page
  end 

  # Enable/Disable only supported for production site
  def disable_community(name, domain=nil)
    comm = find_community(:prod, name, domain, true)

    comm.disable
    @browser.wait_until { comm.status == "Disabled" }
    comm
  end 

  def enable_community(name, domain=nil)
    comm = find_community(:prod, name, domain, true)

    comm.enable
    @browser.wait_until { comm.status == "Enabled" }
    comm
  end 

  def goto_community(site_type, name, domain=nil) 
    comm = find_community(site_type, name, domain, true)
    domain = nil
    case site_type
    when :demo
      domain = comm.domain_link.when_present.text
      comm.domain_link.click
    when :prod
      comm.toggle_couple(:on)
      domain = comm.production_copy.domain_link.when_present.text
      comm.production_copy.domain_link.when_present.click
    when :preview
      comm.toggle_couple(:on)
      domain = comm.preview_copy.domain_link.when_present.text
      comm.preview_copy.domain_link.when_present.click
    else
      raise "site type #{site_type} not supported yet"
    end 

    domain 
  end 

  def convert_to_template(name, domain=nil)
    comm = find_community(:demo, name, domain, true)
    comm.convert_to_template

    @browser.wait_until { newsa_toast_success.present? }
  end 

  def copy_to_community(template_name, template_domain, comm_name, comm_subdomain)
    template = find_community(:demo, template_name, template_domain, true, true)
    template.copy_to_community

    clone_page = Pages::NewSuperAdmin::Clone.new(@config)
    clone_page.clone({name: comm_name, domain: comm_subdomain})

    start_time = Time.now
    while (Time.now - start_time < 30*60) && find_community(:demo, comm_name).nil?
      sleep 10
      @browser.refresh
      @browser.wait_until { newsa_comm_table_title.present? }
    end
  end

  def convert_to_community(template_name, template_domain) 
    template = find_community(:demo, template_name, template_domain, true, true)
    template.convert_to_community

    @browser.wait_until { newsa_toast_success.present? }
  end  

  class CommunityList
    def initialize(browser, is_prod=false)
      @browser = browser
      @is_prod = is_prod
      @parent_css = ".list-table"
    end

    def communities
      list = []
      @browser.divs(:css => @parent_css + " .table-row").each_with_index do |row, index|
        list << Community.new(@browser, @is_prod, ".list-table > .table-row:nth-child(#{index+2})")
      end
      list
    end

    def first_not_operating_community
      communities.find { |comm| !comm.operation_status.present? }
    end  

    def find_comm_by_domain(domain)
      communities.find { |comm| comm.domain.downcase == domain.downcase }
    end 

    def find_comm_by_name(name)
      communities.find { |comm| comm.name.downcase == name.downcase }
    end  

    class Community
      def initialize(browser, is_prod, parent_css)
        @browser = browser
        @is_prod = is_prod
        @parent_css = parent_css
      end 

      def field_cell_css(field)
        case field
        when :name
          @parent_css + " .top-row > div:nth-child(1)"
        when :customerid
          if @is_prod
            @parent_css + " .top-row > div:nth-child(2)"
          else
            raise "No Customer Id for demo communities"
          end  
        when :domain
          @is_prod ? (@parent_css + " .top-row > div:nth-child(3)") : (@parent_css + " .top-row > div:nth-child(2)")
        when :date_created
          @is_prod ? (@parent_css + " .top-row > div:nth-child(4)") : (@parent_css + " .top-row > div:nth-child(3)")
        when :actions_dropdown
          @is_prod ? (@parent_css + " .top-row > div:nth-child(5)") : (@parent_css + " .top-row > div:nth-child(4)")
        else
          raise "Field #{field} is not supported yet"
        end   
      end  

      def name_link
        @browser.link(:css => field_cell_css(:name) + " a")
      end  

      def name
        name_link.when_present.text
      end

      # only available in production super admin
      def status
        @browser.span(:css => field_cell_css(:name) + " .status").when_present.text
      end 

      def operation_status
        @browser.span(:css => field_cell_css(:name) + " .opration-status")
      end  
      
      def domain_link
        @browser.link(:css => field_cell_css(:domain) + " a")
      end  

      def domain
        domain_link.when_present.text
      end

      def date_created
        @browser.div(:css => field_cell_css(:date_created)).when_present.text
      end

      def actions_btn
        @browser.button(:css => field_cell_css(:actions_dropdown) + " button")
      end 

      def actions_view_details_menu_item
        @browser.div(:css => field_cell_css(:actions_dropdown)).link(:text => "View Details")
      end  

      def actions_edit_details_menu_item
        @browser.div(:css => field_cell_css(:actions_dropdown)).link(:text => "Edit Details")
      end 

      def actions_conv_to_tmpt_menu_item
        @browser.div(:css => field_cell_css(:actions_dropdown)).link(:text => "Convert to Template")
      end

      def actions_delete_menu_item
        @browser.div(:css => field_cell_css(:actions_dropdown)).link(:text => "Delete")
      end

      def actions_copy_to_comm_menu_item
        @browser.div(:css => field_cell_css(:actions_dropdown)).link(:text => "Copy to Community")
      end 

      def actions_conv_to_comm_menu_item
        @browser.div(:css => field_cell_css(:actions_dropdown)).link(:text => "Convert back to Community")
      end 

      def actions_enable_menu_item
        @browser.div(:css => field_cell_css(:actions_dropdown)).link(:text => "Enable")
      end 

      def actions_disable_menu_item
        @browser.div(:css => field_cell_css(:actions_dropdown)).link(:text => "Disable")
      end 

      def view
        actions_btn.when_present.click
        actions_view_details_menu_item.when_present.click
      end  

      def view_prod_copy
        toggle_couple(:on)
        production_copy.view
      end  

      def view_preview_copy
        toggle_couple(:on)
        preview_copy.view
      end  

      def edit
        unless is_couple?
          actions_btn.when_present.click
          actions_edit_details_menu_item.when_present.click
        else
          toggle_couple(:on)
          production_copy.edit
        end  
      end

      def edit_prod_copy
        toggle_couple(:on)
        production_copy.edit
      end
      
      def edit_preview_copy
        toggle_couple(:on)
        preview_copy.edit
      end 

      def disable
        actions_btn.when_present.click
        actions_disable_menu_item.when_present.click
      end 

      def enable 
        actions_btn.when_present.click
        actions_enable_menu_item.when_present.click
      end  

      def delete
        actions_btn.when_present.click
        actions_delete_menu_item.when_present.click
      end 

      def convert_to_template
        actions_btn.when_present.click
        actions_conv_to_tmpt_menu_item.when_present.click
      end 

      def copy_to_community
        actions_btn.when_present.click
        actions_copy_to_comm_menu_item.when_present.click
      end

      def convert_to_community
        actions_btn.when_present.click
        actions_conv_to_comm_menu_item.when_present.click
      end 

      def couple_toggle_icon
        @browser.span(:css => @parent_css + " .top-row .name .toggle-icon")
      end 

      def is_couple?
        couple_toggle_icon.present?
      end

      def couple_body
        @browser.div(:css => @parent_css + " .body-row")
      end  

      def toggle_couple(on_or_off)
        case on_or_off
        when :on
          couple_toggle_icon.when_present.click unless couple_body.class_name.include?("expend")
          @browser.wait_until { couple_body.class_name.include?("expend") }
        when :off
          couple_toggle_icon.when_present.click if couple_body.class_name.include?("expend")
          @browser.wait_until { !couple_body.class_name.include?("expend") }
        end  
      end 

      def production_copy
        CommunityCoupleItem.new(@browser, @parent_css + " .body-row > .sub-item:nth-child(1)")
      end
      
      def preview_copy
        CommunityCoupleItem.new(@browser, @parent_css + " .body-row > .sub-item:nth-child(2)")
      end  

      class CommunityCoupleItem
        def initialize(browser, parent_css)
          @browser = browser
          @parent_css = parent_css
        end 

        def name_link
          @browser.link(:css => @parent_css + " .info-row .name a")
        end 

        def name
          name_link.when_present.text
        end
        
        def type
          @browser.element(:css => @parent_css + " .sub-row .com-type").when_present.text
        end 

        def domain_link
          @browser.link(:css => @parent_css + " .info-row > div:nth-child(2) a")
        end

        def domain
          @browser.link(:css => @parent_css + " .info-row > div:nth-child(2) a").when_present.text
        end
        
        def actions_btn
          @browser.button(:css => @parent_css + " .info-row > div:nth-child(4) button")
        end

        def actions_view_details_menu_item
          @browser.div(:css => @parent_css + " .info-row > div:nth-child(4)").link(:text => "View Details")
        end

        def actions_edit_details_menu_item
          @browser.div(:css => @parent_css + " .info-row > div:nth-child(4)").link(:text => "Edit Details")
        end 

        def edit
          actions_btn.when_present.click
          actions_edit_details_menu_item.when_present.click
        end 

        def view
          actions_btn.when_present.click
          actions_view_details_menu_item.when_present.click
        end 
      end 
    end  
  end
end 
