require 'pages/community/admin'
require 'pages/community/home'

class Pages::Community::AdminWebhooks < Pages::Community::Admin

  def initialize config, option = {}
    super config
    @url = "#{config.base_url}/admin/#{config.slug}/webhooks"
  end

  def start! user
    @home_page = Pages::Community::Home.new @config
    @home_page.start! user
    navigate_in
    accept_policy_warning
  end

  new_webhook_btn              { link(:class => 'btn btn-primary', :text => /New Webhook/) }

  create_webhook_btn           { div(:class => 'webhook-submit').input(:class => 'btn btn-primary', :value => /Create/) }
  cancel_webhook_btn           { div(:class => 'webhook-cancel').input(:class => "btn btn-default", :value => /Cancel/) }
  update_webhook_btn           { div(:class => 'webhook-submit').input(:class => 'btn btn-primary', :value => /Update/) }

  edit_webhook_link            { link(:text => /Edit Webhook/) }
  back_to_all_webhook_link     { link(:text => /Back to all webhooks/)}

  delete_webhook_confirm_dlg   { div(:id => 'delete-webhook-confirm') }
  delete_webhook_confirm_btn   { div(:id => 'delete-webhook-confirm').button(:text => /Delete/) }
  delete_action_btn            { ul(:class => "dropdown-menu").link(:text => /Delete/) }

  email_notification_checkbox  { input(:css => '.webhooks-checkboxes input') }
  email_notification_span      { span(:css => '.webhooks-checkboxes label span') }
  bell_notification_checkbox   { input(:css => '.webhooks-checkbox input') }
  bell_notification_span       { span(:css => '.webhooks-checkbox label span') }
  et_all_events_checkbox       { input(:css => '.webhooks-checkbox input') }
  et_all_events_span           { span(:css => '.webhooks-checkbox label span') }
  active_webhook_checkbox      { input(:css => '.webhook-field .ember-view input') }
  active_webhook_span          { span(:css => '.webhook-field label span') }
  regenerate_token_btn         { div(:class => 'btn btn-default', :text => /Regenerate Token/) }
  new_webhook_url_input        { text_field(:id => 'webhook-url') }
  new_webhook_title_input      { text_field(:id => 'webhook-title') }

  webhook_list                 { div(:css => '.row.webhooks-list .admin-grid').divs(:class => 'row') }

  create_webhook_success_msg   { div(:class => 'webhook-field', :text => /The webhook was saved successfully/) }

  def navigate_in_admin_webhooks
    switch_to_sidebar_item :webhooks
    @browser.wait_until { sidebar_item(:webhooks).attribute_value('class').include?('active') }

    @browser.wait_until { new_webhook_btn.present? }
  end

  def create_webhook(title, url)
    @browser.wait_until { new_webhook_btn.present? }
    new_webhook_btn.when_present.click

    new_webhook_title_input.when_present.set title
    new_webhook_url_input.when_present.set url
    regenerate_token_btn.when_present.click
    et_all_events_span.when_present.click unless et_all_events_checkbox.checked?
    active_webhook_span.when_present.click unless active_webhook_checkbox.checked?

    create_webhook_btn.when_present.click
    @browser.wait_until { create_webhook_success_msg.present? } 
  end

  def update_title(upadated_title)
    new_webhook_title_input.when_present.set upadated_title
    update_webhook_btn.when_present.click
    @browser.wait_until { create_webhook_success_msg.present? } 
  end

  def assert_email_bell_notification_checkbox
    email_notification_span.click if email_notification_checkbox.checked?
    assert !email_notification_checkbox.checked?
    email_notification_span.click unless email_notification_checkbox.checked?
    assert email_notification_checkbox.checked?

    bell_notification_span.click if bell_notification_checkbox.checked?
    assert !bell_notification_checkbox.checked?
    bell_notification_span.click unless bell_notification_checkbox.checked?
    assert bell_notification_checkbox.checked?
  end

  def delete_webhook title, url
    @browser.wait_until { new_webhook_btn.present? }
    @index = 0
    webhook_list.each do |item|
      @index = @index + 1
      i_title = @browser.div(:css => '.row.webhooks-list .admin-grid .row', :index => @index).div(:css => '.webhook-title').text
      i_url = @browser.div(:css => '.row.webhooks-list .admin-grid .row', :index => @index).div(:css => '.webhook-url').text
      if i_title.eql?(title) && i_url.eql?(url)
        @browser.div(:css => '.row.webhooks-list .admin-grid .row', :index => @index).button(:class => 'btn btn-default dropdown-toggle', :text => /Actions/).when_present.click
        @browser.div(:css => '.row.webhooks-list .admin-grid .row', :index => @index).ul(:css => ".dropdown-menu").link(:text => /Delete/).when_present.click
        @browser.wait_until { delete_webhook_confirm_dlg.present? }
        delete_webhook_confirm_btn.when_present.click
        @browser.wait_until { !delete_webhook_confirm_dlg.present? }
        @browser.wait_until { !item.present? }
        return
      end
    end
  end

end