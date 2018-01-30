# require 'pages/newsa/newsa'

class Pages::NewSuperAdmin::Layout < Pages::NewSuperAdmin
	def initialize(config, params = {})
    super(config)
  end

  newsa_user_dropdown_toggle          { button(:css => "#user-actions button") }
  newsa_user_signout_menu             { link(:css => "#user-actions .dropdown-menu a[href='#/logout']") }

  newsa_navbar_communities_link       { link(:css => ".sub-nav-bar a[href='#/']") }
  newsa_navbar_betafeatures_link      { link(:css => ".sub-nav-bar a[href='#/beta-features']") }
  newsa_navbar_siteadmins_link        { link(:css => ".sub-nav-bar a[href='#/users']") }
  newsa_navbar_report_link            { link(:css => ".sub-nav-bar a[href='#/report']") }

  newsa_actionbar_submit_btn          { button(:css => ".action-bar .btn-primary") }
  newsa_actionbar_cancel_btn          { link(:css => ".action-bar .btn-default") }

  newsa_loading_spinner               { element(:css => ".v-spinner") }
  newsa_table_spinner                 { div(:css => ".load-more .v-spinner") }
  newsa_toast_message                 { div(:css => ".global-toast .single-toast") }
  newsa_toast_success                 { span(:css => ".toast-success") }

  def tab_present?(tab)
    case tab
    when :communities
      newsa_navbar_communities_link.present?
    when :betafeatures
      newsa_navbar_betafeatures_link.present?
    when :siteadmins
      newsa_navbar_siteadmins_link.present?
    when :report
      newsa_navbar_report_link.present?
    else
      raise "tab #{tab} is not supported yet" 
    end 
  end
  	
  def tab_selected?(tab)
    case tab
    when :communities
      newsa_navbar_communities_link.class_name.include?("active")
    when :betafeatures
      newsa_navbar_betafeatures_link.class_name.include?("active")
    when :siteadmins
      newsa_navbar_siteadmins_link.class_name.include?("active")
    when :report
      newsa_navbar_report_link.class_name.include?("active")
    else
      raise "tab #{tab} is not supported yet"	
    end	
  end	

  def select_tab(tab)
    case tab
    when :communities
      newsa_navbar_communities_link.click unless tab_selected?(tab)
      @browser.wait_until { Pages::NewSuperAdmin::Communities.new(@config).newsa_comm_table_title.present? }
    when :betafeatures
      newsa_navbar_betafeatures_link.click unless tab_selected?(tab)
    when :siteadmins
      newsa_navbar_siteadmins_link.click unless tab_selected?(tab)
      @browser.wait_until { Pages::NewSuperAdmin::SiteAdmins.new(@config).newsa_sa_table_title.present? }
    when :report
      newsa_navbar_report_link.click unless tab_selected?(tab)
    else
      raise "tab #{tab} is not supported yet" 
    end

    @browser.wait_until { !newsa_loading_spinner.present? }
    @browser.wait_until { !newsa_table_spinner.present? }
  end  
end	
