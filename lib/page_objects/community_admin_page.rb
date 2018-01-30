require File.expand_path(File.dirname(__FILE__) + "/page_object.rb")

class CommunityAdminPage < PageObject
 
  attr_accessor :admin_option, :admin_page, 
  :admin_page_link, :admin_page_left_nav, 
  :topic_last_activity, :topic_feature_icon,
  :topic_img, :topic_no_avatar_img, 
  :topic_new, :home_view, 
  :home_edit, :about_view, 
  :about_edit, :analytic_page,
  :analytic_submit, :advertising_google_button, 
  :google_embed_id, :mod_flagged_post_tab,
  :mod_threshold_tab, :mod_success_msg, 
  :mod_perm_removed_tab, :mod_threshold_save_button, 
  :mod_threshold_field, :mod_flagged_post, 
  :mod_perm_removed_post,:mod_profanity_page, 
  :profanity_disable_button,:profanity_import_button,
  :profanity_download_button, :footer_text, 
  :footer_input, :legal_head_text, 
  :legal_cookie_msg, :legal_show_cookie_msg_button, 
  :legal_publish_button, :legal_preview_button, 
  :branding_page, :branding_heading, 
  :widget_theme_page, :widget_theme_create_button, 
  :email_designer_page, :email_designer_edit_button, 
  :pageview_weekly_yearly_graph, :pageview_graph, 
  :pop_content, :responsiveness, 
  :traffic, :business, 
  :liveliness, :members, 
  :interaction, :pageview_export_button, 
  :pop_pie_conv, :pop_pie_conv_title, 
  :pop_pie_info, :pop_pie_topic_title, 
  :pop_pie_topic, :pop_text, 
  :traffic_return_user, :traffic_return_user_graph, 
  :business_community_cta_graph, :business_community_cta_weekly, 
  :business_hybris_cta_graph, :liveliness_table, 
  :members_new_regis_user_graph, :members_post_growth_graph, 
  :interaction_graph, :ecomm_int_page, 
  :ecomm_int_config_page, :ecomm_int_save_button, 
  :ecomm_int_sync_button, :ecomm_int_history_page, 
  :ecomm_int_history_resync_button, :oauth_page, 
  :oauth_page_new_app_button, :oauth_new_app_name_field, 
  :oauth_new_app_save_button, :oauth_new_app_cancel_button, 
  :resp_text, :resp_chart, 
  :resp_pie_title, :profile_field_page, 
  :enable_profanity_button, :widget_theme_edit_button, 
  :pop_pie_monthly_conv, :legal_publish_confirm_button, 
  :legal_confirm_msg, :admin_link, 
  :caret, :caret_dropdown, 
  :dropdown_admin_link, :admin_page, 
  :admin_moderation_link, :flagged_post_link, 
  :mod_threshold_link, :permission_link, 
  :netmod_tab, :netmod_member_card, 
  :permission_user3_trash, :permission_user3_netmod_link, 
  :permission_user3_netadmin_link,
  :topic_permission, :topicadmin_page, 
  :select_topic, :topicadmin_member_card, 
  :topicadmin_user3_link, :topicmod_link, 
  :topicmod_membercard, :topicmod_user3_link, 
  :admin_new_topic_button, :permission_netadmin_tab, 
  :permission_user3, :netadmin_add, 
  :addmember_modal, :netadmin_textfield, 
  :netadmin_add_button, :permission_user3_netadmin_card, 
  :netmod_id, :permission_user3_netmod_card, 
  :netmod_add, :netmod_add_button,
  :netmod_textfield, :topicadmin_add, 
  :topicadmin_add_button, :topicadmin_modal, 
  :topicadmin_field, :topicmod_add, 
  :topicmod_modal, :topicmod_add_button, 
  :topicmod_field, :topicmod_user3_card, 
  :permission_page, :admin_topic_link,
  :admin_home_link, :admin_about_link, 
  :admin_analytics_link, :admin_embed_link, 
  :admin_privacy_link, :admin_branding_link, 
  :admin_profile_link, :admin_email_design_link, 
  :admin_permission_link, :admin_report_link,
  :mod_threshold_link, :flagged_post, 
  :flagged_post_tab, :embedding_container, 
  :embedding_container_clientid_textfield, 
  :embedding_container_banner_slotid_textfield, 
  :embedding_container_side_slotid_textfield, :embed_submit, 
  :embed_contentid, :profanity_link, 
  :profanity_enable_button, :profanity_filefield, 
  :profanity_upload_success_close, :profanity_upload_success, 
  :profanity_disable_button, :new_topic_title_field, 
  :new_topic_desc, :new_topic_browse, 
  :new_topic_tile_banner_file, :new_topic_img_cropper,
  :new_topic_img_select_button, :new_topic_tile_selected_img, 
  :new_topic_tile_banner_change_button, :new_topic_tile_banner_delete_button, 
  :new_topic_default_topictype, :new_topic_eng_topictype, 
  :new_topic_eng_chosen, :new_topic_sup_topictype, 
  :new_topic_sup_chosen, :advertise_check, 
  :new_topic_next_design_button, :new_topic_next_design_page, 
  :topic_type_text, :design_side_zone, 
  :new_topic_browse, :new_topic_banner_selected_img,
  :next_view_topic_button, :activate_topic_button, 
  :edit_topic_button, :deactivate_topic_button, 
  :feature_topic_button, :new_topictitle, 
  :topic_popular_disc_widget, :topic_popular_answer_widget, 
  :ad_banner, :ad_side, 
  :permission_user12_trash, :permission_user12_netadmin_link, 
  :permission_user12_netadmin_card, :permission_user12_netmod_link,
  :permission_user12_netmod_card,:topicadmin_user12_link, 
  :topicadmin_user12_card, :topicmod_user12_card, 
  :user12_link, :flag_modal, 
  :flag_reason_text_input, :flag_modal_submit, 
  :flagged_post_link, :perm_removed_link, 
  :profanity_blocker_link, :permission_card_netmod, 
  :permission_card_topadmin, :permission_card_topmod, 
  :pending_approval_tab, :low_level_mod_radio,
  :medium_level_mod_radio, :high_level_mod_radio, 
  :mod, :spinner, 
  :permission_card, :permission_user12, 
  :topicmod_user12_link,
  :branding_publish_spinner

  def initialize(browser)
    super
    @admin_link = @browser.link(:href => "/admin/#{$networkslug}")
    @admin_option = @browser.link(:class => "ember-view", :text => "Admin")
    @admin_page_table_header = @browser.div(:class => "shown col-lg-12 sap-table-header").div(:class => "btn-group pull-right").button(:type => "button", :value => "Date Modified")
    @topic_title = @browser.div(:class => "topic-title col-md-4")
    @topic_last_activity = @browser.span(:class => "topic-footer-label")
    @topic_feature_icon = @browser.div(:class => "col-md-3 feature-icon")
    @topic_img = @browser.div(:class => "col-md-9").link(:class => "ember-view").img
    @topic_no_img = @browser.div(:class => "col-md-9").link(:class => "ember-view").div(:class => "topic-list-no-avatar")
    @topic_edit = @browser.div(:class => "col-md-2 topic-admin-actions", :index => 7).link(:text => "Edit")
    @topic_view = @browser.div(:class => "col-md-2 topic-admin-actions").link(:class => "ember-view", :text => "View")
    @topic_new = @browser.div(:class => "shown col-lg-12").link(:class => "btn btn-primary pull-right ember-view", :text => "+ New Topic")

    @caret = @browser.div(:class => /topbar-nav/).span(:class => "caret")
    @caret_dropdown = @browser.div(:class => "dropdown open")

    @new_topic_title_field = @browser.text_field(:id => "new-topic-title")
    @new_topic_desc = @browser.text_field(:id => "topic-caption-input")
    @new_topic_browse = @browser.link(:text => "browse")
    @new_topic_tile_banner_file = @browser.file_field(:class => "files")
    @new_topic_img_cropper = @browser.div(:class => "cropper-canvas")
    @new_topic_img_select_button = @browser.button(:class => "btn btn-primary btn-sm file-upload-select-button", :text => "Select Photo")
    @new_topic_tile_selected_img = @browser.div(:class => "ember-view uploader-component topic-tile-upload")
    @new_topic_banner_selected_img = @browser.div(:class => "ember-view uploader-component widget banner normal topic")
    @new_topic_tile_banner_change_button = @browser.button(:class => "btn btn-default", :text => "Change Photo")
    @new_topic_tile_banner_delete_button = @browser.button(:class => "btn btn-default", :text => "Delete Photo")
    @new_topic_default_topictype = @browser.div(:class => "topic-type-selection-box engagement chosen")
    @new_topic_eng_topictype = @browser.div(:class => "topic-type-selection-box engagement")
    @new_topic_eng_chosen = @browser.div(:class => "topic-type-selection-box support chosen", :text => /Engagement/)
    @new_topic_sup_topictype = @browser.div(:class => "topic-type-selection-box support", :text => /Q&A/)
    @new_topic_sup_chosen = @browser.div(:class => "topic-type-selection-box support chosen", :text => /Q&A/)
    @advertise_check = @browser.div(:text => /Enable advertising/).input(:class => "ember-view ember-checkbox")
    @new_topic_next_design_button = @browser.button(:class => "btn btn-primary", :text => /Next: Design/)
    @new_topic_next_design_page = @browser.div(:class => "row topic-create-title")
    @topic_type_text = @browser.div(:class => "topic-type-text")
    @design_side_zone = @browser.div(:class => "widget-container col-lg-4 col-md-3 side zone")
    @new_topic_banner_selected_img = @browser.div(:class => "ember-view uploader-component widget banner normal topic")
    @next_view_topic_button = @browser.button(:class => "btn btn-primary", :text => /Next: View Topic/)
    @activate_topic_button = @browser.button(:class => "btn btn-primary", :text => /Activate Topic/)
    @edit_topic_button = @browser.button(:class => "btn btn-default", :text => /Edit Topic/)
    @deactivate_topic_button = @browser.link(:class => "btn btn-default", :text => "Deactivate Topic")
    @feature_topic_button = @browser.button(:class => "btn btn-default", :text => "Feature Topic")
    @new_topictitle = @browser.div(:class => "row title")
    @ad_banner = browser.div(:id => "ads_banner")
    @ad_side = browser.div(:id => "ads_side")

    @topic_popular_disc_widget = @browser.div(:class => "widget popular_discussions")
    @topic_popular_answer_widget = @browser.div(:class => "widget popular_answers")
    @pop_disc_widget = @browser.div(:class => "widget popular_discussions")
    @pop_ans_widget = @browser.div(:class => "widget popular_answers")
    @ad_banner = @browser.div(:id => "ads_banner")
    @ad_side = @browser.div(:id => "ads_side")


    @home_option = @browser.link(:class => "ember-view", :text => "Home Page")
    @home_view = @browser.div(:class => "col-md-3 col-lg-3 col-xs-6 col-sm-8").link(:class => "btn btn-default ember-view btn btn-default", :text => "View Home Page")
    @home_edit = @browser.div(:class => "col-md-3 col-lg-3 col-xs-6 col-sm-4").link(:class => "btn btn-default ember-view btn btn-default", :text => "Edit Home Page")

    @aboutpage_option = @browser.link(:class => "ember-view", :text => "About Page")
    @about_view = @browser.div(:class => "col-md-3 col-lg-3 col-xs-6 col-sm-8").link(:class => "btn btn-default ember-view btn btn-default", :text => "View About Page")
    @about_edit = @browser.div(:class => "col-md-3 col-lg-3 col-xs-6 col-sm-4").link(:class => "btn btn-default ember-view btn btn-default", :text => "Edit About Page")

    @analytic = @browser.link(:class => "ember-view", :text => "3rd Party Analytics")
    @analytic_page = @browser.div(:class => "form-group", :text => /Analytics Provider/)
    @analytic_submit = @browser.button(:type => "submit", :value => "Submit")

    @advertising = @browser.link(:class => "ember-view", :text => "Advertising")
    @advertising_google_button = @browser.button(:type => "button", :value => "Google Ads")
    @google_embed_id = @browser.text_field(:class => "sap-regular-input ember-view ember-text-field", :index => 0)
    @google_top_banner = @browser.text_field(:class => "sap-regular-input ember-view ember-text-field", :index => 1)
    @google_side_banner = @browser.text_field(:class => "sap-regular-input ember-view ember-text-field", :index => 2)
    @google_ad_save = @browser.button(:class => "btn btn-primary", :value => "Save")
  
    @flagged_post_link = @browser.link(:class => "ember-view", :text => "Flagged")
    @pending_approval_tab = @browser.div(:id => "pending-approval-posts")

    @mod = @browser.link(:class => "ember-view", :text => "Moderation")
    @mod_threshold_link = @browser.div(:class => "moderation").link(:class => "ember-view", :text => "Settings")
    @mod_threshold_field = @browser.text_field(:class => "form-control ember-view ember-text-field")
    @mod_threshold_save_button = @browser.button(:class => "btn btn-primary", :value => /Save/)
    @mod_success_msg = @browser.div(:class => "show moderation-success")
    @flagged_post = @browser.div(:id => "flagged-posts").div(:class => "flagged-posts clearfix", :index => 0).div(:class => "media-body").link(:class => "ember-view")
    @low_level_mod_radio = @browser.radio(:value => "community_moderation_post_shown")
    @medium_level_mod_radio = @browser.radio(:value => "pending_admin_moderation_post_shown")
    @high_level_mod_radio = @browser.radio(:value => "pending_admin_moderation_post_hidden")

    @mod_flagged_post = @browser.div(:class => "ember-view post-list clearfix").div(:class => "ember-view")
    @mod_flagged_post_title_link = @browser.div(:class => "ember-view post-list clearfix").div(:class => "ember-view").link(:class => "ember-view")
    @flagged_link = @browser.div(:class => "media-body").div(:class => "media-heading").link 
    @flag_modal = @browser.div(:id => "report-post-modal", :class => "modal fade  in")

    @mod_perm_removed_tab = @browser.link(:text => "Permanently Removed")
    
    @conv_list = @browser.link(:class => "media-heading ember-view media-heading")
    @reply_depth0 = @browser.div(:class => /depth-0/)
    @reply_perm_remove = @browser.link(:text => "Permanently Remove")
    @reply_perm_remove_confirm_button = @browser.div(:class => "modal in").button(:class => "btn btn-primary", :value => "Remove")
    @reply_reinstate = @browser.link(:text => "Reinstate this content")
    @reply_flag = @browser.link(:text => /Flag as inappropriate/)
    @flag_icon = @browser.span(:class => "icon-flag pull-right")

    @flag_reason_text_input = @browser.div(:class => "modal fade  in").textarea(:class => "ember-view ember-text-area")
    @flag_modal_submit = @browser.div(:class => "modal fade  in").button(:class => "btn btn-primary", :text => "Submit")

    @mod_profanity_tab = @browser.link(:text => "Profanity Blocker")
    @mod_profanity_page = @browser.div(:id => "block-list")
    @profanity_disable_button = @browser.button(:id => "profanity_disable_btn", :value => "Disable Profanity Blocker")
    @profanity_import_button = @browser.link(:class => "btn btn-default profanity-import-btn", :text=> "Import CSV")
    @profanity_download_button = @browser.link(:class => "btn btn-default", :text => "Download CSV")
    @enable_profanity_button = @browser.button(:class => "btn btn-default", :value => "Enable Profanity Blocker")

    @legal = @browser.link(:class => "ember-view", :text => "Legal/Disclosures")
    @footer_text = @browser.div(:class => "col-md-offset-2 col-md-8")
    @footer_input = @browser.textarea(:class => "disclosure-input form-control ember-view ember-text-area disclosure-input form-control")
    @tou = @browser.text_field(:class => "disclosure-input form-control ember-view ember-text-field disclosure-input form-control")
    @tou_text = @browser.div(:class => "col-md-6", :text => /Terms of Use/)
    @privacy = @browser.text_field(:id => "privacy-link", :class => "disclosure-input form-control ember-view ember-text-field disclosure-input form-control")
    @privacy_text = @browser.div(:class => "col-md-6", :text => /Privacy Policy/)
    @imprint = @browser.text_field(:id => "imprint-link", :class => "disclosure-input form-control ember-view ember-text-field disclosure-input form-control")
    @imprint_text = @browser.div(:class => "col-md-6", :text => /Imprint/)
    @contactus = @browser.text_field(:id => "contact-link", :class => "disclosure-input form-control ember-view ember-text-field disclosure-input form-control")
    @legal_publish_button = @browser.div(:class => "row admin-topic-bottom-buttons").div(:class => "col-md-12").button(:value => "Publish")
    @legal_publish_confirm_button = @browser.div(:id => "publish-disclosure-confirm").button(:value => "Publish")
    @legal_preview_button = @browser.button(:class => "btn btn-default", :value => "Preview")
    @legal_head_text = @browser.div(:class => "col-md-12", :text => "Provide copyright, terms of use, other legal information, and how community users can contact your administrators. This information will be provided in the footer of each page. You will need to provide links to existing web pages for terms of use, your privacy policy, and contact information as requested below.")
    @legal_preview_ok_button = @browser.button(:class => "btn btn-default", :value => "Close")
    @legal_cookie_msg = @browser.div(:class => "row disclosure-heading-2", :text => /Cookies, Terms of Use and Privacy Policy Message/)
    @legal_show_cookie_msg_button = @browser.button(:class => "btn btn-default", :value => "Show Message")
    @cookie_proceed_button = @browser.button(:class => "btn btn-primary", :value => "Proceed")
    @legal_confirm_msg = @browser.div(:class => "col-md-12", :text => "Your information was successfully saved!")
    @tou_link = @browser.div(:class => "col-md-offset-2 col-md-8").div(:class => "footer", :index => 1).link(:index=> 0, :href => "http://go.sap.com/corporate/en/legal/terms-of-use.html")
    
    @branding = @browser.link(:class => "ember-view", :text => "Branding")
    @branding_url = $base_url + "/admin/#{$networkslug}/branding"
    @branding_page = @browser.div(:class => "col-lg-4", :text => /Main Body Font/)
    @branding_heading = @browser.h5(:text => "Change Logo")
    @change_logo_button = @browser.button(:class => "btn btn-default", :value => "Browse your device")
    @change_logo_file_field = @browser.file_field(:class=> "ember-view ember-text-field files file photo-browse-input btn btn-default btn-sm")
    @logo_cropper = @browser.div(:class => "cropper-canvas cropper-modal cropper-crop")
    @logo_select_photo = @browser.div(:class => "modal-footer").button(:class => "btn btn-primary btn-sm file-upload-select-button", :text => "Select Photo")
    @logo_img = @browser.img(:class => "nav-logo")
    @sephora_logo_img = @browser.img(:class => "nav-logo" , :src => /sephora-logo.jpg/)
    @sap_logo_img = @browser.img(:class => "nav-logo", :src => /saplogo.png/)

    @branding_normal_link_color_field = @browser.div(:class => "col-lg-8")
    @branding_preview_button = @browser.button(:class => "btn btn-primary ", :value => "Preview")
    @branding_publish_button = @browser.button(:class => "btn btn-primary ", :value => "Publish")
    @branding_reset_button = @browser.button(:class => "btn btn-default ", :value => "Reset to Default")
    @branding_publish_progress = @browser.div(:class => "progress-bar")
    @branding_publish_spinner = @browser.i(:class => "fa fa-spinner fa-spin")
    @profile_link_color = @browser.link(:href => /profile/)

    @branding_button_color_field = @browser.div(:class => "row", :index => 12).div(:class => "col-lg-8").text_field(:class => "ember-view ember-text-field")#@browser.text_field(:class => "ember-view ember-text-field", :index=> 8)
    @favicon_field = @browser.div(:class => "row", :index => 29).div(:class => "col-lg-8").text_field(:class => "ember-view ember-text-field")# :index=> 22)

    @widget_theme = @browser.link(:class => "ember-view", :text => "Widget Theme")
    @widget_theme_page = @browser.div(:class => "col-sm-9").div(:class => "row")
    @widget_theme_create_button = @browser.link(:class => "btn btn-primary", :text => "Create a Widget Theme")
    @widget_theme_edit_button = @browser.link(:class => "btn btn-primary", :text => "Edit Widget Theme")

    @email_designer = @browser.link(:class => "ember-view", :text => "Email Designer")
    @email_designer_page = @browser.div(:class => "email-designer")
    @email_designer_edit_button = @browser.link(:class => "btn btn-primary ember-view btn btn-primary", :text => "Edit Email Template")
    @email_edit_page = @browser.div(:class => "col-md-8 background_box")
    @email_edit_icon = @browser.div(:class => "col-md-8 background_box").div(:class => "email-edit", :text => "Edit")
    @email_bg_textarea = @browser.textarea(:class => "int_background_style ember-view ember-text-area")
    @email_preview_page = @browser.div(:class => "email-preview")
    @email_preview_bg_style = @browser.div(:class => " preview_email")
    @email_preview_button = @browser.button(:class => "preview_email_template btn btn-default", :value => "Preview")
    @email_preview_ok_button = @browser.button(:class => "btn btn-default", :value => "OK")
    @email_cancel_button = @browser.button(:class => "btn btn-default", :value => "Cancel")
    @email_footer_cancel_button = @browser.div(:id => "emailCancelModal").div(:class => "modal-footer").button(:class => "btn btn-default", :value => "Cancel")
    @email_publish_button = @browser.button(:class => "btn btn-primary activate_email_template", :value => "Publish")

    @profile_field = @browser.link(:class => "ember-view", :text => "Profile Fields")
    @profile_field_page = @browser.div(:class => "row profile-fields")
    @req_first_name_profile_field = @browser.div(:class => "panel-body").div(:class => "row profile-fields", :index => 1).div(:class => "col-md-3", :index => 2).input(:class => "is_required ember-view ember-checkbox")
    
    @admin_ecomm_int_link = @browser.link(:href => "/admin/#{$networkslug}/integration")
    @admin_oauth_config = @browser.link(:href => "/admin/#{$networkslug}/oauth_configuration")

    @comment_toggle_option = @browser.div(:class => /ember-view depth-1/).span(:class => "dropdown-toggle")
    @comment_flag_option = @browser.link(:text => /Flag as inappropriate/)

    @admin_sidenav = @browser.div(:class => "sidebar-nav")

    @report_keychart = @browser.link(:text => "Key Charts")

    @report = @browser.link(:class => "ember-view", :text => "Reports")
    @report_pageview = @browser.link(:class => "report-sub-nav", :text => "Page Views")
    @pageview_graph = @browser.div(:id => "page-views-daily")
    @pageview_weekly_yearly_graph = @browser.div(:class => "tab-content")
    @pageview_daily = @browser.link(:href => "#page-views-daily", :text => "Daily")
    @pageview_weekly = @browser.link(:href => "#page-views-weekly", :text => "Weekly")
    @pageview_monthly = @browser.link(:href => "#page-views-monthly", :text => "Monthly")
    @pageview_yearly = @browser.link(:href => "#page-views-yearly", :text => "Yearly")
    @pageview_export_button = @browser.link(:class => "btn btn-primary", :text => "Export CSV")

    @pop_content = @browser.link(:class => "report-sub-nav", :text => "Popular Content")
    @pop_pie_conv = @browser.div(:class => "tab-content").div(:class => "tab-pane no-margin active").div(:class => "tab-content") #.canvas(:class =>"popular-content-last-7days")
    @pop_pie_monthly_conv = @browser.div(:id => "popular-content-last-30days").div(:class => "ember-view", :index => 0).div(:class => "parent-row row").div(:class => "col-lg-4")
    @pop_pie_conv_title = @browser.div(:class => "ember-view", :text => /Conversations with Most Views/)
    @pop_pie_topic = @browser.div(:id => "popular-content-last-7days").div(:class => "ember-view", :index => 1).div(:class => "parent-row row").div(:class => "col-lg-4")
    @pop_pie_topic_title = @browser.div(:class => "ember-view", :text => /Topics with Most Views/)
    @pop_pie_info = @browser.div(:class => "chart-summary", :text => /Total Page Views/)
    @pop_text = @browser.div(:class => "legend-col-1 col-lg-6")
    @pop_weekly = @browser.link(:href => "#popular-content-last-7days", :text => "Last 7 Days")
    @pop_monthly = @browser.link(:href => "#popular-content-last-30days", :text => "Last 30 Days")

    @responsiveness = @browser.link(:href => "#responsiveness", :text => "Responsiveness")
    @resp_chart = @browser.div(:class => "chart")
    @resp_pie_title = @browser.div(:class => "ember-view", :text => /Elapsed time between first post and response to that post/)
    @resp_text = @browser.div(:class => "legend-col-1 col-lg-6")

    @traffic = @browser.link(:href => "#traffic", :text => "Traffic")
    @traffic_return_user = @browser.link(:class => "report-sub-nav", :text => "Returning Users")
    @traffic_daily = @browser.link(:href => "#returning-users-daily", :text => "Daily")
    @traffic_return_user_graph = @browser.div(:id => "returning-users-daily")

    @business = @browser.link(:text => "Business Value")
    @business_comm_cta = @browser.link(:href => "#cta-clicks", :text => "Community CTA")
    @business_community_cta_graph = @browser.div(:id => "weekly-cta")
    @business_community_cta_weekly = @browser.link(:href => "#weekly-cta", :text => "Weekly")
    @business_hybris_cta_link = @browser.link(:href => "#hybris-cta-clicks", :text => "Hybris CTA")
    @business_hybris_cta_graph = @browser.div(:id => "hybris-weekly-cta")

    @liveliness = @browser.link(:href => "#liveliness")
    @liveliness_table = @browser.div(:id => "liveliness").table(:class => "table table-hover")

    @members = @browser.link(:href => "#members", :text => "Members")
    @members_new_regis_user = @browser.link(:class => "report-sub-nav", :text => "New Registered Users")
    @members_new_regis_user_graph = @browser.div(:id => "daily-registered-users")
    @members_new_regis_user_daily = @browser.link(:href => "#daily-registered-users", :text => "Daily")
    @members_post_growth = @browser.link(:class => "report-sub-nav", :text => "Posts Growth")
    @members_post_growth_graph = @browser.div(:id => "weekly-registered-users-post-count")
    @members_post_growth_weekly = @browser.link(:href => "#weekly-registered-users-post-count", :text => "Weekly")

    @interaction = @browser.link(:href => "#interaction", :text => "Interaction")
    @interaction_graph = @browser.div(:id => "interaction")

    @hybris_ecomm = @browser.link(:class => "ember-view", :text => "E-commerce Integration")
    @ecomm_int_page = @browser.div(:class => "col-md-11 settings-item", :text => /Active Products/)
    @ecomm_int_prod_sync_radio = @browser.div(:class => "col-md-1", :index => 1).input(:type => "radio", :value => "false")
    @ecomm_int_config = @browser.link(:text => "Configuration")
    @ecomm_int_config_page = @browser.form(:class => "form-horizontal integration-form")
    @ecomm_int_sync_button = @browser.button(:class => "btn btn-primary", :value => "Sync")
    @ecomm_int_save_button = @browser.button(:class => "btn btn-default", :value => "Save")

    @ecomm_int_history = @browser.link(:text => "History")
    @ecomm_int_history_page = @browser.div(:class => "integration-history-wrap")
    @ecomm_int_history_resync_button = @browser.button(:class => "btn btn-default", :value => "Re-Sync")

    @oauth_configuration = @browser.link(:class => "ember-view", :text => "OAuth Configuration")
    @oauth_page = @browser.div(:class => "admin-grid admin-auth-grid col-md-12")
    @oauth_page_new_app_button = @browser.button(:class => "btn btn-primary", :value => "New Application")
    @oauth_new_app_name_field = @browser.input(:id => "name", :class => "form-control ember-view ember-text-field form-control")
    @oauth_new_app_save_button = @browser.button(:class => "btn btn-primary", :text => "Create")
    # @oauth_new_app_cancel_button = @browser.button(:class => "btn btn-default", :value => "Cancel")
   

    @oauth_app_row = @browser.div(:class => "cell cell-title col-xs-6 col-sm-4")

    @admin_page_link = @browser.div(:class=>"dropdown open").link(:href => "/admin/#{$networkslug}")
    
    #@new_topic_button = @browser.div(:class => "shown col-lg-12").link(:class => "btn btn-primary pull-right ember-view", :text => "+ New Topic")
    #@new_topic_title = @browser.text_field(:id => "new-topic-title")
    #@new_topic_desc = @browser.text_field(:id => "topic-caption-input")
    #@topic_img_browse = @browser.link(:text => "browse")
    @new_topic_cancel = @browser.div(:class => "col-md-1").link(:text => "Cancel")
    @cancel_existing_topic_button = @browser.div(:class => "modal-content").button(:text => "Cancel Topic Edit")
    @cancel_new_draft_topic_button = @browser.div(:class => "modal-content").button(:text => "Cancel New Topic")
    @topic_no_avatar_img = @browser.div(:class => "topic-list-no-avatar")
    @cancel_new_topic_footer = @browser.div(:class => "modal-content")
    @community_breadcrumb = @browser.div(:class => "breadcrumbs").link(:class => "ember-view")

    @modal = @browser.div(:class => "modal-content")
    
    @dropdown_admin_link = @browser.div(:class=>"dropdown open").link(:href => "/admin/#{$networkslug}")
    @admin_link = @browser.link(:href => "/admin/#{$networkslug}")
    @permission = @browser.link(:class => "ember-view", :text => "Permissions")
    @permission_link = @browser.link(:href => "/admin/#{$networkslug}/permission")
    @permission_card =@browser.div(:class => "member-card-container container-fluid").div(:class => "member-card-internal")
  
    @permission_card_netmod = @browser.div(:id => "network-moderators").div(:class => "member-card-container container-fluid").div(:class => "member-card-internal")
    @permission_card_topadmin = @browser.div(:id => "topic-administrators").div(:class => "member-card-container container-fluid").div(:class => "member-card-internal")
    @permission_card_topmod = @browser.div(:id => "topic-moderators").div(:class => "member-card-container container-fluid").div(:class => "member-card-internal")
    @netadmin_id = @browser.div(:id => "network-administrators")
    @permission_netadmin_tab = @browser.link(:href => "#network-permission")
    @permission_page = @browser.div(:class => "member-card-internal")
    @permission_user3 = @browser.link(:text => "#{$user3[3]}")
    @permission_user12 = @browser.link(:text => "#{$user12[3]}")
    @permission_user3_trash = @browser.div(:class => "member-card-internal", :text => /#{$user3[3]}/).div(:class => "fa fa-trash-o fa-2x delete-member-icon")
    @permission_user12_trash = @browser.div(:class => "member-card-internal", :text => /#{$user12[3]}/).div(:class => "fa fa-trash-o fa-2x delete-member-icon")
    
    @permission_user3_netadmin_link = @browser.div(:id => "network-administrators").link(:text => /#{$user3[3]}/)
    @permission_user12_netadmin_link = @browser.div(:id => "network-administrators").link(:text => /#{$user12[3]}/)
    @permission_user3_netadmin_card = @browser.div(:id => "network-administrators").div(:class => "member-card-container container-fluid", :text => /#{$user3[3]}/)
    @permission_user12_netadmin_card = @browser.div(:id => "network-administrators").div(:class => "member-card-container container-fluid", :text => /#{$user12[3]}/)
    @netadmin_add = @browser.div(:id => "network-administrators").div(:class => "row").div(:class => "col-sm-2").input(:id => "addMember")
    @addmember_modal = @browser.div(:class => "modal-body")
    @netadmin_textfield = @browser.text_field(:class => "form-control ember-view ember-text-field")
    @netadmin_add_button = @browser.div(:class => "modal-content").div(:class => "modal-footer").button(:class => "btn btn-primary", :text => /Add/)

    @netmod_tab = @browser.link(:href => "#network-moderators")
    @netmod_id = @browser.div(:id => "network-moderators")
    @netmod_tab_page = @browser.div(:class => "member-card-internal")
    @netmod_member_card = @browser.div(:id => "network-moderators").div(:class => "member-card-container container-fluid")
    @permission_user3_netmod_link = @browser.div(:id => "network-moderators").link(:text => /#{$user3[3]}/)
    @permission_user12_netmod_link = @browser.div(:id => "network-moderators").link(:text => /#{$user12[3]}/)
    @netmod_add = @browser.div(:id => "network-moderators").div(:class => "row").div(:class => "col-sm-2").input(:id => "addMember")
    @netmod_textfield = @browser.div(:id => "addNetworkModeratorModal").text_field(:class => /ember-text-field/)
    @netmod_add_button = @browser.div(:id => "addNetworkModeratorModal").button(:class => "btn btn-primary", :text => /Add/)
    @permission_user3_netmod_card = @browser.div(:id => "network-moderators").div(:class => "member-card-container container-fluid", :text => /#{$user3[3]}/)
    @permission_user12_netmod_card = @browser.div(:id => "network-moderators").div(:class => "member-card-container container-fluid", :text => /#{$user12[3]}/)

    @topic_permission = @browser.link(:href => "#topic-permission")
    #@a_watir_topic_select = @browser.select_list(:class => "ember-view ember-select form-control accessible-topic").select("A Watir Topic")
    @select_topic = @browser.select_list(:class => "ember-view ember-select form-control accessible-topic") #.select("A Watir Topic")
    @topicadmin_member_card = @browser.div(:id => "topic-administrators").div(:class => "member-card-container container-fluid")
    @topicadmin_add = @browser.div(:id => "topic-administrators").div(:class => "row").div(:class => "col-sm-2").input(:id => "addMember")
    @topicadmin_modal = @browser.div(:id => "topic-administrators").div(:class => "modal-body")
    @topicadmin_field = @browser.div(:id => "addTopicMemberModal").text_field(:class => /ember-text-field/)
    @topicadmin_add_button = @browser.div(:id => "addTopicMemberModal").button(:class => "btn btn-primary", :text => /Add/)
    @topicadmin_link = @browser.div(:id => "topic-administrators").link(:text => /#{$user3[3]}/)
    @topicadmin_user3_link = @browser.div(:id => "topic-administrators").link(:text => /#{$user3[3]}/)
    @topicadmin_user12_link = @browser.div(:id => "topic-administrators").link(:text => /#{$user12[3]}/)
    @topicadmin_user3_card = @browser.div(:id => "topic-administrators").div(:class => "member-card-container container-fluid", :text => /#{$user3[3]}/)
    @topicadmin_user12_card = @browser.div(:id => "topic-administrators").div(:class => "member-card-container container-fluid", :text => /#{$user12[3]}/)
    @topicadmin_page = @browser.div(:id => "topic-administrators")
    
    @topicmod_link = @browser.link(:href => "#topic-moderators")
    @topicmod_membercard = @browser.div(:id => "topic-moderators").div(:class => "member-card-container container-fluid")
    @user3_link = @browser.link(:text => "#{$user3[3]}")
    @user12_link = @browser.link(:text => "#{$user12[3]}")
    @topicmod_user3_link = @browser.div(:id => "topic-moderators").link(:text => /#{$user3[3]}/)
    @topicmod_user12_link = @browser.div(:id => "topic-moderators").link(:text => /#{$user12[3]}/)
    @topicmod_add = @browser.div(:id => "topic-moderators").div(:class => "row").div(:class => "col-sm-2").input(:id => "addMember")
    @topicmod_add_button = @browser.div(:id => "addTopicModeratorModal").button(:class => "btn btn-primary", :text => /Add/)
    @topicmod_modal = @browser.div(:id => "topic-moderators").div(:class => "modal-body")
    @topicmod_field = @browser.div(:id => "addTopicModeratorModal").text_field(:class => /ember-text-field/)
    @topicmod_user3_card = @browser.div(:id => "topic-moderators").div(:class => "member-card-container container-fluid", :text => /#{$user3[3]}/)
    @topicmod_user12_card = @browser.div(:id => "topic-moderators").div(:class => "member-card-container container-fluid", :text => /#{$user12[3]}/)

    @admin_page_left_nav = @browser.div(:class => "sidebar-nav")
    @admin_moderation_link = @browser.link(:href => "/admin/#{$networkslug}/moderation")
    @admin_topic_link = @browser.link(:href => "/admin/#{$networkslug}/topics")
    @admin_home_link = @browser.link(:href => "/admin/#{$networkslug}/homePage")
    @admin_about_link = @browser.link(:href => "/admin/#{$networkslug}/aboutPage")
    @admin_analytics_link = @browser.link(:href => "/admin/#{$networkslug}/analytics")
    @admin_embed_link = @browser.link(:href => "/admin/#{$networkslug}/advertising")
    @admin_privacy_link = @browser.link(:href => "/admin/#{$networkslug}/disclosures")
    @admin_branding_link = @browser.link(:href => "/admin/#{$networkslug}/branding")
    @admin_email_design_link = @browser.link(:href => "/admin/#{$networkslug}/email_designer")
    @admin_profile_link = @browser.link(:href => "/admin/#{$networkslug}/profile_field")
    @admin_permission_link = @browser.link(:href => "/admin/#{$networkslug}/permission")    
    @admin_report_link = @browser.link(:href => "/admin/#{$networkslug}/reporting")

    @flagged_post_link = @browser.ul(:class => "nav nav-tabs").link(:text => /Flagged/)
    @perm_removed_link = @browser.ul(:class => "nav nav-tabs").link(:text => /Permanently Removed/)
    @profanity_blocker_link = @browser.ul(:class => "nav nav-tabs").link(:text => /Profanity Blocker/)
    @mod = @browser.link(:class => "ember-view", :text => "Moderation")
    #@mod_threshold_link = @browser.link(:class => "ember-view", :text => "Settings")
    @mod_threshold_field = @browser.text_field(:class => "form-control ember-view ember-text-field")
    @mod_threshold_save_button = @browser.button(:class => "btn btn-primary", :value => /Save/)
    @mod_success_msg = @browser.div(:class => "show moderation-success")
    @flagged_post_tab = @browser.div(:class => "flagged-posts clearfix")
    @flagged_post = @browser.div(:id => "flagged-posts").div(:class => "flagged-posts clearfix", :index => 0).div(:class => "media-body").link(:class => "ember-view")
    @admin_new_topic_button = @browser.link(:class => "btn btn-primary pull-right ember-view" , :text => "+ New Topic")

    @embedding_container = @browser.div(:class => "embedding-containner")
    @embedding_container_clientid_textfield = @browser.div(:class => "embedding-containner").text_field(:class => "ember-view ember-text-field", :index => 0)
    @embedding_container_banner_slotid_textfield = @browser.div(:class => "embedding-containner").text_field(:class => "ember-view ember-text-field", :index => 1)
    @embedding_container_side_slotid_textfield = @browser.div(:class => "embedding-containner").text_field(:class => "ember-view ember-text-field", :index => 2)
    @embed_submit = @browser.button(:class => "btn btn-primary", :type => "submit")
    @embed_contentid = @browser.div(:text => /Embedding Content ID/)

    @profanity_link = @browser.link(:text => /Profanity Blocker/)
    @profanity_filefield = @browser.file_field(:class => /profanity-import-input/)
    @profanity_enable_button = @browser.button(:id => "profanity_enable_btn")
    @profanity_disable_button = @browser.button(:id => "profanity_disable_btn")
    @profanity_upload_success = @browser.div(:id => "profanity-upload-success")
    @profanity_upload_success_close = @browser.div(:id => "profanity-upload-success").button(:text => /Close/)

    @admin_page_link = @browser.div(:class=>"dropdown open").link(:href => "/admin/#{$networkslug}")
    @admin_page = @browser.div(:class => "topics-list row")

    @spinner = @browser.i(:class => /spinner/)
  end

  def goto_admin_page
   @loginpage = CommunityLoginPage.new(@browser)
    if (( !@loginpage.username.present?) || ( !@loginpage.caret.present?))
      about_login("regular", "logged")
    end
    if @browser.url != /admin/ && @adminurl != nil
      @browser.goto @adminurl 
      @browser.wait_until($t) { @admin_page.present? }
    end
    @loginpage = CommunityLoginPage.new(@browser)
    if @loginpage.username.present? || @loginpage.caret.present?
     if !@caret_dropdown.present? 
      @loginpage = CommunityLoginPage.new(@browser)
      @loginpage.caret.when_present.click
     end
     @browser.wait_until($t) { @caret_dropdown.present? }
     if !@admin_option.present?
      about_login("regular", "logged")
      @loginpage = CommunityLoginPage.new(@browser) 
      @loginpage.caret.click 
      @browser.wait_until($t) { @caret_dropdown.present? }
     end
    
    @browser.wait_until($t) { @admin_option.present? }
    @admin_link.click
    if !@admin_page.present?
     about_login("regular", "logged")
     @loginpage = CommunityLoginPage.new(@browser)
     @loginpage.caret.click 
     @browser.wait_until($t) { @caret_dropdown.present? }
     @admin_link.click
    end
    @browser.wait_until($t) { @admin_page.present? } 
    @adminurl = @browser.url
    @browser.wait_until($t) { @admin_page_left_nav.present? }
    if !@permission.present?
     about_login("regular", "logged")
     @loginpage = CommunityLoginPage.new(@browser)
     @loginpage.caret.click 
     @browser.wait_until($t) { @caret_dropdown.present? }
     @browser.wait_until($t) { @admin_option.present? }
     @admin_link.click
     @browser.wait_until($t) { @admin_page.present? }
    end
    @browser.wait_until($t) { @permission.present? }
    end
    
  end

  def check_no_admin_option_for_reg
    about_login("regis2", "logged")
    @loginpage = CommunityLoginPage.new(@browser)
    @loginpage.caret.click 
    @browser.wait_until($t) { @caret_dropdown.present? }
    @browser.wait_until($t) { !@admin_option.present? }
  end

  def check_admin_role
    about_login("regular", "logged")
    @loginpage = CommunityLoginPage.new(@browser)
    @loginpage.caret.click 
    @browser.wait_until($t) { @admin_option.present? }
  end

  def check_admin_option
    @loginpage = CommunityLoginPage.new(@browser)
    if !@loginpage.username.present? || !@loginpage.caret.present?
      about_login("regular", "logged")
    end
    @loginpage = CommunityLoginPage.new(@browser)
    @browser.wait_until($t){
      @loginpage.username.present?
    }
    @loginpage.username.click
    
    if !@admin_page_link.present?
        puts "User not an admin...Logging in admin user.."
        login($user1) # will do a logout before login
        @browser.goto "#{$base_url}"+"/n/#{$networkslug}"
        @loginpage = CommunityLoginPage.new(@browser)
        @browser.wait_until($t){
        @loginpage.caret.present?
       }
      @loginpage.caret.click
    end    
    @browser.wait_until($t) { @admin_page_link.present? }
    assert @admin_page_link.present?
   # return $networkslug
  end

  def check_topic_default_on_admin_page
    if !@admin_page.present?
     goto_admin_page
     @browser.wait_until($t) { @admin_page.present? }
     @browser.wait_until($t) { @admin_page_left_nav.present? }
    end
  end

  def check_topic_edit_option
    if !@admin_page.present? 
     goto_admin_page
     @browser.wait_until($t) { @admin_page.present? }
     @browser.wait_until($t) { @admin_page_left_nav.present? }
    end
    check_topic_default_on_admin_page
    @browser.wait_until($t) { @topic_edit.present? }
    @topic_edit.click
    @browser.wait_until($t) { @new_topic_title_field.present? }
    @new_topic_cancel.click
    @browser.wait_until($t) { @cancel_existing_topic_button.present? || @cancel_new_draft_topic_button.present? }
    if @cancel_new_draft_topic_button.present?
     @cancel_new_draft_topic_button.when_present.click
     @browser.wait_until($t) { @admin_page.present? }
    else
     @cancel_existing_topic_button.when_present.click
     @topicdetailpage = CommunityTopicDetailPage.new(@browser)
     @browser.wait_until($t) { @topicdetailpage.topicdetail.present? }
    end
    
  end

  def check_topic_view_option
    if !@admin_page.present?
     goto_admin_page
     @browser.wait_until($t) { @admin_page.present? }
     @browser.wait_until($t) { @admin_page_left_nav.present? }
    end
    check_topic_default_on_admin_page
    @browser.wait_until($t) { @topic_view.present? }
    @topic_view.click
    @topicdetailpage = CommunityTopicDetailPage.new(@browser)
    @browser.wait_until($t) { @topicdetailpage.topicdetail.present? }
  end

  def check_topic_last_activity_column
    if !@admin_page.present?
     goto_admin_page
     @browser.wait_until($t) { @admin_page.present? }
     @browser.wait_until($t) { @admin_page_left_nav.present? }
    end
    check_topic_default_on_admin_page
    @browser.wait_until($t) { @topic_last_activity.present? }
    @browser.wait_until($t) { @topic_last_activity.text =~ /Last activity:/ }
  end

  def check_topic_feature_column
    if !@admin_page.present?
     goto_admin_page
     @browser.wait_until($t) { @admin_page.present? }
     @browser.wait_until($t) { @admin_page_left_nav.present? }
    end
    check_topic_default_on_admin_page
    @browser.wait_until($t) { @topic_feature_icon.present? }
  end

  def check_topic_img_in_topic_list
    if !@admin_page.present?
     goto_admin_page
     @browser.wait_until($t) { @admin_page.present? }
     @browser.wait_until($t) { @admin_page_left_nav.present? }
    end
    check_topic_default_on_admin_page
    @browser.wait_until($t) { @topic_img.present? || @topic_no_avatar_img.present? }

  end

  def check_new_topic_button_present
    if !@admin_page.present?
     goto_admin_page
     @browser.wait_until($t) { @admin_page.present? }
     @browser.wait_until($t) { @admin_page_left_nav.present? }
    end
    check_topic_default_on_admin_page
    @browser.wait_until($t) { @topic_new.present? }
  end

  def check_new_topic_button_works
    if !@admin_page.present?
     goto_admin_page
     @browser.wait_until($t) { @admin_page.present? }
     @browser.wait_until($t) { @admin_page_left_nav.present? }
    end
    check_topic_default_on_admin_page
    @browser.wait_until($t) { @topic_new.present? }
    @topic_new.click
    @browser.wait_until($t) { @new_topic_title_field.present? }
    assert @new_topic_title_field.present?
    @new_topic_cancel.click
    @browser.wait_until($t) { @cancel_new_draft_topic_button.present? }
    @cancel_new_draft_topic_button.click
    @browser.wait_until($t) { @admin_page.present? }
  end

  def check_homepage_option
    if !@admin_page.present?
     goto_admin_page
     @browser.wait_until($t) { @admin_page.present? }
     @browser.wait_until($t) { @admin_page_left_nav.present? }
    end
    @home_option.click
    @browser.wait_until($t) { @home_view.present? }
    @browser.wait_until($t) { @home_edit.present? }
  end

  def check_homepage_view
    check_homepage_option
    @home_view.click
    @homepage = CommunityHomePage.new(@browser)
    @browser.wait_until($t) { @homepage.home.present? }
  end

  def check_homepage_edit
    check_homepage_option
    @home_edit.click
    @homepage = CommunityHomePage.new(@browser)
    @browser.wait_until($t) { @homepage.homebanner_editmode.present? }
  end

  def check_aboutpage_option
   if !@admin_page.present?
     goto_admin_page
     @browser.wait_until($t) { @admin_page.present? }
     @browser.wait_until($t) { @admin_page_left_nav.present? }
    end
    @aboutpage_option.click
    @browser.wait_until($t) { @about_view.present? }
    @browser.wait_until($t) { @about_edit.present? } 
  end

  def check_aboutpage_view
    check_aboutpage_option
    @about_view.click
    @aboutpage = CommunityAboutPage.new(@browser)
    @browser.wait_until($t) { @aboutpage.about_widget.present? } 
  end

  def check_aboutpage_edit
    check_aboutpage_option
    @about_edit.click
    @aboutpage = CommunityAboutPage.new(@browser)
    @browser.wait_until($t) { @aboutpage.about_edit_mode.present? } 
  end

  def check_3rd_party_analytics_option
   if !@admin_page.present?
     goto_admin_page
     @browser.wait_until($t) { @admin_page.present? }
     @browser.wait_until($t) { @admin_page_left_nav.present? }
   end
   @analytic.click
   @browser.wait_until($t) { @analytic_page.present? } 
   @browser.wait_until($t) { @analytic_submit.present? }
  end

  def check_advertising_option_present
   if !@admin_page.present?
     goto_admin_page
     @browser.wait_until($t) { @admin_page.present? }
     @browser.wait_until($t) { @admin_page_left_nav.present? }
   end
   @advertising.click
   @browser.wait_until($t) { @advertising_google_button.present? }    
  end

  def check_advertising_option_work
   check_advertising_option_present
   @google_embed_id.set "ca-pub-8464600688944785"
   @google_top_banner.set "7717419156"
   @google_side_banner.set "9115119620"  
   @google_ad_save.click
   @browser.wait_until($t) { @google_embed_id.present? }
  end

  def check_moderation_option
   if !@admin_page.present?
     goto_admin_page
     @browser.wait_until($t) { @admin_page.present? }
     @browser.wait_until($t) { @admin_page_left_nav.present? }
   end
   @mod.click
   @browser.wait_until($t) { @flagged_post_tab.present? || @pending_approval_tab.present? }
   @browser.wait_until($t) { @mod_threshold_link.present? }
   @browser.wait_until($t) { @flagged_post_link.present? }
  end

  def check_mod_threshold_tab
    if !@admin_page.present?
     goto_admin_page
     @browser.wait_until($t) { @admin_page.present? }
     @browser.wait_until($t) { @admin_page_left_nav.present? }
    end
    @mod.click
    @browser.wait_until($t) { @flagged_post_tab.present? || @pending_approval_tab.present? }
    @mod_threshold_link.when_present.when_present.click
    @browser.wait_until($t) { @mod_threshold_save_button.present? }
    @browser.wait_until($t) { @mod_threshold_field.present? }
  end

  def set_moderation_threshold_with_low
    check_mod_threshold_tab
    @mod_threshold_field.when_present.clear
    @mod_threshold_field.when_present.set "1"
    @low_level_mod_radio.when_present.set
    @mod_threshold_save_button.when_present.click
    @browser.wait_until($t) { @mod_success_msg.present? }
    assert @mod_success_msg.present?
  end

  def set_moderation_threshold_with_medium
    check_mod_threshold_tab
    @mod_threshold_field.when_present.clear
    @mod_threshold_field.when_present.set "1"
    @medium_level_mod_radio.when_present.set
    @mod_threshold_save_button.when_present.click
    @browser.wait_until($t) { @mod_success_msg.present? }
    assert @mod_success_msg.present?
  end

  def set_moderation_threshold_with_high
    check_mod_threshold_tab
    @mod_threshold_field.when_present.clear
    @mod_threshold_field.when_present.set "1"
    @high_level_mod_radio.when_present.set
    @mod_threshold_save_button.when_present.click
    @browser.wait_until($t) { @mod_success_msg.present? }
    assert @mod_success_msg.present?
  end

  def flag_a_post
    mod_flag_threshold($network, $networkslug)
    #registered user reporting the content
    about_login("regis", "logged")
    root_post = "Q created by Watir for flag - #{get_timestamp}"
    descrip = "Watir test description - #{get_timestamp}"
    flag_msg = "This post has been flagged as inappropriate; it has been temporarily removed and brought to the attention of the site moderators."
    create_conversation($network, $networkslug, "A Watir Topic", "question", root_post, false)
    answer_text = "Answered by Watir - #{get_timestamp}"
    @reply_box.when_present.focus
    @browser.wait_until($t) { @reply_submit.present? }
    @reply_box.when_present.set answer_text
    #@browser.execute_script('$("div.group text-right").blur()')
    @reply_submit.when_present.click
  
    @browser.wait_until($t) { @conv_reply.present?} #text =~ /#{answer_text}/ }
    conv_url = @browser.url

    text = @conv_reply.text #text =~ /#{answer_text}/ } 
    assert_match text, answer_text
    #signout
    #about_login("regular", "logged")
    #@browser.goto conv_url
    #@browser.wait_until($t) { @conv_reply.present?}
    @reply_dropdown_toggle.when_present.click
    
    @browser.wait_until($t) { @reply_menu.present? }
    if ( !@reply_flag.present? )
      puts "User is not a moderator....Signing in the moderator"
      signout
      about_login("regular", "logged")
      topic_detail("A Watir Topic")
      #choose_post_type("question")
      #sort_post_by_newest
      #@conv_list.when_present.click
      @browser.goto conv_url
      @browser.wait_until($t) { @reply_depth0.present? }
      assert @convdetail.present?
      #sleep 1
      @reply_dropdown_toggle.when_present.click
      @browser.wait_until($t) { @reply_menu.present? }
    end

    if (@reply_reinstate.present? )
      puts "The post appears to be already flagged...."
    end
    flag_reason_text = "Set by Watir - #{get_timestamp}"
    @reply_flag.when_present.click
    #byebug
    @browser.wait_until($t) { @flag_modal.present? }
    @flag_reason_text_input.set flag_reason_text
    @flag_modal_submit.click
    @browser.wait_until($t) { !@flag_modal_submit.present? }
    @browser.wait_until($t) { !@flag_modal.present? }
    @browser.wait_until($t) { @flag_icon.present? }
    assert @flag_icon.present?
    signout
    
    #admin-moderator checking the post is flagged
    about_login("admin", "logged")
    @loginpage = CommunityLoginPage.new(@browser)
    @browser.wait_until($t){
    @loginpage.caret.present?
    }
    @loginpage.caret.click
    @admin_option.when_present.click
    @browser.wait_until($t) { @admin_page_left_nav.present? }
    @mod.when_present.click
    ##to show @browser.wait_until($t) { @pending_approval_tab.present? }
    ##to show assert @pending_approval_tab.present?
    @browser.wait_until($t) { @flagged_post_tab.present? || @pending_approval_tab.present? }
   
    assert @flagged_post_tab.present? || @pending_approval_tab.present?

    @flagged_post_link.click
    
    @browser.refresh
    @browser.wait_until($t) { @mod_flagged_post.present? }

    flag_text = @mod_flagged_post_title_link.text
    assert_match flag_text, root_post
    @flagged_link.when_present.click
    sleep 2
    @browser.wait_until($t) { @conv_reply_view.present? }
    @browser.wait_until($t) { @conv_reply.present? }
    assert_match @conv_reply.text, answer_text
    @reply_dropdown_toggle.when_present.click
    @browser.wait_until($t) { @reply_mod_menu.present? }
    assert @reply_reinstate.present?
    signout
  end

  def check_flagged_post_tab
    if !@admin_page.present?
     goto_admin_page
     @browser.wait_until($t) { @admin_page.present? }
     @browser.wait_until($t) { @admin_page_left_nav.present? }
    end
    @mod.click
    @browser.wait_until($t) { @flagged_post_tab.present? || @pending_approval_tab.present? }
    @flagged_post_link.click
    @browser.wait_until($t) { @mod_flagged_post.present? }
  end

  def check_permanently_removed_post_tab
    about_login("regis", "logged")
    policy_warning
    topic_detail("A Watir Topic")
    choose_post_type("question")
    conversation_detail("question")
    root_post = @root_post_title.text
    @browser.wait_until($t) { @answer_level1.present? || @depth0_q.present? }
    @browser.wait_until($t) { !@spinner.present? }
    if @conv_reply.present?
     sort_post_by_newest
     @browser.wait_until{ @conv_reply.present?}
    end
    
    flag_msg = "This post has been flagged as inappropriate; it has been temporarily removed and brought to the attention of the site moderators."
    
    answer_text = "Answered by Watir - #{get_timestamp}"
    @reply_box.when_present.focus
    @browser.wait_until($t) { @reply_submit.present? }
    @reply_box.when_present.set answer_text
    @reply_submit.when_present.click
    @browser.wait_until($t) { !@spinner.present? }
    @browser.wait_until($t) { !@reply_submit.present? }
    
    @browser.wait_until{ @conv_reply.present?}
    #@browser.wait_until($t) { @conv_reply.text =~ /#{answer_text}/ }
    #text = @conv_reply.text #text =~ /#{answer_text}/ } 
    #assert_match text, answer_text
    conv_link = @browser.url
    about_login("regular", "logged")
    policy_warning
    @browser.goto conv_link
    @browser.wait_until($t) { @conv_reply.present? }
    sleep 1
    sort_post_by_newest
    @browser.wait_until{ @conv_reply_input.present?}
    @reply_dropdown_toggle.when_present.click
    
    flag_reason_text = "Set by Watir for permanently removed test - #{get_timestamp}"
     
    @reply_flag.when_present.click
    @browser.wait_until($t) { @flag_modal.present? }
    @flag_reason_text_input.set flag_reason_text
    @flag_modal_submit.click
    @browser.wait_until($t) { !@flag_modal.present? }
    @browser.wait_until($t) { !@flag_modal_submit.present? }
    @browser.wait_until($t) { @flag_icon.present? }
    assert @flag_icon.present?
    sleep 1

    @reply_dropdown_toggle.click
    @browser.wait_until($t) { @reply_mod_menu.present? }
    @reply_perm_remove.click
    @browser.wait_until($t) { @reply_perm_remove_confirm_button.present? }
    @reply_perm_remove_confirm_button.click
    @browser.wait_until($t) { !@reply_dropdown_toggle.present? }
    @loginpage = CommunityLoginPage.new(@browser)
    @loginpage.caret.click 
    @browser.wait_until($t) { @loginpage.caret_dropdown.present? }
    @admin_link.click
    @browser.wait_until($t) { @admin_page.present? }
    @browser.wait_until($t) { @admin_page_left_nav.present? }

    @mod.click
    @browser.wait_until($t) { @flagged_post_tab.present? || @pending_approval_tab.present? }
    @perm_removed_link.click
    @browser.refresh
    @browser.wait_until($t) { @mod_flagged_post.present? }
   
    flag_text = @mod_flagged_post_title_link.text
    assert_match flag_text, root_post
    #assert_match text, answer_text
  end

  def check_profanity_blocker_tab
    if !@admin_page.present?
     goto_admin_page
     @browser.wait_until($t) { @admin_page.present? }
     @browser.wait_until($t) { @admin_page_left_nav.present? }
    end
    @mod.click
    @browser.wait_until($t) { @profanity_blocker_link.present? }
    @profanity_blocker_link.click
    if !@enable_profanity_button.present? 
     @browser.wait_until($t) { @mod_profanity_page.present?}
     @browser.wait_until($t) { @profanity_disable_button.present? }
     @browser.wait_until($t) { @profanity_import_button.present? }
     @browser.wait_until($t) { @profanity_download_button.present? }
    else
     @browser.wait_until($t) { @enable_profanity_button.present? }
    end
  end

  def check_legal_disclosure_tab
    if !@admin_page.present?
     goto_admin_page
     @browser.wait_until($t) { @admin_page.present? }
     @browser.wait_until($t) { @admin_page_left_nav.present? }
     policy_warning
    end
    @legal.click
    @browser.wait_until($t) { @footer_text.present? }
    @browser.wait_until($t) { @footer_input.present? }
    @browser.wait_until($t) { @legal_head_text.present? }
    @legal_publish_button.click
    
    @browser.wait_until($t) { @legal_publish_confirm_button.present? }
    @legal_publish_confirm_button.when_present.click
    @browser.wait_until($t) { @legal_confirm_msg.present? }
  end

  def check_legal_preview_publish
    check_legal_disclosure_tab
    policy_warning
    @browser.wait_until($t) { @legal_publish_button.present? }
    @browser.wait_until($t) { @legal_preview_button.present? }

    
  end

  def set_footer
    check_legal_disclosure_tab
    policy_warning
    $footer_link = "http://go.sap.com/product/content-collaboration/community-powered-commerce.html"
    @footer_input.set $footer_link
    @browser.execute_script("window.scrollBy(0,3000)")
    @legal_publish_button.click
    
    @browser.wait_until($t) { @legal_publish_confirm_button.present? }
    @legal_publish_confirm_button.when_present.click
    @browser.wait_until($t) { !@legal_publish_confirm_button.present? }
    @browser.wait_until($t) { @legal_confirm_msg.present? }
    @aboutpage = CommunityAboutPage.new(@browser)
    @browser.goto @aboutpage.about_url
    @homepage = CommunityHomePage.new(@browser)
    @browser.wait_until($t) { @homepage.footer.present? }
    @browser.wait_until($t) { @homepage.footer.text.include? "#{$footer_link}" }
  end

  def set_privacy_contact_imprint_and_tou
    check_legal_disclosure_tab
    policy_warning
    privacy_link = "http://go.sap.com/corporate/en/legal/privacy.html"
    tou_link = "http://go.sap.com/corporate/en/legal/terms-of-use.html"
    contact_link = "https://go.sap.com/registration/contact.html"
    imprint_link = "http://go.sap.com/corporate/en/legal/impressum.html"
    
    @browser.wait_until($t) { @tou_text.present? }
    @tou.set tou_link

    @contactus.set contact_link

    @browser.wait_until($t) { @privacy_text.present? }
    @privacy.set privacy_link

    @browser.wait_until($t) {@imprint_text.present? }
    @imprint.set imprint_link

    @legal_preview_button.when_present.click
    @browser.wait_until($t) { @legal_preview_ok_button.present? }
    @legal_preview_ok_button.click
    @browser.wait_until($t) { !@legal_preview_ok_button.present? }
    @browser.wait_until($t) { !@modal.present?}
    @browser.wait_until($t) { @legal_publish_button.present? }

    sleep 1
    @legal_publish_button.when_present.click
    @browser.wait_until($t) { @legal_publish_confirm_button.present? }
    @legal_publish_confirm_button.when_present.click
    sleep 1
    @browser.wait_until($t) { @legal_confirm_msg.present? }
 
    @browser.goto @about_url
    @aboutpage = CommunityAboutPage.new(@browser)
    @browser.wait_until($t) { @aboutpage.about_widget.present? }
    @homepage = CommunityHomePage.new(@browser)
    @browser.wait_until($t) { @homepage.footer_link.present? }
    puts footer_text = @homepage.footer_text.text
    
    @browser.wait_until($t) { footer_text =~ /Privacy Policy/ }
    assert footer_text =~ /Privacy Policy/
    
    @browser.wait_until($t) { footer_text =~ /Terms of Use/ }
    @browser.wait_until($t) { @tou_link.present? }
    assert footer_text =~ /Terms of Use/
    
    @browser.wait_until($t) { footer_text =~ /Contact Us/ }
    assert footer_text =~ /Contact Us/
    
    @browser.wait_until($t) { footer_text =~ /Imprint/ }
    assert footer_text =~ /Imprint/

    @tou_link.click
    @browser.wait_until($t) { @browser.url =~ /#{tou_link}/ }
    check_legal_disclosure_tab
    @tou.clear
    @contactus.clear
    @privacy.clear
    @imprint.clear
    @browser.wait_until($t) { @legal_publish_button.present? }
    sleep 1
    @legal_publish_button.when_present.click
    @browser.wait_until($t) { @legal_publish_confirm_button.present? }
    sleep 1
    @legal_publish_confirm_button.when_present.click
    
    @browser.wait_until($t) { !@legal_publish_confirm_button.present? }
    @browser.wait_until($t) { @legal_confirm_msg.present? }  
  end

  def check_legal_cookie_msg
    if !@admin_page.present?
     @browser.execute_script("window.scrollBy(0,-3000)")  
     goto_admin_page
     @browser.wait_until($t) { @admin_page.present? }
     @browser.wait_until($t) { @admin_page_left_nav.present? }
    end
    policy_warning
    @legal.click
    @browser.execute_script("window.scrollBy(0,6000)")
    @browser.wait_until($t) { @legal_cookie_msg.present? }
    @browser.wait_until($t) { @legal_show_cookie_msg_button.present? }
  end

  def set_legal_cookie_msg
    check_legal_cookie_msg
    @legal_show_cookie_msg_button.click
    @browser.wait_until($t) { @cookie_proceed_button.present? }
    @cookie_proceed_button.when_present.click
    @browser.wait_until($t) { !@cookie_proceed_button.present? }
    @browser.wait_until($t) { @legal_show_cookie_msg_button.present? }

    @browser.refresh
    @loginpage = CommunityLoginPage.new(@browser)
    @browser.wait_until($t) { @loginpage.policy_warning.present? }
    assert @loginpage.policy_warning.present?
  end

  def check_branding_tab
    if !@admin_page.present?
     goto_admin_page
     @browser.wait_until($t) { @admin_page.present? }
     @browser.wait_until($t) { @admin_page_left_nav.present? }
    end
    @branding.click
    @browser.wait_until($t) { @branding_page.present? }
    @browser.wait_until($t) { @branding_heading.present? }
  end

  def set_branding_logo
    check_branding_tab
    @browser.wait_until($t) { @change_logo_button.present? }
    assert @change_logo_button.present?
    #uploading sephora logo
    if $os == "windows"
      @browser.execute_script('$(".photo-upload-browse").removeClass("photo-upload-browse")')
    end
    @change_logo_file_field.set("#{$rootdir}/seeds/development/images/sephora-logo.jpg")
    @browser.wait_until($t) { @logo_cropper.present? }
    
    @logo_select_photo.click
    @browser.wait_until($t) { !@logo_cropper.present?}
    
    @browser.refresh # for asserting img src
    @browser.wait_until($t) { @logo_img.present? }
    @browser.wait_until($t) { @sephora_logo_img.present? }
    assert @sephora_logo_img.present?
    
    #uploading saplogo back
    if $os == "windows"
      @browser.wait_until{ @change_logo_file_field.present? }
      @browser.execute_script('$(".photo-upload-browse").removeClass("photo-upload-browse")')
    end
    @browser.wait_until($t) { @change_logo_button.present? }
    @change_logo_file_field.set("#{$rootdir}/seeds/development/images/saplogo.png")
    @browser.wait_until($t) { @logo_cropper.present? }

    @logo_select_photo.when_present.click
    @browser.wait_until($t) { !@logo_cropper.present?}
    @browser.refresh
    @browser.wait_until($t) { @branding_page.present? }
    @browser.wait_until($t) { @logo_img.present? }
  
    @browser.wait_until($t) { @sap_logo_img.present? }
    signout
  end

  def change_link_color
    check_branding_tab
    set_link_color = "#ff2f92"
    set_link_color_rgb = "rgba(255, 47, 146, 1)"
    @browser.wait_until($t) { @branding_normal_link_color_field.present? }
   
    @browser.execute_script('$("div.col-lg-8 input:first").focus()')
    @browser.execute_script('$("div.col-lg-8 input:first").val("#ff2f92")')
    
    @browser.execute_script("window.scrollBy(0,7000)")
    @branding_publish_button.click

    @browser.wait_until(50) { !@branding_publish_spinner.present? }
   # sleep 4
   # @browser.wait_until($t) { !@branding_publish_progress.present? }
    @topicdetailpage = CommunityTopicDetailPage.new(@browser)
    @browser.goto @topicdetailpage.topicpage_url
    @browser.wait_until($t) { @topicdetailpage.topic_page.present? }
    home_link_color = @community_breadcrumb.style('color')
  
    #puts home_link_color #= @profile_link_color.style('color')
    assert_match set_link_color_rgb, home_link_color, "Link color is not per branding settings"
    check_branding_tab
    @browser.execute_script('$("div.col-lg-8 input:first").focus()')
    @browser.execute_script('$("div.col-lg-8 input:first").val("#0433ff")')
    
    @browser.execute_script("window.scrollBy(0,7000)")
    @branding_publish_button.click

    @browser.wait_until(50) { !@branding_publish_spinner.present? }
    sleep 1

  end

  def change_button_color
    check_branding_tab
    set_button_color = "#ffd479"
    set_button_color_rgb = "rgba(255, 212, 121, 1)"
    @browser.wait_until($t) { @branding_normal_link_color_field.present? }
    @browser.execute_script("window.scrollBy(0,2000)")

    @branding_button_color_field.focus
    @branding_button_color_field.set "#ffd479"
    
    @browser.execute_script("window.scrollBy(0,7000)")
    @branding_publish_button.click

    @browser.wait_until($t) { @branding_publish_button.present? }
    @browser.wait_until($t) { !@branding_publish_progress.present? }
    @topicdetailpage = CommunityTopicDetailPage.new(@browser)
    @browser.goto @topicdetailpage.topicpage_url
    @browser.wait_until($t) { @topicdetailpage.topic_page.present? }
    @topicdetailpage.first_topic_link.click
    @browser.wait_until($t) { @topicdetailpage.topic_filter.present? }
    create_new_button_color = @topicdetailpage.topic_detail_create_new_button.style('background-color')
  
    assert_match set_button_color_rgb, create_new_button_color, "Button color is not per branding settings"
    check_branding_tab
    @browser.wait_until($t) { @branding_reset_button.present? }
    @branding_reset_button.when_present.click 
    @branding_publish_button.when_present.click
    @browser.wait_until($t) { @branding_publish_button.present? }
    @browser.wait_until($t) { !@branding_publish_progress.present? }
    sleep 1
  end

  def set_favicon
    check_branding_tab
    nike_favicon = "https://g.foolcdn.com/editorial/images/182320/nike_logo_02_large.jpg"

    @browser.wait_until($t) { @branding_normal_link_color_field.present? }
    @browser.execute_script("window.scrollBy(0,5000)")

    @favicon_field.focus
    @favicon_field.set nike_favicon
   
    @browser.execute_script("window.scrollBy(0,7000)")
    @branding_publish_button.click

    @browser.wait_until($t) { @branding_publish_button.present? }
    @browser.wait_until($t) { !@branding_publish_progress.present? }
    @topicdetailpage = CommunityTopicDetailPage.new(@browser)
    @browser.goto @topicdetailpage.topicpage_url
    @browser.wait_until($t) { @topicdetailpage.topic_page.present? }
    @browser.wait_until($t) { @browser.html =~ /nike_logo/ }
    assert @browser.html =~ /nike_logo/
   
    check_branding_tab
    @browser.wait_until($t) { @branding_reset_button.present? }
    @branding_reset_button.when_present.click 
    @branding_publish_button.when_present.click
    @browser.wait_until($t) { @branding_publish_button.present? }
    @browser.wait_until(60) { !@branding_publish_progress.present? }
    sleep 1

  end

  def check_widget_theme_builder
    if !@admin_page.present?
     goto_admin_page
     @browser.wait_until($t) { @admin_page.present? }
     @browser.wait_until($t) { @admin_page_left_nav.present? }
    end
    @widget_theme.click
    @browser.wait_until($t) { @widget_theme_page.present? }
    @browser.wait_until($t) { @widget_theme_create_button.present? || @widget_theme_edit_button.present? }
  end

  def check_email_designer_option
    if !@admin_page.present?
     goto_admin_page
     @browser.wait_until($t) { @admin_page.present? }
     @browser.wait_until($t) { @admin_page_left_nav.present? }
    end
    @browser.execute_script("window.scrollBy(0,900)")
    @email_designer.click
    @browser.wait_until($t) { @email_designer_page.present? }
    @browser.wait_until($t) { @email_designer_edit_button.present? }
  end

  def edit_email_template
    email_text_color = "color:#0000A0"
    email_text_color_hex = "0000A0"
    email_text_color_rgb = "rgb(0, 0, 160)"
    check_email_designer_option
    @email_designer_edit_button.click
    @browser.wait_until($t) { @email_edit_page.present? }
    @browser.execute_script('$("div.email-edit").css("display", "block")')
    @browser.wait_until($t) { @email_edit_icon.present? }
    @email_edit_icon.when_present.click
    @browser.wait_until($t) { @email_bg_textarea.present? }
    #@email_bg_textarea.focus
    #@email_bg_textarea.clear
    @browser.execute_script('$("int_background_style ember-view ember-text-area").val(" ")')
    sleep 2
    @email_bg_textarea.set "color:#0000A0"
    @browser.execute_script('$("textarea.int_background_style ember-view ember-text-area").blur()')
    sleep 2
    @email_preview_button.click
    @browser.wait_until($t) { @email_preview_page.present? }
    preview_email = @email_preview_bg_style.style
    #puts preview_email = #0000A0.to_s(16) #hex
    assert_match email_text_color_rgb, preview_email, "Preview settings doesn't match with set value"

    @browser.wait_until($t) { @email_preview_ok_button.present? }
    @email_preview_ok_button.when_present.click
    @browser.wait_until($t) { !@email_preview_ok_button.present? }
    @browser.wait_until($t) { @email_publish_button.present? }
    @browser.wait_until($t) { @email_cancel_button.present? }
    @email_cancel_button.when_present.click
    @browser.wait_until($t) { @email_footer_cancel_button.present? }
    @email_footer_cancel_button.when_present.click 
    @browser.wait_until($t) { @email_designer_page.present? }
  end

  def profile_field_option
   if !@admin_page.present?
    goto_admin_page
    @browser.wait_until($t) { @admin_page.present? }
    @browser.wait_until($t) { @admin_page_left_nav.present? }
   end
    @profile_field.click 
    @browser.wait_until($t) { @profile_field_page.present? }
  end

  def check_mandatory_profile_field
    skip
  end

  def check_permission_option
    if !@admin_page.present?
     goto_admin_page
     @browser.wait_until($t) { @admin_page.present? }
     @browser.wait_until($t) { @admin_page_left_nav.present? }
    end
    @permission.click 
    @browser.wait_until($t) { @permission_card.present? }
  end

  def promote_a_user_as_net_admin
   promote_user_role($network, $networkslug, $user3, "netadmin")
   revert_user_role($network, $networkslug, $user3, "netadmin")
  end

  def promote_a_user_as_net_mod
   promote_user_role($network, $networkslug, $user3, "netmod")
   revert_user_role($network, $networkslug, $user3, "netmod") 
  end

  def promote_a_user_as_topic_admin
   promote_user_role($network, $networkslug, $user12, "topicadmin")
   revert_user_role($network, $networkslug, $user12, "topicadmin")
  end

  def promote_a_user_as_topic_mod
   promote_user_role($network, $networkslug, $user12, "topicmod")
   revert_user_role($network, $networkslug, $user12, "topicmod")
  end

  def check_reports_option
    if !@admin_page.present? || !@admin_page_left_nav.present?
     goto_admin_page
     @browser.wait_until($t) { @admin_page.present? }
     @browser.wait_until($t) { @admin_page_left_nav.present? }
    end
    @report.click
    
    @browser.wait_until($t) { @pageview_daily.present? }
    @browser.wait_until($t) { @pop_content.present? }
    @browser.wait_until($t) { @responsiveness.present? }
    @browser.wait_until($t) { @traffic.present? }
    @browser.wait_until($t) { @business.present? }
    @browser.wait_until($t) { @liveliness.present? }
    @browser.wait_until($t) { @members.present? }
    @browser.wait_until($t) { @interaction.present? }
    @browser.wait_until($t) { @pageview_export_button.present? }
  end

  def check_page_view_weekly
    check_reports_option
    @pageview_weekly.click
    @browser.wait_until($t) { @pageview_weekly_yearly_graph.present? }
  end

  def check_page_view_monthly
    check_reports_option
    @pageview_monthly.click
    @browser.wait_until($t) { @pageview_weekly_yearly_graph.present? }
  end

  def check_page_view_yearly
    check_reports_option
    @pageview_yearly.click
    @browser.wait_until($t) { @pageview_weekly_yearly_graph.present? }
  end

  def check_pop_content_weekly
    check_reports_option
    @pop_content.click
    @browser.wait_until($t) { @pop_pie_conv.present? }
    @browser.wait_until($t) { @pop_pie_conv_title.present? }
    @browser.wait_until($t) { @pop_pie_info.present? }
    @browser.wait_until($t) { @pop_pie_topic_title.present? }
    @browser.wait_until($t) { @pop_pie_topic.present? }
    @browser.wait_until($t) { @pop_text.present? }
  end

  def check_pop_content_monthly
    check_reports_option
    @pop_content.click
    @browser.wait_until($t) { @pop_monthly.present? }
    @pop_monthly.click
    @browser.wait_until($t) { @pop_pie_conv.present? }
    @browser.wait_until($t) { @pop_pie_conv_title.present? }
    @browser.wait_until($t) { @pop_pie_info.present? }
    @browser.wait_until($t) { @pop_pie_topic_title.present? }
    #@browser.execute_script("window.scrollBy(0,800)")
    #@browser.wait_until($t) { @pop_pie_topic.present? }
    #@browser.wait_until($t) { @pop_text.present? }
  end

  def check_responsiveness
    if !@admin_page.present? || !@admin_page_left_nav.present?
     goto_admin_page
     @browser.wait_until($t) { @admin_page.present? }
     @browser.wait_until($t) { @admin_page_left_nav.present? }
    end
    @admin_report_link.click
    @browser.wait_until($t) { @pageview_graph.present? }
    @responsiveness.click
    @browser.wait_until($t) { @resp_chart.present? }
    @browser.wait_until($t) { @resp_pie_title.present? }
    @browser.wait_until($t) { @resp_text.present? }
  end

  def check_traffic
    if !@admin_page.present? || !@admin_page_left_nav.present?
     goto_admin_page
     @browser.wait_until($t) { @admin_page.present? }
     @browser.wait_until($t) { @admin_page_left_nav.present? }
    end
    @admin_report_link.click
    @browser.wait_until($t) { @pageview_graph.present? }

    @traffic.click
    @browser.wait_until($t) { @traffic_return_user.present? }
    @browser.wait_until($t) { @traffic_return_user_graph.present? }
  end

  def check_business_comm_cta
    if !@admin_page.present? || !@admin_page_left_nav.present?
     goto_admin_page
     @browser.wait_until($t) { @admin_page.present? }
     @browser.wait_until($t) { @admin_page_left_nav.present? }
    end
    @admin_report_link.click
    @browser.wait_until($t) { @pageview_graph.present? }

    @business.click
    @browser.wait_until($t) { @business_community_cta_graph.present? }
    @browser.wait_until($t) { @business_community_cta_weekly.present? }
  end

  def check_business_hybris_cta
    if !@admin_page.present? || !@admin_page_left_nav.present?
     goto_admin_page
     @browser.wait_until($t) { @admin_page.present? }
     @browser.wait_until($t) { @admin_page_left_nav.present? }
    end
    @admin_report_link.click
    @browser.wait_until($t) { @pageview_graph.present? }

    @business.click
    @browser.wait_until($t) { @business_comm_cta.present? }
    @browser.wait_until($t) { @business_community_cta_graph.present? }
    @business_hybris_cta_link.click
    @browser.wait_until($t) { @business_hybris_cta_graph.present? }
  end

  def check_liveliness
    if !@admin_page.present? || !@admin_page_left_nav.present?
     goto_admin_page
     @browser.wait_until($t) { @admin_page.present? }
     @browser.wait_until($t) { @admin_page_left_nav.present? }
    end
    @admin_report_link.click
    @browser.wait_until($t) { @pageview_graph.present? }

    @liveliness.click
    @browser.wait_until($t) { @liveliness_table.present? }
  end

  def check_members_new_users
    if !@admin_page.present? || !@admin_page_left_nav.present?
     goto_admin_page
     @browser.wait_until($t) { @admin_page.present? }
     @browser.wait_until($t) { @admin_page_left_nav.present? }
    end
    @admin_report_link.click
    @browser.wait_until($t) { @pageview_graph.present? }

    @members.click
    @browser.wait_until($t) { @members_new_regis_user_graph.present? }
  end

  def check_members_post_growth
    if !@admin_page.present? || !@admin_page_left_nav.present?
     goto_admin_page
     @browser.wait_until($t) { @admin_page.present? }
     @browser.wait_until($t) { @admin_page_left_nav.present? }
    end
    @admin_report_link.click
    @browser.wait_until($t) { @pageview_graph.present? }

    @members.click
    @browser.wait_until($t) { @members_new_regis_user_graph.present? }
    @members_post_growth.click
    @browser.wait_until($t) { @members_post_growth_graph.present? }

  end

  def check_interaction
    if !@admin_page.present? || !@admin_page_left_nav.present?
     goto_admin_page
     @browser.wait_until($t) { @admin_page.present? }
     @browser.wait_until($t) { @admin_page_left_nav.present? }
    end
    @admin_report_link.click
    @browser.wait_until($t) { @pageview_graph.present? }

    @interaction.click
    @browser.wait_until($t) { @interaction_graph.present? }
  end

  def check_hybris_option
   if !@admin_page.present?
     goto_admin_page
     @browser.wait_until($t) { @admin_page.present? }
     @browser.wait_until($t) { @admin_page_left_nav.present? }
    end
    @browser.execute_script("window.scrollBy(0,900)")
    @hybris_ecomm.click 
    @browser.wait_until($t) { @ecomm_int_page.present? }
  end

  def check_hybris_config_tab
    check_hybris_option
    @ecomm_int_config.click
    @browser.wait_until($t) { @ecomm_int_config_page.present? }
    @browser.wait_until($t) { @ecomm_int_save_button.present? }
    @browser.wait_until($t) { @ecomm_int_sync_button.present? }
  end

  def check_hybris_history_tab
    check_hybris_option
    @ecomm_int_history.click
    @browser.wait_until($t) { @ecomm_int_history_page.present? }
    @browser.wait_until($t) { @ecomm_int_history_resync_button.present? }
  end

  def check_oauth_config_option
   if !@admin_page.present?
     goto_admin_page
     @browser.wait_until($t) { @admin_page.present? }
     @browser.wait_until($t) { @admin_page_left_nav.present? }
    end
    @oauth_configuration.click
    @browser.wait_until($t) { @oauth_page.present? }
    @browser.wait_until($t) { @oauth_page_new_app_button.present? }
  end

  def oauth_new_app_cancel_button 
    # Scope the cancel button within the currentyl open modal and not on the entire DOM
    # There are 3 buttons on this page and the definition of cancel button didn't ever find the correct one
    #  $(".btn.btn-default")
        # [<button type=​"button" class=​"btn btn-default" data-ember-action=​"1508">​Regenerate Token​</button>​, 
        # <button type=​"button" class=​"btn btn-default" data-dismiss=​"modal">​Cancel​</button>​, 
        # <button type=​"button" class=​"btn btn-default" data-dismiss=​"modal">​Cancel​</button>​]

        # Correct fix : Ask developer to add the correct class name to the cancel  button and not just "btn btn-default"
    @browser.div(:class => "modal fade in").button(:class => "btn btn-default", :text => "Cancel")
  end

  def check_oauth_new_app_field_and_button
    check_oauth_config_option
    @browser.wait_until($t) { @oauth_page_new_app_button.present? }
    @oauth_page_new_app_button.when_present.click
    @browser.wait_until($t) { @oauth_new_app_name_field.present? }
    @browser.wait_until($t) { @oauth_new_app_save_button.present? }
    @browser.wait_until($t) { oauth_new_app_cancel_button.present? }
  end
end

