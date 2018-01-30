require 'pages/community'
require 'pages/community/layout'
require 'pages/community/login'
require 'pages/community/home'
require 'pages/community/conversationdetail'

class Pages::Community::AccountSettings < Pages::Community

  def initialize(config, options = {})
    super(config)

    @url = config.base_url + "/n/#{config.slug}/members/edit"
  end

  account_settings_link               { div(:class=>"dropdown open").link(:text => "Account settings") }
  accout_settings_title				  { h3(:text => /Account Settings/) }
  additional_info_inputs			  { text_fields(:css => ".signin-body input[id^='ember']") }
  username_input					  { text_field(:id => "member_username") }
  email_input						  { text_field(:id => "member_email") }
  pwd_current_input					  { text_field(:id => "current_password") }
  pwd_new_input					  	  { text_field(:id => "member_password") }
  pwd_confirm_input					  { text_field(:id => "member_password_confirmation") }
  save_btn							  { button(:text => /Save/) }
  delete_btn						  { button(:text => /Delete My Account/) }

  save_confirm_dialog				  { div(:id => "save-confirm") }
  save_confirm_btn				      { div(:id => "save-confirm").button(:id => "confirm-save") }

  delete_confirm_dialog				  { div(:id => "delete-member-confirm") }
  delete_confirm_btn				  { div(:id => "delete-member-confirm").button(:text => /Delete/) }

  error_msgs						  { divs(:class => "member-error-message") }
  success_msg						  { div(:id => "success-message") }

  def goto_account_settings
    # add the following wait code to fix the issue: sometimes no response after user_dropdown.click
    @browser.wait_until { !@browser.element(:css => ".loading-block").present? }
    scroll_to_element(user_dropdown)
    user_dropdown.when_present.click
    # Account Settings can't be clicked since it might be overlapped by the toast message. e.g. Click Save in Admin->Contribtor Rating
    @browser.wait_until { !toast_message.present? }
    account_settings_link.when_present.click
    @browser.wait_until { accout_settings_title.present? }
    accept_policy_warning
  end

  def fill_additional_info info
    # sometimes, additional fields lazy load
    begin
      @browser.wait_until(5) { additional_info_inputs.size > 0 }
    rescue
    end 

  	for input in additional_info_inputs
  		input.when_present.set info
      @browser.wait_until { input.value == info }
  	end
  	if additional_info_inputs.size > 0
  		save
  		@browser.wait_until { layout.toast_success_message.present? }
      @browser.wait_until { !layout.toast_success_message.present? }
  	end
  end

  def delete_account
  	scroll_to_element(delete_btn)
  	delete_btn.when_present.click
  	sleep 1
	@browser.wait_until { delete_confirm_dialog.present? }
	delete_confirm_btn.when_present.click
	@browser.wait_until { !delete_confirm_dialog.present? }
  end

  def save
    @browser.wait_until { !layout.toast_success_message.present? } # wait until previous toast disappear
  	scroll_to_element(save_btn)
  	save_btn.when_present.click
  	sleep 1
	@browser.wait_until { save_confirm_dialog.present? }
	save_confirm_btn.when_present.click
	@browser.wait_until { !save_confirm_dialog.present? }
	# sleep 1
	@browser.wait_until { error_msgs.select{ |x| x.present? }.size > 0 || success_msg.present? || layout.toast_success_message.present? }
  end

  def change_username name
  	change_account_value [username_input], [name]
  end

  def change_email email
  	change_account_value [email_input], [email]
  end

  def change_password current_pwd, new_pwd, confirm_pwd
  	change_account_value [pwd_current_input,pwd_new_input,pwd_confirm_input],[current_pwd,new_pwd,confirm_pwd]
  end

  def change_account_value elements, values
  	elements.each_with_index do |item, index|
	  item.when_present.set values[index]
	end
	#to make username input lose focus, which can make save dialog open
	@browser.div.when_present.click
	save
	msg = error_msgs.map{ |x| x.text if x.present? }.compact
	return msg.size>0 ? msg[0]: (success_msg.present? ? success_msg.text : layout.toast_message.text)
  end

end