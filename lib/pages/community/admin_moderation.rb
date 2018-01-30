require 'pages/community/admin'
require 'pages/community/admin_permissions'
require 'pages/community/home'
require 'pages/community/conversationdetail'
require 'pages/community/topicdetail'
require 'pages/community/topic_list'
require 'minitest/assertions'

class Pages::Community::AdminModeration < Pages::Community::Admin

  def initialize(config, options = {})
    super(config)
    @url = config.base_url + "/admin/#{@config.slug}/moderation?tabName=pendingApprovalPosts"

    @topiclist_page = Pages::Community::TopicList.new(@config)
    @convdetail_page = Pages::Community::ConversationDetail.new(@config)
  end

  def start!(user)
    # login starting from Home page
    @home_page = Pages::Community::Home.new(@config)
    @home_page.start!(user)

    navigate_in
  end

  mod                                 { link(:class => "ember-view", :text => "Moderation") }
  mod_settings_tab_link               { div(:class => "moderation").link(:class => "ember-view", :text => "Settings") }
  mod_settings_threshold_field        { text_field(:css => "#settings .moderation-threshold-form input")}
  mod_settings_save_btn               { button(:class => "btn btn-primary", :value => /Save/) }

  mod_settings_low_level_mod_radio    { radio(:value => "community_moderation_post_shown") }
  mod_settings_medium_level_mod_radio { radio(:value => "pending_admin_moderation_post_shown") }
  mod_settings_high_level_mod_radio   { radio(:value => "pending_admin_moderation_post_hidden") }

  mod_flagged_tab_link                { link(:class => "ember-view", :text => /Flagged/) }
  

  flagged_post                        { div(:id => "flagged-posts").div(:class => "flagged-posts clearfix", :index => 0).div(:class => "media-body").link(:class => "ember-view") }


  empty_admin_mod_post                { div(:class => "empty-container-text") }
  # flagged_post_tab                    { div(:class => "flagged-posts clearfix") }
  flagged_post_tab                    { div(:id => "flagged-posts") }
  mod_posts                           { div(:class => "ember-view post-list clearfix")}
  mod_post_list                       { div(:class => "ember-view post-list clearfix").divs(:class => "ember-view post")}
  mod_flagged_post                    { div(:class => "ember-view post-list clearfix").div(:class => "ember-view") }
  mod_flagged_post_title_link         { div(:class => "ember-view post-list clearfix").div(:class => "ember-view").link(:class => "ember-view") }
  flagged_link                        { div(:class => "media-body").div(:class => "media-heading").link }
  # flag_modal                          { div(:id => "report-post-modal", :class => "modal fade  in") }
  flag_modal                          { div(:css => "#report-post-modal.modal.fade.in .modal-dialog") }

  mod_pending_tab_link                { link(:class => "ember-view", :text => /Pending Approval/) }
  pending_approval_tab                { div(:id => "pending-approval-posts") }
  mod_approve_button                  { div(:class => "ember-view moderation-actions").button(:class => "mod-button approve")}
  mod_reject_button                   { div(:class => "ember-view moderation-actions").button(:class => "mod-button reject")}
  mod_dialog                          { div(:class => "modal fade")}
  mod_dialog_button                   { div(:class => "modal-dialog").button(:class => "btn btn-primary")}

  # mod_perm_removed_tab                { link(:text => "Permanently Removed") }
  mod_perm_removed_tab_link           { ul(:class => "nav nav-tabs").link(:text => /Permanently Removed/) }
    
  conv_list                           { link(:class => "media-heading ember-view media-heading") }
  reply_depth0                        { div(:class => /depth-0/) }
  reply_perm_remove                   { link(:text => "Permanently Remove") }
  reply_perm_remove_confirm_button    { div(:class => "modal in").button(:class => "btn btn-primary", :value => "Remove") }
  reply_reinstate                     { link(:text => "Reinstate this content") }
  reply_flag                          { link(:text => /Flag as inappropriate/) }
  flag_icon                           { span(:class => "icon-flag pull-right") }

  flag_reason_text_input              { div(:class => "modal fade  in").textarea(:class => "ember-view ember-text-area") }
  flag_modal_submit                   { div(:class => "modal fade  in").button(:class => "btn btn-primary", :text => "Submit") }

  profanity_blocker_tab_link          { ul(:class => "nav nav-tabs").link(:text => /Profanity Blocker/) }
  # mod_profanity_tab                   { link(:text => "Profanity Blocker") }
  profanity_blocker_tab_page          { div(:id => "profanity-blocker") }
  profanity_disable_button            { button(:id => "profanity_disable_btn") }
  profanity_import_button             { link(:class => "btn btn-default profanity-import-btn", :text=> "Import CSV") }
  profanity_download_button           { link(:class => "btn btn-default", :text => "Download CSV") }
  enable_profanity_button             { button(:id => "profanity_enable_btn") }

  # general elements across all tabs
  mod_tab_posts_block                     { div(:css => ".post-list .posts") }
  loading_block                       { div(:css => ".loading-block") }

  def navigate_in
    super

    switch_to_sidebar_item(:moderation)
    @browser.wait_until($t) { sidebar_item(:moderation).attribute_value("class").include?("active") }

    @browser.wait_until($t) { mod_settings_tab_link.present? }
    @browser.wait_until($t) { mod_pending_tab_link.present? }
    @browser.wait_until($t) { mod_flagged_tab_link.present? }
    @browser.wait_until($t) { mod_perm_removed_tab_link.present? }

    accept_policy_warning
  end

  def navigate_to_profanity_blocker    
    # Admin->Profanity Blocker appears in accordion sidebar or appears as one tab in Admin->Moderation
    switch_to_sidebar_item(:profanity_blocker)
      
    @browser.wait_until($t) { profanity_blocker_tab_page.present? }
  end  

  def switch_to_tab(tab)
    case tab
      when :settings
        mod_settings_tab_link.when_present.click
        @browser.wait_until($t) { mod_settings_save_btn.present? }
        @browser.wait_until($t) { mod_settings_threshold_field.present? }
      when :pending_approval
        mod_pending_tab_link.when_present.click
        @browser.wait_until($t) { mod_tab_posts_block.present? }
        @browser.wait_until($t) { !loading_block.present? }
      when :flagged
        mod_flagged_tab_link.when_present.click

        @browser.refresh # have to refresh because of a bug EN-2224
        @browser.wait_until($t) { mod_tab_posts_block.present? }
        @browser.wait_until($t) { !loading_block.present? }
      when :perm_removed
        mod_perm_removed_tab_link.click

        @browser.refresh
        @browser.wait_until($t) { mod_tab_posts_block.present? }
        @browser.wait_until($t) { !loading_block.present? }
      when :profanity_blocker
        profanity_blocker_tab_link.when_present.click

        @browser.wait_until($t) { profanity_blocker_tab_page.present? }
    end
  end

  # def mod_flag_threshold(network, networkslug)
  #   @browser.goto @config.base_url+ "/admin/#{@config.slug}/topics"
  #   #@admin_perm_page = Pages::Community::Admin.new(@config)
  #   #@browser.wait_until { @admin_perm_page.admin_page_left_nav.present? }
  #   @admin_perm_page = Pages::Community::AdminPermissions.new(@config)
  #   @browser.wait_until { @admin_perm_page.admin_page_left_nav.present? || @admin_perm_page.new_admin_page_left_nav.present?}
  #   assert @admin_perm_page.admin_page_left_nav.present? || @admin_perm_page.new_admin_page_left_nav.present?
  #   if @admin_perm_page.new_admin_page_left_nav.present?
  #    @browser.goto @config.base_url+ "/admin/#{@config.slug}/moderation?tabName=pendingApprovalPosts" 
  #   else
  #    mod.when_present.click
  #   end
  #   @browser.wait_until { pending_approval_tab.present? }
  #   assert pending_approval_tab.present? 
  #   accept_policy_warning
  #   mod_settings_tab_link.when_present.click

  #   mod_settings_threshold_field.when_present.clear
  #   mod_settings_threshold_field.when_present.set "1"
  #   mod_settings_low_level_mod_radio.when_present.set 
  #   mod_settings_save_btn.when_present.click
  #   @browser.wait_until { mod_settings_save_success_msg.present? }
  #   assert mod_settings_save_success_msg.present?
  # end 

  def set_moderation_threshold(threshold, level)
    switch_to_tab(:settings)
    mod_settings_threshold_field.when_present.clear
    mod_settings_threshold_field.when_present.set threshold

    case level
    when :low
      mod_settings_low_level_mod_radio.when_present.set
    when :medium
      mod_settings_medium_level_mod_radio.when_present.set
    when :high
      mod_settings_high_level_mod_radio.when_present.set
    end 

    accept_policy_warning
    mod_settings_save_btn.when_present.click
    @browser.wait_until { toast_success_message.present? }
    @browser.wait_until { !toast_message.present? }
  end  

  def flag_a_post
    set_moderation_threshold("1", :low)

    # go to About page and login with normal user
    about_login("regular_user1", "logged")

    # go to a specific topic
    topic_name = "A Watir Topic"
    @topicdetail_page = @topiclist_page.go_to_topic(topic_name)

    # create a question in the specific topic "A Watir Topic"
    root_post = "Q created by Watir for flag - #{get_timestamp}"
    descrip = "Watir test description - #{get_timestamp}"
    flag_msg = "This post has been flagged as inappropriate; it has been temporarily removed and brought to the attention of the site moderators."
    @topicdetail_page.create_conversation(type: :question,
                                          title: root_post,
                                          details: [{type: :text, content: descrip}])
    
    accept_policy_warning
    # create an answer for the question
    answer_text = "Answered by Watir - #{get_timestamp}"
    @convdetail_page.reply_box.when_present.focus
    @browser.wait_until { @convdetail_page.reply_submit.present? }
    @convdetail_page.reply_box.when_present.set answer_text
    #@browser.execute_script('$("div.group text-right").blur()')
    @convdetail_page.reply_submit.when_present.click
  
    @browser.wait_until { @convdetail_page.conv_reply.present?} #text =~ /#{answer_text}/ }
    conv_url = @browser.url

    # click dropdown menu for the answer
    @convdetail_page.reply_dropdown_toggle.when_present.click
    
    @browser.wait_until { @convdetail_page.reply_menu.present? }
    @login_page = Pages::Community::Login.new(@config)
    if ( !reply_flag.present? )
      #puts "User is not a moderator....Signing in the moderator"
      @login_page.logout!
      about_login("network_admin", "logged")
      @topicdetail_page = Pages::Community::TopicDetail.new(@config)
      @topicdetail_page.topic_detail("A Watir Topic")
      #choose_post_type("question")
      #sort_post_by_newest
      #@conv_list.when_present.click
      @browser.goto conv_url
      @convdetail_page.accept_policy_warning
      @browser.wait_until { reply_depth0.present? }
      assert @convdetail_page.convdetail.present?
      #sleep 1
      @convdetail_page.reply_dropdown_toggle.when_present.click
      @browser.wait_until { @convdetail_page.reply_menu.present? }
    end

    if (reply_reinstate.present? )
      puts "The post appears to be already flagged...."
    end

    # click "Flag as inappropriate" menu item for the answer reply
    flag_reason_text = "Set by Watir - #{get_timestamp}"
    reply_flag.when_present.click
    #byebug
    @browser.wait_until { flag_modal.present? }
    flag_reason_text_input.set flag_reason_text
    flag_modal_submit.click

    @browser.wait_until { !flag_modal_submit.present? }
    @browser.wait_until { !flag_modal.present? }
    # TODO: Behavior changed. Need change watir cases
    # @browser.wait_until { flag_icon.present? }
    sleep 1
    # assert flag_icon.present?

    # logout
    @login_page.logout!
    
    #admin-moderator checking the post is flagged
    about_login("network_admin", "logged")

    navigate_in
    switch_to_tab(:flagged)

    # verify the first post is the one just flagged
    flag_text = mod_flagged_post_title_link.text
    assert_match flag_text, root_post

    # view the flagged post
    flagged_link.when_present.click
    sleep 2
    @browser.wait_until { @convdetail_page.conv_reply_view.present? }
    @browser.wait_until { @convdetail_page.conv_reply.present? }
    assert_match @convdetail_page.conv_reply.text, answer_text
    @convdetail_page.reply_dropdown_toggle.when_present.click
    @browser.wait_until { @convdetail_page.reply_mod_menu.present? }
    # verify "Reinstate this content" menu item is visible
    assert reply_reinstate.present?
    @login_page.logout!
  end

  def reinstate_a_post
    flag_a_post
  end

  def check_permanently_removed_post_tab
    # login by a normal user regular_user1
    about_login("regular_user1", "logged")
    accept_policy_warning

    @topicdetail_page = Pages::Community::TopicDetail.new(@config)
    @topicdetail_page.topic_detail("A Watir Topic")
    @topicdetail_page.choose_post_type("question")
    @convdetail_page = Pages::Community::ConversationDetail.new(@config)
    @convdetail_page.conversation_detail("question")
    root_post = @convdetail_page.root_post_title.text
    @browser.wait_until { @convdetail_page.answer_level1.present? || @convdetail_page.depth0_q.present? }
    @browser.wait_until { !@convdetail_page.spinner.present? }
    if @convdetail_page.conv_reply.present?
     @topicdetail_page.sort_post_by_newest
     @browser.wait_until { @convdetail_page.conv_reply.present?}
    end
    
    flag_msg = "This post has been flagged as inappropriate; it has been temporarily removed and brought to the attention of the site moderators."
    
    # create an answer
    answer_text = "Answered by Watir - #{get_timestamp}"
    @convdetail_page.reply_box.when_present.focus
    @browser.wait_until { @convdetail_page.reply_submit.present? }
    @convdetail_page.reply_box.when_present.set answer_text
    @convdetail_page.reply_submit.when_present.click
    @browser.wait_until { !@convdetail_page.spinner.present? }
    @browser.wait_until { !@convdetail_page.reply_submit.present? }
    
    @browser.wait_until { @convdetail_page.conv_reply.present?}
    #@browser.wait_until($t) { @conv_reply.text =~ /#{answer_text}/ }
    #text = @conv_reply.text #text =~ /#{answer_text}/ } 
    #assert_match text, answer_text
    conv_link = @browser.url

    # login by admin
    about_login("network_admin", "logged")
    accept_policy_warning
    @browser.goto conv_link
    @browser.wait_until { @convdetail_page.conv_reply.present? }
    sleep 1
    @topicdetail_page.sort_post_by_newest
    @browser.wait_until{ @convdetail_page.conv_reply_input.present?}

    # Flag as inappropriate the answer just created
    @convdetail_page.reply_dropdown_toggle.when_present.click
    
    flag_reason_text = "Set by Watir for permanently removed test - #{get_timestamp}"
    
    reply_flag.when_present.click
    @browser.wait_until { flag_modal.present? }
    flag_reason_text_input.set flag_reason_text
    flag_modal_submit.click
    @browser.wait_until { !flag_modal.present? }
    @browser.wait_until { !flag_modal_submit.present? }
    # @browser.wait_until { flag_icon.present? }
    # assert flag_icon.present?
    sleep 1

    # Permanently remove the answer just created
    @convdetail_page.reply_dropdown_toggle.click
    @browser.wait_until { @convdetail_page.reply_mod_menu.present? }
    reply_perm_remove.click
    @browser.wait_until { reply_perm_remove_confirm_button.present? }
    reply_perm_remove_confirm_button.click
    @browser.wait_until { !@convdetail_page.reply_dropdown_toggle.present? }
    
    navigate_in
    switch_to_tab(:perm_removed)
   
    # verify the first post in Permanently Removed tab is the one just Permanently Removed
    flag_text = mod_flagged_post_title_link.text
    assert_match flag_text, root_post
    #assert_match text, answer_text
  end

  def check_profanity_blocker_tab
    # switch_to_tab(:profanity_blocker)
    navigate_to_profanity_blocker

    @browser.wait_until { enable_profanity_button.present? || profanity_disable_button.present? }

    if !enable_profanity_button.present? 
     @browser.wait_until { profanity_blocker_tab_page.present?}
     @browser.wait_until { profanity_disable_button.present? }
     @browser.wait_until { profanity_import_button.present? }
     @browser.wait_until { profanity_download_button.present? }
    else
     @browser.wait_until { enable_profanity_button.present? }
    end
  end

  def post_exist_in_moderation_subtab?(post_title:, tab: :flagged)
    switch_to_tab(tab)
    find_post_css_by_title(post_title)
  end

  def admin_check_post_in_pending_approval
    switch_to_tab(:pending_approval)
  end

  def admin_approve_post_pending_approval(post_title)
    admin_check_post_in_pending_approval

    approve_post_by_title(post_title)
  end

  def admin_reject_post_pending_approval(post_title)
    admin_check_post_in_pending_approval

    reject_post_by_title(post_title)
  end

  def approve_post_in_flagged_tab(post_title)
    switch_to_tab(:flagged)

    approve_post_by_title(post_title)
  end 

  def reject_post_in_flagged_tab(post_title)
    switch_to_tab(:flagged)

    reject_post_by_title(post_title)
  end  
    
  def find_post_css_by_title(post_title)
    # @browser.wait_until { @browser.link(:text => /#{post_title}/).present? }
    # @browser.wait_until { !mod_post_list.find { |i| i.text.include?(post_title) }.nil? }
    return if mod_post_list.find { |i| i.text.include?(post_title) }.nil?

    mod_post_list.each_with_index do |div_item, index|
      if (div_item.text.include?(post_title))
        return ".post-list .posts .post:nth-child(#{index+1})"
      end
    end

    raise "Post #{post_title} is not available" 
  end
  
  def reject_post_by_title(post_title)
    post_css = find_post_css_by_title(post_title)
    @browser.button(:css => post_css + " .moderation-actions .reject").when_present.click

    @browser.button(:css => post_css + " .moderation-actions .modal-dialog button[type='submit']").when_present.click

    @browser.wait_until { !@browser.button(:css => post_css + " .moderation-actions .modal-dialog").present?}
  end

  def approve_post_by_title(post_title)
    post_css = find_post_css_by_title(post_title)

    @browser.button(:css => post_css + " .moderation-actions .approve").when_present.click
  end  

  def create_reply_in_post(setting_type, create_reply=true)
        # go to About page and login with normal user
    about_login("regular_user1", "logged")

    # go to a specific topic
    topic_name = "A Watir Topic"
    @topicdetail_page = @topiclist_page.go_to_topic(topic_name)

    # create a question in the specific topic "A Watir Topic"
    root_post = "Q created by Watir for flag - #{get_timestamp}"
    descrip = "Watir test description - #{get_timestamp}"
    flag_msg = "This post has been flagged as inappropriate; it has been temporarily removed and brought to the attention of the site moderators."
    @topicdetail_page.create_conversation(type: :question,
                                          title: root_post,
                                          details: [{type: :text, content: descrip}])
    
    accept_policy_warning
    answer_text = ""
    if create_reply
    # create an answer for the question
      answer_text = "Answered by Watir - #{get_timestamp}"
      @convdetail_page.reply_box.when_present.focus
      @browser.wait_until { @convdetail_page.reply_submit.present? }
      @convdetail_page.reply_box.when_present.set answer_text
      @convdetail_page.reply_submit.when_present.click
      @browser.wait_until { @convdetail_page.conv_reply.present? }
      assert_create_reply :is_root_post_owner => true, :setting_type => setting_type
    else
      assert_create_conv  :is_root_post_owner => true, :setting_type => setting_type 
    end
    return {:title => root_post, :descrip => descrip, :answer_text => answer_text, :url => @browser.url}
  end

  def assert_create_conv(is_root_post_owner: false, is_admin: false, setting_type: :low, is_reinstate: false, title: nil)
    case setting_type
    when :low
      @browser.wait_until { @convdetail_page.depth0_q.present? }
      @browser.wait_until { @convdetail_page.conv_root_post_like_link.present? && @convdetail_page.conv_root_post_follow_link.present? && @convdetail_page.conv_root_post_reply_link.present? }
      # click dropdown menu for the conversation
      if is_root_post_owner || is_admin || !is_reinstate
        @convdetail_page.root_post_feature_dropdown.when_present.click
      end
      if is_admin || is_root_post_owner
        @browser.wait_until { @convdetail_page.dropdown_edit.present? && @convdetail_page.dropdown_delete.present? }
      elsif is_admin && !is_root_post_owner
        @browser.wait_until { is_reinstate == true || @convdetail_page.dropdown_flag.present? }
        if is_admin
          @browser.wait_until { @convdetail_page.dropdown_escalate.present? && @convdetail_page.dropdown_feature.present? && @convdetail_page.dropdown_close.present? }
        end
      end
    when :medium
      @browser.wait_until { @convdetail_page.depth0_q.present? }
      @browser.wait_until { @convdetail_page.conv_root_post_like_link.present? && @convdetail_page.conv_root_post_follow_link.present? && @convdetail_page.conv_root_post_reply_link.present? }
      if is_admin || is_root_post_owner
        # click dropdown menu for the conversation
        @convdetail_page.root_post_feature_dropdown.when_present.click
        @browser.wait_until { @convdetail_page.dropdown_edit.present? && @convdetail_page.dropdown_delete.present? }
        if is_admin
          @browser.wait_until { @convdetail_page.dropdown_remove.present? && @convdetail_page.conv_moderation_alert.present? }
        end
      else
        assert !@convdetail_page.root_post_feature_dropdown.present?
      end
      @topicdetail_page = @topiclist_page.go_to_topic("A Watir Topic")
      @topicdetail_page.goto_conversation :title => title
      @browser.wait_until { @convdetail_page.depth0_q.present? }
    when :high
      @browser.wait_until { @convdetail_page.conv_moderation_alert.present? }
      assert !@convdetail_page.conv_root_post_like_link.present? && !@convdetail_page.conv_root_post_follow_link.present? && !@convdetail_page.conv_root_post_reply_link.present? 

      if is_admin || is_root_post_owner
        @browser.wait_until { @convdetail_page.depth0_q.present? }
        assert (@convdetail_page.depth0_q.style("background-color").include? "255, 252, 181")
        # click dropdown menu for the conversation
        @convdetail_page.root_post_feature_dropdown.when_present.click
        @browser.wait_until { @convdetail_page.reply_menu_delete.present? && @convdetail_page.reply_menu_edit.present? }
        if is_admin
          @browser.wait_until { @convdetail_page.reply_mod_menu.present? }
          @browser.wait_until { @convdetail_page.conv_mod_action_approve_btn.present? }
          @browser.wait_until { @convdetail_page.conv_mod_action_reject_btn.present? }
        else
          @browser.wait_until { @convdetail_page.conv_moderation_alert_for_root_owner.present? }
          assert !@convdetail_page.conv_mod_action_approve_btn.present?
          assert !@convdetail_page.conv_mod_action_reject_btn.present?
        end
      end
    end
  end

  def assert_create_reply(is_root_post_owner: false, is_admin: false, setting_type: :low, is_reinstate: false)
    case setting_type
    when :low
      @browser.wait_until { @convdetail_page.conv_reply.present? || @convdetail_page.edited_reply_content.present? }
      # click dropdown menu for the answer
      if is_root_post_owner || is_admin || !is_reinstate
        @convdetail_page.reply_dropdown_toggle.when_present.click
      end
      # like/reply can see in any sitiation
      @browser.wait_until { @convdetail_page.reply_like_link.present? }
      @browser.wait_until { @convdetail_page.reply_reply_link.present? }

      if is_admin || is_root_post_owner
        @browser.wait_until { @convdetail_page.reply_mark_best_answer.present? }
        @browser.wait_until { @convdetail_page.reply_menu_delete.present? }
        @browser.wait_until { @convdetail_page.reply_menu_edit.present? }
      elsif is_admin || !is_root_post_owner
        @browser.wait_until { is_reinstate == true || @convdetail_page.reply_flag_option.present? }
      else
      end
    when :medium
      @browser.wait_until { @convdetail_page.conv_reply.present? }
      # like/reply can see in any sitiation
      @browser.wait_until { @convdetail_page.reply_like_link.present? }
      @browser.wait_until { @convdetail_page.reply_reply_link.present? }

      if is_admin || is_root_post_owner
        # click dropdown menu for the answer
        @convdetail_page.reply_dropdown_toggle.when_present.click

        @browser.wait_until { @convdetail_page.reply_menu_delete.present? }
        @browser.wait_until { @convdetail_page.reply_menu_edit.present? }
        if is_admin
          @browser.wait_until { @convdetail_page.conv_moderation_alert.present? }
          @browser.wait_until { @convdetail_page.reply_mod_menu.present? }
        end
      else
        assert !@convdetail_page.reply_dropdown_toggle.present?
      end
    when :high
      # like/reply can't see in any sitiation
      assert !@convdetail_page.reply_like_link.present?
      assert !@convdetail_page.reply_reply_link.present?

      if is_admin || is_root_post_owner
        @browser.wait_until { @convdetail_page.conv_reply.present? }
        @browser.wait_until { @convdetail_page.conv_moderation_alert.present? }
        @browser.wait_until { @convdetail_page.reply.present? && @convdetail_page.depth0_q.present? }
        assert (@convdetail_page.reply.style("background-color").include? "255, 252, 181")
        # click dropdown menu for the answer
        @convdetail_page.reply_dropdown_toggle.when_present.click
        @browser.wait_until { @convdetail_page.reply_menu_delete.present? }
        @browser.wait_until { @convdetail_page.reply_menu_edit.present? }

        if is_admin
          @browser.wait_until { @convdetail_page.reply_mod_menu.present? }
          @browser.wait_until { @convdetail_page.conv_mod_action_approve_btn.present? }
          @browser.wait_until { @convdetail_page.conv_mod_action_reject_btn.present? }
        else
          @browser.wait_until { @convdetail_page.conv_moderation_alert_for_root_owner.present? }
          assert !@convdetail_page.conv_mod_action_approve_btn.present?
          assert !@convdetail_page.conv_mod_action_reject_btn.present?
        end
      else
        @browser.wait_until { @convdetail_page.conv_moderation_alert.present? }
      end
    end
  end

  def find_reply_by_title (title:nil, answer_text:nil, descrip:nil)
    return (find_reply_by_title_and_tabtype title, answer_text, descrip, :pending_approval) || (find_reply_by_title_and_tabtype title, answer_text, descrip, :flagged) || (find_reply_by_title_and_tabtype title, answer_text, descrip, :perm_removed)
  end

  def find_reply_by_title_and_tabtype(title, answer_text, descrip, tab_type, is_reply=true)
    navigate_in
    switch_to_tab(tab_type)
    @browser.wait_until { empty_admin_mod_post.present? || mod_tab_posts_block.div(:class => "post", :index => 0).present? }
    for index in 0...mod_tab_posts_block.divs(:class => "post").size
      if (mod_tab_posts_block.element(:css => ".post .media-heading a", :index => index).text == title)# && (mod_tab_posts_block.element(:css => "p.expand-collapse-content", :index => index).attribute_value("innerText") == answer_text)
        return (tab_type != :pending_approval || !is_reply) || (mod_tab_posts_block.element(:css => ".post .media-heading a", :index => index + 1).text == title) && (mod_tab_posts_block.element(:css => "p.expand-collapse-content", :index => index + 1).attribute_value("innerText") == descrip)
      end
    end
    return false
  end


  def flag_a_conversation (is_admin:false, setting_type: :low, refresh_after_flag: false)
    @browser.refresh
    @browser.wait_until { @convdetail_page.depth0_q.present? }
    # click dropdown menu for the answer
    @convdetail_page.root_post_feature_dropdown.when_present.click
    @convdetail_page.dropdown_flag.when_present.click

    flag_reason_text = "Set by Watir - #{get_timestamp}"
    @browser.wait_until { flag_modal.present? }
    flag_reason_text_input.set flag_reason_text
    flag_modal_submit.click

    @browser.wait_until { !flag_modal_submit.present? && !flag_modal.present? }
    @browser.wait_until { @convdetail_page.depth0_q.present? && (@convdetail_page.depth0_q.style("background-color").include? "255, 252, 181") }

    #refresh to see the flag message 
    if refresh_after_flag
      @browser.refresh
      flag_message = "This post has been flagged as inappropriate; it has been temporarily removed and brought to the attention of the site moderators."
      @browser.wait_until { @convdetail_page.conv_moderation_alert.present? && @convdetail_page.conv_moderation_alert.text == flag_message}
    end
  end
  def flag_a_reply_in_post (is_admin:false, setting_type: :low, refresh_after_flag: false)
    @browser.refresh
    @browser.wait_until { @convdetail_page.conv_reply.present? || @convdetail_page.edited_reply_content.present? }
    # click dropdown menu for the answer
    @convdetail_page.reply_dropdown_toggle.when_present.click

    @browser.wait_until { @convdetail_page.reply_flag_option.present? }
    @convdetail_page.reply_flag_option.click
    flag_reason_text = "Set by Watir - #{get_timestamp}"
    @browser.wait_until { flag_modal.present? }
    flag_reason_text_input.set flag_reason_text
    flag_modal_submit.click

    @browser.wait_until { !flag_modal_submit.present? && !flag_modal.present? }
    @browser.wait_until { @convdetail_page.reply.present? || @convdetail_page.edited_reply_content.present? }
    @browser.wait_until { (@convdetail_page.reply.style("background-color").include? "255, 252, 181") }

    #refresh to see the flag message 
    if refresh_after_flag
      @browser.refresh
      flag_message = "This post has been flagged as inappropriate; it has been temporarily removed and brought to the attention of the site moderators."
      @browser.wait_until { @convdetail_page.conv_reply.present? && @convdetail_page.conv_reply.text == flag_message}
    end
  end

  def root_post_owner_review_flagged_conv
    @browser.wait_until { @convdetail_page.depth0_q.present? && (@convdetail_page.depth0_q.style("background-color").include? "255, 252, 181") }
    @convdetail_page.root_post_feature_dropdown.when_present.click
    @browser.wait_until { @convdetail_page.dropdown_delete.present? && !@convdetail_page.dropdown_edit.present? }
    assert !@convdetail_page.reply_like_link.present? && !@convdetail_page.reply_reply_link.present?
  end

  def admin_review_flagged_conv
    root_post_owner_review_flagged_conv
    @browser.wait_until { @convdetail_page.dropdown_remove.present? && @convdetail_page.dropdown_reinstate.present? }
  end

  def root_post_owner_review_flagged_reply(is_non_creator=false)
    @browser.wait_until { @convdetail_page.conv_reply.present? && (@convdetail_page.reply.style("background-color").include? "255, 252, 181") }
    if is_non_creator
      return
    end
    @convdetail_page.reply_dropdown_toggle.when_present.click
    @browser.wait_until { @convdetail_page.reply_menu_delete.present? && !@convdetail_page.reply_menu_edit.present? }
    assert !@convdetail_page.reply_like_link.present? && !@convdetail_page.reply_reply_link.present?
  end

  def admin_review_flagged_reply
    root_post_owner_review_flagged_reply
    @browser.wait_until { @convdetail_page.reply_mod_menu.present? && @convdetail_page.reply_mod_menu_reinstate.present? }
  end

  def review_rejected_conv (is_admin:false, is_root_post_owner:false, is_high_level:false)
    alert_msg = is_admin ? "This post has been permanently removed" : "This post has been flagged as inappropriate by other users and permanently removed."
    @browser.wait_until { @convdetail_page.conv_moderation_alert.present? && @convdetail_page.conv_moderation_alert.text == alert_msg }
    assert !@convdetail_page.conv_root_post_like_link.present? && !@convdetail_page.conv_root_post_follow_link.present? && !@convdetail_page.conv_root_post_reply_link.present? 
    assert !@convdetail_page.root_post_feature_dropdown.present?
    if is_admin || is_root_post_owner
      @browser.wait_until { @convdetail_page.depth0_q.present? && (@convdetail_page.depth0_q.style("background-color").include? "251, 223, 223") }
    end
  end

  def review_rejected_reply (is_admin:false, is_root_post_owner:false, is_high_level:false)
    alert_msg = is_admin ? "This post has been permanently removed" : "This post has been flagged as inappropriate by other users and permanently removed."
    @browser.wait_until { @convdetail_page.conv_reply.present? && (@convdetail_page.reply.style("background-color").include? "251, 223, 223") }
    if is_root_post_owner || is_admin
      assert @convdetail_page.conv_reply_remove_alert.attribute_value("innerText") == alert_msg
    else
      assert @convdetail_page.edited_reply_content.text.include? alert_msg
    end
    assert !@convdetail_page.reply_dropdown_toggle.present?
    assert !@convdetail_page.reply_like_link.present? && !@convdetail_page.reply_reply_link.present?
  end

  def admin_reinstate_post_or_reply (title, answer_text=nil, descrip=nil, tab_type)
    navigate_in
    switch_to_tab tab_type
    @browser.wait_until { empty_admin_mod_post.present? || mod_tab_posts_block.div(:class => "post", :index => 0).present? }
    for index in 0...mod_tab_posts_block.divs(:class => "post").size
      if (mod_tab_posts_block.element(:css => ".post .media-heading a", :index => index).text == title)
        if answer_text == nil
          answer_text = "Answer by watir"
          next # this is the reply, continue
        end
        mod_tab_posts_block.button(:css => ".mod-button.approve", :index => index).when_present.click
        @browser.wait_until { empty_admin_mod_post.present? || mod_tab_posts_block.div(:class => "post", :index => 0).present? }
        return true
      end
    end
    return false
  end

  def admin_reject_post_or_reply(title, answer_text=nil, descrip=nil, tab_type)
    navigate_in
    switch_to_tab tab_type
    @browser.wait_until { empty_admin_mod_post.present? || mod_tab_posts_block.div(:class => "post", :index => 0).present? }
    for index in 0...mod_tab_posts_block.divs(:class => "post").size
      if (mod_tab_posts_block.element(:css => ".post .media-heading a", :index => index).text == title)
        if answer_text == nil
          answer_text = "Answer by watir"
          next # this is the reply, continue
        end
        mod_tab_posts_block.button(:css => ".mod-button.reject", :index => index).when_present.click
        @browser.wait_until { @browser.button(:css => ".modal-footer .btn-primary", :index => index).present? }
        @browser.button(:css => ".modal-footer .btn-primary", :index => index).click
        @browser.wait_until { empty_admin_mod_post.present? || mod_tab_posts_block.div(:class => "post", :index => 0).present? }
        return true
      end
    end
    return false
  end

# if answer_text = nil, it will approve the conversation
  def admin_approve_reply_or_post(title, answer_text=nil, descrip=nil, tab_type)
    navigate_in
    switch_to_tab tab_type
    @browser.wait_until { empty_admin_mod_post.present? || mod_tab_posts_block.div(:class => "post", :index => 0).present? }
    for index in 0...mod_tab_posts_block.divs(:class => "post").size
      if (mod_tab_posts_block.element(:css => ".post .media-heading a", :index => index).text == title)
        if answer_text == nil
          answer_text = "Answer by watir"
          next # this is the reply, continue
        end
        mod_tab_posts_block.button(:css => ".mod-button.approve", :index => index).when_present.click
        @browser.wait_until { empty_admin_mod_post.present? || mod_tab_posts_block.div(:class => "post", :index => 0).present? }
        return true
      end
    end
    return false
  end

  def edit_reply_by_root_post_owner
    @browser.refresh
    @browser.wait_until { @convdetail_page.conv_reply.present? }
    @convdetail_page.reply_dropdown_toggle.when_present.click
    @convdetail_page.reply_menu_edit.when_present.click
    # eidt reply content
    answer_text = "Answered by Watir - #{get_timestamp} --edit"
    @convdetail_page.edit_reply_box.when_present.focus
    @browser.wait_until { @convdetail_page.edit_reply_submit.present? }
    @convdetail_page.edit_reply_box.when_present.set answer_text
    @convdetail_page.edit_reply_submit.when_present.click
    @browser.wait_until { @convdetail_page.edited_reply_content.present? }
  end

  def goto_conv_detail_from_topic_list_page (topic:nil, title:nil)
    begin
      @topicdetail_page = @topiclist_page.go_to_topic(topic)
      @topicdetail_page.goto_conversation :title => title
      @browser.wait_until { @convdetail_page.depth0_q.present? }
      return true
    rescue
      return false
    end
  end

  def no_change_for_reply_after_operation_on_conv(is_root_post_owner: false, is_admin: false, setting_type: :low, is_reinstate: false)
    assert_create_reply :is_root_post_owner => is_root_post_owner, :is_admin => is_admin, :setting_type => setting_type, :is_reinstate => is_reinstate
    assert !(@convdetail_page.reply.style("background-color").include? "255, 252, 181")
  end
end