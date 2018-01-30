require File.expand_path(File.dirname(__FILE__) + "/page_object.rb")

class CommunityTopicDetailPage < PageObject

  attr_accessor :topicpage_url, 
  :topic_q_icon, 
  :topic_best_answer_q_icon, 
  :topic_d_icon, 
  :topic_b_icon, 
  :topic_r_icon, 
  :topic_featuredb_post_title, 
  :topic_featuredd_post_title, 
  :topic_featuredq_post_title,
  :topic_recentb_post_title, 
  :topic_recentd_post_title, 
  :topic_recentq_post_title, 
  :topic_post_timestamp, 
  :topic_post_author, 
  :topic_q_icon, 
  :topic_best_answer_q_icon, 
  :topic_b_icon, 
  :topic_d_icon, 
  :topic_post, 
  :topic_top_contributor_widget, 
  :topic_signin_widget, 
  :topic_signin_widget_title, 
  :topic_follow_button, 
  :topic_edit_button, 
  :topic_deactivate_button, 
  :topic_feature_button, 
  :topic_unfeature_button, 
  :topic_filter, 
  :topic_support, 
  :topic_engagement, 
  :support_topicname,
  :topic_page, 
  :topic_banner, 
  :topic_title, 
  :engagement_topicname, 
  :support_topicname, 
  :topic_search, 
  :topic_sort_post_by_oldest, 
  :topic_overview_selected, 
  :topic_new_q_button, 
  :topic_new_d_button, 
  :topic_new_b_button,
  :topic_new_r_button, 
  :topic_create_new_button, 
  :topic_post_like_icon, 
  :topic_post_reply_icon, 
  :topic_top_contributor_widget, 
  :topic_featured_topic_widget, 
  :topic_popular_disc_widget, 
  :topic_popular_answer_widget, 
  :topic_featured_post_widget, 
  :topic_open_q_widget, 
  :topic_signin_widget_title, 
  :topic_feature_button,
  :topic_unfeature_button, 
  :topic_activate_button, 
  :topic_deactivate_button, 
  :conv_support_topic_breadcrumb, 
  :conv_engagement_topic_breadcrumb, 
  :topic_sort_post_by_oldest, 
  :topic_sort_post_by_newest, 
  :topic_featuredq,
  :topic_featuredd, 
  :topic_featuredb, 
  :topic_recentq, 
  :topic_recentd, 
  :topic_recentb, 
  :topic_post_comment_icon, 
  :topic_unfollow_button, 
  :topic_featured_topic_widget_title, 
  :topic_featured_topic_widget_topic_link,
  :topic_featured_topic_widget_img, 
  :topic_popular_disc_widget_author_img, 
  :topic_popular_disc_widget_like_icon, 
  :topic_popular_disc_widget_author_name, 
  :topic_popular_disc_widget_title, 
  :topic_popular_answer_widget_title, 
  :topic_featured_post_widget_title, 
  :topic_open_q_widget_title, 
  :no_topic_post, 
  :topic_page_desc, 
  :topicname, 
  :topic_feature, 
  :topic_unfeature, 
  :topic_grid, 
  :topiclink, 
  :topicfilter, 
  :topic_publish_change_button, 
  :topic_admin_button, 
  :new_review_button, 
  :topic_create_new_button, 
  :sort_newest_option_dropdown,
  :topic_featured_topic_widget_no_img, 
  :sort_oldest_option_dropdown, 
  :topic_post_link, 
  :topic_page_top_row,
  :topic_sort_by_oldest_link, 
  :topic_sort_by_newest_link, 
  :topic_post_desc, 
  :topic_featured_q_icon, 
  :topic_featured_b_icon,
  :topic_featured_d_icon, 
  :topic_featured_r_icon, 
  :topic_featured_best_answer_q_icon, 
  :topic_recent_q_icon, 
  :topic_recent_d_icon, 
  :topic_recent_b_icon, 
  :topic_recent_best_answer_q_icon, 
  :topic_b_icon_in_b_filter, 
  :topic_sort_post_by_oldest_new, 
  :topic_sort_post_by_newest_new, 
  :topic_link, :follow_disc_element, 
  :unfollow_disc_element,
  :like_disc_element, 
  :unlike_disc_element, 
  :likeunlike_disc_element,  
  :topicdetail,
  :first_topic_link,
  :topic_detail_create_new_button,
  :topic_sort_button,
  :topic_mainpage_link,
  :new_topic_title,
  :new_topic_description,
  :engagement_topic_type_selection_box,
  :engagement_topic_type_selected,
  :advertise_check,
  :topic_page_divid


  def initialize(browser)
    super
    @topicpage_url = $base_url +"/n/#{$networkslug}"
    @support_topicname = "A Watir Topic With Many Posts"
    @engagement_topicname = "A Watir Topic"
    @engagement2_topicname = "A Watir Topic For Widgets"
    @topic_support = @browser.link(:text => "A Watir Topic With Many Posts")
    @topic_engagement = @browser.link(:text => "A Watir Topic")
    @topic_engagement2 = @browser.link(:text => "A Watir Topic For Widgets")

    @topic_engagement_text = @browser.link(:class => "ember-view").h4(:text => @engagement_topicname)
    @topic_support_text = @browser.link(:class => "ember-view").h4(:text => @support_topicname)

    #@topic_link = @browser.link(:href => "/admin/#{$networkslug}/topics")
    @first_topic_link = @browser.div(:class => "topic").div(:class => "topic-avatar") 

    @topic_page = @browser.div(:id => "topics").div(:class => "col-sm-12 col-lg-4 col-md-4").div(:class => "topic").link(:class => "ember-view").div(:class => "topic-avatar")
    @topic_page_desc = @browser.div(:class => "topic-tile-body").link(:class => "body-paragraph ember-view").p
    @topic_avatar = @browser.div(:class => "topic-avatar")
    #@topic_link = @browser.link(:class => "ember-view")
    @topic_page_topic_link = @browser.link(:class => "ember-view", :text => $topic_name)
    @topic_page_no_topic = @browser.div(:class => "topics")
    @topic_sort_button = @browser.button(:class => "btn btn-default dropdown-toggle filter-dropdown sap-regular-dropdown", :text => "Sort by: Newest")

    @topic_breadcrumb = @browser.div(:class => "breadcrumbs dark-bg col-lg-5 col-md-5")
    @topic_network_breadcrumb = @browser.div(:class => "breadcrumbs dark-bg col-lg-5 col-md-5").link(:class => "ember-view", :text => "#{$network}")
    @topic_topic_breadcrumb = @browser.div(:class => "breadcrumbs dark-bg col-lg-5 col-md-5").link(:class => "ember-view", :text => "Topics")

    @conv_engagement_topic_breadcrumb = @browser.div(:class => "breadcrumbs col-lg-6 col-md-6").link(:class => "ember-view", :text => @engagement_topicname)
    @conv_support_topic_breadcrumb = @browser.div(:class => "breadcrumbs col-lg-6 col-md-6").link(:class => "ember-view", :text => @support_topicname)
    @conv_engagement2_topic_breadcrumb = @browser.div(:class => "breadcrumbs col-lg-6 col-md-6").link(:class => "ember-view", :text => @engagement2_topicname)

    @topic_title = @browser.div(:class => "row title").div(:class => "col-md-12")
    @topic_banner = @browser.div(:class => "normal  widget banner topic")
    @topic_filter = @browser.div(:class => "topic-filters")
    @topic_overview_selected = @browser.link(:class => "overview disabled", :text => "Overview")
    @topic_overview = @browser.link(:class => "overview ", :text => "Overview")

    @topic_post = @browser.div(:class => "post-collection").div(:class => "media-heading") 
    @topic_post_desc = @browser.div(:class => "post-collection").div(:class => "ember-view")
    @topic_post_feature = @browser.div(:class => "post media feature")
    @no_topic_post = @browser.div(:class => "post-collection").h4(:class => "empty-container-text")
    @topic_post_link = @browser.div(:class => "post-collection").div(:class => "media-heading").link
    
    @topic_post_author = @browser.div(:class => "ember-view creation-info clearfix").span(:class => "creator").span(:class => "ember-view network-profile-link")
    @topic_post_timestamp = @browser.div(:class => "ember-view creation-info clearfix").span(:class => "created-at")

    @topic_question_filter = @browser.link(:class => "ques ", :text => "Questions")
    @topic_discussion_filter = @browser.link(:class => "disc ", :text => "Discussions")
    @topic_blog_filter = @browser.link(:class => "blog ", :text => "Blogs")
    @topic_review_filter = @browser.link(:class => "blog ", :text => "Reviews")

    @new_review_button = @browser.div(:class => "topic-follow-button").button(:class => "btn btn-primary", :text => "New Review")

    @topic_create_new_button = @browser.div(:class => "topic-follow-button").button(:class => "btn btn-primary", :text => "Create New")
   
    @topic_post_show_more = @browser.div(:class => "show-more-topics col-md-1 ").link(:class => " btn btn-default   ", :text => "Show more")
    #@topic_post_like = @browser.div(:class => "row meta-row").div(:class => "col-lg-offset-2 col-lg-3").span(:class => "jam-icon-like grey-icon crumb-icon")
    #@topic_post_reply = @browser.div(:class => "row meta-row").div(:class => "col-lg-offset-2 col-lg-3").span(:class => "icon-comment grey-icon crumb-icon")

    @topic_search = @browser.div(:class => "search-form search-bar col-md-8 col-sm-12 col-xs-12 col-lg-offset-2 col-md-offset-2").text_field(:class => "ember-view ember-text-field typeahead form-control tt-input")

    @topic_recentq = @browser.div(:class => "topic-overview", :text => /Most Recent Questions/)
    @topic_recentb = @browser.div(:class => "topic-overview", :text => /Most Recent Blogs/)
    @topic_recentd = @browser.div(:class => "topic-overview", :text => /Most Recent Discussions/)
    
    @topic_recentb_post = @browser.div(:class => "topic-overview", :text => /Most Recent Blogs/).div(:class => "ember-view post").div(:class => "media")
    @topic_recentd_post = @browser.div(:class => "topic-overview", :text => /Most Recent Discussions/).div(:class => "ember-view post").div(:class => "media")
    @topic_recentq_post = @browser.div(:class => "topic-overview", :text => /Most Recent Questions/).div(:class => "ember-view post").div(:class => "media")
    
    @topic_recentb_post_title = @browser.div(:class => "topic-overview", :text => /Most Recent Blogs/).div(:class => "media-body").div(:class => "media-heading")
    @topic_recentd_post_title = @browser.div(:class => "topic-overview", :text => /Most Recent Discussions/).div(:class => "media-body").div(:class => "media-heading")
    @topic_recentq_post_title = @browser.div(:class => "topic-overview", :text => /Most Recent Questions/).div(:class => "media-body").div(:class => "media-heading")
    
    @topic_recentb_post_author = @browser.div(:class => "topic-overview", :text => /Most Recent Blogs/).span(:class => "creator")
    @topic_recentd_post_author = @browser.div(:class => "topic-overview", :text => /Most Recent Discussions/).span(:class => "creator")
    @topic_recentq_post_author = @browser.div(:class => "topic-overview", :text => /Most Recent Questions/).span(:class => "creator")
    
    @topic_recent_q_icon = @browser.div(:class => "topic-overview", :text => /Most Recent Questions/).div(:class => "media-body").div(:index => 7)
    @topic_recent_best_answer_q_icon = @browser.div(:class => "topic-overview", :text => /Most Recent Questions/).div(:class => "media-body").div(:index => 7) #:text => "Question (Answered)")
    @topic_recent_d_icon = @browser.div(:class => "topic-overview", :text => /Most Recent Discussions/).div(:class => "media-body").span(:class => "ember-view post-type discussion")  
    @topic_recent_b_icon = @browser.div(:class => "topic-overview", :text => /Most Recent Blogs/).div(:class => "media-body").span(:class => "ember-view post-type blog") 
    @topic_recent_r_icon = @browser.div(:class => "topic-overview", :text => /Most Recent Reviews/).div(:class => "media-body").span(:class => "ember-view post-type review") 

    @topic_featured_q_icon = @browser.div(:class => "topic-overview", :text => /Featured Questions/).div(:class => "media-body").span(:class => "ember-view post-type question")
    @topic_featured_best_answer_q_icon = @browser.div(:class => "topic-overview", :text => /Featured Questions/).div(:class => "media-body").span(:class => "ember-view post-type question answered") #:text => "Question (Answered)")
    @topic_featured_d_icon = @browser.div(:class => "topic-overview", :text => /Featured Discussions/).div(:class => "media-body").span(:class => "ember-view post-type discussion") 
    @topic_featured_b_icon = @browser.div(:class => "topic-overview", :text => /Featured Blogs/).div(:class => "media-body").span(:class => "ember-view post-type blog")
    @topic_featured_r_icon = @browser.div(:class => "topic-overview", :text => /Featured Reviews/).div(:class => "media-body").span(:class => "ember-view post-type review")

    @topic_q_icon = @browser.div(:class => "media-body").span(:class => "ember-view post-type question")
    @topic_best_answer_q_icon = @browser.div(:class => "media-body").span(:class => "ember-view post-type question answered") #:text => "Question (Answered)")
    @topic_d_icon = @browser.div(:class => "media-body").span(:class => "ember-view post-type discussion")  
    @topic_b_icon = @browser.div(:class => "media-body").span(:class => "ember-view post-type blog") 
    @topic_r_icon = @browser.div(:class => "media-body").span(:class => "ember-view post-type review") 

    @topic_b_icon_in_b_filter = @browser.span(:class => "crumb-icon icon-notes")

    @topic_new_q_button = @browser.div(:class => "topic-follow-button").button(:class => "btn btn-primary", :text => "New Question")
    @topic_new_d_button = @browser.div(:class => "topic-follow-button").button(:class => "btn btn-primary", :text => "New Discussion")
    @topic_new_b_button = @browser.div(:class => "topic-follow-button").button(:class => "btn btn-primary", :text => "New Blog")
    @topic_new_r_button = @browser.div(:class => "topic-follow-button").button(:class => "btn btn-primary", :text => "New Review")
    
    @topic_post_like_icon = @browser.div(:class => "stats ember-view").span(:class => "likes-count")
    @topic_post_comment_icon = @browser.div(:class => "stats ember-view").span(:class => "reply-count")
    @topic_post_feature_icon = @browser.div(:class => "details").span(:class => "featured")
    
    @topic_featuredq = @browser.div(:class => "topic-overview", :text => /Featured Questions/)
    @topic_featuredb = @browser.div(:class => "topic-overview", :text => /Featured Blogs/)
    @topic_featuredd = @browser.div(:class => "topic-overview", :text => /Featured Discussions/)

    @topic_featuredb_post = @browser.div(:class => "topic-overview", :text => /Featured Blogs/).div(:class => "ember-view post").div(:class => "media")
    @topic_featuredd_post = @browser.div(:class => "topic-overview", :text => /Featured Discussions/).div(:class => "ember-view post").div(:class => "media")
    @topic_featuredq_post = @browser.div(:class => "topic-overview", :text => /Featured Questions/).div(:class => "ember-view post").div(:class => "media")

    @topic_featuredb_post_title = @browser.div(:class => "topic-overview", :text => /Featured Blogs/).div(:class => "media-body").div(:class => "media-heading")
    @topic_featuredd_post_title = @browser.div(:class => "topic-overview", :text => /Featured Discussions/).div(:class => "media-body").div(:class => "media-heading")
    @topic_featuredq_post_title = @browser.div(:class => "topic-overview", :text => /Featured Questions/).div(:class => "media-body").div(:class => "media-heading")

    @topic_featuredb_post_author = @browser.div(:class => "topic-overview", :text => /Featured Blogs/).span(:class => "creator")
    @topic_featuredd_post_author = @browser.div(:class => "topic-overview", :text => /Featured Discussions/).span(:class => "creator")
    @topic_featuredq_post_author = @browser.div(:class => "topic-overview", :text => /Featured Questions/).span(:class => "creator") 
    
    @topic_featuredb_post_feature_icon = @browser.div(:class => "topic-overview", :text => /Featured Blogs/).span(:text => "Featured")
    @topic_featuredd_post_feature_icon = @browser.div(:class => "topic-overview", :text => /Featured Discussions/).span(:text => "Featured")
    @topic_featuredq_post_feature_icon = @browser.div(:class => "topic-overview", :text => /Featured Questions/).span(:text => "Featured")

    @topic_signin_widget = @browser.div(:class => "widget sign-in")
    @topic_signin_widget_title = @browser.div(:class => "widget sign-in", :text => /Join the Conversation/)
    @topic_signin_widget_signin = @browser.div(:class => "widget sign-in").div(:class => "actions").link(:class => "btn btn-default ember-view btn btn-default", :text => "Sign in")
    @topic_signin_widget_register = @browser.div(:class => "widget sign-in").div(:class => "actions").link(:class => "ember-view", :text => "or Register")

    @topic_top_contributor_widget = @browser.div(:class => "widget top_contributors")
    @topic_top_contributor_widget_title = @browser.div(:class => "widget top_contributors", :text => "Top Contributors")
    @topic_top_contributors_widget_add_disc_link = @browser.div(:class => "widget top_contributors").div(:class => "col-md-12").link(:class => "ember-view", :text => "Add a New Discussion")
    @topic_top_contributors_widget_add_disc_icon = @browser.div(:class => "widget top_contributors").div(:class => "col-md-12").span(:class => "icon-discussion grey-icon")
    @topic_top_contributors_widget_add_q_link = @browser.div(:class => "widget top_contributors").div(:class => "col-md-12").link(:class => "ember-view", :text => "Ask a New Question")
    @topic_top_contributors_widget_add_q_icon = @browser.div(:class => "widget top_contributors").div(:class => "col-md-12").span(:class => "icon-sys-help-2 grey-icon")
    @topic_top_contributors_widget_username = @browser.div(:class => "widget top_contributors").span(:class => "ember-view network-profile-link")
    @topic_top_contributor_widget_user_img = @browser.div(:class => "widget top_contributors").div(:class => "media-body").div(:class => "media-heading").img(:class => "media-object thumb-32")
    @topic_top_contributor_li = @browser.div(:class => "widget top_contributors").ul(:class => "media-list")

    @topic_featured_topic_widget = @browser.div(:class => "widget featured_topics")
    @topic_featured_topic_widget_title = @browser.div(:class => "widget featured_topics", :text => /Topics/)
    @topic_featured_topic_widget_topic_link = @browser.div(:class => "widget featured_topics").div(:class => "media-left").div(:class => "media-body").link(:class => "ember-view")
    @topic_featured_topic_widget_topic_name = @browser.div(:class => "widget featured_topics").ul.li(:class => "media").div(:class => "media-left").div(:class => "media-body").link(:class => "ember-view active" , :text => $topic_name)
    @topic_featured_topic_widget_meta_info = @browser.div(:class => "widget featured_topics").div(:class => "media-body").link(:class => "ember-view").p(:class => "meta-text")
    @topic_featured_topic_widget_img = @browser.div(:class => "widget featured_topics").div(:class => "media-left").link(:class => "pull-left ember-view").div(:class => "media-object widget-topic-avatar")
    @topic_featured_topic_widget_no_img = @browser.div(:class => "widget featured_topics").div(:class => "media-left").link(:class => "pull-left ember-view").div(:class => "media-object widget-topic-no-avatar")

    @topic_popular_disc_widget = @browser.div(:class => "widget popular_discussions")
    @topic_popular_disc_widget_title = @browser.div(:class => "widget popular_discussions", :text => /Popular Discussions/)
    @topic_popular_disc_widget_conv_link = @browser.div(:class => "widget popular_discussions").div(:class => "conversation-type").div(:class => "text").link(:class => "ember-view")
    @topic_popular_disc_widget_author_name = @browser.div(:class => "widget popular_discussions").div(:class => "conversation-type").div(:class => "author").span(:class => "ember-view network-profile-link")
    @topic_popular_disc_widget_like_icon = @browser.div(:class => "widget popular_discussions").div(:class => "conversation-type").div(:class => "author").span(:class => "jam-icon-like grey-icon crumb-icon widget-like")
    @topic_popular_disc_widget_author_img = @browser.div(:class => "widget popular_discussions").div(:class => "conversation-type").div(:class => "author").img(:class => "media-object thumb-24")

    @topic_popular_answer_widget = @browser.div(:class => "widget popular_answers")
    @topic_popular_answer_widget_title = @browser.div(:class => "widget popular_answers", :text => /Popular Answers/)
    @topic_popular_answer_widget_conv_link = @browser.div(:class => "widget popular_answers").div(:class => "conversation-type").div(:class => "text").link(:class => "ember-view")
    @topic_popular_answer_widget_author_name = @browser.div(:class => "widget popular_answers").div(:class => "conversation-type").div(:class => "author").span(:class => "ember-view network-profile-link")
    @topic_popular_answer_widget_like_icon = @browser.div(:class => "widget popular_answers").div(:class => "conversation-type").div(:class => "author").span(:class => "jam-icon-like grey-icon crumb-icon widget-like")
    @topic_popular_answer_widget_author_img = @browser.div(:class => "widget popular_answers").div(:class => "conversation-type").div(:class => "author").img(:class => "media-object thumb-24")

    @topic_featured_post_widget = @browser.div(:class => "widget featured_posts")
    @topic_featured_post_widget_title = @browser.div(:class => "widget featured_posts", :text => /Featured Posts/)
    @topic_featured_post_widget_conv_link = @browser.div(:class => "widget featured_posts").ul(:class => "media-list").li(:class => "media").div(:class => "conversation-type").div(:class => "text").link(:class => "ember-view")
    @topic_featured_post_widget_author_name = @browser.div(:class => "widget featured_posts").div(:class => "conversation-type").div(:class => "author").span(:class => "ember-view network-profile-link")
    @topic_featured_post_widget_author_img = @browser.div(:class => "widget featured_posts").div(:class => "conversation-type").div(:class => "author").img(:class => "media-object thumb-24")

    @topic_open_q_widget = @browser.div(:class => "widget open_questions")
    @topic_open_q_widget_title = @browser.div(:class => "widget open_questions", :text => /Open Questions/)
    @topic_open_q_widget_conv_link = @browser.div(:class => "widget open_questions").div(:class => "conversation-type").div(:class => "text").link(:class => "ember-view")
    @topic_open_q_widget_author_name = @browser.div(:class => "widget open_questions").div(:class => "conversation-type").div(:class => "author").span(:class => "ember-view network-profile-link")
    @topic_open_q_widget_author_img = @browser.div(:class => "widget open_questions").div(:class => "conversation-type").div(:class => "author").img(:class => "media-object thumb-24")

    
    @topic_edit_screen = @browser.div(:class => "row topic-create-title", :text => /Edit Topic/)
    @topic_edit_desc = @browser.text_field(:id => "topic-caption-input")
    @topic_edit_tile_browse = @browser.link(:class => "edit-button", :text => "browse")
    @topic_edit_tile_modal = @browser.div(:id => "tile-upload-modal")
    @topic_edit_file_field = @browser.form(:class => "ember-view").file_field(:class => "ember-view ember-text-field files")
    @topic_edit_tile_cropper = @browser.div(:class => "cropper-canvas")
    @topic_edit_tile_img_select = @browser.button(:class => "ember-view btn btn-primary btn-sm", :text=> /Select Image/)
    @topic_edit_file_img_selected = @browser.img(:class => "topic-tile-selected-image")
    @topic_type_radio = @browser.div(:class => "col-md-6 col-sm-12").div(:class => "radio")
    @topic_edit_next = @browser.button(:class => "btn btn-primary", :text => /Next: Design/)
    @topic_edit_view_topic = @browser.button(:class => "btn btn-primary pull-right", :text => "Next: View Topic")

    @topic_deactivate_button = @browser.link(:class => "btn btn-default btn-sm admin-dark-btn", :text => "Deactivate Topic")
    @topic_deactivate_modal = @browser.div(:class => "modal-content") #.div(:class => "modal-header", :text => /Deactivate Topic/)
    @topic_deactivate_modal1 = @browser.div(:id => "topic-deactivate-confirm")
    @topic_deactivate_confirm = @browser.button(:value => "Confirm")

    @topic_activate_button = @browser.button(:class => "btn btn-default btn-sm admin-dark-btn", :value => "Activate Topic")

    @topic_feature_button = @browser.button(:class => "btn btn-default btn-sm admin-dark-btn topic-admin-buttons", :text => "Feature Topic")
    @topic_unfeature_button = @browser.button(:class => "btn btn-default btn-sm admin-dark-btn topic-admin-buttons", :text => "Unfeature Topic")

    @tc_PD1_disc_link = @browser.link(:text => "::PD1:: Discussion1 posted to test popular discussion widget?")
    @like_disc_element = @browser.link(:class => "like", :text => "Like")
    @unlike_disc_element = @browser.link(:class => "like", :text => "Unlike")
    @likeunlike_disc_element = @browser.link(:class => "like", :text => /Like|Unlike/)
    @follow_disc_element = @browser.link(:class => "follow", :text => "Follow")
    @unfollow_disc_element = @browser.link(:class => "follow", :text => "Unfollow")
    
    @topic_link = @browser.link(:text => /Topics/)
    @topic_mainpage_link = @browser.div(:id => "topics")
    #@topic_feature_button = @browser.button(:class => "btn btn-default btn-sm admin-dark-btn", :text => "Feature Topic")
    #@topic_unfeature_button = @browser.button(:class => "btn btn-default btn-sm admin-dark-btn", :text => "Unfeature Topic")
    @topic_featured_filter = @browser.button(:class => "btn btn-default", :text => "Featured")
    @topic_all_filter = @browser.button(:class => "btn btn-default", :text => "All")
    #@topicname_support = @browser.h4(:text => "A Watir Topic With Many Posts")
    #@topicname_engagement = @browser.h4(:text => "A Watir Topic")
    #@topicname_widgettopic = @browser.h4(:text => "A Watir Topic For Widgets")
    @topic_sidezone_widget = @browser.div(:class => "widget-container zone side col-lg-4 col-md-5")
   
    @new_topic_title = @browser.text_field(:id => "new-topic-title")
    @new_topic_description = @browser.text_field(:id => "topic-caption-input")
    @engagement_topic_type_selection_box = @browser.div(:class => "topic-type-selection-box engagement", :text => /Engagement/)
    @engagement_topic_type_selected = @browser.div(:class => "topic-type-selection-box engagement chosen", :text => /Engagement/)
    @support_topic_type_selection_box = @browser.div(:class => "topic-type-selection-box support", :text => /Q&A/)
    @support_topic_type_selected =  @browser.div(:class => "topic-type-selection-box support chosen", :text => /Q&A/)
    @advertise_check = @browser.div(:text => /Enable advertising/).input(:class => "ember-view ember-checkbox")
    @topic_filter = @browser.div(:class => "topic-filters")
    @question_icon = @browser.div(:class => "question icon-sys-help-2")

    @topic_follow_button = @browser.div(:class => "topic-follow-button").button(:class => "btn btn-default", :text => "Follow Topic")
    @topic_unfollow_button = @browser.div(:class => "topic-follow-button").button(:class => "btn btn-default", :text => "Unfollow Topic")

    @topic_sort_post_by_oldest = @browser.div(:class => "pull-right btn filter-dropdown ").span(:text => /Oldest/)
    @topic_sort_post_by_newest = @browser.div(:class => "pull-right btn filter-dropdown ").span(:text => /Newest/)

    @topic_sort_post_by_oldest_new = @browser.div(:class => "pull-right sort-by dropdown").span(:text => /Oldest/)
    @topic_sort_post_by_newest_new = @browser.div(:class => "pull-right sort-by dropdown").span(:text => /Newest/)

    @sort_newest_option_dropdown = @browser.div(:class => "pull-right sort-by dropdown open").link(:index => 0)
    @sort_oldest_option_dropdown = @browser.div(:class => "pull-right sort-by dropdown open").ul(:class => "dropdown-menu").li.link(:text => "Oldest")
    #@topic_sort_post_by_oldest = @browser.div(:class => "pull-right sort-by dropdown").span(:text => /Oldest/)
    #@topic_sort_post_by_newest = @browser.div(:class => "pull-right sort-by dropdown").span(:text => /Newest/)

    #@sort_newest_option_dropdown = @browser.div(:class => "pull-right sort-by dropdown open").link(:index => 0)
    #@sort_oldest_option_dropdown = @browser.div(:class => "pull-right sort-by dropdown open").ul(:class => "dropdown-menu").li.link(:text => "Oldest")

    #@topic_sort_by_oldest_link = @browser.div(:class => "pull-right btn filter-dropdown ").span(:text => /Oldest/)
    #@topic_sort_by_newest_link = @browser.div(:class => "pull-right btn filter-dropdown ").span(:text => /Newest/)

    @topicdetail = @browser.div(:class => "topic-filters")
    @topicname = @browser.div(:class => "row title")

    @topic_edit_button = @browser.button(:class => "btn btn-default btn-sm admin-dark-btn", :text => "Edit Topic")
    @topic_feature = @browser.div(:class => "btn-group").button(:class => "btn btn-default btn-sm admin-dark-btn topic-admin-buttons", :text => "Feature Topic")
    @topic_unfeature = @browser.div(:class => "btn-group").button(:class => "btn btn-default btn-sm admin-dark-btn topic-admin-buttons", :text => "Unfeature Topic")
    @topic_link = @browser.link(:class => "ember-view")
    @topic_detail_create_new_button = @browser.div(:class => "topic-follow-button").button(:class => "btn btn-primary", :text => "Create New")

    @support_topicname = "A Watir Topic With Many Posts"
    @engagement_topicname = "A Watir Topic"
    @engagement2_topicname = "A Watir Topic For Widgets"
    @topic_support = @browser.link(:text => "A Watir Topic With Many Posts")
    @topic_engagement = @browser.link(:text => "A Watir Topic")
    @topic_engagement2 = @browser.link(:text => "A Watir Topic For Widgets")
    @topic_grid = @browser.div(:class => "topics-grid row")
    @topiclink = @browser.link(:text => "Topics")
    @topicfilter = @browser.div(:class => "topic-filters")

    @topic_publish_change_button = @browser.div(:class => "topic-create-wizard").div(:class => "container").div(:class => "row").div(:class => "button-align-right").button(:class => "btn btn-primary btn-sm", :text => "Publish Changes")
    @topic_admin_button = @browser.div(:class => "buttons col-lg-7 col-md-7").div(:class => "btn-toolbar pull-right").div(:class => "btn-group").button(:class => "btn btn-default btn-sm admin-dark-btn topic-admin-buttons")

    @topic_page_top_row = @browser.div(:class => "col-md-12").div(:class => "btn-toolbar").div(:class => "btn-group topic-filter-group")   
    @topic_page_divid = @browser.div(:id => "topics")
  end

  def goto_topic_page
    @browser.goto "#{$base_url}"+"/n/#{$networkslug}"
    @browser.wait_until($t) { @topic_page.present? }
  end

  def topic_and_sort_check
    if !@topic_page_top_row.present?
     goto_topic_page
     policy_warning
    end
    
    @browser.wait_until($t) { @topic_page.present? }
    if !@topic_avatar.h4.text.include?(@engagement_topicname)
      topic_sort_by_name
    end
    @browser.wait_until($t) { @topic_page.present? }
  end

 def goto_topicdetail_page(topictype)
  case topictype
   when "support"
    if ($topic_sup_uuid != nil) 
       @browser.goto "#{$base_url}"+"/topic/"+$topic_sup_uuid+"/#{$networkslug}/"+@support_topicname 
    else  
     if @browser.url != @topicpage_url
      @browser.goto @topicpage_url
      @browser.wait_until($t) { @topic_page.present? }
     end 
      
     if !@browser.text.include? @support_topicname
      topic_sort_by_name
     end 
     @browser.wait_until($t) { @topic_page.present? }
     @browser.execute_script("window.scrollBy(0,2000)")
     @topic_support.when_present.click
     @browser.wait_until {@browser.url.include? "/topic/"}
     topic_url = @browser.url
     $topic_sup_uuid = topic_url.split("/topic/")[1].split("/")[0]
    end

    when "engagement"
     if ($topic_eng_uuid != nil) # && $topic_eng_uuid !=0)
      @browser.goto "#{$base_url}"+"/topic/"+$topic_eng_uuid+"/#{$networkslug}/"+@engagement_topicname    
     else
      if @browser.url != @topicpage_url
       @browser.goto @topicpage_url
       @browser.wait_until($t) { @topic_page.present? }
      end 
      if !@browser.text.include? @engagement_topicname
       topic_sort_by_name
      end
      @browser.wait_until($t) { @topic_page.present? }
      @browser.execute_script("window.scrollBy(0,2000)")
      @topic_engagement.when_present.click
      @browser.wait_until {@browser.url.include? "/topic/"}
      topic_url = @browser.url
      $topic_eng_uuid = topic_url.split("/topic/")[1].split("/")[0]
     end

    when "engagement2"
     if ($topic_eng2_uuid != nil)# && $topic_eng2_uuid !=0)
       @browser.goto "#{$base_url}"+"/topic/"+$topic_eng2_uuid+"/#{$networkslug}/"+@engagement2_topicname
     else
      if @browser.url != @topicpage_url
       @browser.goto @topicpage_url
       @browser.wait_until($t) { @topic_page.present? }
      end 
      if !@browser.text.include? @engagement2_topicname
       topic_sort_by_name
      end
      @browser.wait_until($t) { @topic_page.present? }
      @browser.execute_script("window.scrollBy(0,2000)")
      @topic_engagement2.when_present.click
      @browser.wait_until {@browser.url.include? "/topic/"}
      topic_url = @browser.url
      $topic_eng2_uuid = topic_url.split("/topic/")[1].split("/")[0]
     end
      else
       raise "Invalid topic type! Exit.."
     end 
   
    @browser.wait_until($t) { @topic_filter.present? }
    topic_publish
  end

  def check_topnav(user)
    @loginpage = CommunityLoginPage.new(@browser)
    if @loginpage.username.present?
     signout
    end
    if user == "logged"
     about_login("regis2", "logged")
     @loginpage = CommunityLoginPage.new(@browser) 
     @browser.wait_until($t) { @loginpage.topnav_notification.present? }
    else
     @profilepage = CommunityProfilePage.new(@browser) 
     @browser.wait_until($t) { @profilepage.topnav_home.present? }
     @browser.wait_until($t) { @profilepage.topnav_topic.present? }
     @browser.wait_until($t) { @profilepage.topnav_product.present? }
     @browser.wait_until($t) { @profilepage.topnav_about.present? }
     @loginpage = CommunityLoginPage.new(@browser)
     @browser.wait_until($t) { @loginpage.topnav_signin.present? }
     @profilepage = CommunityProfilePage.new(@browser)
     @browser.wait_until($t) { @profilepage.topnav_search.present? }
     @browser.wait_until($t) { @profilepage.topnav_logo.present? } 
   end
  end

  def check_topicdetail_banner
    @browser.wait_until($t) { @topic_banner.present? }
  end

  def check_topicdetail_breadcrumb
    @browser.wait_until($t) { @topic_breadcrumb.present? }
  end

  def check_topicdetail_network_breadcrumb_link
    @browser.wait_until($t) { @topic_breadcrumb.present? }
    @topic_network_breadcrumb.click
    @homepage = CommunityHomePage.new(@browser)
    @browser.wait_until($t) { @homepage.home.present? }
  end

  def check_topicdetail_topic_breadcrumb_link
    @browser.wait_until($t) { @topic_breadcrumb.present? }
    @topic_topic_breadcrumb.click
    @browser.wait_until($t) { @topic_page.present? }
  end

  def check_topic_title(topictype)
    goto_topicdetail_page(topictype)
    @browser.wait_until($t) { @topic_title.present? }
    $topictitle = @topic_title.text
  end

  def check_topicdetail_filter
    @browser.wait_until($t) { @topic_filter.present? }
  end

  def check_topicdetail_create_new_button
    @browser.wait_until($t) { @topic_create_new_button.present? }
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
    @browser.wait_until{ @conv_reply_input.present? || @reply_box.present? }
    if @topic_sort_post_by_oldest.present? || @topic_sort_post_by_oldest_new.present?
      sort_post_by_newest
      @browser.wait_until{ @conv_reply_input.present? }
    end
    @reply_box.when_present.focus
    @browser.wait_until($t) { @reply_submit.present? }
    assert @reply_submit.present?

    if posttype == "discussion"
     @reply_box.when_present.set comment_text
    end
    if posttype == "question"
     @reply_box.when_present.set answer_text
    end
    if posttype == "blog"
     @reply_box.when_present.set blog_comment_text
    end
    if posttype == "review"
     @reply_box.when_present.set review_comment_text
    end
    @reply_submit_button.when_present.click
    @browser.wait_until($t) { !@reply_submit_button.present? }
    @browser.wait_until($t) { @conv_reply_input.present? }
    @browser.wait_until($t) { @post_body.present? }
   
    
    if posttype == "discussion"
     @browser.wait_until($t) { @conv_reply.present? }
     @browser.wait_until($t) { @conv_reply.p.text =~  /#{comment_text}/ }
     assert @conv_reply.p.text =~  /#{comment_text}/
    end 
    if posttype == "question"
     @browser.wait_until($t) { @conv_reply_ans.p.text =~  /#{answer_text}/ }
     assert @conv_reply_ans.p.text =~  /#{answer_text}/
    end 
    if posttype == "blog"
     @browser.wait_until($t) { @conv_reply.p.text =~  /#{blog_comment_text}/ }
     assert @conv_reply.p.text =~  /#{blog_comment_text}/
    end 
    if posttype == "review"
     @browser.wait_until($t) { @conv_reply.p.text =~  /#{review_comment_text}/ }
     assert @conv_reply.p.text =~  /#{review_comment_text}/
    end  
    
  end

  def check_post_conv_anon
    about_login("anon", "visitor")
    policy_warning
    topic_detail("A Watir Topic")
    choose_post_type("question")
    conversation_detail("question")
    
    @reply_box.when_present.focus
    @loginpage = CommunityLoginPage.new(@browser)
    @browser.wait_until($t) { @loginpage.signin_page.present? }
    assert @loginpage.signin_page.present?
 end

 def check_post_like_anon
    about_login("anon", "visitor")
    policy_warning
    topic_detail("A Watir Topic")
    choose_post_type("question")
    conversation_detail("question")
    @like_disc_element.when_present.click
    @loginpage = CommunityLoginPage.new(@browser)
    @browser.wait_until($t) { @loginpage.signin_page.present? }
    assert @loginpage.signin_page.present?
 end

 def check_post_follow_anon
    about_login("anon", "visitor")
    policy_warning
    topic_detail("A Watir Topic")
    choose_post_type("question")
    conversation_detail("question")
    @follow_disc_element.when_present.click
    @loginpage = CommunityLoginPage.new(@browser)
    @browser.wait_until($t) { @loginpage.signin_page.present? }
    assert @loginpage.signin_page.present?
 end

  def check_topicdetail_follow_topic_button
    @browser.wait_until($t) { @topic_follow_button.present? }
  end

  def check_topicdetail_unfollow_topic_button
    @browser.wait_until($t) { @topic_unfollow_button.present? }
  end

  def check_topicdetail_search_bar
    @browser.wait_until($t) { @topic_search.present? }
  end

  def check_topicdetail_search
    searchtext = "Watir Test Question1 ?"
    @topic_search.when_present.set searchtext
    @browser.wait_until($t) { @search_dropdown.attribute_value('style') =~ /display: / }
    @browser.send_keys :enter
    @browser.wait_until($t) { @search_result_page.present? }
  end

  def check_overview_tab_default
    @browser.wait_until($t) { @topic_overview_selected.present? }
    @browser.wait_until($t) { @topic_post.present? }
  end

  def check_post_filter(posttype)
    case posttype
     when "ques"
      @topic_question_filter.when_present.click
      @browser.wait_until($t) { @topic_post_desc.present? }
     when "disc"
      @topic_discussion_filter.when_present.click
      @browser.wait_until($t) { @topic_post_desc.present? }
     when "blog"
      @topic_blog_filter.when_present.click
      @browser.wait_until($t) { @topic_post_desc.present? }
     when "review"
      @topic_review_filter.when_present.click 
      @browser.wait_until($t) { @topic_post_desc.present? || @no_topic_post.present? }
     else
      raise "Invalid post type! Exit.."
     end   
    
  end

  def check_post_filter_button(posttype, user)
    case posttype
     when "ques"
      @topic_question_filter.when_present.click
      @browser.wait_until($t) { @topic_new_q_button.present? }
     when "disc"
      @topic_discussion_filter.when_present.click

      @browser.wait_until($t) { @topic_new_d_button.present? }
     when "blog"
      @topic_blog_filter.when_present.click
      if user == "logged"
        @browser.wait_until($t) { @topic_new_b_button.present? }
     else
      @browser.wait_until($t) { !@topic_new_b_button.present? }
    end
     when "review"
      @topic_review_filter.when_present.click 
      @browser.wait_until($t) { @topic_new_r_button.present? }
     else
      raise "Invalid post type! Exit.."
     end   
  end

  def check_featured_post_present(posttype)
    case posttype
     when "ques"
      @browser.wait_until($t) { @topic_featuredq.present? }
     when "disc"
      @browser.wait_until($t) { @topic_featuredd.present? }
     when "blog"
      @browser.wait_until($t) { @topic_featuredb.present? }
     else
      raise "Invalid post type! Exit.."
     end   
  end

  def check_featured_post_title(posttype)
    case posttype
     when "ques"
      @browser.wait_until($t) { @topic_featuredq_post_title.present? }
     when "disc"
      @browser.wait_until($t) { @topic_featuredd_post_title.present? }
     when "blog"
      @browser.wait_until($t) { @topic_featuredb_post_title.present? }
     else
      raise "Invalid post type! Exit.."
     end   
  end

  def check_featured_post_author_name(posttype)
    case posttype
     when "ques"
      @browser.wait_until($t) { @topic_featuredq_post_author.present? }
     when "disc"
      @browser.wait_until($t) { @topic_featuredd_post_author.present? }
     when "blog"
      @browser.wait_until($t) { @topic_featuredb_post_author.present? }
     else
      raise "Invalid post type! Exit.."
     end   
  end

  def check_featured_post_feature_icon(posttype)
    case posttype
     when "ques"
      @browser.wait_until($t) { @topic_featuredq_post_feature_icon.present? }
     when "disc"
      @browser.wait_until($t) { @topic_featuredd_post_feature_icon.present? }
     when "blog"
      @browser.wait_until($t) { @topic_featuredb_post_feature_icon.present? }
     else
      raise "Invalid post type! Exit.."
     end   
  end

  def check_featured_post_icon(posttype)
    case posttype
     when "ques"
      @browser.wait_until($t) { (@topic_featured_q_icon.present? && @topic_featured_q_icon.text =~ /Question/) || (@topic_featured_best_answer_q_icon.present? && @topic_featured_best_answer_q_icon.text =~ /Question (Answered)/ ) }
     when "disc"
      @browser.wait_until($t) { @topic_featured_d_icon.present? && @topic_featured_d_icon.text =~ /Discussion/}
     when "blog"
      @browser.wait_until($t) { @topic_featured_b_icon.present? && @topic_featured_b_icon.text =~ /Blog/ }
     else
      raise "Invalid post type! Exit.."
     end   
  end


  def check_recent_post_present(posttype)
    case posttype
     when "ques"
      @browser.wait_until($t) { @topic_recentq.present? }
     when "disc"
      @browser.wait_until($t) { @topic_recentd.present? }
     when "blog"
      @browser.wait_until($t) { @topic_recentb.present? }
     else
      raise "Invalid post type! Exit.."
     end   
  end


  def check_recent_post_title(posttype)
    case posttype
     when "ques"
      @browser.wait_until($t) { @topic_recentq_post_title.present? }
     when "disc"
      @browser.wait_until($t) { @topic_recentd_post_title.present? }
     when "blog"
      @browser.wait_until($t) { @topic_recentb_post_title.present? }
     else
      raise "Invalid post type! Exit.."
     end   
  end

  def check_recent_post_author_name(posttype)
    case posttype
     when "ques"
      @browser.wait_until($t) { @topic_recentq_post_author.present? }
     when "disc"
      @browser.wait_until($t) { @topic_recentd_post_author.present? }
     when "blog"
      @browser.wait_until($t) { @topic_recentb_post_author.present? }
     else
      raise "Invalid post type! Exit.."
     end   
  end

  def check_recent_post_icon(posttype)
    case posttype
     when "ques"
      @browser.wait_until($t) { @topic_recent_q_icon.present? ||  @topic_recent_best_answer_q_icon }
     when "disc"
      @browser.wait_until($t) { @topic_recent_d_icon.present? }
     when "blog"
      @browser.wait_until($t) { @topic_recent_b_icon.present? }
     else
      raise "Invalid post type! Exit.."
     end   
  end

  def check_sort_link
    @browser.wait_until($t) { @topic_sort_post_by_newest.present?  || @topic_sort_by_newest_link.present? }
  end

  def sort_post_by_newest
    if @topic_sort_post_by_oldest.present? || @topic_sort_post_by_oldest_new.present?
    @browser.wait_until($t) { @topic_sort_post_by_oldest.present? || @topic_sort_post_by_oldest_new.present? }
    if @topic_sort_post_by_oldest.present?
     @topic_sort_post_by_oldest.click
    else
     @topic_sort_post_by_oldest_new.click
     @browser.wait_until($t) { @sort_newest_option_dropdown.present? }
     @sort_newest_option_dropdown.click
    end
    @browser.wait_until($t) { @post_body.present? }
    end
    @browser.wait_until($t) { @topic_sort_post_by_newest.present? || @topic_sort_post_by_newest_new.present? }
    #@topic_post_timestamp.text.include? "/hour/|/hours/|/day/|/days/"
  end

  def sort_post_by_oldest
    if @topic_sort_post_by_newest.present? || @topic_sort_post_by_newest_new.present?
    @browser.wait_until($t) { @topic_sort_post_by_newest.present? || @topic_sort_post_by_newest_new.present?}
    if @topic_sort_post_by_newest.present?
     @topic_sort_post_by_newest.click
    else
     @topic_sort_post_by_newest_new.click
     @browser.wait_until($t) { @sort_oldest_option_dropdown.present? }
     @sort_oldest_option_dropdown.click
    end
    @browser.wait_until($t) { @topic_post.present? }
    end
    @browser.wait_until($t) { @topic_sort_post_by_oldest.present? || @topic_sort_post_by_oldest_new.present? }
    #@topic_post_timestamp.text.include? "/hour/|/hours/|/day/|/days/"
  end

  def check_post_link
    policy_warning
    @browser.wait_until($t) { @topic_post_link.present? }
    @topic_post_link.when_present.click
    @browser.wait_until($t) { @conv_detail.present? }   
  end

  def check_post_title_author_icon(posttype)
    @browser.wait_until($t) { @topic_post.present? }
    @browser.wait_until($t) { @topic_post_author.present? }
    @browser.wait_until($t) { @topic_post_timestamp.present? }
    case posttype
     when "ques"
      @topic_q_icon.present? || @topic_best_answer_q_icon.present?
     when "disc"
      @topic_d_icon.present?
     when "blog"
      @topic_b_icon.present?
     else
      raise "Invalid post type! Exit.."
     end   
  end

  def check_post_like_icon_and_count
    @browser.wait_until($t) { @topic_post.present? }
    @browser.wait_until($t) { @topic_post_like_icon.present? }
  end

  def check_post_reply_icon_and_count
    @browser.wait_until($t) { @topic_post.present? }
    @browser.wait_until($t) { @topic_post_comment_icon.present? }
  end

  def check_show_more_for_post
    @browser.wait_until($t) { @topic_post.present? }
    @browser.execute_script("window.scrollBy(0,10000)")
    @browser.wait_until($t) { @topic_post_show_more.present? }
    @topic_post_show_more.when_present.click
    @browser.execute_script("window.scrollBy(0,10000)")
    @browser.wait_until($t) { @topic_post_show_more.present? || ( !@topic_post_show_more.present?) }
    @browser.wait_until($t) { @topic_post.present? }
  end

  def check_topic_signin_widget_for_anon
    @loginpage = CommunityLoginPage.new(@browser)
    if @loginpage.topnav_notification.present? || @loginpage.username_dropdown.present?
     signout
     @browser.wait_until($t) { @topic_page.present? }
    end
    #goto_topicdetail_page()
    @browser.wait_until($t) { @topic_signin_widget.present? }
  end

  def check_topic_signin_widget_title
    #@loginpage = CommunityLoginPage.new(@browser)
    #if @loginpage.topnav_notification.present? || @loginpage.username_dropdown.present?
    # signout
    #end
    @browser.wait_until($t) { @topic_signin_widget_title.present? }
  end

  def check_topic_signin_widget_action
    
    @browser.wait_until($t) { @topic_signin_widget_signin.present? }
    @topic_signin_widget_signin.when_present.click
    @loginpage = CommunityLoginPage.new(@browser)
    @browser.wait_until($t) { @loginpage.signin_page.present? }
  end

  def check_topic_signin_widget_action_for_register
    @loginpage = CommunityLoginPage.new(@browser)
    if @loginpage.topnav_notification.present? || @loginpage.username_dropdown.present?
     signout
    end
    @browser.wait_until($t) { @topic_signin_widget_register.present? }
    @topic_signin_widget_register.when_present.click
    @loginpage = CommunityLoginPage.new(@browser)
    @browser.wait_until($t) { @loginpage.register_page.present? }
  end

  def check_topic_signin_widget_for_reg
    @browser.wait_until($t) { !@topic_signin_widget.present? }
  end

  def check_top_contributor_widget
    @browser.wait_until($t) { @topic_top_contributor_widget.present? }
  end

  def check_top_contributor_widget_title
    @browser.wait_until($t) { @topic_top_contributor_widget_title.present? }
  end

  def check_top_contributor_widget_work
    if @topic_top_contributor_widget.text.include? "#{$user1[3]}"
      about_login("regis", "logged")
      topic_detail("A Watir Topic For Widgets")
      choose_post_type("discussion")
      @browser.wait_until($t) { @topic_post.present? }
      conversation_detail("discussion")
      @browser.wait_until($t) { @convdetail.present? }
      if @like_disc_element.present?
        @like_disc_element.click
        @browser.wait_until($t) { @unlike_disc_element.present? }
      end
    end

      about_login("regular", "logged")
      goto_topicdetail_page("engagement2")
      topicurl = @browser.url
      sleep 1
    
      if !@topic_post.present?
        create_conversation($network, $networkslug, "A Watir Topic For Widgets", "discussion", "Discussion created by Watir when no post present - #{get_timestamp}")
      end
      @browser.goto topicurl
      @browser.wait_until($t) { @topic_post.present? }
    
    choose_post_type("discussion")
    conversation_detail("discussion")
    @browser.wait_until($t) { @convdetail.present? }
    
    if @follow_disc_element.present?  #added check for admin follow for root post
    follow_disc_element.when_present.click
    sleep 2
    @browser.wait_until($t) { @unfollow_disc_element.present? }
    end
    about_login("regis", "logged")
    $topic_name = "A Watir Topic For Widgets"
    goto_topicdetail_page("engagement2")
    choose_post_type("discussion")
    @browser.wait_until($t) { @topic_post.present? }
    conversation_detail("discussion")
    @browser.wait_until($t) { @convdetail.present? }
  
    if @unlike_disc_element.present?
      @unlike_disc_element.click
      @browser.wait_until($t) { @like_disc_element.present? }
    end
    assert @like_disc_element.present?
    @like_disc_element.click
    @browser.wait_until($t) { @unlike_disc_element.present? }
    assert @unlike_disc_element.present?

    @conv_detail_topic_link.click
    @browser.wait_until($t) { @topic_post.present? }
    
    topic_publish
    @browser.execute_script("window.scrollBy(0,7000)")
    @browser.wait_until($t) { @topic_top_contributor_widget.li.present? }
    assert @topic_top_contributor_widget.present?

    @browser.wait_until($t) {
      @topic_top_contributor_widget.li.present?
    }

    assert @topic_top_contributor_widget.link(:text => $user1[3]).present?
   
    @topic_top_contributor_widget.link(:text => $user1[3]).when_present.click
    @profilepage = CommunityProfilePage.new(@browser)
    @browser.wait_until($t) { @profilepage.user_profile.present?}
    assert @profilepage.user_profile_name.text.include? $user1[3]

    @topic_link.when_present.click
    @browser.wait_until($t) { @topic_page.present? }
    
    $topic_name = "A Watir Topic For Widgets"
    
    if !@browser.text.include?(@engagement_topicname)
     topic_sort_by_name
     @browser.wait_until($t) { @topic_page.present? }
    end
    goto_topicdetail_page("engagement2")
    @browser.wait_until($t) { @topic_filter.present? }
    choose_post_type("discussion")
    @browser.wait_until($t) { @topic_post.present? }
    conversation_detail("discussion")
    @browser.wait_until($t) { @convdetail.present? }
    @browser.wait_until($t) { @unlike_disc_element.present? }
    @unlike_disc_element.click
    @browser.wait_until($t) { @like_disc_element.present? }
    assert @like_disc_element.present?
  end

  def check_featured_topic_widget
    @browser.wait_until($t) { @topic_featured_topic_widget.present? }
  end

  def check_featured_topic_widget_title
    @browser.wait_until($t) { @topic_featured_topic_widget_title.present? }
  end

  def check_featured_topic_widget_link_and_img
    @browser.wait_until($t) { @topic_featured_topic_widget_img.present? || @topic_featured_topic_widget_no_img.present? }
    assert @topic_featured_topic_widget_img.present? || @topic_featured_topic_widget_no_img.present?
    @browser.wait_until($t) { @topic_featured_topic_widget_topic_link.present? }
    topic1 = @topic_featured_topic_widget_topic_link.text
    topic1_word = topic1.split(' ')
    topic1_first_word = topic1_word[0] #+title_firstword[1]
    topic1_second_word = topic1_word[1]
    topic1_third_word = topic1_word[2]
    topic1_first_second_third_word = "#{topic1_first_word}"+"#{topic1_second_word}"+"#{topic1_third_word}"
    @topic_featured_topic_widget_topic_link.click
    @browser.wait_until($t) { @topicdetail.present? }
    topic2 = @topic_title.text
    topic2_word = topic2.split(' ')
    topic2_first_word = topic2_word[0] #+title_firstword[1]
    topic2_second_word = topic2_word[1]
    topic2_third_word = topic2_word[2]
    topic2_first_second_third_word = "#{topic2_first_word}"+"#{topic2_second_word}"+"#{topic2_third_word}"
    assert_equal topic1_first_second_third_word, topic2_first_second_third_word, "Topics don't match"
  end

  def check_featured_topic_widget_work
    @loginpage = CommunityLoginPage.new(@browser)
    if !@loginpage.topnav_notification.present? 
     about_login("regular", "logged") #
    end
    $topic_name = "A Watir Topic For Widgets"
    topic_detail($topic_name)
    @browser.wait_until { @topic_filter.present?  }
    topic_publish
    if @topic_unfeature_button.present?
      unfeature_topic
    end
    feature_topic
    @browser.goto @topicpage_url
    @browser.wait_until($t) { @topic_page.present? }
    
    @browser.wait_until($t) { @topic_featured_filter.present? }
    @topic_featured_filter.click
    
    @browser.wait_until($t) { @topic_page.present? }
    
    @topic_all_filter.click
    @browser.wait_until($t) { @topic_page.present? }
    goto_topicdetail_page("engagement")
   
    @browser.wait_until($t) { @topic_filter.present? }
    @browser.wait_until($t) { @topic_featured_topic_widget_topic_link.present? }
    
    @browser.execute_script("window.scrollBy(0,300)")
    @browser.wait_until($t) { @topic_featured_topic_widget.present? }
    
    @topic_featured_topic_widget_topic_link.click
    @browser.wait_until($t) { @topic_filter.present? }
    assert_match @topic_title.text, "#{$topic_name}"
    if @topic_publish_change_button.present?
     @topic_publish_change_button.click
     @browser.wait_until($t) { !@topic_publish_change_button.present?}
    end
    if @topic_unfeature_button.present?
      unfeature_topic
    end   
  end

  def check_popular_discussion_widget
    @browser.wait_until($t) { @topic_popular_disc_widget.present? }
  end

  def check_popular_discussion_widget_title
    @browser.execute_script("window.scrollBy(0,20000)") 
    @browser.wait_until($t) { @topic_popular_disc_widget_title.present? }
  end

  def check_popular_discussion_widget_like_icon_and_author_link_and_img
    @browser.execute_script("window.scrollBy(0,20000)") 
    @browser.wait_until($t) { @topic_popular_disc_widget.li.present? }
    @browser.wait_until($t) { @topic_popular_disc_widget_author_img.present? }
    assert @topic_popular_disc_widget_author_img.present?

    @browser.wait_until($t) { @topic_popular_disc_widget_like_icon.present? }
    assert @topic_popular_disc_widget_like_icon.present?
    @browser.wait_until($t) { @topic_popular_disc_widget_author_name.present? }
    assert @topic_popular_disc_widget_author_name.present?
    author1 = @topic_popular_disc_widget_author_name.text
    @topic_popular_disc_widget_author_name.click
    @profilepage = CommunityProfilePage.new(@browser)
    @browser.wait_until($t) { @profilepage.profile_page.present? }
    author2 = @profilepage.user_profile_name.text
    assert_equal author2, author1, "Not same user profile"
  end

  def check_popular_discussion_widget_work
    @loginpage = CommunityLoginPage.new(@browser)
    if !@loginpage.topnav_notification.present?
     about_login("regular", "logged")
    end
    $topic_name = "A Watir Topic For Widgets"
    about_login("regis2", "logged")
    goto_topicdetail_page("engagement2")
    eng2_url = @browser.url
   
    topic_publish
    choose_post_type("discussion")
    conversation_detail("discussion")
    conv_name = root_post_title.text
    conv_link = @browser.url
    
    exp_title = conv_name.split(' ')
    exp_title_firstword = exp_title[0]
    exp_title_secondword = exp_title[1]
    
    @browser.wait_until($t) { @conv_detail.present? }
    if !@likeunlike_disc_element.present? 
     about_login("regis3", "logged")
     @browser.goto conv_link
     @browser.wait_until($t) { @topic_post.present? }
    end
    @browser.wait_until($t) { @likeunlike_disc_element.present? }
     if @like_disc_element.present?
     @like_disc_element.click
     @browser.wait_until($t) { @unlike_disc_element.present? }
     end
    
    signout
    about_login("regular", "logged")
    @browser.goto eng2_url
    
    @browser.wait_until($t) { @topic_sidezone_widget.present? }
    @browser.execute_script("window.scrollBy(0,16000)") 
    assert @topic_popular_disc_widget.present?

    @browser.wait_until($t) {
      @topic_popular_disc_widget_conv_link.present?
    }
    title = @topic_popular_disc_widget_conv_link.text
    title_firstword = title.split(' ')
    conv_name_first_word = title_firstword[0] #+title_firstword[1]
    assert @topic_popular_disc_widget.text.include? conv_name_first_word
    assert_match conv_name_first_word, exp_title_firstword, "Another discussion"
  
    @topic_popular_disc_widget_conv_link.when_present.click
    @browser.wait_until($t) { @conv_detail.present? }

    assert @conv_detail_title.text.include? conv_name
    assert @conv_featured_comment.present?, "Make sure comment is featured for this question"
  end


  def check_popular_answer_widget
    @browser.wait_until($t){ @topic_popular_answer_widget.present? }
  end

  def check_popular_answer_widget_title
    @browser.wait_until($t) { @topic_popular_answer_widget_title.present? }
  end

  def check_popular_answer_widget_like_icon_and_author_link_and_img
    @browser.execute_script("window.scrollBy(0,1000)") 
    if !@topic_popular_answer_widget.li.present?
     @loginpage = CommunityLoginPage.new(@browser)
     if !@loginpage.topnav_notification.present?
      about_login("regular", "logged")
     end
     $topic_name = "A Watir Topic With Many Posts"
    
     goto_topicdetail_page("support")
     @sup_url = @browser.url
     @browser.wait_until($t) { @topic_filter.present? }

     topic_publish
     @browser.wait_until($t) { @topic_sidezone_widget.present? }
     choose_post_type("question")
     conversation_detail("question")
     title = root_post_title.text
     @browser.wait_until($t) { @conv_reply_input.present? }
     if @featured_answer.present?
      unfeature_reply
     end
    
     post_comment("question")  
     feature_reply
     @browser.goto @sup_url 
     @browser.wait_until($t) { @topic_filter.present? }
    
     @browser.execute_script("window.scrollBy(0,7000)")
     @browser.wait_until($t) { @topic_popular_answer_widget.present? }
    end
    @browser.wait_until($t) { @topic_popular_answer_widget.li.present? }
    @browser.wait_until($t) { @topic_popular_answer_widget_author_img.present? }
    @browser.wait_until($t) { @topic_popular_answer_widget_like_icon.present? }
    @browser.wait_until($t) { @topic_popular_answer_widget_author_name.present? }
    author1 = @topic_popular_answer_widget_author_name.text
    @topic_popular_answer_widget_author_name.click
    @profilepage = CommunityProfilePage.new(@browser)
    @browser.wait_until($t) { @profilepage.profile_page.present? }
    author2 = @profilepage.profile_page_author_name.text
    assert_equal author2, author1, "Not same user profile"
  end

  def check_popular_answer_widget_work
    @loginpage = CommunityLoginPage.new(@browser)
    if !@loginpage.topnav_notification.present?
     about_login("regular", "logged")
    end
    $topic_name = "A Watir Topic With Many Posts"
    
    goto_topicdetail_page("support")
    @sup_url = @browser.url
    @browser.wait_until($t) { @topic_filter.present? }

    topic_publish
    @browser.wait_until($t) { @topic_sidezone_widget.present? }
    choose_post_type("question")
    conversation_detail("question")
    title = root_post_title.text
    if !@answer_level1.present?
     @browser.wait_until($t) { @convdetail.present? }
    else
     @browser.wait_until($t) { @answer_level1.present? }
    end
    @browser.wait_until($t) { !@spinner.present? }
    if @featured_answer.present?
     unfeature_reply
    end
    
    
    post_comment("question")  
    feature_reply
    @browser.goto @sup_url 
    @browser.wait_until($t) { @topic_filter.present? }
    
    @browser.execute_script("window.scrollBy(0,7000)")
    @browser.refresh
    @browser.wait_until($t) { @topic_popular_answer_widget.present? }
    @browser.wait_until($t) {
      @topic_popular_answer_widget.li.present?
    }
    assert @topic_popular_answer_widget.li.present?

    
    title_firstword = @topic_popular_answer_widget.lis.first.link.text.split(' ')
    conv_name_first_word = title_firstword[0] 
    conv_name_second_word = title_firstword[1]
   
    @browser.wait_until($t) { @topic_popular_answer_widget.lis.first.link.text =~ /#{conv_name_first_word}/ }

    @topic_popular_answer_widget.lis.first.link.click
    @browser.wait_until($t) { @convdetail.present?}
    @browser.wait_until($t) { @root_post_title.text =~ /#{title}/ }
    assert @root_post_title.text =~ /#{title}/
    assert @conv_featured_comment.present?, "Make sure answer is featured for this question"
    unfeature_reply
  end


  def check_featured_post_widget
    @browser.wait_until($t) { @topic_featured_post_widget.present? }
  end

  def check_featured_post_widget_title
    @browser.wait_until($t) { @topic_featured_post_widget_title.present? }
  end

  def check_featured_post_widget_author_link_and_img
    @browser.execute_script("window.scrollBy(0,900)")
    if !@topic_featured_post_widget.li.present?
     @loginpage = CommunityLoginPage.new(@browser)   
     if !@loginpage.topnav_notification.present?
      about_login("regular", "logged")
     end
     topic_detail("A Watir Topic With Many Posts")
     topic_url = @browser.url
     choose_post_type("discussion")
     conversation_detail("discussion")
     title = @convdetail.text
     title_firstword = title.split(' ')
     conv_name = /#{title_firstword[0]}/
     
     if @conv_root_post_featured.present?
      unfeature_root_post
     end
     feature_root_post
     @browser.goto topic_url
     @browser.wait_until($t) { @topic_filter.present? }
     @browser.wait_until($t) { @topic_post.present? }
     @browser.execute_script("window.scrollBy(0,3000)")
     @browser.wait_until($t) { @topic_featured_post_widget.present? }
     @browser.wait_until($t) { @topic_featured_post_widget_conv_link.present? }
    end
    @browser.wait_until($t) { @topic_featured_post_widget_author_img.present? }
    @browser.wait_until($t) { @topic_featured_post_widget_author_name.present? }
    author1 = @topic_featured_post_widget_author_name.text
    @topic_featured_post_widget_author_name.click
    @profilepage = CommunityProfilePage.new(@browser)
    @browser.wait_until($t) { @profilepage.profile_page.present? }
    author2 = @profilepage.profile_page_author_name.text
    assert_equal author2, author1, "Not same user profile"
  end

  def check_featured_post_widget_work
    @loginpage = CommunityLoginPage.new(@browser)
    if !@loginpage.topnav_notification.present?
     about_login("regular", "logged")
    end
    if !@topic_title.text.include?(@support_topicname)
     topic_detail("A Watir Topic With Many Posts")
    end
    topic_url = @browser.url
    choose_post_type("discussion")
    conversation_detail("discussion")
    title = @convdetail.text
    title_firstword = title.split(' ')
    conv_name = /#{title_firstword[0]}/
    if @conv_root_post_featured.present?
      unfeature_root_post
    end
    feature_root_post
    @browser.goto topic_url
    @browser.wait_until($t) { @topic_filter.present? }
    @browser.wait_until($t) { @topic_post.present? }
    @browser.execute_script("window.scrollBy(0,3000)")
    @browser.wait_until($t) { @topic_featured_post_widget.present? }
    @browser.wait_until($t) { @topic_featured_post_widget_conv_link.present? }
    
    @topic_featured_post_widget_conv_link.click
    @browser.wait_until($t) { @conv_detail.present? }
    title2 = @convdetail.text
    assert title == title2
    
    if @conv_root_post_featured.present?
      unfeature_root_post
    end
    
    @browser.goto topic_url
    choose_post_type("discussion")
    @browser.wait_until($t) { @topic_post.present? }
    @browser.execute_script("window.scrollBy(0,800)")
    @browser.wait_until($t) { @topic_featured_post_widget.present? }
    
    assert ( !@topic_featured_post_widget.text.include? title)
    newline
  end


  def check_open_question_widget
    @browser.wait_until($t) { @topic_open_q_widget.present? }
  end

  def check_open_question_widget_title
    @browser.wait_until($t) { @topic_open_q_widget_title.present? }
  end

  def check_open_question_widget_author_link_and_img
    policy_warning
    @browser.wait_until($t) { @topic_open_q_widget_author_img.present? }
    @browser.wait_until($t) { @topic_open_q_widget_author_name.present? }
    author1 = @topic_open_q_widget_author_name.text
    @topic_open_q_widget_author_name.when_present.click
    @profilepage = CommunityProfilePage.new(@browser)
    @browser.wait_until($t) { @profilepage.profile_page.present? }
    author2 = @profilepage.profile_page_author_name.text
    assert_equal author2, author1, "Not same user profile"
  end

  def check_open_question_widget_work
    network_landing($network)
    @loginpage = CommunityLoginPage.new(@browser)
    if !@loginpage.topnav_notification.present?
     about_login("regular", "logged")
    end
    
    goto_topicdetail_page("support")
    
    if !@topic_filter.present?
    $topic_name = "A Watir Topic With Many Posts"
    conv_name = /Watir Test Question/
    @browser.wait_until { @topic_page.present?}
    assert @topic_page.present?
    goto_topicdetail_page("support")
    @browser.wait_until($t) { @topic_filter.present? }
    end
    topic_publish
    #@browser.wait_until($t) { @topic_sidezone_widget.present? }
    
    @browser.execute_script("window.scrollBy(0,9000)")
    if !@topic_open_q_widget.li.present?
      create_conversation($network, $networkslug, "A Watir Topic With Many Posts", "question", "Q created by Watir when no open Q - #{get_timestamp}")
      goto_topicdetail_page("support")
      topic_publish
    
    end
    @browser.wait_until($t) { @topic_sidezone_widget.present? }
    @browser.wait_until { @topic_open_q_widget.li.present? }
    assert @topic_open_q_widget.present?

    @browser.wait_until($t) {
      @topic_open_q_widget.li.present?
    }

    assert @topic_open_q_widget_conv_link.present?

    @topic_open_q_widget_conv_link.when_present.click
    @browser.wait_until($t) { @conv_detail.present?}
    assert @conv_detail_title.present?
    assert !@conv_root_post_featured.present?, "Make sure no post is featured for this question"
  end

  def check_topicdetail_browser_tab_title
    assert_match @browser.title, @support_topicname
  end

  def check_topic_page_footer
    @browser.execute_script("window.scrollBy(0,10000)")
    @homepage = CommunityHomePage.new(@browser)
    @browser.wait_until($t) { @homepage.footer.present? }
  end

  def anon_create_new
    @topic_create_new_button.when_present.click
    @loginpage = CommunityLoginPage.new(@browser)
    @browser.wait_until($t) { @loginpage.signin_page.present? }
  end

  def anon_follow_topic
    @topic_follow_button.when_present.click
    @loginpage = CommunityLoginPage.new(@browser)
    @browser.wait_until($t) { @loginpage.signin_page.present? }
  end

  def create_new_q_from_topic_detail
    create_conversation($network, $networkslug, "A Watir Topic", "question", "Q from topic detail created by Watir - #{get_timestamp}")
  end

  def create_new_q_with_link_from_topic_detail
    create_conversation($network, $networkslug, "A Watir Topic", "question_with_link", "Q with link created by Watir - #{get_timestamp}", false)
  end

  def create_new_d_with_link_from_topic_detail
    create_conversation($network, $networkslug, "A Watir Topic", "discussion_with_link", "Discussion with link created by Watir - #{get_timestamp}" , false)
  end

  def create_new_b_with_video_from_topic_detail
    create_conversation($network, $networkslug, "A Watir Topic", "blog_with_video", "Blog with video created by Watir - #{get_timestamp}", false)
  end

  def create_new_b_from_topic_detail
    create_conversation($network, $networkslug, "A Watir Topic", "blog", "Blog created by Watir - #{get_timestamp}", false)
  end

  def suggested_q_post
    @loginpage = CommunityLoginPage.new(@browser)
    if !@loginpage.username.present?
    network_landing($network)

    main_landing("regular", "logged")
    end
    new_question = "watir"
    @browser.wait_until($t) { @topic_filter.present? }
    @topic_create_new_button.when_present.click
    
    @browser.wait_until($t) { @post_type_picker.present? }
    @conv_create.when_present.set new_question
    @browser.wait_until($t) { @conv_suggest_shown.present? }
    sleep 2
    assert @browser.form.ul.present?
    assert @browser.form.ul.li.text =~ /#{new_question}/i
    total = @browser.form.ul.lis.length

    matches = @browser.form.ul.lis(:text => /#{new_question}/i).length
    assert_equal total, matches, "Some autocompletes did not match '#{new_question}'"
  end

  def suggested_q_post_link
    @loginpage = CommunityLoginPage.new(@browser)
    if !@loginpage.username.present?
     network_landing($network)
     main_landing("regular", "logged")
    end
 
    new_question = "Watir"
    @browser.wait_until($t) { @topic_filter.present? }
    @topic_create_new_button.when_present.click
    
    @browser.wait_until($t) { @post_type_picker.present? }
    @conv_create.when_present.set new_question
    @browser.wait_until($t) { @conv_suggest_shown.present? }
    assert @browser.form.ul.present?

    conv_link = @browser.form.ul.link.text
    @browser.link(:text => conv_link).click
    sleep 2
    @browser.windows.last.use
    assert @browser.url =~ /#{new_question}/i
    title = @browser.h3(:class => "media-heading root-post-title", :text => conv_link)
    #puts title.text
    @browser.wait_until { title.present? }
    assert title.present?
    @browser.windows.last.close
 end

  def follow_topic
    if !@topic_filter.present?
     goto_topicdetail_page("engagement")
    end
    @topic_follow_button.when_present.click
    sleep 2
    @browser.wait_until($t) { @topic_unfollow_button.present? }
  end

  def unfollow_topic
    if !@topic_filter.present?
     goto_topicdetail_page("engagement")
    end
    if @topic_follow_button.present?
      follow_topic
    end
    @topic_unfollow_button.when_present.click
    sleep 2
    @browser.wait_until($t) { @topic_follow_button.present? }
  end

  def check_no_admin_button(user)
    if user == "logged"
      about_login("logged", "regis2")
    end
    if !@topic_filter.present?
     goto_topicdetail_page("engagement")
    end
    @browser.wait_until($t) { !@topic_edit_button.present? }
    @browser.wait_until($t) { !@topic_deactivate_button.present? }
    @browser.wait_until($t) { !@topic_feature_button.present? || !@topic_unfeature_button.present? }
  end

  def check_admin_button(user)
    if user == "logged"
      about_login("regular", "logged")
    end
    @loginpage = CommunityLoginPage.new(@browser)
    if !@loginpage.topnav_notification.present?
     about_login("regular", "logged")
    end
    goto_topic_page
    goto_topicdetail_page("support")
    @browser.wait_until($t) { @topic_filter.present? }
    @browser.wait_until($t) { @topic_edit_button.present? }
    @browser.wait_until($t) { @topic_deactivate_button.present? }
    @browser.wait_until($t) { @topic_feature_button.present? || @topic_unfeature_button.present? }
  end


  def feature_a_topic
    @loginpage = CommunityLoginPage.new(@browser)
    if !@loginpage.topnav_notification.present?
     about_login("regular", "logged")
    end
    if !@topic_filter.present?
     goto_topicdetail_page("engagement")
    end
    $topic_name = "A Watir Topic"
    @browser.wait_until { @topic_filter.present?  }
    
    if @topic_unfeature_button.present?
      unfeature_topic
    end
    feature_topic
    @browser.goto @topicpage_url
    @browser.wait_until($t) { @topic_page.present? }
    
    @browser.wait_until($t) { @topic_featured_filter.present? }
    @topic_featured_filter.click
    
    @browser.wait_until($t) { @topic_page.present? }
    assert @topic_page.text.include? $topic_name
    
    @topic_all_filter.click
    @browser.wait_until($t) { @topic_page.present? }
    
    if !@browser.text.include?(@engagement_topicname)
      topic_sort_by_name
      @browser.wait_until($t) { @topic_page.present? }
    end
    @topic_engagement.when_present.click
    @browser.wait_until($t) { @topic_filter.present? }
    if @topic_feature_button.present?
      feature_topic
    end
    @topic_unfeature_button.click
    @browser.wait_until($t) { @topic_feature_button.present? }
  end

  def unfeature_a_topic
    @loginpage = CommunityLoginPage.new(@browser)
    if !@loginpage.topnav_notification.present?
     about_login("regular", "logged")
    end

    if !@topic_filter.present?
     goto_topicdetail_page("engagement")
    end
    $topic_name = "A Watir Topic"
    @browser.wait_until { @topic_filter.present?  }
    
    if @topic_feature_button.present?
      feature_topic
    end
    unfeature_topic
    @browser.goto @topicpage_url
    @browser.wait_until($t) { @topic_page.present? }
    
    @browser.wait_until($t) { @topic_featured_filter.present? }
    @topic_featured_filter.click
    
    @browser.wait_until($t) { @topic_page.present? || @topic_page_no_topic.present? }
    assert ( !@browser.text.include? $topic_name) || ( @browser.text.include? "There are no topics")
    
    @topic_all_filter.click
    @browser.wait_until(50) { @topic_page.present? }
    
    if !@browser.text.include?(@engagement_topicname)
      topic_sort_by_name
      @browser.wait_until(50) { @topic_page.present? }
    end
    @topic_engagement.when_present.click
    @browser.wait_until($t) { @topic_filter.present? }
  
    @browser.wait_until($t) { @topic_feature_button.present? }

  end

  def edit_a_topic
    @loginpage = CommunityLoginPage.new(@browser)
    if !@loginpage.topnav_notification.present?
     about_login("regular", "logged")
    end

    if !@topic_filter.present?
     goto_topicdetail_page("engagement2")
    end
    topicdescrip = "Watir topic test description updated during topic edit - #{get_timestamp}"
    filetile = "#{$rootdir}/seeds/development/images/topictileedit.jpg"
    @browser.wait_until { @topic_filter.present?  }
    topic_publish
    @browser.wait_until($t) { @topic_edit_button.present? }
    @topic_edit_button.when_present.click
    @browser.wait_until($t) { @topic_edit_screen.present? }
    @topic_edit_desc.when_present.set topicdescrip

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
    @browser.wait_until($t) { @topic_type_radio.present?}
    
    @topic_edit_next.when_present.click
    sleep 4
    @browser.wait_until($t) { @topic_edit_screen.present? }
    
    @browser.execute_script("window.scrollBy(0,1000)")
    @browser.wait_until { @topic_edit_view_topic.present? }
    @topic_edit_view_topic.when_present.click
    @browser.wait_until($t) { @topic_sidezone_widget.present? }
    @browser.wait_until($t) { @topic_filter.present? }
    @browser.refresh
    @browser.wait_until($t) { @topic_publish_change_button.present? }
    @topic_publish_change_button.when_present.click
    sleep 2
    #@browser.wait_until($t) { !@topic_publish_change_button.present? }
    @browser.wait_until($t) { @topic_edit_button.present? }
    @browser.goto @topicpage_url
  
    @browser.wait_until(40) { @topic_page_desc.present? }
    @browser.wait_until($t) { @topic_page_desc.text.include? topicdescrip}
    assert @topic_page_desc.text.include? topicdescrip
  end

  def deactivate_a_topic
    @loginpage = CommunityLoginPage.new(@browser)
    if !@loginpage.topnav_notification.present?
     about_login("regular", "logged")
    end
    if !@topic_filter.present?
     goto_topicdetail_page("engagement2")
    end
    @browser.wait_until($t) { @topic_filter.present?  }
    if @topic_activate_button.present?
      @topic_activate_button.click
      @browser.wait_until($t) { @topic_deactivate_button.present? }
    end
    @topic_deactivate_button.when_present.click
    @browser.wait_until($t) { @topic_deactivate_modal1.attribute_value('style') =~ /display: block;/  }
    #@browser.execute_script('$("button.btn btn-primary").click()')
    @topic_deactivate_confirm.click
    
    @browser.wait_until($t) { @topic_activate_button.present? }
  end

  def activate_a_topic
    @loginpage = CommunityLoginPage.new(@browser)
    if !@loginpage.topnav_notification.present?
     about_login("regular", "logged")
    end
    if !@topic_filter.present?
     goto_topicdetail_page("engagement2")
    end

    @browser.wait_until($t) { @topic_filter.present?  }
    if @topic_deactivate_button.present?
      @topic_deactivate_button.when_present.click
      @browser.wait_until($t) { @topic_activate_button.present? }
    end
    sleep 1
    @topic_activate_button.when_present.click
    
    @browser.wait_until($t) { @topic_deactivate_button.present? }
  end

  def topic_widgets_in_topic_type(network, networkslug, topicname, topictype)
    network_landing(network)
    main_landing("regular", "logged")
    @browser.link(:class => "ember-view", :text => topicname).when_present.click
    @browser.wait_until($t) { @browser.div(:class => "widget top_contributors", :text => /Top Contributors/).present? }
    if (topictype == "engagement")
      @browser.wait_until($t) { @browser.div(:class => "widget top_contributors", :text => /Top Contributors/).present? }
      assert @browser.div(:class => "widget top_contributors", :text => /Top Contributors/).present?
      @browser.wait_until($t) { @browser.div(:class => "widget featured_topics", :text => /Featured Topics/).present? }
      assert @browser.div(:class => "widget featured_topics", :text => /Featured Topics/).present?
      @browser.wait_until($t) { @browser.div(:class => "widget popular_discussions", :text => /Popular Discussions/).present? }
      assert @browser.div(:class => "widget popular_discussions", :text => /Popular Discussions/).present?
      assert (!@browser.div(:class => "widget open_questions", :text => /Open Questions/).present?)
    else 
      @browser.wait_until($t) { @browser.div(:class => "widget popular_answers", :text => /Popular Answers/).present? }
      assert @browser.div(:class => "widget popular_answers", :text => /Popular Answers/).present?
      @browser.wait_until($t) { @browser.div(:class => "widget featured_posts", :text => /Featured Posts/).present? }
      assert @browser.div(:class => "widget featured_posts", :text => /Featured Posts/).present?
      @browser.wait_until($t) { @browser.div(:class => "widget top_contributors", :text => /Top Contributors/).present? }
      assert @browser.div(:class => "widget top_contributors", :text => /Top Contributors/).present?
      @browser.wait_until($t) { @browser.div(:class => "widget open_questions", :text => /Open Questions/).present? }
      assert @browser.div(:class => "widget open_questions", :text => /Open Questions/).present?
      assert (!@browser.div(:class => "widget popular_discussions", :text => /Popular Discussions/).present?)
    end
  end

end