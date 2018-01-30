require File.expand_path(File.dirname(__FILE__) + "/excelsior_watir_test.rb")
require File.expand_path(File.dirname(__FILE__) + "/../lib/test_helper.rb")
require File.expand_path(File.dirname(__FILE__) + "/../lib/page_objects/community_notification_page.rb")
require File.expand_path(File.dirname(__FILE__) + "/../lib/watir_lib.rb")

class NotificationPageTest < ExcelsiorWatirTest
  include WatirLib
  def setup
    super
    @notificationpage = CommunityNotificationPage.new(@browser)
  end

  #============ ANON USER TESTS ==========================#
  #=================================================================#

  #======== login page, log in with username or email, register, social login, etc. tests ============#
  def test_p1_00010_check_no_notification_for_anon
  	@notificationpage.check_no_notification_for_anon
  	assert !@notificationpage.notification.present?
    @notificationpage.newline
  end

#============ REGULAR USER TESTS ==========================#

  def test_p1_00020_check_notification_present
  	@notificationpage.check_notification
  	assert @notificationpage.notification.present?
    @notificationpage.newline
  end

  def test_p1_00030_check_notification_bell_and_count
  	@notificationpage.check_notification_bell
  	assert @notificationpage.notification_bell.present?

  	@notificationpage.check_notification_count
  	assert @notificationpage.notification_count.present?
    @notificationpage.newline
  end

  def test_p1_00040_check_notification_dropdown
  	@notificationpage.click_notification_for_dropdown
  	assert @notificationpage.notification_dp_open.present?
    @notificationpage.newline
  end

  def test_00050_check_user_img_in_notification_dp
    sleep 8
  	@notificationpage.check_notification_dp_user_img
    sleep 8
  	assert @notificationpage.convdetail.present?
    @notificationpage.newline
  end

  def test_p1_00060_check_row_in_notification_dp
  	@notificationpage.check_notification_dp_row
  	assert @notificationpage.notification_dp_row.present?
  	assert @notificationpage.notification_dp_row_txt.present?
  	assert @notificationpage.notification_dp_row_date.present?
    @notificationpage.newline
  end

  def test_p1_00070_check_label_in_notification_dp
  	@notificationpage.check_notification_dp_label
  	assert @notificationpage.notification_dp_label.present?
    @notificationpage.newline
  end

  def test_00080_check_mark_read_in_notification_dp
  	@notificationpage.check_notification_dp_mark_read
  	assert @notificationpage.notification_dp_read_all.present?
    @notificationpage.newline
  end

  def test_p1_00090_check_view_all_in_notification_dp
  	@notificationpage.check_notification_dp_view_all
  	assert @notificationpage.notification_dp_view_all.present?
    @notificationpage.newline
  end

  def test_p1_00091_click_view_all_in_notification_dp
  	@notificationpage.click_view_all_in_notification_dp 
  	assert @notificationpage.notification_pg.present?
    @notificationpage.newline
  end

  def test_p1_00100_goto_notification_conv_detail
  	@notificationpage.goto_notification_conv_detail
    @notificationpage.newline
  end

  def test_p1_00110_goto_notification_detail
  	@notificationpage.goto_notification_detail_pg
  	assert @notificationpage.notification_pg.present? 
    #assert @notification.notification_pg_block.present? 
    assert @notificationpage.notification_pg_row.present? 
    assert @notificationpage.notification_pg_read_all.present? 
    @notificationpage.newline
  end

  def test_p1_00120_check_notification_pg_title
  	@notificationpage.check_notification_detail_pg_title
  	assert @notificationpage.notification_pg_title.present?
    @notificationpage.newline
  end

  def test_p1_00130_check_row_in_notification_pg
  	@notificationpage.check_notification_detail_row
  	assert @notificationpage.notification_pg_row.present?
    @notificationpage.newline
  end

  def test_p1_00140_check_user_img_in_notification_pg
  	@notificationpage.check_notification_detail_user_img
    assert @notificationpage.notification_pg_row_img.exists?
    @notificationpage.newline
  end

  def test_p1_00150_check_user_link_in_notification_pg
  	@notificationpage.check_notification_detail_user_link
    @profilepage = CommunityProfilePage.new(@browser)
  	assert @profilepage.profile_page.present?
    @notificationpage.newline
  end

  def test_p1_00160_check_topic_link_in_notification_pg
  	@notificationpage.check_notification_detail_topic_link
    @topicdetailpage = CommunityTopicDetailPage.new(@browser)
  	assert ((@topicdetailpage.topicdetail.present?) || (@notificationpage.convdetail.present?) || ( !@notificationpage.notification_pg_row_topic_link1.present?) || ( !@notificationpage.notification_pg_row_topic_link2.present?))
    @notificationpage.newline
  end

  def test_p1_00170_check_show_more_in_notification_pg
  	@notificationpage.check_notification_detail_show_more
  	assert (@notificationpage.notification_pg_row.present?) || ( !@notificationpage.notification_pg_show_all.present?)
    @notificationpage.newline
  end

  def test_p1_00180_post_comment_highlevel_notification
  	@notificationpage.post_comment_highlevel_notification
    @notificationpage.newline
  end

  def test_p1_00190_stop_highlevel_notification
  	@notificationpage.stop_highlevel_notification
    @notificationpage.newline
  end

  def test_p1_00200_check_aggregated_like_notification
  	@notificationpage.check_aggregated_like_notification
    @notificationpage.newline
  end

  def test_p1_00210_check_featured_post_notification

  	@notificationpage.check_featured_post_notification
    @notificationpage.newline
  end

end