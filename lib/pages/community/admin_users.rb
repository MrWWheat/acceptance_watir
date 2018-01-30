require 'pages/community/admin'
require 'pages/community/home'
require 'pages/community/login'
require 'pages/community/layout'
require 'pages/community/profile'
require 'watir_config'
#require 'pages/base'

class Pages::Community::AdminUsers < Pages::Community::Admin

  def initialize(config, options = {})
    super(config)
    # @url = config.base_url + "/n/#{config.slug}/home"
    @url = config.base_url + "/admin/#{@config.slug}/user_management"
  end

  def start!(user)
    # login starting from Home page
    @home_page = Pages::Community::Home.new(@config)
    @profile_page = Pages::Community::Profile.new(@config)
    @home_page.start!(user)

    navigate_in
  end

  user_invite_tab             { link(:id => "user_invite") }
  user_list_tab               { link(:id => "user_list") }
  invite_user_textarea        { div(:class => "pill-textarea form-control") }
  invite_message_textarea     { textarea(:id => "invite_message") }
  single_users                { div(:class => "pill-textarea form-control").links(:class => "title") }               
  send_invite_btn             { button(:id => "send_invite") }  
  preview_email_text          { div(:class => "preview_email") }
  preview_email_btn           { link(:text => /Preview/) }
  preview_email_close         { button(:css => "#email-preview-modal .close") }

  delete_btn                { div(:class => "user-banner").button(:text => /Delete/) }
  ban_btn                   { div(:class => "user-banner").button(:text => /Ban/) }

  select_count              { span(:class => "selected-count") }

  user_list_loading         { div(:class => "user-list loading") }
  user_list                 { div(:class => "user-list")}
  user_rows                 { divs(:class => "user-list-item") }
  user_search_box           { div(:class => "user-search").text_field }

  filter_btn                { button(:id => "admin-topics-list-filter")}
  filter_all_btn            { link(:text => "Username")}
  filter_active_btn         { link(:text => "Active")}
  filter_banned_btn         { link(:text => "Banned")}
  filter_pending_btn        { link(:text => "Pending")}

  ban_modal                 { div(:id => "ban-modal") }
  ban_msg_input             { div(:id => "ban-modal").textarea }
  ban_user_btn              { div(:id => "ban-modal").button(:id => "drop-btn") }
  delete_modal              { div(:id => "delete-modal") }
  delete_user_btn           { div(:id => "delete-modal").button(:id => "drop-btn") }
  reset_modal               { div(:id => "reset-modal") }
  reset_btn                 { div(:id => "reset-modal").button(:id => "drop-btn") }

  user_list_empty_label     { element(:css => ".user-list .empty-container-text") }

  pagination_bar            { div(:class => "pagination-container") }
  pre_btn                   { link(:text => /Previous Page/) }
  next_btn                  { link(:text => /Next Page/) }
  first_btn                 { link(:text => /First/) }
  last_btn                  { link(:text => /Last/) }
  active_page               { link(:class => "pagination-link active")}

  def navigate_in
    super
    accept_policy_warning
    switch_to_sidebar_item(:users)
    wait_until_admin_users_page_loaded
  end

  def wait_until_admin_users_page_loaded
    @browser.wait_until($t) { invite_user_textarea.present? }
    @browser.wait_until($t) { user_list_tab.present? }
  end

  def wait_until_invite_loaded
    @browser.wait_until($t) { invite_user_textarea.present? }
    @browser.wait_until($t) { send_invite_btn.present? }
  end

  def wait_until_list_loaded
    @browser.wait_until($t) { !user_list_loading.present? }
    @browser.wait_until($t) { user_rows.size > 0 || user_list_empty_label.present? }
  end

  def switch_to_tab(tab)
    case tab
    when :invite
      user_invite_tab.when_present.click
    wait_until_invite_loaded
    when :list
      user_list_tab.when_present.click
      wait_until_list_loaded
    else
      raise "#{@tab} is unsupported yet"
    end
  end

  def invite_user user_email, message=nil
    invite_user_textarea.when_present.click
    @browser.send_keys user_email
    @browser.send_keys :enter
    @browser.wait_until{ single_users.size > 0 }
    if message
      invite_message_textarea.when_present.set message
      preview_email_btn.when_present.click
      @browser.wait_until{ preview_email_text.present? }
      @browser.wait_until{ preview_email_text.text.include? message }
      @browser.wait_until{ preview_email_close.present? && !preview_email_close.disabled? }
      preview_email_close.click
      @browser.wait_until{ !preview_email_text.present? }
      sleep 2
    end
    send_invite_btn.when_present.click
    @browser.wait_until { toast_success_message.present? }
    @browser.wait_until { !toast_success_message.present? }
    switch_to_tab :list
    user_row = search_user user_email
  end

  def invite_users user_emails
    invite_user_textarea.when_present.click
    for i in 0..user_emails.size-1
      @browser.send_keys user_emails[i]
      @browser.send_keys :space
      @browser.wait_until{ single_users.size == i+1 }
    end
    send_invite_btn.when_present.click
    @browser.wait_until { toast_success_message.present? }
    @browser.wait_until { !toast_success_message.present? }
  end

  def user_row_at_text(text)
    @browser.div(:class => "user-list-item", :text => /#{text}/)
  end  

  def search_user user, visible_expected=true, timeout=2*60
    if(user.size > 20)
      user = user[0...-12]
    end

    if visible_expected.nil?
      user_search_box.when_present.set user
      sleep 2
      @browser.wait_until{ user_row_at_text(user).present? || user_list_empty_label.present? }
    else
      start_time = Time.now
      loop do
        break if Time.now - start_time > timeout
        user_search_box.when_present.set user
        sleep 2
        @browser.wait_until{ user_row_at_text(user).present? || user_list_empty_label.present? }

        if visible_expected && user_list_empty_label.present?
          sleep 5
        elsif !visible_expected && user_row_at_text(user).present?
          sleep 5
        else
          break
        end  
      end 
    end  

    user_row_at_text(user)
    # user_search_box.when_present.set user
    # sleep 2
    # @browser.wait_until{ user_row_at_text(user).present? || user_list_empty_label.present? }
    # if user_list_empty_label.present?
    #   nil
    # else
    #   user_row
    # end
  end

  def filter option
    filter_btn.when_present.click
    case option
    when :all
      filter_all_btn.when_present.click
      wait_until_list_loaded
    when :active
      filter_active_btn.when_present.click
      wait_until_list_loaded
      users = @browser.divs(:class => "user-list-item", :text => /Active/)
      @browser.wait_until{ users.size == user_rows.size }
    when :pending
      filter_pending_btn.when_present.click
      wait_until_list_loaded
      users = @browser.divs(:class => "user-list-item", :text => /Pending/)
      @browser.wait_until{ users.size == user_rows.size }
    when :banned
      filter_banned_btn.when_present.click
      wait_until_list_loaded
      users = @browser.divs(:class => "user-list-item", :text => /Banned/)
      @browser.wait_until{ users.size == user_rows.size }
    else
      raise "#{@option} filter is unsupported yet"
    end    
  end

  def do_action option, user=nil
    user_row = nil
    if user
      user_row = search_user user
    else
      user_row = user_rows[0]
    end
    user_row.button.when_present.click
    case option
    when :view_profile
      user_row.link(:text => /View Profile/).when_present.click
    when :reset_password
      user_row.link(:text => /Send Password Reset/).when_present.click
    when :ban
      user_row.link(:text => "Ban").when_present.click
    when :remove_ban
      user_row.link(:text => "Remove Ban").when_present.click
    when :delete
      user_row.link(:text => /Delete/).when_present.click
    else
      raise "#{@option} operation is unsupported yet"
    end
    user_row
  end

  def view_profile user=nil
    user_row = do_action :view_profile, user
    profile_url = user_row.link(:class => "user-item-name").href
    user_full_name = user_row.divs(:class => /col/)[2].text
    @browser.window(:url => /#{profile_url}/).when_present.use do
      @browser.wait_until { @profile_page.profile_user_name.present? }
      @browser.wait_until { @profile_page.profile_user_name.text == user_full_name }
      @browser.window.close
    end
  end

  def delete_user user=nil
    user_row = do_action :delete, user
    @browser.wait_until { delete_modal.present? }
    delete_user_btn.when_present.click
    @browser.wait_until { toast_success_message.present? }    
  end

  def reset_password user=nil
    user_row = do_action :reset_password, user
    @browser.wait_until { reset_modal.present? }
    reset_btn.when_present.click
    @browser.wait_until { toast_success_message.present? }    
  end

  def ban_user user=nil, msg=nil
    user_row = do_action :ban, user
    @browser.wait_until { ban_modal.present? }
    if msg
      sleep 1
      ban_msg_input.when_present.set msg
    end
    ban_user_btn.when_present.click
    sleep 1
    @browser.wait_until{ user_row.text.include? "Banned" }
    user_row.span(:class => "more-details").when_present.click
    msg_div = user_row.div(:class => "ban-message-row")
    @browser.wait_until{ msg_div.present? }
    if msg
      @browser.wait_until{ msg_div.text.include? msg }
    end
  end

  def remove_ban_user user=nil
    user_row = do_action :remove_ban, user
    @browser.wait_until{ user_row.text.include? "Active" }
  end

  def multiple_selection users=nil
    if users
      for user in users
        user_row = search_user user
        user_row.div(:class => "customize-checkbox").when_present.click
      end
    else
        user_rows[0].div(:class => "customize-checkbox").when_present.click
        user_rows[1].div(:class => "customize-checkbox").when_present.click
    end
    @browser.wait_until{ ban_btn.present? }
    @browser.wait_until{ delete_btn.present? }
    @browser.wait_until{ select_count.present? }
    @browser.wait_until{ select_count.text.include? "2"}
  end

  def ban_users users=nil, msg=nil
    multiple_selection users
    ban_btn.when_present.click
    if msg
      sleep 1
      ban_msg_input.when_present.set msg
    end
    ban_user_btn.when_present.click
    sleep 3
    filter :banned
    for user in users
        user_row = search_user user
        @browser.wait_until{ user_row.text.include? "Banned" }
        user_row.span(:class => "more-details").when_present.click
        msg_div = user_row.div(:class => "ban-message-row")
        @browser.wait_until{ msg_div.present? }
        if msg
          @browser.wait_until{ msg_div.text.include? msg }
        end
    end
  end

  def remove_ban_users users=nil
    multiple_selection users
    ban_btn.when_present.click
    sleep 3
    filter :active
    for user in users
        user_row = search_user user
        @browser.wait_until{ user_row.text.include? "Active" }
    end
  end

  def delete_users users=nil
    multiple_selection users
    delete_btn.when_present.click
    sleep 1
    delete_user_btn.when_present.click
    @browser.wait_until { toast_success_message.present? }
    @browser.wait_until { !toast_success_message.present? }
  end

  def pagination_to option
    pre_first_user_info = user_rows[0].text
    case option
    when :previous
      pre_btn.when_present.click
    when :next
      next_btn.when_present.click
    when :first
      first_btn.when_present.click
    when :last
      last_btn.when_present.click
    else
      @browser.link(:class => "pagination-link", :text => /#{option}/).when_present.click
    end
    wait_until_list_loaded
    @browser.wait_until{ user_rows[0].present? }
    after_first_user_info = user_rows[0].text
    @browser.wait_until{ pre_first_user_info != after_first_user_info }
  end

  def ensure_remove_banned_user(user)
    user_row = search_user user
    user_row.button.when_present.click
    @browser.wait_until { user_row.link(:text => /Delete/).present? }
    if user_row.link(:text => /Remove Ban/).present?
      user_row.link(:text => /Remove Ban/).click
    end
  end

end
