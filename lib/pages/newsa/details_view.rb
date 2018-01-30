require 'pages/newsa/newsa'
require 'pages/newsa/invite_admin'

class Pages::NewSuperAdmin::DetailsView < Pages::NewSuperAdmin
  def initialize(config, options = {})
    super(config)
  end

  newsa_details_header                 { div(:css => ".detail-header") }
  newsa_details_edit_btn               { link(:css => ".detail-header #edit_btn") }

  newsa_details_list_tables            { divs(:css => ".list-table") }
  newsa_details_add_comm_admin_btn     { div(:css => ".list-table").link(:text => "+ Community Admin") }
  newsa_details_replace_admin_inputs   { text_fields(:css => "#replace_admin input") }
  newsa_details_replace_admin_replace_btn { button(:css => "#replace_admin .btn-primary") }

  newsa_details_delete_admin_modal     { div(:id => "del_admin") }
  newsa_details_delete_admin_modal_input        { text_field(:css => "#del_admin input") }
  newsa_details_delete_admin_modal_confirm_btn  { button(:css => "#del_admin .btn-primary") }

  def community_admin
    CommunityAdmin.new(@browser)
  end

  def admin_exists?
    @browser.wait_until { newsa_details_add_comm_admin_btn.present? || community_admin.present? }
    community_admin.present?
  end  

  def action_log_table
    ActionLogTable.new(@browser, newsa_details_list_tables[1])
  end  

  def info_field_by_name(name)
    result = nil

    @browser.divs(:css => ".info-group").each do |e|
      if e.p(:css => ".info-label").text.downcase == name.downcase
        result = e.p(:css => ".info-label + p")
        break
      else
        next
      end  
    end 

    result
  end 

  def invite_admin(admin_email, schedule=nil)
    newsa_details_add_comm_admin_btn.when_present.click
    invite_admin_page = Pages::NewSuperAdmin::InviteAdmin.new(@config)
    invite_admin_page.invite_admin(admin_email, schedule)
    @browser.wait_until { newsa_toast_success.present? }
    @browser.wait_until { admin_exists? }
  end 

  def replace_admin(new_admin_email, expect_toast_msg=false)
    community_admin.actions_btn.when_present.click
    community_admin.actions_replace_admin_menu_item.when_present.click
    @browser.wait_until { newsa_details_replace_admin_inputs.size == 2 }
    newsa_details_replace_admin_inputs[0].set new_admin_email
    newsa_details_replace_admin_inputs[1].set "replace"
    @browser.wait_until { !newsa_details_replace_admin_replace_btn.when_present.class_name.include?("disabled") }
    newsa_details_replace_admin_replace_btn.click
    @browser.wait_until { newsa_toast_success.present? } if expect_toast_msg
    @browser.wait_until { community_admin.present? && community_admin.email.include?(new_admin_email) }
  end 

  def delete_admin
    @browser.wait_until { admin_exists? }
    community_admin.delete
    newsa_details_delete_admin_modal_input.when_present.set "delete"
    @browser.wait_until { !newsa_details_delete_admin_modal_confirm_btn.when_present.class_name.include?("disabled") }
    newsa_details_delete_admin_modal_confirm_btn.when_present.click
    @browser.wait_until { !admin_exists? }
  end 

  def resend_admin_invitation
    @browser.wait_until { admin_exists? }
    community_admin.resend_invitation_email
    @browser.wait_until { newsa_toast_success.present? }
  end  

  class CommunityAdmin
    def initialize(browser)
      @browser = browser
      @parent_css = ".list-table .table-row"
    end

    def present?
      @browser.div(:css => @parent_css + " .email").present?
    end  

    def email
      @browser.element(:css => @parent_css + " > div:nth-child(1) p:not(.status)").when_present.text
    end

    def status
      @browser.element(:css => @parent_css + " > div:nth-child(1) .status").when_present.text
    end  
    
    def last_active
      @browser.div(:css => @parent_css + " > div:nth-child(2)").when_present.text
    end

    def invitation_sent
      @browser.div(:css => @parent_css + " > div:nth-child(3)").when_present.text
    end

    def actions_btn
      @browser.button(:css => @parent_css + " > div:nth-child(4) button")
    end 

    def actions_replace_admin_menu_item
      @browser.div(:css => @parent_css + " > div:nth-child(4)").link(:text => "Replace Admin")
    end  

    def actions_resend_email_menu_item
      @browser.div(:css => @parent_css + " > div:nth-child(4)").link(:text => /Resend/)
    end 

    def actions_delete_menu_item
      @browser.div(:css => @parent_css + " > div:nth-child(4)").link(:text => "Delete")
    end

    def delete
      actions_btn.when_present.click
      actions_delete_menu_item.when_present.click
    end 

    def resend_invitation_email
      actions_btn.when_present.click
      actions_resend_email_menu_item.when_present.click
    end  
  end

  class ActionLogTable
    def initialize(browser, parent)
      @browser = browser
      @parent = parent
    end

    def logs
      list = []
      @parent.divs(:css => ".table-row").each_with_index do |row, index|
        list << LogRow.new(@browser, @parent, ".list-table > .table-row:nth-child(#{index+2})")
      end
      list
    end

    class LogRow
      def initialize(browser, parent_table, subparent_css)
        @browser = browser
        @parent_table = parent_table
        @subparent_css = subparent_css
      end

      def action
        @parent_table.div(:css => @subparent_css + " > div:nth-child(1)").when_present.text
      end
      
      def actor
        @parent_table.div(:css => @subparent_css + " > div:nth-child(2)").when_present.text
      end

      def time
        @parent_table.div(:css => @subparent_css + " > div:nth-child(3)").when_present.text
      end

      def prev_value
        @parent_table.div(:css => @subparent_css + " > div:nth-child(4)").when_present.text
      end 

      def next_value
        @parent_table.div(:css => @subparent_css + " > div:nth-child(5)").when_present.text
      end  
    end
  end  
end