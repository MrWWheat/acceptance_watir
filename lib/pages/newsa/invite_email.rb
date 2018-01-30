require 'pages/newsa/newsa'
require 'pages/community/login'
require 'watir_config'
require 'pages/community/onboard_account_register'

class Pages::NewSuperAdmin::CommAdminInviteEmail < Pages::NewSuperAdmin
  newsa_email_commadmin_sitebrand   { element(:css => ".site-brand") }
  newsa_email_commadmin_email       { element(:css => ".info-block p:first-child") }
  newsa_email_commadmin_pwd         { element(:css => ".info-block p:last-child") }
  newsa_email_commadmin_signin_btn  { link(:css => "a[href$='sign_in']") }

  def site_brand
    newsa_email_commadmin_sitebrand.when_present.text
  end 

  def sign_in(registerfield_infos)
    email = newsa_email_commadmin_email.when_present.text.gsub(/^(Email: )*/, '')
    password = newsa_email_commadmin_pwd.when_present.text.gsub(/^(Temporary password: )*/, '')

    newsa_email_commadmin_signin_btn.when_present.click
    
    @browser.window(:url => /admins\/sign_in/).when_present.use do
      login_page = Pages::Community::Login.new(@config)
      user = WatirConfig::User.new(nil, email, password, email, "", "", nil)

      login_page.login_with_username_and_password(user)
      if block_given?
        yield(login_page) # for verification purpose
      end

      account_register_page = Pages::Community::OnboardAccountRegister.new(@config)
      field_infos = { username: registerfield_infos[:username], 
                      firstname: registerfield_infos[:firstname], 
                      lastname: registerfield_infos[:lastname], 
                      companyname: registerfield_infos[:companyname], 
                      currentpwd: password, 
                      newpwd: registerfield_infos[:newpwd], 
                      confirmpwd: registerfield_infos[:newpwd] }
      account_register_page.register(field_infos)
      # @browser.window.close
    end
  end  
end  