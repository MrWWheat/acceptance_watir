require 'pages/newsa/newsa'

class Pages::NewSuperAdmin::InviteAdmin < Pages::NewSuperAdmin
  newsa_comm_admin_invite_email_field       { text_field(:css => ".invite-email input[placeholder='Enter email address']") }
  newsa_comm_admin_invite_schedule_switch   { div(:css => ".schedule-picker .toggle label[role='checkbox']") }
  newsa_comm_admin_invite_schedule_input    { text_field(:css => ".schedule-picker .toggle + input") }

  newsa_comm_admin_invite_submit_btn        { button(:css => ".invite-body .action-bar .btn-primary") } 
  newsa_comm_admin_invite_cancel_btn        { link(:css => ".invite-body .action-bar .btn-default") } 

  def invite_admin(admin_email, schedule)
    newsa_comm_admin_invite_email_field.when_present.set admin_email
    sleep 1 # have to wait otherwise the following button click will fail
    unless schedule.nil?
      newsa_comm_admin_invite_schedule_switch.click unless newsa_comm_admin_invite_schedule_switch.when_present.class_name.include?("toggled")
      newsa_comm_admin_invite_schedule_input.when_present.set schedule
    end 

    newsa_comm_admin_invite_submit_btn.when_present.click
  end
end  