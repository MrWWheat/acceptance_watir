require 'pages/community'
require 'minitest/assertions'
require 'pages/community/gadgets/home_conversations'

class Pages::Community::Home < Pages::Community

  def initialize(config, options = {})
    super(config)
    @url = config.base_url + "/n/#{config.slug}/home"

    #puts @network_name = config.network_name
    #puts @base_url = config.base_url
    #puts @@slug = config.slug  
  end
  
  def start!(user)
    
    super(user, @url, homebanner)

    # Need to make sure go to Home page after logout because 
    # topics page is displayed even home page is displayed before logout.
    ensure_correct_start_location!(@url, homebanner) unless @browser.url == @url

    accept_policy_warning
  end
  #puts "#{@url}"
  #puts "ash"+"#{config.slug}"
 
  home 								           { div(:class => "home") }
  homebanner 						         { div(:css => ".widget.banner.home") }
  home_inverted_banner 				   { div(:class => "inverted  widget banner home") }
  homebanner_editmode 				   { div(:class => "uploader-component widget banner home") }
  homebanner_inverted 				   { div(:class => "inverted  widget banner home") }
  homebanner_style 					     { div(:class => "normal  widget banner home") }

  search_middle_input            { input(:css => ".search-form.search-bar.col-md-8 input") }

  search_bar 						         { input(:class => "form-control tt-input", :placeholder => "Search...") }
  search_input  					       { text_field(:class => "form-control tt-input") }
  search_dropdown   				     { span(:class => "tt-dropdown-menu") }
  search_page 						       { div(:class => /(col-lg-8 col-md-7 col-sm-12|col-lg-8 col-md-8 col-sm-12)/) } #changeattribute
  search_page_post 					     { div(:class => "media") }
  search_result_heading 			   { div(:class => "media-heading") }
  search_no_match 					     { div(:class => "ember-view", :text => /_filtered_ - did not find any matches./) } #changetext
  search_open_q_widget 				   { div(:class => "widget-container zone side").div(:class => "col-sm-12").div(:class => "hidden-sm", :index => 1).div(:class => "widget").div(:class => "offset-15", :index => 1).p(:class => "checkable-item checked") }
  search_featured_d_widget 			 { div(:class => "widget-container zone side").div(:class => "col-sm-12").div(:class => "hidden-sm", :index => 1).div(:class => "widget").div(:class => "offset-15").p(:index => 0) }
  search_featured_q_widget 			 { div(:class => "widget-container zone side").div(:class => "col-sm-12").div(:class => "hidden-sm", :index => 1).div(:class => "widget").div(:class => "offset-15", :index => 3).p(:class => "checkable-item checked") }
  search_featured_b_widget 			 { div(:class => "widget-container zone side").div(:class => "col-sm-12").div(:class => "hidden-sm", :index => 1).div(:class => "widget").div(:class => "offset-15", :index => 4).p(:class => "checkable-item checked") }

  topic_page 						         { div(:class => "col-sm-12 col-lg-4 col-md-4") } #changeattribute
  topicdetail 						       { div(:class => "topic-filters") }
  question_icon 					       { span(:class => "ember-view post-type question") }
 
  topicname 						         { div(:class => "col-md-12") } #changeattribute
  topic_feature 					       { div(:class => "btn-group").button(:class => "btn btn-default btn-sm admin-dark-btn topic-admin-buttons", :text => "Feature Topic") } #changetext
  topic_unfeature 					     { div(:class => "btn-group").button(:class => "btn btn-default btn-sm admin-dark-btn topic-admin-buttons", :text => "Unfeature Topic") } #changetext


  home_featured_topic 				    { div(:class => "widget featured-topics") }
  home_featured_topic_row 			  { div(:class => "col-sm-12 col-lg-4 col-md-4") } #changeattribute
  home_featured_topic_link 			  { div(:class => "col-sm-12 col-lg-4 col-md-4").link(:class => "ember-view") }
  home_featured_topic_post_count 	{ div(:class => "topic-footer posts-count").span(:class => "meta-text") } 
  home_featured_topic_last_post 	{ div(:class => "topic-footer last-activity").span(:class => "meta-text") }
  featured_topic_viewall 			{ link(:class => "view-all-featured", :text => "View All") }

  home_open_question 				  { div(:class => "widget home_open_questions").div(:class => "media") }
  home_open_q_desc 					  { div(:class => "widget home_open_questions").div(:class => "media").div(:class => "media-body") }
  home_open_q_link 					  { div(:class => "widget home_open_questions").link(:class => "ember-view") }
  open_question_viewall 			{ div(:class => "widget home_open_questions").link(:class => "view-all") }
  open_question_conv 				  { div(:class => "widget home_open_questions").div(:class => "media-body") }

  home_featured_discussion 		{ div(:class => "widget featured_discussions").div(:class => "media") }
  featured_discussion_viewall { div(:class => "widget featured_discussions").link(:class => "view-all") }
  featured_discussion_conv 		{ div(:class => "widget featured_discussions").div(:class => "media-body") }
  featured_discussion_icon 		{ div(:class => "widget featured_discussions").div(:class => "ember-view post").div(:class => "media").div(:class => "media-body").div(:class => "details").span(:class => "featured") }
  home_featured_d_link 				{ div(:class => "widget featured_discussions").link(:class => "ember-view") }
  home_featured_d_desc 				{ div(:class => "widget featured_discussions").div(:class => "posts").div(:class => "post").div(:class => "media-body") }

  home_featured_question      { div(:css => ".widget.featured_questions,.-featured-questions").div(:css => ".post") }
  featured_question_viewall   { div(:css => ".widget.featured_questions,.-featured-questions").link(:class => "view-all") }
  featured_question_conv 			{ div(:css => ".widget.featured_questions,.-featured-questions").div(:class => "media-body") }
  featured_question_icon      { div(:css => ".widget.featured_questions,.-featured-questions").div(:class => "ember-view post").div(:class => "media").div(:class => "media-body").div(:class => "details").span(:class => "featured") }
  home_featured_q_link        { div(:css => ".widget.featured_questions,.-featured-questions").link(:class => "ember-view") }
  home_featured_q_desc        { div(:css => ".widget.featured_questions,.-featured-questions").div(:css => ".post .media-body") }

  home_featured_blog 				  { div(:class => "widget featured_blog_posts").div(:class => "media") }
  featured_blog_viewall 			{ div(:class => "widget featured_blog_posts").link(:class => "view-all") }
  featured_blog_conv 				  { div(:class => "widget featured_blog_posts").div(:class => "media-body") }
  featured_blog_icon 				  { div(:class => "widget featured_blog_posts").div(:class => "ember-view post").div(:class => "media").div(:class => "media-body").div(:class => "details").span(:class => "featured") }
  home_featured_b_link 				{ div(:class => "widget featured_blog_posts").link(:class => "ember-view") }
  home_featured_b_desc 				{ div(:class => "widget featured_blog_posts").div(:class => "ember-view post").div(:class => "media").div(:class => "media-body") }

  home_featured_review        { div(:css => ".widget.featured_reviews,.-featured-reviews").div(:class => "media") }
  home_featured_review_des    { div(:css => ".widget.featured_reviews,.-featured-reviews").div(:class => "ember-view post").div(:class => "media").div(:class => "media-body")}
  featured_review_viewall     { div(:css => ".widget.featured_reviews,.-featured-reviews").link(:class => "view-all")}

  empty_upcoming_events      { div(:class => "upcoming-events").h4(:class =>"empty-container-text")}
  upcoming_events            { div(:class => "upcoming-events").divs(:class => "event-card") }
  event_view_all_link        { link(:href => /events/) }

  home_search 						    { text_field(:class => "form-control tt-input") }

  home_edit 						      { button(:class => "btn btn-default btn-sm admin-dark-btn", :text => "Edit Home Page") }
  home_edit_mode 					    { div(:class => " widget text can-edit") }
  home_edit_browse_new 				{ link(:text => "browse") }
  home_edit_change 					  { button(:class => "btn btn-default btn-sm admin-dark-btn", :text => "Change Photo") }
  home_edit_modal 					  { div(:class => "modal-header") }
  home_edit_file_field 				{ file_field(:class => "files file photo-browse-input btn btn-default btn-sm") }
  home_edit_selected_file 		{ div(:class => "cropper-canvas") }
  home_img_upload 					  { button(:class => "file-upload-select-button", :text => /Select Photo/) }
  home_edit_toggle_txt_btn         { button(:css => ".widget.banner.home .btn-toolbar .btn-group > button:nth-child(3)") }

  # home_widget 						    { div(:class => "zone main") }
  home_topic_widget 				  { div(:class => "widget featured-topics").div(:class => "col-sm-12 col-lg-4 col-md-4") }

  conv_detail 						    { div(:class => /depth-0/) }

  conv_feature 						    { span(:class => "featured") }
  conv_title 						      { h3(:class => "media-heading root-post-title") }

  home_url 							      { "#{@@base_url}" +"/n/#{@@slug}/home" }

  footer_link 						    { div(:css => ".footer").parent } #changeattribute
  tou_link                    { link(:css => ".footer a[href='http://go.sap.com/corporate/en/legal/terms-of-use.html'") }
  home_de_locale_url          { "#{@@base_url}" +"/n/#{@@slug}/home"+"?locale=de" }
  featured_topic_viewall_de   { link(:class => "view-all-featured ember-view view-all-featured", :text => "Alle anzeigen") }

  carousel_topic_list         { div(:class => "carousel slide topics-carousel-container")}
  carousel_left_page_btn      { link(:class => "topic-control control-left")}
  carousel_right_page_btn     { link(:class => "topic-control control-right")}
  carousel_pagination         { ol(:class => "carousel-indicators topics-grid-indicators")}
  carousel_left_topic         { div(:class => "topic-avatar")}
  carousel_active_topic       { div(:class => "item active")}
  carousel_left_topic_name    { div(:class => "item active").h4s[0].text}
  carousel_middle_topic_name  { div(:class => "item active").h4s[1].text}
  carousel_right_topic_name   { div(:class => "item active").h4s[2].text}

  idea_widget_view_all_link   { div(:class => "ideas-container").link(:text => /View All/) }

  def open_questions_widget
    Gadgets::Community::OpenQ.new(@config)
  end 

  def featured_q_widget
    Gadgets::Community::FeaturedQ.new(@config)
  end 

  def featured_b_widget
    Gadgets::Community::FeaturedB.new(@config)
  end 

  def featured_r_widget
    Gadgets::Community::FeaturedR.new(@config)
  end 

  def navigate_in(url=nil)
    url = home_url if url.nil?
    @browser.goto url
    @browser.wait_until { homebanner.present? }
  end  

  def change_home_locale(locale)
    
   case locale
    when "de"   
     navigate_in(home_de_locale_url)
     @browser.wait_until { featured_topic_viewall_de.present? }
    when "en"
     navigate_in
     @browser.wait_until { featured_topic_viewall.present? }
    else
     raise "Invalid locale! Exit.."
    end 
  end 

  def get_img_position_by_css
    pi_count = @browser.elements(:css => ".slide.s-section").size - 1

    result = nil

    (0..pi_count).each do |i|
      
      if @browser.element(:css => ".slide.s-gadget", :index => i).element(:css => ".banner-title").present?
        result = i
        break
      end  
    end

    raise "Cannot find widget img" if result.nil?

    result
  end

  def get_input_position_by_css
    pi_count = @browser.elements(:css => ".slide.s-section").size - 1

    result = nil

    (0..pi_count).each do |i|
      
      if @browser.element(:css => ".slide.s-gadget", :index => i).element(:css => ".col-md-8 .tt-input").present?
        result = i
        break
      end  
    end

    raise "Cannot find widget input" if result.nil?

    result
  end

  def get_topic_position_by_css
    pi_count = @browser.elements(:css => ".slide.s-section").size - 1

    result = nil

    (0..pi_count).each do |i|
      topic = @browser.element(:css => ".slide.s-gadget", :index => i).element(:css => ".customization-home-heading")
      
      if topic.present? && topic.text.downcase == "topics"
        result = i
        break
      end  
    end

    raise "Cannot find widget topic" if result.nil?

    result
  end

  def assert_view_all_link_present_and_click(type=nil)
    link = nil
    case type
    when "Review"
      link = featured_review_viewall
    when "Question"
      link = featured_question_viewall
    when "Blog"
      link = featured_blog_viewall
    end
    begin
      @browser.wait_until(5) { link.present? }
      link.click
      return true
    rescue 
      puts "Message : #{type} view all link didn't provided !"
      return false
    end
  end
end