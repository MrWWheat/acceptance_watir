require File.expand_path(File.dirname(__FILE__) + "/page_object.rb")

class CommunityProfilePage < PageObject
 
  attr_accessor :profile_link, 
  :profile_page, 
  :profile_username, 
  :profile_jobtitle, 
  :profile_membersince, 
  :profile_img, 
  :profile_banner, 
  :profile_pic_edit_icon, 
  :profile_edit_button,
  :profile_activity_title, 
  :profile_activity, 
  :profile_show_more_button, 
  :profile_edit_mode, 
  :profile_personal_info_tab, 
  :profile_personal_info_icon, 
  :profile_work_info_tab, 
  :profile_work_info_icon, 
  :profile_pic_modal, 
  :profile_pic_modal_title, 
  :profile_pic_file_info, 
  :profile_pic_change_button, 
  :profile_pic_cancel_button, 
  :profile_pic_select_button, 
  :profile_pic_delete_button,
  :profile_pic_close_icon, 
  :profile_field_save_button, 
  :search_bar, 
  :topnav_search, 
  :search_input, 
  :search_dropdown,
  :search_result_page, 
  :profile_field_cancel_button, 
  :user_profile, 
  :user_profile_name, 
  :profile_page_author_name,
  :topnav_home,
  :topnav_topic,
  :topnav_product,
  :topnav_about,
  :topnav_logo,
  :topnav


  def initialize(browser)
    super
    @profile_link = @browser.div(:class=>"dropdown open").link(:text => "My Profile")
    @profile_username = @browser.div(:class => "col-md-10 col-lg-10 col-xs-12 col-sm-12")
    @profile_jobtitle = @browser.div(:class => "col-md-6 col-lg-12 col-xs-12 icon-suitcase profile-title-label")
    @profile_membersince = @browser.div(:class => "col-md-6 col-xs-12 col-lg-12 profile-date")
    @profile_edit_button = @browser.button(:class => "shown btn btn-primary btn-sm shown", :value => "Edit Profile")
    @profile_edit_mode = @browser.div(:class => "edit-profile")
    @profile_bio_title = @browser.div(:class => "col-lg-12")
    @profile_bio_submit = @browser.div(:class => "col-md-4 col-xs-12 col-lg-4 col-md-offset-6").button(:class => "btn btn-primary")
    @profile_bg = @browser.div(:class => "profile-box-background")
    @profile_page = @browser.div(:class => "row profile-box")

    @profile_personal_info_tab = @browser.div(:class => "edit-tab", :text => "Personal Info")
    @profile_personal_info_icon = @browser.link(:class => "icon-person-placeholder")
    @profile_work_info_tab = @browser.div(:class => "edit-tab", :text => "Work Info")
    @profile_work_info_icon = @browser.link(:class => "icon-suitcase")
    @profile_field = @browser.div(:class => "row edit-profile-field")
    @profile_field_label = @browser.div(:class => "col-lg-3 control-label")
    @profile_text_input = @browser.input(:class => "form-control ember-view ember-text-field form-control")
    @profile_field_placeholder = @browser.div(:class => "col-lg-9").input(:placeholder => "Enter City")
    @profile_work_tab_job_title = @browser.div(:class => "col-lg-3 control-label", :text => "Job Title")
    @profile_work_tab_company_name = @browser.div(:class => "row edit-profile-field ").div(:class => "col-lg-3 control-label", :text => "Company Name")

    @profile_field_save_button = @browser.div(:class => "col-md-4 col-xs-12 col-lg-4 col-md-offset-6").button(:class => "btn btn-primary", :value => "Save")
    @profile_field_cancel_button = @browser.div(:class => "col-md-4 col-xs-12 col-lg-4 col-md-offset-6").button(:class => "btn btn-default", :value => "Cancel")

    @profile_img = @browser.div(:class => "ember-view uploader-component profile-selected-image")
    @profile_pic_edit_icon = @browser.div(:class => "profile-photo-edit-icon photo-edit")
    @profile_pic_modal = @browser.div(:class => "modal-content")
    @profile_pic_modal_title = @browser.div(:class => "modal-content").h4(:class => "modal-title", :text => "Upload Photo")
    @profile_pic_file_info = @browser.div(:class => "modal-body", :text => /Accepted file types include .GIF, .JPG, and .PNG./)
    @profile_pic_browse = @browser.div(:class => "instructions").button(:class => "btn btn-default", :text => "Browse your device")
    @profile_pic_close_icon = @browser.div(:class => "modal-header").button(:class => "close")
    @profile_pic_close = @browser.button(:class => "close")
    @profile_pic_change_button = @browser.div(:class => "modal-footer").button(:class => "btn btn-default btn-sm other", :text => "Change Photo")
    @profile_pic_cancel_button = @browser.button(:class => "btn btn-default btn-sm", :value => "Cancel")

    @profile_pic_filefield = @browser.file_field(:class => "file")
    @profile_pic_cropper = @browser.div(:class => "cropper-canvas cropper-modal cropper-crop")
    @profile_pic_select_button = @browser.button(:class => "btn btn-primary btn-sm file-upload-select-button", :text => "Select Photo")
    @profile_pic_selected_img = @browser.div(:class => "ember-view uploader-component profile-selected-image")
    @profile_pic_img = @browser.div(:class => "ember-view uploader-component profile-selected-image")
    @profile_pic_delete_option = @browser.button(:class => "btn btn-default btn-sm other", :value => "Delete Photo")
    @profile_pic_delete_button = @browser.button(:class => "btn btn-default btn-sm other", :text => "Delete Photo")
    @profile_pic_delete_confirm_button = @browser.button(:class => "btn btn-primary", :text => "Delete Photo")

    @profile_selected_pic_modal_title = @browser.div(:class => "modal-header").h4(:class => "modal-title", :text => "Edit Photo")
    @profile_pic_selected_pic_info = @browser.div(:class => "modal-body", :text => /Drag the blue box to change position and size. Anything outside the box will be cropped./)

    @profile_banner = @browser.div(:class => "profile-box-background")
    @profile_bio = @browser.textarea(:class => "form-control form-control ember-view ember-text-area form-control")
    @profile_bio_set = @browser.div(:class => "shown container").div(:class => "shown row profile-info-extra").div(:class => "col-lg-12")
    @profile_activity = @browser.div(:class => "member-activity")
    @profile_activity_conv = @browser.div(:class => "col-md-10 col-xs-9 col-lg-11 col-sm-9").div(:class => "row")

    @profile_activity_title = @browser.div(:class => "row profile-info-extra").div(:class => "col-lg-12")
    @profile_activity_img = @browser.img(:class => "media-object thumb-48")
    @profile_activity_username = @browser.div(:class => "col-md-10 col-xs-9 col-lg-11 col-sm-9")
    @profile_activity_date = @browser.div(:class => " row activity-date")
    @profile_show_more_button = @browser.div(:class => " show-more-topics col-md-10 col-sm-12 col-xs-12").link(:class => "btn btn-default ", :text => "Show more")

    @convdetail = @browser.h3(:class => "media-heading root-post-title")

    @search_bar = @browser.input(:class => "ember-view ember-text-field typeahead form-control tt-input", :placeholder => "Search...")

    @topnav = @browser.div(:class => "navbar topbar-nav")
    @topnav_home = @browser.link(:class => "ember-view", :text => "Home")
    @topnav_topic = @browser.link(:class => "ember-view", :text => "Topics")
    @topnav_product = @browser.link(:class => "ember-view", :text => "Products")
    @topnav_about = @browser.link(:class => "ember-view", :text => "About")
    
    @topnav_search = @browser.input(:class => "ember-view ember-text-field typeahead form-control tt-input")
    @topnav_logo = @browser.link(:class => "ember-view").img(:class => "nav-logo", :src => /jpg|jpeg|png|gif|tif/)
    @tab_title = @browser.title
    
    @breadcrumb_link = @browser.link(:class => "ember-view", :text => "#{$network}")

    @profile_page = @browser.div(:class => "row profile-box")
     @profile_username = @browser.div(:class => "col-md-10 col-lg-10 col-xs-12 col-sm-12")
     @profile_page_author_name = @browser.div(:class => "col-lg-8 col-md-8 col-xs-6 member-info-col").div(:class => "col-md-10 col-lg-10 col-xs-12 col-sm-12")

    ################ Signin / Register page elememts ###################
    @user_profile = @browser.div(:class => "profile-box-background")
    @user_profile_name = @browser.div(:class => "col-lg-8 col-md-8 col-xs-6 member-info-col").h3
    
    
    ################ search elememts ###################
    @search_result_page = @browser.div(:class => "row filters search-facets")
    
    @search_input = @browser.text_field(:class => "ember-view ember-text-field typeahead form-control tt-input")
    @search_dropdown = @browser.span(:class => "tt-dropdown-menu")
    @search_result_heading = @browser.div(:class => "media-heading")
  end

  
  def check_profile_in_user_dropdown
    @loginpage = CommunityLoginPage.new(@browser)
    if !@loginpage.username.present?
     about_login("regular", "logged")
    end
    if !@loginpage.dropdown_open.present?
     @adminpage = CommunityAdminPage.new(@browser)
     @adminpage.caret.when_present.click
    end
    @loginpage = CommunityLoginPage.new(@browser)
    @browser.wait_until($t) { @loginpage.dropdown_open.present? }
    @browser.wait_until($t) { @profile_link.present? }
  end

  def goto_profile
    check_profile_in_user_dropdown
    @profile_link.click
    @browser.wait_until($t) { @profile_page.present? }
  end

  def check_profile_username
    @browser.wait_until($t) { @profile_page.present? }
    username = @profile_username.text
    @browser.wait_until($t) { @profile_username.present? }
  end

  def check_profile_jobtitle
    @browser.wait_until($t) { @profile_page.present? }
    username = @profile_jobtitle.text
    @browser.wait_until($t) { @profile_jobtitle.present? }
  end

  def check_profile_membsersince
    @browser.wait_until($t) { @profile_page.present? }
    @browser.wait_until($t) { @profile_membersince.present? }
  end

  def check_profile_img
    @browser.wait_until($t) { @profile_page.present? }
    @browser.wait_until($t) { @profile_img.present? }
  end

  def check_profile_banner
    @browser.wait_until($t) { @profile_page.present? }
    @browser.wait_until($t) { @profile_banner.present? }
  end

  def check_profile_pic_edit_icon
    @browser.wait_until($t) { @profile_page.present? }
    @browser.wait_until($t) { @profile_pic_edit_icon.present? }
  end

  def check_edit_profile_button
    @browser.wait_until($t) { @profile_page.present? }
    @browser.wait_until($t) { @profile_edit_button.present? }
  end

  def check_activity_title
    @browser.wait_until($t) { @profile_page.present? }
    @browser.wait_until($t) { @profile_activity_title.present? }
  end

  def check_activity_feed
    @browser.wait_until($t) { @profile_page.present? }
    @browser.wait_until($t) { @profile_activity.present? }
  end

  def check_activity_feed_link
    @browser.wait_until($t) { @profile_page.present? }
    @browser.wait_until($t) { @profile_activity_conv.present? }
    conv = @profile_activity_conv.link.text
    @profile_activity_conv.link.when_present.click
    @browser.wait_until($t) { @convdetail.present? }
    @browser.wait_until($t) { @convdetail.text.include? conv }
  end

  def check_show_more
    @browser.wait_until($t) { @profile_page.present? }
    @browser.execute_script("window.scrollBy(0,3000)")
    @browser.wait_until($t) { @profile_show_more_button.present? }
  end

  def check_topnav_on_profile(user)
    if user == "logged"
      about_login("regis2", "logged")
      @loginpage = CommunityLoginPage.new(@browser)
      @browser.wait_until($t) { @loginpage.topnav_notification.present? } 
    else
    @browser.wait_until($t) { @topnav_home.present? }
    @browser.wait_until($t) { @topnav_topic.present? }
    @browser.wait_until($t) { @topnav_product.present? }
    @browser.wait_until($t) { @topnav_about.present? }
    @browser.wait_until($t) { @topnav_signin.present? }
    @browser.wait_until($t) { @topnav_search.present? }
    @browser.wait_until($t) { @topnav_logo.present? } 
  end
  end

  def check_footer_on_profile
    @browser.wait_until($t) { @profile_page.present? }
    @browser.execute_script("window.scrollBy(0,10000)")
    @homepage = CommunityHomePage.new(@browser)
    @browser.wait_until($t) { @homepage.footer.present? }
  end

  def check_browser_tab_title
    about_login("regular", "logged")
    goto_profile
    #expected_tabtitle = "#{$user[3]}'s"+" Profile"
    @browser.wait_until($t) { @profile_page.present? }
    actual_tabtitle = @browser.title
    assert_equal actual_tabtitle, "#{$user1[3]}'s"+" Profile", "Not expected profile"
    #assert_match actual_tabtitle, expected_tabtitle
  end

  def edit_profile_mode
    @browser.wait_until($t) { @profile_page.present? }
     @profile_edit_button.click
    @browser.wait_until($t) { @profile_edit_mode.present? }
  end

  def edit_bio_field
    about_login("regis", "logged")
    @adminpage = CommunityAdminPage.new(@browser)
    @browser.wait_until($t) { @adminpage.caret.present? }
    @adminpage.caret.click

    bio = "Bio edited by Watir - #{get_timestamp}"
    @profile_link.when_present.click
    @browser.wait_until($t) { @profile_page.exists? }
    assert @profile_edit_button.present?
    @profile_edit_button.when_present.click
    @browser.wait_until($t) { @profile_edit_mode.present? }
    @browser.execute_script("window.scrollBy(0,800)")
    @profile_bio.when_present.set bio
    @profile_field_save_button.when_present.click
    sleep 4
    bg_box = @profile_bg
    #@browser.execute_script('$("div.profile-box-background").scrollTop(200)')
    @browser.execute_script("window.scrollBy(0,-200)")
    @browser.wait_until($t) { @profile_bg.present? }
    @browser.wait_until($t) { @profile_bio_set.text.include? bio}
    assert @profile_bio_set.text.include? bio
  end

  def check_personal_info_tab
    if !@profile_edit_button.present?
      goto_profile
    end
    @browser.wait_until($t) { @profile_page.present? }
    @profile_edit_button.when_present.click
    @browser.wait_until($t) { @profile_edit_mode.present? }
    @browser.wait_until($t) { @profile_personal_info_tab.present?}
  end

  def check_personal_info_icon
    if !@profile_edit_button.present? 
      goto_profile
    end
    @browser.wait_until($t) { @profile_page.present? }
    @browser.wait_until($t) { @profile_edit_button.present? }
    @profile_edit_button.click
    @browser.wait_until($t) { @profile_edit_mode.present? }
    @browser.wait_until($t) { @profile_personal_info_icon.present?}
  end

  def check_work_info_tab
    if !@profile_edit_button.present?
      goto_profile
    end
    @browser.wait_until($t) { @profile_page.present? }
    @browser.wait_until($t) { @profile_edit_button.present? }
    @profile_edit_button.click
    @browser.wait_until($t) { @profile_edit_mode.present? }
    @browser.wait_until($t) { @profile_work_info_tab.present?}
  end

  def check_work_info_icon
    if !@profile_edit_button.present?
      goto_profile
    end
    @browser.wait_until($t) { @profile_page.present? }
    @browser.wait_until($t) { @profile_edit_button.present? }
    @profile_edit_button.click
    @browser.wait_until($t) { @profile_edit_mode.present? }
    @browser.wait_until($t) { @profile_work_info_icon.present?}
  end

  def check_new_activity_feed
    goto_profile
    check_activity_feed_link
  end

  def goto_edit_profile_pic
    if !@profile_pic_edit_icon.present?
      goto_profile
    end
    @browser.wait_until($t) { @profile_page.present? }
    @browser.wait_until($t) { !@profile_pic_modal.present?}
    @browser.wait_until($t) { @profile_pic_edit_icon.present? }
    @profile_pic_edit_icon.click
    @browser.wait_until($t) { @profile_pic_modal.present?}
  end

  def check_edit_profile_pic_modal_title
    if !@profile_pic_edit_icon.present?
      goto_profile
    end
    @browser.wait_until($t) { @profile_pic_modal_title.present? }
  end

  def check_edit_profile_pic_modal_info
    if !@profile_pic_edit_icon.present?
      goto_profile
      @profile_pic_edit_icon.click
      @browser.wait_until($t) { @profile_pic_modal.present?}
    end
    @browser.wait_until($t) { @profile_pic_file_info.present? }
  end

  def check_edit_profile_pic_modal_footer_button_and_close_icon
    if !@profile_pic_edit_icon.present?
      goto_profile
      @profile_pic_edit_icon.click
      @browser.wait_until($t) { @profile_pic_modal.present?}
    end
    @browser.wait_until($t) { @profile_pic_change_button.present? }
    @browser.wait_until($t) { @profile_pic_cancel_button.present?}
    @browser.wait_until($t) { @profile_pic_select_button .present?}
    @browser.wait_until($t) { @profile_pic_delete_button.present? }

    @browser.wait_until($t) { @profile_pic_close_icon.present? }
  end

  def edit_profile_pic
    about_login("regis", "logged")
    goto_profile

    profilepic = "#{$rootdir}/seeds/development/images/profilepic.jpeg"
    @browser.wait_until($t) { @profile_page.exists? }
    @profile_pic_edit_icon.when_present.click

    @browser.wait_until($t) { @profile_pic_modal.present? }
    @profile_pic_filefield.set profilepic
    @browser.wait_until($t) { @profile_pic_cropper.exists? }
    @profile_pic_select_button.when_present.click
    @browser.wait_until($t) { !@profile_pic_modal.present? }
    @browser.refresh
    @browser.wait_until($t) { @profile_pic_selected_img.present? }
    profile_image1 = @profile_pic_selected_img.style
    assert_match /profilepic.jpeg/ , profile_image1, "profile image should match profilepic.jpeg"

    # #removing profile pic for next test run
    @browser.wait_until($t) { @profile_pic_edit_icon.present? }
    @profile_pic_edit_icon.when_present.click
    @browser.wait_until($t) { @profile_pic_modal.present? }
    @browser.wait_until($t) { @profile_pic_delete_button.present? }
    @profile_pic_delete_button.when_present.click
    @browser.wait_until($t) { @profile_pic_delete_confirm_button.present? }
    @profile_pic_delete_confirm_button.click

    sleep 2
    @browser.refresh
    if @profile_pic_modal.present?
      @profile_pic_close.click 
    end
    @browser.wait_until { !@profile_pic_modal.present? }
    @browser.wait_until($t) { @profile_pic_selected_img.present? }
    no_profile_image = @profile_pic_selected_img.style
    assert_match /person_shadow/ , no_profile_image, "profile image should match person shadow"
  end

  def delete_profile_pic
    about_login("regis", "logged")
    goto_profile

    profilepic = "#{$rootdir}/seeds/development/images/profilepic.jpeg"
    @browser.wait_until($t) { @profile_page.present? }
    @profile_pic_edit_icon.when_present.click

    @browser.wait_until($t) { @profile_pic_modal.present? }
    @profile_pic_filefield.set profilepic
    @browser.wait_until($t) { @profile_pic_cropper.present? }
    @profile_pic_select_button.when_present.click
    @browser.wait_until($t) { !@profile_pic_modal.present? }
    @browser.refresh
    @browser.wait_until($t) { @profile_pic_selected_img.present? }
    if @profile_pic_selected_img.present?
     @profile_pic_edit_icon.when_present.click
     @browser.wait_until($t) { @profile_pic_modal.present? }
     @browser.wait_until($t) { @profile_pic_delete_button.present? }
     @profile_pic_delete_button.when_present.click
     @browser.wait_until($t) { @profile_pic_delete_confirm_button.present? }
     @profile_pic_delete_confirm_button.click

     sleep 2
     @browser.refresh
     if @profile_pic_modal.present?
       @profile_pic_close.click 
     end
     @browser.wait_until { !@profile_pic_modal.present? }
     @browser.wait_until($t) { @profile_pic_selected_img.present? }
     no_profile_image = @profile_pic_selected_img.style
     assert_match /person_shadow/ , no_profile_image, "profile image should match person shadow"
    end
    no_profile_image = @profile_pic_selected_img.style
    assert_match /person_shadow/ , no_profile_image, "profile image should match person shadow"

  end

  def check_another_user_profile_as_anon
    @loginpage = CommunityLoginPage.new(@browser)
    if @loginpage.topnav_notification.present? || @loginpage.username.present? 
      signout
    end
    @topicdetailpage = CommunityTopicDetailPage.new(@browser)
    @browser.goto @topicdetailpage.topicpage_url
    @browser.wait_until($t) { @topicdetailpage.topic_page.present? }
    policy_warning
    topic_detail("A Watir Topic For Widgets")
    choose_post_type("discussion")
    @browser.wait_until($t) { @topicdetailpage.topic_post.present? }
    username = @topicdetailpage.topic_post_author.text
    @topicdetailpage.topic_post_author.click
    @browser.wait_until($t) { @profile_page.present? }
    assert @profile_page.text.include? username
  end

end