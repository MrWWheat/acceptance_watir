require 'pages/community/admin'
require 'pages/community/home'

class Pages::Community::AdminEmailAndProfile < Pages::Community::Admin

  def initialize(config, options = {})
    super(config)
    @url = config.base_url+"/admin/#{@config.slug}/email_designer"
  end

  def start!(user)
   # login starting from Home page
    @home_page = Pages::Community::Home.new(@config)
    @home_page.start!(user)

    navigate_in # navigate to Admin default page
    accept_policy_warning
  end

  email_designer                    { link(:class => "ember-view", :text => "Email Designer") }
  email_designer_page               { div(:class => "email-designer") }
  email_designer_edit_button        { link(:class => "btn btn-primary ember-view btn btn-primary", :text => "Edit Email Template") } 
  email_edit_page                   { div(:class => "col-md-8 background_box") }
  email_edit_icon                   { div(:class => "col-md-8 background_box").div(:class => "email-edit", :text => "Edit") }
  email_bg_textarea                 { textarea(:class => "int_background_style ember-view ember-text-area") }
  email_preivew_dialog              { div(:id => "emailPreviewModal") }
  email_preview_page                { div(:class => "email-preview") }
  email_preview_bg_style            { div(:class => " preview_email") }
  email_preview_button              { button(:css => ".email-designer .preview_email_template") }
  email_preview_ok_button           { button(:class => "btn btn-default", :value => "OK") }
  email_cancel_button               { button(:class => "btn btn-default", :value => "Cancel") }
  email_edit_publish_button         { button(:css => ".email-designer .activate_email_template") }
  email_edit_cancel_confirm_cancel_btn  { button(:css => "#emailCancelModal .modal-footer button:nth-of-type(2)") }
  email_edit_cancel_confirm_dialog  { div(:id => "emailCancelModal") }


  profile_field                     { link(:class => "ember-view", :text => "Profile Fields") }
  profile_field_page                { div(:class => "row profile-fields") }
  req_first_name_profile_field      { div(:class => "panel-body").div(:class => "row profile-fields", :index => 1).div(:class => "col-md-3", :index => 2).input(:class => "is_required ember-view ember-checkbox") }
  
  def navigate_to_email_designer
    switch_to_sidebar_item(:email_designer)

    @browser.wait_until($t) { sidebar_item(:email_designer).attribute_value("class").include?("active") }
    @browser.wait_until($t) { email_designer_page.present? }
    @browser.wait_until($t) { email_designer_edit_button.present? }
  end

  def navigate_to_profile_fields
    switch_to_sidebar_item(:profile_field)

    @browser.wait_until($t) { sidebar_item(:profile_field).attribute_value("class").include?("active") }
    @browser.wait_until($t) { profile_field_page.present? }
  end  
end