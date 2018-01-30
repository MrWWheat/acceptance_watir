require 'watir_test'
require 'pages/newsa/login'
require 'pages/newsa/siteadmins'
require 'pages/newsa/registersa'
require 'pages/newsa/details_edit'

class NewSAProdSATest < WatirTest

  def setup
    super
    @login_page = Pages::NewSuperAdmin::Login.new(@config)
    @communities_page = Pages::NewSuperAdmin::Communities.new(@config)
    @siteadmins_page = Pages::NewSuperAdmin::SiteAdmins.new(@config)
    @registersa_page = Pages::NewSuperAdmin::RegisterSA.new(@config)
    @commedit_page = Pages::NewSuperAdmin::DetailsEdit.new(@config) 

    @testsa_prodpv_email = "watirtestsa_prodpv@sap.com"
    @testsa_prodcs_email = "watirtestsa_prodcs@sap.com"
    @testsa_proddev_email = "watirtestsa_proddev@sap.com"
    @testsa_password = "P@ssw0rd"

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
  def test_00010_create_sa_prod_pv
    @communities_page.layout.select_tab(:siteadmins)
    @siteadmins_page.delete_sa(@testsa_prodpv_email) if !@siteadmins_page.find_sa_by_email(@testsa_prodpv_email).nil?
    @siteadmins_page.create_sa(@testsa_prodpv_email)

    @browser.wait_until(120) { !@siteadmins_page.find_sa_by_email(@testsa_prodpv_email).nil? }
    sa = @siteadmins_page.find_sa_by_email(@testsa_prodpv_email)
    assert sa.role == "Provisioning"

    @siteadmins_page.logout

    @registersa_page.register(@testsa_prodpv_email, @testsa_password)
    @login_page.login(@testsa_prodpv_email, @testsa_password)
    assert @communities_page.newsa_comm_create_btn.present?
  end

  user :sa_prod_cs
  p1
  def test_00011_create_sa_prod_cs
    @communities_page.layout.select_tab(:siteadmins)
    @siteadmins_page.delete_sa(@testsa_prodcs_email) if !@siteadmins_page.find_sa_by_email(@testsa_prodcs_email).nil?
    @siteadmins_page.create_sa(@testsa_prodcs_email)

    sa = @siteadmins_page.find_sa_by_email(@testsa_prodcs_email)
    assert sa.role == "Customer Support"

    @siteadmins_page.logout

    @registersa_page.register(@testsa_prodcs_email, @testsa_password)
    @login_page.login(@testsa_prodcs_email, @testsa_password)
    assert @communities_page.newsa_comm_table_title.present?
  end

  user :sa_prod_dev
  p1
  def test_00011_create_sa_prod_dev_with_resend_invite
    @communities_page.layout.select_tab(:siteadmins)
    @siteadmins_page.delete_sa(@testsa_proddev_email) if !@siteadmins_page.find_sa_by_email(@testsa_proddev_email).nil?
    @siteadmins_page.create_sa(@testsa_proddev_email)

    sa = @siteadmins_page.find_sa_by_email(@testsa_proddev_email)
    assert sa.role == "Engineering"

    @siteadmins_page.resend_sa_confirm_email(@testsa_proddev_email)

    @siteadmins_page.logout

    @registersa_page.register(@testsa_proddev_email, @testsa_password, true)
    @login_page.login(@testsa_proddev_email, @testsa_password)
    assert @communities_page.newsa_comm_table_title.present?
  end

  user :sa_prod_pv
  p1
  def test_00020_permission_check_prod_pv
    # Provisioning user can't see Beta Features nav link.
    # Provisioning user can create new community.
    # Provisioning user can't operate templates.
    assert_all_keys ({
      :beta_features_nav => !@communities_page.newsa_navbar_betafeatures_link.present?,
      :report_nav => @communities_page.newsa_navbar_report_link.present?,
      :create_community_btn => @communities_page.newsa_comm_create_btn.present?,
      :template_list_tab => !@communities_page.newsa_template_list_tab_link.present?
    })

    # Provisioning user can't see Features tab in Community Edit page.
    # Provisioning user can't edit domain.
    @communities_page.prod_community_list.communities[0].edit
    @browser.wait_until { @commedit_page.newsa_edit_name_field.present? }
    assert_all_keys ({
      :features_tab => @commedit_page.newsa_edit_nav_tabs.size == 0,
      :domain_field => !@commedit_page.newsa_edit_domain_field.present?,
      :customerid_field => @commedit_page.newsa_edit_customer_id.present?
    })
  end

  user :sa_prod_pv
  p2
  def test_00021_permission_prod_pv_users_visibility
    @communities_page.layout.select_tab(:siteadmins)

    # Provisioning user can only see users of demo sale
    @siteadmins_page.sa_list.site_admins.each do |sa|
      assert sa.role == "Provisioning" 
    end 
  end  

  user :sa_prod_cs
  p1
  def test_00022_permission_check_prod_cs
    # Customer Support user can't see Beta Features nav link.
    # Customer Support user can't create new community.
    assert_all_keys ({
      :beta_features_nav => !@communities_page.newsa_navbar_betafeatures_link.present?,
      :report_nav => @communities_page.newsa_navbar_report_link.present?,
      :create_community_btn => !@communities_page.newsa_comm_create_btn.present?,
      :template_list_tab => !@communities_page.newsa_template_list_tab_link.present?
    })

    @browser.wait_until { !@communities_page.newsa_table_spinner.present? }

    # Customer Support user can't see Features tab in Community Edit page.
    # Customer Support user can't edit domain.
    # Customer Support user can't delete community.
    @communities_page.prod_community_list.first_not_operating_community.actions_btn.when_present.click
    @browser.wait_until { @communities_page.prod_community_list.first_not_operating_community.actions_enable_menu_item.present? ||
                          @communities_page.prod_community_list.first_not_operating_community.actions_disable_menu_item.present? }
    assert !@communities_page.prod_community_list.first_not_operating_community.actions_delete_menu_item.present?
    @communities_page.prod_community_list.first_not_operating_community.actions_btn.click
    @communities_page.prod_community_list.first_not_operating_community.edit
    @browser.wait_until { @commedit_page.newsa_edit_name_field.present? }
    assert_all_keys ({
      :features_tab => @commedit_page.newsa_edit_nav_tabs.size == 0,
      :domain_field => !@commedit_page.newsa_edit_domain_field.present?,
      :customerid_field => @commedit_page.newsa_edit_customer_id.present?
    })
  end

  user :sa_prod_cs
  p2
  def test_00023_permission_prod_cs_users_visibility
    @communities_page.layout.select_tab(:siteadmins)

    # Customer Support user can only see all users of demo sale or demo dev
    @siteadmins_page.sa_list.site_admins.each do |sa|
      assert sa.role == "Customer Support"
    end 
  end  
  
  user :sa_prod_dev
  p1
  def test_00024_permission_check_prod_dev
    # Engineering user can see Beta Features nav link.
    # Engineering user can't create new community.
    assert_all_keys ({
      :beta_features_nav => @communities_page.newsa_navbar_betafeatures_link.present?,
      :report_nav => @communities_page.newsa_navbar_report_link.present?,
      :create_community_btn => !@communities_page.newsa_comm_create_btn.present?,
      :template_list_tab => !@communities_page.newsa_template_list_tab_link.present?
    })

    # Engineering user can see Features tab in Community Edit page.
    # All users can't edit domain.
    @communities_page.prod_community_list.communities[0].edit
    @browser.wait_until { @commedit_page.newsa_edit_name_field.present? }
    assert_all_keys ({
      :features_tab => @commedit_page.newsa_edit_nav_tabs.size == 2,
      :domain_field => !@commedit_page.newsa_edit_domain_field.present?,
      :customerid_field => @commedit_page.newsa_edit_customer_id.present?
    })
  end

  user :sa_prod_dev
  p2
  def test_00025_permission_prod_dev_users_visibility
    @communities_page.layout.select_tab(:siteadmins)

    # demo dev user can only see all users of demo sale or demo dev
    @siteadmins_page.sa_list.site_admins.each do |sa|
      assert sa.role == "Customer Support" || sa.role == "Provisioning" || sa.role == "Engineering"
    end 
  end  

  user :sa_prod_dev
  p2
  def test_00030_delete_demo_sa
    @communities_page.layout.select_tab(:siteadmins)
    @siteadmins_page.delete_sa(@testsa_prodpv_email)
    @siteadmins_page.delete_sa(@testsa_prodcs_email)
    @siteadmins_page.delete_sa(@testsa_proddev_email)
    
    assert @siteadmins_page.find_sa_by_email(@testsa_prodpv_email).nil?
    assert @siteadmins_page.find_sa_by_email(@testsa_prodcs_email).nil?
    assert @siteadmins_page.find_sa_by_email(@testsa_proddev_email).nil?
  end

  user :sa_prod_dev
  p2
  def test_00040_sa_table_load_more_btn
    @communities_page.layout.select_tab(:siteadmins)

    @browser.wait_until { @siteadmins_page.sa_list.site_admins.size > 1 }
    @browser.wait_until { @siteadmins_page.newsa_sa_table_title.present? }
    assert @siteadmins_page.sa_list.site_admins.size <= 20
    if @siteadmins_page.newsa_sa_load_more_btn.present?
      @siteadmins_page.newsa_sa_load_more_btn.click
      puts "Load More works"
      @browser.wait_until { @siteadmins_page.sa_list.site_admins.size > 20 }
    end  
  end  
end