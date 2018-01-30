require 'watir_test'
require 'pages/community/profile'
require 'pages/community/admin_profile_feild'

class ProfileTest < WatirTest

  def setup
    super
    @browser = @config.browser
    @login_page = Pages::Community::Login.new(@config)
    @convdetail_page = Pages::Community::ConversationDetail.new(@config)
    @topicdetail_page = Pages::Community::TopicDetail.new(@config)
    @topiclist_page = Pages::Community::TopicList.new(@config)
    @profile_page = Pages::Community::Profile.new(@config)
    @admin_profile_page = Pages::Community::AdminProfileFeild.new(@config)

    user = @c.users[user_for_test]
    @config.data['user_uuids'] ||= {}
    user_uuid = @config.data['user_uuids'][user.username]
    @profile_page = Pages::Community::Profile.new(@config, uuid: user_uuid)
    @current_page = @profile_page
    puts "[[[ #{name} ::: #{user_for_test} ]]]" if @config.verbose?

    @profile_page.start!(user_for_test)
    # persist the user uuid for later user
    @config.data['user_uuids'][user.username] = @profile_page.get_profile_uuid if user_uuid.nil?
  end

  def teardown
    super
  end

  def get_persisted_user_uuid(user)
    

    @config.data['user_uuids'][user.username] = @profile_page.get_profile_uuid
  end  

  user :network_admin
  p1
  # Case #1: Check Profile menu item visible in User dropdown
  def test_00010_profilepage_profile_option
    @profile_page.user_dropdown.when_present.click
    assert @profile_page.profile_link.present?
  ensure
    # close up the context menu
    @profile_page.user_dropdown.click if @profile_page.profile_link.present?
  end

  # Case #2: Check look and feel for Profile page
  def test_00020_profilepage_profile_page
    @profile_page.goto_profile
    @browser.wait_until { @profile_page.profile_activity_item.present? }

    assert_all_keys({
      :profile_page => @profile_page.profile_page.present?,
      :profile_username_match => @c.users[user_for_test].name == @profile_page.user_name,
      :work_info => @profile_page.profile_workinfo_line.present?,
      :profile_img => @profile_page.profile_img.present?,
      :profile_edit_button => @profile_page.profile_edit_button.present?,
      :profile_activity_item => @profile_page.profile_activity_item.present?,
      :topnav_home => @profile_page.topnav_home.present?,
      :topnav_topic => @profile_page.topnav_topic.present?,
      :topnav_product => @profile_page.topnav_product.present?,
      :topnav_about => @profile_page.topnav_about.present?,
      :topnav_search => @profile_page.topnav_search.present?,
      :topnav_logo =>  @profile_page.topnav_logo.present?,
      # :browser_title => (@browser.title == "#{@c.users[user_for_test].name}'s Profile"),
    })
    
    #TODO
    @profile_page.profile_avatar_img.when_present.hover
    @profile_page.profile_avatar_camera.when_present
    assert @profile_page.profile_avatar_camera.present?
    # comment below assert since it is invisible when no bio
    # assert @profile_page.profile_bioinfo_line.present? 
  end

  def test_00030_check_avatar_link_clickable
    topicdetail_page = @topiclist_page.go_to_topic("A Watir Topic")
    @browser.execute_script("window.scrollBy(0,-1200)")
    sleep 1
    topicdetail_page.topic_detail_posts_creator_pills[0].when_present.click

    @browser.wait_until { @profile_page.profile_activity_item.present? }
    assert_all_keys({
      :profile_page => @profile_page.profile_page.present?,
      :profile_img => @profile_page.profile_img.present?,
      # :browser_title => (@browser.title == "#{@c.users[user_for_test].name}'s Profile"),
    })

    @topiclist_page.go_to_topic("A Watir Topic")
    @browser.execute_script("window.scrollBy(0,-1200)")
    sleep 1
    begin
      @browser.wait_until(5) { topicdetail_page.topic_detail_creator_avatars[0].present? }
      topicdetail_page.topic_detail_creator_avatars[0].click
    rescue
      topicdetail_page.topic_detail_creator_avatars_unfeature[0].when_present.click
    end
    @browser.wait_until { @profile_page.profile_activity_item.present? }
    assert_all_keys({
      :profile_page => @profile_page.profile_page.present?,
      :profile_img => @profile_page.profile_img.present?,
      # :browser_title => (@browser.title == "#{@c.users[user_for_test].name}'s Profile"),
    })
  end

  def test_00040_activity_show_recent_updated_activity
    @profile_page.goto_profile
    url = @browser.url
    # user1 post a reply to a question
    topicdetail_page = @topiclist_page.go_to_topic("A Watir Topic")
    topicdetail_page.check_post_link
    answer_text = @convdetail_page.post_comment "question"
    # user2 check the activity of user1
    @profile_page.about_login("regular_user2", "logged")
    @browser.goto url
    @browser.wait_until { @profile_page.profile_activity_reply_content.present? }
    assert answer_text == @profile_page.profile_activity_reply_content.attribute_value("innerText")

    # click content will redirect to the conversation detail page
    @profile_page.scroll_to_element @browser.link(:text => /Replies by/)
    @browser.execute_script("window.scrollBy(0,-200)")
    @profile_page.profile_activity_reply_content.click
    @browser.wait_until { @convdetail_page.reply_box.present? }
  end

  def test_00050_check_contributor_in_about_tab
    @profile_page.switch_to_tab(:about)
    if !beta_feature_enabled?("fs_ideas") || (@browser.url.include? "betaon1")
      skip
    end
    @browser.wait_until { @profile_page.contri_level_progress.present? }
    curr_point = @profile_page.contri_level_progress.total_points

    if @profile_page.contri_level_progress.max_level.present?
      curr_level = @profile_page.contri_level_progress.max_level.text[-1].to_i
    else
      curr_level = @profile_page.contri_level_progress.current_level.text[-1].to_i
    end
    @profile_page.profile_about_contri_learnmore.when_present.click

    @browser.window(:url => /contributor_settings/).when_present.use do
      @browser.wait_until { @profile_page.profile_level_learnmore_lsettings.present? }
      curr_level_threshold = @browser.span(:class => "level-threshold", :index => (curr_level-1) ).attribute_value("innerText").gsub(',','').to_i
      next_level_threshold = @browser.span(:class => "level-threshold", :index => (curr_level  ) ).attribute_value("innerText").gsub(',','').to_i unless curr_level == 5 
      assert curr_level_threshold <= curr_point && ( curr_level == 5 || next_level_threshold > curr_point )
      @browser.window.close
    end

  end

  def test_00060_set_feild_visible_or_unvisible
    first_name = @c.users[user_for_test].name.split(' ')[0]
    # admin set always public unchecked
    @admin_profile_page.navigate_in
    @admin_profile_page.custom_profile_feild "First Name", {1 => true, 2 => false}
    # admin edit his first name feild 
    @profile_page.goto_profile
    url = @browser.url
    @profile_page.profile_edit_button.when_present.click
    label = @profile_page.profile_editor.field_at_name "First Name"
    icon_init_type = (label.icon.attribute_value("class").include? "icon-show")? "icon-show" : "icon-hide"

    # user2 can/can't see the feild
    @login_page.about_login("regular_user2", "logged")
    @browser.goto url
    @browser.wait_until { @profile_page.profile_page_author_name_betaon.present? }
    assert icon_init_type == "icon-show" || !(@profile_page.profile_page_author_name_betaon.text.include? first_name)

    # admin click the icon to set visible/unvisible
    @login_page.about_login("network_admin", "logged")
    @profile_page.goto_profile
    @profile_page.profile_edit_button.when_present.click
    label.icon.when_present.click
    @browser.wait_until { !(label.icon.attribute_value("class").include? icon_init_type) }
    @profile_page.profile_editor.edit([{name: "Bio", value: "Bio for test"}])
    @browser.execute_script("window.scrollBy(0,-1200)")
    @browser.wait_until { @profile_page.profile_edit_button.present? }

    # user2 can't/can see the feild
    @login_page.about_login("regular_user2", "logged")
    @browser.goto url
    @browser.wait_until { @profile_page.profile_page_author_name_betaon.present? }
    assert icon_init_type != "icon-show" || !(@profile_page.profile_page_author_name_betaon.text.include? first_name)
  ensure
    @login_page.about_login("network_admin", "logged")
    @profile_page.goto_profile
    @profile_page.profile_edit_button.when_present.click
    @browser.wait_until { label.icon.present? }
    if !(label.icon.attribute_value("class").include? icon_init_type)
      label.icon.click
      @browser.wait_until { (label.icon.attribute_value("class").include? icon_init_type) }
      @profile_page.profile_editor.edit([{name: "Bio", value: "Bio for test"}])
      @browser.execute_script("window.scrollBy(0,-1200)")
      @browser.wait_until { @profile_page.profile_edit_button.present? }
    end
  end

 #============ ADMIN USER PROFILE FEILD TESTS ==========================#

  def test_00070_add_feild_as_show_feild
    first_name = @c.users[user_for_test].name.split(' ')[0]
    # set first name feild as not show
    @admin_profile_page.navigate_in
    @admin_profile_page.custom_profile_feild "First Name", {0 => false }
    # admin can't see first name feild
    @profile_page.goto_profile
    url = @browser.url
    @browser.wait_until { @profile_page.profile_page_author_name_betaon.present? }
    assert !(@profile_page.profile_page_author_name_betaon.text.include? first_name)
    # user2 can't see first name feild
    @login_page.about_login("regular_user2", "logged")
    @browser.goto url
    @browser.wait_until { @profile_page.profile_page_author_name_betaon.present? }
    assert !(@profile_page.profile_page_author_name_betaon.text.include? first_name)

    # set first name feild as show
    @login_page.about_login("network_admin","logged")
    @admin_profile_page.navigate_in
    @admin_profile_page.custom_profile_feild "First Name", {0 => true, 2 => false }
    # admin can't see first name feild]
    @browser.goto url
    @browser.wait_until { @profile_page.profile_page_author_name_betaon.present? }
    assert (@profile_page.profile_page_author_name_betaon.text.include? first_name)
    # user2 can't see first name feild
    @login_page.about_login("regular_user2", "logged")
    @browser.goto url
    @browser.wait_until { @profile_page.profile_page_author_name_betaon.present? }
    assert (!@profile_page.profile_page_author_name_betaon.text.include? first_name)

    # set first name feild as public
    @login_page.about_login("network_admin","logged")
    @admin_profile_page.navigate_in
    @admin_profile_page.custom_profile_feild "First Name", {0 => true, 2 => true }
    # admin can see first name feild
    @browser.goto url
    @browser.wait_until { @profile_page.profile_page_author_name_betaon.present? }
    assert (@profile_page.profile_page_author_name_betaon.text.include? first_name)
    # user2 can see first name feild
    @browser.goto url
    @browser.wait_until { @profile_page.profile_page_author_name_betaon.present? }
    assert (@profile_page.profile_page_author_name_betaon.text.include? first_name)
  ensure
    # set first name feild as public
    @login_page.about_login("network_admin","logged")
    @admin_profile_page.navigate_in
    @admin_profile_page.custom_profile_feild "First Name", {2 => true }
  end

  def test_00080_add_feild_as_require_feild
    first_name = @c.users[user_for_test].name.split(' ')[0]
    # set first name feild as not show
    @admin_profile_page.navigate_in
    @admin_profile_page.custom_profile_feild "First Name", {1 => true}
    @profile_page.goto_profile
    # eidt first name feild with empty text 
    @profile_page.profile_edit_button.when_present.click
    @browser.wait_until { @profile_page.profile_editor.present? }
    @profile_page.profile_editor.edit([{name: "First Name", value: ""}])
    @browser.wait_until { @browser.div(:class => "member-error-message", :text => /First Name is required/).present? }
    # eidt first name feild with "Watir" 
    @profile_page.profile_editor.edit([{name: "First Name", value: first_name}])
    @browser.execute_script("window.scrollBy(0,-1200)")
    # @browser.wait_until { @profile_page.profile_edit_button.present? }

    # require feild when register
    @login_page.logout!
  ensure
    # set first name feild as public
    @login_page.about_login("network_admin","logged")
    @admin_profile_page.navigate_in
    @admin_profile_page.custom_profile_feild "First Name", {2 => true }
  end

  def test_00090_add_feild_as_public_feild
    @admin_profile_page.navigate_in
    @admin_profile_page.custom_profile_feild "First Name", {2 => true}

    # user1 login and edit profile
    @login_page.about_login("regular_user1", "logged")
    @profile_page.goto_profile
    url = @browser.url

    @profile_page.profile_edit_button.when_present.click
    label = @profile_page.profile_editor.field_at_name "First Name"
    label.icon.when_present.click
    assert !(label.icon.attribute_value("class").include? "icon-hide")
    # user2 can see the public feild 
    @login_page.about_login("regular_user2", "logged")
    @browser.goto url
    @browser.wait_until { @profile_page.profile_page_author_name_betaon.present? }
    assert (@profile_page.profile_page_author_name_betaon.text.include? "Watir")
  ensure
    # set first name feild as public
    @login_page.about_login("network_admin","logged")
    @admin_profile_page.navigate_in
    @admin_profile_page.custom_profile_feild "First Name", {2 => true }
  end

  def test_00100_check_available_config_of_profile_feilds
    @admin_profile_page.navigate_in
    @admin_profile_page.check_available_config_of_profile_feilds
  ensure
    @admin_profile_page.custom_profile_feild "First Name", {2 => true }
  end

  user :regular_user1
  # Case #3: Check newly created question appears in Profile page as activity
  def test_00120_profilepage_check_new_activity_feed
    @topicdetail_page = @topiclist_page.go_to_topic("A Watir Topic")
    title = "Test q created by Watir - #{get_timestamp}"
    @topicdetail_page.create_conversation(type: :question,
                                          title: title,
                                          details: [{type: :text, content: "Watir test description"}])

    @profile_page.goto_profile
    @browser.wait_until { !@profile_page.question_list_in_activity_pane.activity_at_title(title).nil? }
    activity_card = @profile_page.question_list_in_activity_pane.activity_at_title(title)
    activity_card.click_conv_link
    @browser.wait_until { @convdetail_page.convdetail.present? }
    assert @convdetail_page.root_post_title.text =~ /#{title}/ 
  end

  # Case #4: Check conversation link text in activity tab is the correct title.
  def test_00130_profilepage_check_activity_feed_link
    @profile_page.goto_profile
    @browser.wait_until { @profile_page.profile_activity_item.present? }

    @browser.wait_until { @profile_page.question_list_in_activity_pane.activity_list.size > 0 }
    activity_card = @profile_page.question_list_in_activity_pane.activity_list[0]
    conv = activity_card.conv_title
    activity_card.click_conv_link

    @browser.wait_until { @convdetail_page.convdetail.present? }
    assert @convdetail_page.convdetail.text.include? conv
  end

  p2
  def test_00150_profilepage_check_footer_on_profile
    @profile_page.goto_profile
    @browser.execute_script("window.scrollBy(0,10000)")
    @browser.wait_until { @profile_page.footer.present? }
  end

  p1
  def test_00170_profilepage_check_show_more_button
    @profile_page.goto_profile
    skip if @browser.url.include? "betaon1"

    begin
      @profile_page.switch_to_tab(:questions)
      @browser.wait_until(10) { @profile_page.profile_questions_showmore_btn.present? }
      @profile_page.switch_to_tab(:replies)
      @browser.wait_until(10) { @profile_page.profile_replies_showmore_btn.present? }
    rescue
      puts "The number of questions or replies doesn't trigger the show more button"
      skip
    end 
  end

  def test_00180_profilepage_check_edit_profile_mode
    @profile_page.goto_profile
    @profile_page.profile_edit_button.when_present.click

    @browser.wait_until { @profile_page.profile_editor.present? }

    assert_all_keys({
      :personal_info_tab => @profile_page.profile_editor.personinfo_nav.present?,
      :work_info_tab => @profile_page.profile_editor.workinfo_nav.present?,
      :edit_button => !@profile_page.profile_edit_button.present?,
      :view_button => @profile_page.profile_view_button.present?
      })

    @profile_page.profile_editor.cancel_btn.when_present.click
    @browser.wait_until { @profile_page.profile_editor.present? }
    @browser.execute_script("window.scrollBy(0,-2000)")
    assert_all_keys({
      :edit_button => @profile_page.profile_edit_button.present?,
      :view_button => !@profile_page.profile_view_button.present?
      }) 
  end

  user :regular_user1
  def test_00190_profilepage_edit_bio_field
    @login_page.about_login("network_admin","logged")
    @admin_profile_page.navigate_in
    @admin_profile_page.custom_profile_feild "Bio", {2 => true }

    @login_page.about_login("regular_user1","logged")
    @profile_page.goto_profile
    bio = "Bio edited by Watir - #{@c.get_timestamp}"

    @profile_page.edit_profile([{name: "Bio", value: bio}])
    @browser.refresh
    @browser.wait_until { @profile_page.profile_bioinfo_line.present? && @profile_page.profile_bioinfo_line.text == bio }

    url = @browser.url
    @profile_page.about_login("regular_user2", "logged")
    @browser.goto url
    @browser.wait_until { @profile_page.profile_bioinfo_line.present? }
    assert @profile_page.profile_bioinfo_line.text == bio
  end

  def test_00280_profilepage_edit_profile_pic
    @profile_page.goto_profile

    @profile_page.profile_avatar_img.when_present.hover
    @profile_page.profile_avatar_camera.when_present.click

    @browser.wait_until { @profile_page.profile_pic_modal.present? }

    # verify all controls are visible in Upload Photo modal dialog
    assert_all_keys({
      :profile_pic_modal => @profile_page.profile_pic_modal.present?,
      :profile_pic_modal_title => @profile_page.profile_pic_modal_title.present?,
      :profile_pic_file_info => @profile_page.profile_pic_file_info.present?,

      :profile_pic_change_button => @profile_page.profile_pic_change_button.present?,
      :profile_pic_cancel_button => @profile_page.profile_pic_cancel_button.present?,
      :profile_pic_select_button => @profile_page.profile_pic_select_button.present?,
      :profile_pic_delete_button => @profile_page.profile_pic_delete_button.present?,
      :profile_pic_close_icon => @profile_page.profile_pic_close_icon.present?
    })

    @profile_page.profile_pic_filefield.set("#{@c.project_root}/seeds/development/images/profilepic.jpeg")
    
    @profile_page.profile_pic_select_button.when_present.click

    @browser.wait_until { !@profile_page.profile_pic_modal.present? }

    @browser.refresh
    @browser.wait_until { @profile_page.profile_pic_selected_img.present? }

    profile_image1 = @profile_page.profile_pic_selected_img.style

    assert_match /profilepic.jpeg/ , profile_image1, "profile image should match profilepic.jpeg"

    # delete profile picture
    @profile_page.profile_avatar_img.when_present.hover
    @profile_page.profile_avatar_camera.when_present.click


    @browser.wait_until { @profile_page.profile_pic_modal.present? }
    @browser.wait_until { @profile_page.profile_pic_delete_option.present? && !@profile_page.profile_pic_delete_option.disabled? }
    @profile_page.profile_pic_delete_option.when_present.click
    sleep 2 # without this sleep, the following click doesn't work
    @profile_page.profile_pic_delete_confirm_button.when_present.click
    sleep 2 # without this sleep, Selenium::WebDriver::Error::UnhandledAlertError happen sometimes.
    @profile_page.clean_up_modals! # this is a must. otherwise, alert will popup with following refresh
    @browser.refresh
    @browser.wait_until { @profile_page.profile_pic_selected_img.present? }
    assert_match /person_shadow/ , @profile_page.profile_pic_selected_img.style, "profile image is not the default shadow"
  ensure
    uuid = @profile_page.get_profile_uuid

    response = @c.api.post(@c.users[user_for_test],
      "/api/v1/OData/Members('#{uuid}')/FileDelete()",
      body: {"d": {"attribute": "profile_photo"}}.to_json,
      headers: {"Content-Type": "application/json"},

    )
    raise "unable to clean up profile pic via api" unless response.code == 204
    @profile_page.clean_up_modals!
  end

    #============ ANON USER TESTS ==========================#
  user :regular_user1
  p1
  def test_00300_profilepage_check_user_profile_as_anon
    @profile_page.goto_profile
    @browser.wait_until { @profile_page.profile_activity_item.present? }
    url = @browser.url
    @login_page.logout!
    @browser.goto url
    @browser.wait_until { @profile_page.profile_page.present? }
    assert_all_keys({
      :username => @profile_page.user_name.include?(@c.users[:regular_user1].name),
      :profile_edit_btn => !@profile_page.profile_edit_button.present?,
      :profile_view_btn => !@profile_page.profile_view_button.present?,
      })
    
    @profile_page.profile_avatar_img.when_present.hover
    assert !@profile_page.profile_avatar_camera.present?
  end
end
