require 'pages/community'
require 'pages/community/layout'
require 'pages/community/login'
require 'pages/community/home'
require 'pages/community/conversationdetail'
require 'minitest/assertions'

class Pages::Community::Profile < Pages::Community

  attr_accessor :uuid

  def initialize(config, options = {})
    super(config)

    @uuid = options[:uuid]

    @url = config.base_url + "/n/#{config.slug}/profile/#{@uuid}"
  end

  def start!(user)
    if @uuid.nil?
      home_page = Pages::Community::Home.new(@config)
      home_page.start!(user)
      goto_profile
    else  
      super(user, @url, profile_activity_item)
    end
  end

  def profile_pic_modal_cleanup!
    if profile_pic_modal.present?
      profile_pic_cancel_button.click
      @browser.wait_until { !profile_pic_cancel_button.present? }
    end
  ensure
    clean_up_modals!
  end

  profile_link                       { div(:class=>"dropdown open").link(:text => "My Profile") } 
  #profile_username                   { div(:class => "col-md-10 col-lg-10 col-xs-12 col-sm-12") }
  profile_jobtitle                   { element(:css => ".profile-title-label,.work-info-line") }
  profile_membersince                { div(:class => "col-md-6 col-xs-12 col-lg-12 profile-date") }
  profile_edit_button                { button(:value => "Edit Profile") }
  profile_edit_mode                  { div(:class => "edit-profile") }
  profile_bio_title                  { div(:class => "col-lg-12") }
  profile_bio_submit                 { div(:class => "col-md-4 col-xs-12 col-lg-4 col-md-offset-6").button(:class => "btn btn-primary") }
  profile_bg                         { div(:class => "profile-box-background") }
  #profile_page                       { div(:class => "row profile-box") }

  profile_personal_info_tab          { div(:class => "edit-tab", :text => "Personal Info") }
  profile_personal_info_icon         { link(:class => "icon-person-placeholder") }
  profile_work_info_tab              { div(:class => "edit-tab", :text => "Work Info") }
  profile_work_info_icon             { link(:class => "icon-suitcase") }
  profile_field                      { div(:class => "row edit-profile-field") }
  profile_field_label                { div(:class => "col-lg-3 control-label") }
  profile_text_input                 { input(:class => "form-control ember-view ember-text-field form-control") }
  profile_field_placeholder          { div(:class => "col-lg-9").input(:placeholder => "Enter City") }
  profile_work_tab_job_title         { div(:class => "col-lg-3 control-label", :text => "Job Title") }
  profile_work_tab_company_name      { div(:class => "row edit-profile-field ").div(:class => "col-lg-3 control-label", :text => "Company Name") }

  profile_field_save_button          { div(:class => "col-md-4 col-xs-12 col-lg-4 col-md-offset-6").button(:class => "btn btn-primary", :value => "Save") }
  profile_field_cancel_button        { div(:class => "col-md-4 col-xs-12 col-lg-4 col-md-offset-6").button(:class => "btn btn-default", :value => "Cancel") }

  profile_img                        { div(:class => "ember-view uploader-component profile-selected-image") }
  profile_pic_edit_icon              { div(:class => "profile-photo-edit-icon photo-edit") }
  profile_pic_modal                  { div(:class => "modal-content") }
  profile_pic_modal_title            { div(:class => "modal-content").h4(:class => "modal-title", :text => "Upload Photo") }
  profile_pic_file_info              { div(:class => "modal-body", :text => /Accepted file types include .GIF, .JPG, and .PNG./) }
  profile_pic_browse                 { div(:class => "instructions").button(:class => "btn btn-default", :text => "Browse your device") }
  profile_pic_close_icon             { div(:class => "modal-header").button(:class => "close") }
  profile_pic_close                  { button(:class => "close") }
  profile_pic_change_button          { div(:class => "modal-footer").button(:class => "btn btn-default btn-sm other", :text => "Change Photo") }
  profile_pic_cancel_button          { button(:class => "btn btn-default btn-sm", :value => "Cancel") }

  profile_pic_filefield              { file_field(:class => "file") }
  profile_pic_cropper                { div(:class => "cropper-canvas cropper-modal cropper-crop") }
  profile_pic_select_button          { button(:class => "btn btn-primary btn-sm file-upload-select-button", :text => "Select Photo") }
  profile_pic_selected_img           { div(:class => "ember-view uploader-component profile-selected-image") }
  profile_pic_img                    { div(:class => "ember-view uploader-component profile-selected-image") }
  profile_pic_delete_option          { button(:class => "btn btn-default btn-sm other", :value => "Delete Photo") }
  profile_pic_delete_button          { button(:class => "btn btn-default btn-sm other", :text => "Delete Photo") }
  profile_pic_delete_confirm_button  { button(:class => "btn btn-primary", :text => "Delete Photo") }

  profile_selected_pic_modal_title   { div(:class => "modal-header").h4(:class => "modal-title", :text => "Edit Photo") }
  profile_pic_selected_pic_info      { div(:class => "modal-body", :text => /Drag the blue box to change position and size. Anything outside the box will be cropped./) }

  profile_level_and_point            { div(:class => /level-with-points/)}
  profile_level_icon                 { element(:css => ".contributor-level-meta [class^=contributor-level]") }
  profile_level                      { element(:css => ".contributor-level-meta [class^=level]") }
  profile_level_points               { element(:css => ".contributor-level-meta .contributor-points") }
  profile_level_info_icon            { element(:css => ".contributor-level-meta .contributor-level-info") }
  profile_level_popover_total_points { element(:css => ".popover .contributor-level-progress .data-total-points") }
  profile_level_popover_level_pg     { element(:css => ".popover .level-progress") }
  profile_level_popover_level_max    { element(:css => ".popover .level-max") }
  profile_level_popover_max_current_level { element(:css => ".popover .level-max .current-level") }
  profile_level_popover_pg_current_level { element(:css => ".popover .level-desc") }
  profile_level_popover_pg_points_to_next_level { element(:css => ".popover .points-to-next-level") }
  profile_level_info_popover_learnmore  { link(:css => ".contributor-level-meta .popover-content .link-learn-more a") }
  profile_level_learnmore_psettings  { div(:class => "col-contributor-setting-events")}
  profile_level_learnmore_lsettings  { div(:class => "level-settings")}
  profile_level_learnmore_threshold  { divs(:class => "level-threshold")}


  profile_banner                     { div(:class => "profile-box-background") }
  profile_bio                        { textarea(:class => "form-control form-control ember-view ember-text-area form-control") }
  profile_bio_set                    { div(:class => "shown container").div(:class => "shown row profile-info-extra").div(:class => "col-lg-12") }
  profile_activity                   { div(:class => "member-activity") }
  profile_activity_conv              { div(:class => "col-md-10 col-xs-9 col-lg-11 col-sm-9").div(:class => "row") }

  profile_activity_title             { div(:class => "row profile-info-extra").div(:class => "col-lg-12") }
  profile_activity_img               { img(:class => "media-object thumb-48") }
  profile_activity_username          { div(:class => "col-md-10 col-xs-9 col-lg-11 col-sm-9") }
  profile_activity_date              { div(:class => " row activity-date") }
  profile_show_more_button           { link(:css => ".show-more-topics a") }
  profile_activity_reply_content     { p(:class => "reply-content")}

  convdetail                         { h3(:class => "media-heading root-post-title") }

  search_bar                         { input(:class => "ember-view ember-text-field typeahead form-control tt-input", :placeholder => "Search...") }

  topnav                             { div(:class => "navbar topbar-nav") }
  topnav_home                        { link(:class => "ember-view", :text => "Home") }
  topnav_topic                       { link(:class => "ember-view", :text => "Topics") } 
  topnav_product                     { link(:class => "ember-view", :text => "Products") }
  topnav_about                       { link(:class => "ember-view", :text => "About") } 

  topnav_search                      { input(:class => "ember-view ember-text-field typeahead form-control tt-input") }
  topnav_logo                        { link(:class => "ember-view").element(:class => "nav-logo") }
  tab_title                          { title }

  breadcrumb_link                    { link(:class => "ember-view", :text => @c.slug) }

  profile_page                       { div(:css => ".profile-box") }
  profile_page_betaon                { div(:class => "profile-box") }
  profile_username                   { div(:class => "col-md-10 col-lg-10 col-xs-12 col-sm-12").h3 }
  profile_page_author_name           { div(:class => "col-lg-8 col-md-8 col-xs-6 member-info-col").div(:class => "col-md-10 col-lg-10 col-xs-12 col-sm-12") }
  profile_page_author_name_betaon    { h3(:css => ".profile-information h3") }

  user_profile                       { div(:class => "profile-box-background") }
  user_profile_betaon                { div(:class => "profile-avatar") }
  user_profile_name                  { div(:class => "col-lg-8 col-md-8 col-xs-6 member-info-col").h3 }
  user_profile_name_betaon           { div(:class => "profile-box").h3 }
  ################ Signin / Register page elememts ###################


  ################ search elememts ###################
  search_result_page                 { div(:class => "row filters search-facets") }

  search_input                       { text_field(:class => "ember-view ember-text-field typeahead form-control tt-input") } 
  search_dropdown                    { span(:class => "tt-dropdown-menu") }
  search_result_heading              { div(:class => "media-heading") }

  ################ Profile redesign ###################
  profile_avatar_img                 { div(:css => ".profile-selected-image") }
  profile_avatar_camera              { element(:css => ".icon-camera") }
  profile_user_name                  { element(:css => ".profile-information h3") }
  profile_avatar_contri_level_icon   { div(:css => ".profile-avatar [class*=contributor-level]") }
  profile_workinfo_line              { element(:css => ".profile-title-label,.work-info-line") }
  profile_bioinfo_line               { p(:css => ".profile-information-content p:nth-of-type(3)") }
  profile_nav_activity_link          { link(:css => ".profile-flex-subnav a[href='#profile-activities']") }
  profile_nav_questions_link         { link(:css => ".profile-flex-subnav a[href='#profile-questions']") }
  profile_nav_replies_link           { link(:css => ".profile-flex-subnav a[href='#profile-replies']") }
  profile_nav_about_link             { link(:css => ".profile-flex-subnav a[href='#profile-about']") }
  profile_activity_pane              { div(:id => "profile-activity") }
  profile_qustions_pane              { div(:id => "profile-questions") }
  profile_replies_pane               { div(:id => "profile-replies") }
  profile_view_button                { div(:css => ".profile-information-buttons").button(:value => "View Profile") }
  profile_edit_stickbar              { element(:css => ".edit-profile-stickbar") }

  #============== Profile Activity ==============
  profile_activity_item              { element(:css => ".profile-activity-card,.member-activity") }
  profile_activity_conv_link         { link(:css => ".conversation-link") }

  #============== Profile Questions ==============
  profile_questions_showmore_btn     { link(:css => "#profile-questions .show-more-topics a") }

  #============== Profile Replies ==============
  profile_replies_showmore_btn     { link(:css => "#profile-replies .show-more-topics a") }

  #============== Profile About ==============
  profile_about_pane                 { div(:id => "profile-about") }
  profile_about_contri_level         { div(:css => ".contributor-level-progress") }
  profile_about_contri_learnmore     { link(:css => ".link-learn-more a") }
  profile_about_contri_levelmax      { div(:css => ".level-max") }
  profile_about_contri_totalpoints   { div(:css => ".data-total-points") }

  def get_profile_uuid
    @browser.url.match(/profile\/(.*)$/)[1]
  end

  def get_user_uuid_by_name user_name
    start!(user_name)
    @browser.url.split("/profile/")[1]
  end

  def switch_to_tab(tab)
    case tab
    when :activity
      profile_nav_activity_link.click unless profile_nav_activity_link.when_present.parent.class_name.include?("active")
      profile_activity_pane.when_present
    when :questions
      profile_nav_questions_link.when_present.click
      profile_qustions_pane.when_present 
    when :replies
      profile_nav_replies_link.when_present.click
      profile_replies_pane.when_present
    when :about
      profile_nav_about_link.when_present.click unless profile_nav_about_link.when_present.parent.class_name.include?("active")
      profile_about_pane.when_present
    else
      raise "Tab #{tab} not supported yet"  
    end  
  end  

  def goto_profile
    # add the following wait code to fix the issue: sometimes no response after user_dropdown.click
    @browser.wait_until { !@browser.element(:css => ".loading-block").present? }
    scroll_to_element(user_dropdown)
    user_dropdown.when_present.click
    # Profile can't be clicked since it might be overlapped by the toast message. e.g. Click Save in Admin->Contribtor Rating
    @browser.wait_until { !toast_message.present? }
    profile_link.when_present.click
    @browser.wait_until { profile_page.present? }
    accept_policy_warning
  end

  def check_activity_feed_link
    @browser.wait_until { profile_activity_conv.present? }
    conv = profile_activity_conv.link.text
    profile_activity_conv.link.when_present.click
    @convdetail_page = Pages::Community::ConversationDetail.new(@config)
    @browser.wait_until { @convdetail_page.convdetail.present? }
    @browser.wait_until { @convdetail_page.convdetail.text.include? conv }
  end

  def check_new_activity_feed
    goto_profile
    check_activity_feed_link
  end

  def level_points
    switch_to_tab(:about)
    contri_level_progress.total_points
  end  

  # since the point for Read a review won't be accumulated immediately, 
  # retry several times here.
  def wait_until_contri_rating_points_updated(expected_points, retry_times=5)
    retry_counter = 0
    while (level_points != expected_points) do
      break if retry_counter > retry_times
      sleep 1
      retry_counter += 1
      @browser.refresh
    end

    level_points 
  end
 
  def goto_first_conversation
    switch_to_tab(:activity)
    profile_activity_conv_link.when_present.click

    @convdetail_page = Pages::Community::ConversationDetail.new(@config)
    @browser.wait_until { @convdetail_page.conv_content.present? }
    @browser.wait_until { !@convdetail_page.conv_detail_loading_block.present? }
    @browser.wait_until { @browser.ready_state == "complete" }
  end

  def contri_level_icon
    profile_avatar_contri_level_icon
  end

  def contri_level_icon_level
    contri_level_icon.class_name.match(/contributor-level-[\d]/)[0]
  end

  def user_name
    profile_user_name.when_present.text
  end

  def contri_current_level
    switch_to_tab(:about)
    if contri_level_progress.is_max_level?
      contri_level_progress.max_level.text
    else  
      contri_level_progress.current_level.when_present.text
    end   
  end 

  def contri_level_progress
    ContriLevelProgressBlock.new(@browser)
  end 

  def question_list_in_activity_pane
    QuestionActivityList.new(@browser, ".gadget-profile-activity .tab-content>.active .profile-activity-card-list:nth-child(1)")
  end 

  def profile_editor
    ProfileEditor.new(@browser)
  end

  def edit_profile(fields)
    profile_edit_button.when_present.click
    @browser.wait_until { profile_editor.present? }

    profile_editor.edit(fields)
    @browser.execute_script("window.scrollTo(0,document.documentElement.scrollTop)")
    @browser.wait_until { profile_edit_button.present? }
  end 

  class ContriLevelProgressBlock
    def initialize(browser)
      @browser = browser
      @parent_css = ".contributor-level-progress"
    end

    def present?
      @browser.div(:css => @parent_css).present?
    end  

    def total_points
      @browser.div(:css => @parent_css + " .data-total-points").when_present.text.gsub(/[^0-9]/, '').to_i
    end

    def is_max_level?
      @browser.wait_until { level_max.present? || level_progress.present? }
      level_max.present? && !level_progress.present?
    end
      
    def level_progress
      @browser.div(:css => @parent_css + " .level-progress")
    end

    def level_max
      @browser.div(:css => @parent_css + " .level-max")
    end

    def max_level
      @browser.div(:css => @parent_css + " .level-max .current-level")
    end  

    def current_level
      @browser.element(:css => @parent_css + " .level-desc")
    end 

    def points_to_next_level
      @browser.element(:css => @parent_css + " .points-to-next-level")
    end

    def learnmore_link
      @browser.link(:css => @parent_css + " .link-learn-more a")
    end 
  end

  class QuestionActivityList
    def initialize(browser, parent_css)
      @browser = browser
      @parent_css = parent_css
    end

    def present?
      @browser.div(:css => @parent_css).present?
    end  

    def activity_list
      cards_count = @browser.elements(:css => @parent_css + " .profile-activity-card").size

      result = []
      (1..cards_count).each do |i|
        result << QuestionActivity.new(@browser, @parent_css + " div:nth-of-type(#{i}) .profile-activity-card")
      end  

      result
    end

    def activity_at_title(title)
      activity_list.find { |a| a.conv_title.downcase == title.downcase  }
    end  

    class QuestionActivity
      def initialize(browser, parent_css)
        @browser = browser
        @parent_css = parent_css
      end

      def topic_link
        @browser.link(:css => @parent_css + " header a")
      end

      def topic_title
        topic_link.when_present.text
      end  

      def conv_link
        @browser.link(:css => @parent_css + " .conversation-link")
      end

      def conv_title
        conv_link.when_present.text
      end 

      def user_pill
        @browser.link(:css => @parent_css + " .network-profile-pill")
      end

      def user
        user_pill.when_present.text
      end  

      def like_count
        @browser.label(:css => @parent_css + " .profile-activity-card-footer .icon-thumb-up + label").when_present.text
      end

      def reply_count
        @browser.label(:css => @parent_css + " .profile-activity-card-footer .icon-comment + label").when_present.text
      end

      def view_count
        @browser.label(:css => @parent_css + " .profile-activity-card-footer .icon-show + label").when_present.text
      end

      def click_conv_link
        conv_link.when_present.click
      end  
    end 
  end
  
  class ReplyActivityList
    def initialize(browser, parent_css)
      @browser = browser
      @parent_css = parent_css
    end

    class ReplyActivity
      def initialize(browser, parent_css)
        @browser = browser
        @parent_css = parent_css
      end
    end 
  end

  class ProfileEditor
    def initialize(browser)
      @browser = browser
      @parent_css = ".edit-profile"
    end

    def present?
      @browser.div(:css => @parent_css).present?
    end  

    def personinfo_nav
      @browser.link(:css => @parent_css + " a[href='#personal_info']")
    end
    
    def workinfo_nav
      @browser.link(:css => @parent_css + " a[href='#work_info']")
    end  

    def save_btn
      @browser.button(:css => @parent_css + " .button-action-row .btn-primary")
    end
    
    def cancel_btn
      @browser.button(:css => @parent_css + " .button-action-row .btn-default")
    end  

    def switch_to_tab(tab)
      case tab
      when :person
        personinfo_nav.when_present.click
      when :work
        workinfo_nav.when_present.click
      else
        raise "Tab #{tab} not supported yet"
      end  
    end 

    def edit(fields)
      fields.each do |field|
        name = field[:name]
        raise "Cannot find field #{name}" if field_at_name(name).nil?
        field_at_name(name).set(field[:value])
      end

      save_btn.click  
    end

    def field_at_name(name)
      result = nil
      @browser.divs(:css => @parent_css + " .active .edit-profile-field").each_with_index do |item, index|
        if (item.div(:css => @parent_css + " .control-label").when_present.title == name)
          result = EditField.new(@browser, @parent_css + " .edit-profile-field:nth-of-type(#{index+1})")
          break
        end  
      end

      result
    end  

    class EditField
      def initialize(browser, parent_css)
        @browser = browser
        @parent_css = parent_css
      end

      def label
        @browser.div(:css => @parent_css + " .control-label").when_present.text
      end

      def input_field
        @browser.text_field(:css => @parent_css + " .form-control")
      end

      def set(value)
        input_field.set(value)
        @browser.wait_until { input_field.value == value }
      end  

      def icon
        @browser.span(:css => @parent_css + " .ember-view")
      end
    end  
  end  
end