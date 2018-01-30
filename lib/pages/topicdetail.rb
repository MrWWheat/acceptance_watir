require 'pages/base'

class Pages::TopicDetail < Pages::Base

  def initialize(config, options = {})
    super(config)
    @url = config.base_url + "/n/#{config.slug}"
  end

  def start!(user)
    super(user, @url, topic_page)

  end
  topicpage_url               { "#{@@base_url}"+"/n/#{@@slug}" }
  #topic_page                 { div(:id => "topics").div(:class => "col-sm-12 col-lg-4 col-md-4").div(:class => "topic").link(:class => "ember-view").div(:class => "topic-avatar") }

  support_topicname           { "A Watir Topic With Many Posts" }
  engagement_topicname        { "A Watir Topic" }
  engagement2_topicname       { "A Watir Topic For Widgets" }
  topic_support 		      { link(:text => "A Watir Topic With Many Posts") }
  topic_engagement 		      { link(:text => "A Watir Topic") }
  topic_engagement2 	      { link(:text => "A Watir Topic For Widgets") }
  topic_page 			      { div(:id => "topics").div(:class => "col-sm-12 col-lg-4 col-md-4").div(:class => "topic").link(:class => "ember-view").div(:class => "topic-avatar") }
  topic_sort_button 	      { button(:class => "btn btn-default dropdown-toggle filter-dropdown sap-regular-dropdown", :text => "Sorted by: Newest") }
  topic_mainpage_link	      { div(:id => "topics") }

  topic_publish_change_button { div(:class => "topic-create-wizard").div(:class => "container").div(:class => "row").div(:class => "button-align-right").button(:class => "btn btn-primary btn-sm", :text => "Publish Changes") }
  topic_admin_button 		  { div(:class => "buttons col-lg-7 col-md-7").div(:class => "btn-toolbar pull-right").div(:class => "btn-group").button(:class => "btn btn-default btn-sm admin-dark-btn topic-admin-buttons") }

  topic_activate_button 	  { button(:class => "btn btn-default btn-sm admin-dark-btn", :value => "Activate Topic") }
  topic_deactivate_button 	  { link(:class => "btn btn-default btn-sm admin-dark-btn", :text => "Deactivate Topic") }
  topic_filter				  { div(:class => "topic-filters") }

  post_body 				  { div(:class => "media-body") }
  topic_grid 				  { div(:class => "topics-grid row") }
  topiclink 				  { link(:text => "Topics") }
  topic_page_divid 		      { div(:id => "topics") }
  topicname 				  { div(:class => "row title") }

  topic_feature 			  { div(:class => "btn-group").button(:class => "btn btn-default btn-sm admin-dark-btn topic-admin-buttons", :text => "Feature Topic") }
  topic_unfeature 		      { div(:class => "btn-group").button(:class => "btn btn-default btn-sm admin-dark-btn topic-admin-buttons", :text => "Unfeature Topic") }

  topic_page_top_button     { div(:class => "row topic-button-toolbar") }

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
      @browser.screenshot.save screenshot_dir('topicsort.png')
      refute_nil @browser.execute_script 'return $(".topic-sort-drop-down >button").trigger("click")', "Failed to open the dropdown"
      refute_nil @browser.execute_script 'return $(".filter-dropdown a:contains(\'Name\')").trigger("click")', "Failed to Name sort option in the dropdown"
      @browser.wait_until { topic_mainpage_link.text =~ /#{topic_name}/ }
      @browser.wait_until { topic_page.present? }
      assert topic_mainpage_link.text =~ /#{topic_name}/
    end
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
    @browser.wait_until { post_body.present? }

  end

  def topic_detail(topic_name)
    if respond_to?(:deprecate)
      deprecate __method__, "Use fixtures for getting topic related information. \nExample: @browser.goto topics(:a_watir_topic).url"
    end

    if ($topic_uuid != nil && $topic_uuid != 0)
      @browser.goto "#{@@base_url}"+"/topic/"+$topic_uuid+"/#{@@slug}/"+topic_name
    else
    if !(topic_grid.present?)
     topiclink.when_present.click
     @browser.wait_until { topic_grid.present? }
    end
    @browser.wait_until { topic_page.present? }
    if ( !(topic_page_divid.text.include? topic_name) && !(topic_page_divid.link(:text => topic_name).visible?))
     topic_sort_by_name
    end
    @browser.execute_script("window.scrollBy(0,3000)")
    @browser.link(:class => "ember-view", :text => topic_name).when_present.click
    @browser.wait_until { topic_filter.present? }
    topic_url = @browser.url
    $topic_uuid = topic_url.split("/topic/")[1].split("/")[0]
    end
  end

  def click_topic_feature
    topic_publish
    topic = topicname.h1.text
    if topic_unfeature.present?
      topic_unfeature.click
    end
    @browser.wait_until { topic_feature.present? }
    topic_feature.when_present.click
    @browser.wait_until { topic_unfeature.present? }
    sleep 2 #assert @topic_unfeature.present?
    return topic
  end

  def click_topic_unfeature
    topic_publish
    topic = topicname.h1.text
    if topic_feature.present?
      topic_feature.click
    end
    @browser.wait_until { topic_unfeature.present? }
    topic_unfeature.when_present.click
    @browser.wait_until { topic_feature.present? }
    return topic
  end

end
