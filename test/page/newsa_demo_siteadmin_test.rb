require 'watir_test'
require 'pages/newsa/login'
require 'pages/newsa/siteadmins'
require 'pages/newsa/registersa'
require 'pages/newsa/details_edit'
require 'pages/newsa/report'

class NewSADemoSATest < WatirTest

  def setup
    super
    @login_page = Pages::NewSuperAdmin::Login.new(@config)
    @communities_page = Pages::NewSuperAdmin::Communities.new(@config)
    @siteadmins_page = Pages::NewSuperAdmin::SiteAdmins.new(@config)
    @registersa_page = Pages::NewSuperAdmin::RegisterSA.new(@config)
    @commedit_page = Pages::NewSuperAdmin::DetailsEdit.new(@config) 
    @report_page = Pages::NewSuperAdmin::Report.new(@config)

    @testsa_demosale_email = "watirtestsa_demosale@sap.com"
    @testsa_demodev_email = "watirtestsa_demodev@sap.com"
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

  user :sa_demo_sale
  p1
  def test_00010_create_sa_demo_sale
    @communities_page.layout.select_tab(:siteadmins)
    @siteadmins_page.delete_sa(@testsa_demosale_email) if !@siteadmins_page.find_sa_by_email(@testsa_demosale_email).nil?
    @siteadmins_page.create_sa(@testsa_demosale_email)

    sa = @siteadmins_page.find_sa_by_email(@testsa_demosale_email)
    assert sa.role == "Presales"

    @siteadmins_page.logout

    @registersa_page.register(@testsa_demosale_email, @testsa_password)
    @login_page.login(@testsa_demosale_email, @testsa_password)
    assert @communities_page.newsa_comm_create_btn.present?
  end

  user :sa_demo_dev
  p1
  def test_00011_create_sa_demo_dev
    @communities_page.layout.select_tab(:siteadmins)
    @siteadmins_page.delete_sa(@testsa_demodev_email) if !@siteadmins_page.find_sa_by_email(@testsa_demodev_email).nil?
    @siteadmins_page.create_sa(@testsa_demodev_email)

    sa = @siteadmins_page.find_sa_by_email(@testsa_demodev_email)
    assert sa.role == "Engineering"

    @siteadmins_page.logout

    @registersa_page.register(@testsa_demodev_email, @testsa_password)
    @login_page.login(@testsa_demodev_email, @testsa_password)
    assert @communities_page.newsa_comm_create_btn.present?
  end

  user :sa_demo_sale
  p1
  def test_00020_permission_check_demo_sale
    # Demo Sale user can't see Beta Features nav link.
    # Demo Sale user can create new community.
    assert_all_keys ({
      :beta_features_nav => !@communities_page.newsa_navbar_betafeatures_link.present?,
      :report_nav => @communities_page.newsa_navbar_report_link.present?,
      :create_community_btn => @communities_page.newsa_comm_create_btn.present?,
      :template_list_tab => @communities_page.newsa_template_list_tab_link.present?
    })

    # Demo Sale user can't see Features tab in Community Edit page.
    # Demo user can edit domain.
    @communities_page.community_list.communities[0].edit
    @browser.wait_until { @commedit_page.newsa_edit_name_field.present? }
    assert @commedit_page.newsa_edit_nav_tabs.size == 0
    assert @commedit_page.newsa_edit_domain_field.present?
  end

  user :sa_demo_sale
  p2
  def test_00021_permission_demo_sale_users_visibility
    @communities_page.layout.select_tab(:siteadmins)

    # demo sale user can only see users of demo sale
    @siteadmins_page.sa_list.site_admins.each do |sa|
      assert sa.role == "Presales" 
    end 
  end  

  user :sa_demo_dev
  p1
  def test_00022_permission_check_demo_dev
    # Demo Dev user can see Beta Features nav link.
    # Demo Dev user can create new community.
    assert_all_keys ({
      :beta_features_nav => @communities_page.newsa_navbar_betafeatures_link.present?,
      :report_nav => @communities_page.newsa_navbar_report_link.present?,
      :create_community_btn => @communities_page.newsa_comm_create_btn.present?,
      :template_list_tab => @communities_page.newsa_template_list_tab_link.present?
    })

    # Demo Dev user can see Features tab in Community Edit page.
    # Demo user can edit domain.
    @communities_page.community_list.communities[0].edit
    @browser.wait_until { @commedit_page.newsa_edit_name_field.present? }
    assert @commedit_page.newsa_edit_nav_tabs.size == 2
    assert @commedit_page.newsa_edit_domain_field.present?
  end

  user :sa_demo_dev
  p2
  def test_00023_permission_demo_dev_users_visibility
    @communities_page.layout.select_tab(:siteadmins)

    sleep 1 # add more wait to fix unstable issue, no idea why
    # demo dev user can only see all users of demo sale or demo dev
    @siteadmins_page.sa_list.site_admins.each do |sa|
      assert sa.role == "Presales" || sa.role == "Engineering"
    end 
  end  
   
  user :sa_demo_dev
  p2
  def test_00030_delete_demo_sa
    @communities_page.layout.select_tab(:siteadmins)
    @siteadmins_page.delete_sa(@testsa_demosale_email)
    @siteadmins_page.delete_sa(@testsa_demodev_email)

    assert @siteadmins_page.find_sa_by_email(@testsa_demosale_email).nil?
    assert @siteadmins_page.find_sa_by_email(@testsa_demodev_email).nil?
  end

  user :sa_demo_sale
  p2
  def test_00070_demo_export_report
    @communities_page.layout.select_tab(:report)
    
    file_entries_before_download = Dir.entries(@config.download_dir)
    @report_page.export_report
    downloaded_file = wait_file_download(@config.download_dir, file_entries_before_download, "communites_report", wait_time=30)
    assert !downloaded_file.nil?, "Cannot find the file downloaded"
  ensure 
    File.delete(downloaded_file) unless downloaded_file.nil?
  end 

  user :sa_demo_sale
  p2
  def test_00080_demo_request_report
    @communities_page.layout.select_tab(:report)
 
    # note down the report of the current date and take two non-zero page views as baseline
    old_rows = @report_page.report_table.rows

    baseline_rowcount = 2
    baseline_rows = []
    old_rows.each do |row|
      if baseline_rows.size < baseline_rowcount
        baseline_rows << {jcom_id: row.jcom_id, page_view: row.page_view} if row.page_view.to_i > 0
      else
        break
      end  
    end  

    # request the report for the last month of last year
    current_year = Time.now.strftime("%Y").to_i
    @report_page.request_report((current_year - 1).to_s, "Dec")

    # verify the report is updated by making sure 
    #  at least there is 1 different page view compared before
    differ_rows = []
    if baseline_rows.size > 0
      baseline_rows.each do |baseline_row|
        @browser.wait_until { !@report_page.report_table.rows.find { |r| r.jcom_id == baseline_row[:jcom_id] }.nil? }
        new_row = @report_page.report_table.rows.find { |r| r.jcom_id == baseline_row[:jcom_id] }
        if baseline_row[:page_view] != new_row.page_view
          differ_rows << {jcom_id: baseline_row[:jcom_id], page_view: new_row.page_view}
        end  
      end

      assert differ_rows.size > 0
    end

    # download report
    file_entries_before_download = Dir.entries(@config.download_dir)
    @report_page.export_report
    downloaded_file = wait_file_download(@config.download_dir, file_entries_before_download, "communites_report", wait_time=30)
    assert !downloaded_file.nil?, "Cannot find the file downloaded"

    # verify the exported report reflect the requested report
    count = 0
    File.open(downloaded_file).read.each_line do |line|
      differ_rows.each do |row|
        if line.split(',')[0] == row[:jcom_id]
          assert line.split(',')[2] == row[:page_view] 
          count += 1
          break
        end  
      end 

      break if count == differ_rows.size
    end
  ensure 
    File.delete(downloaded_file) unless downloaded_file.nil?
  end  
end