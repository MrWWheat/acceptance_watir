require 'pages/community/admin'
require 'pages/community/home'

class Pages::Community::AdminSamlIdp < Pages::Community::Admin

  def initialize(config, options = {})
    super(config)
    @url = config.base_url + "/admin/#{@config.slug}/idp_configuration"
  end

  def start!(user)
    # login starting from Home page
    @home_page = Pages::Community::Home.new(@config)
    @home_page.start!(user)

    navigate_in # go to Admin default page
    accept_policy_warning

    @private_key = nil
    @certificate = nil
  end

  saml_idp_settings_page                     { div(:id => "idp_form") }
  new_saml_idp_config_btn                    { link(:class => "btn btn-primary", :text => /New IDP Configuration/)}
  issur_input                                { text_field(:id => "issuer")}
  generate_key_pairs_btn                     { button(:class => "btn btn-default", :text => /Generate Key Pairs/)}
  generate_save_btn                          { button(:class =>"btn btn-primary", :text => /Save/)}
  generate_cancel_btn                        { button(:class =>"btn btn-default", :text => /Cancel/)}
  view_edit_btn                              { link(:text => /Edit/) }
  view_back_to_list_btn                      { link(:text => /Back to all IDPs/) }
  idp_form_list                              { div(:class => "admin-grid admin-auth-grid col-md-12").divs(:class => "row")}
  idp_form_item                              { div(:class => "admin-grid admin-auth-grid col-md-12").div(:class => "row")}
  action_button                              { button(:id => "drop1")}
  delete_button                              { ul(:class => "dropdown-menu app-detail-row").link(:text => /Delete/)}
  private_key_input                          { textarea(:id =>"private_key")}
  certificate_key_input                      { textarea(:id =>"certificate")}
  
  idp_radio_option_btns                      { inputs(:css => ".integration-form input[type=radio]") }
  save_success_msg_label                     { div(:css => "#notice")}

  delete_confirm_dialog                      { div(:id => "delete-idp-confirm") }
  delete_confirm_btn                         { div(:id => "delete-idp-confirm").button(:text => /Delete/) }

  def idp_list
    IDPList.new(@browser)
  end  

  def navigate_to_saml_tab
    switch_to_sidebar_item(:saml)

    @browser.wait_until($t) { sidebar_item(:saml).attribute_value("class").include?("active") }
    @browser.wait_until($t) { saml_idp_settings_page.present? }
  end

  def select_radio_option(option)
    case option
    when :import
      idp_radio_option_btns[0].click
      @browser.wait_until { idp_radio_option_btns[0].checked? }
    when :generate 
      idp_radio_option_btns[1].click
      @browser.wait_until { idp_radio_option_btns[1].checked? }
    else
      raise "Radio option #{option} is unsupported yet"
    end  
  end

  def create_new_idp(name, generate_key_type = :generate)
    delete_idp(name) if idp_list.idp_exists?(name)
    sleep 1
    new_saml_idp_config_btn.when_present.click
    issur_input.when_present.set(name)
    select_radio_option(:generate)
    generate_key_pairs_btn.when_present.click
    select_radio_option(:import) if generate_key_type === :import
    @browser.wait_until { !private_key_input.value.strip.empty? } unless generate_key_type === :import
    @browser.wait_until { !certificate_key_input.value.strip.empty? }

    accept_policy_warning
    generate_save_btn.when_present.click
    @browser.wait_until { toast_success_message.present? }
  end 

  def delete_idp(name)
    idp_list.delete_idp(name)
    @browser.wait_until{ delete_confirm_dialog.present? }
    delete_confirm_btn.when_present.click
    @browser.wait_until{ !delete_confirm_dialog.present? }
    @browser.wait_until { !idp_list.idp_exists?(name) }
  end

  # def view_idp_config
  #   idp_form_list.each_with_index do |div_item|
  #     if div_item.text.include?"watir_test"
  #       div_item.button(:id => "drop1").when_present.click
  #       div_item.ul(:class => "dropdown-menu app-detail-row").link(:text => /View/).when_present.click
  #       @browser.wait_until($t) { !div_item.present? }
  #       break
  #     end
  #   end
  #   @browser.wait_until($t) { issur_input.present? }
  # end

  # def delete_idp_config(issur_name)
  #   idp_form_list.each_with_index do |div_item|
  #     if div_item.text.include?issur_name
  #       div_item.button(:id => "drop1").when_present.click
  #       div_item.ul(:class => "dropdown-menu app-detail-row").link(:text => /Delete/).when_present.click
  #       @browser.wait_until($t) { !div_item.present? }
  #       break
  #     end
  #   end
  # end

  def private_key_value
    return @private_key
  end

  def certificate_key_value
    return @certificate
  end

  class IDPList
    attr_reader :browser

    def initialize(browser)
      @browser = browser
    end

    def idp_grid_css
      "#idp_form .admin-grid"
    end  

    def idp_at_name_css(name)
      idp_grid_css + " ##{name}"
    end

    def idp_at_name(name)
      IDPItem.new(idp_at_name_css(name), @browser)
    end  
    
    def view_idp(name)
      idp_at_name(name).view

      @browser.wait_until { !idp_exists?(name) }
    end  

    def delete_idp(name)
      idp_at_name(name).delete
    end

    def idp_exists?(name)
      @browser.div(:css => idp_at_name_css(name)).present?
    end  

    class IDPItem
      attr_reader :idp_item_css, :browser

      def initialize(idp_item_css, browser)
        @idp_item_css = idp_item_css
        @browser = browser
      end

      def actions_dropdown_btn
        @browser.button(:css => @idp_item_css + " .dropdown button")
      end

      def menu_item_at_index(index)
        @browser.link(:css => @idp_item_css + " .dropdown .dropdown-menu > li:nth-child(#{index+1}) a")
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
