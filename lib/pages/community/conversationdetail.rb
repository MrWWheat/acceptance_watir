require 'pages/community'
require 'pages/community/topicdetail'
require 'pages/community/profile'
require 'pages/community/about'
require 'pages/community/conversation/publish_setting'
require 'pages/community/gadgets/top_hybris_nav'
#require 'watir_test'
require 'minitest/assertions'

class Pages::Community::ConversationDetail < Pages::Community

  def initialize(config, options = {})
    super(config)
    @url = config.base_url + "/n/#{config.slug}"
  end
  
  def start!(user)
    super(user, @url)   
  end

  conv_breadcrumbs_topic_link             { link(:css => ".breadcrumbs a[href^='/topic/']") }

  # topic_page                              { div(:id => "topics").div(:class => "col-sm-12 col-lg-4 col-md-4").div(:class => "topic").link(:class => "ember-view").div(:class => "topic-avatar") }
  conv_show_more_link 	                  { link(:text => "Show more") }
  conv_post_collection                    { div(:class => "post-collection") }

  answer_level1 		                      { div(:class => /ember-view depth-1 answer post/) }
  root_post_title 		                    { h3(:class => "root-post-title") }

  depth0_d 				                        { div(:class => /depth-0 discussion/) }
  depth0_q 				                        { div(:class => /depth-0 question/) }

  conv_content 			                      { div(:class => /conversation-content/) }
  first_conv_link 		                    { div(:class => "post-collection").div(:class => "media-heading").link }

  root_post 			                        { div(:class => /root-post/) }
  root_post_blog 		                      { div(:class => /ember-view root-post/) }

  featured 				                        { span(:class => "featured-post-collection") }
  featured_answer 		                    { div(:class => "featured-post-collection").div(:class => "ember-view") }
  featured_comment 		                    { div(:class => "featured-post-collection").div(:class => "ember-view") }
  conv_feature			                      { span(:class => "featured") }
  featured_root 		                      { span(:class => "featured") }

  comment_level1 		                      { div(:class => /ember-view depth-1 post/) }

  root_post_feature_dropdown              { div(:class => /depth-0/).span(:class => "dropdown-toggle") }

  #================= root post info fields =================
  conv_type_flag                          { span(:css => ".conversation .post-type") }
  conv_title                              { h3(:class => "root-post-title") }
  conv_review_recommend_flag              { element(:css => ".conversation-info .review-recommend") }
  conv_review_rating_full_stars           { elements(:css => ".review-rating .full-star") }
  conv_user_link                          { link(:css => ".conversation-info .network-profile-pill a") }
  conv_featured_flag                      { element(:css => ".conversation-info .featured") }

  conv_detail 				                    { div(:class => /ember-view root-post/) }
  conv_des                                { div(:class => "post-content") }
  conv_create                             { text_field(:class => "form-control ember-view ember-text-field") }
  conv_reply_input                        { div(:class => "input") }
  conv_reply                              { div(:class => /ember-view depth-1/).div(:class => "input", :index => 0) }
  conv_reply_remove_alert                 { p(:css => ".depth-1 .moderation-alert")}

  post_content                            { div(:class => "post-content") }
  reply_post_content                      { div(:class => /depth-1/).div(:class => "post-content") }

  reply                                   { div(:class => /depth-1/) }
  reply_box                               { textarea(:class => "ember-view ember-text-area form-control") }
  edit_reply_box                          { textarea(:class => "ember-text-area", :index => 2)}
  reply_submit                            { div(:class => "group text-right").button(:value => /Submit/) } 
  edit_reply_submit                       { button(:css => ".group.text-right .btn-primary", :index => 1)}
  edited_reply_content                    { div(:css => ".post-content.customization-reply-post-content") }

  suggested_post                          { div(:class => "shown") }

  conv_featured_comment                   { div(:class => "featured-post-collection") }
  conv_root_post_featured                 { span(:class => "featured") }

  reply_submit_button                     { button(:value => /Submit/) }
  
  conv_reply_view                         { div(:class => /ember-view/) }
  depth2_reply                            { div(:class => /ember-view depth-2/).div(:class => /input/) }

  reply_dropdown_toggle                   { div(:class => /ember-view depth-1/).span(:class => "dropdown-toggle") }
  reply_menu                              { div(:class => "dropdown pull-right open").li(:index => 1) }
  reply_feature_option                    { link(:class => "feature-class") }
  reply_mark_best_answer                  { div(:class => "dropdown pull-right open").link(:text => "Mark as best answer") }
  reply_menu_edit                         { div(:class => "dropdown pull-right open").link(:text => "Edit") }
  reply_menu_delete                       { div(:class => "dropdown pull-right open").link(:text => "Delete") }
  reply_reply_link                        { span(:css => ".post-actions-line.not-root-post .replies") }
  reply_like_link                         { span(:css => ".post-actions-line.not-root-post .like-hollow") }
  reply_mod_menu                          { div(:class => "dropdown pull-right open").link(:text => "Permanently Remove") }
  reply_mod_menu_reinstate                { div(:class => "dropdown pull-right open").link(:text => "Reinstate this content") }
  reply_flag_option                       { div(:class => "dropdown pull-right open").link(:text => "Flag as inappropriate") }

  post_body                               { div(:class => "media-body") }
  conv_detail_sort                        { div(:class => "pull-right sort-by dropdown").span(:class=> "dropdown-toggle").span(:class => "icon-down fs-7") }
  conv_detail_sort_text                   { div(:class => "pull-right sort-by dropdown").span(:class=> "dropdown-toggle") }
  conv_detail_sort_dropdown_open          { div(:class => "pull-right sort-by dropdown open") }
  conv_detail_oldest_link                 { link(:text => "Oldest") }
  conv_detail_newest_link                 { link(:text => "Newest") }
  
  conv_page                               { div(:class => /ember-view root-post depth-0/).div(:class => "media-body").div(:class => "post-content") }
    
  conv_detail_authorname                  { link(:css => ".root-post .network-profile-pill > a") }
  conv_reply_ans                          { div(:class => /ember-view depth-1 answer post/).div(:class => "media post-body").div(:class => "media-body").div(:class =>"post-content").div(:class => "input") }
    
  topic_sort_post_by_newest_button        { button(:class => "btn btn-default dropdown-toggle filter-dropdown sap-regular-dropdown", :text => "Sort by: Newest") }

  level1_reply                            { div(:class => "ember-view depth-1 post") }
  root_post_feature                       { span(:class => "featured") }

  conv_detail_title                       { h3(:class => "root-post-title") }
  convdetail                              { h3(:class => "root-post-title") }

  # conv_detail_topic_link                  { div(:class => "crumb conversation-creator").div.span(:class => "topic").link(:class => "ember-view") }

  post_type_picker                        { div(:class => "row post-type-picker") }
  conv_suggest_shown                      { div(:class => "shown") }

  spinner                                 { i(:class => "fa fa-spinner fa-spin") }
  conv_root_post_like_link                { element(:css => ".root-post .post-actions-line [class^=like]") }
  conv_root_post_reply_link              { element(:css => ".root-post .post-actions-line .replies") }
  conv_root_post_follow_link              { element(:css => ".root-post .post-actions-line .follows") }

  reply_like_disc_element                 { div(:class => /depth-1/).span(:css => ".post-actions-line .like-hollow:not(.action-done)") }
  reply_unlike_disc_element               { div(:class => /depth-1/).span(:css => ".post-actions-line .like-hollow.action-done") }

  conv_blog_alert                         { div(:class => "alert alert-warning") }
  conv_blog_schedule_change_link          { div(:class => "alert alert-warning").link(:text => /Change/) }

  livechat_link                           { link(:class => "live-chat-link")}
  livechat_sender                         { div(:class => "chat-sender")}

  recent_mention_prod_list                { element(:text => "Recently Mentioned Products").parent }
  recent_mention_prods_widget_spinner     { i(:css => ".recent_mention_products fa-spinner") }
  prod_card_placeholders                  { divs(:css => ".product-card-placeholder") }
  dropdown_arrow                          { span(:class => "icon-navigation-down-arrow") }
  dropdown_menu                           { div(:class =>"dropdown pull-right open").ul(:class => /dropdown-menu/)}
  dropdown_edit                           { ul(:class => "dropdown-menu moderator-post-actions-menu").link(:text => /Edit/) }
  dropdown_delete                         { ul(:class => "dropdown-menu moderator-post-actions-menu").link(:text => /Delete/) }
  dropdown_fearure                        { ul(:class => "dropdown-menu moderator-post-actions-menu").link(:text => /Feature this conversation/) }
  dropdown_flag                           { ul(:class => "dropdown-menu moderator-post-actions-menu").link(:text => /Flag as inappropriate/) }
  dropdown_escalate                       { ul(:class => "dropdown-menu moderator-post-actions-menu").link(:text => /Escalate/) }
  dropdown_close                          { ul(:class => "dropdown-menu moderator-post-actions-menu").link(:text => /Close/) }
  dropdown_reopen                         { ul(:class => "dropdown-menu moderator-post-actions-menu").link(:text => /Reopen/) }
  dropdown_remove                         { ul(:class => "dropdown-menu moderator-post-actions-menu").link(:text => /Permanently Remove/) }
  dropdown_reinstate                      { ul(:class => "dropdown-menu moderator-post-actions-menu").link(:text => /Reinstate this content/) }
  conv_root_post_dropdown_flag            { ul(:css => ".root-post .dropdown-menu").link(:text => /Flag/) }
  product_cards_in_root_post              { divs(:class => /variant-card/) }
  product_cards_in_comments               { div(:class=> "comments").divs(:class => /variant-card/) }
  product_codes_in_root_post              { ps(:css => ".root-post .product-code") }
  product_codes_in_comments               { ps(:css => ".comments .product-code") }
  product_names_in_root_post              { ps(:css => ".root-post .less-variant-card .variant-product-title") }
  product_names_in_comments               { ps(:css => ".comments .less-variant-card .variant-product-title") }

  reply_text_field                        { text_field(:id => "wmd-input") }
  mentioned_list                          { div(:class => "at-list-wrap") }
  mention_tag_list                        { ul(:class => "at-list at-tag-list")}
  conversation_product                    { div(:class => /conversation-product/) }
  conv_prodcard_toggle                    { button(:css => ".new-conversation-product button.toggle-product-card") }
  conv_prodcard_addtocard_link            { link(:css => ".new-conversation-product .add-to-cart") }
  reply_conversation_modal                { div(:class => "post-body") }
  submit_btn                              { button(:text => /Submit/) }
  reply_dropdown_arrow                    { spans(:class => "icon-navigation-down-arrow")[1] }
  reply_dropdown_edit                     { uls(:class => "moderator-post-actions-menu")[1].link(:text => /Edit/) }
  edit_reply_text_field                   { text_fields(:class => "reply-box")[1] }
  edit_reply_mentioned_list               { divs(:class => "at-list-wrap")[1] }

  add_to_cart_btns                        { links(:text => "Add To Cart")}

  facebook_sharing_button                 { span(:class => "common-share facebook")}
  twitter_sharing_button                  { span(:class => "common-share twitter")}
  linkedin_sharing_button                 { span(:class => "common-share linkedin")}
  google_sharing_button                   { span(:class => "common-share google-plus")}

  insert_image_btn                        { i(:css => ".note-insert .note-icon-picture") }
  # insert_image_dialog                     { div(:class => "note-dialog")}
  insert_image_url_input                  { text_field(:css => ".modal-dialog .note-image-url")}
  insert_image_confirm_btn                { button(:css => ".modal-footer .note-image-btn")}

  tooltip_mention_btn                 { span(:data_type => "product")}
  tooltip_mention_btns                { spans(:data_type => "product")}
  tooltip_tag_btn                     { span(:data_type => "tag")}
  tooltip_tag_btns                    { spans(:data_type => "tag")}

  tag_link                            { link(:class => "tag-mention")}
  tag_links                           { links(:class => "tag-mention")}

  mention_tooltip                     { span(:class => "tooltips")}
  mention_tooltips                    { spans(:class => "tooltips")}

  post_delete_confirm_dlg             { div(:css => ".post-delete-confirm") }
  post_delete_confirm_dlg_delete_btn  { button(:css => ".post-delete-confirm .modal-footer .btn-primary") }

  contributor_rating_level_icon       { div(:class => "contributor-level-meta")}
  conv_detail_creator_pills           { elements(:css => ".network-profile-pill") }
  conv_detail_posts_creator_pills     { elements(:css => ".post .network-profile-pill") }
  conv_detail_widget_creator_pills    { elements(:css => ".widget .network-profile-pill") }

  conv_detail_posts_avatars           { divs(:css => ".post .media .media-object[alt*=person]") }
  conv_detail_site_widgets_avatars    { divs(:css => ".side-gadget .media .media-object[alt*=person]") }

  conv_detail_loading_block           { div(:css => ".loading-block") }
  
  conv_flag_confirm_dlg               { div(:css => "#report-post-modal .modal-dialog") }
  conv_flag_confirm_dlg_submit_btn    { button(:css => "#report-post-modal .btn-primary") }
  conv_flagged_root_post              { div(:css => ".root-post.flagged") }

  conv_moderation_alert               { element(:css => "#moderation-message .moderation-alert") }
  conv_mod_action_approve_btn         { button(:css => ".moderation-actions button.approve") }
  conv_mod_action_reject_btn          { button(:css => ".moderation-actions button.reject") }
  conv_moderation_alert_for_root_owner { p(:class => "moderation-alert", :text => /Other users will be able to see it once it is approved/) }

  conv_social_share_box               { div(:css => "#share-box") }

  flag_confirm_modal                  { div(:css => "#report-post-modal.modal.fade.in .modal-dialog") }
  flag_reason_input                   { div(:class => "modal fade  in").textarea(:class => "ember-view ember-text-area") }
  flag_confirm_modal_submit           { div(:class => "modal fade  in").button(:class => "btn btn-primary", :text => "Submit") }

  permanently_remove_confirm_modal    { div(:class => "modal in").div(:class => "modal-dialog")}
  permanently_remove_confirm_btn      { div(:class => "modal in").button(:class => "btn btn-primary", :text => /Remove/)}

  conv_close_confirm_modal_primary_btn  { button(:css => ".root-post #conversation-close-action-confirm .btn-primary")}    

  def create_conversation(network, networkslug, topic_name, posttype, title, widget=true)
    @topicdetail_page = Pages::Community::TopicDetail.new(@config)
    @login_page = Pages::Community::Login.new(@config)
    @profile_page = Pages::Community::Profile.new(@config)
    @about_page = Pages::Community::About.new(@config)
    @browser.wait_until { @topicdetail_page.topic_filter.present? || @login_page.login_body.present? || @profile_page.profile_activity.present? || @about_page.about_widget.present?  }

    if ( !@topicdetail_page.topic_filter.present?)
      @browser.goto @topicdetail_page.topicpage_url
      @browser.wait_until { @topicdetail_page.topic_page.present? }
    end
    if (@login_page.signin_link.present?)
      @login_page.login!(@c.users[:network_admin])
    end
    @topicdetail_page.topic_detail(topic_name)
    @browser.wait_until { @topicdetail_page.topic_filter.present? }
    assert @topicdetail_page.topic_follow_button.present? || @topicdetail_page.topic_unfollow_button.present?
    if @topicdetail_page.topic_publish_change_button.present?
      @topicdetail_page.topic_publish_change_button.click
      @browser.wait_until {@topicdetail_page.topic_edit_button.present? }
      assert @topicdetail_page.topic_edit_button.present?
    end
    if posttype == "review"
      @browser.wait_until{@topicdetail_page.topic_featuredb.present?}
      @topicdetail_page.topic_review_filter.click
      @browser.wait_until { @topicdetail_page.new_review_button.present? }
      @topicdetail_page.new_review_button.click
    else
      @topicdetail_page.topic_create_new_button.when_present.click
      @browser.ul(:css => ".topic-follow-button .dropdown .dropdown-menu").link(:text => "Question").when_present.click

      @browser.wait_until { conv_create.present? }
    end
    conv_create.when_present.set title
    accept_policy_warning
    if posttype.start_with?("question")
      @browser.wait_until { suggested_post.present? } #suggested posts
      if !@browser.div(:class => "post-type question chosen").present?
        @browser.div(:class => "post-type question ").when_present.click
      end
      @browser.wait_until { @browser.div(:class => "post-type question chosen").present? }
    elsif posttype.start_with?("discussion")
      @browser.wait_until { @browser.div(:class => "shown").exists? } #suggested posts
      if !@browser.div(:class => "post-type discussion chosen").present?
        @browser.div(:class => "post-type discussion ").when_present.click
      end
      @browser.wait_until { @browser.div(:class => "post-type discussion chosen").present? }
    elsif posttype.start_with?("blog")
      if !@browser.div(:class => "post-type blog chosen").present?
        @browser.div(:class => "post-type blog ").when_present.click
      end
      @browser.wait_until { @browser.div(:class => "post-type blog chosen").present? }
    end

    if posttype.end_with?("blog")
      @browser.execute_script('$("div.note-editable").html($("div.note-editable").html() + "Watir test description")')
      @browser.execute_script('$("div.note-editable").blur()') #needed to communicate the description back to the parent element. the blur events fires fine during manual creation.
      @browser.execute_script("window.scrollBy(0,600)")
      @browser.wait_until { @browser.div(:class => "controls text-right").button(:class => "btn btn-primary conversation-submit").present? }
      submit_value = @browser.div(:class => "controls text-right").button(:class => "btn btn-primary conversation-submit").text
      if(submit_value == "Send to admin")
        @browser.div(:class => "controls text-right").button(:class => "btn btn-primary conversation-submit", :value => "Send to admin").when_present.click
        @browser.wait_until { @browser.div(:class => "modal fade  in").present? }
        @browser.div(:id => "delayed-publish-modal").div(:class => "modal-dialog").div(:class => "modal-content").div(:class => "modal-footer").button(:value => /Send to admin/).click
      else
        @browser.div(:class => "controls text-right").button(:class => "btn btn-primary conversation-submit", :value => "Submit").when_present.click
        @browser.wait_until { @browser.div(:class => "modal fade  in").present? }
        @browser.div(:id => "delayed-publish-modal").div(:class => "modal-dialog").div(:class => "modal-content").div(:class => "modal-footer").button(:value => /Submit/).click
      end
      sleep 2
      @browser.wait_until { !@browser.div(:class => "modal fade  in").present? }

      @browser.wait_until($t) { convdetail.present? }
    else
      @browser.execute_script('$("div.note-editable").html($("div.note-editable").html() + "Watir test description")')
      @browser.execute_script('$("div.note-editable").blur()') #needed to communicate the description back to the parent element. the blur events fires fine during manual creation.
      @browser.execute_script("window.scrollBy(0,600)")
      if posttype.end_with?("video")
        @browser.execute_script('$("button[data-event=showVideoDialog]").click()')
        @browser.wait_until { @browser.text_field(:class => "note-video-url").present? }

        video_url = "https://www.youtube.com/watch?v=prCKZg5ONGg"

        assert @browser.text_field(:class => "note-video-url").present?, "Modal for video not present"
        @browser.text_field(:class => "note-video-url").set(video_url)
        @browser.button(:class => "btn-primary note-video-btn").when_present.click
      elsif posttype.end_with?("link")
        @browser.execute_script('$("div.note-editable").text("http://www.jambajuice.com\n")')
        @browser.execute_script('$("div.note-editable").focus()')
        @browser.send_keys :space
        @browser.execute_script("window.scrollBy(0,800)")

        @browser.wait_until { @browser.img(:src => /jambajuice/).present? }
        @browser.wait_until { @browser.p( :text => "Healthy breakfast, quick lunch or a delicious snack. Try Jamba Juice fruit smoothies, all-natural baked goods, steel-cut oatmeal, sandwiches and other healthy choices for an active lifestyle.").present? }

        assert @browser.img(:src => /jambajuice/).present?
        assert @browser.div(:class => "note-editable").p(:text => "Healthy breakfast, quick lunch or a delicious snack. Try Jamba Juice fruit smoothies, all-natural baked goods, steel-cut oatmeal, sandwiches and other healthy choices for an active lifestyle.").present?
      elsif posttype.end_with?("image")
        insert_image_btn.when_present.click
        @browser.wait_until($t) {insert_image_url_input.present? }
        image_url = "http://insidebigdata.com/wp-content/uploads/2015/03/SAP_logo.gif"
        insert_image_url_input.when_present.set image_url
        insert_image_confirm_btn.when_present.click
        @browser.wait_until($t) {!insert_image_url_input.present? }
        sleep 1 # sometimes image failed to save in local
      elsif posttype.end_with?("rte")
        @browser.button(:css => ".note-btn-italic,button[data-name=italic]").click
        @browser.button(:css => ".note-current-color-button,.note-recent-color").click
        @browser.div(:class => "note-editable").send_keys "description"
        text_bg_color = @browser.div(:class => "note-editable").p.span.style('background-color')
        @browser.execute_script('$("div.note-editable").blur()') #needed to communicate the description back to the parent element. the blur events fires fine during manual creation.
        @browser.execute_script("window.scrollBy(0,600)")
      end
      @browser.wait_until { @browser.div(:class => "controls text-right").button(:class => "btn btn-primary").present? }
      if @browser.div(:class => "controls text-right").button(:class => "btn btn-primary").text == "Submit"
        @browser.div(:class => "controls text-right").button(:class => "btn btn-primary").when_present.click
      else
        @browser.div(:class => "controls text-right").button(:class => "btn btn-primary").when_present.click
        sleep(3)
        @browser.button(:css => ".modal.fade.in .modal-dialog .modal-footer .btn-primary").when_present.click
      end
    end

    @browser.wait_until { !spinner.present? }
    @browser.wait_until { @browser.div(:class => /depth-0/).present?}

    if posttype.end_with?("link")
      @browser.wait_until { @browser.div(:class => "post-content").present? }
      @browser.wait_until { @browser.img(:src => /image_preview/).present? }
      assert @browser.div(:class => "post-content").present?
      assert @browser.img(:src => /image_preview/).present?
    elsif posttype.end_with?("rte")
      assert text_bg_color == @browser.div(:class => "post-content").p(:index => 0).span.style('background-color')
    end

    return title
  end

  def conversation_detail(type, post_name = nil)
    accept_policy_warning
    if !(post_name == nil)
      until @browser.text.include? post_name
      @browser.execute_script("window.scrollBy(0,1900)")
      conv_show_more_link.click
      @browser.wait_until { conv_post_collection.present? }
      @browser.text.include? post_name
      end
      @browser.link(:text => post_name).when_present.click
    if (type == "question")
      @browser.wait_until { answer_level1.present? || depth0_q.present? }
      assert answer_level1.present?
      assert root_post_title.text.include? post_name
    end
    if (type == "discussion")
      @browser.wait_until { depth0_d.present? }
      assert conv_content.present?
      assert root_post_title.text.include? post_name
    end
    if (type == "blog")
      @browser.wait_until { conv_content.present? }
      assert root_post_title.text.include? post_name
    end
  
  else
    @browser.wait_until { first_conv_link.present? }
    sleep(2)
    first_conv_link.when_present.click
    @browser.execute_script("window.scrollBy(0,-2000)")
    if (type == "question")
      @browser.wait_until { root_post.present? }
      #assert root_post.present?
    end
    if (type == "discussion")
      @browser.wait_until { root_post.present? }
      #assert root_post.present?
    end
    if (type == "blog")
      @browser.wait_until { root_post_blog.present? }
      #assert root_post_blog.present?
    end
      if (type == "review")
        @browser.wait_until { root_post.present? }
      end
    end

  end

  def like_root_post
    # hide the left social share tool panel since it will overlap Like like
    @browser.execute_script('$("#share-box").css("display", "none")')
    @browser.wait_until { !conv_social_share_box.present? }
    conv_root_post_like_link.when_present.click unless conv_root_post_like_link.when_present.class_name.include?("action-done")
    @browser.wait_until { conv_root_post_like_link.class_name.include?("action-done") }
  end

  def unlike_root_post
    # hide the left social share tool panel since it will overlap Like like
    @browser.execute_script('$("#share-box").css("display", "none")')
    @browser.wait_until { !conv_social_share_box.present? }
    conv_root_post_like_link.when_present.click if conv_root_post_like_link.when_present.class_name.include?("action-done")
    @browser.wait_until { !conv_root_post_like_link.class_name.include?("action-done") }
  end 

  def follow_root_post
    conv_root_post_follow_link.click unless conv_root_post_follow_link.when_present.class_name.include?("action-done")
    @browser.wait_until { conv_root_post_follow_link.class_name.include?("action-done") } #Followed
  end
  
  def unfollow_root_post
    conv_root_post_follow_link.click if conv_root_post_follow_link.when_present.class_name.include?("action-done")
    @browser.wait_until { !conv_root_post_follow_link.class_name.include?("action-done") } #Unfollowed
  end 

  # def flag_root_post
  #   # scroll to top so as to avoid the controls are overlapped by navigation bar
  #   @browser.execute_script("window.scrollBy(0,-1000)")
    
  #   dropdown_arrow.when_present.click
  #   conv_root_post_dropdown_flag.when_present.click
  #   @browser.wait_until { conv_flag_confirm_dlg.present? }
  #   conv_flag_confirm_dlg_submit_btn.when_present.click
  #   @browser.wait_until { conv_flagged_root_post.present? }
  # end

  def create_new_conv_and_reply_for_specific_topic(reply_text:, conv_title:, conv_desc:, conv_type: :question, topic_title: 'A Watir Topic', **)
    @topiclist_page = Pages::Community::TopicList.new(@config)
    @topicdetail_page = @topiclist_page.go_to_topic(topic_title)
    @topicdetail_page.create_conversation(type: conv_type,
                                          title: conv_title,
                                          details: [{type: :text, content: conv_desc}])
    accept_policy_warning
    reply_box.when_present.focus
    @browser.wait_until { reply_submit.present? }
    reply_box.when_present.set reply_text
    reply_submit.when_present.click
    @browser.wait_until { conv_reply.present?}

    @browser.url
  end

  def create_new_conv_for_specific_topic(conv_title:, conv_desc:, conv_type: :question, topic_title: 'A Watir Topic For Notification', topic_link: nil, **)
    @topiclist_page = Pages::Community::TopicList.new(@config)

    if !topic_link.nil?
      @topicdetail_page = @topiclist_page.go_to_topic_by_url(topic_link)
    else
      @topicdetail_page = @topiclist_page.go_to_topic(topic_title)
    end

    @topicdetail_page.create_conversation(type: conv_type,
                                          title: conv_title,
                                          details: [{type: :text, content: conv_desc}])
    accept_policy_warning
    @browser.wait_until { reply_box.present? }

    @browser.url
  end

  def create_new_reply_for_specific_conv_url(conv_url:, reply_text:, **)
    user_check_post_by_url(conv_url)
    @browser.wait_until { reply_box.present? }

    reply_box.when_present.focus
    @browser.wait_until { reply_submit.present? }
    reply_box.when_present.set reply_text
    reply_submit.when_present.click
    @browser.wait_until { conv_reply.present?}
  end

  def create_new_child_reply_for_specific_conv_and_parent_reply(conv_url:, parent_reply_text:, reply_text:, **)
    user_check_post_by_url(conv_url)
    @browser.wait_until { reply_box.present? }

    post = get_post(1, parent_reply_text)
    @browser.wait_until { post.span(:css => ".post-actions-line .replies").present? }
    post.span(:css => ".post-actions-line .replies").when_present.click
    @browser.wait_until { post.textarea(:class => "ember-view ember-text-area form-control").present? }
    post.textarea(:class => "ember-view ember-text-area form-control").when_present.focus
    @browser.wait_until { post.div(:class => "group text-right").button(:value => /Submit/).present? }
    post.textarea(:class => "ember-view ember-text-area form-control").when_present.set reply_text
    post.div(:class => "group text-right").button(:value => /Submit/).when_present.click
    @browser.wait_until { depth2_reply.present?}
    depth2_reply.text.include?(reply_text)
  end

  def create_new_child_reply_for_specific_conv_and_specific_reply(conv_url:, parent_reply_text:, reply_text:, level:, **)
    user_check_post_by_url(conv_url)
    @browser.wait_until { reply_box.present? }

    post = get_post(level, parent_reply_text)
    @browser.wait_until { post.span(:css => ".post-actions-line .replies").present? }
    post.span(:css => ".post-actions-line .replies").when_present.click
    @browser.wait_until { post.textarea(:class => "ember-view ember-text-area form-control").present? }
    post.textarea(:class => "ember-view ember-text-area form-control").when_present.focus
    @browser.wait_until { post.div(:class => "group text-right").button(:value => /Submit/).present? }
    post.textarea(:class => "ember-view ember-text-area form-control").when_present.set reply_text
    post.div(:class => "group text-right").button(:value => /Submit/).when_present.click
    @browser.wait_until { depth2_reply.present?}
    depth2_reply.text.include?(reply_text)
  end

  def like_conversation
    @browser.execute_script("window.scrollTo(0,document.documentElement.scrollTop)")
    like_post(:level => 0)
  end

  def like_reply(post_name:)
    like_post(:level => 1, :post_name => post_name)
  end

  def like_post(level:, post_name: nil)
    post = get_post(level, post_name)
    @browser.wait_until { post.span(:css => ".post-actions-line .like-hollow").present? }
    post.span(:css => ".post-actions-line .like-hollow").when_present.click unless post.span(:css => ".post-actions-line .like-hollow").class_name.include?('action-done')
    @browser.wait_until { post.span(:css => ".post-actions-line .like-hollow").class_name.include?('action-done')}
  end

  def unlike_conversation
    @browser.execute_script("window.scrollTo(0,document.documentElement.scrollTop)")
    unlike_post(:level => 0)
  end

  def unlike_reply(post_name:)
    unlike_post(:level => 1, :post_name => post_name)
  end

  def unlike_post(level:, post_name: nil)
    post = get_post(level, post_name)
    @browser.wait_until { post.span(:css => ".post-actions-line .like-hollow").present? }
    post.span(:css => ".post-actions-line .like-hollow").when_present.click if post.span(:css => ".post-actions-line .like-hollow").class_name.include?('action-done')
    @browser.wait_until { !post.span(:css => ".post-actions-line .like-hollow").class_name.include?('action-done')}
  end

  def flag_root_post(reason: nil)
    @browser.execute_script("window.scrollTo(0,document.documentElement.scrollTop)")
    flag_post(:reason => reason, :level => 0)
  end

  def flag_reply(reason: nil, post_name: nil)
    flag_post(:reason => reason, :level => 1, :post_name => post_name)
  end

  def flag_post(reason:, level:, post_name: nil)
    post = get_post(level, post_name)
    post.span(:class => "dropdown-toggle").when_present.click
    @browser.wait_until { dropdown_menu.present? }
    post.link(:text => /Flag as inappropriate/).when_present.click

    @browser.wait_until { flag_confirm_modal.present? }
    flag_reason_input.set reason unless reason.nil?
    flag_confirm_modal_submit.click

    @browser.wait_until { !flag_confirm_modal_submit.present? }
    @browser.wait_until { !flag_confirm_modal.present? } 
    @browser.wait_until { post.attribute_value("class").include?("tempRemoved") || post.attribute_value("class").include?("flagged") }
    assert post.attribute_value("class").include?("tempRemoved") || post.attribute_value("class").include?("flagged")
  end

  def permanently_remove_flagged_root_post
    @browser.execute_script("window.scrollTo(0,document.documentElement.scrollTop)")
    permanently_remove_flagged_post(level: 0)
  end

  def permanently_remove_flagged_reply(post_name: nil)
    permanently_remove_flagged_post(level: 1, post_name: post_name)
  end

  def permanently_remove_flagged_post(level:, post_name: nil)
    post = get_post(level, post_name)
    assert post.attribute_value("class").include?("tempRemoved")
    post.span(:class => "dropdown-toggle").when_present.click
    @browser.wait_until { dropdown_menu.present? }
    @browser.wait_until { !post.link(:text => /Flag as inappropriate/).present? }
    @browser.wait_until { post.link(:text => /Permanently Remove/).present? }
    post.link(:text => /Permanently Remove/).when_present.click

    @browser.wait_until { permanently_remove_confirm_modal.present? }
    permanently_remove_confirm_btn.click

    @browser.wait_until { !permanently_remove_confirm_btn.present? }
    @browser.wait_until { !permanently_remove_confirm_modal.present? }
  end

  def reinstate_flagged_root_post
    @browser.execute_script("window.scrollTo(0,document.documentElement.scrollTop)")
    reinstate_flagged_post(level: 0)
  end

  def reinstate_flagged_reply(post_name: nil)
    reinstate_flagged_post(level: 1, post_name: post_name)
  end

  def reinstate_flagged_post(level:, post_name: nil)
    post = get_post(level, post_name)
    assert post.attribute_value("class").include? "tempRemoved"
    post.span(:class => "dropdown-toggle").when_present.click
    @browser.wait_until { dropdown_menu.present? }
    @browser.wait_until { !post.link(:text => /Flag as inappropriate/).present? }
    @browser.wait_until { post.link(:text => /Reinstate this content/).present? }
    post.link(:text => /Reinstate this content/).click

    # dropdown menu donnot have the following options any more:
    # Flag as inappropriate/Reinstate this content/Permanently Remove
    post.span(:class => "dropdown-toggle").when_present.click
    @browser.wait_until { dropdown_menu.present? }
    @browser.wait_until { !post.link(:text => /Flag as inappropriate/).present? }
    @browser.wait_until { !post.link(:text => /Permanently Remove/).present? }
    @browser.wait_until { !post.link(:text => /Reinstate this content/).present? }
  end

  def feature_root_post
    @browser.execute_script("window.scrollTo(0,document.documentElement.scrollTop)")
    feature_post(0)
  end

  def feature_comment(post_name=nil)
    feature_post(1,post_name)
  end

  def feature_reply(post_name=nil)
    feature_post(1,post_name)
  end

  def unfeature_root_post
    @browser.execute_script("window.scrollTo(0,document.documentElement.scrollTop)")
    unfeature_post(0)
  end

  def unfeature_comment(post_name=nil)
    unfeature_post(1,post_name)
  end

  def unfeature_reply(post_name=nil)
    unfeature_post(1,post_name)
  end

  def feature_post(level,post_name=nil)  
    post = get_post(level,post_name)

    # Approve the pending approval posts
    if level == 0
      if @browser.div(:css => ".gadget-conversation-content #moderation-message .moderation-actions").present?
        @browser.button(:css => ".gadget-conversation-content .moderation-actions button.approve").when_present.click
      end  
    else
      if post.div(:css => "#moderation-message .moderation-actions").present?
        post.button(:css => "#moderation-message .moderation-actions button.approve").when_present.click 
      end  
    end  

    post.span(:class => "dropdown-toggle").when_present.click
    @browser.wait_until { dropdown_menu.present? }
    if post.link(:text => /Mark as best answer/).present?
     @browser.wait_until { post.link(:text => /Mark as best answer/).present? }
     post.link(:text => /Mark as best answer/).when_present.click
     
     @browser.wait_until { featured_answer.present? }
    else
     @browser.wait_until { post.link(:text => /Feature/).present? }
     post.link(:text => /Feature/).when_present.click
     if level == 0
      @browser.wait_until { featured_root.present? }
     else
      @browser.wait_until {featured_comment.present?  }
     end 
    end 
  end

  def unfeature_post(level,post_name=nil)
    post = get_post(level,post_name)
    post.span(:class => "dropdown-toggle").when_present.click
    if post.link(:text => "Unmark as best answer").present? 
     post.link(:text => "Unmark as best answer").when_present.click
     @browser.wait_until { !featured_answer.present? }
    else
     post.link(:text => "Stop Featuring").when_present.click
     if level == 0
      @browser.wait_until { !featured_root.present? }
     else
      @browser.wait_until { !featured_comment.present?  }
     end 
    end
  end

  def get_post(level,post_name=nil,count=0)
    if post_name
      element = @browser.div(:class => /depth-#{level}/,:text => /#{post_name}/)
    else
      element = @browser.div(:class => /depth-#{level}/) #,:index => count)
    end

    @browser.wait_until{ element.present? }
    return element
  end

  def post_comment(posttype)
    if posttype == "discussion"
     comment_text = "Comment posted by Watir - #{get_timestamp}"
    end
    if posttype == "question"
     answer_text = "Answer posted by Watir - #{get_timestamp}"
    end
    if posttype == "blog"
     blog_comment_text = "Blog comment posted by Watir - #{get_timestamp}"
    end
    if posttype == "review"
     review_comment_text = "Review comment posted by Watir - #{get_timestamp}"
    end
    @browser.execute_script("window.scrollBy(0,500)")
    @topicdetail_page = Pages::Community::TopicDetail.new(@config)
    @browser.wait_until { conv_reply_input.present? || reply_box.present? }
    if @topicdetail_page.topic_sort_post_by_oldest.present? || @topicdetail_page.topic_sort_post_by_oldest_new.present?
      @topicdetail_page.sort_post_by_newest
      @browser.wait_until { conv_reply_input.present? }
    end
    reply_box.when_present.focus
    @browser.wait_until { reply_submit.present? }
    assert reply_submit.present?

    if posttype == "discussion"
     reply_box.when_present.set comment_text
    end
    if posttype == "question"
     reply_box.when_present.set answer_text
    end
    if posttype == "blog"
     reply_box.when_present.set blog_comment_text
    end
    if posttype == "review"
     reply_box.when_present.set review_comment_text
    end
    reply_submit_button.when_present.click
    @browser.wait_until { !reply_submit_button.present? }
    @browser.wait_until { conv_reply.present? }
    @browser.wait_until { post_body.present? }
   
    if posttype == "discussion"
     @browser.wait_until { conv_reply.present? }
     @browser.wait_until { conv_reply.text =~  /#{comment_text}/ }
     assert conv_reply.text =~  /#{comment_text}/
    end 
    if posttype == "question"
     @browser.wait_until { conv_reply.present? }
     @browser.wait_until { conv_reply_ans.text =~  /#{answer_text}/ }
     assert conv_reply_ans.text =~  /#{answer_text}/
     return answer_text
    end 
    if posttype == "blog"
     @browser.wait_until { conv_reply.present? }
     @browser.wait_until { conv_reply.p.text =~  /#{blog_comment_text}/ }
     assert conv_reply.p.text =~  /#{blog_comment_text}/
    end 
    if posttype == "review"
     @browser.wait_until { conv_reply.present? }
     @browser.wait_until { conv_reply.p.text =~  /#{review_comment_text}/ }
     assert conv_reply.p.text =~  /#{review_comment_text}/
    end  
    
  end

  def feature_a_conv
    if conv_feature.present?
      unfeature_root_post
    end
    feature_root_post
    @browser.wait_until { conv_feature.present? }
  end

  def unfeature_a_conv
    if !conv_feature.present?
      feature_root_post
    end
    unfeature_root_post
    @browser.wait_until { !conv_feature.present? }
  end

  def sort_comments(by: :newest)
    @browser.wait_until { conv_detail_sort.present? }
    @browser.wait_until { !conv_detail_loading_block.present? }
    conv_detail_sort.when_present.click
    @browser.wait_until { conv_detail_sort_dropdown_open.present? }

    sort_by_text = "Sorted by: Newest"
    case by
    when :oldest
      conv_detail_oldest_link.when_present.click
    when :newest
      conv_detail_newest_link.when_present.click    
    end

    @browser.wait_until { conv_detail_sort_text.text.include? sort_by_text}
    @browser.wait_until { !conv_detail_loading_block.present? }
    @browser.wait_until { conv_reply.present? }
    assert conv_detail_sort_text.text.include? sort_by_text 
  end

  def get_review_id
    @browser.wait_until { conv_title.present? }
    @browser.url.match(/\/review\/(\w+)\//)[1]
  end

  def goto_edit_page
    @browser.wait_until {conv_content.present?}
    # scroll to top so as to avoid the controls are overlapped by navigation bar
    @browser.execute_script("window.scrollBy(0,-1000)")
    
    dropdown_arrow.when_present.click
    dropdown_edit.when_present.click

    convedit_page = Pages::Community::ConversationEdit.new(@config)
    @browser.wait_until { convedit_page.title_field.present? }
    accept_policy_warning

    convedit_page
  end

  def edit_conversation(type: :question, title: nil, details: nil, attachments: nil)
    convedit_page = goto_edit_page

    convedit_page.edit_fields_then_submit_conversation(type: type, title: title, details: details, attachments: attachments)
    @browser.wait_until { conv_content.present? }
  end
  
  def edit_review(title: nil, details: nil, attachments: nil, star: 5, recommended: true)
    convedit_page = goto_edit_page

    convedit_page.fill_in_fields_then_submit_review(title: title, details: details, attachments: attachments, star: star, recommended: recommended)
    @browser.wait_until { conv_content.present? }
  end  

  def delete_conversation
    # scroll to top so as to avoid the controls are overlapped by navigation bar
    @browser.execute_script("window.scrollBy(0,-1000)")

    dropdown_arrow.when_present.click
    dropdown_delete.when_present.click

    post_delete_confirm_dlg_delete_btn.when_present.click

    topicdetail_page = Pages::Community::TopicDetail.new(@config)
    @browser.wait_until { topicdetail_page.topic_filter.present? }
  end  

  def create_reply des:"description", mention_type:nil, hint:"d", mention_way: "key"
    @browser.wait_until {conv_content.present?}
    scroll_to_element reply_text_field
    if mention_type != nil
      if mention_type == "at"
        if mention_way == "key"
          reply_text_field.when_present.set des + "@" + hint
        elsif mention_way == "icon"
          reply_text_field.when_present.set des
          tooltip_mention_btn.when_present.click
          reply_text_field.when_present.focus
          @browser.send_keys hint
        end
        @browser.wait_until {mentioned_list.present?}
        mentioned_list.lis[0].when_present.click
        @browser.wait_until {conversation_product.present?}
        scroll_to_element submit_btn
        @browser.execute_script("window.scrollBy(0,-400)")
      elsif mention_type == "tag"
        if mention_way == "key"
          reply_text_field.when_present.set "#tag#{Time.now.utc.to_i}"
        elsif mention_way == "icon"
          scroll_to_element tooltip_tag_btn
          reply_text_field.when_present.click
          tooltip_tag_btn.when_present.click
          reply_text_field.when_present.focus
          @browser.send_keys hint
          @browser.wait_until($t) {mentioned_list.present?}
          mentioned_list.lis[0].when_present.click
          @browser.wait_until($t) {!mentioned_list.present?}
        end
      end
      submit_btn.when_present.click
      @browser.wait_until {reply_conversation_modal.present?}
      if mention_type == "at"
        return reply_conversation_modal.p(:class => "variant-product-title").when_present.text
      end
    else
      reply_text_field.when_present.set des
      submit_btn.when_present.click
    end
  end 

  def edit_reply des:"description", mention_type:nil, hint:"d", mention_way: "key"
    @browser.wait_until {conv_content.present?}
    # @browser.execute_script("window.scrollBy(0,200)")
    reply_dropdown_arrow.when_present.click
    reply_dropdown_edit.when_present.click
    edit_reply_text_field.when_present.click
    if mention_type != nil
      if mention_type == "at"
        if mention_way == "key"
          edit_reply_text_field.when_present.set des + "@" + hint
        elsif mention_way == "icon"
          edit_reply_text_field.when_present.set des
          tooltip_mention_btns[2].when_present.click
          edit_reply_text_field.when_present.focus
          @browser.send_keys hint
        end
        @browser.wait_until {edit_reply_mentioned_list.present?}
        new_prodcard_name = edit_reply_mentioned_list.lis[0].when_present.p(:css => ".at-list-title").text
        edit_reply_mentioned_list.lis[0].when_present.click
        @browser.wait_until {conversation_product.present?}
      elsif mention_type == "tag"
        edit_reply_text_field.when_present.focus
        if mention_way == "key"
          @browser.send_keys "#tag#{Time.now.utc.to_i}"
        elsif mention_way == "icon"
          edit_reply_text_field.when_present.click
          tooltip_tag_btns[1].when_present.click
          edit_reply_text_field.when_present.focus
          @browser.execute_script("window.scrollBy(0,200)")
          @browser.send_keys hint
          @browser.wait_until($t) {mention_tag_list.present?}
          mention_tag_list.lis[0].when_present.click
          @browser.wait_until($t) {!mention_tag_list.present?}
        end
      end
      # scroll_to_element submit_btn
      # @browser.execute_script("window.scrollBy(0,-400)")
      submit_btn.when_present.click
      if mention_type == "at"
        @browser.wait_until {reply_conversation_modal.present?}
        @browser.wait_until { product_names_in_comments[0].when_present.text == new_prodcard_name }
        return product_names_in_comments[0].when_present.text
      end
    else
      edit_reply_text_field.when_present.set des
      submit_btn.when_present.click
    end
  end

  def add_to_cart index=0
    accept_policy_warning
    # card = @browser.div(:class => /conversation-product/)
    @browser.wait_until(60) { conversation_product.present? }
    # scroll_to_element card
    # card.when_present.click   #sometimes the shopping card drop-down layout cover the add to cart button,need hide it
    product_name = conversation_product.p(:class => /product-title/).text
    cart_number = shopping_cart_icon.text.to_i
    @browser.wait_until{ conv_prodcard_toggle.present? }
    scroll_to_element(conversation_product)
    @browser.execute_script("window.scrollBy(0,-200)")
    conv_prodcard_toggle.when_present.click
    conv_prodcard_addtocard_link.when_present.click
    scroll_to_element shopping_cart_icon

    top_hybris_nav = Gadgets::Community::TopHybrisNavigator.new(@config)
    if top_hybris_nav.present?
      @browser.wait_until { !shopping_cart_icon.text.match(/\((\d) ITEM/).nil? \
        && shopping_cart_icon.text.match(/\((\d) ITEM/)[1].to_i == cart_number + 1 }
    else  
      @browser.wait_until { shopping_cart_icon.text.to_i == cart_number + 1 }
    end  
    @browser.wait_until { !cart_item_ghost.present? }
    @browser.wait_until { !shopping_cart_popup.present? }
    shopping_cart_icon.when_present.click
    @browser.wait_until { shopping_cart_popup.present? }
    @browser.wait_until { @browser.li(:class => "cart-popup-item", :text => /#{product_name}/).present? }
    @browser.li(:class => "cart-popup-item", :text => /#{product_name}/)
  end

  def change_product_number_in_cart cart_item, number
    open_shopping_cart_popup
    item_number = get_cart_item_number cart_item
    total_number = get_cart_total_number
    # work round for alert bug, instead cart_item.text_field.set number
    cart_item.text_field.when_present.double_click
    @browser.send_keys :backspace
    @browser.send_keys number

    total_change_number = get_cart_total_number
    @browser.wait_until{ item_number-number == total_number-total_change_number }
  end

  def remove_product_from_cart cart_item
    open_shopping_cart_popup
    item_number = get_cart_item_number cart_item
    total_number = get_cart_total_number
    cart_item.link(:class => "cart-del").when_present.click
    @browser.wait_until{ !cart_item.present? }
    total_change_number = get_cart_total_number
    @browser.wait_until{ 
      open_shopping_cart_popup # workaround for bug EN-2471
      item_number == total_number-get_cart_total_number }
  end

  def clean_shopping_cart
    toggle_on_shopping_cart

    until shopping_cart_items.size == 0
      item_count_pre = shopping_cart_items.size

      @browser.link(:css => delete_link_css_for_shopping_cart_item_at_index(0)).when_present.click

      @browser.wait_until { item_count_pre - shopping_cart_items.size == 1 }
    end

    toggle_off_shopping_cart   
  end

  def delete_link_css_for_shopping_cart_item_at_index(index)
    ".cart-popup-menu > .cart-popup-item:nth-child(#{index+1}) .cart-del"
  end 

  def toggle_on_shopping_cart
    shopping_cart_icon.when_present.click unless shopping_cart_popup.present?
    @browser.wait_until { shopping_cart_popup.present? }
  end

  def toggle_off_shopping_cart
    shopping_cart_icon.when_present.click if shopping_cart_popup.present?
    @browser.wait_until { !shopping_cart_popup.present? }
  end  

  def get_cart_products
    cart_items = @browser.lis(:class => "cart-popup-item")
    total_number,total_price = 0,0
    products = Hash.new
    cart_items.each do |cart_item|
      title = get_cart_item_title cart_item
      item_number = get_cart_item_number cart_item
      item_price = get_cart_item_price cart_item
      products[title] = [item_number,item_price]
    end
    products
  end

  def get_cart_total_number
    total_number = @browser.div(:class => "drop-menu-header").link.inner_html
    total_number[/\d+/].to_i
  end

  def get_cart_total_price
    total_price = @browser.div(:class => "drop-menu-footer").h5.inner_html
    total_price.delete(',')[/\d(\d+|\.)+/].to_f
  end

    def get_cart_item_title cart_item
    cart_item.div(:class => "cart-item-title").text
  end

  def get_cart_item_number cart_item
    cart_item.input.value.to_i
  end

  def get_cart_item_price cart_item
    price = cart_item.div(:class => "cart-item-price").inner_html
    price.delete(',')[/\d(\d+|\.)+/].to_f
  end

  def user_check_post_by_url(conv_url)
    @browser.goto conv_url
    @browser.wait_until { root_post_title.present? || conv_moderation_alert.present? }
  end

  def open_shopping_cart_popup
    shopping_cart_icon.when_present.click unless shopping_cart_popup.present?
    shopping_cart_icon.when_present.click unless checkout_button.present?
  end

  def create_new_reply_for_specific_topic_and_conv_type(comment_text:, topic_title: "A Watir Topic", conv_type: :question, **)
    @topiclist_page = Pages::Community::TopicList.new(@config)
    @topicdetail_page = @topiclist_page.go_to_topic(topic_title)
    @topicdetail_page.goto_conversation(type: conv_type)
    @browser.wait_until { comment_level1.present? || depth0_q.present? }
    if comment_level1.present?
     @browser.wait_until { comment_level1.present? }
     sort_comments
    else
     @browser.wait_until { convdetail.present? }
    end

    reply_box.when_present.focus
    @browser.wait_until { reply_submit.present? }
    reply_box.set comment_text
    reply_box.focus
    assert reply_submit.present?
    reply_submit.click
    @browser.wait_until { !reply_submit.present? }
    @browser.wait_until { !spinner.present? }
    @browser.url
  end

  def close_conversation
    @browser.wait_until {conv_content.present?}
    # scroll to top so as to avoid the controls are overlapped by navigation bar
    @browser.execute_script("window.scrollBy(0,-1000)")
    
    dropdown_arrow.when_present.click
    dropdown_close.when_present.click
    conv_close_confirm_modal_primary_btn.when_present.click

    @browser.wait_until { replies_panel.closed_label.present? }
  end
  
  def reopen_conversation
    @browser.wait_until {conv_content.present?}
    # scroll to top so as to avoid the controls are overlapped by navigation bar
    @browser.execute_script("window.scrollBy(0,-1000)")
    
    dropdown_arrow.when_present.click
    dropdown_reopen.when_present.click

    @browser.wait_until { !replies_panel.closed_label.present? }
  end  

  def change_blog_schedule(publish_schedule)
    conv_blog_schedule_change_link.when_present.click
    Pages::Community::PublishSetting.new(@config).set(publish_schedule)
  end  

  def root_post_actions_panel
    ConversationActionsPanel.new(@browser)
  end  

  def replies_panel
    RepliesPanel.new(@browser)
  end

  def attachments_panel
    AttachmentsPanel.new(@browser)
  end  

  class ConversationActionsPanel
    def initialize(browser)
      @browser = browser
      @parent_css = ".root-post .conversation-post-actions"
    end 

    def present?
      @browser.div(:css => @parent_css).present?
    end  

    def likes_count
      @browser.span(:css => @parent_css + " .post-meta-line .likes").when_present.text.match(/(\d+)/)[0]
    end
    
    def replies_count
      @browser.span(:css => @parent_css + " .post-meta-line .replies").when_present.text.match(/(\d+)/)[0]
    end

    def follows_count
      @browser.span(:css => @parent_css + " .post-meta-line .follows").when_present.text.match(/(\d+)/)[0]
    end 

    def like_clicker
      @browser.span(:css => @parent_css + " .post-actions-line [class*=like]")
    end
    
    def reply_clicker
      @browser.span(:css => @parent_css + " .post-actions-line .replies")
    end

    def follow_clicker
      @browser.span(:css => @parent_css + " .post-actions-line .follows")
    end

    def liked?
      like_clicker.when_present.class_name.include?("action-done")
    end 

    def followed?
      follow_clicker.when_present.class_name.include?("action-done")
    end 

    def reply_enabled?
      !reply_clicker.class_name.include?("dead-link")
    end 

    def click_like_clicker
      @browser.execute_script('arguments[0].scrollIntoView();', like_clicker)
      @browser.execute_script("window.scrollBy(0,-200)")
      like_clicker.click
    end

    def like
      click_like_clicker unless liked?
      @browser.wait_until { liked? }
    end 

    def unlike
      click_like_clicker if liked?
      @browser.wait_until { !liked? }
    end  

    def follow
      follow_clicker.click unless followed?
      @browser.wait_until { followed? }
    end

    def unfollow 
      follow_clicker.click if followed?
      @browser.wait_until { !followed? }
    end  
  end  

  class RepliesPanel
    attr_reader :browser

    def initialize(browser)
      @browser = browser
    end

    def reply_collection_css
      ".comments"
    end

    def replies_count
      @browser.h5(:css => reply_collection_css + " .response + div h5").when_present.text.match(/(\d+)/)[0]
    end 

    def closed_label
      @browser.element(:css => reply_collection_css + " .closed-response")
    end 

    def featured_reply
      Reply.new(reply_collection_css + " .featured-post-collection .post", @browser)
    end  

    def show_more_btn
      @browser.link(:css => reply_collection_css + " .show-more-answers a")
    end  

    def replies_at_depth(depth)
      if depth == 1
        replie_eles = @browser.divs(:css => reply_collection_css + " > div:not([class=featured-post-collection]) .depth-#{depth}.post")
      else
        replie_eles = @browser.divs(:css => reply_collection_css + " > .depth-#{depth}.post")
      end

      replies = []
      replie_eles.each { |i| replies.push(Reply.new("##{i.id}.depth-#{depth}.post", @browser)) }

      replies
    end

    def reply_with_content(depth, content)
      if content.nil?
        replies_at_depth(depth)[0] if replies_at_depth(depth).size > 0 # return 1st reply if content is nil
      else
        replies_at_depth(depth).find { |r| r.content == content }
      end  
    end

    def feature_reply(depth, content, type=:answer)
      @browser.wait_until { !reply_with_content(depth, content).nil? }
      reply_with_content(depth, content).actions_arrow.when_present.click
      case type
      when :answer  
        reply_with_content(depth, content).action_menu_item_mark_best.when_present.click
      when :comment
        reply_with_content(depth, content).action_menu_item_feature.when_present.click
      end 
      @browser.wait_until { reply_with_content(depth, content).featured? }
      sleep 1 # page will be scrolled for a while after feature/unfeature which will cause the following click not working
    end

    def unfeature_reply(depth, content, type=:answer)
      @browser.wait_until { !reply_with_content(depth, content).nil? }
      reply_with_content(depth, content).actions_arrow.when_present.click
      case type
      when :answer  
        reply_with_content(depth, content).action_menu_item_unmark_best.when_present.click
      when :comment
        reply_with_content(depth, content).action_menu_item_unfeature.when_present.click
      end 
      @browser.wait_until { reply_with_content(depth, content).featured? }
      sleep 1
    end

    def feature_reply_at_index(depth, index, type=:answer)
      @browser.wait_until { !replies_at_depth(depth)[index].nil? }

      # no idea why click doesn't work sometimes
      start_time = Time.now
      loop do
        replies_at_depth(depth)[index].actions_arrow.when_present.click
        begin
          @browser.wait_until(1) { replies_at_depth(depth)[index].action_menu_item_mark_best.present? }
          break
        rescue 
          puts "Click on actions arrow doesn't work. Wait adn then try again"  
        end
        break if Time.now - start_time > 30
        sleep 1
      end  
      
      case type
      when :answer  
        replies_at_depth(depth)[index].action_menu_item_mark_best.when_present.click
      when :comment
        replies_at_depth(depth)[index].action_menu_item_feature.when_present.click
      end 
      @browser.wait_until { replies_at_depth(depth)[index].featured? }
      sleep 1
    end 

    def unfeature_reply_at_index(depth, index, type=:answer)
      @browser.wait_until { !replies_at_depth(depth)[index].nil? }
      replies_at_depth(depth)[index].actions_arrow.when_present.click
      case type
      when :answer  
        replies_at_depth(depth)[index].action_menu_item_unmark_best.when_present.click
      when :comment
        replies_at_depth(depth)[index].action_menu_item_unfeature.when_present.click
      end 
      @browser.wait_until { !replies_at_depth(depth)[index].featured? }
      sleep 1
    end 

    def like_reply(depth, content)
      @browser.wait_until { !reply_with_content(depth, content).nil? }
      reply_with_content(depth, content).like
      @browser.wait_until { reply_with_content(depth, content).liked? }
    end

    def delete_reply(depth, content)
      @browser.wait_until { !reply_with_content(depth, content).nil? }
      reply_with_content(depth, content).delete
      @browser.wait_until { reply_with_content(depth, content).nil? }
    end  

    class Reply
      attr_reader :reply_css, :browser
      def initialize(reply_css, browser)
        @reply_css = reply_css
        @browser = browser
      end

      def present?
        @browser.div(:css => @reply_css).present?
      end  
      
      def content
        begin
          @browser.div(:css => @reply_css + " .post-content").when_present.text
        rescue Selenium::WebDriver::Error::InvalidSelectorError => e
          puts 'Selector: ["' + @reply_css + ' .post-content"] is invalid'
          raise e
        end  
      end 

      def actions_arrow
        @browser.span(:css => @reply_css + " .dropdown .icon-navigation-down-arrow")
      end

      def actions_dropdown_menu
        @browser.ul(:css => @reply_css + " .dropdown-menu")
      end

      def action_menu_item_feature
        actions_dropdown_menu.link(:text => /Feature/)
      end

      def action_menu_item_unfeature
        actions_dropdown_menu.link(:text => /Stop Featuring/)
      end  

      def action_menu_item_flag
        actions_dropdown_menu.link(:text => /Flag/)
      end

      def action_menu_item_edit
        actions_dropdown_menu.link(:text => /Edit/)
      end 

      def action_menu_item_delete
        actions_dropdown_menu.link(:text => /Delete/)
      end

      def action_menu_item_mark_best
        actions_dropdown_menu.link(:text => /Mark as best/)
      end

      def action_menu_item_unmark_best
        actions_dropdown_menu.link(:text => /Unmark as best answer/)
      end  

      def action_menu_item_reinstate
        actions_dropdown_menu.link(:text => /Reinstate/)
      end

      def action_menu_item_permanently_remove
        actions_dropdown_menu.link(:text => /Permanently Remove/)
      end

      def like_action_link
        @browser.link(:css => @reply_css + " .post-actions-line a.like")
      end

      def show_older_responses_link
        @browser.link(:css => @reply_css + " #show-more-before-post-link")
      end   

      def featured?
        @browser.element(:css => @reply_css).class_name.include?("feature")
      end

      def liked?
        like_clicker.when_present.class_name.include?("action-done")
      end

      def like_clicker
        @browser.element(:css => @reply_css + " .post-actions-line [class*=like]")
      end

      def reply_clicker
        @browser.element(:css => @reply_css + " .post-actions-line .replies")
      end 

      def like_count_label
        @browser.element(:css => @reply_css + " .post-actions-line .unclick")
      end  

      def like_count
        like_count_label.when_present.text.match(/(\d+)/)[0]
      end  

      def reply_enabled?
        !reply_clicker.class_name.include?("dead-link")
      end  

      def like
        like_clicker.click unless liked?
        @browser.wait_until { liked? }
      end 

      def unlike
        like_clicker.click if liked?
        @browser.wait_until { !liked? }
      end 

      def reply_editor
        ReplyEditor.new(@browser, @reply_css + " .response")
      end 

      def edit(contents)
        actions_arrow.when_present.click
        action_menu_item_edit.when_present.click
        @browser.wait_until { reply_editor.active? }

        reply_editor.submit(contents)
      end

      def reply(contents)
        reply_clicker.when_present.click
        @browser.wait_until { reply_editor.active? }

        reply_editor.submit(contents)
      end 

      def delete_confirm_modal_delete_button
        @browser.button(:css => @reply_css + " .post-delete-confirm .modal-footer .btn-primary")
      end  

      def delete
        actions_arrow.when_present.click
        action_menu_item_delete.when_present.click

        delete_confirm_modal_delete_button.when_present.click
      end  
    end 

    class ReplyEditor
      def initialize(browser, parent_css)
        @browser = browser
        @parent_css = parent_css
      end

      def active?
        reply_box.present? && mention_prod_icon.present?
      end  

      def reply_box
        @browser.textarea(:css => @parent_css + " .reply-box")
      end  

      def mention_prod_icon
        @browser.span(:css => @parent_css + " .at-mention-tags-icons [data-type=product]")
      end
      
      def mention_tag_icon
        @browser.span(:css => @parent_css + " .at-mention-tags-icons [data-type=tag]")
      end

      def mention_onboard_tooltip
        @browser.span(:css => @parent_css + " .at-mention-tags-icons [data-type=product] .onboard")
      end

      def mention_suggest_list
        @browser.ul(:css => @parent_css + " .at-list")
      end 

      def mention_tags
        @browser.spans(:css => @parent_css + " .at-mention-echo .at-mention[data-type=tag]")
      end 

      def mention_products
        @browser.spans(:css => @parent_css + " .at-mention-echo .at-mention[data-type=product]")
      end

      def submit_btn
        @browser.button(:css => @parent_css + " .btn-primary")
      end

      def submit_spinner
        @browser.element(:css => @parent_css + " .btn-primary .fa-spinner")
      end  
      
      def cancel_btn
        @browser.button(:css => @parent_css + " .btn-default")
      end  

      # Format of contents: 
      #  [{type: :text, content: "Description"}, {type: :product, hint: "d", way: :icon}]
      #
      def submit(contents)
        @browser.execute_script('arguments[0].focus()', reply_box)

        contents.each do |content|
          case content[:type]
          when :text
            @browser.send_keys content[:content]
            @browser.send_keys :enter # workaround for EN-2719
          when :product
            old_mention_prods_num = mention_products.size
            case content[:way]
            when :key, nil
              @browser.send_keys "@"
            when :icon
              scroll_to_element mention_prod_icon
              mention_prod_icon.when_present.click
            end
            @browser.send_keys content[:hint]
            @browser.wait_until { mention_suggest_list.present?}
            mention_suggest_list.lis[0].when_present.click
            @browser.wait_until { !mention_suggest_list.present? }
            @browser.wait_until { mention_products.size == old_mention_prods_num + 1 }

            sleep 2
          when :tag
            case content[:way]
            when :key, nil
              @browser.send_keys "#"
            when :icon
              scroll_to_element mention_tag_icon
              mention_tag_icon.when_present.click
            end

            if content[:hint].nil?
              @browser.send_keys content[:content]
            else
              @browser.send_keys content[:hint]
              @browser.wait_until { mention_suggest_list.present? }
              mention_suggest_list.lis[0].when_present.click
              @browser.wait_until { !mention_suggest_list.present? }
            end  
          end 
        end

        @browser.execute_script('$("div.note-editable").blur()') #needed to communicate the description back to the parent element. the blur events fires fine during manual creation.
        # @browser.execute_script("window.scrollBy(0,600)")

        submit_btn.when_present.click
        @browser.wait_until { !submit_spinner.present? }
      end  
    end 
  end

  class AttachmentsPanel
    def initialize(browser)
      @browser = browser
      @parent_css = ".attachment-list"
    end

    def present?
      @browser.div(:css => @parent_css).present?
    end  

    def label_count
      @browser.element(:css => @parent_css + " .attachment-title").text[/\d+/].to_i
    end

    def attachments
      list_eles = @browser.lis(:css => @parent_css + " .list-group .list-group-item")

      results = []

      return [] if list_eles.size < 1

      (1..list_eles.size).each { |i|
        results.push(Attachment.new(@browser, @parent_css + " .list-group > .list-group-item:nth-child(#{i})"))
      }

      results
    end  

    class Attachment
      def initialize(browser, parent_css)
        @browser = browser
        @parent_css = parent_css
      end

      def download_link
        @browser.link(:css => @parent_css + " .download-attachment")
      end  

      def name
        name = nil

        return name if @browser.span(:css => @parent_css + " .file-title").when_present.text.match(/(.*) \(.*\)/).nil?

        if @browser.span(:css => @parent_css + " .file-title").when_present.text.match(/(.*) \(.*\)/).size > 0
          name = @browser.span(:css => @parent_css + " .file-title").when_present.text.match(/(.*) \(.*\)/)[1]
        else
          name
        end

        name
      end
      
      def download
        download_link.when_present.click
      end
    end  
  end  
end