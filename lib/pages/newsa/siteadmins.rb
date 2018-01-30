require 'pages/newsa/newsa'

class Pages::NewSuperAdmin::SiteAdmins < Pages::NewSuperAdmin
  def initialize(config, options = {})
    super(config)
    @url = config.base_url + "/#/users"
  end

  def start!(user)
    super(user, @url, newsa_sa_table_title)
  end

  newsa_sa_create_btn                       { link(:css => ".header-section .btn-primary[href='#/users/new']") }
  newsa_sa_table_title                      { element(:class => "list-table-title", :text => "Site Administrators") }
  newsa_sa_search_field                     { text_field(:css => "input[placeholder='Search site administrators']") }
  newsa_sa_load_more_btn                    { button(:text => "Load More") }

  newsa_sa_del_modal                        { div(:id => "del_admin") }
  newsa_sa_del_modal_input                  { text_field(:css => "#del_admin input") }
  newsa_sa_del_modal_confirm_btn            { button(:css => "#del_admin button.btn-primary") }

  # Invite Site Administrators page
  newsa_invitesa_title                      { h2(:text => "Invite Site Administrators") }
  newsa_invitesa_email_field                { div(:css => ".im-textarea-container .im-textarea") }
  newsa_invitesa_email_pill                 { div(:css => ".pill") }
  
  def sa_list
    SiteAdminList.new(@browser)
  end  
  
  def create_sa(email)
    delete_sa(email)

    scroll_to_element newsa_sa_create_btn
    @browser.execute_script("window.scrollBy(0,-200)")
    sleep 0.5 # no idea why unstable sometimes
    newsa_sa_create_btn.when_present.click
    newsa_invitesa_email_field.when_present.click
    @browser.send_keys email
    @browser.send_keys :enter
    @browser.wait_until { newsa_invitesa_email_pill.present? }
    newsa_actionbar_submit_btn.when_present.click
    @browser.wait_until { newsa_toast_success.present? }
    @browser.wait_until { !newsa_toast_message.present? }
  end

  def search(keyword)
    newsa_sa_search_field.when_present.set keyword
    @browser.send_keys :enter
    sleep 1
    @browser.wait_until { !newsa_table_spinner.present? }
  end 

  def find_sa_by_email(email, throw_exception_when_fail=false)
    newsa_sa_search_field.set "" if newsa_sa_search_field.when_present.value == ""
    sa = sa_list.find_sa_by_email(email)

    if sa.nil?
      search(email)

      sa = sa_list.find_sa_by_email(email)
      raise "Cannot find the site admin with email #{email}" if sa.nil? && throw_exception_when_fail
    end

    sa
  end  

  def delete_sa(email, throw_exception_when_fail=false)
    sa = find_sa_by_email(email, throw_exception_when_fail)
    unless sa.nil?
      old_count = sa_list.site_admins.size
      sa.delete
      newsa_sa_del_modal_input.when_present.set "delete"
      newsa_sa_del_modal_confirm_btn.when_present.click
      @browser.wait_until { !newsa_sa_del_modal.present? }
      @browser.wait_until { sa_list.site_admins.size == (old_count - 1) }
    end  
  end

  def resend_sa_confirm_email(email)
    find_sa_by_email(email, true).resend_confirm_email

    @browser.wait_until { newsa_toast_success.present? }
    @browser.wait_until { !newsa_toast_message.present? }
  end  

  class SiteAdminList
    def initialize(browser)
      @browser = browser
      @parent_css = ".list-table"
    end

    def site_admins
      list = []
      @browser.divs(:css => @parent_css + " .table-row").each_with_index do |row, index|
        list << SiteAdmin.new(@browser, ".list-table > .table-row:nth-child(#{index+2})")
      end
      list
    end

    def find_sa_by_email(email)
      site_admins.find { |sa| sa.email.downcase == email.downcase }
    end 

    class SiteAdmin
      def initialize(browser, parent_css)
        @browser = browser
        @parent_css = parent_css
      end

      def email
        @browser.div(:css => @parent_css + " > div:nth-child(1)").when_present.text
      end
      
      def role
        @browser.div(:css => @parent_css + " > div:nth-child(2)").when_present.text
      end

      def invited_by
        @browser.div(:css => @parent_css + " > div:nth-child(3)").when_present.text
      end

      def actions_btn
        @browser.button(:css => @parent_css + " > div:nth-child(5) button")
      end 

      def delete_menu_item
        @browser.div(:css => @parent_css + " > div:nth-child(5)").link(:text => "Delete")
      end

      def resend_confirm_email_menu_item
        @browser.div(:css => @parent_css + " > div:nth-child(5)").link(:text => "Resend Confirmation Email")
      end 

      def delete
        actions_btn.when_present.click
        delete_menu_item.when_present.click
      end

      def resend_confirm_email
        actions_btn.when_present.click
        resend_confirm_email_menu_item.when_present.click
      end  
    end  
  end  
end

