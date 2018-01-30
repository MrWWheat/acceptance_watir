require File.expand_path(File.dirname(__FILE__) + "/page_object.rb")


class CommunityTopicsPage < PageObject  
  
  NUM_TOPICS_ON_PAGE = 12
  FOLLOW_TEXT = "Follow"
  FOLLOWING_TEXT = "Following"
  UNFOLLOW_TEXT = "Unfollow"

  attr_accessor :activated_topics_filter_button,
    :create_new_topic_button_on_topicdetail,
    :featured_topic_icon_grid_view,
    :featured_topic_icon_list_view,
    :featured_topics_filter_button,
    :new_topic_description,
    :new_topic_title,
    :topic_activate_new_topic_button,
    :topic_banner_change_button,
    :topic_banner_delete_button,
    :topic_banner_image_holder,
    :topic_create_link,
    :topic_create_title,
    :topic_deactivate_topic_link,
    :topic_edit_button,
    :topic_feature_topic_button,
    :topic_follow_button_on_topicdetail,
    :topic_next_design_button,
    :topic_next_view_button,
    :topic_sort_by_name_link,
    :topic_tile,
    :topic_tile_change_button,
    :topic_tile_delete_button,
    :topic_tile_link,
    :topic_tile_photo_holder,
    :topic_tile_select_photo_button,
    :topic_type,
    :topic_widget_container,
    :topics_button_row,
    :topics_grid_view,
    :topics_list_view_link_selected,
    :topic_listed_row,
    :list_view_topic_title,    
    :show_more_button

  def initialize(browser)
 	  super
    @url = $base_url +"/n/#{$networkslug}/"
    @topics_button_row = @browser.div(:class => "row topic-button-toolbar")
    @topics_grid_view = @browser.div(:class => "topics-grid row")
    @featured_topics_filter_button = @browser.button(:class => "btn btn-default", :text => "Featured")
    @activated_topics_filter_button = @browser.button(:class => "btn btn-default", :text => "Activated")
    @featured_topic_icon_grid_view = @browser.div(:class => "topic-tile-body").span(:class => "icon-favorite")    
    @featured_topic_icon_list_view = @browser.span(:class => "icon-favorite")
    
    @topic_create_link = @browser.link(:href => "/admin/#{$networkslug}/topics/create", :text => "+ New Topic")

    # @all_topic_tiles = @browser.divs(:class => "topic")  
    # puts "!!@all_topic_tiles.length current snapshot!!", @all_topic_tiles.length

    @topic_tile = @browser.div(:class => "topic")
    @topic_tile_link = @browser.div(:class => "topic-avatar")
    @topic_detail_link_on_list_view = @browser.div(:class => "head")

    @topic_tile_select_photo_button = @browser.button(:class => "btn btn-primary btn-sm file-upload-select-button", :text => "Select Photo")
    @topic_tile_photo_holder = @browser.div(:class => "ember-view uploader-component topic-tile-upload")
    @topic_tile_change_button = @browser.button(:class => "btn btn-default", :text => "Change Photo")
    @topic_tile_delete_button = @browser.button(:class => "btn btn-default", :text => "Delete Photo")
    @topic_next_design_button = @browser.button(:class => "btn btn-primary", :text => /Next: Design/)
    @topic_create_title = @browser.div(:class => "row topic-create-title")
    @topic_type = @browser.div(:class => "topic-type-text")
    @topic_widget_container = @browser.div(:class => "widget-container")
    @topic_banner_image_holder = @browser.div(:class => "ember-view uploader-component widget banner normal topic")
    @topic_banner_change_button = @browser.button(:class => "btn btn-default", :text => "Change Photo")
    @topic_banner_delete_button = @browser.button(:class => "btn btn-default", :text => "Remove Photo")
    @topic_next_view_button = @browser.button(:class => "btn btn-primary", :text => /Next: View Topic/)
    @topic_activate_new_topic_button = @browser.button(:class => "btn btn-primary", :text => /Activate Topic/)
    @topic_edit_button = @browser.button(:class => "btn btn-default btn-sm admin-dark-btn", :text => "Edit Topic")
    @topic_deactivate_topic_link = @browser.link(:class => "btn btn-default btn-sm admin-dark-btn", :text => "Deactivate Topic")
    @topic_feature_topic_button = @browser.button(:class => "btn btn-default btn-sm admin-dark-btn topic-admin-buttons", :text => "Feature Topic")
    @topic_follow_button_on_topicdetail = @browser.button(:class => "btn btn-default", :text => "Follow Topic")
    @create_new_topic_button_on_topicdetail = @browser.button(:class => "btn btn-primary", :text => "Create New")

    @topic_follow_button = @browser.button(:class => "ember-view btn btn-default icon", :text => "Follow")
    @topic_following_button = @browser.button(:class => "ember-view btn btn-default icon", :text => "Following")

    @topic_sort_by_name_link = @browser.button(:class => "btn btn-default dropdown-toggle filter-dropdown sap-regular-dropdown", :text => "Sort by: Newest")
    @topics_grid_view_link_unselected = @browser.div(:class => " topic-view-option icon-grid")
    @topics_grid_view_link_selected = @browser.div(:class => "selected topic-view-option icon-grid")
    @topics_list_view_link_unselected = @browser.div(:class => "topic-view-option icon-list")
    @topics_list_view_link_selected = @browser.div(:class => "selected topic-view-option icon-list")
    @topic_listed_row = @browser.div(:class => "topics-list row")    
    @list_view_topic_title = @browser.div(:class => "topics").div(:class=>"title").link

    @show_more_button = @browser.div(:class => "show-more-topics").link
    
    #search bar in the middle of the page
    @main_search_bar_input = @browser.div(:class => "row widget search").text_field(:class => "typeahead")

    #@new_topic_title = @browser.text_field(:id => "new-topic-title")
    #@new_topic_description = @browser.text_field(:id => "topic-caption-input")
  end

  #these method values can change based on browser page state
  def all_topic_listed_rows
    @browser.divs(:class => "topics-list row")
  end

  def all_topic_tiles
    @browser.divs(:class => "topic")  
  end

  def all_featured_topic_icons
    @browser.spans(:class => "icon-favorite")
  end
  
  #this is the list of all buttons containting the text Follow/Unfollow for Topics
  def all_topic_follow_unfollow_buttons
    @browser.buttons(:class => "btn-default icon")
  end

  def topic_detail_page_unfollow_button
    @browser.button(:class => "btn btn-default", :text => "Unfollow Topic")
  end

  def topic_detail_page_follow_button
    @browser.button(:class => "btn btn-default", :text => "Follow Topic")
  end


  def goto_topics_page
    @browser.goto @url
    #@browser.wait_until($t) { topics_grid_view.present? }
    @browser.wait_until($t) { @browser.div(:class => "topic").present? }
    if !@topics_grid_view.present?
      @topics_grid_view_link_unselected.when_present.click
      @browser.wait_until($t) { topics_grid_view.present? }
    end
  end

  def goto_topics_list_view
    @browser.goto @url
    #@browser.wait_until($t) { topics_grid_view.present? }
    @browser.wait_until($t) { @browser.div(:class => "topic").present? }
    if !topic_listed_row.present?
      @topics_list_view_link_unselected.when_present.click
      @browser.wait_until($t) { topic_listed_row.exists? }
    end


    @topics_list_view_link_unselected.when_present.click
    @browser.wait_until($t) { topic_listed_row.exists? }    
  end

  def check_breadcrumb_link
  	@browser.wait_until($t) { breadcrumb_link.present? }
  	@breadcrumb_link.click
    @homepage = CommunityHomePage.new(@browser)
  	@browser.wait_until($t) { @homepage.home.present? }
  end

  def goto_topic_detail_page_from_topictile_on_grid_view
    @browser.wait_until($t) { topic_tile.present? }
    topic_tile.when_present.click
    @topicdetailpage = CommunityTopicDetailPage.new(@browser)
    @browser.wait_until($t) { @topicdetailpage.topicdetail.present? }
    #@topicdetailpage = CommunityTopicDetailPage.new(@browser)
    @topicdetailpage.topicname.text #return title of the topic
  end

  def goto_topic_detail_page_from_topicname_on_list_view
    @browser.wait_until($t) { @topic_detail_link_on_list_view.present? }
    @topic_detail_link_on_list_view.when_present.click
    @topicdetailpage = CommunityTopicDetailPage.new(@browser)
    @browser.wait_until($t) { @topicdetailpage.topicdetail.present? }

    @topicdetailpage.topicname.text #return title of the topic
  end

  def click_featured_topics_button
    @browser.wait_until($t) { featured_topics_filter_button.present? }
    @browser.wait_until($t) { topic_tile.present? }
    featured_topics_filter_button.click
  end

  def check_featured_topics_in_grid_view
    @browser.wait_until($t) { topic_tile.present? }
    @browser.wait_until($t) { featured_topic_icon_grid_view.present? } 
  end

  def check_featured_topics_in_list_view
    @browser.wait_until($t) { @topic_detail_link_on_list_view.present? }
    @browser.wait_until($t) { featured_topic_icon_list_view.present? }
  end

  def click_new_topic_create_link
    @browser.wait_until($t) { topic_create_link.present? }
    topic_create_link.click
    @topicdetailpage = CommunityTopicDetailPage.new(@browser)
    @browser.wait_until ($t) {@topicdetailpage.new_topic_title.present?}
  end

  def set_new_topic_details(topictype, advertise)
    topicname = "Watir created topic - #{get_timestamp}"
    topicdescription = "Watir topic test description - #{get_timestamp}" 
    @topicdetailpage = CommunityTopicDetailPage.new(@browser)   
    @topicdetailpage.new_topic_title.when_present.set topicname
    @topicdetailpage.new_topic_description.when_present.set topicdescription
    
    if (topictype == "engagement")
        @topicdetailpage.engagement_topic_type_selection_box.when_present.click
        assert @topicdetailpage.engagement_topic_type_selected.present?
    end
    if (topictype == "q&a")
       @topicdetailpage.engagement_topic_type_selection_box.when_present.click
       assert @topicdetailpage.support_topic_type_selected.present?
    end

    #if advertise != nil
    #  @topicdetailpage.advertise_check.when_present.click if advertise != @topicdetailpage.advertise_check.checked?
    #end
  end

  def image_set(imagetype)    
    if(imagetype == "filetile")
      file_path = "#{$rootdir}/seeds/development/images/watir2Tile.jpeg"
    else 
      file_path = "#{$rootdir}/seeds/development/images/watir2Banner.jpg"
    end    
    assert image_upload_link.exists?

    ulpoad_image.set file_path
    @browser.wait_until($t) { uploaded_file_selector.exists? }
    topic_tile_select_photo_button.when_present.click
    @browser.wait_until { !uploaded_file_selector.present? }
  end
    
  def topic_create_steps_after_image_set(imagetype)
      
    if (imagetype == "filetile")
      @browser.wait_until($t) { topic_tile_photo_holder.exists? }
      assert topic_tile_delete_button.exists?
      topic_next_design_button.when_present.click

      @browser.wait_until($t) { 
        topic_create_title.present? && topic_type.present? && topic_widget_container.present?
      }

    else # its filebanner
      sleep 3
      topic_banner_image_holder
      @browser.wait_until($t) { topic_banner_image_holder.present? }
      topic_banner = @browser.div(:class => "ember-view uploader-component widget banner normal topic").style
      assert_match /watir2Banner.jpg/, topic_banner, "background url should match watir2Banner.jpg"
      assert topic_banner_change_button.exists?
      assert topic_banner_delete_button.exists?
      @browser.execute_script("window.scrollBy(0,1000)")
      topic_next_view_button.when_present.click
      @browser.wait_until($t) { topic_activate_new_topic_button.present? }
      @browser.execute_script("window.scrollTo(0,document.documentElement.scrollTop)")
      topic_activate_new_topic_button.when_present.click
      @browser.wait_until($t) { topic_edit_button.present? }
      assert topic_edit_button.present?
      assert topic_deactivate_topic_link.present?
      assert topic_feature_topic_button.present?
      assert topic_follow_button_on_topicdetail.present?
      assert create_new_topic_button_on_topicdetail.present?
    end
  end

  def follow_topic #chooses first topic in the list
    first_follow_or_unfollow_button = all_topic_follow_unfollow_buttons[0]
    if FOLLOWING_TEXT == first_follow_or_unfollow_button.text || UNFOLLOW_TEXT == first_follow_or_unfollow_button.text
      #unfollow it
      first_follow_or_unfollow_button.click
      @browser.wait_until($t) { FOLLOW_TEXT == first_follow_or_unfollow_button.text }
    end 
    first_follow_or_unfollow_button.click #follow action
    @browser.wait_until($t) { FOLLOWING_TEXT == first_follow_or_unfollow_button.text || UNFOLLOW_TEXT == first_follow_or_unfollow_button.text }
    first_follow_or_unfollow_button
  end

  def unfollow_topic #chooses first topic in the list
    first_follow_or_unfollow_button = all_topic_follow_unfollow_buttons[0]

    if FOLLOW_TEXT == first_follow_or_unfollow_button.text
      #Follow it
      first_follow_or_unfollow_button.click
      @browser.wait_until($t) { FOLLOWING_TEXT == first_follow_or_unfollow_button.text || UNFOLLOW_TEXT == first_follow_or_unfollow_button.text }
    end
    first_follow_or_unfollow_button.click #unfollow action
    @browser.wait_until($t) { FOLLOW_TEXT == first_follow_or_unfollow_button.text }
    first_follow_or_unfollow_button
  end

  def topic_sort_by_name
    topic_name = "A Watir Topic"
    if topic_sort_by_name_link.exists? 
      @browser.screenshot.save screenshot_dir('topicsort.png')
      refute_nil @browser.execute_script 'return $(".topic-sort-drop-down >button").trigger("click")', "Failed to open the dropdown"
      refute_nil @browser.execute_script 'return $(".filter-dropdown a:contains(\'Name\')").trigger("click")', "Failed to Name sort option in the dropdown"
      @browser.wait_until {@browser.link(:class => "ember-view", :text => /#{topic_name}/).present?}
      assert @browser.link(:class => "ember-view", :text => /#{topic_name}/).present?
    end
  end

  def topics_filter_by_activated_button
    @activated_topics_filter_button.when_present.click
    @browser.wait_until($t) { topic_tile.present? }
  end



end