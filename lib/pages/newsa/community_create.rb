require 'pages/newsa/newsa'

class Pages::NewSuperAdmin::CommunityCreate < Pages::NewSuperAdmin
  def initialize(config, options = {})
    super(config)
    @url = config.base_url + "/#/communities/create"
  end

  newsa_comm_create_name_field              { text_field(:css => "input[placeholder='Enter community name']") }
  newsa_comm_create_customerid_field        { text_field(:css => "input[placeholder='Enter Customer Id']") }
  newsa_comm_create_domain_field            { text_field(:css => "input[placeholder='Enter community domain']") }

  newsa_comm_create_wizard_left_link        { link(:css => ".wizzard-bar .left-group a") }
  newsa_comm_create_wizard_right_link       { element(:css => ".wizzard-bar .right-group *") }
  newsa_comm_create_wizard_spinner          { element(:css => ".wizzard-bar .v-spinner") }

  newsa_comm_create_invite_email_field      { text_field(:css => "input[placeholder='Enter email address']") }
  newsa_comm_create_invite_schedule_switch  { label(:css => ".schedule-picker .toggle label[role='checkbox']") }
  newsa_comm_create_invite_schedule_input   { text_field(:css => ".schedule-picker .toggle + div input") }

  newsa_comm_create_confirm_modal_create_btn { button(:css => "#create_modal .btn-primary") }

  def create(site_type=:demo, field_infos, admin_email, schedule)
    setup(field_infos)
    invite_admin(admin_email, schedule) unless admin_email.nil?

    newsa_comm_create_confirm_modal_create_btn.when_present.click if site_type == :prod
    @browser.wait_until { newsa_toast_success.present? }
  end

  def setup(field_infos)
    newsa_comm_create_name_field.when_present.set field_infos[:name]
    newsa_comm_create_customerid_field.when_present.set field_infos[:customerid] unless field_infos[:customerid].nil?
    newsa_comm_create_domain_field.when_present.set field_infos[:domain]

    newsa_comm_create_wizard_right_link.when_present.click
    @browser.wait_until { newsa_comm_create_wizard_spinner.present? }
    @browser.wait_until { !newsa_comm_create_wizard_spinner.present? }
  end 

  def invite_admin(admin_email, schedule)
    newsa_comm_create_invite_email_field.when_present.set admin_email
    sleep 1 # have to wait otherwise the following right button click will fail
    unless schedule.nil?
      newsa_comm_create_invite_schedule_switch.click unless newsa_comm_create_invite_schedule_switch.when_present.class_name.include?("toggled")
      newsa_comm_create_invite_schedule_input.when_present.set schedule
    end 

    newsa_comm_create_wizard_right_link.when_present.click
  end  
end