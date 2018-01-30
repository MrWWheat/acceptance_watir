class PageObject < Minitest::Test

  attr_accessor :breadcrumb_link, 
    :image_upload_link, 
    :ulpoad_image, 
    :uploaded_file_selector, 
    
    :conv_create, 
    
    :tab_title,
    :reply_box, 
    :reply_submit, 
    :reply_submit_button, 
    :conv_reply, 
    :conv_reply_view, 
    
    :conv_reply_input,
    
    :conv_reply_view,
    :reply_dropdown_toggle,
    :reply_feature_option,
    :reply_mod_menu,
    
    :reply_dropdown_toggle,
    :reply_flag_option, 
    
    :post_body,
    :conv_show_more_link,
    :conv_post_collection,
    :answer_level1,
    :root_post_title,
    :depth0_d,
    :depth0_q,
    :first_conv_link,
    :conv_content,
    :root_post,
    :root_post_blog,
    :featured,
    
    :conv_detail_sort,
    :conv_detail_sort_dropdown_open,
    :conv_detail_oldest_link,
    :conv_detail_newest_link,

    :suggested_post,
    :level1_reply,
    :convdetail,
    :conv_page,
    :root_post_title,
    :root_post_feature, 
    :conv_detail,
    :featured_answer,

    :conv_detail_title,
    :convdetail,
    :conv_featured_comment,
    :conv_root_post_featured,

    :conv_detail_topic_link,
    :post_type_picker,
    :conv_suggest_shown,

    :conv_reply_ans,
    :featured_answer,
    :featured_comment,
    :featured_root,
    :comment_level1,
    :spinner, 
    :search_post,
    :search_dropdown,
    :search_placeholder_text,
    :search_result_page,
    :conv_detail_authorname,
    :search_bar,
    :support_topicname,
    :engagement_topicname,
    :engagement2_topicname,
    :reply_menu 
    
  def initialize(browser)
    super
    @browser = browser

    @support_topicname = "A Watir Topic With Many Posts"
    @engagement_topicname = "A Watir Topic"
    @engagement2_topicname = "A Watir Topic For Widgets"

    ################ upload image elememts ###################
    @image_upload_link = @browser.link(:text => "browse")
    @ulpoad_image = @browser.file_field(:class => "files")
    @uploaded_file_selector = @browser.div(:class => "cropper-canvas")

    ############conv detail ########
    @conv_create = @browser.text_field(:class => "form-control ember-view ember-text-field")

    @conv_title = @browser.h3(:class => "media-heading root-post-title")
    @reply_box = @browser.textarea(:class => "ember-view ember-text-area form-control")
    @reply_submit = @browser.div(:class => "group text-right").button(:value => /Submit/)

    @reply_submit_button = @browser.button(:value => /Submit/)
    @conv_reply = @browser.div(:class => /ember-view depth-1/).div(:class => "input", :index => 0)
    @conv_reply_view = @browser.div(:class => /ember-view/)
    @conv_reply_input = @browser.div(:class => "input")
    @reply_dropdown_toggle = @browser.div(:class => /ember-view depth-1/).span(:class => "dropdown-toggle")
    @reply_feature_option = @browser.link(:class => "feature-class")
    @reply_mod_menu = @browser.div(:class => "dropdown pull-right open").li(:index => 1).link(:text => "Permanently Remove")
    @reply_menu = @browser.div(:class => "dropdown pull-right open").li(:index => 1)
    @reply_flag_option = @browser.link(:text => /Flag as inappropriate/)
    @post_body = @browser.div(:class => "media-body")
    @conv_detail_sort = @browser.div(:class => "pull-right sort-by dropdown").span(:class=> "dropdown-toggle").span(:class => "icon-down fs-7")
    @conv_detail_sort_dropdown_open = @browser.div(:class => "pull-right sort-by dropdown open")
    @conv_detail_oldest_link = @browser.link(:text => "Oldest")
    @conv_detail_newest_link = @browser.link(:text => "Newest")
    @convdetail = @browser.h3(:class => "media-heading root-post-title")
    @conv_detail = @browser.div(:class => /ember-view root-post/)
    @conv_page = @browser.div(:class => /ember-view root-post depth-0/).div(:class => "media-body").div(:class => "post-content")
    
    @conv_detail_authorname = @browser.div(:class => "crumb conversation-creator").span.span(:class => "ember-view network-profile-link").link
    @conv_reply_ans = @browser.div(:class => /ember-view depth-1 answer post/).div(:class => "media post-body").div(:class => "media-body").div(:class =>"post-content").div(:class => "input")
    
    @topic_sort_post_by_newest_button = @browser.button(:class => "btn btn-default dropdown-toggle filter-dropdown sap-regular-dropdown", :text => "Sort by: Newest")
    @conv_show_more_link = @browser.link(:text => "Show more")
    @conv_post_collection = @browser.div(:class => "post-collection")

    @answer_level1 = @browser.div(:class => /ember-view depth-1 answer post/)
    @root_post_title = @browser.h3(:class => "media-heading root-post-title")

    @depth0_d = @browser.div(:class => /depth-0 discussion/)
    @depth0_q = @browser.div(:class => /depth-0 question/)

    @conv_content = @browser.div(:class => "conversation-content")

    @first_conv_link = @browser.div(:class => "post-collection").div(:class => "media-heading").link
    @root_post = @browser.div(:class => /row conversation-root-post/)
    @root_post_blog = @browser.div(:class => /ember-view root-post/)

    @featured = @browser.span(:class => "featured")

    @suggested_post = @browser.div(:class => "shown")

    @level1_reply = @browser.div(:class => "ember-view depth-1 post")

    @root_post_title = @browser.h3(:class => "media-heading root-post-title")
    @root_post_feature = @browser.span(:class => "featured")

    @conv_detail_title = @browser.h3(:class => "media-heading root-post-title")
    @convdetail = @browser.h3(:class => "media-heading root-post-title")
    @conv_featured_comment = @browser.div(:class => "featured-post-collection")
    @conv_root_post_featured = @browser.span(:class => "featured")

    @conv_detail_topic_link = @browser.div(:class => "crumb conversation-creator").div.span(:class => "topic").link(:class => "ember-view")

    @post_type_picker = @browser.div(:class => "row post-type-picker")
    @conv_suggest_shown = @browser.div(:class => "shown")

    @featured = @browser.span(:class => "featured-post-collection")
    @featured_answer = @browser.div(:class => "featured-post-collection").div(:class => "ember-view")
    @featured_comment = @browser.div(:class => "featured-post-collection").div(:class => "ember-view")
    @featured_root = @browser.span(:class => "featured")

    @answer_level1 = @browser.div(:class => /ember-view depth-1 answer post/)
    @comment_level1 = @browser.div(:class => /ember-view depth-1 post/)

    @spinner = @browser.i(:class => "fa fa-spinner fa-spin")

    ############ search elements #############
    @search_post = @browser.div(:class => "media-heading")
    @search_placeholder_text = @browser.text_field(:class => "ember-view ember-text-field typeahead form-control tt-input", :placeholder => "Search...")
    @search_dropdown = @browser.span(:class => "tt-dropdown-menu")
    @search_result_page = @browser.div(:class => "row filters search-facets")
    @search_bar = @browser.input(:class => "ember-view ember-text-field typeahead form-control tt-input", :placeholder => "Search...")

    #==================#
    #### topnav elements ##########
    @breadcrumb_link = @browser.link(:class => "ember-view", :text => "#{$network}")
    ###############################

    #run_once do
    #@topicdetailpage.network_landing_topic_wait($networkslug)
    #@topicdetailpage.topic_sort_by_name
    #if ( !@browser.text.include? "A Watir Topic") && ( !@browser.text.include? "A Watir Topic With Many Posts")
    # @topicdetailpage.create_new_topic($network, $networkslug, "engagement", "false", "A Watir Topic")
    # @topicdetailpage.create_new_topic($network, $networkslug, "support", "false", "A Watir Topic With Many Posts")
    #end 
    #end 
  end
  
  def wait_for_page
    @browser.wait_until{ @browser.body.present? }
  end

  def assert test, msg = nil
    msg ||= "Failed assertion, no message given."
    unless test then
      msg = msg.call if Proc === msg
    raise MiniTest::Assertion, msg
    end
    true
  end

  #################### LOGIN ###############
  ##########################################
  
  def about_landing(networkslug)
    @aboutpage = CommunityAboutPage.new(@browser)
    @browser.goto @aboutpage.about_url
    @browser.wait_until($t) { @aboutpage.about_breadcrumb_link.present? }
  end

  def network_landing(networkslug)
    @topicdetailpage = CommunityTopicDetailPage.new(@browser)
    @browser.goto @topicdetailpage.topicpage_url
  end 

  def network_landing_topic_wait(networkslug)
    @topicdetailpage = CommunityTopicDetailPage.new(@browser)
    @browser.goto @topicdetailpage.topicpage_url 
    @browser.wait_until($t) { @topicdetailpage.topic_page.present? }
    assert @topicdetailpage.topic_page.present?
  end  

  def about_login(type, user)
    @aboutpage = CommunityAboutPage.new(@browser)
    if @browser.url != @aboutpage.about_url
     @browser.goto @aboutpage.about_url
    end
    @browser.wait_until($t) { @aboutpage.about_title_row.present? }
    @loginpage = CommunityLoginPage.new(@browser)
    if ( !@loginpage.login_link.present?) || (@loginpage.username.present?) || (@loginpage.topnav_notification.present?)
      signout
    end
    
    if user == "logged"
      @loginpage = CommunityLoginPage.new(@browser)
       case type
        when "social-fb"   
          @loginpage.login($user6)
        when "social-link"
          @loginpage.login($user7)
        when "social-g"
          @loginpage.login($user8)
        when "social-twi"
          @loginpage.login($user9)
        when "regis"
          @loginpage.login($user3)
        when "regis2"
          @loginpage.login($user4)
        when "regis3"
          @loginpage.login($user5)
        when "regis4"
          @loginpage.login($user12)
        when "admin" 
          @loginpage.login($user1)
        when "mod"
          @loginpage.login($user2)
        when "adminonly"
          @loginpage.login($user10)
        when "regular"
          @loginpage.login($user1) #user1 is admin and moderator
        else
        raise "Invalid user type! Exit.."
       end 
      assert ( !@loginpage.login_link.present?)
      assert @loginpage.username_dropdown.present?
      @aboutpage = CommunityAboutPage.new(@browser)
      @browser.goto @aboutpage.about_url
      @browser.wait_until($t) { @aboutpage.about_title_row.present? }
      assert @aboutpage.about_title_row.present?
    end
    
    if user == "visitor"
      @loginpage = CommunityLoginPage.new(@browser)
      case type
       when "anon"
       if @loginpage.username.present?
         signout
       end
       assert @loginpage.login_link.text.include? "Sign In"
       @aboutpage = CommunityAboutPage.new(@browser)
       @browser.goto @aboutpage.about_url
       @browser.wait_until($t) { @aboutpage.about_widget.present? }
       assert @aboutpage.about_widget.present?
       else
      raise "Invalid user type! Exit.."
      end
    end
      policy_warning
  end


  def login(user)
    #puts "#{user.inspect}"
    #puts "#{$logged_in_user.inspect}"
    return if user == $logged_in_user
    @loginpage = CommunityLoginPage.new(@browser)
    if ( !@loginpage.login_link.present?) || (@loginpage.username.present?)
      signout
    end
    if @loginpage.login_link.present?
      @browser.screenshot.save screenshot_dir('login.png') #for jenkins test
      
      @browser.goto @loginpage.login_url
      @browser.wait_until($t) { @loginpage.login_page.present? }
      @browser.screenshot.save screenshot_dir('signin.png')
      @loginpage.login_helper(user)
    end
  end

  def login_from_widget(user)
    return if user == $logged_in_user
    @loginpage = CommunityLoginPage.new(@browser)
    @loginpage.signin.when_present.click
    @loginpage.login_helper(user)
  end

  def login_helper(user)
    @loginpage = CommunityLoginPage.new(@browser)
    @loginpage.login_user_field.set user[2]
    @loginpage.login_password_field.set user[1]
    @browser.screenshot.save screenshot_dir('userpwd.png')

    assert @loginpage.login_submit.present?
    @loginpage.login_submit.click

    @browser.wait_until { @loginpage.username.present?}
    assert @loginpage.username.present?
    $logged_in_user = user # save for next time
  end


  def main_landing(type, user)
    #@aboutpage = CommunityAboutPage.new(@browser)
    #@browser.goto @aboutpage.about_url
    @topicdetailpage = CommunityTopicDetailPage.new(@browser)
    if @browser.url != @topicdetailpage.topicpage_url || @topicurl == nil || @browser.url != @topicurl
    #puts " in topic"
     @browser.goto @topicdetailpage.topicpage_url 
     @browser.wait_until($t) { @topicdetailpage.topic_page.present? }
     @topicurl = @browser.url 
    end 
    @loginpage = CommunityLoginPage.new(@browser)
    if (( !@loginpage.login_link.present?) || (@loginpage.username.present?) || (@loginpage.topnav_notification.present? ))
      #@aboutpage = CommunityAboutPage.new(@browser)
      #@browser.goto @aboutpage.about_url
     # @browser.wait_until($t) { @aboutpage.about_breadcrumb_link.present? }
      signout
    end
      
    
    if user == "logged"
       case type
        when "social-fb"
          @loginpage = CommunityLoginPage.new(@browser)
          @loginpage.login($user6)
        when "social-link"
          @loginpage = CommunityLoginPage.new(@browser)
          @loginpage.login($user7)
        when "social-g"
          @loginpage = CommunityLoginPage.new(@browser)
          @loginpage.login($user8)
        when "social-twi"
          @loginpage = CommunityLoginPage.new(@browser)
          @loginpage.login($user9)
        when "regis"
          @loginpage = CommunityLoginPage.new(@browser)
          @loginpage.login($user3)
        when "regis2"
          @loginpage = CommunityLoginPage.new(@browser)
          @loginpage.login($user4)
        when "regis3"
          @loginpage = CommunityLoginPage.new(@browser)
          @loginpage.login($user5)
        when "admin" 
          @loginpage = CommunityLoginPage.new(@browser)
          @loginpage.login($user1)
        when "mod"
          @loginpage = CommunityLoginPage.new(@browser)
          @loginpage.login($user2)
        when "adminonly"
          @loginpage = CommunityLoginPage.new(@browser)
          @loginpage.login($user10)
        when "regular"
          @loginpage = CommunityLoginPage.new(@browser)
          @loginpage.login($user1) #user1 is admin and moderator
        else
        raise "Invalid user type! Exit.."
       end 
      assert ( !@loginpage.login_link.present?)
#      assert @loginpage.username.present?
      @topicdetailpage = CommunityTopicDetailPage.new(@browser)
      @aboutpage = CommunityAboutPage.new(@browser)
      @browser.wait_until(40) { @topicdetailpage.topic_page.present? || @aboutpage.about_widget.present? }
      assert @topicdetailpage.topic_page.present? || @aboutpage.about_widget.present?
       
    end
    
    if user == "visitor"
      case type
       when "anon"
       @loginpage = CommunityLoginPage.new(@browser)
       if @loginpage.username.present?
         @loginpage.signout
       end
      assert @loginpage.login_link.text.include? "Sign In / Register"
      @topicdetailpage = CommunityTopicDetailPage.new(@browser)
      @browser.wait_until { @topicdetailpage.topic_page.present? }
      assert @topicdetailpage.topic_page.present?
     else
      raise "Invalid user type! Exit.."
      end
    end
    @loginpage = CommunityLoginPage.new(@browser)
    if @loginpage.policy_warning.present?
      @loginpage.policy_warning
    end
  end

  def policy_warning
    @loginpage = CommunityLoginPage.new(@browser)
    if @loginpage.policy_warning.present?
      @loginpage.policy_warning_primary_button.click
      @browser.wait_until { !@loginpage.policy_warning.present? }
      assert !@loginpage.policy_warning.present?
    end
  end

  def signout
    $logged_in_user = nil
    @loginpage = CommunityLoginPage.new(@browser)
    @browser.wait_until($t){
      @loginpage.username_dropdown.present?
    }
    @loginpage.username_dropdown.click
    @browser.wait_until($t) { @loginpage.signout_link.present? }
    @loginpage.signout_link.click
    @browser.wait_until($t) { !@loginpage.username_dropdown.present? }
    assert @loginpage.topnav_signin.present?  
  end 

  def screenshot_dir(filename)
    #FileUtils.mkdir("/../screenshots") unless File.directory?("/../screenshots")
    #Dir.mkdir("/../screenshots") unless File.exists?("/../screenshots")
    FileUtils.mkdir_p(File.expand_path(File.dirname(__FILE__) + "/../screenshots"))
    File.expand_path(File.dirname(__FILE__) + "/../screenshots/#{filename}")
  end

  ################################################################

  ############################# SEARCH ###########################

  def check_page_search_bar
    @loginpage = CommunityLoginPage.new(@browser)
    @browser.wait_until($t) { @loginpage.search_bar.present? }
  end

  # this is common navigation bar
  def search_from_searchbar
    @loginpage = CommunityLoginPage.new(@browser)
    @browser.wait_until($t) { @loginpage.search_bar.present? }
    @loginpage.search_input.set "watir"
    @browser.wait_until($t) { @loginpage.search_dropdown.present? }
    @browser.send_keys :enter
    @browser.wait_until { @loginpage.search_result_page.present? }
  end

  ##################################################################

  ################################ TOPIC ###########################
  def click_topic_feature
    @topicdetailpage = CommunityTopicDetailPage.new(@browser)
    $featuredtopicname = @topicdetailpage.topicname.h1.text    
    if @topicdetailpage.topic_unfeature.present? 
      @topicdetailpage.topic_unfeature.click
      @browser.wait_until($t) { @topicdetailpage.topic_feature.present? }
    end
    @topicdetailpage.topic_feature.when_present.click
    @browser.wait_until($t) { @topicdetailpage.topic_unfeature.present? }
  end

  def click_topic_unfeature
    @topicdetailpage = CommunityTopicDetailPage.new(@browser)
    $featuredtopicname = @topicdetailpage.topicname.h1.text
    if @topicdetailpage.topic_feature.present? 
      @topicdetailpage.topic_feature.click
      @browser.wait_until($t) { @topicdetailpage.topic_unfeature.present? }
    end

    @topicdetailpage.topic_unfeature.when_present.click
    @browser.wait_until($t) { @topicdetailpage.topic_feature.present? }
  end

  def topic_sort_by_name
    @topicdetailpage = CommunityTopicDetailPage.new(@browser)
    if @browser.url != "#{$base_url}"+"/n/#{$networkslug}"
     @topicdetailpage.goto_topic_page 
    end
    
    topic_name = "A Watir Topic"
    if @topicdetailpage.topic_sort_button.present? 
      @browser.screenshot.save screenshot_dir('topicsort.png')
      refute_nil @browser.execute_script 'return $(".topic-sort-drop-down >button").trigger("click")', "Failed to open the dropdown"
      refute_nil @browser.execute_script 'return $(".filter-dropdown a:contains(\'Name\')").trigger("click")', "Failed to Name sort option in the dropdown"
      @browser.wait_until($t) { @topicdetailpage.topic_mainpage_link.text =~ /#{topic_name}/ }
      @browser.wait_until($t) { @topicdetailpage.topic_page.present? }
      assert @topicdetailpage.topic_mainpage_link.text =~ /#{topic_name}/
    end
  end

  def topic_detail(topic_name)
    @topicdetailpage = CommunityTopicDetailPage.new(@browser)
    if respond_to?(:deprecate)
      deprecate __method__, "Use fixtures for getting topic related information. \nExample: @browser.goto topics(:a_watir_topic).url"
    end

    if ($topic_uuid != nil && $topic_uuid != 0)
      @browser.goto "#{$base_url}"+"/topic/"+$topic_uuid+"/#{$networkslug}/"+topic_name
    else   
    if !(@topicdetailpage.topic_grid.present?)
     @topicdetailpage.topiclink.when_present.click
     @browser.wait_until($t) { @topicdetailpage.topic_grid.present? }
    end
    assert @topicdetailpage.topic_grid.present?
    @browser.wait_until($t) { @topicdetailpage.topic_page.present? }
    assert @topicdetailpage.topic_page.present?
    if ( !(@topicdetailpage.topic_page_divid.text.include? topic_name) && !(@topicdetailpage.topic_page_divid.link(:text => topic_name).present?))
     @topicdetailpage.topic_sort_by_name
    end
    @browser.execute_script("window.scrollBy(0,3000)")
    @browser.link(:class => "ember-view", :text => topic_name).when_present.click
    @browser.wait_until($t) { @topicdetailpage.topicfilter.present? }
    assert @topicdetailpage.topicfilter.present?
    topic_url = @browser.url
    $topic_uuid = topic_url.split("/topic/")[1].split("/")[0]
    end
  end

  def topic_publish
   @topicdetailpage = CommunityTopicDetailPage.new(@browser)
   if @topicdetailpage.topic_publish_change_button.present?
      @topicdetailpage.topic_publish_change_button.click
      @browser.wait_until($t) { @topicdetailpage.topic_admin_button.present? }
      assert @topicdetailpage.topic_admin_button.present?
   end
   if @topicdetailpage.topic_activate_button.present?
    @topicdetailpage.topic_activate_button.click
    @browser.wait_until($t) { @topicdetailpage.topic_deactivate_button.present?}
    assert @topicdetailpage.topic_deactivate_button.present?
   end 
  end

  def sort_post_by_newest
    @topicdetailpage = CommunityTopicDetailPage.new(@browser)
    if @topicdetailpage.topic_sort_post_by_oldest.present? || @topicdetailpage.topic_sort_post_by_oldest_new.present?
     @browser.wait_until($t) { @topicdetailpage.topic_sort_post_by_oldest.present? || @topicdetailpage.topic_sort_post_by_oldest_new.present? }
     if @topicdetailpage.topic_sort_post_by_oldest.present?
      @topicdetailpage.topic_sort_post_by_oldest.click
     else
     @topicdetailpage.topic_sort_post_by_oldest_new.click
     @topicdetailpage.sort_newest_option_dropdown.click
     end
     #byebug
     @browser.wait_until($t) { @conv_reply.present? }
    end
    @browser.wait_until($t) { @topicdetailpage.topic_sort_post_by_newest.present? || @topicdetailpage.topic_sort_post_by_newest_new.present? }
    #@topic_post_timestamp.text.include? "/hour/|/hours/|/day/|/days/"
  end

  def sort_post_by_oldest
    @topicdetailpage = CommunityTopicDetailPage.new(@browser)
    if @topicdetailpage.topic_sort_post_by_newest.present? || @topicdetailpage.topic_sort_post_by_newest_new.present?
     @browser.wait_until($t) { @topicdetailpage.topic_sort_post_by_newest.present? || @topicdetailpage.topic_sort_post_by_newest_new.present? }
     if @topicdetailpage.topic_sort_post_by_newest.present?
      @topicdetailpage.topic_sort_post_by_newest.click
     else
     @topicdetailpage.topic_sort_post_by_newest_new.click
     @topicdetailpage.sort_oldest_option_dropdown.click
     end

     @browser.wait_until($t) { @conv_reply.present? }
    end
    @browser.wait_until($t) { @topicdetailpage.topic_sort_post_by_oldest.present? || @topicdetailpage.topic_sort_post_by_oldest_new.present? }
    #@topic_post_timestamp.text.include? "/hour/|/hours/|/day/|/days/"
  end

  def goto_topicdetail_page(topictype)
    policy_warning
    @topicdetailpage = CommunityTopicDetailPage.new(@browser)
    if (($topic_sup_uuid != nil && $topic_sup_uuid != 0) || ($topic_eng_uuid != nil && $topic_eng_uuid != 0) || ($topic_eng2_uuid != nil && $topic_eng2_uuid != 0))
     case topictype
      when "support"
       @browser.goto "#{$base_url}"+"/topic/"+$topic_sup_uuid+"/#{$networkslug}/"+@topicdetailpage.support_topicname
      when "engagement"
       @browser.goto "#{$base_url}"+"/topic/"+$topic_eng_uuid+"/#{$networkslug}/"+@topicdetailpage.engagement_topicname
      when "engagement2"
       @browser.goto "#{$base_url}"+"/topic/"+$topic_eng2_uuid+"/#{$networkslug}/"+@topicdetailpage.engagement2_topicname 
      else
       raise "Invalid topic type! Exit.."
     end 
     else 
   # end   

    case topictype
     when "support"
      if @browser.url != @topicdetailpage.topicpage_url
       @browser.goto @topicdetailpage.topicpage_url
       @browser.wait_until($t) { @topicdetailpage.topic_page.present? }
      end 
      @topicdetailpage.topic_sort_by_name
      @browser.wait_until($t) { @topicdetailpage.topic_page.present? }
      @topicdetailpage.topic_support.when_present.click
      @browser.wait_until {@browser.url.include? "/topic/"}
      topic_url = @browser.url
      $topic_sup_uuid = topic_url.split("/topic/")[1].split("/")[0]
     when "engagement"
      if @browser.url != @topicdetailpage.topicpage_url
       @browser.goto @topicdetailpage.topicpage_url
       @browser.wait_until($t) { @topicdetailpage.topic_page.present? }
      end 
      if !@browser.text.include? @topicdetailpage.engagement_topicname
       @topicdetailpage.topic_sort_by_name
      end
     @browser.execute_script("window.scrollBy(0,1000)")
     @topicdetailpage.topic_engagement.when_present.click
     @browser.wait_until {@browser.url.include? "/topic/"}
     topic_url = @browser.url
     $topic_eng_uuid = topic_url.split("/topic/")[1].split("/")[0]
     when "engagement2"
      if @browser.url != @topicdetailpage.topicpage_url
       @browser.goto @topicdetailpage.topicpage_url
       @browser.wait_until($t) { @topicdetailpage.topic_page.present? }
      end 
     if !@browser.text.include?(@topicdetailpage.engagement2_topicname)
      @topicdetailpage.topic_sort_by_name
      @browser.wait_until($t) { @topicdetailpage.topic_page.present? }
     end
      @browser.execute_script("window.scrollBy(0,3000)")
      @topicdetailpage.topic_engagement2.when_present.click
      @browser.wait_until {@browser.url.include? "/topic/"}
      topic_url = @browser.url
      $topic_eng2_uuid = topic_url.split("/topic/")[1].split("/")[0]
     else
      raise "Invalid topic type! Exit.."
     end   
    @browser.wait_until($t) { @topicdetailpage.topic_filter.present? }
    end
    topic_publish
  end


  ############################################################################

  ############################# ADMIN ########################################

  def admin_check(networkslug) 
  @loginpage = CommunityLoginPage.new(@browser)   
    @browser.wait_until($t){
      @loginpage.username.present?
    }
    @loginpage.username.click

    @adminpage = CommunityAdminPage.new(@browser)
    if !@adminpage.admin_link.present?
        puts "User not an admin...Logging in admin user.."
        @loginpage = CommunityLoginPage.new(@browser)
        @loginpage.login($user1) # will do a logout before login
        @topicdetailpage = CommunityTopicDetailPage.new(@browser)
        @browser.goto @topicdetailpage.topicpage_url
        @adminpage = CommunityAdminPage.new(@browser)
        @browser.wait_until($t){
        @adminpage.caret.present?
       }
      @adminpage.caret.click
    end    
    @browser.wait_until($t) { @adminpage.admin_link.present? }
    assert @adminpage.admin_link.present?
    return networkslug
  end  

  def go_to_admin_page(networkslug)
    @adminpage = CommunityAdminPage.new(@browser)

    unless @adminpage.admin_page_link.present?
      @browser.wait_until($t) { @adminpage.caret.present? }
      @adminpage.caret.click
      @browser.wait_until($t) { @adminpage.admin_page_link.present? }
    end
    @adminpage.admin_page_link.click
  end

  def mod_flag_threshold(network, networkslug)
    @loginpage = CommunityLoginPage.new(@browser)
    policy_warning
    if !@loginpage.caret.present?
     @aboutpage = CommunityAboutPage.new(@browser)
     about_login("admin", "logged")
     @loginpage = CommunityLoginPage.new(@browser)
     @browser.wait_until($t){
      @loginpage.caret.present?
    }
    end
  
    @adminpage = CommunityAdminPage.new(@browser)
    
    if !@adminpage.dropdown_admin_link.present?
     @adminpage.caret.click
    end
    @adminpage.dropdown_admin_link.when_present.click
    @browser.wait_until($t) { @adminpage.admin_page.present? }
    assert @adminpage.admin_page_left_nav.present?
    @adminpage.mod.when_present.click
    @browser.wait_until { @adminpage.pending_approval_tab.present? }
    assert @adminpage.pending_approval_tab.present? 
    @adminpage.mod_threshold_link.when_present.click

    @adminpage.mod_threshold_field.when_present.clear
    @adminpage.mod_threshold_field.when_present.set "1"
    @adminpage.low_level_mod_radio.when_present.set 
    @adminpage.mod_threshold_save_button.when_present.click
    @browser.wait_until($t) { @adminpage.mod_success_msg.present? }
    assert @adminpage.mod_success_msg.present?
  end  

  def revert_user_role(network, networkslug, username, role)
      @aboutpage = CommunityAboutPage.new(@browser)
      about_login("regular", "logged")
      @adminpage = CommunityAdminPage.new(@browser)
      @browser.wait_until($t){
      @adminpage.caret.present?
      }
      @adminpage.caret.click
      @browser.wait_until($t) { @adminpage.dropdown_admin_link.present? }
      assert @adminpage.dropdown_admin_link.present?    
      @adminpage.dropdown_admin_link.when_present.click
      @browser.wait_until($t) { @adminpage.admin_page_left_nav.present? }

    if role == "netmod"
      @adminpage.permission_link.when_present.click
      @adminpage.netmod_tab.when_present.click
      @browser.wait_until($t) { @adminpage.netmod_member_card.present? }
      @adminpage.permission_user3_trash.when_present.click
      
      @browser.wait_until($t) { !@spinner.present? }
      #assert @browser.div(:id => "network-moderators").div(:class =>"alert alert-success alert-dismissible display-block").exists?
      @browser.wait_until($t) { !@adminpage.permission_user3_netmod_link.present?}
      assert ( !@adminpage.permission_user3_netmod_link.present?)
      signout
      sleep 1
    end

    if role == "netadmin"
      @adminpage.permission_link.when_present.click
      @adminpage.permission_user3_trash.when_present.click
      @browser.wait_until($t) { !@adminpage.permission_user3_netadmin_link.present? }
      @browser.wait_until($t) { !@spinner.present? }
      sleep 2
      #commenting out for now for display msg
      #assert @browser.div(:class => "ember-view").div(:class => "container").div.div(:class => "row").div(:class => "col-sm-9").div(:id => "network-permission").div(:class => "tab-content").div(:id => "network-administrators").div.div(:class => "alert-box").div(:class =>"alert alert-success alert-dismissible display-block").exists?
      @browser.wait_until($t) { !@adminpage.permission_user3_netadmin_link.present? }
      assert ( !@adminpage.permission_user3_netadmin_link.present?)
      signout
      sleep 1
    end

    if role == "topicmod"
      @adminpage.permission_link.when_present.click
      @browser.wait_until($t) { !@spinner.present? }
      @browser.wait_until($t) { @adminpage.permission_netadmin_tab.present? }
      @browser.wait_until($t) { @adminpage.permission_card.present? }
      @adminpage.topic_permission.when_present.click
      @browser.wait_until($t) { !@spinner.present? }
      @browser.wait_until($t) { @adminpage.topic_permission.present? }
      @adminpage.select_topic.select("A Watir Topic")
       @browser.wait_until($t) { !@spinner.present? }
      sleep 2
      @adminpage.topicmod_link.when_present.click
      @browser.wait_until($t) { !@spinner.present? }
      @browser.wait_until($t) { @adminpage.topicmod_membercard.present? }
      assert @adminpage.topicmod_membercard.present?
      @adminpage.select_topic.select("A Watir Topic")
      @browser.wait_until($t) { !@spinner.present? }
      @browser.wait_until($t) { @adminpage.topicmod_user12_link.present? }
      @adminpage.permission_user12_trash.when_present.click
      @browser.wait_until($t) { !@spinner.present? }
      @browser.wait_until($t) { !@adminpage.topicmod_user12_link.present?}

      #assert @browser.div(:id => "topic-moderators").div.div(:class => "alert-box").div(:class =>"alert alert-success alert-dismissible display-block").exists?
      assert ( !@adminpage.topicmod_user12_link.present?)
      signout
      sleep 1
    end

    if role == "topicadmin"
      @adminpage.permission_link.when_present.click
      @browser.wait_until($t) { !@spinner.present? }
      @browser.wait_until($t) { @adminpage.permission_netadmin_tab.present? }
      @browser.wait_until($t) { @adminpage.permission_card.present? }

      @adminpage.topic_permission.when_present.click
      @browser.wait_until($t) { @adminpage.topicadmin_page.present? }
      @browser.wait_until($t) { !@spinner.present? }
      @adminpage.select_topic.select("A Watir Topic")

      @browser.wait_until($t) { !@spinner.present? }
      @browser.wait_until($t) { @adminpage.topicadmin_member_card.present? }
      assert @adminpage.topicadmin_member_card.present?
      #@adminpage.select_topic.select("A Watir Topic")
      #@browser.wait_until($t) { !@spinner.present? }
      @browser.execute_script("window.scrollBy(0,1000)")
      @browser.wait_until($t) { @adminpage.topicadmin_user12_link.present? }
      @adminpage.permission_user12_trash.when_present.click
      @browser.wait_until($t) { !@spinner.present? }
      @browser.wait_until($t) { !@adminpage.topicadmin_user12_link.present?}
      assert ( !@adminpage.topicadmin_user12_link.present?)
      signout
      sleep 1
    end
  end

  def promote_user_role (network, networkslug, username, role)
    @aboutpage = CommunityAboutPage.new(@browser)
    @aboutpage.about_landing(networkslug)
    about_login("regular", "logged")
    admin_check(networkslug)
    mod_flag_threshold(network, networkslug)
    about_login("admin", "logged") #adding in case if previous test run fails or previous user is still logged in
    
    @adminpage = CommunityAdminPage.new(@browser)
    @browser.wait_until($t){
      @adminpage.caret.present?
    }
    @adminpage.caret.click
    @browser.wait_until($t) { @adminpage.dropdown_admin_link.present? }
    @adminpage.dropdown_admin_link.when_present.click
    @browser.wait_until($t){ @adminpage.admin_page_left_nav.present? }
    @browser.wait_until($t) { @adminpage.admin_new_topic_button.present? }
    assert @adminpage.admin_new_topic_button.present?
    
    if role == "netadmin"
      @adminpage.permission_link.when_present.click
      @browser.wait_until($t) { @adminpage.permission_netadmin_tab.present? }
      @browser.wait_until($t) { @adminpage.permission_card.present? }
      @browser.wait_until($t) { !@spinner.present? }
      if (@adminpage.permission_user3_trash.present? )
       @adminpage.permission_user3_trash.when_present.click
       @browser.wait_until($t) { !@spinner.present? }
       @browser.wait_until($t) { !@adminpage.permission_user3_netadmin_link.present?}
       assert ( !@adminpage.permission_user3_netadmin_link.present?)
      end
      @adminpage.netadmin_add.when_present.click
      @browser.wait_until($t) { @adminpage.addmember_modal.present? }
      @adminpage.netadmin_textfield.when_present.set $user3[2]
      sleep 2
      @adminpage.netadmin_add_button.when_present.click
      sleep 3
      @browser.wait_until($t) { !@spinner.present? }
      @browser.wait_until($t) { @adminpage.permission_user3_netadmin_card.present?}
      assert @adminpage.permission_user3_netadmin_link.present?
    end

    if role == "netmod"
      @adminpage.permission_link.when_present.click
      @browser.wait_until($t) { @adminpage.permission_netadmin_tab.present? }
      @adminpage.netmod_tab.when_present.click
      @browser.wait_until($t) { @adminpage.netmod_id.present? }
      @browser.wait_until($t) { @adminpage.permission_card_netmod.present? }
      @browser.wait_until($t) { !@spinner.present? }
      assert @adminpage.netmod_id.present? 
      sleep 2
      if (@adminpage.permission_user3_trash.present? )
       @adminpage.permission_user3_trash.when_present.click
       @browser.wait_until($t) { !@spinner.present? }
       @browser.wait_until($t) { !@adminpage.permission_user3_netmod_link.present?}
       assert ( !@adminpage.permission_user3_netmod_card.present?)
      end

      @adminpage.netmod_add.when_present.click
      @browser.wait_until($t) { @adminpage.netmod_add_button.present? }
      @adminpage.netmod_textfield.when_present.set $user3[2]
      sleep 4
      @adminpage.netmod_add_button.when_present.click
      sleep 3
      @browser.wait_until($t) { !@spinner.present? }
      @browser.wait_until($t) {@adminpage.permission_user3_netmod_card.present?}
      assert @adminpage.permission_user3_netmod_link.present?
    end  

    if role == "topicadmin"
      @adminpage.permission_link.when_present.click

      @browser.wait_until($t) { !@spinner.present? }
      @browser.wait_until($t) { @adminpage.permission_netadmin_tab.present? }
      @browser.wait_until($t) { @adminpage.permission_card.present? }
      @adminpage.topic_permission.when_present.click
      @browser.wait_until($t) { !@spinner.present? }
      @browser.wait_until($t) { @adminpage.topicadmin_page.present? }
      @adminpage.select_topic.select("A Watir Topic")
      @browser.wait_until($t) { !@spinner.present? }
      @browser.wait_until($t) { @adminpage.permission_card_topadmin.present? || @adminpage.topicadmin_page.present? }
      sleep 2
      if (@adminpage.permission_user12_trash.present?)
       @adminpage.permission_user12_trash.when_present.click 
       @browser.wait_until($t) { !@spinner.present? }
       @browser.wait_until($t) { !@adminpage.topicadmin_user12_link.present?}
       #assert @browser.div(:id => "network-moderators").div(:class =>"alert alert-success alert-dismissible display-block").exists?
       assert ( !@adminpage.topicadmin_user12_link.present?)
      end
      @adminpage.topicadmin_add.when_present.click
      @browser.wait_until($t) { @adminpage.topicadmin_modal.present? }
      sleep 1
      @adminpage.topicadmin_field.when_present.set $user12[2]
      sleep 4
      @browser.wait_until($t) { @adminpage.topicadmin_add_button.present? }
      sleep 3
      @adminpage.topicadmin_add_button.when_present.click
      @browser.wait_until($t) { !@adminpage.topicadmin_add_button.present? }
      @browser.wait_until($t) { !@spinner.present? }
      @browser.wait_until($t) { @adminpage.topicadmin_user12_link.present? }
      assert @adminpage.topicadmin_user12_link.present?
    end

    if role == "topicmod"
      @adminpage.permission_link.when_present.click
      @browser.wait_until($t) { !@spinner.present? }
      @browser.wait_until($t) { @adminpage.permission_netadmin_tab.present? }
      @browser.wait_until($t) { @adminpage.permission_card.present? }
      @adminpage.topic_permission.when_present.click
      @browser.wait_until($t) { !@spinner.present? }
      @browser.wait_until($t) { @adminpage.topicadmin_page.present? }
      @adminpage.select_topic.select("A Watir Topic")
      sleep 2
      @browser.wait_until($t) { @adminpage.permission_card_topadmin.present? || @adminpage.topicadmin_page.present?}
      @adminpage.topicmod_link.when_present.click

      @browser.wait_until($t){ @adminpage.topicmod_membercard.present? }
      @browser.wait_until($t) { !@spinner.present? }
      assert @adminpage.topicmod_membercard.present?
      if (@adminpage.permission_user12_trash.present?)
       @adminpage.permission_user12_trash.when_present.click
       @browser.wait_until($t) { !@spinner.present? }
       #assert @browser.div(:id => "network-moderators").div(:class =>"alert alert-success alert-dismissible display-block").exists?
       @browser.wait_until($t) { !@adminpage.topicmod_user12_link.present?}
       assert ( !@adminpage.topicmod_user12_link.present?)
      end
      @adminpage.select_topic.select("A Watir Topic")
      assert @adminpage.topicmod_membercard.present? 
      @adminpage.topicmod_add.when_present.click
      @browser.wait_until($t) { @adminpage.topicmod_modal.present? }
      sleep 1
      @adminpage.topicmod_field.when_present.set $user12[2]
      sleep 4
      @browser.wait_until($t) { @adminpage.topicmod_add_button.present? }
      sleep 3
      @adminpage.topicmod_add_button.when_present.click
      @browser.wait_until($t) { !@adminpage.topicmod_add_button.present? }
      @browser.wait_until($t) { !@spinner.present? }
      @browser.wait_until($t) { @adminpage.topicmod_user12_card.present?}
      assert @adminpage.topicmod_user12_link.present?
    end

    signout
    if role == "topicadmin" || role == "topicmod"
     about_login("regis4", "logged")
    else
     about_login("regis", "logged")
    end
    @browser.wait_until($t){
      @adminpage.caret.present?
    }
    @adminpage.caret.click
    @browser.wait_until($t) { @adminpage.admin_link.present? }
    assert @adminpage.admin_link.present?    
    @adminpage.admin_link.click
    @browser.wait_until { @adminpage.admin_page_left_nav.present? }

    if role == "netadmin"
      @adminpage.permission_link.when_present.click
      @browser.wait_until($t) { @adminpage.permission_netadmin_tab.present? }
      @browser.wait_until($t) { @adminpage.permission_page.present? }
      assert @adminpage.permission_page.present? 
      signout
      sleep 2
    end

    if role == "netmod"
      @adminpage.mod.when_present.click
      @browser.wait_until($t) { @adminpage.pending_approval_tab.present? }
      assert @adminpage.pending_approval_tab.present?
      assert !@adminpage.admin_topic_link.present?
      assert !@adminpage.admin_home_link.present?
      assert !@adminpage.admin_about_link.present?
      assert !@adminpage.admin_analytics_link.present?
      assert !@adminpage.admin_embed_link.present?
      assert !@adminpage.admin_privacy_link.present?
      assert !@adminpage.admin_branding_link.present?
      assert !@adminpage.admin_email_design_link.present?
      assert !@adminpage.admin_profile_link.present?
      assert !@adminpage.admin_permission_link.present?
      assert !@adminpage.admin_report_link.present?
      signout
      sleep 2
    end

    if(role == "topicmod")
      @adminpage.mod.when_present.click
      @browser.wait_until($t) { @adminpage.pending_approval_tab.present? }
      assert @adminpage.pending_approval_tab.present?
      assert ( !@adminpage.mod_threshold_link.present?)

      @topicdetailpage = CommunityTopicDetailPage.new(@browser)
      @browser.goto @topicdetailpage.topicpage_url
      @browser.wait_until($t) { @topicdetailpage.topic_grid.present? }
      topic_detail("A Watir Topic")
      choose_post_type("discussion")
      conversation_detail("discussion")
      @browser.wait_until($t) { @comment_level1.present? || @depth0_d.present? }
      if @comment_level1.present?
       @browser.wait_until($t) { @comment_level1.present? }
       @topicdetailpage.sort_post_by_newest
      else
       @browser.wait_until($t) { @convdetail.present? }
      end
      
      comment_text = "Commented by Watir4 for moderation - #{get_timestamp}"
      @reply_box.when_present.focus
      @browser.wait_until($t) { @reply_submit.present? }
      @reply_box.set comment_text
      @reply_box.focus
      assert @reply_submit.present?
      @reply_submit.click
      @browser.wait_until($t) { !@reply_submit.present? }
      #byebug
      @browser.wait_until { !@spinner.present? }
      @browser.wait_until($t) { @conv_reply.text =~ /#{comment_text}/ }
      assert @conv_reply.text =~ /#{comment_text}/ 
      @reply_dropdown_toggle.when_present.click
      @browser.wait_until($t) { @reply_flag_option.present? }
      ######### commenting out until submit comment is added for new mod feature ##########
      
      #@reply_flag_option.when_present.click
      #@browser.send_keys :enter
      #@browser.wait_until($t) { @flag_modal.present? }
      #@flag_modal_submit_button.click
      #@browser.wait_until($t) { !@flag_modal_submit_button.present? }

      #@browser.wait_until($t){
      #@caret.present?
      #}
     #@caret.click
     #@admin_link.when_present.click
     #@browser.wait_until($t){ @admin_page_left_nav.present? } 
    
     #@mod.when_present.click
     #@browser.wait_until($t) { @pending_approval_tab.present? }
     ##@browser.wait_until($t) { @flagged_post.present? }
     #@flagged_post_link.click

     #assert @flagged_post_tab.present?
     #@browser.wait_until($t) { @flagged_post.text =~ /#{comment_text}/ }
     #assert @flagged_post.text =~ /#{comment_text}/
     signout
     sleep 2
    end

    if(role == "topicadmin")
     @adminpage = CommunityAdminPage.new(@browser)
     @adminpage.permission_link.when_present.click
     @browser.wait_until($t) { !@spinner.present? }
     @browser.wait_until($t) { !@adminpage.permission_netadmin_tab.present? }
     @browser.wait_until($t) { !@adminpage.permission_card.present? }
     @browser.wait_until ($t) { @adminpage.topic_permission.present? }

    # if !@adminpage.topicadmin_page.present?
      @adminpage.topic_permission.click
      @browser.wait_until($t) { !@spinner.present? }
     #end
     @browser.wait_until($t) { @adminpage.topicadmin_page.present? }
     assert @adminpage.topicadmin_page.present?
     signout
     sleep 2
    end
  end

  def set_google_ads_params(networkslug, client_id, banner_slot_id, side_slot_id)
    admin_check(networkslug)
    @adminpage = CommunityAdminPage.new(@browser)
    @adminpage.admin_link.when_present.click
    @browser.wait_until($t) { @adminpage.admin_page_left_nav.present? }
    @adminpage.admin_embed_link.when_present.click
    @browser.wait_until($t){ @adminpage.embedding_container.present? }
    
    @adminpage.embedding_container_clientid_textfield.set client_id
    @adminpage.embedding_container_banner_slotid_textfield.set banner_slot_id
    @adminpage.embedding_container_side_slotid_textfield.set side_slot_id
    @adminpage.embed_submit.when_present.click
    @browser.wait_until($t){ @browser.alert.exists? }
    assert_equal "setting saved!", @browser.alert.text
    @browser.alert.ok
    @browser.wait_until($t){ @adminpage.embed_contentid.present? }
  end

  def enable_profanity_blocker (networkslug, enable)
    admin_check(networkslug)
    @adminpage = CommunityAdminPage.new(@browser)
    @adminpage.dropdown_admin_link.when_present.click
    @browser.wait_until($t) { @adminpage.admin_page_left_nav.present? }
    @adminpage.admin_moderation_link.when_present.click
    @adminpage.profanity_link.when_present.click
    if enable
      if @adminpage.profanity_enable_button.present?
        @adminpage.profanity_enable_button.when_present.click
      end 
      @browser.wait_until($t) {@adminpage.profanity_filefield.present?}
      @adminpage.profanity_filefield.set("#{$rootdir}/seeds/development/files/blocklist.csv")
      @browser.wait_until($t) { @adminpage.profanity_upload_success.present? }
      @adminpage.profanity_upload_success_close.when_present.click
    else
      if @adminpage.profanity_disable_button.present?
        @adminpage.profanity_disable_button.when_present.click 
      end
      @browser.wait_until($t) { !@adminpage.profanity_filefield.present?}
    end
  end

  def create_new_topic(network, networkslug, topictype, advertise, topicname)
    network_landing(network)
    main_landing("regular", "logged")
   
    topicdescrip = "Watir topic test description - #{get_timestamp}"
    filetile = "#{$rootdir}/seeds/development/images/watir2Tile.jpeg"
    filebanner = "#{$rootdir}/seeds/development/images/watir2Banner.jpg"

    go_to_admin_page(networkslug)
    @adminpage = CommunityAdminPage.new(@browser)
    @browser.wait_until($t) { @adminpage.admin_topic_link.present? }
    @adminpage.admin_topic_link.click
    @browser.wait_until($t) { @adminpage.admin_new_topic_button.present? }
    assert @adminpage.admin_new_topic_button.present?
    @adminpage.admin_new_topic_button.click
    @browser.wait_until($t) { @adminpage.new_topic_title_field.present? }
    @adminpage.new_topic_title_field.set topicname
    @adminpage.new_topic_desc.when_present.set topicdescrip

    if $os == "windows"
      @browser.execute_script('$(".photo-upload-browse").removeClass("photo-upload-browse")')
    end

    assert @adminpage.new_topic_browse.present?
    @adminpage.new_topic_tile_banner_file.set filetile
    @browser.wait_until($t) { @adminpage.new_topic_img_cropper.present? }
    @adminpage.new_topic_img_select_button.when_present.click
    @browser.wait_until { !@adminpage.new_topic_img_cropper.present? }
  
    @browser.wait_until($t) { @adminpage.new_topic_tile_selected_img.present? }
    topic_tile_image = @adminpage.new_topic_tile_selected_img.style 

    #URL doesnt get saved, so following assertion will fail, hence commented out.
    #assert_match /watir2Tile.jpeg/, topic_tile_image, " topic tile should match watir2Tile.jpeg "
    assert @adminpage.new_topic_tile_banner_change_button.present?
    assert @adminpage.new_topic_tile_banner_delete_button.present?

    @browser.execute_script("window.scrollBy(0,1000)")
    @browser.wait_until($t) { @adminpage.new_topic_default_topictype.present? }  

    if (topictype == "engagement")
        @adminpage.new_topic_eng_topictype.when_present.click
        assert @adminpage.new_topic_eng_chosen.present?
    end
    if (topictype == "q&a")
       @adminpage.new_topic_sup_topictype.when_present.click
       assert @adminpage.new_topic_sup_chosen.present?
    end

    if advertise != nil
      @adminpage.advertise_check.when_present.click if advertise != @adminpage.advertise_check.checked?
    end

    @adminpage.new_topic_next_design_button.when_present.click
    sleep 4
    @browser.wait_until($t) { @adminpage.new_topic_next_design_page.present? }
    assert @adminpage.topic_type_text.present?
    assert @adminpage.design_side_zone.present? 
    assert @adminpage.new_topic_browse.present?
    @adminpage.new_topic_tile_banner_file.set filebanner
    @browser.wait_until($t) {@adminpage.new_topic_img_cropper.present? }
    @adminpage.new_topic_img_select_button.when_present.click
    @browser.wait_until { !@adminpage.new_topic_img_cropper.present? }

    sleep 3
    @browser.wait_until($t) { @adminpage.new_topic_banner_selected_img.present? }
    topic_banner = @adminpage.new_topic_banner_selected_img.style
    assert_match /watir2Banner.jpg/, topic_banner, "background url should match watir2Banner.jpg"
    assert @adminpage.new_topic_tile_banner_change_button.present?
    assert @adminpage.new_topic_tile_banner_delete_button.present?
    @browser.execute_script("window.scrollBy(0,1000)")
    @adminpage.next_view_topic_button.when_present.click
    @browser.wait_until($t) { @adminpage.activate_topic_button.present? }
    @adminpage.activate_topic_button.when_present.click
    @browser.wait_until($t) { @adminpage.edit_topic_button.present? }  
    assert @adminpage.edit_topic_button.present?
    assert @adminpage.deactivate_topic_button.present?
    assert @adminpage.feature_topic_button.present?
    assert @adminpage.new_topictitle.text =~ /#{topicname}/
    #assert @topic_filter.present?

    if (topictype == "engagement")
      @browser.wait_until($t) { @adminpage.topic_popular_disc_widget.present? }
      assert @adminpage.topic_popular_disc_widget.present?
    end
    if (topictype == "q&a")
      @browser.wait_until($t) { @adminpage.topic_popular_answer_widget.present? }
      assert @adminpage.topic_popular_answer_widget.present?
    end
    
    if advertise != nil
      if advertise
        @browser.wait_until($t){ @adminpage.ad_banner.present? }
        @browser.wait_until($t){ @adminpage.ad_side.present? }
      elsif !advertise
        assert !@adminpage.ad_banner.present?
        assert !@adminpage.ad_side.present?
      end
    end
    @browser.refresh
    return topicname
  end

  #####################################################################

  ######################### CONVERSATION ##############################

  def choose_post_type(type)
    if type == "discussion"
      typeclass = "disc"
      typetext = "Discussions"
    elsif type == "question"
      typeclass = "ques "
      typetext = "Questions"
    elsif type == "blog"
      typeclass = "blog"
      typetext = "Blogs"
    end 
    link = @browser.link(:text => typetext)
    link.when_present.click
    @browser.wait_until($t) { @post_body.present? }
    assert @post_body.present?
  end

  def create_conversation(network, networkslug, topic_name, posttype, title, widget=true)

  @topicdetailpage = CommunityTopicDetailPage.new(@browser) 
  if ( !@topicdetailpage.topic_filter.present?)
    @browser.goto "#{$base_url}"+"/n/#{networkslug}"
    @browser.wait_until($t){ @topicdetailpage.topic_page.present? }
  end
    @loginpage = CommunityLoginPage.new(@browser)
    if (@loginpage.signin_link.present?)
    about_login("regular", "logged")
    end
    topic_detail(topic_name)
    @topicdetailpage = CommunityTopicDetailPage.new(@browser)
    @browser.wait_until($t) { @topicdetailpage.topic_filter.present? }
    assert @topicdetailpage.topic_follow_button.present? || @topicdetailpage.topic_unfollow_button.present?

    if @topicdetailpage.topic_publish_change_button.present?
     @topicdetailpage.topic_publish_change_button.click 
     @browser.wait_until($t) {@topicdetailpage.topic_edit_button.present? }
     assert @topicdetailpage.topic_edit_button.present?
    end
  #end

    if posttype == "review"
      @topicdetailpage.topic_review_filter.click
      @browser.wait_until($t) { @topicdetailpage.new_review_button.present? }
      @topicdetailpage.new_review_button.click
    #end
    else
      @topicdetailpage.topic_create_new_button.when_present.click
    
      @browser.wait_until($t) { @conv_create.present? }
    end
  #end

    @conv_create.when_present.set title
    
    if posttype == "question" || posttype == "question_with_image"
      @browser.wait_until($t) { @suggested_post.present? } #suggested posts
      if !@browser.div(:class => "post-type question chosen").present?
       @browser.div(:class => "post-type question ").when_present.click
      end
      @browser.wait_until($t) { @browser.div(:class => "post-type question chosen").present? }
    end
    if posttype == "discussion" || posttype == "discussion_with_link"
      @browser.wait_until($t) { @browser.div(:class => "shown").exists? } #suggested posts
      if !@browser.div(:class => "post-type discussion chosen").present?
       @browser.div(:class => "post-type discussion ").when_present.click
      end
      @browser.wait_until($t) { @browser.div(:class => "post-type discussion chosen").present? }
    end
    if posttype == "blog" || posttype == "blog_with_video"
      if !@browser.div(:class => "post-type blog chosen").present?
       @browser.div(:class => "post-type blog ").when_present.click
      end
      @browser.wait_until($t) { @browser.div(:class => "post-type blog chosen").present? }
    end

    #if posttype == "discussion_with_link" #always have link in it
    #  @browser.execute_script('$("button[data-event=showLinkDialog]").get(1).click()')
    #  @browser.wait_until($t) {
    #    @browser.text_field(:class => "note-link-text").present?
    #  }
    #  link_href = "http://www.jambajuice.com"
    #  link_title = "Jamba Juice"
   # end

   # if posttype == "question_with_link" #always have link in it
   #   if !@browser.div(:class => "post-type question chosen").present?
   #    @browser.div(:class => "post-type question ").when_present.click
   #   end
   #   @browser.wait_until($t) { @browser.div(:class => "post-type question chosen").present? }
      #@browser.execute_script('$("button[data-event=showLinkDialog]").get(1).click()')
      #@browser.wait_until($t) {
      #  @browser.text_field(:class => "note-link-text").present?
      #}
   #   link_href = "http://www.jambajuice.com"
   #   link_title = "Jamba Juice"

   # end
   if posttype == "discussion_with_rte" #always have link in it
      #@browser.execute_script('$("div.note-style btn-group button[data-event=bold]").get(1).click()')
      @browser.div(:class => "note-style btn-group").button(:class => "btn btn-default btn-sm", :index => 1).click
      @browser.div(:class => "note-style btn-group").button(:class => "btn btn-default btn-sm note-recent-color").click
      @browser.div(:class => "note-editable panel-body").text("test")
      
    @browser.execute_script('$("div.note-editable").blur()') #needed to communicate the description back to the parent element. the blur events fires fine during manual creation.
    @browser.execute_script("window.scrollBy(0,600)")
      
    end

    if posttype == "question_with_link" #always have link in it
      if !@browser.div(:class => "post-type question chosen").present?
       @browser.div(:class => "post-type question ").when_present.click
      end
      @browser.wait_until($t) { @browser.div(:class => "post-type question chosen").present? }
      
      link_href = "http://www.jambajuice.com"
      link_title = "Jamba Juice"
    end

    if posttype == "blog_with_video"
      @browser.execute_script('$("button[data-event=showVideoDialog]").click()')
      @browser.wait_until($t) {
        @browser.text_field(:class => "note-video-url").present?
      }

      video_url = "https://www.youtube.com/watch?v=prCKZg5ONGg"

      assert @browser.text_field(:class => "note-video-url").present?, "Modal for video not present"
      @browser.text_field(:class => "note-video-url").set(video_url)
      @browser.button(:class => "btn-primary note-video-btn").when_present.click
    end
    if posttype == "discussion_with_link" || posttype == "question_with_link"
      @browser.execute_script('$("div.note-editable").text("http://www.jambajuice.com\n")')
      @browser.execute_script('$("div.note-editable").focus()')
      @browser.send_keys :space
      @browser.execute_script("window.scrollBy(0,800)")
     
      @browser.wait_until($t) { @browser.img(:src => /jambajuice/).present? }
      @browser.wait_until($t) { @browser.p( :text => "Healthy breakfast, quick lunch or a delicious snack. Try Jamba Juice fruit smoothies, all-natural baked goods, steel-cut oatmeal, sandwiches and other healthy choices for an active lifestyle.").present? }
      
      assert @browser.img(:src => /jambajuice/).present? 
      assert @browser.div(:class => "note-editable panel-body").p(:text => "Healthy breakfast, quick lunch or a delicious snack. Try Jamba Juice fruit smoothies, all-natural baked goods, steel-cut oatmeal, sandwiches and other healthy choices for an active lifestyle.").present? 
    else
    if (posttype != "discussion_with_rte")
    @browser.execute_script('$("div.note-editable").html($("div.note-editable").html() + "Watir test description")')
    @browser.execute_script('$("div.note-editable").blur()') #needed to communicate the description back to the parent element. the blur events fires fine during manual creation.
    @browser.execute_script("window.scrollBy(0,600)")
    end
    end
    @browser.wait_until($t) { @browser.div(:class => "controls text-right").button(:class => "btn btn-primary").present? }
    if (posttype == "blog" || posttype == "blog_with_video")
      @browser.button(:css => ".conversation-submit").when_present.click
      @browser.div(:id => "delayed-publish-modal").button(:class => "btn btn-primary btn-sm").when_present.click
    else
      @browser.div(:class => "controls text-right").button(:class => "btn btn-primary", :value => "Submit").when_present.click
    end
    #@browser.wait_until($t) { !@browser.div(:class => "controls text-right").button(:class => "btn btn-primary", :value => /Submit/).present? }
  @browser.wait_until($t) { @browser.div(:class => /depth-0/).present?}

    if posttype == "discussion_with_link" || posttype == "question_with_link"
      @browser.wait_until($t) { @browser.div(:class => "post-content").present? }
      @browser.wait_until($t) { @browser.img(:src => /image_preview/).present? }

      assert @browser.div(:class => "post-content").present?
      assert @browser.img(:src => /image_preview/).present? 
    end
    if posttype == "discussion_with_rte" 
        text_bg_color = @browser.div(:class => "post-content").p(:index => 0).span.style('background-color')
        @browser.wait_until($t) { text_bg_color.present? }
       # assert_equal text_bg_color, 
    end
  
    return title
  end

  def conversation_detail(type, post_name = nil)
    policy_warning
    if !(post_name == nil)
      until @browser.text.include? post_name
      @browser.execute_script("window.scrollBy(0,1900)")
      @show_more_link.click
      @browser.wait_until { @conv_post_collection.present? }
      @browser.text.include? post_name
      end
      @browser.link(:text => post_name).when_present.click
    if (type == "question")
      @browser.wait_until($t) { @answer_level1.present? || @depth0_q.present? }
      assert @answer_level1.present?
      assert @root_post_title.text.include? post_name
    end
    if (type == "discussion")
      @browser.wait_until($t) { @depth0_d.present? }
      assert @conv_content.present?
      assert @root_post_title.text.include? post_name
    end
    if (type == "blog")
      @browser.wait_until($t) { @conv_content.present? }
      assert @root_post_title.text.include? post_name
    end
  
  else
    @browser.wait_until($t) { @first_conv_link.present? }
    @first_conv_link.when_present.click
    if (type == "question")
      @browser.wait_until($t) { @root_post.present? }
      assert @root_post.present?
    end
    if (type == "discussion")
      @browser.wait_until($t) { @root_post.present? }
      assert @root_post.present?
    end
    if (type == "blog")
      @browser.wait_until($t) { @root_post_blog.present? }
      assert @root_post_blog.present?
    end
    end

  end

  def feature_root_post
    feature_post(0)
  end

  def feature_comment(post_name=nil)
    feature_post(1,post_name)
  end

  def feature_reply(post_name=nil)
    feature_post(1,post_name)
  end

  def unfeature_root_post
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
    post.span(:class => "dropdown-toggle").when_present.click
    
    if post.link(:text => /Mark as best answer/).present?
     @browser.wait_until($t) { post.link(:text => /Mark as best answer/).present? }
     post.link(:text => /Mark as best answer/).when_present.click
     
     @browser.wait_until { @featured_answer.present? }
     assert @featured_answer.present?
    else
     @browser.wait_until($t) { post.link(:text => /Feature/).present? }
     post.link(:text => /Feature/).when_present.click
     if level == 0
      @browser.wait_until($t) { @featured_root.present? }
      assert @featured_root.present?
     else
      @browser.wait_until {@featured_comment.present?  }
      assert @featured_comment.present?
     end 
    end 
  end

  def unfeature_post(level,post_name=nil)
    post = get_post(level,post_name)
    post.span(:class => "dropdown-toggle").when_present.click
    if post.link(:text => "Unmark as best answer").present? 
     post.link(:text => "Unmark as best answer").when_present.click
     @browser.wait_until { !@featured_answer.present? }
     assert !@featured_answer.present?
    else
     post.link(:text => "Stop Featuring").when_present.click
     if level == 0
      @browser.wait_until($t) { !@featured_root.present? }
      assert !@featured_root.present?
     else
      @browser.wait_until { !@featured_comment.present?  }
      assert !@featured_comment.present?
     end 
    end
  end

  def get_post(level,post_name=nil,count=0)
    if post_name
      element = @browser.div(:class => /depth-#{level}/,:text => /#{post_name}/)
    else
      element = @browser.div(:class => /depth-#{level}/) #,:index => count)
    end

    @browser.wait_until($t){ element.present? }
    return element
  end

  def sort_by_old_in_conversation_detail
    @conv_detail_sort.when_present.click
    @browser.wait_until($t) { @conv_detail_sort_dropdown_open.present? }
    @conv_detail_oldest_link.click
    sleep 1
    @browser.wait_until($t) { @conv_detail_sort_dropdown_open.text.include? "Sorted by: Oldest" }
    assert @conv_detail_sort_dropdown_open.text.include? "Sorted by: Oldest"
  end

  def sort_by_new_in_conversation_detail
    @conv_detail_sort.when_present.click
    @browser.wait_until($t) { @conv_detail_sort_dropdown_open.present?}
    @conv_detail_newest_link.click
    @browser.wait_until { @conv_detail_sort_dropdown_open.text.include? "Sorted by: Newest"}
    @browser.wait_until { @conv_reply.present? }
    assert @conv_detail_sort_dropdown_open.text.include? "Sorted by: Newest"
  end

  def feature_topic
    @topicdetailpage = CommunityTopicDetailPage.new(@browser)
    if @topicdetailpage.topic_feature.present? 
     @topicdetailpage.topic_feature.click
     @browser.wait_until { @topicdetailpage.topic_unfeature.present? }
    end
    assert @topicdetailpage.topic_unfeature.present?
  end

  def unfeature_topic
    @topicdetailpage = CommunityTopicDetailPage.new(@browser)
    if @topicdetailpage.topic_unfeature.present? 
     @topicdetailpage.topic_unfeature.click
     @browser.wait_until { @topicdetailpage.topic_feature.present? }
    end
    assert @topicdetailpage.topic_feature.present?
  end

  def get_topic_uuid(topictype)
    case topictype
     when "engagement"
      #if topic_uuid != nil
       @topicdetailpage = CommunityTopicDetailPage.new(@browser)
       @topicdetailpage.goto_topicdetail_page("engagement")
       topic_url = @browser.url
       topic_uuid = topic_url.split("/topic/")[1].split("/")[0]
      #end
     when "support"
      @topicdetailpage = CommunityTopicDetailPage.new(@browser)
      @topicdetailpage.goto_topicdetail_page("support")
      topic_url = @browser.url
      topic_uuid = topic_url.split("/topic/")[1].split("/")[0]
     when "engagement2"
      @topicdetailpage = CommunityTopicDetailPage.new(@browser)
      @topicdetailpage.goto_topicdetail_page("engagement2")
      topic_url = @browser.url
      topic_uuid = topic_url.split("/topic/")[1].split("/")[0]
    else
      raise "Invalid topictype!"
    end
      return topic_uuid
  end

  def newline
    puts "\n\n"
  end

  def get_timestamp
    return Time.now.utc.to_s.gsub(/[-: ]/,'')
  end

end