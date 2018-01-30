require 'pages/community'

class Pages::Community::Layout < Pages::Community
  def initialize(config, params = {})
    super(config)
  end

  preview_span                  { div(:css => ".customization-preview") }
  preview_click_here_link       { link(:css => ".customization-preview a") }

  ################ top nav elememts ###################
  login_link            { link(:class => /ember-view login/) }
   
  navigate_bar_product                     { div(:class => "navbar-collapse collapse").ul(:class => "nav-list-menu").link(:class => "ember-view", :text => "Products")}
  navigate_bar_event                       { div(:class => "navbar-collapse collapse").ul(:class => "nav-list-menu").link(:class => "ember-view", :text => "Events")}
  navigate_bar_about                       { div(:class => "navbar-collapse collapse").ul(:class => "nav-list-menu").link(:class => "ember-view", :text => "About")}
  navigate_bar_home                        { div(:class => "navbar-collapse collapse").ul(:class => "nav-list-menu").link(:class => "ember-view", :text => "Home")}

  community_name_span                      { span(:class => "community-name") }

  # username drop down & associated content
  user_dropdown         { element(:css => ".dropdown-toggle.profile .caret") }
  user_dropdown_menu    { ul(:css => ".dropdown-menu.member-menu") }
  dropdown_settings     { link(:href => /members\/edit/) }
  dropdown_logout       { link(:css => ".dropdown.open .dropdown-menu .sign-out a") }
  dropdown_admin        { link(:href => /\/admin\/#{@@slug}/) }

  shopping_cart_icon    { div(:class => "nav-cart")}
  shopping_cart_popup   { ul(:css => ".nav-cart.open .drop-menu-layer") }
  shopping_cart_items   { lis(:css => ".cart-popup-item") }
  cart_item_ghost       { element(:class => "cart-item-ghost") }
  checkout_button       { link(:class => "checkout-btn")}
  overnumber_cart_items { lis(:class => "cart-popup-item error")}

  logout_link           { link(:text => /Sign Out/) }
  admin_link            { link(:text => /Admin/) }

  # ".navbar .profile"
  product_nav           { link(:href => /\/n\/#{@@slug}\/products/) }

  user_avatar           { link(:href => /\/n\/#{@@slug}\/profile/) }

  topnav_search_input   { text_field(:css => ".isNotPhone .search-bar input") }
  topnav_search_autocomplete { span(:css => ".isNotPhone .search-bar .tt-dropdown-menu") }
  
  layout_loading_block          { div(:css => ".loading-block") }
  layout_loading_spinner        { element(:css => ".fa-spinner") }

  ################ footer elememts ###################
  footer                { footer(:class => "ember-view") }

  terms_of_use          {link(:text => "Terms of Use")}
  privacy_policy        {link(:text => "Privacy Policy")}
  imprint               {link(:text => "Imprint")}
  contact_us            {link(:text => "Contact Us")}

  footer_home           {ul(:class => "footer-nav-links", :index => 1).link(:text => "Home")}
  footer_topics         {ul(:class => "footer-nav-links", :index => 1).link(:text => "Topics")}
  footer_about          {ul(:class => "footer-nav-links", :index => 1).link(:text => "About")}

  select_lan            {select_list(:id => "lang-selector")}

  ################ Policy Warning elememts ###################
  policy_warning                { div(:id => "policy-warning") }
  policy_warning_primary_button { div(:class => "policy-warning-button").button(:class => "btn btn-primary") }


  ################ Edit wizard elememts ###################
  edit_wizard               { div(:css => ".topic-create-wizard") }
  cancel_btn_in_edit_wizard { div(:css => ".topic-create-wizard").link(:text => "Cancel") }
  confirm_discard_modal_dlg { div(:css => ".confirm-discard .modal-dialog") }
  cancel_btn_in_modal_dlg   { button(:css => ".confirm-discard .modal-dialog .modal-footer button:first-child") }

  next_btn_in_edit_wizard   { div(:css => ".topic-create-wizard").link(:text => /Next/)  }

  publish_btn_in_edit_wizard  { div(:css => ".topic-create-wizard").button(:text => "Publish Changes") }

  ################ Toast Message ###################
  toast_message               { div(:css => ".single-toast") }
  toast_success_message       { span(:css => ".toast-success") }

  def search_at_topnav(keyword)
    topnav_search_input.when_present.set keyword
    # @browser.wait_until { topnav_search_autocomplete.present? }
    @browser.send_keys :enter
  end 

  def cancel_edit
    if edit_wizard.present?
      @browser.execute_script("window.scrollTo(0,document.documentElement.scrollTop)")
      cancel_btn_in_edit_wizard.when_present.click

      confirm_discard_modal_dlg.when_present
      cancel_btn_in_modal_dlg.when_present.click
      @browser.wait_until($t) { !edit_wizard.present? }
    end
  end

  def publish_edit
    next_btn_in_edit_wizard.when_present.click
    publish_btn_in_edit_wizard.when_present.click
    @browser.wait_until($t) { !edit_wizard.present? }
  end 

  def wait_until_loading_complete
    @browser.wait_until { !layout_loading_block.present? }
    @browser.wait_until { !layout_loading_spinner.present? }
  end 
end
