require 'pages/community'

class Pages::Community::TopicList < Pages::Community

  def initialize(config, options = {})
    super(config)
    @url = config.base_url + "/n/#{config.slug}"
  end

  def start!(user)
    super(user, @url, topic_list)
  end

  productlist_page_url                     { "#{@@base_url}"+"/n/#{@@slug}/products" }
  topiclist_empty_text                     { h4(:css => "#topics .empty-container-text") }

  topic_list                               { div(:id => "topics") }
  topic_list_breadcrumb                    { div(:class => "breadcrumbs").link }
  topic_list_sort_btn                      { button(:css => ".topic-sort-drop-down .dropdown-toggle") }
  topic_list_sort_dropdown                 { ul(:css => ".topic-sort-drop-down .dropdown-menu") }
  topic_list_sort_name_menu                { ul(:css => ".topic-sort-drop-down .dropdown-menu").link(:text => "Name") }
  topic_list_placeholder                   { div(:css => ".topics-grid-placeholder") }
  topics_grid_view                         { div(:class => "topics-grid row")}
  breadcrumb_link                          { link(:class => "ember-view", :text => "#{$network}")}
  topic_tile                               { div(:class => "topic")}
  topic_listed_row                         { div(:class => "topic row-topic") }
  topics_list_view_link_unselected         { div(:class => "topic-view-option icon-list")}
  topics_list_view_link_selected           { div(:class => "selected topic-view-option icon-list")}
  topic_detail_link_on_list_view           { p(:class => "customization-topic-content")}
  activated_topics_filter_button           { button(:class => "btn btn-default", :text => "Activated")}
  all_topic_follow_unfollow_buttons        { buttons(:class => "btn-default icon")}
  topic_create_link                        { link(:href => "/admin/#{@@slug}/topics/create", :text => "+ New Topic")}
  all_topic_tiles                          { divs(:class => "topic") }
  show_more_button                         { div(:class => "show-more-topics").link}
  image_upload_link                        { link(:text => "browse")}
  image_change_button                      { button(:text => "Change Photo")}
  image_delete_button                      { button(:text => "Delete Photo")}
  ulpoad_image                             { file_field(:class => "files")}
  uploaded_file_selector                   { div(:class => "cropper-canvas")}
  topic_tile_select_photo_button           { button(:class => "btn btn-primary btn-sm file-upload-select-button", :text => "Select Photo")}
  topic_tile_photo_holder                  { div(:class => "ember-view uploader-component topic-tile-upload")}
  topic_tile_delete_button                 { button(:class => "btn btn-default", :text => "Delete Photo")}
  topic_next_design_button                 { button(:class => "btn btn-primary", :text => /Next: Design/)}
  topic_create_title                       { div(:class => "row topic-create-title")}
  topic_type                               { div(:class => "topic-type-text")}
  topic_widget_container                   { div(:class => "widget-container")}
  topic_banner_image_holder                { div(:class => "ember-view uploader-component widget banner topic")}
  topic_banner_change_button               { button(:class => "btn btn-default", :text => "Change Photo")}
  topic_banner_delete_button               { button(:class => "btn btn-default", :text => "Remove Photo")}
  topic_next_view_button                   { button(:class => "btn btn-primary", :text => /Next: View Topic/)}
  topic_activate_new_topic_button          { button(:class => "btn btn-primary", :text => /Activate Topic/)}
  topic_edit_button                        { button(:class => "btn btn-default btn-sm admin-dark-btn", :text => "Edit Topic")}
  topic_deactivate_topic_link              { link(:class => "btn btn-default btn-sm admin-dark-btn", :text => "Deactivate Topic")}
  topic_feature_topic_button               { button(:class => "btn btn-default btn-sm admin-dark-btn topic-admin-buttons", :text => "Feature Topic")}
  topic_follow_button_on_topicdetail       { button(:class => "btn btn-default", :text => "Follow Topic")}
  create_new_topic_button_on_topicdetail   { button(:class => "btn btn-primary", :text => "Create New")}
  topics_grid_view_link_unselected         { div(:class => " topic-view-option icon-grid")}

  idea_widget_view_all_link                { div(:class => "gadget-popular-ideas").link(:text => /View All/) }

  topic_feature_icons                      { spans(:class => "icon-favorite")}
  def navigate_in(type=:topic)
    case type
    when :topic  
      @browser.goto @url
    when :product
      @browser.goto productlist_page_url
    end    

    @browser.wait_until { topic_list.present? }
    @browser.wait_until { !topic_list_placeholder.present? }
    @browser.wait_until { topiccard_list.topic_cards.size > 0 || 
                          topiclist_empty_text.present? }
  end

  def topiccard_list
    TopicCardList.new(@browser)
  end
  
  def get_topic_uuid_by_title topic_title
    @topicdetail_page = go_to_topic(topic_title)
    return @browser.url.split("/topic/")[1].split("/")[0]
  end

  def show_topic(title)
    @browser.wait_until { topiccard_list.present? }
    @browser.wait_until { !topic_list_placeholder.present? }

    if topiccard_list.topic_with_title(title).nil?
      sort_by_name

      raise "Cannot find topic #{title}" if topiccard_list.topic_with_title(title).nil?
    end  
  end  

  def go_to_first_product(outside_prodpage=true)
    product_nav.when_present.click if outside_prodpage
    goto_first_topic
  end

  def goto_first_topic
    @browser.wait_until($t) {topic_list.present?}
    @browser.wait_until($t) {topic_list.links[0].present?}
    topic_list.links[0].when_present.click

    topicdetail_page =  Pages::Community::TopicDetail.new(@config)
 
    @browser.wait_until { topicdetail_page.topic_filter.present? }

    topicdetail_page
  end  

  def goto_topic_at_index(index)
    @browser.wait_until($t) {topic_list.present?}
    @browser.wait_until($t) {topic_list.links[0].present?}
    @browser.div(:css => "#topics > div:nth-child(#{index+1}) .topic .topic-avatar").when_present.click

    topicdetail_page =  Pages::Community::TopicDetail.new(@config)
 
    @browser.wait_until { topicdetail_page.topic_filter.present? }

    topicdetail_page
  end

  def go_to_topic(name)
    $topics = {} if $topics.nil?

    if $topics[name.downcase].nil?
      navigate_in unless @browser.url == @url

      sort_by_name if topiccard_list.topic_with_title(name).nil?

      # @browser.execute_script("window.scrollBy(0,2000)")
      @browser.wait_until { @browser.link(:text => name).present? }

      scroll_to_element @browser.link(:text => name)
      @browser.execute_script("window.scrollBy(0,-200)")

      @browser.link(:text => name).when_present.click

      @browser.wait_until { @browser.url.include? "/topic/" }
      topic_url = @browser.url
      topic_uuid = topic_url.split("/topic/")[1].split("/")[0]
      $topics[name.downcase] = Topic.new(name, topic_uuid, topic_url)
    else
      @browser.goto($topics[name.downcase].url)
    end

    topicdetail_page =  Pages::Community::TopicDetail.new(@config)
 
    @browser.wait_until { topicdetail_page.topic_filter.present? }

    topicdetail_page
  end

  def go_to_topic_by_url(topic_url)
    @browser.goto topic_url
    topicdetail_page =  Pages::Community::TopicDetail.new(@config)
    @browser.wait_until { topicdetail_page.topic_filter.present? }
    topicdetail_page
  end

  def sort_by_name
    # this wait is necessary. Otherwise, click on Name doesn't work
    @browser.wait_until { topic_list_sort_btn.present? }
    @browser.wait_until { !topic_list_placeholder.present? }

    topic_list_sort_btn.when_present.click
    topic_list_sort_name_menu.when_present.click

    @browser.wait_until { !topic_list_placeholder.present? }
  end

  def check_breadcrumb_link
    @browser.wait_until($t) { breadcrumb_link.present? }
    breadcrumb_link.click
    @homepage = Pages::Community::Home.new(@config)
    @browser.wait_until($t) { @homepage.home.present? }
  end

  def check_page_search_bar
    @homepage = Pages::Community::Home.new(@config)
    @browser.wait_until($t) { @homepage.search_bar.present? }
  end

  def goto_topics_list_view
    @browser.goto @url
    #@browser.wait_until($t) { topics_grid_view.present? }
    @browser.wait_until($t) { topic_tile.present? }
    if !topic_listed_row.present?
      topics_list_view_link_unselected.when_present.click
      @browser.wait_until($t) { topic_listed_row.exists? }
    end
    topics_list_view_link_unselected.when_present.click
    @browser.wait_until($t) { topic_listed_row.exists? }
  end

  def goto_topic_detail_page_from_topictile_on_grid_view
    @browser.wait_until($t) { topic_tile.present? }
    topic_tile.when_present.click
    @topicdetailpage = Pages::Community::TopicDetail.new(@config)
    @browser.wait_until($t) { @topicdetailpage.topic_filter.present? }
    @topicdetailpage.topicname.text #return title of the topic
  end

  def goto_topic_detail_page_from_topicname_on_list_view
    @browser.wait_until($t) { topic_detail_link_on_list_view.present? }
    topic_detail_link_on_list_view.when_present.click
    @topicdetailpage = Pages::Community::TopicDetail.new(@config)
    @browser.wait_until($t) { @topicdetailpage.topicdetail.present? }
    @topicdetailpage.topicname.text #return title of the topic
  end

  def click_new_topic_create_link
    @browser.wait_until($t) { topic_create_link.present? }
    topic_create_link.when_present.click
    @topicdetailpage = Pages::Community::TopicDetail.new(@config)
    @browser.wait_until ($t) {@topicdetailpage.new_topic_title.present?}
  end

  def set_new_topic_details(topictype, advertise)
    topicname = "Watir created topic - #{get_timestamp}"
    topicdescription = "Watir topic test description - #{get_timestamp}"
    @topicdetailpage = Pages::Community::TopicDetail.new(@config)
    @topicdetailpage.new_topic_title.when_present.set topicname
    @topicdetailpage.new_topic_description.when_present.set topicdescription

    accept_policy_warning

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
    topicname
  end

  def image_set(imagetype)
    assert image_upload_link.exists?
    if(imagetype == "filetile")
      ulpoad_image.set File.expand_path(File.dirname(__FILE__)+ "/../../../seeds/development/images/watir2Tile.jpeg")
    else
      ulpoad_image.set File.expand_path(File.dirname(__FILE__)+ "/../../../seeds/development/images/watir2Banner.jpg")
    end
    @browser.wait_until($t) { uploaded_file_selector.exists? }
    topic_tile_select_photo_button.when_present.click
    @browser.wait_until { !uploaded_file_selector.present? }
  end

  def image_set_change(imagetype)
    assert image_change_button.exists? && image_delete_button.exists?
    if(imagetype == "filetile")
      ulpoad_image.set File.expand_path(File.dirname(__FILE__)+ "/../../../seeds/development/images/watir2Tile.jpeg")
    else
      ulpoad_image.set File.expand_path(File.dirname(__FILE__)+ "/../../../seeds/development/images/watir2Banner.jpg")
    end
    @browser.wait_until($t) { uploaded_file_selector.exists? }
    topic_tile_select_photo_button.when_present.click
    @browser.wait_until { !uploaded_file_selector.present? }
  end

  def saving_draft_when_create_topic
    @browser.execute_script("window.scrollBy(0,1000)")
    topic_next_view_button.when_present.click
    @browser.wait_until{ topic_activate_new_topic_button.present? }
  end

  def topic_create_steps_after_image_set(imagetype)
    if (imagetype == "filetile")
      @browser.wait_until($t) { topic_tile_photo_holder.exists? }
      assert topic_tile_delete_button.exists?
      topic_next_design_button.when_present.click
      @browser.wait_until($t) { topic_create_title.present? && topic_type.present? && topic_widget_container.present? }
    else # its filebanner
      sleep 3
      @browser.wait_until($t) { topic_banner_image_holder.present? }
      topic_banner = topic_banner_image_holder.style
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

  def goto_topics_page
    @browser.goto @url
    @browser.wait_until($t) { topic_tile.present? }
    if !topics_grid_view.present?
      topics_grid_view_link_unselected.when_present.click
      @browser.wait_until($t) { topics_grid_view.present? }
    end
  end

  def follow_topic #chooses first topic in the list
    first_follow_or_unfollow_button = all_topic_follow_unfollow_buttons[0]
    if "Follow" == first_follow_or_unfollow_button.text || "Unfollow" == first_follow_or_unfollow_button.text
      first_follow_or_unfollow_button.click
      @browser.wait_until($t) { "Follow" == first_follow_or_unfollow_button.text }
    end
    first_follow_or_unfollow_button.click #follow action
    @browser.wait_until($t) { "Follow" == first_follow_or_unfollow_button.text || "Unfollow" == first_follow_or_unfollow_button.text }
    first_follow_or_unfollow_button
  end

  def unfollow_topic #chooses first topic in the list
    first_follow_or_unfollow_button = all_topic_follow_unfollow_buttons[0]
    if "Follow" == first_follow_or_unfollow_button.text
      first_follow_or_unfollow_button.click
      @browser.wait_until($t) { "Follow" == first_follow_or_unfollow_button.text || "Unfollow" == first_follow_or_unfollow_button.text }
    end
    first_follow_or_unfollow_button.click #unfollow action
    @browser.wait_until($t) { "Follow" == first_follow_or_unfollow_button.text }
    first_follow_or_unfollow_button
  end

  def topics_filter_by_activated_button
    activated_topics_filter_button.when_present.click
    @browser.wait_until($t) { topic_tile.present? }
  end

  def admins_and_moderators_with_network_scope_can_create_blog(topic_title: nil, **)
    topic_title_for_test = topic_title || "A Watir Topic"
    @topicdetail_page = go_to_topic(topic_title_for_test)
    @topicdetail_page.topic_navigator.create_new_btn.when_present.click
    @browser.wait_until { @topicdetail_page.topic_navigator.create_new_question_menu_item.present? } 
    @browser.wait_until { @topicdetail_page.topic_navigator.create_new_review_menu_item.present? } 
    assert_all_keys({
      :questions => @topicdetail_page.topic_navigator.create_new_question_menu_item.present?,
      :blogs => @topicdetail_page.topic_navigator.create_new_blog_menu_item.present?,
      :reviews => @topicdetail_page.topic_navigator.create_new_review_menu_item.present?, 
    })
  end

  def get_the_first_conv_root_post_for_specific_topic_and_conv_type(topic_title: "A Watir Topic", conv_type: :question, conv_url: nil, **)
    @topicdetail_page = go_to_topic(topic_title)
    if conv_url
      @browser.goto conv_url
    else
      @topicdetail_page.goto_conversation(type: conv_type)
    end
    @convdetail_page = Pages::Community::ConversationDetail.new(@config)
    @browser.wait_until { @convdetail_page.comment_level1.present? || @convdetail_page.depth0_q.present? }
    conv_root_post = @convdetail_page.get_post(0)
    @browser.wait_until { conv_root_post.span(:class => "dropdown-toggle").present? }
    conv_root_post.span(:class => "dropdown-toggle").when_present.click
    @browser.wait_until { @convdetail_page.dropdown_menu.present? }
    conv_root_post
  end

  class Topic
    attr_reader :name, :uuid, :url

    def initialize(name, uuid, url)
      @name = name
      @uuid = uuid
      @url = url
    end
  end

  class TopicCardList
    def initialize(browser)
      @browser = browser
      @parent_css = "#topics"
    end
    
    def present?
      @browser.element(:css => @parent_css).present?
    end  

    def topic_with_title(title)
      topic_cards.find { |t| t.title.downcase == title.downcase }
    end 

    def topic_cards
      list_eles = @browser.divs(:css => @parent_css + " .single-topic")

      results = []

      return [] if list_eles.size < 1

      (1..list_eles.size).each { |i|
        results.push(TopicCard.new(@browser, @parent_css + " .single-topic:nth-child(#{i})"))
      }

      results 
    end

    def follow_topic(title)
      @browser.wait_until { !topic_with_title(title).nil? }

      if topic_with_title(title).follow_btn.when_present.text == "Follow"
        topic_with_title(title).follow_btn.click
        @browser.wait_until { topic_with_title(title).follow_btn.text == "Unfollow" }
      end
    end

    def unfollow_topic(title)
      @browser.wait_until { !topic_with_title(title).nil? }

      if topic_with_title(title).follow_btn.when_present.text == "Following"
        topic_with_title(title).follow_btn.click
        @browser.wait_until { topic_with_title(title).follow_btn.text == "Follow" }
      end
    end  
  end

  class TopicCard
    def initialize(browser, parent_css)
      @browser = browser
      @parent_css = parent_css
    end
    
    def title
      @browser.element(:css => @parent_css + " .topic-avatar").when_present.text
    end
    
    def description
      @browser.element(:css => @parent_css + " .topic-tile-body .body-paragraph").when_present.text
    end

    def follow_btn
      @browser.button(:css => @parent_css + " .topic-tile-body button")
    end

    def feature_icon
      @browser.span(:css => @parent_css + " .icon-favorite")
    end

  end  
end