require 'watir_test'
require 'pages/newsa/login'
require 'pages/newsa/communities'
require 'pages/newsa/mail_catcher'
require 'pages/newsa/details_view'
require 'pages/community/home'
require 'pages/community/login'

class NewSAProdCommTest < WatirTest

  def setup
    super
    @login_page = Pages::NewSuperAdmin::Login.new(@config)
    @communities_page = Pages::NewSuperAdmin::Communities.new(@config)
    @commview_page = Pages::NewSuperAdmin::DetailsView.new(@config)
    @mail_catcher = Pages::MailCatcher::SAMailCatcher.new(@config)
    @comm_home_page = Pages::Community::Home.new(@config)
    @comm_login_page = Pages::Community::Login.new(@config)

    @test_date = Time.now.strftime("%y%m%d")
    @testcomm_name = "ProdSAWatirTest Community"
    @testcomm_customerid = "Id for Watir Test"
    @testcomm_subdomain = "watirtest-prodsa"
    @testcomm_admin_email = "watirprodadmin#{@test_date}@watir.com"
    @testcomm_admin_name = "watiradmin"
    @testcomm_admin_pwd = "P@ssw0rd"

    # assigning @current_page helps error reporting
    #  give good contextual data
    @current_page = @login_page
    puts "[[[ #{name} ::: #{user_for_test} ]]]" if @config.verbose?
    @browser = @config.browser

    if user_for_test == :anonymous
      @login_page.start!(user_for_test)
    else
      @communities_page.start!(user_for_test)
    end  
  end

  def teardown
    super
  end

  user :sa_prod_pv
  p1
  def test_00010_create_community
    unless @communities_page.find_community(:prod, @testcomm_name).nil?
      @communities_page.delete_community(:prod, @testcomm_name)
    end  

    field_infos = { name: @testcomm_name, customerid: @testcomm_customerid, domain: @testcomm_subdomain }
    @communities_page.create_community(:prod, field_infos, @testcomm_admin_email)

    @browser.goto @config.mail_catcher_url
    mail_urls = @mail_catcher.get_admin_invite_emails(@testcomm_admin_email, 2)
    assert mail_urls.size == 2
    invite_email_page = @mail_catcher.goto_admin_invite_email(mail_urls[0])

    registerfield_infos = { username: @testcomm_admin_name, 
                            firstname: "Admin", 
                            lastname: "Watir", 
                            companyname: "SAP", 
                            newpwd: @testcomm_admin_pwd }

    invite_email_page.sign_in(registerfield_infos) do |login_page|
      @browser.wait_until { login_page.username_field.present? }
      assert login_page.preview_span.present?
    end  

    user = WatirConfig::User.new(nil, @testcomm_admin_email, @testcomm_admin_pwd, @testcomm_admin_name, "", "", nil)
    logout_then_login_community(user)

    invite_email_page = @mail_catcher.goto_admin_invite_email(mail_urls[1])
    invite_email_page.sign_in registerfield_infos
    logout_then_login_community(user)
  end

  user :sa_prod_cs
  p1
  def test_00020_replace_admin
    # create community if not existing
    if @communities_page.find_community(:prod, @testcomm_name).nil?
      @communities_page.start!(:sa_prod_pv)
      field_infos = { name: @testcomm_name, customerid: @testcomm_customerid, domain: @testcomm_subdomain }
      @communities_page.create_community(:prod, field_infos, @testcomm_admin_email)
      @communities_page.start!(:sa_prod_cs)
    end 

    # view the community and replace the admin
    details_view_page = @communities_page.view_community(:prod, @testcomm_name)
    replaceadmin_email = "watirprodadmin1#{@test_date}@watir.com"
    details_view_page.replace_admin(replaceadmin_email, true)

    # verify action log is updated
    @browser.wait_until { details_view_page.action_log_table.logs[0].action == "replace_admin" }
    assert details_view_page.action_log_table.logs[0].action == "replace_admin"

    # go to mail catcher to check invitation email is received
    @browser.goto @config.mail_catcher_url
    mail_urls = @mail_catcher.get_admin_invite_emails(replaceadmin_email, 1)
    assert mail_urls.size == 1

    invite_email_page = @mail_catcher.goto_admin_invite_email(mail_urls[0])

    registerfield_infos = { username: "watiradmin1", 
                            firstname: "Admin1", 
                            lastname: "Watir", 
                            companyname: "SAP", 
                            newpwd: @testcomm_admin_pwd }

    # sign in with the new admin and its temporary password
    user = WatirConfig::User.new(nil, replaceadmin_email, @testcomm_admin_pwd, "watiradmin1", "", "", nil)
    invite_email_page.sign_in registerfield_infos
    logout_then_login_community(user)
  end

  user :sa_prod_cs
  p2
  def test_00021_invite_delete_admin
    # create community if not existing
    if @communities_page.find_community(:prod, @testcomm_name).nil?
      @communities_page.start!(:sa_prod_pv)
      field_infos = { name: @testcomm_name, customerid: @testcomm_customerid, domain: @testcomm_subdomain }
      @communities_page.create_community(:prod, field_infos, @testcomm_admin_email)
      @communities_page.start!(:sa_prod_cs)
    end

    # view the community and delete the existing admins if exists
    details_view_page = @communities_page.view_community(:prod, @testcomm_name)
    if details_view_page.admin_exists?
      details_view_page.delete_admin
    end
    comm_details_url = @browser.url

    # invite an admin
    first_admin_email = "watirprodadmin2#{@test_date}@watir.com"
    details_view_page.invite_admin(first_admin_email)
    assert details_view_page.community_admin.email == first_admin_email
    assert details_view_page.community_admin.status == "Pending", "Status of the new admin is incorrect"

    # resend invitation email
    details_view_page.resend_admin_invitation

    # go to mail catcher to check invitation email is received
    @browser.goto @config.mail_catcher_url
    mail_urls = @mail_catcher.get_admin_invite_emails(first_admin_email, 2)
    assert mail_urls.size == 2

    invite_email_page = @mail_catcher.goto_admin_invite_email(mail_urls[0])
    comm_login_url = invite_email_page.newsa_email_commadmin_signin_btn.when_present.href

    registerfield_infos = { username: "watiradmin2", 
                            firstname: "Admin2", 
                            lastname: "Watir", 
                            companyname: "SAP", 
                            newpwd: @testcomm_admin_pwd }

    # sign in with the new admin and its temporary password
    user = WatirConfig::User.new(nil, first_admin_email, @testcomm_admin_pwd, "watiradmin2", "", "", nil)
    invite_email_page.sign_in registerfield_infos
    logout_then_login_community(user)

    # delete the admin
    @browser.goto comm_details_url
    @commview_page.delete_admin

    # go to community to verify the admin is not able to login
    @browser.goto comm_login_url
    @comm_login_page.login_with_username_and_password(user)
    @browser.wait_until { @comm_login_page.login_error_msg.present? }
  end  
  
  user :sa_prod_dev
  p1
  def test_00030_toggle_beta_features
    # create community if not existing
    if @communities_page.find_community(:prod, @testcomm_name).nil?
      @communities_page.start!(:sa_prod_pv)
      field_infos = { name: @testcomm_name, customerid: @testcomm_customerid, domain: @testcomm_subdomain }
      @communities_page.create_community(:prod, field_infos, @testcomm_admin_email)
      @communities_page.start!(:sa_prod_dev)
    end

    # view the community and replace the admin
    details_edit_page = @communities_page.edit_community(:prod, @testcomm_name)
    details_edit_page.switch_to_tab(:features)
    details_edit_page.toggle_feature(:fun_switch, "events", :on)
    details_edit_page.newsa_actionbar_submit_btn.when_present.click

    # @browser.wait_until { @commview_page.newsa_details_header.present? }
    @browser.wait_until { !@commview_page.info_field_by_name("Production Domain").nil? }
    @browser.goto @commview_page.info_field_by_name("Production Domain").text

    @browser.wait_until { @comm_home_page.navigate_bar_event.present? }
  end  

  user :sa_prod_pv
  p1
  def test_00040_disable_enable_community
    # create community if not existing
    if @communities_page.find_community(:prod, @testcomm_name).nil?
      field_infos = { name: @testcomm_name, customerid: @testcomm_customerid, domain: @testcomm_subdomain }
      @communities_page.create_community(:prod, field_infos, @testcomm_admin_email)
      @communities_page.start!(:sa_prod_pv)
    end

    # verify the community status is Enabled
    comm = @communities_page.find_community(:prod, @testcomm_name)
    assert comm.status == "Enabled"

    # disable community
    comm = @communities_page.disable_community(@testcomm_name)
    assert comm.status == "Disabled"

    # go to the production instance community to verify it is unavailable
    domain = @communities_page.goto_community(:prod, @testcomm_name)
    @browser.window(:url => /#{domain}/).when_present.use do
      @browser.wait_until { @browser.url =~ /disable.html$/ }
      assert @browser.url =~ /disable.html$/
      @browser.window.close
    end   

    # go to the preview instance community to verify it is unavailable
    domain = @communities_page.goto_community(:preview, @testcomm_name)
    @browser.window(:url => /#{domain}/).when_present.use do
      @browser.wait_until { @browser.url =~ /disable.html$/ }
      assert @browser.url =~ /disable.html$/
      @browser.window.close
    end

    # go to super admin to enable the community
    comm = @communities_page.enable_community(@testcomm_name)
    assert comm.status == "Enabled"

    # go to the production instance community to verify it is available
    domain = @communities_page.goto_community(:prod, @testcomm_name)
    @browser.window(:url => /#{domain}/).when_present.use do
      @browser.wait_until { @comm_home_page.navigate_bar_home.present? }
      @browser.window.close
    end
    
    # go to the preview instance community to verify it is available
    domain = @communities_page.goto_community(:preview, @testcomm_name)
    @browser.window(:url => /#{domain}/).when_present.use do
      @browser.wait_until { @comm_home_page.navigate_bar_home.present? }
      @browser.window.close
    end
  end  

  user :sa_prod_pv
  p1
  def test_00060_delete_community
    unless @communities_page.find_community(:prod, @testcomm_name).nil?
      @communities_page.delete_community(:prod, @testcomm_name)
    end

    assert @communities_page.find_community(:prod, @testcomm_name).nil?
  end

  user :sa_prod_pv
  p2
  def test_00070_load_more_communites
    @browser.wait_until { !@communities_page.newsa_loading_spinner.present? }
    @browser.wait_until { !@communities_page.newsa_table_spinner.present? }
   
    if @communities_page.newsa_comm_load_more_btn.present?
      @communities_page.load_more
      @browser.wait_until { @communities_page.prod_community_list.communities.size > 20 }
    end  
  end  

  def logout_then_login_community(user)
    home_page = Pages::Community::Home.new(@config)
    @browser.wait_until { home_page.homebanner.present? || @browser.div(:css => ".my-auto-show-modal").present? }
    @browser.wait_until { !home_page.layout_loading_block.present? }
    if @browser.div(:css => ".my-auto-show-modal").present?
      @browser.button(:css => ".my-auto-show-modal button.btn-primary").when_present.click
      @browser.wait_until { !@browser.div(:css => ".my-auto-show-modal").present? }
    end 

    # add the following 3 sleep to fix 422 Unprocess Error issue
    sleep 1
    home_page.logout!
    sleep 1
    home_page.login_link.when_present.click
    sleep 1
    login_page = Pages::Community::Login.new(@config)
    login_page.login_with_username_and_password(user)
    @browser.wait_until { home_page.user_dropdown.present? }
    @browser.wait_until { !home_page.layout_loading_block.present? }
    assert home_page.user_dropdown.present?
    sleep 1
    home_page.logout!
  end  
end  