require File.expand_path(File.dirname(__FILE__) + "/page_object.rb")

class CommunityNotificationPage < PageObject
 
  attr_accessor :notification,
  :notification_bell,
  :notification_count,
  :notification_dp_open,
  :notification_dp_row,
  :notification_dp_row_txt,
  :notification_dp_row_date,
  :notification_dp_label,
  :notification_dp_read_all,
  :notification_pg,
  :notification_pg_block,
  :notification_pg_row,
  :notification_pg_read_all,
  :notification_pg_title,
  :notification_pg_row_img,
  :notification_pg_show_all,
  :notification_dp_view_all,
  :notification_pg_row_topic_link1,
  :notification_pg_row_topic_link2


  def initialize(browser)
    super
    @notification = @browser.link(:class => "dropdown-toggle notification")
    @notification_bell = @browser.link(:class => "dropdown-toggle notification").i(:class => "fa fa-bell-o")
    @notification_count = @browser.link(:class => "dropdown-toggle notification").span(:class => "bubble")

    @notification_dropdown = @browser.div(:class => "ember-view notification-item notification-item").div(:class => "body")
    @notification_dp_open = @browser.div(:class =>  "dropdown nav-notification  open")
    @notification_dp_label = @browser.div(:class => "label", :text => "Notifications")
    @notification_dp_row = @browser.div(:class => /open/).div(:class => "panel panel-default notification-panel").div(:class => /ember-view notification-item notification-item/).div(:class => "body")
    @notification_dp_read_all = @browser.div(:class => "mark-all-read").link(:text => "Mark All Read")
    @notification_dp_row_img = @browser.img(:class => "media-object thumb-48")
    @notification_dp_row_txt = @browser.div(:class => "ember-view notification-item notification-item new").div(:class => "body").span(:class => "text")
    @notification_dp_row_date = @browser.div(:class => "ember-view notification-item notification-item new").div(:class => "body").span(:class => "date")
    @notification_dp_view_all = @browser.div(:class => "panel-footer show-all-link", :text => "View All")

    @notification_link = @browser.div(:class => "notification-popup").div(:class => "ember-view notification-item notification-item")

    @notification_pg = @browser.div(:class =>  "notification-block row")
    @notification_pg_title = @browser.h3(:class => "notification-list-title", :text => "Notifications")
    @notification_pg_block = @browser.div(:class => "col-xs-12 col-sm-12 col-md-12 col-lg-12").div(:class =>  /ember-view notification-item notification-item/)
    @notification_pg_read_all = @browser.div(:class => "mark-all-read-page pull-right").link(:text => "Mark All Read")
    @notification_pg_row = @browser.div(:class => "notification-block row").div(:class => "col-xs-12 col-sm-12 col-md-12 col-lg-12").div(:class => /ember-view notification-item notification-item/).div(:class => "body")
    @notification_pg_row_img = @browser.img(:class => "media-object thumb-32")
    @notification_pg_row_user_link = @browser.div(:class => "notification-block row").div(:class => "col-xs-12 col-sm-12 col-md-12 col-lg-12").div(:class => /ember-view notification-item notification-item/).div(:class => "body").span(:class => "text").link(:index => 0)
    @notification_pg_row_topic_link1 = @browser.div(:class => "notification-block row").div(:class => "col-xs-12 col-sm-12 col-md-12 col-lg-12").div(:class => "ember-view notification-item notification-item").div(:class => "body").span(:class => "text").link(:index => 1)
    @notification_pg_row_topic_link2 = @browser.div(:class => "notification-block row").div(:class => "col-xs-12 col-sm-12 col-md-12 col-lg-12").div(:class => "ember-view notification-item notification-item").div(:class => "body").span(:class => "text").link(:index => 2)

    @notification_pg_show_all = @browser.button(:class => " btn btn-default btn-lg btn-block show-more-notification", :text => "Show more")

    @notification_panel_footer = @browser.div(:class => "panel-footer show-all-link")
  end

  def check_no_notification_for_anon
    @loginpage = CommunityLoginPage.new(@browser)
  	if @loginpage.username.present?
     signout
    end 
    @aboutpage = CommunityAboutPage.new(@browser)
    @browser.goto @aboutpage.about_url
  	@browser.wait_until($t) { !@notification.present? }
  end

  def check_notification
    @loginpage = CommunityLoginPage.new(@browser)
  	if !@loginpage.username.present?
      about_login("regular", "logged")
    end
  	@browser.wait_until($t) { @notification.present? }
  end

  def check_notification_bell
     @loginpage = CommunityLoginPage.new(@browser)
  	if !@loginpage.username.present?
      about_login("regular", "logged")
    end
     @browser.wait_until($t) { @notification_bell.present? }
  end

  def check_notification_count
     @loginpage = CommunityLoginPage.new(@browser)
  	if !@loginpage.username.present?
     about_login("regular", "logged")
    end
     @browser.wait_until($t) { @notification_count.present? }
  end

  def click_notification_for_dropdown
     @loginpage = CommunityLoginPage.new(@browser)
  	if !@loginpage.username.present?
     about_login("regular", "logged")
    end
    if !@notification_dp_row.present?
     @notification.click
     @browser.wait_until($t) { @notification_dp_row.present? }
   	else
     @browser.wait_until($t) { @notification_dp_row.present? }
    end 
   # @notifurl = @browser.url
   end

  def check_notification_dp_user_img
  	click_notification_for_dropdown
    if !@notification_dp_row.present?
     @notification.click
    end
  	@browser.wait_until($t) { @notification_dp_row_img.present? }
  	assert @notification_dp_row_img.present?
  	@notification_dp_row_img.click
  	@browser.wait_until($t) { @root_post.present? || @convdetail.present? || @conv_page.present? }
  end

  def check_notification_dp_row
  	click_notification_for_dropdown
  	@browser.wait_until($t) { @notification_dp_row.present? }
  	@browser.wait_until($t) { @notification_dp_row_txt.present? }
  	@browser.wait_until($t) { @notification_dp_row_date.present? }
  end

  def check_notification_dp_mark_read
  	click_notification_for_dropdown
  	@browser.wait_until($t) { @notification_dp_read_all.present? }
  end

  def check_notification_dp_view_all
  	click_notification_for_dropdown
  	@browser.wait_until($t) { @notification_dp_view_all.present? }
  end

  def click_view_all_in_notification_dp
  	click_notification_for_dropdown
  	@browser.wait_until($t) { @notification_dp_view_all.present? }
  	@notification_dp_view_all.when_present.click
  	@browser.wait_until($t) { @notification_pg.present? }
  end

  def check_notification_dp_label
  	click_notification_for_dropdown
  	@browser.wait_until($t) { @notification_dp_label.present? }
  end

  def goto_notification_conv_detail
    about_login("regis2", "logged")
    goto_topicdetail_page("engagement")
    choose_post_type("blog")
    conversation_detail("blog")
    title = @conv_title.text
    reply = "Reply on root posted by Watir User2 - #{get_timestamp}"
    @reply_box.when_present.focus
    @browser.wait_until($t) { @reply_submit.exists? }

    @reply_box.when_present.set reply
    @reply_submit_button.when_present.click
    sort_by_new_in_conversation_detail
    
    @browser.wait_until($t) { @conv_reply_input.present? }
    signout

    about_landing($network)
    about_login("regular", "logged")
    @notification.when_present.click
    @browser.wait_until { @notification_panel_footer.present? }
    first_link = @notification_dp_row
    @browser.wait_until($t) { first_link.present? }
    first_link.click
    @browser.wait_until($t) { @convdetail.present? }
    @browser.wait_until($t) { @convdetail.text =~ /#{title}/ }
    assert @convdetail.text =~ /#{title}/
  end

  def goto_notification_detail_pg
  	about_landing($network)
    about_login("regular", "logged")
    @notification.when_present.click
    sleep 3
    @browser.wait_until($t) { @notification_panel_footer.present? }
    @notification_dp_view_all.when_present.click

    @browser.wait_until($t) { @notification_pg.present? }
    @browser.wait_until($t) { @notification_pg_row.present? } 
    @browser.wait_until($t) { @notification_pg_read_all.present? }

  end

  def check_notification_detail_pg_title
    @loginpage = CommunityLoginPage.new(@browser)
  	if !@loginpage.username.present?
     about_login("regular", "logged")
    end
    @loginpage.policy_warning
    @notification.when_present.click
    sleep 3
    @browser.wait_until($t) { @notification_panel_footer.present? }
    @notification_dp_view_all.when_present.click

    @browser.wait_until($t) { @notification_pg.present? }
    @browser.wait_until($t) { @notification_pg_title.present? }
  end

  def check_notification_detail_row
    @loginpage = CommunityLoginPage.new(@browser)
  	if !@loginpage.username.present?
     about_login("regular", "logged")
    end
    @notification.when_present.click
    sleep 3
    @browser.wait_until($t) { @notification_panel_footer.present? }
    @notification_dp_view_all.when_present.click

    @browser.wait_until($t) { @notification_pg.present? }
    @browser.wait_until($t) { @notification_pg_row.present? }
  end

  def check_notification_detail_user_img
    @loginpage = CommunityLoginPage.new(@browser)
  	if !@loginpage.username.present?
     about_login("regular", "logged")
    end
    @notification.when_present.click
    sleep 3
    @browser.wait_until($t) { @notification_panel_footer.present? }
    @notification_dp_view_all.when_present.click

    @browser.wait_until($t) { @notification_pg.present? }
    @browser.wait_until($t) { @notification_pg_row_img.exists? }

  end

  def check_notification_detail_user_link
    @loginpage = CommunityLoginPage.new(@browser)
  	if !@loginpage.username.present?
     about_login("regular", "logged")
    end
    @notification.when_present.click
    sleep 3
    @browser.wait_until($t) { @notification_panel_footer.present? }
    @notification_dp_view_all.when_present.click

    @browser.wait_until($t) { @notification_pg.present? }
    #byebug
    @browser.wait_until($t) { @notification_pg_row_user_link.present? }
    
    username = @notification_pg_row_user_link.text
    @notification_pg_row_user_link.click
    @profilepage = CommunityProfilePage.new(@browser)
    @browser.wait_until($t) { @profilepage.profile_page.present? }
    profile_username = @profilepage.profile_username.text
    assert_match username, profile_username, "Wrong user profile"
  end

  def check_notification_detail_topic_link
    @loginpage = CommunityLoginPage.new(@browser)
  	if !@loginpage.username.present?
     about_login("regis2", "logged")
    end
    @notification.when_present.click
    @browser.wait_until($t) { @notification_panel_footer.present? }
    @notification_dp_view_all.when_present.click

    @browser.wait_until($t) { @notification_pg.present? }
    if @notification_pg_row_topic_link1.present?
    @browser.wait_until($t) { @notification_pg_row_topic_link1.present? || @notification_pg_row_user_link.present? }
    puts topicname = @notification_pg_row_topic_link1.text

    
    @notification_pg_row_topic_link1.click 
    @topicdetailpage = CommunityTopicDetailPage.new(@browser)
    @profilepage = CommunityProfilePage.new(@browser)
    @browser.wait_until($t) { @topicdetailpage.topicdetail.present? || @convdetail.present? || @profilepage.profile_page.present? }
   	if @convdetail.present?
    topicname_detail = @convdetail.text
    assert_match topicname, topicname_detail, "Wrong conversation"
	 else
    @topicdetailpage = CommunityTopicDetailPage.new(@browser)
	  topicname_detail = @topicdetailpage.topicname.text
	  assert_match topicname, topicname_detail, "Wrong topic"
	 end
   @profilepage = CommunityProfilePage.new(@browser)
	 if @profilepage.profile_page.present?
	  @notification.when_present.click
    @browser.wait_until($t) { @notification_panel_footer.present? }
    @notification_dp_view_all.when_present.click

    @browser.wait_until($t) { @notification_pg.present? }

    @browser.wait_until($t) { @notification_pg_row_topic_link.present? || @notification_pg_row_user_link.present? }
    topicname = @notification_pg_row_topic_link2.text
    @notification_pg_row_topic_link2.click 
    @topicdetailpage = CommunityTopicDetailPage.new(@browser)
    @browser.wait_until($t) { @topicdetailpage.topicdetail.present? }
    topicname_detail = @topicdetailpage.topicname.text
	  assert_match topicname, topicname_detail, "Wrong topic"
   end
   assert !@notification_pg_row_topic_link1.present? || !@notification_pg_row_topic_link2.present?
end

  end

  def check_notification_detail_show_more
    @loginpage = CommunityLoginPage.new(@browser)
  	if !@loginpage.username.present?
     about_login("regular", "logged")
    end
    @notification.when_present.click
    @browser.wait_until($t) { @notification_panel_footer.present? }
    @notification_dp_view_all.when_present.click

    @browser.wait_until($t) { @notification_pg.present? }
    @browser.execute_script("window.scrollBy(0,10000)")
    policy_warning

    @browser.wait_until($t) { @notification_pg_show_all.present? }
    @notification_pg_show_all.click
    @browser.wait_until($t) { @notification_pg_row.present? || !@notification_pg_show_all.present? }
  end

  def post_comment_highlevel_notification
    about_login("regular", "logged")
    admin_check($networkslug)
    goto_topicdetail_page("engagement")
    choose_post_type("discussion")
    conversation_detail("discussion")
    @browser.wait_until($t) { @convdetail.present? }
    authorname = @conv_detail_authorname.text
    @topicdetailpage = CommunityTopicDetailPage.new(@browser)

    if @topicdetailpage.follow_disc_element.present? #added check for admin follow for root post
    @topicdetailpage.follow_disc_element.when_present.click
    @browser.wait_until($t) { @topicdetailpage.unfollow_disc_element.present? }
    end
    signout

    about_login("regis2", "logged")
    goto_topicdetail_page("engagement")
    choose_post_type("discussion")
    conversation_detail("discussion")
    if @comment_level1.present?
     @browser.wait_until($t) { @comment_level1.present? }
     @topicdetailpage = CommunityTopicDetailPage.new(@browser)
     @topicdetailpage.sort_post_by_newest
    end
    @browser.wait_until($t) { @convdetail.present? }
    
    #sort_by_new_in_conversation_detail
    @browser.wait_until($t) { !@spinner.present? }
    reply = "Reply on root posted by Watir User2 - #{get_timestamp}"
    @reply_box.when_present.focus
    @browser.wait_until($t) { @reply_submit.present? }

    @reply_box.when_present.set reply
    @reply_submit_button.when_present.click
    @browser.wait_until ($t) { !@reply_submit_button.present? }
    @browser.wait_until($t) { !@spinner.present? }
    
    
    @browser.wait_until($t) { @conv_reply_view.text.include? reply }
    signout

    about_landing($network)
    @loginpage = CommunityLoginPage.new(@browser)
    if authorname == $user1[3]
     @loginpage.login($user1)
    end
    if authorname == $user2[3]
     @loginpage.login($user2)
    end
    if authorname == $user3[3]
     @loginpage.login($user3)
    end
    if authorname == $user4[3]
     @loginpage.login($user3)
    end
    if authorname == $user12[3]
     @loginpage.login($user3)
    end
    
    @notification.when_present.click
    @browser.wait_until($t) { @notification_dropdown.present? }
  
    if @notification_dp_open.present?
       assert @notification_dp_row_txt.text.include? $user4[3]+" replied to "
       assert (@notification_dp_row_date.text.include? "a few seconds ago") || (@notification_dp_row_date.text.include? "a minute ago")|| (@notification_dp_row_date.text.include? "minutes ago")
    end
    signout
  end

  def stop_highlevel_notification
    about_login("regular", "logged")
    admin_check($networkslug)
    goto_topicdetail_page("engagement")
    choose_post_type("blog")
    conversation_detail("blog")
    @browser.wait_until($t) { @conv_reply_view.present? }
    @topicdetailpage = CommunityTopicDetailPage.new(@browser)
    if @topicdetailpage.unfollow_disc_element.present?
    @topicdetailpage.unfollow_disc_element.when_present.click
    @browser.wait_until($t) { @topicdetailpage.follow_disc_element.present? }
    end
    @adminpage = CommunityAdminPage.new(@browser)
    @browser.wait_until($t) {
      @adminpage.caret.present?
    }
    @adminpage.caret.click
    @loginpage = CommunityLoginPage.new(@browser)
    @loginpage.signout_link.when_present.click
    @browser.wait_until($t) { @loginpage.signin_link.present? }
   	assert @loginpage.signin_link.present?

    about_login("regis4", "logged")
    goto_topicdetail_page("engagement")
    choose_post_type("blog")
    conversation_detail("blog")
    
    reply = "Reply on root posted by Watir User4 - #{get_timestamp}"
    @reply_box.when_present.focus

    @browser.wait_until($t) { @reply_submit.present? }
    @reply_box.when_present.set reply

    @reply_submit_button.when_present.click
    @browser.wait_until($t) { @level1_reply.present? }
    assert @level1_reply.present?

    sort_by_new_in_conversation_detail
    @browser.wait_until($t){ @conv_reply_view.text.include? reply }
    signout
    about_landing($network)
    about_login("admin", "logged")
    #@browser.refresh
    @notification.when_present.click
    @browser.wait_until($t) { @notification_dp_row.present? }
    assert !(@notification_dp_row_txt.text.include? $user12[3]+" replied to your post: " )
    assert !(@notification_dp_row_date.text.include? "a few seconds ago" ) || !(@notification_dp_row_date.text.include? "a minute ago")

    about_login("regular", "logged")
    goto_topicdetail_page("engagement")
    choose_post_type("blog")
    conversation_detail("blog")
    @topicdetailpage = CommunityTopicDetailPage.new(@browser)
    @topicdetailpage.follow_disc_element.when_present.click
    @browser.wait_until($t) { @topicdetailpage.unfollow_disc_element.present? }
  end

  def check_aggregated_like_notification
    topic_name = "A Watir Topic"
    about_login("regular", "logged")
    goto_topicdetail_page("engagement")
    create_conversation($network, $networkslug, topic_name, "blog", "Blog created by Watir for like notification - #{get_timestamp}", false)
    conv_url = @browser.url
    signout

    about_login("mod", "logged")
    @browser.goto conv_url
    
    @browser.wait_until { @convdetail.present? }
    @topicdetailpage = CommunityTopicDetailPage.new(@browser)
    if @topicdetailpage.unlike_disc_element.present?
         @topicdetailpage.unlike_disc_element.when_present.click
         @browser.wait_until($t) { @topicdetailpage.like_disc_element.present? }
    end
    assert @topicdetailpage.like_disc_element.present?
    @topicdetailpage.like_disc_element.when_present.click
    @browser.wait_until($t) { @topicdetailpage.unlike_disc_element.present? }
    assert @topicdetailpage.unlike_disc_element.present?
    signout

    about_login("regis", "logged")
    @browser.goto conv_url
    
    @browser.wait_until { @convdetail.present? }
    @topicdetailpage = CommunityTopicDetailPage.new(@browser)
    if @topicdetailpage.unlike_disc_element.present?
     @topicdetailpage.unlike_disc_element.when_present.click
     sleep 1
     @browser.wait_until($t) { @topicdetailpage.like_disc_element.present? }
    end
    assert @topicdetailpage.like_disc_element.present?
    @topicdetailpage.like_disc_element.when_present.click
    @browser.wait_until($t) { @topicdetailpage.unlike_disc_element.present? }
    assert @topicdetailpage.unlike_disc_element.present?
    signout

    about_login("regular", "logged")
    #@browser.refresh
    @notification.when_present.click
    
    @browser.wait_until($t) { @notification_dp_row.present? }
    assert @notification_dp_open.present?
    assert ((@notification_dp_row_txt.text.include? $user2[3]+" and "+$user3[3]+" liked your post: ") || (@notification_dp_row_txt.text.include? $user3[3]+" and "+$user2[3]+" liked your post: "))
    assert (@notification_dp_row_date.text.include? "a few seconds ago") || (@notification_dp_row_date.text.include? "a minute ago")|| (@notification_dp_row_date.text.include? "minutes ago")

  end

  def check_featured_post_notification
  	topic_name = "A Watir Topic"
    about_login("regis", "logged")
   
    create_conversation($network, $networkslug, topic_name, "discussion", "Discussion created by Watir for feature notification - #{get_timestamp}", false)
    signout
    about_login("regular", "logged")
    goto_topicdetail_page("engagement")
    choose_post_type("discussion")
    conversation_detail("discussion")
    @topicdetailpage = CommunityTopicDetailPage.new(@browser)
    if @topicdetailpage.root_post_feature.present?
     unfeature_root_post
    end
    feature_root_post
    @topicdetailpage = CommunityTopicDetailPage.new(@browser)
    @browser.wait_until($t) { @topicdetailpage.root_post_feature.present? }
    signout
    about_login("regis", "logged")
    @notification.when_present.click
    @browser.wait_until($t) { @notification_dp_row.present? }
    assert @notification_dp_open.present?
    assert @notification_dp_row_txt.text.include? $user1[3]+" featured "
    assert (@notification_dp_row_date.text.include? "a few seconds ago") || (@notification_dp_row_date.text.include? "a minute ago")|| (@notification_dp_row_date.text.include? "minutes ago")
    signout
  end

  end