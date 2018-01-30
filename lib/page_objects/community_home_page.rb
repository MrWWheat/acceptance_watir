require File.expand_path(File.dirname(__FILE__) + "/page_object.rb")

class CommunityHomePage < PageObject
 
  attr_accessor :homebanner, 
  :home, 
  :search_bar, 
  :search_page, 
  :search_result_heading, 
  :home_featured_topic, 
  :topic_page, 
  :home_open_question, 
  :search_open_q_widget,
  :home_featured_discussion, 
  :search_featured_d_widget, 
  :home_featured_question, 
  :search_featured_q_widget, 
  :home_featured_blog, 
  :search_featured_b_widget, 
  :footer,
  :home_featured_topic_post_count, 
  :home_featured_topic_last_post, 
  :home_open_q_link, 
  :conv_detail, 
  :question_icon, 
  :conv_title, 
  :featured_discussion_conv, 
  :home_featured_b_link,
  :featured_blog_conv, 
  :home_featured_b_link, 
  :home_edit, 
  :home_featured_topic_link, 
  :conv_feature, 
  :home_edit, 
  :topic_unfeature, 
  :footer_link, 
  :home_url, 
  :home_topic_widget, 
  :home_open_q_desc, 
  :home_featured_d_desc,
  :home_featured_b_desc, 
  :home_featured_q_desc, 
  :home_inverted_banner, 
  :homebanner_editmode,
  :home_lingo_url,
  :featured_topic_viewall_de

  def initialize(browser)
    super
    @url = $base_url +"/n/#{$networkslug}/home"

    @home_de_locale_url = $base_url +"/n/#{$networkslug}/home"+"?locale=de"
    @featured_topic_viewall_de = @browser.link(:class => "view-all-featured ember-view view-all-featured", :text => "Alle anzeigen")
    @footer = @browser.footer(:class => "ember-view")
    @home = @browser.div(:class => "home")
    @homebanner = @browser.div(:class => "normal  widget banner home")
    @home_inverted_banner = @browser.div(:class => "inverted  widget banner home")
    @homebanner_editmode = @browser.div(:class => "ember-view uploader-component widget banner normal home")
    @homebanner_inverted = @browser.div(:class => "inverted  widget banner home")
    @homebanner_style = @browser.div(:class => "normal  widget banner home")

    @search_bar = @browser.input(:class => "ember-view ember-text-field typeahead form-control tt-input", :placeholder => "Search...")
    @search_input = @browser.text_field(:class => "ember-view ember-text-field typeahead form-control tt-input")
    @search_dropdown = @browser.span(:class => "tt-dropdown-menu")
    @search_page = @browser.div(:class => "col-lg-8 col-md-7 col-sm-12")
    @search_page_post = @browser.div(:class => "media")
    @search_result_heading = @browser.div(:class => "media-heading")
    @search_no_match = @browser.div(:class => "ember-view", :text => /_filtered_ - did not find any matches./)
    @search_open_q_widget = @browser.div(:class => "widget-container zone side col-lg-4 col-md-5 col-sm-12").div(:class => "col-sm-12").div(:class => "hidden-sm", :index => 1).div(:class => "widget").div(:class => "offset-15", :index => 1).p(:class => "ember-view checkable-item checked")
    @search_featured_d_widget = @browser.div(:class => "widget-container zone side col-lg-4 col-md-5 col-sm-12").div(:class => "col-sm-12").div(:class => "hidden-sm", :index => 1).div(:class => "widget").p(:class => "ember-view checkable-item checked", :index => 1)
    @search_featured_q_widget = @browser.div(:class => "widget-container zone side col-lg-4 col-md-5 col-sm-12").div(:class => "col-sm-12").div(:class => "hidden-sm", :index => 1).div(:class => "widget").div(:class => "offset-15", :index => 3).p(:class => "ember-view checkable-item checked")
    @search_featured_b_widget = @browser.div(:class => "widget-container zone side col-lg-4 col-md-5 col-sm-12").div(:class => "col-sm-12").div(:class => "hidden-sm", :index => 1).div(:class => "widget").div(:class => "offset-15", :index => 4).p(:class => "ember-view checkable-item checked")

    @topic_page = @browser.div(:class => "col-sm-12 col-lg-4 col-md-4")
    @question_icon = @browser.span(:class => "ember-view post-type question")
    @topicdetail = @browser.div(:class => "topic-filters")
    @topicname = @browser.div(:class => "col-md-12")
    @topic_feature = @browser.div(:class => "btn-group").button(:class => "btn btn-default btn-sm admin-dark-btn topic-admin-buttons", :text => "Feature Topic")
    @topic_unfeature = @browser.div(:class => "btn-group").button(:class => "btn btn-default btn-sm admin-dark-btn topic-admin-buttons", :text => "Unfeature Topic")


    @home_featured_topic = @browser.div(:class => "widget featured-topics")
    @home_featured_topic_row = @browser.div(:class => "col-sm-12 col-lg-4 col-md-4")
    @home_featured_topic_link = @browser.div(:class => "col-sm-12 col-lg-4 col-md-4").link(:class => "ember-view")
    @home_featured_topic_post_count = @browser.div(:class => "topic-footer posts-count").span(:class => "meta-text")
    @home_featured_topic_last_post = @browser.div(:class => "topic-footer posts-count").span(:class => "meta-text")
    @featured_topic_viewall = @browser.link(:class => "view-all-featured ember-view view-all-featured", :text => "View All")

    @home_open_question = @browser.div(:class => "widget home_open_questions").div(:class => "media")
    @home_open_q_desc = @browser.div(:class => "widget home_open_questions").div(:class => "media").div(:class => "media-body")
    @home_open_q_link = @browser.div(:class => "widget home_open_questions").link(:class => "ember-view")
    @open_question_viewall = @browser.div(:class => "widget home_open_questions").link(:class => "view-all")
    @open_question_conv = @browser.div(:class => "widget home_open_questions").div(:class => "media-body")

    @home_featured_discussion = @browser.div(:class => "widget featured_discussions").div(:class => "media")
    @featured_discussion_viewall = @browser.div(:class => "widget featured_discussions").link(:class => "view-all")
    @featured_discussion_conv = @browser.div(:class => "widget featured_discussions").div(:class => "media-body")
    @featured_discussion_icon = @browser.div(:class => "widget featured_discussions").div(:class => "ember-view post").div(:class => "media").div(:class => "media-body").div(:class => "details").span(:class => "featured")
    @home_featured_d_link = @browser.div(:class => "widget featured_discussions").link(:class => "ember-view")
    @home_featured_d_desc = @browser.div(:class => "widget featured_discussions").div(:class => "post media").div(:class => "media-body").div(:class => "preview")

    @home_featured_question = @browser.div(:class => "widget featured_questions").div(:class => "media")
    @featured_question_viewall = @browser.div(:class => "widget featured_questions").link(:class => "view-all")
    @featured_question_conv = @browser.div(:class => "widget featured_questions").div(:class => "media-body")
    @home_featured_q_desc = @browser.div(:class => "widget featured_questions").div(:class => "ember-view post").div(:class => "media").div(:class => "media-body")

    @home_featured_blog = @browser.div(:class => "widget featured_blog_posts").div(:class => "media")
    @featured_blog_viewall = @browser.div(:class => "widget featured_blog_posts").link(:class => "view-all")
    @featured_blog_conv = @browser.div(:class => "widget featured_blog_posts").div(:class => "media-body")
    @featured_blog_icon = @browser.div(:class => "widget featured_blog_posts").div(:class => "ember-view post").div(:class => "media").div(:class => "media-body").div(:class => "details").span(:class => "featured")
    @home_featured_b_link = @browser.div(:class => "widget featured_blog_posts").link(:class => "ember-view")
    @home_featured_b_desc = @browser.div(:class => "widget featured_blog_posts").div(:class => "ember-view post").div(:class => "media").div(:class => "media-body")

    @home_search = @browser.text_field(:class => "ember-view ember-text-field typeahead form-control tt-input")

    @home_edit = @browser.button(:class => "ember-view btn btn-default btn-sm admin-dark-btn", :text => "Edit Home Page")
    @home_edit_mode = @browser.div(:class => " widget text can-edit")
    @home_edit_browse_new = @browser.link(:text => "browse")
    @home_edit_change =  @browser.button(:class => "btn btn-default btn-sm admin-dark-btn", :text => "Change Photo")
    @home_edit_modal = @browser.div(:class => "modal-header")
    @home_edit_file_field = @browser.file_field(:class => "ember-view ember-text-field files file photo-browse-input btn btn-default btn-sm")
    @home_edit_selected_file = @browser.div(:class => "cropper-canvas")
    @home_img_upload = @browser.div(:class => "modal-footer").button(:class => "btn btn-primary btn-sm file-upload-select-button", :text => "Select Photo")


    @home_widget = @browser.div(:class => "col-lg-12 col-md-12 zone main")
    @home_topic_widget = @browser.div(:class => "widget featured-topics").div(:class => "col-sm-12 col-lg-4 col-md-4")

    @conv_detail = @browser.div(:class => /depth-0/)

    @conv_feature = @browser.span(:class => "featured")
    @conv_title = @browser.h3(:class => "media-heading root-post-title")

    @tab_title = @browser.title

    @home = @browser.div(:class => "home")
    @home_url = $base_url +"/n/#{$networkslug}/home"
    @home_topic_widget = @browser.div(:class => "widget featured-topics").div(:class => "col-sm-12 col-lg-4 col-md-4")
    @homebanner_editmode = @browser.div(:class => "ember-view uploader-component widget banner normal home")

    @footer_link = @browser.div(:class => "col-md-offset-2 col-md-8")
  end

  def goto_homepage
    @browser.goto $base_url+"/n/#{$networkslug}/home"
    @browser.wait_until($t) { @home_topic_widget.present? }
    @browser.wait_until($t) { @home_widget.present? }
    policy_warning
    @homeurl = @browser.url
    if @browser.url != @homeurl && @homeurl != nil
     @browser.goto @homeurl 
     @browser.wait_until($t) { @home_widget.present? }
    end
  end

  def check_homepage_banner
    @browser.wait_until($t) { @homebanner.present? || @home_inverted_banner.present? }
  end

  def check_browser_tab_title
    assert_match @browser.title, "#{$network}" 
  end

  def check_homepage_search_bar
    @browser.wait_until($t) { @search_bar.present? }
  end

  def search_from_homepage
    @browser.wait_until($t) { @search_bar.present? }
    @search_input.set "watir"
    @browser.wait_until($t) { @search_dropdown.present? }
    @browser.send_keys :enter
    @browser.wait_until { @search_page.present? }
  end

  def check_featured_topic_widget
    @browser.wait_until($t) { @home_featured_topic_row.present? }
  end

  def check_featured_topic_widget_link
    @browser.execute_script("window.scrollBy(0,3000)")
    @browser.wait_until($t) { @home_featured_topic_link.present? }
    @home_featured_topic_link.when_present.click
    @browser.wait_until($t) { @topicdetail.present? }
  end

  def click_topic_feature
    topic_publish
    $hometopicname = @topicname.h1.text
    if @topic_unfeature.present? 
      @topic_unfeature.click
    end
    @browser.wait_until($t) { @topic_feature.present? }
    @topic_feature.when_present.click
    @browser.wait_until($t) { @topic_unfeature.present? }
    sleep 2 #assert @topic_unfeature.present?
  end

  def click_topic_unfeature
    topic_publish
    $hometopicname = @topicname.h1.text
    if @topic_feature.present? 
      @topic_feature.click
    end
    @browser.wait_until($t) { @topic_unfeature.present? }
    @topic_unfeature.when_present.click
    @browser.wait_until($t) { @topic_feature.present? }
  end

  def check_featured_topic_in_widget
    @browser.wait_until($t) { @home_featured_topic.text.include? $hometopicname}
  end


  def check_featured_topic_widget_topic
    @browser.wait_until($t) { @home_featured_topic_row.present? }
  end

  def check_featured_topic_widget_post_count
    @browser.wait_until($t) { @home_featured_topic_post_count.present? }
  end

  def check_featured_topic_widget_last_post
    @browser.wait_until($t) { @home_featured_topic_last_post.present? }
  end

  def goto_featured_topic_viewall
    @browser.wait_until($t) { @featured_topic_viewall.present? }
    #if @browser.div(:id => "policy-warning").present?=
     policy_warning
    #end
    @featured_topic_viewall.click
    @browser.wait_until($t) { @topic_page.present?}
  end

  def check_open_question_widget
    check_featured_topic_widget
  
    @browser.execute_script("window.scrollBy(0,5000)")
  
    @browser.wait_until($t) { @home_open_question.present? }  
    @browser.wait_until($t) { @home_open_q_desc.present?} 
  end

  def check_open_question_conv
    @browser.wait_until($t) { @open_question_conv.present? }
  end

  def check_open_q_conv_link
    @browser.execute_script("window.scrollBy(0,6000)")
    conv_title = @home_open_q_link.text
    @browser.wait_until($t) { @home_open_q_link.present? }
    @home_open_q_link.when_present.click
    @browser.wait_until($t) { @conv_detail.present? }
  end

  def check_open_question_icon
    @browser.execute_script("window.scrollBy(0,6000)")
    @browser.wait_until($t) { @question_icon.present? }
  end

  def goto_open_question_viewall
    check_featured_topic_widget
    @browser.execute_script("window.scrollBy(0,5000)")
    @browser.wait_until($t) { @open_question_viewall.present? }
    @open_question_viewall.click
    @browser.wait_until { @search_page_post.present? }
    
    @browser.wait_until($t) { @search_page.h3.text.include? "Search Results"}
  end

  def check_featured_discussion_widget
    @browser.execute_script("window.scrollBy(0,5000)")
    @browser.wait_until($t) { @home_featured_discussion.present? }
  end

  def check_featured_discussion_conv
    @browser.execute_script("window.scrollBy(0,5000)")
    @browser.wait_until($t) { @featured_discussion_conv.present? }
  end

  def check_featured_d_conv_link
    @browser.execute_script("window.scrollBy(0,5000)")
    conv_title = @home_featured_d_link.text
    @browser.wait_until($t) { @home_featured_d_link.present? }
    @home_featured_d_link.click
    @browser.wait_until($t) { @conv_detail.present? }
  end

  def check_featured_discussion_icon
    @browser.wait_until($t) { @featured_discussion_icon.present? }
  end

  def feature_a_conv
    if @conv_feature.present?
      unfeature_root_post
    end
    feature_root_post
    @browser.wait_until($t) { @conv_feature.present? }
  end

  def unfeature_a_conv
    if !@conv_feature.present?
      feature_root_post
    end
    unfeature_root_post
    @browser.wait_until($t) { !@conv_feature.present? }
  end

  def goto_featured_discussion_viewall
    @browser.execute_script("window.scrollBy(0,5000)")
    @browser.wait_until($t) { @featured_discussion_viewall.visible? }
    @browser.wait_until { @browser.link(:class => "ember-view").present? }
    @featured_discussion_viewall.click

    @browser.wait_until { @search_page.present? }

    if @search_no_match.present?
      about_login("regular", "logged")
      @browser.goto @topicpage_url
      goto_topicdetail_page("engagement")
      choose_post_type("discussion")
      conversation_detail("discussion")
      feature_a_conv
      signout
      goto_homepage
      @featured_question_viewall.click
    end
    @browser.wait_until { @search_page_post.present? }
    @browser.wait_until($t) { @search_page.h3.text.include? "Search Results"}
    
  end

  def check_featured_question_widget
    @browser.execute_script("window.scrollBy(0,5000)")
    @browser.wait_until($t) { @home_featured_question.present? }
  end

  def check_featured_question_conv
    @browser.execute_script("window.scrollBy(0,5000)")
    @browser.wait_until($t) { @featured_question_conv.present? }
  end

  def check_featured_question_icon
    @browser.wait_until($t) { @question_icon.present? }
  end

  def goto_featured_question_viewall
    @browser.execute_script("window.scrollBy(0,5000)")
    @browser.wait_until($t) { @featured_question_viewall.present? }
    @featured_question_viewall.click
    @browser.wait_until { @search_page.present? }

    if @search_no_match.present?
      about_login("regular", "logged")
      @browser.goto @topicpage_url
      goto_topicdetail_page("engagement")
      choose_post_type("question")
      conversation_detail("question")
      feature_a_conv
      signout
      goto_homepage
      @featured_question_viewall.click
    end
    @browser.wait_until { @search_page_post.present? }
    @browser.wait_until($t) { @search_page.h3.text.include? "Search Results"}
  end


  def check_featured_blog_widget
    @browser.execute_script("window.scrollBy(0,8000)")
    @browser.wait_until($t) { @home_featured_blog.present? }
  end

  def check_featured_blog_conv
    @browser.execute_script("window.scrollBy(0,8000)")
    @browser.wait_until($t) { @featured_blog_conv.present? }
  end

  def check_featured_b_conv_link
    @browser.execute_script("window.scrollBy(0,8000)")
    @browser.wait_until { @home_featured_blog.present? }
    conv_title = @home_featured_b_link.text
    @browser.wait_until($t) { @home_featured_b_link.present? }
    @home_featured_b_link.click
    @browser.wait_until($t) { @conv_detail.present? }
  end

  def check_featured_blog_icon
    @browser.execute_script("window.scrollBy(0,8000)")
    @browser.wait_until($t) { @featured_blog_icon.present? }
  end

  def goto_featured_blog_viewall
    @browser.execute_script("window.scrollBy(0,11000)")
    @browser.wait_until($t) { @featured_blog_viewall.present? }
    @featured_blog_viewall.click

    @browser.wait_until { @search_page.present? }

    if @search_no_match.present?
      about_login("regular", "logged")
      @browser.goto @topicpage_url
      goto_topicdetail_page("engagement")
      choose_post_type("blog")
      conversation_detail("blog")
      feature_a_conv
      signout
      goto_homepage
      @browser.execute_script("window.scrollBy(0,12000)")
      @browser.wait_until($t) { @featured_blog_viewall.present? }
      @featured_blog_viewall.click
    end
    @browser.wait_until { @search_page_post.present? }
    @browser.wait_until($t) { @search_page.h3.text.include? "Search Results"}
  end

  def check_homepage_footer
    @browser.execute_script("window.scrollBy(0,10000)")
    @browser.wait_until($t) { @footer.present? }
  end

  def check_edit_button
    @browser.wait_until($t) { @home_edit.present? }
  end
  
  def edit_banner
    homebannerimage1 = File.expand_path(File.dirname(__FILE__) + "/../../seeds/development/images/chicagoRiverView.jpeg") 
    homebannerimage2 = File.expand_path(File.dirname(__FILE__) + "/../../seeds/development/images/chicagoNightView.jpg") 
    @browser.wait_until($t) { @home_edit.present? }
    @home_edit.click
    @browser.wait_until($t) { @home_edit_mode.present?}
    if @home_edit_browse_new.present?
      @home_edit_browse_new.click
    else
      assert @home_edit_change.present?
    end
    
    if $os == "windows"
      @browser.execute_script('$(".photo-upload-browse").removeClass("photo-upload-browse")')
    end
    @home_edit_file_field.set homebannerimage1
    @browser.wait_until($t) { @home_edit_selected_file.present? }
    @home_img_upload.click
    @browser.wait_until($t) { @home_img_upload.present? != true }
    @browser.wait_until($t) { @homebanner_editmode.present? }
    @browser.goto @url
    @browser.wait_until($t) { @home_topic_widget.present? }
    banner_image1 = @homebanner.style   
    assert_match /chicagoRiverView.jpeg/, banner_image1, "background url should match chicagoRiverView.jpeg"


    @home_edit.when_present.click
    
    if $os == "windows"
      @browser.execute_script('$(".photo-upload-browse").removeClass("photo-upload-browse")')
    end
    @home_edit_file_field.set homebannerimage2
    @browser.wait_until($t) { @home_edit_selected_file.present? }
    @home_img_upload.click
    @browser.wait_until($t) { @home_img_upload.present? != true }
    @browser.wait_until($t) { @homebanner_editmode.present? }
    @browser.goto @url
    @browser.wait_until($t) { @home_topic_widget.present? }
    @browser.wait_until($t) { @homebanner.present? }
    banner_image2 = @homebanner.style   
    assert_match /chicagoNightView.jpg/, "banner_image2, background url should match chicagoNightView.jpg"
  end

  def change_home_locale(locale)
    
    case locale
        when "de"   
          @browser.goto @home_de_locale_url
          @browser.wait_until($t) { @home_widget.present? }
          @browser.wait_until($t) { @featured_topic_viewall_de.present? }
          assert @featured_topic_viewall_de.present?
        when "en"
          @browser.goto @url
          @browser.wait_until($t) { @home_widget.present? }
          @browser.wait_until($t) { @featured_topic_viewall.present? }
          assert @featured_topic_viewall.present?
        else
        raise "Invalid locale! Exit.."
       end 
  end
end
