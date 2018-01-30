require 'pages/community'
require 'minitest/assertions'

class Pages::Community::Notification < Pages::Community
  def initialize(config, options = {})
    super(config)
    @url = config.base_url + "/n/#{config.slug}"
  end

  def start!(user)
    @topicdetail_page = Pages::Community::TopicDetail.new(@config)
    super(user, @url, @topicdetail_page.topic_page)
  end

  # notification_url                  { "#{@@base_url}" + "/n/#{@@slug}/" }
  notification 					            { link(:class => "dropdown-toggle notification") }
  notification_bell 			          { i(:css => ".dropdown-toggle.notification .fa-bell-o") }
  notification_count 				        { span(:css => ".dropdown-toggle.notification .bubble") }

  notification_dropdown 		      	{ div(:css => ".notification-dropdown") }
  notification_dp_open 			      	{ div(:css =>  ".dropdown.nav-notification.open") }
  notification_dp_label 			      { div(:class => "label", :text => "Notifications") }
  # notification_dp_row 				      { div(:class => /open/).div(:class => "panel panel-default notification-panel").div(:class => /ember-view notification-item notification-item/).div(:class => "body") }
  notification_dp_row               { div(:css => ".notification-popup .notification-item") }
  notification_popup_first_row      { div(:css => ".notification-popup .notification-item", :index => 0) }
  notification_popup_first_row_txt  { div(:css => ".notification-popup .notification-item", :index => 0).span(:css => ".body .text").text }
  notification_popup_second_row_txt { div(:css => ".notification-popup .notification-item", :index => 1).span(:css => ".body .text").text }
  notification_popup_first_row_span { div(:css => ".notification-popup .notification-item", :index => 0).span(:css => ".body .text") }

  notification_dp_read_all 		     	{ div(:class => "mark-all-read").link(:text => "Mark All Read") }
  notification_dp_row_img           { img(:css => ".notification-popup .avatar-container img") }
  notification_dp_row_txt 			    { span(:css => ".notification-popup .notification-item .body .text") }
  notification_dp_row_date 			    { span(:css => ".notification-popup .notification-item .body .date") }
  notification_dp_view_all 			    { div(:class => "panel-footer show-all-link", :text => "View All") }

  notification_link 				        { div(:css => ".notification-popup .notification-item") }

  notification_pg 					        { div(:class =>  "notification-block row") }
  notification_pg_title 			      { h3(:class => "notification-list-title", :text => "Notifications") }
  notification_pg_block 			      { div(:class => "col-xs-12 col-sm-12 col-md-12 col-lg-12").div(:class =>  /ember-view notification-item notification-item/) }
  notification_pg_read_all 			    { div(:class => "mark-all-read-page pull-right").link(:text => "Mark All Read") }
  notification_pg_row 				      { div(:css => ".notification-block .notification-item") }
  notification_pg_row_img 			    { img(:class => "media-object thumb-32") }
  notification_pg_row_user_link 	  { div(:css => ".notification-block .notification-item").link(:href => /profile/, :text => /.*\S.*/) }
  notification_pg_row_topic_link    { link(:css => ".notification-block .notification-item .topic-title a") }
  notification_pg_row_conv_link     { div(:css => ".notification-block").link(:href => /\/(question|blog|review)\//) }
  notification_pg_old_items         { divs(:css => ".notification-page .notification-block.row:last-of-type .notification-item") }


  notification_pg_show_all 			    { button(:css => ".show-more-notification") }

  notification_panel_footer 		    { div(:class => "panel-footer show-all-link") }

  def check_no_notification_for_anon
    @about_page = Pages::Community::About.new(@config)
    @browser.goto @about_page.about_url
    @browser.wait_until { !notification.present? }
  end

  def check_notification
    @browser.wait_until { notification.present? }
  end

  def check_notification_bell
    @browser.wait_until { notification_bell.present? }
  end

  def check_notification_count
    @browser.wait_until { notification_count.present? }
  end

  def click_notification_for_dropdown
    notification.when_present.click unless notification_dp_row.present?

    # sometimes, no notification item is expected.
    start_time = Time.now
    while Time.now - start_time < 20
      break if notification_dp_row.present?
      sleep 1
    end
    # @browser.wait_until { notification_dp_row.present? }
  end

  def check_notification_dp_user_img
    click_notification_for_dropdown
    @browser.wait_until { notification_dp_row_img.present? }
    notification_dp_row_img.click
    @convdetail_page = Pages::Community::ConversationDetail.new(@config)
    @browser.wait_until { @convdetail_page.root_post.present? || @convdetail_page.convdetail.present? || @convdetail_page.conv_page.present? }
  end

  def wait_until_dp_row_present
    @browser.wait_until { notification_dp_row.present? }
    @browser.wait_until { notification_dp_row_txt.present? }
    @browser.wait_until { notification_dp_row_date.present? }
  end

  # def check_notification_dp_mark_read
  #   click_notification_for_dropdown
  #   @browser.wait_until { notification_dp_read_all.present? }
  # end

  # def check_notification_dp_view_all
  #   click_notification_for_dropdown
  #   @browser.wait_until { notification_dp_view_all.present? }
  # end  

  def click_view_all_in_notification_dp
    click_notification_for_dropdown
    @browser.wait_until { notification_panel_footer.present? }
    notification_dp_view_all.when_present.click
    @browser.wait_until { notification_pg.present? }
  end

  def check_notification_dp_label
    click_notification_for_dropdown
    @browser.wait_until { notification_dp_label.present? }
  end

  def goto_notification_detail_pg
    click_view_all_in_notification_dp

    @browser.wait_until { notification_pg_row.present? }
    @browser.wait_until { notification_pg_read_all.present? }
  end

  def check_notification_detail_pg_title
    @login_page = Pages::Community::Login.new(@config)
    @login_page.accept_policy_warning
    click_view_all_in_notification_dp
    @browser.wait_until { notification_pg_title.present? }
  end

  def check_notification_detail_row
    click_view_all_in_notification_dp
    @browser.wait_until { notification_pg_row.present? }
  end

  def check_notification_detail_user_img
    click_view_all_in_notification_dp
    @browser.wait_until { notification_pg_row_img.exists? }
  end

  def check_notification_detail_user_link
    click_view_all_in_notification_dp
    @browser.wait_until { notification_pg_row_user_link.present? }

    username = notification_pg_row_user_link.text
    notification_pg_row_user_link.click
    @profile_page = Pages::Community::Profile.new(@config)

    @browser.wait_until { @profile_page.profile_page.present? }
    profile_username = @profile_page.user_name
    assert_match username, profile_username, "Wrong user profile"
  end

  def check_notification_detail_topic_link
    @topicdetail_page = Pages::Community::TopicDetail.new(@config)
    @profile_page = Pages::Community::Profile.new(@config)
    @convdetail_page = Pages::Community::ConversationDetail.new(@config)
    click_view_all_in_notification_dp

    # considering that there might be no topic link yet while run the currect test.
    # check the link in these priorities (1: Topic, 2: Conversation, 3: Profile)
    check_link_type = nil
    begin
      @browser.wait_until { notification_pg_row_topic_link.present? }
      check_link_type = :topic
    rescue Watir::Wait::TimeoutError
      begin 
        @browser.wait_until { notification_pg_row_conv_link.present? }
        check_link_type = :conversation
      rescue Watir::Wait::TimeoutError
        begin
          @browser.wait_until { notification_pg_row_user_link.present? }
          check_link_type = :profile
        rescue Watir::Wait::TimeoutError
          check_link_type = nil
        end  
      end  
    end 

    case check_link_type
    when :topic  
      topicname_in_notification = notification_pg_row_topic_link.when_present.text
      notification_pg_row_topic_link.click
      @browser.wait_until { @topicdetail_page.topicdetail.present? }
      topicname_in_topicdetail = @topicdetail_page.topicname.text
      assert_match topicname_in_notification, topicname_in_topicdetail, "Wrong topic"
    when :conversation
      convname_in_notification = notification_pg_row_conv_link.when_present.text
      notification_pg_row_conv_link.click
      convname_in_convdetail = @convdetail_page.convdetail.when_present.text
      assert_match convname_in_notification, convname_in_convdetail, "Wrong conversation"
    when :profile
      username_in_notification = notification_pg_row_user_link.text
      notification_pg_row_user_link.click
      @browser.wait_until { @profile_page.profile_page.present? }
      username_in_profile = @profile_page.profile_username.text
      assert_match username_in_notification, username_in_profile, "Wrong user profile"
    else
      raise "Cannot find any links to navigate in Notification page"
    end 
  end

  def check_notification_detail_show_more
    click_view_all_in_notification_dp
    @browser.execute_script("window.scrollBy(0,10000)")
    accept_policy_warning

    @browser.wait_until { notification_pg_show_all.present? || notification_pg_old_items.size < 20 }
    # Show All button available only when number of old notification items exceeds 20
    assert notification_pg_show_all.present? || notification_pg_old_items.size < 20
    return if notification_pg_old_items.size < 20
    @browser.wait_until { notification_pg_show_all.present? }
    notification_pg_show_all.click
    @browser.wait_until { notification_pg_row.present? || !notification_pg_show_all.present? }
  end

  def post_comment_highlevel_notification
    @convdetail_page = Pages::Community::ConversationDetail.new(@config)
    @login_page = Pages::Community::Login.new(@config)
    @topiclist_page = Pages::Community::TopicList.new(@config)
    topic_name = "A Watir Topic For Notification"
    # admin go to the specific topic
    @topicdetail_page = @topiclist_page.go_to_topic(topic_name)

    # open the first existing question
    @topicdetail_page.goto_conversation(type: :question)
    authorname = @convdetail_page.conv_detail_authorname.when_present.text
    # @topicdetailpage = CommunityTopicDetailPage.new(@browser)

    # follow the root post if unfollowed before
    @convdetail_page.follow_root_post

    # logout
    @login_page.logout!

    about_login("nf_regular_user2", "logged")

    # go to the specific topic
    @topicdetail_page = @topiclist_page.go_to_topic(topic_name)

    # open the first question
    @topicdetail_page.goto_conversation(type: :question)
    if @convdetail_page.comment_level1.present?
      @browser.wait_until { @convdetail_page.comment_level1.present? }
      # @topicdetailpage = CommunityTopicDetailPage.new(@browser)
      @topicdetail_page.sort_post_by_newest
    end
    @browser.wait_until { @convdetail_page.convdetail.present? }

    # sort_by_new_in_conversation_detail
    @browser.wait_until { !@convdetail_page.spinner.present? }

    # create a reply to the question
    reply = "Reply on root posted by #{@c.users[:nf_regular_user2].name} - #{get_timestamp}"
    @convdetail_page.reply_box.when_present.focus
    @browser.wait_until { @convdetail_page.reply_submit.present? }

    @convdetail_page.reply_box.when_present.set reply
    @convdetail_page.reply_submit_button.when_present.click
    @browser.wait_until { !@convdetail_page.reply_submit_button.present? }
    @browser.wait_until { !@convdetail_page.spinner.present? }

    @browser.wait_until($t) { @convdetail_page.conv_reply_view.text.include? reply }
    @login_page.logout!

    # login with the author of the question
    # need to trim ... since triple dot will appear when author name is long
    authorname = authorname.gsub(/\./, "")
    author = @c.users.users.values.find { |u| u.name.include?(authorname) }
    raise "User #{authorname} is not defined in config" if author.nil?
    login(author)

    @browser.wait_until { notification.present? && !@login_page.layout_loading_block.present? }
    notification.when_present.click
    @browser.wait_until { notification_dropdown.present? }

    if notification_dp_open.present?
      assert notification_dp_row_txt.text.downcase.include? @c.users[:nf_regular_user2].name.downcase + " replied to "
      # EN-2958: sometimes "in a few seconds" displayed.
      # assert (notification_dp_row_date.text.include? "a few seconds ago") || (notification_dp_row_date.text.include? "a minute ago")|| (notification_dp_row_date.text.include? "minutes ago")
      puts notification_dp_row_date.text
      assert (notification_dp_row_date.text.downcase =~ /a few seconds/) || (notification_dp_row_date.text.downcase.include? "a minute ago")|| (notification_dp_row_date.text.downcase.include? "minutes ago")
    end
    @login_page.logout!
  end

  def stop_highlevel_notification
    @topicdetail_page = Pages::Community::TopicDetail.new(@config)
    @convdetail_page = Pages::Community::ConversationDetail.new(@config)
    @topiclist_page = Pages::Community::TopicList.new(@config)
    @login_page = Pages::Community::Login.new(@config)
    topic_name = "A Watir Topic For Notification"
    # login with admin
    # go to the specific topic
    @topicdetail_page = @topiclist_page.go_to_topic(topic_name)

    # open the first blog
    @topicdetail_page.goto_conversation(type: :blog)
    @browser.wait_until { @convdetail_page.conv_reply_view.present? }

    blog_url = @browser.url

    # unfollow it if it is followed
    @convdetail_page.unfollow_root_post

    # logout
    @browser.wait_until {
      Pages::Community::Layout.new(@config).user_dropdown.present?
    }
    Pages::Community::Layout.new(@config).user_dropdown.click

    @login_page.log_out.when_present.click
    @browser.wait_until { @login_page.signin_link.present? }
    @browser.wait_until { !@login_page.layout_loading_block.present? }
    assert @login_page.signin_link.present?

    # login with 
    about_login("nf_regular_user1", "logged")
    @browser.goto blog_url
    @browser.wait_until { @convdetail_page.conv_detail.present? } 

    reply = "Reply on root posted by #{@c.users[:nf_regular_user1].name} - #{get_timestamp}"
    @convdetail_page.reply_box.when_present.focus

    @browser.wait_until { @convdetail_page.reply_submit.present? }
    @convdetail_page.reply_box.when_present.set reply

    @convdetail_page.reply_submit_button.when_present.click
    @browser.wait_until { @convdetail_page.level1_reply.present? }
    assert @convdetail_page.level1_reply.present?

    @convdetail_page.sort_comments(by: :newest)
    @browser.wait_until { @convdetail_page.conv_reply_view.text.include? reply }
    @login_page.logout!

    about_login("nf_topic_admin", "logged")
    # @browser.refresh
    notification.when_present.click
    @browser.wait_until { notification_dp_row.present? }
    assert !(notification_dp_row_txt.text.include? @c.users[:nf_regular_user1].name + " replied to your post: " )
    assert !(notification_dp_row_date.text.include? "a few seconds ago" ) || !(notification_dp_row_date.text.include? "a minute ago")

    @browser.goto blog_url
    @browser.wait_until { @convdetail_page.conv_detail.present? } 

    # follow the conversation
    @convdetail_page.follow_root_post
  end

  def check_aggregated_like_notification
    @topicdetail_page = Pages::Community::TopicDetail.new(@config)
    @convdetail_page = Pages::Community::ConversationDetail.new(@config)
    @login_page = Pages::Community::Login.new(@config)
    @topiclist_page = Pages::Community::TopicList.new(@config)
    topic_name = "A Watir Topic For Notification"
    # about_login("network_admin", "logged")
    # @topicdetail_page.goto_topicdetail_page("engagement")
    # go to the specific topic
    @topicdetail_page = @topiclist_page.go_to_topic(topic_name)

    @topicdetail_page.create_conversation(type: :blog, 
                                          title: "Blog created by Watir for like notification - #{get_timestamp}", 
                                          details: [{type: :text, content: "Watir test description"}])
    conv_url = @browser.url
    @login_page.logout!

    about_login("nf_topic_moderator", "logged")
    @browser.goto conv_url

    @browser.wait_until { @convdetail_page.convdetail.present? }

    # click unlike if current is unlike
    @convdetail_page.unlike_root_post

    # like the blog
    @convdetail_page.like_root_post

    @login_page.logout!

    about_login("nf_regular_user1", "logged")
    @browser.goto conv_url
    @browser.wait_until { @convdetail_page.convdetail.present? }

    # click unlike if current is unlike
    @convdetail_page.unlike_root_post

    # like the blog
    @convdetail_page.like_root_post

    @login_page.logout!

    about_login("nf_topic_admin", "logged")
    # @browser.refresh
    notification.when_present.click

    @browser.wait_until { notification_dp_row.present? }
    assert notification_dp_open.present?
    assert ((notification_dp_row_txt.text.downcase.include? @c.users[:nf_topic_moderator].name.downcase + " and " + @c.users[:nf_regular_user1].name.downcase + " liked your post: ") || (notification_dp_row_txt.text.downcase.include? @c.users[:nf_regular_user1].name.downcase+" and "+@c.users[:nf_topic_moderator].name.downcase+" liked your post: "))
    # EN-2958: sometimes "in a few seconds" displayed.
    # assert (notification_dp_row_date.text.include? "a few seconds ago") || (notification_dp_row_date.text.include? "a minute ago")|| (notification_dp_row_date.text.include? "minutes ago")
    assert (notification_dp_row_date.text.downcase =~ /a few seconds/) || (notification_dp_row_date.text.downcase.include? "a minute ago")|| (notification_dp_row_date.text.downcase.include? "minutes ago")
  end

  #due to EN-2694, now change feature question to feature blog
  def check_featured_post_notification
    @topicdetail_page = Pages::Community::TopicDetail.new(@config)
    @convdetail_page = Pages::Community::ConversationDetail.new(@config)
    @login_page = Pages::Community::Login.new(@config)
    @topiclist_page = Pages::Community::TopicList.new(@config)
    topic_name = "A Watir Topic For Notification"
    about_login("nf_topic_moderator", "logged")
    # go to the specific topic
    @topicdetail_page = @topiclist_page.go_to_topic(topic_name)

    @topicdetail_page.create_conversation(type: :blog, 
                                          title: "Blog created by Watir for feature notification - #{get_timestamp}", 
                                          details: [{type: :text, content: "Watir test description"}])
    @login_page.logout!
    about_login("nf_topic_admin", "logged")
    @topicdetail_page = @topiclist_page.go_to_topic(topic_name)
    @topicdetail_page.goto_conversation(type: :blog)
    # @topicdetailpage = CommunityTopicDetailPage.new(@browser)
    if @convdetail_page.root_post_feature.present?
      @convdetail_page.unfeature_root_post
    end
    @convdetail_page.feature_root_post
    # @topicdetailpage = CommunityTopicDetailPage.new(@browser)
    @browser.wait_until { @convdetail_page.root_post_feature.present? }
    @login_page.logout!
    about_login("nf_topic_moderator", "logged")
    notification.when_present.click
    @browser.wait_until { notification_dp_row.present? }
    assert notification_dp_open.present?

    # Try again when there might be some delay sometimes. 
    if !notification_dp_row_txt.text.include?(@c.users[:nf_topic_admin].name + " featured ")
      @browser.refresh
      # try again
      notification.when_present.click
      @browser.wait_until { notification_dp_row.present? }
    end  

    assert notification_dp_row_txt.text.downcase.include? @c.users[:nf_topic_admin].name.downcase + " featured "
    # EN-2958: sometimes "in a few seconds" displayed.
    # assert (notification_dp_row_date.text.include? "a few seconds ago") || (notification_dp_row_date.text.include? "a minute ago") || (notification_dp_row_date.text.include? "minutes ago")
    assert (notification_dp_row_date.text.downcase =~ /a few seconds/) || (notification_dp_row_date.text.downcase.include? "a minute ago") || (notification_dp_row_date.text.downcase.include? "minutes ago") 
    @login_page.logout!
  end

  def check_blogger_notification
    @admin_perm_page = Pages::Community::AdminPermissions.new(@config)
    @convdetail_page = Pages::Community::ConversationDetail.new(@config)
    # @admin_perm_page.promote_user_role(@config.network_name, @config.slug, @config.users[:nf_network_blogger], "blogger")
    about_login("nf_topic_admin", "logged")
    notification.when_present.click
    @browser.wait_until { notification_dp_row.present? }
    assert notification_dp_open.present?
    assert notification_dp_row_txt.text.include? "There is a blog post"
    assert (notification_dp_row_date.text.include? "a few seconds ago") || (notification_dp_row_date.text.include? "a minute ago") || (notification_dp_row_date.text.include? "minutes ago")
    # @browser.wait_until { notification_panel_footer.present? }
    first_link = notification_dp_row
    @browser.wait_until { first_link.present? }
    first_link.click
    @browser.wait_until { @convdetail_page.convdetail.present? }
    # byebug
    @browser.wait_until { @convdetail_page.conv_blog_alert.present? }
    @login_page.logout!
    # @admin_perm_page.revert_user_role(@config.network_name, @config.slug, @config.users[:nf_network_blogger], "blogger")
  end

  def get_first_popup_notification_text(user: nil)
    @about_page = Pages::Community::About.new(@config)
    @about_page.about_login(user, 'logged') unless user.nil?
    check_notification_count
    assert notification_count.present?
    click_notification_for_dropdown
    wait_until_dp_row_present
    @browser.wait_until { notification_popup_first_row.present? }
    notification_popup_first_row_txt
  end

  def get_first_two_popup_notifications_text(user: nil)
    @about_page = Pages::Community::About.new(@config)
    @about_page.about_login(user, 'logged') unless user.nil?
    check_notification_count
    assert notification_count.present?
    click_notification_for_dropdown
    wait_until_dp_row_present
    @browser.wait_until { notification_popup_first_row.present? }
    return notification_popup_first_row_txt, notification_popup_second_row_txt
  end

  def mark_first_popup_notification_as_read(user: nil)
    @about_page = Pages::Community::About.new(@config)
    @about_page.about_login(user, 'logged') unless user.nil?
    check_notification_count
    assert notification_count.present?
    click_notification_for_dropdown
    wait_until_dp_row_present
    @browser.wait_until { notification_popup_first_row.present? }
    @browser.wait_until { notification_popup_first_row_span.present? }
    notification_popup_first_row_span.when_present.click
    @browser.wait_until { !notification_popup_first_row_span.present? }
  end

end
