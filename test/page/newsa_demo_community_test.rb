require 'watir_test'
require 'pages/newsa/login'
require 'pages/newsa/communities'
require 'pages/newsa/mail_catcher'
require 'pages/newsa/details_view'
require 'pages/community/home'
require 'pages/community/login'

class NewSADemoCommTest < WatirTest

  def setup
    super
    @login_page = Pages::NewSuperAdmin::Login.new(@config)
    @communities_page = Pages::NewSuperAdmin::Communities.new(@config)
    @commview_page = Pages::NewSuperAdmin::DetailsView.new(@config)
    @mail_catcher = Pages::MailCatcher::SAMailCatcher.new(@config)
    @comm_home_page = Pages::Community::Home.new(@config)

    @test_date = Time.now.strftime("%y%m%d")
    @testcomm_name = "DemoSAWatirTest Community"
    @testcomm_customerid = "Id for Watir Test"
    @testcomm_subdomain = "watirtest-demosa"
    @testcomm_admin_email = "watirdemoadmin#{@test_date}@watir.com"
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

  user :sa_demo_sale
  p1
  def test_00010_demo_create_community
    # delete the specific community if exists
    unless @communities_page.find_community(:demo, @testcomm_name).nil?
      @communities_page.delete_community(:demo, @testcomm_name)
    end  

    # create the community
    field_infos = { name: @testcomm_name, domain: @testcomm_subdomain }
    @communities_page.create_community(:demo, field_infos, @testcomm_admin_email)

    # community admin is Pending for now
    @browser.wait_until { @commview_page.community_admin.status == "Pending" }
    comm_url = @browser.url

    # go to mail catcher to register the invited admin
    @browser.goto @config.mail_catcher_url
    mail_urls = @mail_catcher.get_admin_invite_emails(@testcomm_admin_email, 1)
    assert mail_urls.size == 1
    invite_email_page = @mail_catcher.goto_admin_invite_email(mail_urls[0])

    registerfield_infos = { username: @testcomm_admin_name, 
                            firstname: "Admin", 
                            lastname: "Watir", 
                            companyname: "SAP", 
                            newpwd: @testcomm_admin_pwd }

    invite_email_page.sign_in(registerfield_infos) 
    user = WatirConfig::User.new(nil, @testcomm_admin_email, @testcomm_admin_pwd, @testcomm_admin_name, "", "", nil)
    logout_then_login_community(user)

    # go to super admin to verify the community admin is Active
    @browser.goto comm_url
    @browser.wait_until { @commview_page.community_admin.status == "Active" }
  end

  user :sa_demo_sale
  p1
  def test_00020_demo_replace_admin
    # create community if not existing
    if @communities_page.find_community(:demo, @testcomm_name).nil?
      @communities_page.start!(:sa_demo_sale)
      field_infos = { name: @testcomm_name, domain: @testcomm_subdomain }
      @communities_page.create_community(:demo, field_infos, @testcomm_admin_email)
      @communities_page.start!(:sa_demo_sale)
    end 

    # view the community and replace the admin
    details_view_page = @communities_page.view_community(:demo, @testcomm_name)
    replaceadmin_email = "watirdemoadmin1#{@test_date}@watir.com"
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
  
  user :sa_demo_dev
  p1
  def test_00030_demo_toggle_beta_features
    # create community if not existing
    if @communities_page.find_community(:demo, @testcomm_name).nil?
      @communities_page.start!(:sa_demo_sale)
      field_infos = { name: @testcomm_name, domain: @testcomm_subdomain }
      @communities_page.create_community(:demo, field_infos, @testcomm_admin_email)
      @communities_page.start!(:sa_demo_dev)
    end

    # view the community and replace the admin
    details_edit_page = @communities_page.edit_community(:demo, @testcomm_name)
    details_edit_page.switch_to_tab(:features)
    # just check the first beta feature can be toggled on since beta feature will change periodically
    details_edit_page.toggle_feature_at_index(:beta, 0, :on) 
    details_edit_page.toggle_feature(:fun_switch, "events", :on)
    details_edit_page.newsa_actionbar_submit_btn.when_present.click

    # @browser.wait_until { @commview_page.newsa_details_header.present? }
    @browser.wait_until { !@commview_page.info_field_by_name("Demo Domain").nil? }
    @browser.goto @commview_page.info_field_by_name("Demo Domain").text

    @browser.wait_until { @comm_home_page.navigate_bar_event.present? }
  end  

  user :sa_demo_sale
  p1
  def test_00040_demo_operate_template
    # create community if not existing
    if @communities_page.find_community(:demo, @testcomm_name).nil?
      # @communities_page.start!(:sa_demo_sale)
      field_infos = { name: @testcomm_name, domain: @testcomm_subdomain }
      @communities_page.create_community(:demo, field_infos, @testcomm_admin_email)
      @communities_page.start!(:sa_demo_sale)
    end

    comm = @communities_page.find_community(:demo, @testcomm_name, nil, true)
    comm_domain = comm.domain
    template_domain = comm_domain.gsub(/\/\//, "//template-")

    # delete the specific template if exists
    @communities_page.delete_community(:demo, @testcomm_name, template_domain, true) unless @communities_page.find_community(:demo, @testcomm_name, template_domain, false, true).nil?
    
    # convert the community to template
    @communities_page.convert_to_template(@testcomm_name, comm_domain)
    template = @communities_page.find_community(:demo, @testcomm_name, nil, false, true)
    assert !template.nil? && template.domain == template_domain
    # verify total count
    @browser.wait_until { @communities_page.total_count > 0 }

    # convert to community
    @communities_page.convert_to_community(@testcomm_name, template_domain)
    assert @communities_page.find_community(:demo, @testcomm_name, nil, false, true).nil?
    assert !@communities_page.find_community(:demo, @testcomm_name, nil, false, false).nil?

    # convert it to template again
    @communities_page.convert_to_template(@testcomm_name, comm_domain)

    # clone a community
    @communities_page.copy_to_community(@testcomm_name, template_domain, @testcomm_name, @testcomm_subdomain)
    assert !@communities_page.find_community(:demo, @testcomm_name, @comm_domain).nil?

    # delete the template
    @communities_page.delete_community(:demo, @testcomm_name, template_domain, true)
    assert @communities_page.find_community(:demo, @testcomm_name, template_domain, false, true).nil?
  end   

  user :sa_demo_sale
  p1
  def test_00060_demo_delete_community
    unless @communities_page.find_community(:demo, @testcomm_name).nil?
      @communities_page.delete_community(:demo, @testcomm_name)
    end

    assert @communities_page.find_community(:demo, @testcomm_name).nil?
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
    home_page.logout!
  end  
end  