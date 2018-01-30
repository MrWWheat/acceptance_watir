require 'pages/community'
require 'minitest/assertions'
require 'pages/community/conversationdetail'
require 'pages/community/conversation/conversation_create'
require 'pages/community/conversation/conversation_edit'
require 'pages/community/topic_list'
require 'pages/community/gadgets/topic_navigator'
require 'pages/community/gadgets/topic_conversations'
require 'pages/community/gadgets/side'

class Pages::Community::TopicDetail < Pages::Community

  def initialize(config, options = {})
    super(config)
    @url = config.base_url + "/n/#{config.slug}"

    @convcreate_page = Pages::Community::ConversationCreate.new(@config)
    @convedit_page = Pages::Community::ConversationEdit.new(@config)
    @convdetail_page = Pages::Community::ConversationDetail.new(@config)
    @login_page = Pages::Community::Login.new(@config)
  end
  
  def start!(user)
    super(user, @url, topic_page)
    
  end

  topicpage_url                           { "#{@@base_url}"+"/n/#{@@slug}" }
  productpage_url                         { "#{@@base_url}"+"/n/#{@@slug}/products" }

  support_topicname                       { "A Watir Topic With Many Posts" }
  engagement_topicname                    { "A Watir Topic" }
  eng_top_name                            { 'a-watir-topic'}
  engagement2_topicname                   { "A Watir Topic For Widgets" }
  topic_support 		                      { link(:text => "A Watir Topic With Many Posts") }
  topic_engagement 		                    { link(:text => "A Watir Topic") }
  topic_engagement2 	                    { link(:text => "A Watir Topic For Widgets") }

  topic_engagement_text                   { link(:class => "ember-view").h4(:text => engagement_topicname) }
  topic_support_text                      { link(:class => "ember-view").h4(:text => support_topicname) }

  first_topic_link                        { div(:class => "topic").div(:class => "topic-avatar") }
  first_product_link                      { div(:class => "topic").div(:class => "topic-avatar") }

  topic_page 			                        { div(:css => "#topics .topic-avatar") }
  topic_page_desc                         { div(:class => "topic-tile-body").link(:class => "body-paragraph ember-view").p }
  topic_avatar                            { div(:class => "topic-avatar") }
  topic_page_topic_link                   { link(:class => "ember-view", :text => $topic_name) }
  topic_page_no_topic                     { div(:class => "topics") }
  # topic_sort_button 	                    { button(:class => "btn btn-default dropdown-toggle filter-dropdown sap-regular-dropdown", :text => "Sorted by: Newest") }
  topic_sort_button                       { button(:css => ".topic-sort-drop-down button") }

  topic_breadcrumb                        { div(:class => "breadcrumbs dark-bg col-lg-5 col-md-5") }
  # topic_network_breadcrumb                { div(:class => "breadcrumbs dark-bg col-lg-5 col-md-5").link(:class => "ember-view", :text => "#{@@network_name}") }
  # topic_topic_breadcrumb                  { div(:class => "breadcrumbs dark-bg col-lg-5 col-md-5").link(:class => "ember-view", :text => "Topics") }
  topic_network_breadcrumb                { link(:css => ".breadcrumbs a[href$=home]") }
  topic_topic_breadcrumb                  { link(:css => ".breadcrumbs a:not([href$=home])")}

  conv_engagement_topic_breadcrumb        { div(:css => ".breadcrumbs-warp-text-overflow").link(:index => 2) }
  conv_support_topic_breadcrumb           { div(:class => "breadcrumbs col-lg-6 col-md-6").link(:class => "ember-view", :text => "A Watir Topic With Many Posts") }
  conv_engagement2_topic_breadcrumb       { div(:class => "breadcrumbs col-lg-6 col-md-6").link(:class => "ember-view", :text => "A Watir Topic For Widgets") }

  topic_mainpage_link	                    { div(:id => "topics") }
  topic_page_top_row                      { div(:class => "col-md-12").div(:class => "btn-toolbar").div(:class => "btn-group topic-filter-group") }
  topic_page_top_button                   { div(:class => "row topic-button-toolbar") }
  topic_title                             { element(:css => ".topic .title .banner-title") }
  topic_banner                            { div(:css => ".widget.banner.topic") }
  topic_filter                            { div(:class => "topic-filters") }
  topic_overview_selected                 { link(:class => "overview disabled", :text => "Overview") }
  topic_overview                          { link(:class => "overview ", :text => "Overview") }

  topic_post                              { div(:class => "post-collection").div(:class => "media-heading") } 
  topic_post_desc                         { div(:class => "post-collection").div(:class => "ember-view") }
  topic_post_feature                      { div(:class => "post media feature") }
  no_topic_post                           { div(:class => "post-collection").h4(:class => "empty-container-text") }
  topic_post_link                         { div(:class => "post-collection").div(:class => "media-heading").link }

  topic_post_author                       { div(:class => "ember-view creation-info clearfix").span(:class => "creator").span(:class => "ember-view network-profile-link") }
  topic_post_timestamp                    { div(:class => "ember-view creation-info clearfix").span(:class => "created-at") }

  topic_question_filter                   { link(:class => /ques/, :text => "Questions") }
  # topic_discussion_filter                 { link(:class => /disc/, :text => "Discussions") }
  topic_blog_filter                       { link(:class => /blog/, :text => "Blogs") }
  topic_review_filter                     { link(:class => /blog/, :text => "Reviews") }

  topic_question_filter_selected          { link(:class => "ques disabled", :text => "Questions") }
  topic_discussion_filter_selected        { link(:class => "disc disabled", :text => "Discussions") }
  topic_blog_filter_selected              { link(:class => "blog disabled", :text => "Blogs") }
  topic_review_filter_selected            { link(:class => "blog disabled", :text => "Reviews") }

  new_review_button                       { div(:class => "topic-follow-button").button(:class => "btn btn-primary", :text => "New Review") }
  create_discussion_btn                   { div(:class => "topic-follow-button").button(:text => /New Discussion/) }
  topic_create_new_button                 { div(:class => "topic-follow-button").button(:class => "btn btn-primary", :text => "Create New") }
  topic_create_new_question_menu_item    { ul(:css => ".topic-follow-button .dropdown .dropdown-menu").link(:text => "Question") }
  topic_create_new_blog_menu_item        { ul(:css => ".topic-follow-button .dropdown .dropdown-menu").link(:text => "Blog") }
  topic_create_new_review_menu_item      { ul(:css => ".topic-follow-button .dropdown .dropdown-menu").link(:text => "Review") }

  topic_post_show_more                    { links(:class => /btn btn-default/, :text => "Show more")[0] }

  topic_search                            { div(:class => /search-form search-bar col-md-8 col-sm-12 col-xs-12/).text_field(:class => "ember-view ember-text-field typeahead form-control tt-input") }
  topic_recentq                           { div(:class => "topic-overview", :text => /Most Recent Questions/) }
  topic_recentb                           { div(:class => "topic-overview", :text => /Most Recent Blogs/) }
  topic_recentd                           { div(:class => "topic-overview", :text => /Most Recent Discussions/) }
  
  topic_recentq_betaon                    { div(:class => "ember-view gadget gadget-topic-conversations topic-content gadget-topic-questions", :text => /Most Recent Questions/) }
  topic_recentb_betaon                    { div(:class => "ember-view gadget gadget-topic-conversations topic-content gadget-topic-blogs", :text => /Most Recent Blogs/) }

  topic_recentb_post                      { div(:class => "topic-overview", :text => /Most Recent Blogs/).div(:class => "ember-view post").div(:class => "media") }
  topic_recentd_post                      { div(:class => "topic-overview", :text => /Most Recent Discussions/).div(:class => "ember-view post").div(:class => "media") }
  topic_recentq_post                      { div(:class => "topic-overview", :text => /Most Recent Questions/).div(:class => "ember-view post").div(:class => "media") } 
    
  topic_recentb_post_title                { div(:class => "topic-overview", :text => /Most Recent Blogs/).div(:class => "media-body").div(:class => "media-heading") }
  topic_recentd_post_title                { div(:class => "topic-overview", :text => /Most Recent Discussions/).div(:class => "media-body").div(:class => "media-heading") }
  topic_recentq_post_title                { div(:class => "topic-overview", :text => /Most Recent Questions/).div(:class => "media-body").div(:class => "media-heading") }
  
  topic_recentb_post_title_betaon         { div(:class => "ember-view gadget gadget-topic-conversations topic-content gadget-topic-blogs", :text => /Most Recent Blogs/).div(:class => "media-body").div(:class => "media-heading") }
  topic_recentq_post_title_betaon         { div(:class => "ember-view gadget gadget-topic-conversations topic-content gadget-topic-questions", :text => /Most Recent Questions/).div(:class => "media-body").div(:class => "media-heading") }

  conversation_post_title                 { link(:css => ".customization-post-title")}

  topic_recentb_post_author               { div(:class => "topic-overview", :text => /Most Recent Blogs/).span(:class => "creator") }
  topic_recentd_post_author               { div(:class => "topic-overview", :text => /Most Recent Discussions/).span(:class => "creator") }
  topic_recentq_post_author               { div(:class => "topic-overview", :text => /Most Recent Questions/).span(:class => "creator") }
  
  topic_recentb_post_author_betaon        { div(:class => "ember-view gadget gadget-topic-conversations topic-content gadget-topic-blogs", :text => /Most Recent Blogs/).span(:class => "creator") }
  topic_recentq_post_author_betaon        { div(:class => "ember-view gadget gadget-topic-conversations topic-content gadget-topic-questions", :text => /Most Recent Questions/).span(:class => "creator") }

  topic_recent_q_icon                     { div(:class => "topic-overview", :text => /Most Recent Questions/).div(:class => "media-body").div(:index => 7) }
  topic_recent_best_answer_q_icon         { div(:class => "topic-overview", :text => /Most Recent Questions/).div(:class => "media-body").div(:index => 7) } #:text => "Question (Answered)")
  topic_recent_d_icon                     { div(:class => "topic-overview", :text => /Most Recent Discussions/).div(:class => "media-body").span(:class => "ember-view post-type discussion") } 
  topic_recent_b_icon                     { div(:class => "topic-overview", :text => /Most Recent Blogs/).div(:class => "media-body").span(:class => "ember-view post-type blog") }
  topic_recent_r_icon                     { div(:class => "topic-overview", :text => /Most Recent Reviews/).div(:class => "media-body").span(:class => "ember-view post-type review") }

  topic_recent_q_icon_betaon              { div(:class => "ember-view gadget gadget-topic-conversations topic-content gadget-topic-questions", :text => /Most Recent Questions/).div(:class => "media-body").div(:index => 7) }
  topic_recent_b_icon_betaon              { div(:class => "ember-view gadget gadget-topic-conversations topic-content gadget-topic-questions", :text => /Most Recent Blogs/).div(:class => "media-body").span(:class => "ember-view post-type blog") }

  topic_featured_q_icon                   { div(:class => "topic-overview", :text => /Featured Questions/).div(:class => "media-body").span(:class => "ember-view post-type question") }
  topic_featured_best_answer_q_icon       { div(:class => "topic-overview", :text => /Featured Questions/).div(:class => "media-body").span(:class => "ember-view post-type question answered") } #:text => "Question (Answered)")
  topic_featured_d_icon                   { div(:class => "topic-overview", :text => /Featured Discussions/).div(:class => "media-body").span(:class => "ember-view post-type discussion") } 
  topic_featured_b_icon                   { div(:class => "topic-overview", :text => /Featured Blogs/).div(:class => "media-body").span(:class => "ember-view post-type blog") }
  topic_featured_r_icon                   { div(:class => "topic-overview", :text => /Featured Reviews/).div(:class => "media-body").span(:class => "ember-view post-type review") }

  topic_q_icon                            { div(:class => "media-body").span(:class => "ember-view post-type question") }
  topic_best_answer_q_icon                { div(:class => "media-body").span(:class => "ember-view post-type question answered") } #:text => "Question (Answered)")
  topic_d_icon                            { div(:class => "media-body").span(:class => "ember-view post-type discussion") } 
  topic_b_icon                            { span(:css => ".ember-view.post-type.blog") }
  topic_r_icon                            { span(:css => ".ember-view.post-type.review") }

  topic_b_icon_in_b_filter                { span(:class => "crumb-icon icon-notes") }

  topic_new_q_button                      { div(:class => "topic-follow-button").button(:class => "btn btn-primary", :text => "New Question") }
  topic_new_d_button                      { div(:class => "topic-follow-button").button(:class => "btn btn-primary", :text => "New Discussion") }
  topic_new_b_button                      { div(:class => "topic-follow-button").button(:class => "btn btn-primary", :text => "New Blog") }
  topic_new_r_button                      { div(:class => "topic-follow-button").button(:class => "btn btn-primary", :text => "New Review") }
    
  topic_post_like_icon                    { div(:class => "stats ember-view").div(:class => /likes-count/) }
  topic_post_comment_icon                 { div(:class => "stats ember-view").div(:class => "reply-count") }
  topic_post_view_icon                    { div(:class => "stats ember-view").div(:class => "view-count") }
  topic_post_feature_icon                 { div(:class => "details").span(:class => "featured") }
    
  topic_featuredq                         { div(:class => "topic-overview", :text => /Featured Questions/) }
  topic_featuredb                         { div(:class => "topic-overview", :text => /Featured Blogs/) }
  topic_featuredd                         { div(:class => "topic-overview", :text => /Featured Discussions/) }

  topic_featuredb_post                    { div(:class => "topic-overview", :text => /Featured Blogs/).div(:class => "ember-view post").div(:class => "media") }
  topic_featuredd_post                    { div(:class => "topic-overview", :text => /Featured Discussions/).div(:class => "ember-view post").div(:class => "media") }
  topic_featuredq_post                    { div(:class => "topic-overview", :text => /Featured Questions/).div(:class => "ember-view post").div(:class => "media") }

  topic_featuredb_post_title              { div(:class => "topic-overview", :text => /Featured Blogs/).div(:class => "media-body").div(:class => "media-heading") }
  topic_featuredd_post_title              { div(:class => "topic-overview", :text => /Featured Discussions/).div(:class => "media-body").div(:class => "media-heading") }
  topic_featuredq_post_title              { div(:class => "topic-overview", :text => /Featured Questions/).div(:class => "media-body").div(:class => "media-heading") }

  topic_featuredb_post_author             { div(:class => "topic-overview", :text => /Featured Blogs/).span(:class => "creator") }
  topic_featuredd_post_author             { div(:class => "topic-overview", :text => /Featured Discussions/).span(:class => "creator") }
  topic_featuredq_post_author             { div(:class => "topic-overview", :text => /Featured Questions/).span(:class => "creator") }
    
  topic_featuredb_post_feature_icon       { div(:class => "topic-overview", :text => /Featured Blogs/).span(:text => "Featured") }
  topic_featuredd_post_feature_icon       { div(:class => "topic-overview", :text => /Featured Discussions/).span(:text => "Featured") }
  topic_featuredq_post_feature_icon       { div(:class => "topic-overview", :text => /Featured Questions/).span(:text => "Featured") }

  topic_signin_widget                     { div(:css => ".zone.side .widget.sign-in") }
  topic_signin_widget_title               { element(:css => ".zone.side .widget.sign-in h7") }
  topic_signin_widget_signin              { div(:css => ".zone.side .widget.sign-in .actions").link( :text => "Sign in") }
  topic_signin_widget_register            { div(:css => ".zone.side .widget.sign-in .actions").link( :text => "or Register") }

  topic_trending_tags_widget              { div(:css => ".trend_tags,.widget trend_tags")}

  topic_top_contributor_widget            { div(:css => ".widget[class*=contributors]") }
  topic_top_contributor_widget_title      { div(:css => ".widget[class*=contributors]").h7(:text => "Top Contributors") }

  topic_featured_topic_widget             { div(:css =>".zone.side .widget[class*=topics]") }
  topic_featured_topic_widget_title       { div(:css =>".zone.side .widget[class*=topics]") }
  topic_featured_topic_widget_topic_link  { div(:css =>".zone.side .widget[class*=topics]").p(:class=> "media-heading").link(:class => "ember-view") }
  topic_featured_topic_widget_topic_name  { div(:css =>".zone.side .widget[class*=topics]").link(:class => "ember-view active" , :text => $topic_name) }
  topic_featured_topic_widget_meta_info   { div(:css =>".zone.side .widget[class*=topics]").div(:class => "media-body").p(:class => "meta-text") }
  topic_featured_topic_widget_img         { div(:css =>".zone.side .widget[class*=topics]").div(:class => "media-left").link(:class => "pull-left ember-view").div(:class => "media-object widget-topic-avatar") }
  topic_featured_topic_widget_no_img      { div(:css =>".zone.side .widget[class*=topics]").div(:class => "media-left").link(:class => "pull-left ember-view").div(:class => "media-object widget-topic-no-avatar") }

  topic_popular_disc_widget               { div(:class => "widget popular_discussions") }
  topic_popular_disc_widget_title         { div(:class => "widget popular_discussions", :text => /Popular Discussions/) }
  topic_popular_disc_widget_conv_link     { div(:class => "widget popular_discussions").div(:class => "conversation-type").div(:class => "text").link(:class => "ember-view") }
  topic_popular_disc_widget_author_name   { div(:class => "widget popular_discussions").div(:class => "conversation-type").div(:class => "author").span(:class => "ember-view network-profile-link") }
  topic_popular_disc_widget_like_icon     { div(:class => "widget popular_discussions").div(:class => "conversation-type").div(:class => "author").span(:class => "jam-icon-like grey-icon crumb-icon widget-like") }
  topic_popular_disc_widget_author_img    { div(:class => "widget popular_discussions").div(:class => "conversation-type").div(:class => "author").img(:class => "media-object thumb-24") }

  topic_popular_answer_widget             { div(:css => ".gadget-popular-answers,.widget.popular_answers") }
  topic_popular_answer_widget_title       { div(:css => ".gadget-popular-answers,.widget.popular_answers").element(:text => /Popular Answers/)}
  topic_popular_answer_widget_first_link  { link(:css => ".gadget-popular-answers .conversation-type a") }
  topic_popular_answer_widget_conv_link   { div(:css => ".gadget-popular-answers,.widget.popular_answers").div(:class => "conversation-type").div(:class => "text").link(:class => "ember-view") }
  topic_popular_answer_widget_author_name { div(:css => ".gadget-popular-answers,.widget.popular_answers").div(:class => "conversation-type").div(:class => "author").span(:class => "ember-view network-profile-link") }
  topic_popular_answer_widget_like_icon   { div(:css => ".gadget-popular-answers,.widget.popular_answers").div(:class => "conversation-type").div(:class => "author").span(:class => "jam-icon-like grey-icon crumb-icon widget-like") }
  topic_popular_answer_widget_author_img  { div(:css => ".gadget-popular-answers,.widget.popular_answers").div(:class => "conversation-type").div(:class => "author").div }

  topic_featured_post_widget              { div(:class => "widget featured_posts") }
  topic_featured_post_widget_title        { div(:class => "widget featured_posts", :text => /Featured Posts/) }
  topic_featured_post_widget_conv_link    { div(:class => "widget featured_posts").ul(:class => "media-list").li(:class => "media").div(:class => "conversation-type").div(:class => "text").link(:class => "ember-view") }
  topic_featured_post_widget_author_name  { div(:class => "widget featured_posts").div(:class => "conversation-type").div(:class => "author").span(:class => "ember-view network-profile-link") }
  topic_featured_post_widget_author_img   { div(:class => "widget featured_posts").div(:class => "conversation-type").div(:class => "author").img(:class => "media-object thumb-24") }

  topic_open_q_widget                     { div(:class => "widget open_questions") }
  topic_open_q_widget_title               { div(:class => "widget open_questions", :text => /Open Questions/) }
  topic_open_q_widget_conv_link           { div(:class => "widget open_questions").div(:class => "conversation-type").div(:class => "text").link(:class => "ember-view") }
  topic_open_q_widget_author_name         { div(:class => "widget open_questions").div(:class => "conversation-type").div(:class => "author").span(:class => "ember-view network-profile-link") }
  topic_open_q_widget_author_img          { div(:class => "widget open_questions").div(:class => "conversation-type").div(:class => "author").img(:class => "media-object thumb-24") }

    
  topic_edit_screen                       { div(:class => "row topic-create-title", :text => /Edit Topic/) }
  topic_edit_desc                         { text_field(:id => "topic-caption-input") }
  topic_edit_tile_browse                  { link(:class => "edit-button", :text => "browse") }
  topic_edit_tile_modal                   { div(:id => "tile-upload-modal") }
  topic_edit_file_field                   { form(:class => "ember-view").file_field(:class => "ember-view ember-text-field files") }
  topic_edit_tile_cropper                 { div(:class => "cropper-canvas") }
  topic_edit_tile_img_select              { button(:class => "ember-view btn btn-primary btn-sm", :text=> /Select Image/) }
  topic_edit_file_img_selected            { img(:class => "topic-tile-selected-image") }
  topic_type_radio                        { div(:class => "col-md-6 col-sm-12").div(:class => "radio") }
  topic_edit_next                         { button(:class => "btn btn-primary", :text => /Next: Design/) }
  topic_edit_view_topic                   { button(:class => "btn btn-primary pull-right", :text => "Next: View Topic") }

  topic_deactivate_button                 { link(:class => "btn btn-default btn-sm admin-dark-btn", :text => "Deactivate Topic") }
  topic_deactivate_modal                  { div(:class => "modal-content") } #.div(:class => "modal-header", :text => /Deactivate Topic/)
  topic_deactivate_modal1                 { div(:id => "topic-deactivate-confirm") }
  topic_deactivate_confirm                { button(:value => "Confirm") }
  topic_activate_button                   { button(:class => "btn btn-default btn-sm admin-dark-btn", :value => "Activate Topic") }
  topic_publish_change_button             { div(:class => "topic-create-wizard").div(:class => "container").div(:class => "row").div(:class => "button-align-right").button(:class => "btn btn-primary btn-sm", :text => "Publish Changes") }
  topic_admin_button                      { div(:class => "buttons col-lg-7 col-md-7").div(:class => "btn-toolbar pull-right").div(:class => "btn-group").button(:class => "btn btn-default btn-sm admin-dark-btn topic-admin-buttons") }
  topic_edit_button                       { button(:class => "btn btn-default btn-sm admin-dark-btn", :text => "Edit Topic") } 

  topic_feature                           { div(:class => "btn-group").button(:class => "btn btn-default btn-sm admin-dark-btn topic-admin-buttons", :text => "Feature Topic") }
  topic_unfeature                         { div(:class => "btn-group").button(:class => "btn btn-default btn-sm admin-dark-btn topic-admin-buttons", :text => "Unfeature Topic") }
  topic_feature_button                    { button(:class => "btn btn-default btn-sm admin-dark-btn topic-admin-buttons", :text => "Feature Topic") }
  topic_unfeature_button                  { button(:class => "btn btn-default btn-sm admin-dark-btn topic-admin-buttons", :text => "Unfeature Topic") }

  tc_PD1_disc_link                        { link(:text => "::PD1:: Discussion1 posted to test popular discussion widget?") }
    
  topiclink                               { link(:text => "Topics") }
    
  topic_featured_filter                   { button(:class => "btn btn-default", :text => "Featured") }
  topic_all_filter                        { button(:class => "btn btn-default", :text => "All") }
    

  topic_sidezone_widget_betaon            { div(:class => "col-lg-4 col-md-4 col-sm-12 zone side") }
  topic_sidezone_widget                   { div(:class => /zone side/) }
   
  new_topic_title                         { text_field(:id => "new-topic-title") }
  new_topic_description                   { text_field(:id => "topic-caption-input") }
  engagement_topic_type_selection_box     { div(:class => "topic-type-selection-box engagement", :text => /Engagement/) }
  engagement_topic_type_selected          { div(:class => "topic-type-selection-box engagement chosen", :text => /Engagement/) }
  support_topic_type_selection_box        { div(:class => "topic-type-selection-box support", :text => /Q&A/) }
  support_topic_type_selected             { div(:class => "topic-type-selection-box support chosen", :text => /Q&A/) }
  advertise_check                         { div(:text => /Enable advertising/).input(:class => "ember-view ember-checkbox") }
  question_icon                           { div(:class => "question icon-sys-help-2") }

  topic_follow_button                     { div(:class => "topic-follow-button").button(:class => "btn btn-default", :text => "Follow Topic") }
  topic_unfollow_button                   { div(:class => "topic-follow-button").button(:class => "btn btn-default", :text => "Unfollow Topic") }

  topic_sort_post_by_oldest               { div(:class => "pull-right btn filter-dropdown ").span(:text => /Oldest/) }
  topic_sort_post_by_newest               { div(:class => "pull-right btn filter-dropdown ").span(:text => /Newest/) }

  #topic_sort_post_button                  { div(:class => "pull-right sort-by dropdown").span(:class => "dropdown-toggle")}

  topic_sort_post_by_oldest_new           { div(:class => "pull-right sort-by dropdown").span(:text => /Oldest/) }
  topic_sort_post_by_newest_new           { div(:class => "pull-right sort-by dropdown").span(:text => /Newest/) }

  sort_newest_option_dropdown             { div(:class => "pull-right sort-by dropdown open").link(:index => 0) }
  sort_oldest_option_dropdown             { div(:class => "pull-right sort-by dropdown open").ul(:class => "dropdown-menu").link(:text => /Oldest/) }
  
  topicdetail                             { div(:class => "topic-filters") }
  topicname                               { div(:class => "row title") }

  topic_link                              { link(:class => "ember-view") }
  topic_detail_create_new_button          { div(:class => "topic-follow-button").button(:class => "btn btn-primary", :text => "Create New") }

  topic_grid                              { div(:class => "topics-grid row") }
  
  topicfilter                             { div(:class => "topic-filters") }
  topic_page_divid                        { div(:id => "topics") }
  post_body 				                      { div(:class => "media-body") }

  search_dropdown                         { span(:class => "tt-dropdown-menu") }
  search_result_page                      { div(:class => "row filters search-facets") }

  topic_detail_create_conv_btn            { button(:css => ".topic-follow-button .btn-primary") }

  product_detail_banner                   { div(:css => ".product-banner")}
  product_detail_banner_title             { div(:class => "card-title").h3}
  product_detail_banner_readmore          { div(:class => "card-title").link}
  product_detail_ld_json                  { script(:css => "[type='application/ld+json']") }

  topic_detail_posts_avatars              { divs(:css => ".post .media .media-object[alt*=person]") }
  topic_detail_site_widgets_avatars       { divs(:css => ".side-gadget .media .media-object[alt*=person]") }

  topic_detail_creator_pills              { elements(:css => ".network-profile-pill") }
  topic_detail_posts_creator_pills        { elements(:css => ".post .network-profile-pill") }
  topic_detail_widget_creator_pills       { elements(:css => ".widget .network-profile-pill") }
  topic_detail_loading_block              { div(:css => ".loading-block") }
  topic_detail_loading_spinner            { element(:css => ".fa-spinner") }

  topic_detail_creator_avatars            { divs(:class => "contribution-icon-wrap")}
  topic_detail_creator_avatars_unfeature  { divs(:css => ".media-object.pull-left.ember-view")}

  onboarding_tooltips_close               { div(:class => "onboarding-tooltips open").span(:class => "icon-decline")}

  topic_review_restrict_modal             { div(:id => "review-restriction") }
  topic_review_restrict_modal_link        { link(:css => "#review-restriction a")}
  topic_review_restrict_modal_skip_btn    { button(:css => "#review-restriction button.btn-primary") }
###################### UI Elements when UI Customization beta feature enabled ######################
  def topic_navigator
    Gadgets::Community::TopicNavigator.new(@config.browser)
  end
  
  def recent_q_gadget
    Gadgets::Community::TopicQuestions.new(@config.browser)
  end

  def recent_b_gadget
    Gadgets::Community::TopicBlogs.new(@config.browser)
  end  
  
  def recent_r_gadget
    Gadgets::Community::TopicReviews.new(@config.browser)
  end

  def side_signin_gadget
    Gadgets::Community::SideSignIn.new(@config.browser)
  end

  def side_popular_answers_gadget
    Gadgets::Community::SidePopularAnswers.new(@config.browser)
  end

  def side_top_contri_gadget
    Gadgets::Community::SideTopContributors.new(@config.browser)
  end 

  def common_topic_navigator
    CommonTopicNavigator.new(@config.browser)
  end
    
  def wait_until_page_loaded
    @browser.wait_until { post_body.present? }
    @browser.wait_until { !topic_detail_loading_block.present? }
    @browser.wait_until { !topic_detail_loading_spinner.present?}
    @browser.wait_until { @browser.ready_state == "complete" }
  end

  def goto_topicdetail_page(topictype)
  case topictype
   when "support"
    if ($topic_sup_uuid != nil) 
       @browser.goto "#{@@base_url}"+"/topic/"+$topic_sup_uuid+"/#{@@slug}/"+support_topicname 
    else  
     if @browser.url != topicpage_url
      @browser.goto topicpage_url
      @browser.wait_until { topic_page.present? }
     end 
      
     if !@browser.text.include? support_topicname
      topic_sort_by_name
     end 
     @browser.wait_until { topic_page.present? }
     @browser.execute_script("window.scrollBy(0,2000)")
     topic_support.when_present.click
     @browser.wait_until {@browser.url.include? "/topic/"}
     topic_url = @browser.url
     $topic_sup_uuid = topic_url.split("/topic/")[1].split("/")[0]
    end

    when "engagement"
     if ($topic_eng_uuid != nil) # && $topic_eng_uuid !=0)
      @browser.goto "#{@@base_url}"+"/topic/"+$topic_eng_uuid+"/#{@@slug}/"+engagement_topicname    
     else
      if @browser.url != topicpage_url
       @browser.goto topicpage_url
       @browser.wait_until { topic_page.present? }
      end 
      if !@browser.text.include? engagement_topicname
       topic_sort_by_name
      end
      @browser.wait_until { topic_page.present? }
      @browser.execute_script("window.scrollBy(0,2000)")
      topic_engagement.when_present.click
      @browser.wait_until {@browser.url.include? "/topic/"}
      topic_url = @browser.url
      $topic_eng_uuid = topic_url.split("/topic/")[1].split("/")[0]
     end

    when "engagement2"
     if ($topic_eng2_uuid != nil)# && $topic_eng2_uuid !=0)
       @browser.goto "#{@@base_url}"+"/topic/"+$topic_eng2_uuid+"/#{@@slug}/"+engagement2_topicname
     else
      if @browser.url != topicpage_url
       @browser.goto topicpage_url
       @browser.wait_until { topic_page.present? }
      end 
      if !@browser.text.include? engagement2_topicname
       topic_sort_by_name
      end
      @browser.wait_until { topic_page.present? }
      @browser.execute_script("window.scrollBy(0,2000)")
      topic_engagement2.when_present.click
      @browser.wait_until {@browser.url.include? "/topic/"}
      topic_url = @browser.url
      $topic_eng2_uuid = topic_url.split("/topic/")[1].split("/")[0]
     end
      else
       raise "Invalid topic type! Exit.."
     end 
   
    @browser.wait_until { topic_filter.present? }
    topic_publish
  end

  def get_topic_uuid(topictype)
    case topictype
     when "engagement"
      #if topic_uuid != nil
       goto_topicdetail_page("engagement")
       topic_url = @browser.url
       topic_uuid = topic_url.split("/topic/")[1].split("/")[0]
      #end
     when "support"
      goto_topicdetail_page("support")
      topic_url = @browser.url
      topic_uuid = topic_url.split("/topic/")[1].split("/")[0]
     when "engagement2"
      goto_topicdetail_page("engagement2")
      topic_url = @browser.url
      topic_uuid = topic_url.split("/topic/")[1].split("/")[0]
    else
      raise "Invalid topictype!"
    end
      return topic_uuid
  end

  def topic_sort_by_name
    if @browser.url != "#{@@base_url}"+"/n/#{@@slug}"
     @browser.goto topicpage_url
     @browser.wait_until { topic_page.present? }
    end
    
    topic_name = "A Watir Topic"
    if topic_sort_button.present? 
      assert topic_sort_button.text == "Sorted by: Newest"

      @c.screenshot!('topicsort.png')
      refute_nil @browser.execute_script 'return $(".topic-sort-drop-down >button").trigger("click")', "Failed to open the dropdown"
      refute_nil @browser.execute_script 'return $(".filter-dropdown a:contains(\'Name\')").trigger("click")', "Failed to Name sort option in the dropdown"
      @browser.wait_until { topic_mainpage_link.text =~ /#{topic_name}/ }
      @browser.wait_until { topic_page.present? }
      assert topic_mainpage_link.text =~ /#{topic_name}/
    end
  end

  def product_sort_by_name
    @browser.wait_until { first_product_link.present? }
    origin = first_product_link.text
    @browser.wait_until{ topic_sort_button.present? }
    refute_nil @browser.execute_script 'return $(".topic-sort-drop-down >button").trigger("click")', "Failed to open the dropdown"
    refute_nil @browser.execute_script 'return $(".filter-dropdown a:contains(\'Name\')").trigger("click")', "Failed to Name sort option in the dropdown"
    @browser.wait_until { first_product_link.present? }
    @browser.wait_until { first_product_link.text != origin}
  end

  def topic_publish
   if topic_publish_change_button.present?
      topic_publish_change_button.click
      @browser.wait_until { topic_admin_button.present? }
      assert topic_admin_button.present?
   end
   if topic_activate_button.present?
    topic_activate_button.click
    @browser.wait_until { topic_deactivate_button.present?}
    assert topic_deactivate_button.present?
   end 
  end

  def choose_post_type(type)
    @browser.wait_until { post_body.present? }
    @browser.wait_until { !topic_detail_loading_block.present? }
    # @browser.wait_until($t) {topic_post.present?}
    if type == "discussion"
      type_css = "Discussions"
    elsif type == "question"
      type_css = ".topic-navigator-item[href='#topic-conversation-questions'],.topic-navigator-item[data-hash='#topic-conversation-questions']"
    elsif type == "blog"
      type_css = ".topic-navigator-item[href='#topic-conversation-blogs'],.topic-navigator-item[data-hash='#topic-conversation-blogs']"
    elsif type == "review"
      type_css = ".topic-navigator-item[href='#topic-conversation-reviews'],.topic-navigator-item[data-hash='#topic-conversation-reviews']"
    end
    @browser.execute_script("window.scrollTo(0,document.documentElement.scrollTop)")
    link = @browser.element(:css => type_css)
    link.when_present.click
    @browser.wait_until {post_body.present?}
  
  end

  def topic_detail(topic_name)
    if respond_to?(:deprecate)
      deprecate __method__, "Use fixtures for getting topic related information. \nExample: @browser.goto topics(:a_watir_topic).url"
    end

    if ($topic_uuid != nil && $topic_uuid != 0)
      @browser.goto "#{@@base_url}"+"/topic/"+$topic_uuid+"/#{@@slug}/"+topic_name
    else   
    if !(topic_grid.present?)
     @browser.execute_script("window.scrollTo(0,document.documentElement.scrollTop)")
     topiclink.when_present.click
     @browser.wait_until { topic_grid.present? }
    end
    @browser.wait_until { topic_page.present? }
    if ( !(topic_page_divid.text.include? topic_name) && !(topic_page_divid.link(:text => topic_name).exists?))
     topic_sort_by_name
    end
    @browser.execute_script("window.scrollBy(0,3000)")
    @browser.link(:class => "ember-view", :text => topic_name).when_present.click
    @browser.execute_script("window.scrollTo(0,document.documentElement.scrollTop)")
    @browser.wait_until { topic_filter.present? }
    topic_url = @browser.url
    $topic_uuid = topic_url.split("/topic/")[1].split("/")[0]
    end
  end

  def feature_topic
    @browser.execute_script("window.scrollTo(0,document.documentElement.scrollTop)")
    if topic_feature.present? 
     begin
        topic_feature.click
      rescue Selenium::WebDriver::Error::UnknownError => e
        if e.message.include? "Element is not clickable at point"
          onboarding_tooltips_close.when_present.click
          topic_feature.click
        else 
          raise e
        end
      end
     @browser.wait_until { topic_unfeature.present? }
    end
  end

  def unfeature_topic
    @browser.execute_script("window.scrollTo(0,document.documentElement.scrollTop)")
    if topic_unfeature.present? 
     begin
        topic_unfeature.click
      rescue Selenium::WebDriver::Error::UnknownError => e
        if e.message.include? "Element is not clickable at point"
          onboarding_tooltips_close.when_present.click
          topic_unfeature.click
        else 
          raise e
        end
      end
     @browser.wait_until { topic_feature.present? }
    end
  end

  def click_topic_feature
    # scroll top to avoid ui elements overlapped by navigation top bar
    @browser.execute_script("window.scrollTo(0,document.documentElement.scrollTop)")
    topic_publish
    topic = topicname.h1.text
    if topic_unfeature.present? 
      begin
        topic_unfeature.click
      rescue Selenium::WebDriver::Error::UnknownError => e
        if e.message.include? "Element is not clickable at point"
          onboarding_tooltips_close.when_present.click
          topic_unfeature.click
        else 
          raise e
        end
      end
    end
    @browser.wait_until { topic_feature.present? }
    topic_feature.when_present.click
    @browser.wait_until { topic_unfeature.present? }
    sleep 2 #assert @topic_unfeature.present?
    return topic
  end

  def click_topic_unfeature
    # scroll top to avoid ui elements overlapped by navigation top bar
    @browser.execute_script("window.scrollTo(0,document.documentElement.scrollTop)")
    topic_publish
    topic = topicname.h1.text
    if topic_feature.present? 
      begin
        topic_feature.click
      rescue Selenium::WebDriver::Error::UnknownError => e
        if e.message.include? "Element is not clickable at point"
          onboarding_tooltips_close.when_present.click
          topic_feature.click
        else 
          raise e
        end
      end
    end
    @browser.wait_until { topic_unfeature.present? }
    topic_unfeature.when_present.click
    @browser.wait_until { topic_feature.present? }
    return topic
  end

  def create_discussion
    create_discussion_btn.when_present.click
  end

  

  def goto_topic_page
    @browser.goto topicpage_url
    @browser.wait_until { topic_page.present? }
  end

  def topic_and_sort_check
    if !topic_page_top_row.present?
     goto_topic_page
     accept_policy_warning
    end
    
    @browser.wait_until { topic_page.present? }
    if !topic_avatar.h4.text.include?(engagement_topicname)
      topic_sort_by_name
    end
    @browser.wait_until { topic_page.present? }
  end


  def check_post_filter(posttype)
    @browser.wait_until{topic_post.present?}
    @browser.execute_script("window.scrollTo(0,document.documentElement.scrollTop)")
    case posttype
      when "ques"
        # topic_question_filter.when_present.click
        common_topic_navigator.questions_link.when_present.click
        @browser.wait_until { topic_post.present? }
      when "disc"
        topic_discussion_filter.when_present.click
        @browser.wait_until { topic_post.present? }
      when "blog"
        # topic_blog_filter.when_present.click
        common_topic_navigator.blogs_link.when_present.click
        @browser.wait_until { topic_post.present? }
      when "review"
        # topic_review_filter.when_present.click
        common_topic_navigator.reviews_link.when_present.click
        @browser.wait_until { topic_post.present? || no_topic_post.present? }
      else
        raise "Invalid post type! Exit.."
     end   
    
  end 

  def check_post_filter_button(posttype, user)
    @browser.wait_until {common_topic_navigator.questions_link.present? || 
      common_topic_navigator.selected_questions_link.present? }
    case posttype
     when "ques"
      if common_topic_navigator.questions_link.present?
        sleep 2
       common_topic_navigator.questions_link.when_present.click
      else
       assert common_topic_navigator.selected_questions_link.present?
       @browser.wait_until { topic_new_q_button.present? }
      end
     when "disc"
      if topic_discussion_filter.present?
       topic_discussion_filter.when_present.click
      else
       assert topic_discussion_filter_selected.present?
       @browser.wait_until { topic_new_d_button.present? }
      end
     when "blog"
      if common_topic_navigator.blogs_link.present?
        sleep 2
       common_topic_navigator.blogs_link.when_present.click
      else
       assert common_topic_navigator.selected_blogs_link.present?
      end
      if user == "logged"
        @browser.wait_until { topic_create_new_button.present? }
     else
      @browser.wait_until { !topic_new_b_button.present? }
    end
     when "review"
      if common_topic_navigator.reviews_link.present?
        sleep 2
       common_topic_navigator.reviews_link.when_present.click
      else
       assert common_topic_navigator.selected_reviews_link.present?  
       @browser.wait_until { topic_new_r_button.present? }
      end
     else
      raise "Invalid post type! Exit.."
     end   
  end

  def check_post_conv_anon
    about_login("anon", "visitor")
    accept_policy_warning
    topic_detail("A Watir Topic")
    choose_post_type("question")
    @convdetail_page = Pages::Community::ConversationDetail.new(@config)
    @convdetail_page.conversation_detail("question")
    
    @convdetail_page.reply_box.when_present.focus
    @login_page = Pages::Community::Login.new(@config)
    @browser.wait_until { @login_page.signin_page.present? }
    assert @login_page.signin_page.present?
 end

 def check_post_like_anon
    about_login("anon", "visitor")
    accept_policy_warning
    topic_detail("A Watir Topic")
    choose_post_type("question")
    @convdetail_page = Pages::Community::ConversationDetail.new(@config)
    @convdetail_page.conversation_detail("question")
    @convdetail_page.conv_root_post_like_link.when_present.click
    @login_page = Pages::Community::Login.new(@config)
    @browser.wait_until { @login_page.signin_page.present? }
 end

 def check_post_follow_anon
    about_login("anon", "visitor")
    accept_policy_warning
    topic_detail("A Watir Topic")
    choose_post_type("question")
    @convdetail_page = Pages::Community::ConversationDetail.new(@config)
    @convdetail_page.conversation_detail("question")
    @convdetail_page.conv_root_post_follow_link.when_present.click
    @login_page = Pages::Community::Login.new(@config)
    @browser.wait_until { @login_page.signin_page.present? }
 end

 def create_new_q_from_topic_detail
  @convdetail_page = Pages::Community::ConversationDetail.new(@config)
  @convdetail_page.create_conversation(@config.network_name, @config.slug, "A Watir Topic", "question", "Q from topic detail created by Watir - #{get_timestamp}")
  end

  def create_new_q_with_link_from_topic_detail
    @convdetail_page = Pages::Community::ConversationDetail.new(@config)
    @convdetail_page.create_conversation(@config.network_name, @config.slug, "A Watir Topic", "question_with_link", "Q with link created by Watir - #{get_timestamp}", false)
  end

  def create_new_q_with_image_from_topic_detail
    @convdetail_page = Pages::Community::ConversationDetail.new(@config)
    @convdetail_page.create_conversation(@config.network_name, @config.slug, "A Watir Topic", "question_with_image", "Q with image created by Watir - #{get_timestamp}", false)
  end

  def create_new_q_with_rte_from_topic_detail
    @convdetail_page = Pages::Community::ConversationDetail.new(@config)
    @convdetail_page.create_conversation(@config.network_name, @config.slug, "A Watir Topic", "question_with_rte", "Discussion with rte created by Watir - #{get_timestamp}" , false)
  end

  def create_new_d_with_link_from_topic_detail
    @convdetail_page = Pages::Community::ConversationDetail.new(@config)
    @convdetail_page.create_conversation(@config.network_name, @config.slug, "A Watir Topic", "discussion_with_link", "Discussion with link created by Watir - #{get_timestamp}" , false)
  end

  def create_new_d_with_rte_from_topic_detail
    @convdetail_page = Pages::Community::ConversationDetail.new(@config)
    @convdetail_page.create_conversation(@config.network_name, @config.slug, "A Watir Topic", "discussion_with_rte", "Discussion with rte created by Watir - #{get_timestamp}" , false)
  end

  def create_new_b_with_video_from_topic_detail
    @convdetail_page = Pages::Community::ConversationDetail.new(@config)
    @convdetail_page.create_conversation(@config.network_name, @config.slug, "A Watir Topic", "blog_with_video", "Blog with video created by Watir - #{get_timestamp}", false)
  end

  def create_new_b_from_topic_detail
    @convdetail_page = Pages::Community::ConversationDetail.new(@config)
    @convdetail_page.create_conversation(@config.network_name, @config.slug, "A Watir Topic", "blog", "Blog created by Watir - #{get_timestamp}", false)
  end

  def create_conv_with_tag
    about_login("regular_user1", "logged")
    # go to a specific topic
    topic_name = "A Watir Topic"
    tag = "#tag#{get_timestamp}"
    @topiclist_page = Pages::Community::TopicList.new(@config)
    @topicdetail_page = @topiclist_page.go_to_topic(topic_name)
    # create a question in the specific topic "A Watir Topic"
    root_post = "Q created by Watir for flag - #{get_timestamp}"
    descrip = "Watir test description - #{get_timestamp} #{tag}"
    @topicdetail_page.create_conversation(type: :question,
                                          title: root_post,
                                          details: [{type: :text, content: descrip}])
    return {:title => root_post, :descrip => descrip, :tag => tag, :url => @browser.url }
  end

  def suggested_q_post
    new_question = "watir "
    @browser.wait_until { topic_filter.present? }
    goto_conversation_create_page(:question)

    @convdetail_page = Pages::Community::ConversationDetail.new(@config)
    @browser.wait_until { @convdetail_page.post_type_picker.present? }
    @convdetail_page.conv_create.when_present.set new_question
    @browser.wait_until { @convdetail_page.conv_suggest_shown.present? }
    sleep 2
    assert @browser.form.ul.present?
    assert @browser.form.ul.li.text =~ /#{new_question.strip}/i
    total = @browser.form.ul.lis.length

    matches = @browser.form.ul.lis(:text => /#{new_question.strip}/i).length
    assert_equal total, matches, "Some autocompletes did not match '#{new_question}'"
  end

  def suggested_q_post_link
    new_question = "watir"
    @browser.wait_until { topic_filter.present? }
    goto_conversation_create_page(:question)
    
    @convdetail_page = Pages::Community::ConversationDetail.new(@config)
    @browser.wait_until { @convdetail_page.post_type_picker.present? }
    @convdetail_page.conv_create.when_present.set new_question
    @browser.wait_until { @convdetail_page.conv_suggest_shown.present? }
    assert @browser.form.ul.present?
    sleep 2

    conv_link = @browser.form.ul.link.text
    #sleep 1
    @browser.link(:text => conv_link).click
    sleep 2
    @browser.windows.last.use
    #@browser.wait_until { @browser.url =~ /#{new_question}/ }
    assert @browser.url =~ /#{new_question}/
    title = @browser.h3(:class => "root-post-title", :text => conv_link)
    #puts title.text
    @browser.wait_until { title.present? }
    assert title.present?
    @browser.windows.last.close
 end

 def follow_topic
    if !topic_filter.present?
     goto_topicdetail_page("engagement")
    end
    topic_follow_button.when_present.click
    sleep 2
    @browser.wait_until { topic_unfollow_button.present? }
  end

  def unfollow_topic
    if !topic_filter.present?
     goto_topicdetail_page("engagement")
    end
    if topic_follow_button.present?
      follow_topic
    end
    topic_unfollow_button.when_present.click
    sleep 2
    @browser.wait_until { topic_follow_button.present? }
  end


 def check_no_admin_button(user)
    if user == "logged"
      about_login("regular_user2", "logged")
    end
    if !topic_filter.present?
     goto_topicdetail_page("engagement")
    end
    @browser.wait_until { !topic_edit_button.present? }
    @browser.wait_until { !topic_deactivate_button.present? }
    @browser.wait_until { !topic_feature_button.present? || !topic_unfeature_button.present? }
  end

  def check_admin_button(user)
    if user == "logged"
      about_login("network_admin", "logged")
    end
    @login_page = Pages::Community::Login.new(@config)
    if !@login_page.topnav_notification.present?
     about_login("network_admin", "logged")
    end
    goto_topic_page
    goto_topicdetail_page("support")
    @browser.wait_until { topic_filter.present? }
    @browser.wait_until { topic_edit_button.present? }
    @browser.wait_until { topic_deactivate_button.present? }
    @browser.wait_until { topic_feature_button.present? || topic_unfeature_button.present? }
  end

  def check_topicdetail_search
    searchtext = "Watir Test Question1 ?"
    topic_search.when_present.set searchtext
    @browser.wait_until { search_dropdown.attribute_value('style') =~ /display: / }
    @browser.send_keys :enter
    @browser.wait_until { search_result_page.present? }
  end

  def sort_post_by_newest
    if topic_sort_post_by_oldest.present? || topic_sort_post_by_oldest_new.present?
    @browser.wait_until { topic_sort_post_by_oldest.present? || topic_sort_post_by_oldest_new.present? }
    if topic_sort_post_by_oldest.present?
     topic_sort_post_by_oldest.click
    else
     topic_sort_post_by_oldest_new.click
     @browser.wait_until { sort_newest_option_dropdown.present? }
     sort_newest_option_dropdown.click
    end
    @browser.wait_until { post_body.present? }
    end
    @browser.wait_until { topic_sort_post_by_newest.present? || topic_sort_post_by_newest_new.present? }
    #@topic_post_timestamp.text.include? "/hour/|/hours/|/day/|/days/"
  end

  def sort_post_by_oldest
    if topic_sort_post_by_newest.present? || topic_sort_post_by_newest_new.present?
    @browser.wait_until { topic_sort_post_by_newest.present? || topic_sort_post_by_newest_new.present?}
    if topic_sort_post_by_newest.present?
     topic_sort_post_by_newest.click
    else
     topic_sort_post_by_newest_new.click
     @browser.wait_until { sort_oldest_option_dropdown.present? }
     sort_oldest_option_dropdown.click
    end
    @browser.wait_until { topic_post.present? }
    end
    @browser.wait_until { topic_sort_post_by_oldest.present? || topic_sort_post_by_oldest_new.present? }
    #@topic_post_timestamp.text.include? "/hour/|/hours/|/day/|/days/"
  end

  def check_featured_post_present(posttype)
    case posttype
     when "ques"
      @browser.wait_until { topic_featuredq.present? }
     when "disc"
      @browser.wait_until { topic_featuredd.present? }
     when "blog"
      @browser.wait_until { topic_featuredb.present? }
     else
      raise "Invalid post type! Exit.."
     end   
  end

  def check_featured_post_title(posttype)
    case posttype
     when "ques"
      @browser.wait_until { topic_featuredq_post_title.present? }
     when "disc"
      @browser.wait_until { topic_featuredd_post_title.present? }
     when "blog"
      @browser.wait_until { topic_featuredb_post_title.present? }
     else
      raise "Invalid post type! Exit.."
     end   
  end

  def check_featured_post_author_name(posttype)
    case posttype
     when "ques"
      @browser.wait_until { topic_featuredq_post_author.present? }
     when "disc"
      @browser.wait_until { topic_featuredd_post_author.present? }
     when "blog"
      @browser.wait_until { topic_featuredb_post_author.present? }
     else
      raise "Invalid post type! Exit.."
     end   
  end

  def check_featured_post_feature_icon(posttype)
    case posttype
     when "ques"
      @browser.wait_until { topic_featuredq_post_feature_icon.present? }
     when "disc"
      @browser.wait_until { topic_featuredd_post_feature_icon.present? }
     when "blog"
      @browser.wait_until { topic_featuredb_post_feature_icon.present? }
     else
      raise "Invalid post type! Exit.."
     end   
  end

  def check_featured_post_icon(posttype)
    case posttype
     when "ques"
      @browser.wait_until { (topic_featured_q_icon.present? && topic_featured_q_icon.text =~ /Question/) || (topic_featured_best_answer_q_icon.present? && topic_featured_best_answer_q_icon.text =~ /Question (Answered)/ ) }
     when "disc"
      @browser.wait_until { topic_featured_d_icon.present? && topic_featured_d_icon.text =~ /Discussion/}
     when "blog"
      @browser.wait_until { topic_featured_b_icon.present? && topic_featured_b_icon.text =~ /Blog/ }
     else
      raise "Invalid post type! Exit.."
     end   
  end


  def check_recent_post_present(posttype)
    case posttype
     when "ques"
      @browser.wait_until { topic_recentq_betaon.present? }
     when "blog"
      @browser.wait_until { topic_recentb_betaon.present? }
     else
      raise "Invalid post type! Exit.."
    end  
  end


  def check_recent_post_title(posttype)
    case posttype
    when "ques"
      @browser.wait_until { topic_recentq_post_title_betaon.present? }
    when "blog"
      @browser.wait_until { topic_recentb_post_title_betaon.present? }
    else
      raise "Invalid post type! Exit.."
    end  
  end

  def check_recent_post_author_name(posttype)
    case posttype
    when "ques"
      @browser.wait_until { topic_recentq_post_author_betaon.present? }
    when "blog"
      @browser.wait_until { topic_recentb_post_author_betaon.present? }
    else
      raise "Invalid post type! Exit.."
    end   
  end

  def check_recent_post_icon(posttype)
    case posttype
    when "ques"
      @browser.wait_until { topic_recent_q_icon_betaon.present? }
    when "blog"
      @browser.wait_until { topic_recent_b_icon_betaon.present? }
    else
      raise "Invalid post type! Exit.."
    end  
  end

  def check_post_link
    accept_policy_warning
    @browser.wait_until { topic_post_link.present? }
    topic_post_link.when_present.click
    @convdetail_page = Pages::Community::ConversationDetail.new(@config)
    @browser.wait_until { @convdetail_page.conv_detail.present? }   
  end

  def check_post_title_author_icon(posttype)
    @browser.wait_until { topic_post.present? }
    @browser.wait_until { topic_post_author.present? }
    @browser.wait_until { topic_post_timestamp.present? }
    case posttype
     when "ques"
      topic_q_icon.present? || topic_best_answer_q_icon.present?
     when "disc"
      topic_d_icon.present?
     when "blog"
      topic_b_icon.present?
     else
      raise "Invalid post type! Exit.."
     end   
  end

  def check_post_like_icon_and_count
    @browser.wait_until { topic_post.present? }
    @browser.wait_until { topic_post_like_icon.present? }
  end

  def check_post_reply_icon_and_count
    url = @browser.url
    @browser.wait_until { topic_post.present? }
    @browser.wait_until { topic_post_comment_icon.present? }
    topic_post_comment_icon.click
    @browser.wait_until { @convdetail_page.reply_box.present? }
    @browser.goto url
    @browser.wait_until { topic_post.present? && topic_post_comment_icon.present? }
  end

  def check_post_view_icon_and_count
    # url = @browser.url
    @browser.wait_until { topic_post.present? }
    @browser.wait_until { topic_post_view_icon.present? }
    # view_count = topic_post_view_icon.attribute_value("innerText").to_i
    # conversation_post_title.when_present.click
    # @browser.wait_until { @convdetail_page.reply_box.present? }
    # @browser.wait_until {  }
    # @browser.goto url
    # the first question might be viewed by other case at the same time. So, use >= below instead of ==.
    # the exact comparsion case is covered in widgets_test.rb

    # @browser.wait_until { topic_post.present? && topic_post_view_icon.attribute_value("innerText").to_i >= (view_count + 1) }
  end

  def check_show_more_for_post
    accept_policy_warning
    @browser.wait_until { topic_post.present? }
    @browser.execute_script("window.scrollBy(0,10000)")
    @browser.wait_until { topic_post_show_more.present? }
    scroll_to_element(topic_post_show_more)
    @browser.execute_script("window.scrollBy(0,-200)")

    topic_post_show_more.when_present.click
    @browser.execute_script("window.scrollBy(0,10000)")
    @browser.wait_until { topic_post_show_more.present? || ( !topic_post_show_more.present?) }
    @browser.wait_until { topic_post.present? }
  end


  def check_topic_signin_widget_for_anon
    @login_page = Pages::Community::Login.new(@config)
    if @login_page.topnav_notification.present? || @login_page.user_dropdown.present?
     @login_page.logout!
     @browser.wait_until { topic_page.present? }
    end
    #goto_topicdetail_page()
    @browser.wait_until { topic_signin_widget.present? }
  end

  def check_topic_signin_widget_title
    @browser.wait_until { topic_signin_widget_title.present? }
  end

  def check_topic_signin_widget_action
    
    @browser.wait_until { topic_signin_widget_signin.present? }
    topic_signin_widget_signin.when_present.click
    @login_page = Pages::Community::Login.new(@config)
    @browser.wait_until { @login_page.signin_page.present? }
  end

  def check_topic_signin_widget_action_for_register
    @login_page = Pages::Community::Login.new(@config)
    if @login_page.topnav_notification.present? || @login_page.user_dropdown.present?
     @login_page.logout!
    end
    @browser.wait_until { topic_signin_widget_register.present? }
    topic_signin_widget_register.when_present.click
    @login_page = Pages::Community::Login.new(@config)
    @browser.wait_until { @login_page.register_page.present? }
  end

  def check_topic_signin_widget_for_reg
    @browser.wait_until { !topic_signin_widget.present? }
  end

  def check_top_contributor_widget
    @browser.wait_until { topic_top_contributor_widget.present? }
  end

  def check_top_contributor_widget_title
    @browser.wait_until { topic_top_contributor_widget_title.present? }
  end

  def check_top_contributor_widget_work
    if topic_top_contributor_widget.text.include? "#{@c.users[:network_admin].username}"
      about_login("regular_user1", "logged")
      topic_detail("A Watir Topic For Widgets")
      choose_post_type("question")
      @browser.wait_until { @topic_post.present? }
      @convdetail_page = Pages::Community::ConversationDetail.new(@config)
      @convdetail_page.conversation_detail("question")
      @browser.wait_until { @convdetail_page.convdetail.present? }
      unless @convdetail_page.conv_root_post_like_link.when_present.class_name.include?("action-done") #Unliked
        @convdetail_page.conv_root_post_like_link.click
        @browser.wait_until { @convdetail_page.conv_root_post_like_link.class_name.include?("action-done") } #Liked
      end
    end
    @convdetail_page = Pages::Community::ConversationDetail.new(@config)
    @login_page.login!(@c.users[:network_admin])
    goto_topicdetail_page("engagement2")
    topicurl = @browser.url
    sleep 1
    
    if !topic_post.present?
      @convdetail_page.create_conversation(@config.network_name, @config.slug, "A Watir Topic For Widgets", "question", "Discussion created by Watir when no post present - #{get_timestamp}")
    end
    @browser.goto topicurl
    @browser.wait_until { topic_post.present? }
    
    choose_post_type("question")
    @convdetail_page = Pages::Community::ConversationDetail.new(@config)
    @convdetail_page.conversation_detail("question")
    @browser.wait_until { @convdetail_page.convdetail.present? }
    conv_url = @browser.url
    unless @convdetail_page.conv_root_post_follow_link.when_present.class_name.include?("action-done")  #added check for admin follow for root post
    @convdetail_page.conv_root_post_follow_link.click
    @browser.wait_until { @convdetail_page.conv_root_post_follow_link.class_name.include?("action-done") } #Followed
    end
    Pages::Community.new(@config).about_login("regular_user1", "logged")
    @browser.goto conv_url
    # $topic_name = "A Watir Topic For Widgets"
    # goto_topicdetail_page("engagement2")
    # choose_post_type("question")
    # @browser.wait_until { topic_post.present? }
    # @convdetail_page = Pages::Community::ConversationDetail.new(@config)
    # @convdetail_page.conversation_detail("question")
    @browser.wait_until { @convdetail_page.convdetail.present? }

    if @convdetail_page.conv_root_post_like_link.when_present.class_name.include?("action-done") #Liked
      @convdetail_page.conv_root_post_like_link.click
      @browser.wait_until { !@convdetail_page.conv_root_post_like_link.class_name.include?("action-done") } #Unliked
    end
    assert !@convdetail_page.conv_root_post_like_link.class_name.include?("action-done") #Unliked
    @convdetail_page.conv_root_post_like_link.click
    @browser.wait_until { @convdetail_page.conv_root_post_like_link.class_name.include?("action-done") } #Liked
    assert @convdetail_page.conv_root_post_like_link.class_name.include?("action-done") #Liked

    @convdetail_page.conv_breadcrumbs_topic_link.click
    @browser.wait_until { topic_post.present? }
    
    topic_publish
    @browser.execute_script("window.scrollBy(0,7000)")
    @browser.wait_until { topic_top_contributor_widget.li.present? }
    assert topic_top_contributor_widget.present?

    @browser.wait_until {
      topic_top_contributor_widget.li.present?
    }
    sleep 1
    assert topic_top_contributor_widget.link(:text => "#{@c.users[:network_admin].name}").present?
    
    #@browser.execute_script("window.scrollTo(0,document.documentElement.scrollTop)")
    scroll_to_element topic_top_contributor_widget
    @browser.execute_script("window.scrollBy(0,-200)")
    topic_top_contributor_widget.link(:text => "#{@c.users[:network_admin].name}").when_present.click
    @profile_page = Pages::Community::Profile.new(@config)

    @browser.wait_until { @profile_page.user_profile_betaon.present?}
    assert @profile_page.user_profile_name_betaon.text.include? "#{@c.users[:network_admin].name}"

    topic_link.when_present.click
    @browser.wait_until { topic_page.present? }
    
    $topic_name = "A Watir Topic For Widgets"
    
    if !@browser.text.include?(engagement_topicname)
     topic_sort_by_name
     @browser.wait_until { topic_page.present? }
    end
    goto_topicdetail_page("engagement2")
    @browser.wait_until { topic_filter.present? }
    choose_post_type("question")
    @browser.wait_until { topic_post.present? }
    @convdetail_page = Pages::Community::ConversationDetail.new(@config)
    @convdetail_page.conversation_detail("question")
    @browser.wait_until { @convdetail_page.convdetail.present? }
    @browser.wait_until { @convdetail_page.conv_root_post_like_link.when_present.class_name.include?("action-done") } #Liked
    @convdetail_page.conv_root_post_like_link.click
    @browser.wait_until { !@convdetail_page.conv_root_post_like_link.class_name.include?("action-done") } #Unliked
    assert !@convdetail_page.conv_root_post_like_link.class_name.include?("action-done")
  end

  def check_featured_topic_widget
    @browser.wait_until { topic_featured_topic_widget.present? }
  end

  def check_featured_topic_widget_title
    @browser.wait_until { topic_featured_topic_widget_title.present? }
  end

  def check_featured_topic_widget_link_and_img
    @browser.wait_until { topic_featured_topic_widget_img.present? || topic_featured_topic_widget_no_img.present? }
    assert topic_featured_topic_widget_img.present? || topic_featured_topic_widget_no_img.present?
    @browser.wait_until { topic_featured_topic_widget_topic_link.present? }
    topic1 = topic_featured_topic_widget_topic_link.text
    topic1_word = topic1.split(' ')
    topic1_first_word = topic1_word[0] #+title_firstword[1]
    topic1_second_word = topic1_word[1]
    topic1_third_word = topic1_word[2]
    topic1_first_second_third_word = "#{topic1_first_word}"+"#{topic1_second_word}"+"#{topic1_third_word}"
    @browser.execute_script("window.scrollBy(0,500)")
    topic_featured_topic_widget_topic_link.click
    @browser.wait_until { topicdetail.present? }
    topic2 = topic_title.text
    topic2_word = topic2.split(' ')
    topic2_first_word = topic2_word[0] #+title_firstword[1]
    topic2_second_word = topic2_word[1]
    topic2_third_word = topic2_word[2]
    topic2_first_second_third_word = "#{topic2_first_word}"+"#{topic2_second_word}"+"#{topic2_third_word}"
    assert_equal topic1_first_second_third_word, topic2_first_second_third_word, "Topics don't match"
  end

  def check_featured_topic_widget_work
    @login_page = Pages::Community::Login.new(@config)
    if !@login_page.topnav_notification.present? 
     about_login("network_admin", "logged") #
    end
    $topic_name = "A Watir Topic For Widgets"
    topic_detail($topic_name)
    @browser.wait_until { topic_filter.present?  }
    topic_publish
    if topic_unfeature_button.present?
      unfeature_topic
    end
    feature_topic
    @browser.goto topicpage_url
    @browser.wait_until { topic_page.present? }
    
    @browser.wait_until { topic_featured_filter.present? }
    topic_featured_filter.click
    
    @browser.wait_until { topic_page.present? }
    
    topic_all_filter.click
    @browser.wait_until { topic_page.present? }
    goto_topicdetail_page("engagement")
   
    @browser.wait_until { topic_filter.present? }
    @browser.wait_until { topic_featured_topic_widget_topic_link.present? }
    
    @browser.execute_script("window.scrollBy(0,300)")
    @browser.wait_until { topic_featured_topic_widget.present? }
    scroll_to_element(topic_featured_topic_widget)
    @browser.execute_script("window.scrollBy(0,-200)")
    topic_featured_topic_widget_topic_link.click
    @browser.wait_until { topic_filter.present? }
    assert_match topic_title.text, "#{$topic_name}"
    if topic_publish_change_button.present?
     topic_publish_change_button.click
     @browser.wait_until { !topic_publish_change_button.present?}
    end
    if topic_unfeature_button.present?
      unfeature_topic
    end   
  end

  def check_popular_discussion_widget
    @browser.wait_until { topic_popular_disc_widget.present? }
  end

  def check_popular_discussion_widget_title
    @browser.execute_script("window.scrollBy(0,20000)") 
    @browser.wait_until { topic_popular_disc_widget_title.present? }
  end

  def check_popular_discussion_widget_like_icon_and_author_link_and_img
    @browser.execute_script("window.scrollBy(0,20000)") 
    @browser.wait_until { topic_popular_disc_widget.li.present? }
    @browser.wait_until { topic_popular_disc_widget_author_img.present? }
    assert topic_popular_disc_widget_author_img.present?

    @browser.wait_until { topic_popular_disc_widget_like_icon.present? }
    assert topic_popular_disc_widget_like_icon.present?
    @browser.wait_until { topic_popular_disc_widget_author_name.present? }
    assert topic_popular_disc_widget_author_name.present?
    author1 = topic_popular_disc_widget_author_name.text
    topic_popular_disc_widget_author_name.click
    @profile_page = Pages::Community::Profile.new(@config)
    @browser.wait_until { @profile_page.profile_page.present? }
    author2 = @profile_page.user_profile_name.text
    assert_equal author2, author1, "Not same user profile"
  end

  # def check_popular_discussion_widget_work
  #   @login_page = Pages::Community::Login.new(@config)
  #   if !@login_page.topnav_notification.present?
  #    about_login("network_admin", "logged")
  #   end
  #   $topic_name = "A Watir Topic For Widgets"
  #   about_login("regular_user2", "logged")
  #   goto_topicdetail_page("engagement2")
  #   eng2_url = @browser.url
   
  #   topic_publish
  #   choose_post_type("discussion")
  #   @convdetail_page = Pages::Community::ConversationDetail.new(@config)
  #   @convdetail_page.conversation_detail("discussion")
  #   conv_name = @convdetail_page.root_post_title.text
  #   conv_link = @browser.url
    
  #   exp_title = conv_name.split(' ')
  #   exp_title_firstword = exp_title[0]
  #   exp_title_secondword = exp_title[1]
    
  #   @browser.wait_until { @convdetail_page.conv_detail.present? }
  #   if !likeunlike_disc_element.present? 
  #    about_login("regular_user3", "logged")
  #    @browser.goto conv_link
  #    @browser.wait_until { topic_post.present? }
  #   end
  #   @browser.wait_until { likeunlike_disc_element.present? }
  #    if like_disc_element.present?
  #    like_disc_element.click
  #    @browser.wait_until { unlike_disc_element.present? }
  #    end
    
  #   @login_page = Pages::Community::Login.new(@config)
  #   @login_page.logout!
  #   about_login("network_admin", "logged")
  #   @browser.goto eng2_url
    
  #   @browser.wait_until { topic_sidezone_widget.present? }
  #   @browser.execute_script("window.scrollBy(0,16000)") 
  #   assert topic_popular_disc_widget.present?

  #   @browser.wait_until {
  #     topic_popular_disc_widget_conv_link.present?
  #   }
  #   title = topic_popular_disc_widget_conv_link.text
  #   title_firstword = title.split(' ')
  #   conv_name_first_word = title_firstword[0] #+title_firstword[1]
  #   assert topic_popular_disc_widget.text.include? conv_name_first_word
  #   assert_match conv_name_first_word, exp_title_firstword, "Another discussion"
  
  #   topic_popular_disc_widget_conv_link.when_present.click
  #   @convdetail_page = Pages::Community::ConversationDetail.new(@config)
  #   @browser.wait_until { @convdetail_page.conv_detail.present? }

  #   assert @convdetail_page.conv_detail_title.text.include? conv_name
  #   assert @convdetail_page.conv_featured_comment.present?, "Make sure comment is featured for this question"
  # end


  def check_popular_answer_widget
    @browser.wait_until { topic_popular_answer_widget.present? }
  end

  def check_popular_answer_widget_title
    @browser.wait_until { topic_popular_answer_widget_title.present? }
  end

  def check_popular_answer_widget_like_icon_and_author_link_and_img
    @browser.execute_script("window.scrollBy(0,1000)") 
    if !topic_popular_answer_widget.li.present?
     @login_page = Pages::Community::Login.new(@config)
     if !@login_page.topnav_notification.present?
      about_login("network_admin", "logged")
     end
     $topic_name = "A Watir Topic With Many Posts"
    
     goto_topicdetail_page("support")
     sup_url = @browser.url
     @browser.wait_until { topic_filter.present? }

     topic_publish
     @browser.wait_until { topic_sidezone_widget.present? }
     choose_post_type("question")
     @convdetail_page = Pages::Community::ConversationDetail.new(@config)
     @convdetail_page.conversation_detail("question")
     title = @convdetail_page.root_post_title.text
     @browser.wait_until { @convdetail_page.conv_reply_input.present? }
     if @convdetail_page.featured_answer.present?
      @convdetail_page.unfeature_reply
     end
    
     @convdetail_page.post_comment("question")  
     @convdetail_page.feature_reply
     @browser.goto sup_url 
     @browser.wait_until { topic_filter.present? }
    
     @browser.execute_script("window.scrollBy(0,7000)")
     @browser.wait_until { topic_popular_answer_widget.present? }
    end
    @browser.wait_until { topic_popular_answer_widget.li.present? }
    @browser.wait_until { topic_popular_answer_widget_author_img.present? }
    image = topic_popular_answer_widget_author_img.style("background-image")
    @browser.wait_until { (image.include? "profile_photo") || (image.include? "person") }
    @browser.wait_until { topic_popular_answer_widget_like_icon.present? }
    @browser.wait_until { topic_popular_answer_widget_author_name.present? }
    @browser.execute_script("window.scrollTo(0,document.documentElement.scrollTop)")
    author1 = topic_popular_answer_widget_author_name.text
    scroll_to_element topic_popular_answer_widget_author_name
    @browser.execute_script("window.scrollBy(0,-200)")
    topic_popular_answer_widget_author_name.click
    @profile_page = Pages::Community::Profile.new(@config)

    @browser.wait_until { @profile_page.profile_page_betaon.present? }
    author2 = @profile_page.profile_page_author_name_betaon.text
    assert_equal author2, author1, "Not same user profile"
  end

  def check_popular_answer_widget_work
    @login_page = Pages::Community::Login.new(@config)
    if !@login_page.topnav_notification.present?
     about_login("network_admin", "logged")
    end
    topic_name = "A Watir Topic For Widgets"
    
    goto_topicdetail_page("engagement2")
    sup_url = @browser.url
    @browser.wait_until { topic_filter.present? }

    topic_publish
    @browser.wait_until { topic_sidezone_widget.present? }
    choose_post_type("question")
    @convdetail_page = Pages::Community::ConversationDetail.new(@config)
    @convdetail_page.conversation_detail("question")
    title = @convdetail_page.root_post_title.text
    conv_url = @browser.url 
  
    if !@convdetail_page.answer_level1.present?
     @browser.wait_until { @convdetail_page.convdetail.present? }
    else
     @browser.wait_until { @convdetail_page.answer_level1.present? }
    end

    # @browser.wait_until { !@convdetail_page.spinner.present? }
    @browser.wait_until { !@convdetail_page.layout_loading_block.present? }
    @browser.wait_until { !@convdetail_page.layout_loading_spinner.present? }
    if @convdetail_page.featured_answer.present?
     @convdetail_page.unfeature_reply
    end
    
    @convdetail_page.post_comment("question")  

    ### adding user1 like as popular answer widget list is based on number of likes on answer ###
    about_login("regular_user1", "logged")
    @browser.goto conv_url
    @browser.wait_until { @convdetail_page.reply.present? }
    @browser.wait_until { @convdetail_page.reply_post_content.present? || @convdetail_page.reply_box.present? } 
    sort_post_by_newest
    @browser.wait_until { @convdetail_page.reply_post_content.present? }
    @browser.wait_until { !@convdetail_page.spinner.present? }
    if @convdetail_page.reply_unlike_disc_element.present?
     @convdetail_page.reply_unlike_disc_element.click
     @browser.wait_until { @convdetail_page.reply_like_disc_element.present? }
     assert @convdetail_page.reply_like_disc_element.present?
    end
    @convdetail_page.reply_like_disc_element.when_present.click
    @browser.wait_until { @convdetail_page.reply_unlike_disc_element.present? }
    assert @convdetail_page.reply_unlike_disc_element.present?

    about_login("network_admin", "logged")
    @browser.goto conv_url
    @browser.wait_until { @convdetail_page.convdetail.present? }
    @convdetail_page.feature_reply
    @browser.goto sup_url 
    @browser.wait_until { topic_filter.present? }
    
    @browser.execute_script("window.scrollBy(0,7000)")
    @browser.refresh
    @browser.wait_until { topic_popular_answer_widget.present? }
    @browser.wait_until {
      topic_popular_answer_widget.li.present?
    }
    assert topic_popular_answer_widget.li.present?

    @browser.wait_until { !layout_loading_spinner.present? }
    
    title_firstword = topic_popular_answer_widget.lis.first.link.text.split(' ')
    conv_name_first_word = title_firstword[0] 
    conv_name_second_word = title_firstword[1]
   
    @browser.wait_until { topic_popular_answer_widget.lis.first.link.text =~ /#{conv_name_first_word}/ }

    # sometimes, the widget is overlapped by the top navigator.   
    scroll_to_element(topic_popular_answer_widget)
    # @browser.execute_script("window.scrollBy(0,-300)")
    sleep 2

    topic_popular_answer_widget_first_link.when_present.click
    @browser.wait_until { @convdetail_page.convdetail.present?}
    @browser.wait_until { @convdetail_page.root_post_title.text =~ /#{title}/ }
    assert @convdetail_page.root_post_title.text =~ /#{title}/
    assert @convdetail_page.conv_featured_comment.present?, "Make sure answer is featured for this question"

    # annoymous user can see the widget
    about_login("anon", "visitor")
    @browser.goto sup_url
    @browser.wait_until { topic_filter.present? }
    check_popular_answer_widget_title
    assert topic_popular_answer_widget_title.present?

    about_login("network_admin", "logged")
    @browser.goto conv_url
    @browser.wait_until { @convdetail_page.convdetail.present?}
    @convdetail_page.unfeature_reply
  end

  def check_featured_post_widget
    @browser.wait_until { topic_featured_post_widget.present? }
  end

  def check_featured_post_widget_title
    @browser.wait_until { topic_featured_post_widget_title.present? }
  end

  def check_featured_post_widget_author_link_and_img
    @browser.execute_script("window.scrollBy(0,900)")
    if !topic_featured_post_widget.li.present?
     @login_page = Pages::Community::Login.new(@config)   
     if !@login_page.topnav_notification.present?
      about_login("network_admin", "logged")
     end
     topic_detail("A Watir Topic With Many Posts")
     topic_url = @browser.url
     choose_post_type("discussion")
     @convdetail_page = Pages::Community::ConversationDetail.new(@config)
     @convdetail_page.conversation_detail("discussion")
     title = @convdetail_page.convdetail.text
     title_firstword = title.split(' ')
     conv_name = /#{title_firstword[0]}/
     
     if @convdetail_page.conv_root_post_featured.present?
      @convdetail_page.unfeature_root_post
     end
     @convdetail_page.feature_root_post
     @browser.goto topic_url
     @browser.wait_until { topic_filter.present? }
     @browser.wait_until { topic_post.present? }
     @browser.execute_script("window.scrollBy(0,3000)")
     @browser.wait_until { topic_featured_post_widget.present? }
     @browser.wait_until { topic_featured_post_widget_conv_link.present? }
    end
    @browser.wait_until { topic_featured_post_widget_author_img.present? }
    @browser.wait_until { topic_featured_post_widget_author_name.present? }
    author1 = topic_featured_post_widget_author_name.text
    topic_featured_post_widget_author_name.click
    @profile_page = Pages::Community::Profile.new(@config)
    @browser.wait_until { @profile_page.profile_page.present? }
    author2 = @profile_page.profile_page_author_name.text
    assert_equal author2, author1, "Not same user profile"
  end

  def check_featured_post_widget_work
    @login_page = Pages::Community::Login.new(@config)
    if !@login_page.topnav_notification.present?
     about_login("network_admin", "logged")
    end
    if !topic_title.text.include?(support_topicname)
     topic_detail("A Watir Topic With Many Posts")
    end
    topic_url = @browser.url
    choose_post_type("question")
    @convdetail_page = Pages::Community::ConversationDetail.new(@config)
    @convdetail_page.conversation_detail("question")
    title = @convdetail_page.convdetail.text
    title_firstword = title.split(' ')
    conv_name = /#{title_firstword[0]}/
    if @convdetail_page.conv_root_post_featured.present?
      @convdetail_page.unfeature_root_post
    end
    @convdetail_page.feature_root_post
    @browser.goto topic_url
    @browser.wait_until { topic_filter.present? }
    @browser.wait_until { topic_post.present? }
    @browser.execute_script("window.scrollBy(0,3000)")
    @browser.wait_until { topic_featured_post_widget.present? }
    @browser.wait_until { topic_featured_post_widget_conv_link.present? }
    
    @browser.execute_script("window.scrollTo(0,document.documentElement.scrollTop)")
    topic_featured_post_widget_conv_link.click
    @browser.wait_until { @convdetail_page.conv_detail.present? }
    title2 = @convdetail_page.convdetail.text
    assert title == title2
    
    if @convdetail_page.conv_root_post_featured.present?
      @convdetail_page.unfeature_root_post
    end
    
    @browser.goto topic_url
    choose_post_type("question")
    @browser.wait_until { topic_post.present? }
    @browser.execute_script("window.scrollBy(0,800)")
    @browser.wait_until { topic_featured_post_widget.present? }
    
    assert ( !topic_featured_post_widget.text.include? title)
  end


  def check_open_question_widget
    @browser.wait_until { topic_open_q_widget.present? }
  end

  def check_open_question_widget_title
    @browser.wait_until { topic_open_q_widget_title.present? }
  end

  def check_open_question_widget_author_link_and_img
    accept_policy_warning
    @browser.wait_until { topic_open_q_widget_author_img.present? }
    @browser.wait_until { topic_open_q_widget_author_name.present? }
    author1 = topic_open_q_widget_author_name.text
    topic_open_q_widget_author_name.when_present.click
    @profile_page = Pages::Community::Profile.new(@config)
    @browser.wait_until { @profile_page.profile_page.present? }
    author2 = @profile_page.profile_page_author_name.text
    assert_equal author2, author1, "Not same user profile"
  end

  def check_open_question_widget_work
    #network_landing($network)
    @login_page = Pages::Community::Login.new(@config)
    if !@login_page.topnav_notification.present?
     about_login("network_admin", "logged")
    end
    
    goto_topicdetail_page("support")
    
    if !topic_filter.present?
    $topic_name = "A Watir Topic With Many Posts"
    conv_name = /Watir Test Question/
    @browser.wait_until { topic_page.present?}
    assert topic_page.present?
    goto_topicdetail_page("support")
    @browser.wait_until { topic_filter.present? }
    end
    topic_publish
    #@browser.wait_until($t) { @topic_sidezone_widget.present? }
    
    @browser.execute_script("window.scrollBy(0,9000)")
    @convdetail_page = Pages::Community::ConversationDetail.new(@config)
    if !topic_open_q_widget.li.present?
      @convdetail_page = Pages::Community::ConversationDetail.new(@config)
      @convdetail_page.create_conversation(@config.network_name, @config.slug, "A Watir Topic With Many Posts", "question", "Q created by Watir when no open Q - #{get_timestamp}")
      goto_topicdetail_page("support")
      topic_publish
    
    end
    @browser.wait_until { topic_sidezone_widget.present? }
    @browser.wait_until { topic_open_q_widget.li.present? }
    assert topic_open_q_widget.present?

    @browser.wait_until {
      topic_open_q_widget.li.present?
    }

    assert topic_open_q_widget_conv_link.present?

    topic_open_q_widget_conv_link.when_present.click
    @browser.wait_until { @convdetail_page.conv_detail.present?}
    assert @convdetail_page.conv_detail_title.present?
    assert !@convdetail_page.conv_root_post_featured.present?, "Make sure no post is featured for this question"
  end

  def edit_a_topic
    @login_page = Pages::Community::Login.new(@config)
    if !@login_page.topnav_notification.present?
     about_login("network_admin", "logged")
    end
    @topiclist_page = Pages::Community::TopicList.new(@config)
    topic_title = "A Watir Topic For Widgets"
    if !topic_filter.present?
     @topiclist_page.go_to_topic(topic_title)
    end
    @browser.execute_script("window.scrollTo(0,document.documentElement.scrollTop)")
    topicdescrip = "Watir topic test description updated during topic edit - #{get_timestamp}"
    filetile = "#{$rootdir}/seeds/development/images/topictileedit.jpg"
    @browser.wait_until { topic_filter.present?  }
    topic_publish
    @browser.execute_script("window.scrollTo(0,document.documentElement.scrollTop)")
    @browser.wait_until { topic_edit_button.present? }
    topic_edit_button.when_present.click
    @browser.wait_until { topic_edit_screen.present? }
    topic_edit_desc.when_present.set topicdescrip

    #@topic_edit_tile_browse.when_present.click
    #@browser.wait_until($t) { @topic_edit_tile_modal.present? }
    
    #@browser.wait_until($t) { @topic_edit_file_field.exists? } # this will be hidden
    #assert @topic_edit_file_field.exists?
    #if $os == "windows"
    #  @browser.execute_script('$(".photo-upload-browse").removeClass("photo-upload-browse")')
    #end
    #@topic_edit_file_field.set filetile
    #@browser.wait_until($t) {@topic_edit_tile_cropper.present? }
    #@topic_edit_tile_img_select.when_present.click
    #@browser.wait_until($t) { @topic_edit_file_img_selected.present? }
    @browser.execute_script("window.scrollBy(0,1000)")
    @browser.wait_until { topic_type_radio.present?}
    
    topic_edit_next.when_present.click
    sleep 4
    @browser.wait_until { topic_edit_screen.present? }
    
    @browser.execute_script("window.scrollBy(0,1000)")
    @browser.wait_until { topic_edit_view_topic.present? }
    topic_edit_view_topic.when_present.click
    @browser.wait_until { topic_sidezone_widget_betaon.present? }

    @browser.wait_until { topic_filter.present? }
    @browser.refresh
    @browser.wait_until { topic_publish_change_button.present? }
    @browser.execute_script("window.scrollTo(0,document.documentElement.scrollTop)")
    topic_publish_change_button.when_present.click
    sleep 2
    #@browser.wait_until($t) { !@topic_publish_change_button.present? }
    @browser.wait_until { topic_edit_button.present? }
    @topiclist_page.navigate_in
    @browser.execute_script("window.scrollTo(0,document.documentElement.scrollTop)")
    @browser.wait_until { !@topiclist_page.topiccard_list.topic_with_title(topic_title).nil? }
    assert @topiclist_page.topiccard_list.topic_with_title(topic_title).description.include?(topicdescrip)
  end

  def deactivate_a_topic
    @login_page = Pages::Community::Login.new(@config)
    if !@login_page.topnav_notification.present?
     about_login("network_admin", "logged")
    end
    if !topic_filter.present?
     goto_topicdetail_page("engagement2")
    end
    @browser.wait_until { topic_filter.present?  }
    if topic_activate_button.present?
      topic_activate_button.click
      @browser.wait_until { topic_deactivate_button.present? }
    end
    topic_deactivate_button.when_present.click
    @browser.wait_until { topic_deactivate_modal1.attribute_value('style') =~ /display: block;/  }
    #@browser.execute_script('$("button.btn btn-primary").click()')
    topic_deactivate_confirm.click
    
    @browser.wait_until { topic_activate_button.present? }
  end

  def activate_a_topic
    @login_page = Pages::Community::Login.new(@config)
    if !@login_page.topnav_notification.present?
     about_login("network_admin", "logged")
    end
    if !topic_filter.present?
     goto_topicdetail_page("engagement2")
    end

    @browser.wait_until { topic_filter.present?  }
    if topic_deactivate_button.present?
      topic_deactivate_button.when_present.click
      @browser.wait_until { topic_activate_button.present? }
    end
    sleep 1
    topic_activate_button.when_present.click
    
    @browser.wait_until { topic_deactivate_button.present? }
  end

  def topic_widgets_in_topic_type(network, networkslug, topicname, topictype)
    @login_page = Pages::Community::Login.new(@config)
    @login_page.login![:network_admin]
    @browser.link(:class => "ember-view", :text => topicname).when_present.click
    @browser.wait_until { topic_top_contributor_widget_title.present? }
    if (topictype == "engagement")
      @browser.wait_until { topic_top_contributor_widget_title.present? }
      assert topic_top_contributor_widget_title.present?
      @browser.wait_until { topic_featured_topic_widget_title.present? }
      assert topic_featured_topic_widget_title.present?
      @browser.wait_until { topic_popular_disc_widget_title.present? }
      assert topic_popular_disc_widget_title.present?
      assert ( !topic_open_q_widget_title.present?)
    else 
      @browser.wait_until { topic_popular_answer_widget_title.present? }
      assert topic_popular_answer_widget_title.present?
      @browser.wait_until { topic_featured_post_widget_title.present? }
      assert topic_featured_post_widget_title.present?
      @browser.wait_until { topic_top_contributor_widget_title.present? }
      assert topic_top_contributor_widget_title.present?
      @browser.wait_until { topic_open_q_widget_title.present? }
      assert topic_open_q_widget_title.present?
      assert ( !topic_popular_disc_widget_title.present?)
    end
  end

  def feature_a_topic
    @login_page = Pages::Community::Login.new(@config)
    if !@login_page.topnav_notification.present?
     about_login("network_admin", "logged")
    end
    if !topic_filter.present?
     goto_topicdetail_page("engagement")
    end
    $topic_name = "A Watir Topic"
    @browser.wait_until { topic_filter.present?  }
    
    if topic_unfeature_button.present?
      unfeature_topic
    end
    feature_topic
    @browser.goto topicpage_url
    @browser.wait_until { topic_page.present? }
    
    @browser.wait_until { topic_featured_filter.present? }
    topic_featured_filter.click
    
    @browser.wait_until { topic_page.present? }
    assert topic_page.text.include? $topic_name
    
    topic_all_filter.click
    @browser.wait_until { topic_page.present? }
    
    if !@browser.text.include?(engagement_topicname)
      topic_sort_by_name
      @browser.wait_until { topic_page.present? }
    end
    topic_engagement.when_present.click
    @browser.wait_until { topic_filter.present? }
    if topic_feature_button.present?
      feature_topic
    end
    topic_unfeature_button.click
    @browser.wait_until { topic_feature_button.present? }
  end

  def unfeature_a_topic
    @login_page = Pages::Community::Login.new(@config)
    if !@login_page.topnav_notification.present?
     about_login("network_admin", "logged")
    end

    if !topic_filter.present?
     goto_topicdetail_page("engagement")
    end
    $topic_name = "A Watir Topic"
    @browser.wait_until { topic_filter.present?  }
    
    if topic_feature_button.present?
      feature_topic
    end
    unfeature_topic
    @browser.goto topicpage_url
    @browser.wait_until { topic_page.present? }
    
    @browser.wait_until { topic_featured_filter.present? }
    topic_featured_filter.click
    
    @browser.wait_until { topic_page.present? || topic_page_no_topic.present? }
    assert ( !@browser.text.include? $topic_name) || ( @browser.text.include? "There are no topics")
    
    topic_all_filter.click
    @browser.wait_until(50) { topic_page.present? }
    
    if !@browser.text.include?(engagement_topicname)
      topic_sort_by_name
      @browser.wait_until(50) { topic_page.present? }
    end
    topic_engagement.when_present.click
    @browser.wait_until { topic_filter.present? }
    @browser.wait_until { topic_feature_button.present? }

  end

  def goto_first_productdetail_page
    if @browser.url != productpage_url
      @browser.goto productpage_url
    end
    first_product_link.when_present.click
  end

  def goto_conversation_create_page(type)
    sleep 2
    @browser.execute_script("window.scrollBy(0,-1000)")
    topic_create_new_button.when_present.click
    case type
    when :question
      topic_create_new_question_menu_item.when_present.click
    when :blog
      topic_create_new_blog_menu_item.when_present.click
    when :review
      topic_create_new_review_menu_item.when_present.click
    end
  end  

  # Format of param details - [{ type: :text/:product/:tag, content/hint: xxx, way: :key/:icon }]
  def create_conversation(type: :question, title:, details:, attachments: nil)
    # choose_post_type("blog")
    goto_conversation_create_page(type)

    @convcreate_page.fill_in_fields_then_submit_conversation(type: type, title: title, 
                                                             details: details, attachments: attachments)
    @browser.wait_until { @convdetail_page.conv_content.present? }
  end

  def create_blog(title:, details:, attachments: nil, publish_schedule: nil)
    goto_conversation_create_page(:blog)

    @convcreate_page.fill_in_conversation_fields(type: :blog, title: title, details: details, attachments: attachments)

    @convcreate_page.submit_blog(publish_schedule)
    @browser.wait_until { @convdetail_page.conv_content.present? }
  end  

  def create_review(title:, details:, attachments: nil, star: 5, recommended: true)
    choose_post_type("review")
    goto_conversation_create_page(:review)

    @convcreate_page.fill_in_fields_then_submit_review(title: title, details: details, 
                                                       attachments: attachments, star: star, recommended: recommended)
    @browser.wait_until { @convdetail_page.conv_content.present? }
  end 

  def goto_conversation(type: :question, title: nil)
    choose_post_type(type.to_s)

    posts_widget = nil

    sleep 2
    case type
    when :question
      posts_widget = questionlist_widget
    when :blog
      posts_widget = bloglist_widget
    when :review 
      posts_widget = reviewlist_widget
    end

    @browser.wait_until { posts_widget.present? && posts_widget.load_finished? }
    accept_policy_warning
    if title.nil?
      posts_widget.post_at_index(0).open
    else
      raise "Cannot find the conversation with title #{title}" if posts_widget.post_with_title(title).nil?
      posts_widget.post_with_title(title).open
    end 

    @browser.wait_until { @convdetail_page.conv_detail.present? } 
    @browser.wait_until { !@convdetail_page.layout_loading_block.present? }
    @browser.wait_until { !@convdetail_page.layout_loading_spinner.present? }
    @browser.execute_script("window.scrollTo(0,document.documentElement.scrollTop)")
  end 

  def questionlist_widget
    PostListWidget.new(@browser, ".gadget-topic-questions")
  end 

  def bloglist_widget
    PostListWidget.new(@browser, ".gadget-topic-blogs")
  end  

  def reviewlist_widget
    PostListWidget.new(@browser, ".gadget-topic-reviews")
  end  

  class PostListWidget
    def initialize(browser, parent_css)
      @browser = browser
      @parent_css = parent_css
    end

    def present?
      @browser.element(:css => @parent_css + " .post-list").present?
    end

    def load_finished?
      !@browser.element(:css => @parent_css + " .post-list .loading-block").present?
    end 

    def show_more_link
      @browser.link(:css => @parent_css + " .show-more-topics a")
    end  

    def posts
      list_eles = @browser.divs(:css => @parent_css + " .post-list .posts .post")

      results = []

      return [] if list_eles.size < 1

      (1..list_eles.size).each { |i|
        results.push(Post.new(@browser, @parent_css + " .post-list .posts > .post:nth-child(#{i})"))
      }

      results
    end  

    def post_with_title(title)
      posts.find { |p| p.title == title }
    end

    def post_at_index(index)
      Post.new(@browser, @parent_css + " .post-list .posts > .post:nth-child(#{index+1})")
    end 
  end
  
  class Post
    def initialize(browser, parent_css)
      @browser = browser
      @parent_css = parent_css
    end
    
    def title
      title_link.when_present.text
    end

    def title_link
      @browser.link(:css => @parent_css + " .media-body .media-heading a")
    end 

    def featured?
      @browser.element(:css => @parent_css + " .details .featured").present?
    end  

    def views_count
      @browser.element(:css => @parent_css + " .details .stats .view-count").when_present.text
    end  

    def replies_count
      @browser.element(:css => @parent_css + " .details .stats .reply-count").when_present.text
    end  

    def likes_count
      @browser.element(:css => @parent_css + " .details .stats [class*=like]").when_present.text
    end  

    def open
      @browser.wait_until { title_link.present? }
      @browser.execute_script('arguments[0].scrollIntoView();', title_link)
      @browser.execute_script("window.scrollBy(0,-200)")
      title_link.when_present.click
    end 
  end 

  class CommonTopicNavigator
    def initialize(browser)
      @browser = browser
      @parent_css = ".topic-filter-set"
    end

    def parent
      @browser.div(:css => @parent_css)
    end 
    
    def selected_parent
      @browser.div(:css => @parent_css + " .topic-filter-selected")
    end  

    def overview_link
      parent.element(:text => "Overview")
    end  

    def questions_link
      parent.element(:text => "Questions")
    end 

    def blogs_link
      parent.element(:text => "Blogs")
    end

    def reviews_link
      parent.element(:text => "Reviews")
    end

    def selected_overview_link
      selected_parent.element(:text => "Overview")
    end  

    def selected_questions_link
      selected_parent.element(:text => "Questions")
    end 

    def selected_blogs_link
      selected_parent.element(:text => "Blogs")
    end

    def selected_reviews_link
      selected_parent.element(:text => "Reviews")
    end
  end 
end