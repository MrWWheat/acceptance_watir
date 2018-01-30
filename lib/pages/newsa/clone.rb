require 'pages/newsa/newsa'

class Pages::NewSuperAdmin::Clone < Pages::NewSuperAdmin
  newsa_comm_clone_name_field              { text_field(:css => "input[placeholder='Enter community name']") }
  newsa_comm_clone_domain_field            { text_field(:css => "input[placeholder='Enter community domain']") }

  newsa_comm_clone_clone_btn               { button(:css => ".action-bar .btn-primary") }
  newsa_comm_clone_cancel_btn              { link(:css => ".action-bar .btn-default") }

  def clone(field_infos)
    newsa_comm_clone_name_field.when_present.set field_infos[:name] unless field_infos[:name].nil?
    newsa_comm_clone_domain_field.when_present.set field_infos[:domain]

    newsa_comm_clone_clone_btn.when_present.click
    @browser.wait_until { !newsa_loading_spinner.present? }
  end  
end