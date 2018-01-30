require 'pages/community/admin'
require 'pages/community/home'
require 'pages/community/login'
require 'pages/community/admin_topics'
require 'pages/community/admin_moderation'
require 'pages/community/layout'
require 'pages/community/topicdetail'
require 'pages/community/conversationdetail'
require 'actions/hybris/api'
require 'watir_config'
#require 'pages/base'

class Pages::Community::AdminPermissions < Pages::Community::Admin

  def initialize(config, options = {})
    super(config)
    # @url = config.base_url + "/n/#{config.slug}/home"
    @url = config.base_url + "/admin/#{@config.slug}/permission"
  end

  def start!(user)
    # login starting from Home page
    @home_page = Pages::Community::Home.new(@config)
    @home_page.start!(user)

    navigate_in
  end
  permission                                { link(:class => "ember-view", :text => "Permissions") }
  permission_link                           { link(:href => "/admin/#{@@slug}/permission") }
  permission_card                           { div(:class => "member-card-container container-fluid").div(:class => "member-card-internal") }
  
  permission_card_netmod                    { div(:id => "network-moderators").div(:class => "member-card-container container-fluid").div(:class => "member-card-internal") }
  permission_card_topadmin                  { div(:id => "topic-administrators").div(:class => "member-card-container container-fluid").div(:class => "member-card-internal") }
  permission_card_topmod                    { div(:id => "topic-moderators").div(:class => "member-card-container container-fluid").div(:class => "member-card-internal") }
  #netadmin_id                               { div(:id => "network-administrators") }
  permission_netadmin_tab                   { link(:href => "#network-permission") }
  permission_page                           { div(:class => "member-card-internal") }
  blogger_page                              { div(:id => "network-bloggers").div(:class => "member-card-container container-fluid") }
  netadmin_add                              { div(:id => "network-administrators").div(:class => "row").div(:class => "col-sm-2").input(:id => "addMember") }
  addmember_modal                           { div(:class => "modal-body") }
  netadmin_textfield                        { text_field(:class => "form-control ember-view ember-text-field") }
  netadmin_add_button                       { div(:class => "modal-content").div(:class => "modal-footer").button(:class => "btn btn-primary", :text => /Add/) }

  netmod_tab                                { link(:href => "#network-moderators") }
  netmod_id                                 { div(:id => "network-moderators") }
  netmod_tab_page                           { div(:class => "member-card-internal") }
  netmod_member_card                        { div(:id => "network-moderators").div(:class => "member-card-container container-fluid") }
  netmod_add                                { div(:id => "network-moderators").div(:class => "row").div(:class => "col-sm-2").input(:id => "addMember") }
  netmod_textfield                          { div(:id => "addNetworkModeratorModal").text_field(:class => /ember-text-field/) }
  netmod_add_button                         { div(:id => "addNetworkModeratorModal").button(:class => "btn btn-primary", :text => /Add/) }
 
  topic_permission                          { link(:href => "#topic-permission") }                  
    #@a_watir_topic_select = @browser.select_list(:class => "ember-view ember-select form-control accessible-topic").select("A Watir Topic")
  select_topic                              { select_list(:class => "ember-view ember-select form-control accessible-topic") } #.select("A Watir Topic")
  topicadmin_member_card                    { div(:id => "topic-administrators").div(:class => "member-card-container container-fluid") }
  topicadmin_add                            { div(:id => "topic-administrators").div(:class => "row").div(:class => "col-sm-2").input(:id => "addMember") }
  topicadmin_modal                          { div(:id => "topic-administrators").div(:class => "modal-body") }
  topicadmin_field                          { div(:id => "addTopicMemberModal").text_field(:class => /ember-text-field/) }
  topicadmin_add_button                     { div(:id => "addTopicMemberModal").button(:class => "btn btn-primary", :text => /Add/) }
  topicadmin_link                           { div(:id => "topic-administrators").link(:text => /#{@config.users[:regular_user1]}/) }
  topicadmin_page                           { div(:id => "topic-administrators") }
    
  topicmod_link                             { link(:href => "#topic-moderators") }
  topicmod_membercard                       { div(:id => "topic-moderators").div(:class => "member-card-container container-fluid") }
  topicmod_add                              { div(:id => "topic-moderators").div(:class => "row").div(:class => "col-sm-2").input(:id => "addMember") }
  topicmod_add_button                       { div(:id => "addTopicModeratorModal").button(:class => "btn btn-primary", :text => /Add/) }
  topicmod_modal                            { div(:id => "topic-moderators").div(:class => "modal-body") }
  topicmod_field                            { div(:id => "addTopicModeratorModal").text_field(:class => /ember-text-field/) }
  
  
  blogger_member_card                       { div(:id => "network-bloggers").div(:class => "member-card-container container-fluid") }
  blogger_add                               { div(:id => "network-bloggers").div(:class => "row").div(:class => "col-sm-2").input(:id => "addMember") }
  blogger_modal                             { div(:id => "network-bloggers").div(:class => "modal-body") }
  blogger_field                             { div(:id => "addNetworkBloggerModal").text_field(:class => /ember-text-field/) }
  blogger_add_button                        { div(:id => "addNetworkBloggerModal").button(:class => "btn btn-primary", :text => /Add/) }
  blogger_link                              { div(:id => "network-bloggers").link(:text => /#{@config.users[:regular_user4]}/) }
  blogger_tab                               { link(:href => "#network-bloggers") }
  blogger_textfield                         { div(:id => "addNetworkBloggerModal").text_field(:class => /ember-text-field/) }

  def navigate_in
    super

    navigate_in_from_admin_page
  end

  def navigate_in_from_admin_page(wait_tab=MemberListTab.new(@browser, :net_admin))
    accept_policy_warning

    switch_to_sidebar_item(:permissions)

    wait_tab.wait_until_loaded

    wait_tab
  end

  def switch_to_tab(tab)
    case tab
    when :net_admin, :net_mod, :net_blog # Community->Administartors, Moderators, Bloggers
      permission_netadmin_tab.when_present.click
      MemberListTab.new(@browser, :net_admin).wait_until_loaded
    when :topic_admin, :topic_mod, :topic_blog # Topic->Administartors, Moderators, Bloggers
      topic_permission.when_present.click
      MemberListTab.new(@browser, :topic_admin).wait_until_loaded
    else
      raise "#{@tab} is unsupported yet"
    end 

    # need to click tab header if not the default tab Community->Administrators and Topic->Administrators
    tab_header_link(tab).when_present.click unless tab == :net_admin || tab == :topic_admin

    # wait until the tab content is loaded completely
    memberlist_tab = MemberListTab.new(@browser, tab)

    memberlist_tab.wait_until_loaded

    memberlist_tab
  end

  def tab_header_link(tab)
    href = case tab
    when :net_admin # Community->Administartors
      "#network-administrators"
    when :net_mod # Community->Moderators
      "#network-moderators"
    when :net_blog # Community->Bloggers
      "#network-bloggers"
    when :topic_admin # Topic->Administartors
      "#topic-administrators"
    when :topic_mod # Topic->Moderators
      "#topic-moderators"
    when :topic_blog # Topic->Bloggers
      "#topic-bloggers"
    else
      raise "#{@tab} is unsupported yet"
    end

    @browser.link(:href => href)
  end

  def promote_user_role(user, role, topic=nil, network_admin="network_admin")
    @about_page = Pages::Community::About.new(@config)
    @login_page = Pages::Community::Login.new(@config)
    @admin_mod_page = Pages::Community::AdminModeration.new(@config)
    
    # login with admin user if no user login
    if !@login_page.user_dropdown.present?
     about_login(network_admin, "logged")
     @about_page.user_dropdown.click
     @browser.wait_until { @about_page.user_dropdown_menu.present? }
     assert @about_page.admin_link.present?
    end

    # go to Admin->Moderation page and set threshod to low
    @admin_mod_page.navigate_in
    @admin_mod_page.set_moderation_threshold("1", :low)

    # go to Admin->Permissions page
    netadmin_tab = navigate_in_from_admin_page

    # switch to the corresponding tab for the role 
    tab = switch_to_tab(role)

    # add the specific member
    tab.add_member(user, topic)

    # logout
    @login_page.logout!
  end

  def remove_user_role(user, role, topic=nil)
    @login_page = Pages::Community::Login.new(@config)

    # login with admin user
    about_login("network_admin", "logged")

    # go to Admin->Permissions page
    navigate_in

    # switch to the corresponding tab for the role 
    tab = switch_to_tab(role)

    # search out the specified topic when in topic permission
    tab.search_and_then_select_a_topic(topic) unless topic.nil?

    # delete the member
    tab.delete_member(user)

    # logout
    @login_page.logout!

    # sometimes, Selenium::WebDriver::Error::UnhandledAlertError happen when login right after the logout above
    # since this error can't be reproduced manually, add a sleep here to workaround this
    sleep 2
  end

  class MemberListTab
    attr_reader :css

    def initialize(browser, tab)
      @browser = browser
      @css = tab_css(tab)
    end
    
    def tab_css(tab)
      case tab
      # Community->Administartors
      # Community->Moderators
      # Community->Bloggers 
      when :net_admin, :net_mod, :net_blog 
        "#network-administrators"
      # Topic->Administartors
      # Topic->Moderators 
      # Topic->Bloggers
      when :topic_admin, :topic_mod, :topic_blog 
        "#topic-administrators"
      else
        raise "#{@tab} is unsupported yet"
      end  
    end  

    def member_at_index_css(index)
      @css + " .member-card-container > .member-card:nth-of-type(#{index+1}) .member-card-internal"
    end

    def member_at_index(index)
      Member.new(@browser, member_at_index_css(index))
    end
      
    def no_members_label
      @browser.div(:css => @css + " .member-card-container").p(:text => /No members/)
    end

    def topic_select_info_label
      @browser.div(:css => @css + " .member-card-container").p(:text => /Please select/)
    end  

    def member_present?(user)
      @browser.div(:css => @css).div(:class => "member-card-internal", :text => /#{user.username}/).present?
    end

    def delete_member(user)
      @browser.wait_until { @browser.div(:css => @css).div(:class => "member-card-internal", :text => /#{user.username}/).div(:css => ".delete-member-icon").present? }
      @browser.div(:css => @css).div(:class => "member-card-internal", :text => /#{user.username}/).div(:css => ".delete-member-icon").when_present.click

      @browser.wait_until { !spinner_present? }
      @browser.wait_until { !member_present?(user)}
    end

    def add_member(user, topic=nil)
      # select the expected topic when in topic permission
      search_and_then_select_a_topic(topic) unless topic.nil?

      # delete member if exists
      delete_member(user) if member_present?(user)

      @browser.execute_script('arguments[0].scrollIntoView();', add_member_btn)
      @browser.execute_script("window.scrollBy(0,-200)") # in case overlapped by top navigator bar
      # add member
      @browser.wait_until { add_member_btn.present? && !add_member_btn.disabled? }
      add_member_btn.when_present.click

      add_member_modal_dlg = AddMemberModalDialog.new(@browser, @css + " .modal-dialog")

      @browser.wait_until { add_member_modal_dlg.present? }
      add_member_modal_dlg.add_member(user)
      @browser.wait_until { !spinner_present? }
      @browser.wait_until { member_present?(user) }
    end

    def add_member_btn
      @browser.input(:css => @css + " #addMember")
    end 

    def present?
      @browser.div(:css => @css).present?
    end

    def spinner_present?
      @browser.div(:css => @css + " .fa-spinner").present?
    end

    # def wait_until_loaded(member_expected=false)
    #   @browser.wait_until { present? && !spinner_present?}
    #   @browser.wait_until { member_at_index(0).present? } if member_expected
    # end

    def wait_until_loaded
      @browser.wait_until { present? }
      @browser.wait_until { !spinner_present? && (topic_select_info_label.present? || no_members_label.present? || member_at_index(0).present?) }
    end 

    def topic_search_bootstrap_css
      @css + " .bootstrap.search"
    end

    def topic_search_bootstrap_input
      @browser.text_field(:css => topic_search_bootstrap_css + " input.keyword")
    end

    def first_topic_in_search_bootstrap_dropdown(topic)
      @browser.li(:css => topic_search_bootstrap_css + " .dropdown-menu li:nth-of-type(1)")
    end
   
    def search_and_then_select_a_topic(topic)
      topic_search_bootstrap_input.when_present.set(topic)

      first_topic_in_search_bootstrap_dropdown(topic).when_present.click

      @browser.wait_until($t) { topic_search_bootstrap_input.value.include?(topic) }
      @browser.wait_until($t) { !first_topic_in_search_bootstrap_dropdown(topic).present? }

      # wait until member list loaded completely
      wait_until_loaded
    end 

    class Member
      attr_reader :css

      def initialize(browser, css)
        @browser = browser
        @css = css
      end
      
      def present?
        @browser.div(:css => @css).present?
      end

      def delete
        @browser.div(:css => @css + " .delete-member-icon").when_present.click
        @browser.wait_until { !spinner_present? }
        @browser.wait_until { !present? }
      end  
    end

    class AddMemberModalDialog
      def initialize(browser, css)
        @browser = browser
        @css = css
      end  

      def present?
        @browser.div(:css => @css).present?
      end

      def add_member(user)
        sleep 1
        set_member(user.username)

        @browser.wait_until { @browser.div(:css => @css + " .member-autocomplete .member-field-value.meta").when_present.text.downcase == user.email.downcase }
        
        select_member_by_email(user.email)
        add_btn.when_present.click
        @browser.wait_until { !present? }
      end  

      def set_member(username)
        text_field.when_present.set(username)
      end

      def select_member_by_email(email)
        rows = @browser.lis(:css => @css + " .member-autocomplete li")
        row_count = rows.size

        (1..row_count).each do |i|
          row_css = @css + " .member-autocomplete li:nth-of-type(#{i})"
          email_css = row_css + " .member-field-value.meta"
          if @browser.div(:css => email_css).text.downcase == email.downcase
            @browser.li(:css => row_css).click
            @browser.wait_until { @browser.li(:css => row_css).class_name.include?("focus-css") }
            break
          end
        end
      end  
      
      def add_btn
        @browser.button(:css => @css + " .modal-footer .btn-primary[type=submit]")
      end

      def text_field
        @browser.text_field(:css => @css + " .modal-body .ember-text-field")
      end 
    end  
  end  
end
