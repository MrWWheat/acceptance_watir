require 'pages/community/admin'
require 'pages/community/home'

class Pages::Community::AdminTrustedOrigin < Pages::Community::Admin

  def initialize(config, options = {})
    super(config)
    @url = config.base_url + "/admin/#{@config.slug}/trusted_origins"
  end

  def start!(user)
    # login starting from Home page
    @home_page = Pages::Community::Home.new(@config)
    @home_page.start!(user)

    navigate_in
  end

  new_trusted_origin_btn                     { link(:class => "btn btn-primary", :text => /New Trusted Origin/)}
  name_input                                 { text_field(:id => "name")}
  origin_input								 { text_field(:id => "origin")}
  
  save_btn                             		 { button(:text => /Save/)}

  edit_link									 { link(:text => /Edit/)}
  back_link									 { link(:text => /Back/)}

  delete_confirm_dialog                      { div(:id => "delete-origin-confirm") }
  delete_confirm_btn                         { div(:id => "delete-origin-confirm").button(:text => /Delete/) }

  def navigate_in
    super
    accept_policy_warning
    switch_to_sidebar_item(:trusted_origin)
    wait_until_trusted_origin_page_loaded
  end

  def wait_until_trusted_origin_page_loaded
    @browser.wait_until($t) { new_trusted_origin_btn.present? }
  end

  def trusted_origin_list
	TrustedOriginList.new(@browser)
  end

  def create_trusted_origin(name, url)
    delete_trusted_origin(name) if trusted_origin_list.trusted_origin_exists?(name)
    sleep 1
    new_trusted_origin_btn.when_present.click
    fill_blanks(name,url)
  end

  def edit_trusted_origin(change_name, change_url, origin_name, origin_url)
    trusted_origin_list.edit_trusted_origin(origin_name)
    fill_blanks(change_name, change_url, origin_name, origin_url)
  end 

  def delete_trusted_origin(name)
    trusted_origin_list.delete_trusted_origin(name)
    @browser.wait_until{ delete_confirm_dialog.present? }
    delete_confirm_btn.when_present.click
    @browser.wait_until{ !delete_confirm_dialog.present? }
    @browser.wait_until { !trusted_origin_list.trusted_origin_exists?(name) }
  end

  def fill_blanks(change_name, change_url, origin_name=nil, origin_url=nil)
  	@browser.wait_until { name_input.present? }
  	if origin_name
  		@browser.wait_until{ name_input.value == origin_name }
  		@browser.wait_until{ origin_input.value == origin_url }
  	end
  	name_input.when_present.set(change_name)
    origin_input.when_present.set(change_url)
    save_btn.when_present.click
    @browser.wait_until { toast_success_message.present? }
  end

  class TrustedOriginList
    attr_reader :browser

    def initialize(browser)
      @browser = browser
    end

    def trusted_origin_grid_css
      "#trusted_origin_form .admin-grid"
    end  

    def trusted_origin_at_name_css(name)
      trusted_origin_grid_css + " ##{name}"
    end

    def trusted_origin_at_name(name)
      TrustedOriginItem.new(trusted_origin_at_name_css(name), @browser)
    end  
    
    def view_trusted_origin(name)
      trusted_origin_at_name(name).view
      @browser.wait_until { !trusted_origin_exists?(name) }
    end  

    def delete_trusted_origin(name)
      trusted_origin_at_name(name).delete
    end

    def edit_trusted_origin(name)
      trusted_origin_at_name(name).edit
    end

    def trusted_origin_exists?(name)
      @browser.div(:css => trusted_origin_at_name_css(name)).present?
    end  

    class TrustedOriginItem
      attr_reader :to_item_css, :browser

      def initialize(to_item_css, browser)
        @to_item_css = to_item_css
        @browser = browser
      end

      def actions_dropdown_btn
        @browser.button(:css => @to_item_css + " .dropdown button")
      end

      def menu_item_at_index(index)
        @browser.link(:css => @to_item_css + " .dropdown .dropdown-menu > li:nth-child(#{index+1}) a")
      end 

      def view_menu_item
        menu_item_at_index(0)
      end  

      def edit_menu_item
        menu_item_at_index(1)
      end
      
      def delete_menu_item
        menu_item_at_index(2)
      end  

      def edit
        actions_dropdown_btn.when_present.click
        edit_menu_item.when_present.click
      end  
      
      def view
        actions_dropdown_btn.when_present.click
        view_menu_item.when_present.click
      end  

      def delete
        actions_dropdown_btn.when_present.click
        delete_menu_item.when_present.click
      end  
    end 
  end
end
