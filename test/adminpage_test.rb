require File.expand_path(File.dirname(__FILE__) + "/excelsior_watir_test.rb")
require File.expand_path(File.dirname(__FILE__) + "/../lib/test_helper.rb")
require File.expand_path(File.dirname(__FILE__) + "/../lib/page_objects/community_admin_page.rb")
require File.expand_path(File.dirname(__FILE__) + "/../lib/watir_lib.rb")

class AdminPageTest < ExcelsiorWatirTest
  include WatirLib
  def setup
    super
    @adminpage = CommunityAdminPage.new(@browser)    
  end

  #============ ANON/REGULAR/ADMIN USER TESTS ==========================#
  #=================================================================#

  #======== admin link, admin options, user permission etc. tests ============#

  def test_p1_00010_check_no_admin_for_reg
    @adminpage.check_no_admin_option_for_reg
    assert !@adminpage.admin_link.present?	
    @adminpage.newline
  end

  def test_00020_check_admin_role
    @adminpage.check_admin_role 
    assert @adminpage.admin_link.present?  
    @adminpage.newline
  end

  def test_p1_00030_check_admin_option
    @adminpage.check_admin_option 
    assert @adminpage.admin_page_link.present?
    @adminpage.newline
  end

  def test_p1_00040_goto_admin_page
    @adminpage.goto_admin_page
    assert @adminpage.admin_page.present?
    puts $adminurl = @browser.url
    @adminpage.newline 
  end

  def test_p1_00050_check_topic_default_on_admin_page
    @adminpage.check_topic_default_on_admin_page 
    assert @adminpage.admin_page.present?
    assert @adminpage.admin_page_left_nav.present? 
    @adminpage.newline
  end

  def test_p1_00060_check_topic_edit
    @adminpage.check_topic_edit_option
    @topicdetailpage = CommunityTopicDetailPage.new(@browser) 
    assert @adminpage.admin_page.present? || @topicdetailpage.topicdetail.present?
    @adminpage.newline
  end

  def test_p1_00070_click_topic_view
    @adminpage.check_topic_view_option
    @topicdetailpage = CommunityTopicDetailPage.new(@browser) 
    assert @topicdetailpage.topicdetail.present?
    @adminpage.newline
  end

  def test_p1_00080_check_topic_last_activity_column
    @adminpage.check_topic_last_activity_column 
    assert @adminpage.topic_last_activity.text =~ /Last activity:/
    @adminpage.newline
  end

  def test_p1_00090_check_topic_feature_column
    @adminpage.check_topic_feature_column 
    assert @adminpage.topic_feature_icon.present? 
    @adminpage.newline
  end

  def test_p1_00100_check_topic_img_in_topic_list
    @adminpage.check_topic_img_in_topic_list 
    assert @adminpage.topic_img.present? || @adminpage.topic_no_avatar_img.present?
    @adminpage.newline
  end

  def test_p1_00110_check_new_topic_button_present
    @adminpage.check_new_topic_button_present 
    assert @adminpage.topic_new.present?
    @adminpage.newline
  end

  def test_p1_00120_check_new_topic_button_works
    @adminpage.check_new_topic_button_works 
    assert @adminpage.admin_page.present?
    @adminpage.newline
  end

  def test_00130_check_homepage_option
    @adminpage.check_homepage_option 
    assert @adminpage.home_view.present?
    assert @adminpage.home_edit.present?
    @adminpage.newline
  end

  def test_p1_00140_check_homepage_view
    @adminpage.check_homepage_view 
    @homepage = CommunityHomePage.new(@browser)
    assert @homepage.home.present? 
    @adminpage.newline
  end

  def test_p1_00150_check_homepage_edit
    @adminpage.check_homepage_edit 
    @homepage = CommunityHomePage.new(@browser)
    assert @homepage.homebanner_editmode.present? 
    @adminpage.newline
  end

  def test_00160_check_aboutpage_option
    @adminpage.check_aboutpage_option 
    assert @adminpage.about_view.present? 
    assert @adminpage.about_edit.present? 
    @adminpage.newline
  end

  def test_p1_00170_check_aboutpage_view
    @adminpage.check_aboutpage_view 
    @aboutpage = CommunityAboutPage.new(@browser)
    assert @aboutpage.about_widget.present? 
    @adminpage.newline
  end

  def test_p1_00180_check_aboutpage_edit
    @adminpage.check_aboutpage_edit 
    @aboutpage = CommunityAboutPage.new(@browser)
    assert @aboutpage.about_edit_mode.present?
    @adminpage.newline
  end

  def test_00190_check_3rd_party_analytics_option
    @adminpage.check_3rd_party_analytics_option
    assert @adminpage.analytic_page.present?
    assert @adminpage.analytic_submit.present?
    @adminpage.newline
  end

  def test_00200_check_advertising_option_present
    @adminpage.check_advertising_option_present
    assert @adminpage.advertising_google_button.present? 
    @adminpage.newline
  end

  def xtest_00210_check_advertising_option_work
    @adminpage.check_advertising_option_work 
    assert @adminpage.google_embed_id.present? 
    @adminpage.newline
  end

  def test_p1_SET2_00220_check_mod_option
    @adminpage.check_moderation_option
    assert @adminpage.mod_threshold_link.present?
    assert @adminpage.flagged_post_link.present?
    assert @adminpage.perm_removed_link.present?
    @adminpage.newline
  end

  def test_p1_SET2_00230_check_mod_threshold_tab
    @adminpage.check_mod_threshold_tab 
    assert @adminpage.mod_threshold_save_button.present?
    assert @adminpage.mod_threshold_field.present?
    @adminpage.newline
  end

  def test_p1_SET2_00240_set_mod_threshold
    @adminpage.set_moderation_threshold_with_low
    assert @adminpage.mod_success_msg.present?
    @adminpage.newline
  end

  def test_p1_SET2_00250_flag_a_post
    @adminpage.flag_a_post 
    @adminpage.newline
  end

  def test_p1_SET2_00260_check_flagged_post_tab
    @adminpage.check_flagged_post_tab 
    assert @adminpage.flagged_post_link.present?
    assert @adminpage.mod_flagged_post.present?
    @adminpage.newline
  end

  def test_p1_SET2_00270_check_permanently_removed_post_tab
    @adminpage.check_permanently_removed_post_tab
    @adminpage.newline
  end

  def test_00280_check_profanity_blocker_tab
    @adminpage.check_profanity_blocker_tab 
    if !@adminpage.enable_profanity_button.present?
     assert @adminpage.mod_profanity_page.present?
     assert @adminpage.profanity_disable_button.present? 
     assert @adminpage.profanity_import_button.present? 
     assert @adminpage.profanity_download_button.present?
    else
     assert @adminpage.enable_profanity_button.present? 
    end
    @adminpage.newline
  end

  def test_00290_check_legal_disclosure_tab
    @adminpage.check_legal_disclosure_tab 
    assert @adminpage.footer_text.present? 
    assert @adminpage.footer_input.present?
    assert @adminpage.legal_head_text.present?
    @adminpage.newline
  end

  def test_00300_check_legal_preview_publish
   @adminpage.check_legal_preview_publish
   assert @adminpage.legal_publish_button.present?
   assert @adminpage.legal_preview_button.present? 
   @adminpage.legal_publish_button.click 
   @browser.wait_until($t) { @adminpage.legal_publish_confirm_button.present? }
   @adminpage.legal_publish_confirm_button.when_present.click
   @browser.wait_until($t) { @adminpage.legal_confirm_msg.present? }
   @adminpage.newline
  end

  def test_p1_00310_set_footer
   @adminpage.set_footer 
   @homepage = CommunityHomePage.new(@browser)
   assert @homepage.footer.text.include? $footer_link 
   @adminpage.newline
  end

  def xtest_p1_00320_set_privacy_contact_imprint_and_tou
   @adminpage.set_privacy_contact_imprint_and_tou
   #@adminpage.legal_publish_button.click  
   #@browser.wait_until($t) { @adminpage.legal_publish_confirm_button.present? }
   #@adminpage.legal_publish_confirm_button.when_present.click
   #@browser.wait_until($t) { @adminpage.legal_confirm_msg.present? }
   @adminpage.newline
  end

  def test_00330_check_legal_cookie_msg
   @adminpage.check_legal_cookie_msg 
   assert @adminpage.legal_cookie_msg.present?
   assert @adminpage.legal_show_cookie_msg_button.present?
   @adminpage.policy_warning 
   @adminpage.legal_publish_button.click 
   @browser.wait_until($t) { @adminpage.legal_publish_confirm_button.present? }
   @adminpage.legal_publish_confirm_button.when_present.click
   @browser.wait_until($t) { @adminpage.legal_confirm_msg.present? }
   @adminpage.newline
  end

  def test_00340_set_legal_cookie_msg
   @adminpage.set_legal_cookie_msg 
   @adminpage.policy_warning 
   @adminpage.legal_publish_button.click 
   @browser.wait_until($t) { @adminpage.legal_publish_confirm_button.present? }
   @adminpage.legal_publish_confirm_button.when_present.click
   @browser.wait_until($t) { @adminpage.legal_confirm_msg.present? }
   @adminpage.policy_warning
   @adminpage.newline
  end

  def test_p1_00350_check_branding_tab
   @adminpage.check_branding_tab 
   assert @adminpage.branding_page.present?
   assert @adminpage.branding_heading.present?
   @adminpage.newline
  end

  def test_p1_00360_set_branding_logo
   @adminpage.set_branding_logo 
   @adminpage.newline
  end

  def test_p1_00370_change_link_color
   @adminpage.change_link_color 
   @adminpage.newline
  end

  def test_p1_00371_change_button_color
   @adminpage.change_button_color 
   @adminpage.newline
  end

  def test_p1_00372_set_favicon
    #Commenting out this test for now, as the URL used in the method "set_favicon" to set favicon is instead getting saved to "title color" under Live chat, which is causing EN-2160. Test needs to be fixed. 
    @adminpage.set_favicon 
    @adminpage.newline
  end

  def test_00380_check_widget_theme_builder
   @adminpage.check_widget_theme_builder 
   assert @adminpage.widget_theme_page.present? 
   assert @adminpage.widget_theme_create_button.present? || @adminpage.widget_theme_edit_button.present?
   @adminpage.newline
  end

  def test_p1_00390_check_email_designer_option
   @adminpage.check_email_designer_option
   assert @adminpage.email_designer_page.present?
   assert @adminpage.email_designer_edit_button.present? 
   @adminpage.newline
  end

  def test_p1_00400_edit_email_template
   @adminpage.edit_email_template 
   assert @adminpage.email_designer_page.present? 
   @adminpage.newline
  end

  def test_00410_check_profile_field_option
   @adminpage.profile_field_option 
   assert @adminpage.profile_field_page.present?
   @adminpage.newline
  end

  def test_p1_SET2_00420_check_permission_option
    @adminpage.check_permission_option 
    assert @adminpage.permission_card.present? 
    @adminpage.newline
  end

  def test_p1_SET2_00660_promote_a_user_as_net_admin
    @adminpage.promote_a_user_as_net_admin
    @adminpage.newline
  end

  def test_p1_SET2_00670_promote_a_user_as_net_mod
    @adminpage.promote_a_user_as_net_mod
    @adminpage.newline
  end

  def test_p1_SET2_00680_promote_a_user_as_topic_admin
    @adminpage.promote_a_user_as_topic_admin
    @adminpage.newline
  end

  def test_p1_SET2_00690_promote_a_user_as_topic_mod
    @adminpage.promote_a_user_as_topic_mod
    @adminpage.newline
  end

  def test_00470_check_reports_option
    @adminpage.check_reports_option 
    assert @adminpage.pageview_graph.present? 
    assert @adminpage.pop_content.present? 
    assert @adminpage.responsiveness.present? 
    assert @adminpage.traffic.present? 
    assert @adminpage.business.present? 
    assert @adminpage.liveliness.present? 
    assert @adminpage.members.present? 
    assert @adminpage.interaction.present? 
    assert @adminpage.pageview_export_button.present? 
    @adminpage.newline
  end

  def test_00480_check_page_view_weekly
    @adminpage.check_page_view_weekly 
    assert @adminpage.pageview_weekly_yearly_graph.present? 
    @adminpage.newline
  end

  def test_00490_check_page_view_monthly
    @adminpage.check_page_view_monthly 
    assert @adminpage.pageview_weekly_yearly_graph.present?
    @adminpage.newline
  end

  def test_00500_check_page_view_yearly
    @adminpage.check_page_view_yearly 
    assert @adminpage.pageview_weekly_yearly_graph.present?
    @adminpage.newline
  end

  def test_00510_check_pop_content_weekly
    @adminpage.check_pop_content_weekly
    assert @adminpage.pop_pie_conv.present? 
    assert @adminpage.pop_pie_conv_title.present? 
    assert @adminpage.pop_pie_info.present? 
    assert @adminpage.pop_pie_topic_title.present? 
    assert @adminpage.pop_pie_topic.present? 
    assert @adminpage.pop_text.present? 
    @adminpage.newline
  end

  def test_00520_check_pop_content_monthly
    @adminpage.check_pop_content_monthly 
    assert @adminpage.pop_pie_monthly_conv.present? 
    assert @adminpage.pop_pie_conv_title.present? 
    assert @adminpage.pop_pie_info.present? 
    assert @adminpage.pop_pie_topic_title.present? 
    #assert @adminpage.pop_pie_topic.present? 
    #assert @adminpage.pop_text.present? 
    @adminpage.newline
  end

  def test_00530_check_responsiveness
    @adminpage.check_responsiveness 
    assert @adminpage.resp_chart.present?
    assert @adminpage.resp_pie_title.present? 
    assert @adminpage.resp_text.present?
    @adminpage.newline
  end

  def test_00540_check_traffic
    @adminpage.check_traffic 
    assert @adminpage.traffic_return_user.present?
    assert @adminpage.traffic_return_user_graph.present?
    @adminpage.newline
  end

  def test_00550_check_business_comm_cta
    @adminpage.check_business_comm_cta
    assert @adminpage.business_community_cta_graph.present? 
    assert @adminpage.business_community_cta_weekly.present?
    @adminpage.newline
  end

  def test_00560_check_business_hybris_cta
    @adminpage.check_business_hybris_cta
    assert @adminpage.business_hybris_cta_graph.present?
    @adminpage.newline
  end

  def test_00570_check_liveliness
    @adminpage.check_liveliness 
    assert @adminpage.liveliness_table.present?
    @adminpage.newline
  end

  def test_00580_check_members_new_users
    @adminpage.check_members_new_users
    assert @adminpage.members_new_regis_user_graph.present?
    @adminpage.newline
  end

  def test_00590_check_members_post_growth
    @adminpage.check_members_post_growth 
    assert @adminpage.members_post_growth_graph.present?
    @adminpage.newline
  end

  def test_00600_check_interaction
    @adminpage.check_interaction 
    assert @adminpage.interaction_graph.present?
    @adminpage.newline
  end

  def test_p1_00610_check_hybris_option
    @adminpage.check_hybris_option 
    assert @adminpage.ecomm_int_page.present? 
    @adminpage.newline
  end

  def test_p1_00620_check_hybris_config_tab
    @adminpage.check_hybris_config_tab 
    assert @adminpage.ecomm_int_config_page.present? 
    assert @adminpage.ecomm_int_save_button.present? 
    assert @adminpage.ecomm_int_sync_button.present? 
    @adminpage.newline
  end

  def test_00630_check_hybris_history_tab
    @adminpage.check_hybris_history_tab 
    assert @adminpage.ecomm_int_history_page.present? 
    assert @adminpage.ecomm_int_history_resync_button.present? 
    @adminpage.newline
  end

  def test_00640_check_oauth_config_option
    @adminpage.check_oauth_config_option
    assert @adminpage.oauth_page.present? 
    assert @adminpage.oauth_page_new_app_button.present? 
    @adminpage.newline
  end

  def test_p1_00650_check_oauth_new_app_field_and_button
    @adminpage.check_oauth_new_app_field_and_button
    assert @adminpage.oauth_new_app_name_field.present? 
    assert @adminpage.oauth_new_app_save_button.present? 
    assert @adminpage.oauth_new_app_cancel_button.present? 
    @adminpage.newline
  end
end
