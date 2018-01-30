require 'pages/community/admin'
require 'pages/community/home'

class Pages::Community::AdminAdAndLegal < Pages::Community::Admin

  def initialize(config, options = {})
    super(config)
    @url = config.base_url + "/admin/#{@config.slug}/embedding"
  end

  def start!(user)
    # login starting from Home page
    @home_page = Pages::Community::Home.new(@config)
    @home_page.start!(user)

    navigate_in # go to Admin default page
    navigate_to_legal # go to advertising tab
  end

  advertising                 { link(:class => "ember-view", :text => "Advertising") }
  advertising_google_button   { button(:type => "button", :value => "Google Ads") }
  google_embed_id             { text_field(:class => "sap-regular-input ember-view ember-text-field", :index => 0) }
  google_top_banner           { text_field(:class => "sap-regular-input ember-view ember-text-field", :index => 1) }
  google_side_banner          { text_field(:class => "sap-regular-input ember-view ember-text-field", :index => 2) }
  google_ad_save              { button(:class => "btn btn-primary", :value => "Save") }

  here                        { link(:text => "here") }

  legal                       { link(:class => "ember-view", :text => "Legal/Disclosures") }
  # footer_text                 { div(:class => "col-md-offset-2 col-md-8") }
  footer_text                 { label(:css => "label[for='footer-text-pre']") }
  # footer_input                { textarea(:class => "disclosure-input form-control ember-view ember-text-area disclosure-input form-control") }
  footer_input                { textarea(:id => "footer-text-pre") }
  tou                         { text_field(:id => "terms-link") }
  tou_text                    { div(:class => "col-md-6", :text => /Terms of Use/) }
  privacy                     { text_field(:id => "privacy-link", :class => "disclosure-input form-control ember-view ember-text-field disclosure-input form-control") }
  privacy_text                { div(:class => "col-md-6", :text => /Privacy Policy/) }
  #imprint                     { text_field(:id => "imprint-link", :class => "disclosure-input form-control ember-view ember-text-field disclosure-input form-control") }
  imprint_text                { div(:class => "col-md-6", :text => /Imprint/) }
  contactus                   { text_field(:id => "contact-link", :class => "disclosure-input form-control ember-view ember-text-field disclosure-input form-control") }
  legal_publish_button        { div(:class => "row admin-topic-bottom-buttons").div(:class => "col-md-12").button(:value => "Publish") }
  legal_publish_confirm_button { div(:id => "publish-disclosure-confirm").button(:value => "Publish") }
  legal_preview_button        { button(:class => "btn btn-default", :value => "Preview") }
  legal_head_text             { div(:class => "col-md-12", :text => "Provide copyright, terms of use, other legal information, and how community users can contact your administrators. This information will be provided in the footer of each page. You will need to provide links to existing web pages for terms of use, your privacy policy, and contact information as requested below.") }
  legal_preview_close_button  { button(:class => "btn btn-default", :value => "Close") }
  legal_cookie_msg            { div(:class => "row disclosure-heading-2", :text => /Cookies, Terms of Use and Privacy Policy Message/) }
  legal_show_cookie_msg_button { button(:css => ".disclosure-bottom-buttons button") }
  cookie_proceed_button       { button(:css => "#show-warning-confirm .modal-footer .btn-primary") }
  legal_confirm_msg           { div(:class => "col-md-12", :text => "Your information was successfully saved!") }
  # tou_link                    { div(:class => "col-md-offset-2 col-md-8").div(:class => "footer", :index => 1).link(:index=> 0, :href => "http://go.sap.com/corporate/en/legal/terms-of-use.html") }
    
  def navigate_to_ad
    switch_to_sidebar_item(:advertising)

    @browser.wait_until($t) { sidebar_item(:advertising).attribute_value("class").include?("active") }
    @browser.wait_until($t) { advertising_google_button.present? }

    # dismiss the policy warning dialog if exists
    accept_policy_warning
  end

  def navigate_to_legal
    # dismiss the policy warning dialog if exists
    accept_policy_warning
    
    switch_to_sidebar_item(:disclosures)

    @browser.wait_until($t) { sidebar_item(:disclosures).attribute_value("class").include?("active") }
    @browser.wait_until($t) { legal_cookie_msg.present? }

  end 

  def set_footer(footer_link)
    footer_input.set footer_link

    publish_changes
  end

  def publish_changes
    @browser.execute_script("window.scrollBy(0,3000)")
    legal_publish_button.click
    
    @browser.wait_until($t) { legal_publish_confirm_button.present? }

    legal_publish_confirm_button.when_present.click

    @browser.wait_until($t) { !legal_publish_confirm_button.present? }
    @browser.wait_until($t) { legal_confirm_msg.present? }
  end  
end