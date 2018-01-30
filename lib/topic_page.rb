module TopicPage 

  def topic_detail(topic_name)
    if respond_to?(:deprecate)
      deprecate __method__, "Use fixtures for getting topic related information. \nExample: @browser.goto topics(:a_watir_topic).url"
    end

    if ($topic_uuid != nil && $topic_uuid != 0)
      @browser.goto "#{$base_url}"+"/topic/"+$topic_uuid+"/#{$networkslug}/"+topic_name
    else   
      if !(@browser.div(:class => "topics-grid row").exists?)
         @browser.link(:text => "Topics").when_present.click
         @browser.wait_until($t) { @browser.div(:class => "topics-grid row").exists? }
      end
       assert @browser.div(:class => "topics-grid row").exists?
       @browser.wait_until($t) { @browser.div(:class => "topics").div(:class => "topics-grid row").div(:id => "topics").div(:class => "col-sm-12 col-lg-4 col-md-4").present? }
       assert @browser.div(:class => "topics").div(:class => "topics-grid row").div(:id => "topics").div(:class => "col-sm-12 col-lg-4 col-md-4").present?
       if !(@browser.link(:class => "ember-view", :text => topic_name).present?)
         topic_sort_by_name
       end
       @browser.execute_script("window.scrollBy(0,3000)")
       @browser.link(:class => "ember-view", :text => topic_name).when_present.click
       @browser.wait_until($t) { @browser.div(:class => "topic-filters").exists? }
       assert @browser.div(:class => "topic-filters").exists?
       topic_url = @browser.url
       $topic_uuid = topic_url.split("/topic/")[1].split("/")[0]
    end
  end

  def topic_list_view
    if @browser.div(:class => "topics-grid row").exists?
       @browser.div(:class => "topic-view-option icon-list pull-right").when_present.click
       @browser.wait_until($t) { @browser.div(:class => "topics-list row").exists? }

       assert @browser.div(:class => "topics-list row").exists?
    end
  end  

  def topic_sort_by_name
    topic_name = "A Watir Topic"
    if @browser.button(:class => "btn btn-default dropdown-toggle filter-dropdown sap-regular-dropdown", :text => "Sort by: Newest").exists? 
      @browser.screenshot.save screenshot_dir('topicsort.png')
      refute_nil @browser.execute_script 'return $(".topic-sort-drop-down >button").trigger("click")', "Failed to open the dropdown"
      refute_nil @browser.execute_script 'return $(".filter-dropdown a:contains(\'Name\')").trigger("click")', "Failed to Name sort option in the dropdown"
      @browser.wait_until {@browser.link(:class => "ember-view", :text => /#{topic_name}/).present?}
      assert @browser.link(:class => "ember-view", :text => /#{topic_name}/).present?
    end
  end

  def xcreate_new_topic(network, networkslug, topictype, advertise, topicname)
    #puts "#{network}"
    network_landing(network)
    main_landing("regular", "logged")
   # topic_detail("A Watir Topic")
   # admin_check(networkslug)
   # topicname = "Watir created topic - #{get_timestamp}"
    topicdescrip = "Watir topic test description - #{get_timestamp}"
    filetile = "#{$rootdir}/seeds/development/images/watir2Tile.jpeg"
    filebanner = "#{$rootdir}/seeds/development/images/watir2Banner.jpg"

    go_to_admin_page(networkslug)
    topics_link = @browser.link(:href => "/admin/#{networkslug}/topics")
    @browser.wait_until($t) { topics_link.present? }
    topics_link.click
    new_topic_button = @browser.div(:class => "shown col-lg-12").link(:class => "btn btn-primary pull-right ember-view", :text => "+ New Topic")
    @browser.wait_until($t) { new_topic_button.present? }
    assert new_topic_button.present?
    new_topic_button.click
    @browser.wait_until($t) { @browser.text_field(:id => "new-topic-title").present? }
    @browser.text_field(:id => "new-topic-title").set topicname
    @browser.text_field(:id => "topic-caption-input").when_present.set topicdescrip

    if $os == "windows"
      @browser.execute_script('$(".photo-upload-browse").removeClass("photo-upload-browse")')
    end

    assert @browser.link(:text => "browse").exists?
    @browser.file_field(:class => "files").set filetile
    @browser.wait_until($t) {@browser.div(:class => "cropper-canvas").exists? }
    @browser.button(:class => "btn btn-primary btn-sm file-upload-select-button", :text => "Select Photo").when_present.click
    @browser.wait_until { !@browser.div(:class => "cropper-canvas").present? }
  
    @browser.wait_until($t) { @browser.div(:class => "ember-view uploader-component topic-tile-upload").exists? }
    topic_tile_image = @browser.div(:class => "ember-view uploader-component topic-tile-upload").style 

    #URL doesnt get saved, so following assertion will fail, hence commented out.
    #assert_match /watir2Tile.jpeg/, topic_tile_image, " topic tile should match watir2Tile.jpeg "
    assert @browser.button(:class => "btn btn-default", :text => "Change Photo").exists?
    assert @browser.button(:class => "btn btn-default", :text => "Delete Photo").exists?

    @browser.execute_script("window.scrollBy(0,1000)")
    @browser.wait_until($t) { @browser.div(:class => "topic-type-selection-box engagement chosen").exists? }  

    if (topictype == "engagement")
        @browser.div(:class => "topic-type-selection-box engagement").when_present.click
        assert @browser.div(:class => "topic-type-selection-box engagement chosen", :text => /Engagement/).present?
    end
    if (topictype == "q&a")
       @browser.div(:class => "topic-type-selection-box support", :text => /Q&A/).when_present.click
       assert @browser.div(:class => "topic-type-selection-box support chosen", :text => /Q&A/).present?
    end

    if advertise != nil
      advertise_check = @browser.div(:text => /Enable advertising/).input(:class => "ember-view ember-checkbox")
      advertise_check.when_present.click if advertise != advertise_check.checked?
    end

    @browser.button(:class => "btn btn-primary", :text => /Next: Design/).when_present.click
    sleep 4
    @browser.wait_until($t) { @browser.div(:class => "row topic-create-title").present? }
    assert @browser.div(:class => "topic-type-text").present?
    assert @browser.div(:class => "widget-container col-lg-4 col-md-3 side zone").present? 
    assert @browser.link(:text => "browse").exists?
    @browser.file_field(:class => "files").set filebanner
    @browser.wait_until($t) {@browser.div(:class => "cropper-canvas").exists? }
    @browser.button(:class => "btn btn-primary btn-sm file-upload-select-button", :text => "Select Photo").when_present.click
    @browser.wait_until { !@browser.div(:class => "cropper-canvas").present? }

    sleep 3
    @browser.wait_until($t) { @browser.div(:class => "ember-view uploader-component widget banner normal topic").exists? }
    topic_banner = @browser.div(:class => "ember-view uploader-component widget banner normal topic").style
    assert_match /watir2Banner.jpg/, topic_banner, "background url should match watir2Banner.jpg"
    assert @browser.button(:class => "btn btn-default", :text => "Change Photo").exists?
    assert @browser.button(:class => "btn btn-default", :text => "Remove Photo").exists?
    @browser.execute_script("window.scrollBy(0,1000)")
    @browser.button(:class => "btn btn-primary", :text => /Next: View Topic/).when_present.click
    @browser.wait_until($t) { @browser.button(:class => "btn btn-primary", :text => /Activate Topic/).present? }
    @browser.button(:class => "btn btn-primary", :text => /Activate Topic/).when_present.click
    @browser.wait_until($t) { @browser.button(:class => "btn btn-default", :text => /Edit Topic/).present? }  
    assert @browser.button(:class => "btn btn-default", :text => "Edit Topic").exists?
    assert @browser.link(:class => "btn btn-default", :text => "Deactivate Topic").exists?
    assert @browser.button(:class => "btn btn-default", :text => "Feature Topic").exists?
    assert @browser.div(:class => "row title", :text => /#{topicname}/).present?
    assert @browser.div(:class => "topic-filters").present?

    if (topictype == "engagement")
      @browser.wait_until($t) { @browser.div(:class => "widget popular_discussions").present? }
      assert @browser.div(:class => "widget popular_discussions").present?
    end
    if (topictype == "q&a")
      assert @browser.div(:class => "widget popular_answers").present?
    end
    
    if advertise != nil
      if advertise
        @browser.wait_until($t){ @browser.div(:id => "ads_banner").present? }
        @browser.wait_until($t){ @browser.div(:id => "ads_side").present? }
      elsif !advertise
        assert !@browser.div(:id => "ads_banner").present?
        assert !@browser.div(:id => "ads_side").present?
      end
    end
    @browser.refresh
    return topicname
  end

  def feature_topic
    feature_button = @browser.button(:class => "btn btn-default btn-sm admin-dark-btn", :text => "Feature Topic")
    @browser.wait_until($t) { feature_button.present? }
    feature_button.click
    @browser.wait_until { @browser.button(:class => "btn btn-default btn-sm admin-dark-btn", :text => "Unfeature Topic").present? }
    assert @browser.button(:class => "btn btn-default btn-sm admin-dark-btn", :text => "Unfeature Topic").present?
  end

  def unfeature_topic
    unfeature_button = @browser.button(:class => "btn btn-default btn-sm admin-dark-btn", :text => "Unfeature Topic")
    @browser.wait_until($t) { unfeature_button.present? }
    sleep 2
    unfeature_button.click
    @browser.wait_until { @browser.button(:class => "btn btn-default btn-sm admin-dark-btn", :text => "Feature Topic").present? }
    assert @browser.button(:class => "btn btn-default btn-sm admin-dark-btn", :text => "Feature Topic").present?
  end

  def sort_by_old_in_conversation_list
    @browser.div(:class => "pull-right btn filter-dropdown").span(:class => "caret").when_present.click
    @browser.wait_until($t) { @browser.div(:class => "sorter").div(:class => "pull-right btn filter-dropdown").text.include? "Sort by: Oldest"}
    assert @browser.div(:class => "sorter").div(:class => "pull-right btn filter-dropdown").text.include? "Sort by: Oldest"
  end

  def sort_by_new_in_conversation_list
    @browser.div(:class => "pull-right btn filter-dropdown").span(:class => "caret").when_present.click
    @browser.wait_until($t) { @browser.div(:class => "sorter").div(:class => "pull-right btn filter-dropdown").text.include? "Sort by: Newest"}
    assert @browser.div(:class => "sorter").div(:class => "pull-right btn filter-dropdown").text.include? "Sort by: Newest"
  end

  def post_detail(post_name=nil,type)
    choose_post_type(type)
    @browser.wait_until($t){ !@browser.i(:class => "fa fa-spinner fa-2x fa-spin").exists? }
    if post_name
      @browser.link(:text => post_name).when_present.click
    else
      @browser.link(:class => "ember-view media-heading", :index => 0).when_present.click
    end
    textarea = @browser.textarea(:class => "ember-view ember-text-area form-control")
    @browser.wait_until($t) { textarea.exists? }
    @browser.wait_until($t) { @browser.div(:class => /ember-view/).exists? }
    @browser.wait_until($t) { @browser.div(:class => "conversation-content").exists? }
    sleep 2
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
    #@browser.wait_until($t) { link.class_name.include? "disabled" }
    @browser.wait_until { @browser.div(:class => "media-body").exists? }
    assert @browser.div(:class => "media-body").exists?
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

  def edit_topic(networkslug, old_topic_name, topic_params)
    admin_check(networkslug)
    @browser.link(:href => "/admin/#{networkslug}").when_present.click
    @browser.wait_until($t) { @browser.div(:class => "navbar-collapse collapse sidebar-navbar-collapse").exists? }
    @browser.link(:href => "/admin/#{networkslug}/topics").when_present.click
    @browser.wait_until($t) { @browser.div(:class => "shown col-lg-12").link(:class => "ember-view btn btn-primary pull-right", :text => "+ New Topic").exists? }
    @browser.button(:id => "admin-topics-list-sort").when_present.click
    @browser.div(:class => "btn-group pull-right open").link(:text => "Name").when_present.click
    @browser.div(:class => "topics-list row", :text => /#{old_topic_name}/).link(:text => "Edit").when_present.click
    @browser.wait_until($t) { @browser.input(:id => "new-topic-title").exists? }

    @browser.text_field(:id => "new-topic-title").set topic_params[:topic_name] if topic_params[:topic_name]
    @browser.text_field(:id => "topic-caption-input").when_present.set topic_params[:topic_desc] if topic_params[:topic_desc]
    
    if topic_params[:advertise] != nil
      advertise_check = @browser.div(:text => /Enable advertising/).input(:class => "ember-view ember-checkbox")
      advertise_check.when_present.click if topic_params[:advertise] != advertise_check.checked?
    end
  
    if topic_params[:topic_image]
      @browser.link(:class => "edit-button", :text => "browse").when_present.click
      @browser.wait_until($t) { @browser.div(:class => "modal-header").exists? }
      assert @browser.form(:class => "ember-view").file_field(:class => "ember-view ember-text-field files").exists?
      sleep 3
      @browser.file_field(:class => "ember-view ember-text-field files").set topic_params[:topic_image]
      @browser.wait_until($t) {@browser.div(:class => "cropper-canvas").exists? }
      @browser.button(:class => "ember-view btn btn-primary btn-sm", :text=> /Select Image/).when_present.click
    end
    
    if topic_params[:topic_type]
      @browser.execute_script("window.scrollBy(0,600)")
      assert @browser.div(:class => "row topic-type-selection-box").div(:class => "col-md-10").div(:class => "radio").exists?
  
      if (topic_params[:topic_type] == "engagement")
          @browser.div(:class => "radio", :text => /Engagement/).when_present.click
          assert @browser.div(:class  => "row topic-type-selection-box chosen", :text => /Engagement/).present?
      end
      if (topic_params[:topic_type] == "q&a")
         @browser.div(:class => "radio", :text => /Q&A/).when_present.click
         assert @browser.div(:class  => "row topic-type-selection-box chosen", :text => /Q&A/).present?
      end
    end

    @browser.div(:class => "button-align-right").link(:text => /Next/).when_present.click
    @browser.wait_until($t) { @browser.h3(:text => "Edit Topic").exists? }
    
    if topic_params[:topic_banner]
      @browser.link(:class => "edit-button").when_present.click
      @browser.wait_until($t) { @browser.div(:class => "modal-header").exists? }
      assert @browser.form(:class => "ember-view").file_field(:class => "ember-view ember-text-field files").exists?
      sleep 3
      @browser.file_field(:class => "ember-view ember-text-field files").set filebanner
      @browser.wait_until($t) {@browser.div(:class => "cropper-canvas").exists? }
      @browser.button(:class => "btn btn-primary", :text => "Upload Image").when_present.click
      @browser.wait_until($t) { @browser.div(:class => "widget topic-banner").exists? }
    end
    
    @browser.button(:class => "btn btn-primary pull-right", :text => "Next: View Topic").when_present.click
    @browser.wait_until($t) { @browser.div(:class => "topic-create-wizard").exists? }
    #assert @browser.div(:class => "topic-header").text.include? topic_params[:topic_name]
    assert @browser.div(:class => "topic-filters").exists?

    # if (topic_params[:topic_type] == "engagement")
      # assert @browser.div(:class => "widget", :text => /Popular Discussions/).exists?
    # end
    # if (topic_params[:topic_type] == "q&a")
      # assert @browser.div(:class => "widget", :text => /Popular Answers/).exists?
    # end

    @browser.button(:class => "btn btn-primary btn-sm", :text => /Publish Changes/).when_present.click
    @browser.wait_until($t) {!@browser.div(:class => "topic-create-wizard").div(:class => "container").div(:class => "row").div(:class => "button-align-right").button(:class => "btn btn-primary btn-sm", :text => /Activate Topic/).exists? }
    assert @browser.button(:class => "btn btn-default btn-sm", :text => "Edit Topic").exists?
    if topic_params[:topic_name] 
      return topic_params[:topic_name]
    else
      return old_topic_name
    end
    
  end

  def product_topic_detail(topic_name)
    @browser.link(:href => "/n/nike/products").when_present.click
    @browser.link(:class => "ember-view", :text => topic_name).when_present.click
    @browser.wait_until($t) { @browser.div(:class => "topic-filters").exists? }
    assert @browser.div(:class => "topic-filters").exists?
  end

end