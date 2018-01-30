require 'pages/community'
require 'minitest/assertions'

class Pages::Community::OnboardAccountRegister < Pages::Community
  onboard_username_field        { text_field(:id => "member_username") }
  onboard_firstname_field       { text_field(:css => "input[placeholder='Enter First Name']") }
  onboard_lastname_field        { text_field(:css => "input[placeholder='Enter Last Name']") }
  onboard_companyname_field     { text_field(:css => "input[placeholder='Enter Company Name']") }
  onboard_continue_btn          { button(:css => ".signup-submit-button button") }

  onboard_current_pwd_field     { text_field(:id => "current_password") }
  onboard_new_pwd_field         { text_field(:id => "member_password") }
  onboard_confirm_pwd_field     { text_field(:id => "member_password_confirmation") }
  onboard_go_to_comm_btn        { button(:text => "Go To Community")}

  def register(field_infos)
    onboard_username_field.when_present.set field_infos[:username]
    onboard_firstname_field.when_present.set field_infos[:firstname]
    onboard_lastname_field.when_present.set field_infos[:lastname]
    onboard_companyname_field.when_present.set field_infos[:companyname]
    onboard_continue_btn.when_present.click

    onboard_current_pwd_field.when_present.set field_infos[:currentpwd]
    onboard_new_pwd_field.when_present.set field_infos[:newpwd]
    onboard_confirm_pwd_field.when_present.set field_infos[:confirmpwd]
    onboard_go_to_comm_btn.when_present.click
    @browser.wait_until { !onboard_go_to_comm_btn.present? }
  end  
end  