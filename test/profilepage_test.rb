require File.expand_path(File.dirname(__FILE__) + "/excelsior_watir_test.rb")
require File.expand_path(File.dirname(__FILE__) + "/../lib/test_helper.rb")
require File.expand_path(File.dirname(__FILE__) + "/../lib/page_objects/community_profile_page.rb")
require File.expand_path(File.dirname(__FILE__) + "/../lib/watir_lib.rb")

class ProfilePageTest < ExcelsiorWatirTest
  include WatirLib
  def setup
    super
    @profilepage = CommunityProfilePage.new(@browser)
  end

  #============ ANON USER TESTS ==========================#
  #=================================================================#

  #======== profile page, username, jobtitle, activity feed, banner, edit profile pic, edit profile bio field, etc. tests ============#
  def test_p1_00010_profilepage_profile_option
    if !@profilepage.profile_activity.present?
     @profilepage.goto_profile
    end
    if @profilepage.profile_pic_modal.present?
     @profilepage.profile_pic_cancel_button.click
     @browser.wait_until($t) { !@profilepage.profile_pic_modal.present? }
    end
  	@profilepage.check_profile_in_user_dropdown
  	assert @profilepage.profile_link.present? 
    @profilepage.newline
  end

  def test_p1_00020_profilepage_profile_page
    if !@profilepage.profile_page.present? || !@profilepage.profile_activity.present?
     @profilepage.goto_profile
    end
    if @profilepage.profile_pic_modal.present?
     @profilepage.profile_pic_cancel_button.click
     @browser.wait_until($t) { !@profilepage.profile_pic_modal.present? }
    end
  	@profilepage.goto_profile
  	assert @profilepage.profile_page.present?
    @profilepage.newline

  end

  def test_p1_00030_profilepage_check_username
  	if !@profilepage.profile_page.present? || !@profilepage.profile_activity.present?
  	 @profilepage.goto_profile
  	end
  	assert @profilepage.profile_page.present?
  	@profilepage.check_profile_username
  	assert @profilepage.profile_username.present?
    @profilepage.newline
  end

  def test_p1_00040_profilepage_check_jobtitle
  	if !@profilepage.profile_page.present? || !@profilepage.profile_activity.present?
  	 @profilepage.goto_profile
  	end
  	assert @profilepage.profile_page.present?
  	@profilepage.check_profile_jobtitle
  	assert @profilepage.profile_jobtitle.present?
    @profilepage.newline
  end

  def test_p1_00050_profilepage_check_membersince_date
  	if !@profilepage.profile_page.present? || !@profilepage.profile_activity.present?
  	 @profilepage.goto_profile
  	end
  	assert @profilepage.profile_page.present?
  	@profilepage.check_profile_membsersince
  	assert @profilepage.profile_membersince.present?
    @profilepage.newline
  end

  def test_p1_00060_profilepage_check_profile_pic_present
  	if !@profilepage.profile_page.present? || !@profilepage.profile_activity.present?
  	 @profilepage.goto_profile
  	end
  	assert @profilepage.profile_page.present?
  	@profilepage.check_profile_img
  	assert @profilepage.profile_img.present?
    @profilepage.newline
  end

  def test_p1_00070_profilepage_profile_banner
  	if !@profilepage.profile_page.present? || !@profilepage.profile_activity.present?
  	 @profilepage.goto_profile
  	end
  	assert @profilepage.profile_page.present?
  	@profilepage.check_profile_banner
  	assert @profilepage.profile_banner.present?
  	profile_banner_bg = @profilepage.profile_banner.style('background-color')
  	assert profile_banner_bg =~ /#cccccc/ || /rgba(204, 204, 204, 1)/
    @profilepage.newline
  end

  def test_p1_00080_profilepage_profile_pic_edit_icon
  	if !@profilepage.profile_page.present? || !@profilepage.profile_activity.present?
  	 @profilepage.goto_profile
  	end
  	assert @profilepage.profile_page.present?
  	@profilepage.check_profile_pic_edit_icon
  	assert @profilepage.profile_pic_edit_icon.present?
    @profilepage.newline
  end

  def test_p1_00090_profilepage_profile_edit_button
  	if !@profilepage.profile_page.present? || !@profilepage.profile_activity.present?
  	 @profilepage.goto_profile
  	end
  	assert @profilepage.profile_page.present?
  	@profilepage.check_edit_profile_button
  	assert @profilepage.profile_edit_button.present?
    @profilepage.newline
  end

  def test_p1_00100_profilepage_check_activity_title
  	if !@profilepage.profile_page.present? || !@profilepage.profile_activity.present?
  	 @profilepage.goto_profile
  	end
  	assert @profilepage.profile_page.present?
  	@profilepage.check_activity_title
  	assert @profilepage.profile_activity_title.present?
    @profilepage.newline
  end

  def test_p1_00110_profilepage_check_activity_feed
  	if !@profilepage.profile_page.present? || !@profilepage.profile_activity.present?
  	 @profilepage.goto_profile
  	end
  	assert @profilepage.profile_page.present?
  	@profilepage.check_activity_feed
  	assert @profilepage.profile_activity.present?
    @profilepage.newline
  end

  def test_p1_00130_profilepage_check_activity_feed_link
  	if !@profilepage.profile_page.present? || !@profilepage.profile_activity.present?
  	 @profilepage.goto_profile
  	end
  	assert @profilepage.profile_page.present?
  	@profilepage.check_activity_feed_link
  	assert @profilepage.convdetail.present?
    @profilepage.newline
  end

  def test_p1_00120_profilepage_check_new_activity_feed
  	if !@profilepage.profile_page.present? || !@profilepage.profile_activity.present?
  	 @profilepage.goto_profile
  	end
  	assert @profilepage.profile_page.present?
  	conv_title = @profilepage.create_conversation($network, $networkslug, "A Watir Topic", "question_with_link", "Q with link created by Watir for profile test - #{get_timestamp}", false)
  	@profilepage.check_new_activity_feed
  	assert @profilepage.convdetail.present?
    @profilepage.newline
  end

  def test_p1_00140_profilepage_check_topnav_on_profile
  	if !@profilepage.profile_page.present? || !@profilepage.profile_activity.present?
  	 @profilepage.goto_profile
  	end
  	assert @profilepage.profile_page.present?
  	@profilepage.check_topnav_on_profile("logged")
  	
  	assert @profilepage.topnav_home.present? 
    assert @profilepage.topnav_topic.present? 
    assert @profilepage.topnav_product.present? 
    assert @profilepage.topnav_about.present?  
    assert @profilepage.topnav_search.present? 
    assert @profilepage.topnav_logo.present?  
    @profilepage.newline
  end

  def test_00150_profilepage_check_footer_on_profile
  	if !@profilepage.profile_page.present? || !@profilepage.profile_activity.present?
  	 @profilepage.goto_profile
  	end
  	assert @profilepage.profile_page.present?
  	@profilepage.check_footer_on_profile
    @homepage = CommunityHomePage.new(@browser)
  	assert @homepage.footer.present?
    @profilepage.newline
  end

  def test_00160_profilepage_check_browser_tab_title
  	if !@profilepage.profile_page.present? || !@profilepage.profile_activity.present?
  	 @profilepage.goto_profile
  	end
  	assert @profilepage.profile_page.present?
  	@profilepage.check_browser_tab_title
    @profilepage.newline
  end

  def test_p1_00170_profilepage_check_show_more_button
  	if !@profilepage.profile_page.present? || !@profilepage.profile_activity.present?
  	 @profilepage.goto_profile
  	end
  	assert @profilepage.profile_page.present?
  	@profilepage.check_show_more
  	assert @profilepage.profile_show_more_button.present?
    @profilepage.newline
  end

  def test_p1_00180_profilepage_check_edit_profile_mode
  	if !@profilepage.profile_page.present? || !@profilepage.profile_activity.present?
  	 @profilepage.goto_profile
  	end
  	assert @profilepage.profile_page.present?
  	@profilepage.edit_profile_mode
  	assert @profilepage.profile_edit_mode.present?
    @profilepage.newline
  end

  def test_p1_00190_profilepage_edit_bio_field
  	if !@profilepage.profile_page.present? || !@profilepage.profile_activity.present?
  	 @profilepage.goto_profile
  	end
  	assert @profilepage.profile_page.present?
  	@profilepage.edit_bio_field
    @profilepage.newline
  end

  def test_p1_00200_profilepage_check_personal_info_tab
  	if !@profilepage.profile_page.present? || !@profilepage.profile_activity.present?
  	 @profilepage.goto_profile
  	end
  	assert @profilepage.profile_page.present?
  	@profilepage.check_personal_info_tab
  	assert @profilepage.profile_personal_info_tab.present?
    @profilepage.profile_field_cancel_button.click
    @browser.wait_until($t) { !@profilepage.profile_edit_mode.present? }
    @profilepage.newline
  end

  def test_00210_profilepage_check_personal_info_icon
  	if !@profilepage.profile_page.present? || !@profilepage.profile_activity.present? 
  	 @profilepage.goto_profile
  	end
  	if @profilepage.profile_edit_mode.present?
  	 @profilepage.profile_field_save_button.click
  	 @browser.wait_until($t) { @profilepage.profile_page.present? }
  	end
  	assert @profilepage.profile_page.present?
  	@profilepage.check_personal_info_icon
  	assert @profilepage.profile_personal_info_icon.present?
    @profilepage.profile_field_cancel_button.click
    @browser.wait_until($t) { !@profilepage.profile_edit_mode.present? }
    @profilepage.newline
  end

  def test_p1_00220_profilepage_check_work_info_tab
  	if !@profilepage.profile_page.present? || !@profilepage.profile_activity.present?
  	 @profilepage.goto_profile
  	end
  	if @profilepage.profile_edit_mode.present?
  	 @profilepage.profile_field_save_button.click
  	 @browser.wait_until($t) { @profilepage.profile_page.present? }
  	end
  	assert @profilepage.profile_page.present?
  	@profilepage.check_work_info_tab
  	assert @profilepage.profile_work_info_tab.present?
    @profilepage.profile_field_cancel_button.click
    @browser.wait_until($t) { !@profilepage.profile_edit_mode.present? }
    @profilepage.newline
  end

  def test_00230_profilepage_check_work_info_icon
  	if !@profilepage.profile_page.present? || !@profilepage.profile_activity.present?
  	 @profilepage.goto_profile
  	end
  	if @profilepage.profile_edit_mode.present?
  	 @profilepage.profile_field_save_button.click
  	 @browser.wait_until($t) { @profilepage.profile_page.present? }
  	end
  	assert @profilepage.profile_page.present?
  	@profilepage.check_work_info_icon
  	assert @profilepage.profile_work_info_icon.present?
    @profilepage.profile_field_cancel_button.click
    @browser.wait_until($t) { !@profilepage.profile_edit_mode.present? }
    @profilepage.newline
  end

  def test_p1_00240_profilepage_goto_profile_pic_edit
  	if !@profilepage.profile_page.present? || !@profilepage.profile_activity.present?
  	 @profilepage.goto_profile
  	end
  	if @profilepage.profile_pic_modal.present?
  	 @profilepage.profile_pic_cancel_button.click
  	 @browser.wait_until($t) { @profilepage.profile_page.present? }
  	end
  	assert @profilepage.profile_page.present?
  	@profilepage.goto_edit_profile_pic
  	assert @profilepage.profile_pic_modal.present?
    @profilepage.newline
  end

  def test_p1_00250_profilepage_check_edit_pic_modal_title
  	if !@profilepage.profile_page.present? || !@profilepage.profile_activity.present?
  	 @profilepage.goto_profile
  	end
  	if @profilepage.profile_pic_modal.present?
  	 @profilepage.profile_pic_cancel_button.click
  	 @browser.wait_until($t) { !@profilepage.profile_pic_modal.present? }
  	end
  	assert @profilepage.profile_page.present?
  	@profilepage.goto_edit_profile_pic
  	@profilepage.check_edit_profile_pic_modal_title
  	assert @profilepage.profile_pic_modal_title.present?
    @profilepage.newline
  end

  def test_00260_profilepage_check_edit_pic_modal_info
  	if !@profilepage.profile_page.present? || !@profilepage.profile_activity.present?
  	 @profilepage.goto_profile
  	end
  	if @profilepage.profile_pic_modal.present?
  	 @profilepage.profile_pic_cancel_button.click
  	 @browser.wait_until($t) { !@profilepage.profile_pic_modal.present? }
  	end
  	assert @profilepage.profile_page.present?
  	@profilepage.goto_edit_profile_pic
  	@profilepage.check_edit_profile_pic_modal_info
  	assert @profilepage.profile_pic_file_info.present?
    @profilepage.profile_pic_cancel_button.click
    @browser.wait_until($t) { !@profilepage.profile_pic_modal.present? }
    @profilepage.newline
  end

  def test_p1_00270_profilepage_check_edit_pic_modal_footer_button_and_close_icon
  	if !@profilepage.profile_page.present? || !@profilepage.profile_activity.present?
  	 @profilepage.goto_profile
  	end
  	if @profilepage.profile_pic_modal.present?
  	 @profilepage.profile_pic_cancel_button.click
  	 @browser.wait_until($t) { !@profilepage.profile_pic_modal.present? }
  	end
  	assert @profilepage.profile_page.present?
  	@profilepage.goto_edit_profile_pic
  	@profilepage.check_edit_profile_pic_modal_footer_button_and_close_icon
  	assert @profilepage.profile_pic_change_button.present? 
    assert @profilepage.profile_pic_cancel_button.present?
    assert @profilepage.profile_pic_select_button .present?
    assert @profilepage.profile_pic_delete_button.present? 

    assert @profilepage.profile_pic_close_icon.present? 
    @profilepage.profile_pic_cancel_button.click
    @browser.wait_until($t) { !@profilepage.profile_pic_modal.present? }
    @profilepage.newline

  end

  def test_p1_00280_profilepage_edit_profile_pic
  	if !@profilepage.profile_page.present? || !@profilepage.profile_activity.present?
  	 @profilepage.goto_profile
  	end
  	if @profilepage.profile_pic_modal.present?
  	 @profilepage.profile_pic_cancel_button.click
  	 @browser.wait_until($t) { !@profilepage.profile_pic_modal.present? }
  	end
  	assert @profilepage.profile_page.present?
  	@profilepage.edit_profile_pic
    @profilepage.newline
  end

  def test_p1_00290_profilepage_delete_profile_pic
  	if !@profilepage.profile_page.present? || !@profilepage.profile_activity.present?
  	 @profilepage.goto_profile
  	end
  	if @profilepage.profile_pic_modal.present?
  	 @profilepage.profile_pic_cancel_button.click
  	 @browser.wait_until($t) { !@profilepage.profile_pic_modal.present? }
  	end
  	assert @profilepage.profile_page.present?
  	@profilepage.delete_profile_pic
    @profilepage.newline
  end

  def test_p1_00300_profilepage_check_user_profile_as_anon
  	if !@profilepage.profile_page.present? || !@profilepage.profile_activity.present?
  	 @profilepage.goto_profile
  	end
  	if @profilepage.profile_pic_modal.present?
  	 @profilepage.profile_pic_cancel_button.click
  	 @browser.wait_until($t) { !@profilepage.profile_pic_modal.present? }
  	end
  	assert @profilepage.profile_page.present?
  	@profilepage.check_another_user_profile_as_anon
    @profilepage.newline
  end

 end