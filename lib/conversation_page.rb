module ConversationPage

  # def create_conversation(network, networkslug, topic_name, posttype, title, widget=true)
    
  # if (!widget)
  #   @browser.goto "#{$base_url}"+"/n/#{networkslug}"
  #   @browser.wait_until($t){ @browser.div(:id => "topics").present? }

  #   if (@browser.div(:class => "pull-right flex-content-center").text.include? "Sign In")
  #   network_landing(network)
  #   main_landing("regular", "logged")
  #   end

  #   topic_detail(topic_name)
  #   @browser.wait_until($t) { @browser.div(:class => "topic-filters").exists? }
  #   assert @browser.div(:class => "topic-follow-button").exists?

  #   if @browser.div(:class => "topic-create-wizard").div(:class => "container").div(:class => "row").div(:class => "button-align-right").button(:class => "btn btn-primary btn-sm", :text => "Publish Changes").exists?
  #     @browser.div(:class => "topic-create-wizard").div(:class => "container").div(:class => "row").div(:class => "button-align-right").button(:class => "btn btn-primary btn-sm", :text => "Publish Changes").click
  #     @browser.wait_until($t) {@browser.button(:class => "btn btn-default btn-sm admin-dark-btn", :text => "Edit Topic").present? }
  #     assert @browser.button(:class => "btn btn-default btn-sm admin-dark-btn", :text => "Edit Topic")
  #   end

  #   if posttype == "review"
  #     @browser.link(:class => "blog ", :text => "Reviews").click
  #     @browser.wait_until($t) { @browser.div(:class => "topic-follow-button").button(:class => "btn btn-primary", :text => "New Review").present? }
  #     @browser.div(:class => "topic-follow-button").button(:class => "btn btn-primary", :text => "New Review").click
  #   #end
  #   else
  #     @browser.button(:class => "btn btn-primary", :text => /Create New/).when_present.click

  #     @browser.wait_until($t) { @browser.div(:class => "row post-type-picker").present? }

  #   end
  # end

  #   @browser.text_field(:class => "form-control ember-view ember-text-field").when_present.set title
    
  #   if posttype == "question" || posttype == "question_with_image"
  #     @browser.wait_until($t) { @browser.div(:class => "shown").exists? } #suggested posts
  #     if !@browser.div(:class => "post-type question chosen").present?
  #      @browser.div(:class => "post-type question ").when_present.click
  #     end
  #     @browser.wait_until($t) { @browser.div(:class => "post-type question chosen").present? }
  #   end
  #   if posttype == "discussion" || posttype == "discussion_with_link"
  #     @browser.wait_until($t) { @browser.div(:class => "shown").exists? } #suggested posts
  #     if !@browser.div(:class => "post-type discussion chosen").present?
  #      @browser.div(:class => "post-type discussion ").when_present.click
  #     end
  #     @browser.wait_until($t) { @browser.div(:class => "post-type discussion chosen").present? }
  #   end
  #   if posttype == "blog" || posttype == "blog_with_video"
  #     if !@browser.div(:class => "post-type blog chosen").present?
  #      @browser.div(:class => "post-type blog ").when_present.click
  #     end
  #     @browser.wait_until($t) { @browser.div(:class => "post-type blog chosen").present? }
  #   end

  #   #if posttype == "discussion_with_link" #always have link in it
  #   #  @browser.execute_script('$("button[data-event=showLinkDialog]").get(1).click()')
  #   #  @browser.wait_until($t) {
  #   #    @browser.text_field(:class => "note-link-text").present?
  #   #  }
  #   #  link_href = "http://jambajuice.com"
  #   #  link_title = "Jamba Juice"
  #   #end

  #   if posttype == "question_with_link" #always have link in it
  #     if !@browser.div(:class => "post-type question chosen").present?
  #      @browser.div(:class => "post-type question ").when_present.click
  #     end
  #     @browser.wait_until($t) { @browser.div(:class => "post-type question chosen").present? }
  #     #@browser.execute_script('$("button[data-event=showLinkDialog]").get(1).click()')
  #     #@browser.wait_until($t) {
  #     #  @browser.text_field(:class => "note-link-text").present?
  #     #}
  #     link_href = "http://jambajuice.com"
  #     link_title = "Jamba Juice"

  #   end


  #   if posttype == "blog_with_video"
  #     @browser.execute_script('$("button[data-event=showVideoDialog]").click()')
  #     @browser.wait_until($t) {
  #       @browser.text_field(:class => "note-video-url").present?
  #     }

  #     video_url = "https://www.youtube.com/watch?v=prCKZg5ONGg"

  #     assert @browser.text_field(:class => "note-video-url").present?, "Modal for video not present"
  #     @browser.text_field(:class => "note-video-url").set(video_url)
  #     @browser.button(:class => "btn-primary note-video-btn").when_present.click
  #     #assert @browser.div(:class => "conversation-content").exists?

  #   end
  #   if posttype == "discussion_with_link" || posttype == "question_with_link"
  #     @browser.execute_script('$("div.note-editable").text("http://www.jambajuice.com\n")')
  #     @browser.execute_script('$("div.note-editable").focus()')
  #     @browser.send_keys :space
  #     @browser.execute_script("window.scrollBy(0,800)")
     
  #     @browser.wait_until($t) { @browser.img(:src => /jambajuice/).present? }
  #     @browser.wait_until($t) { @browser.p( :text => "Healthy breakfast, quick lunch or a delicious snack. Try Jamba Juice fruit smoothies, all-natural baked goods, steel-cut oatmeal, sandwiches and other healthy choices for an active lifestyle.").present? }
      
  #     assert @browser.img(:src => /jambajuice/).present? 
  #     assert @browser.div(:class => "note-editable panel-body").p(:text => "Healthy breakfast, quick lunch or a delicious snack. Try Jamba Juice fruit smoothies, all-natural baked goods, steel-cut oatmeal, sandwiches and other healthy choices for an active lifestyle.").present? 
  #   else
    
  #   @browser.execute_script('$("div.note-editable").html($("div.note-editable").html() + " Watir test description")')
  #   @browser.execute_script('$("div.note-editable").blur()') #needed to communicate the description back to the parent element. the blur events fires fine during manual creation.
  #   @browser.execute_script("window.scrollBy(0,600)")
  #   end
  #   @browser.wait_until($t) { @browser.div(:class => "controls text-right").button(:class => "btn btn-primary").present? }
  #   @browser.div(:class => "controls text-right").button(:class => "btn btn-primary", :value => "Submit").when_present.click
  #   #@browser.wait_until($t) { !@browser.div(:class => "controls text-right").button(:class => "btn btn-primary", :value => /Submit/).present? }
  #   @browser.wait_until($t) { @browser.div(:class => /depth-0/).present?}

  #   if posttype == "discussion_with_link" || posttype == "question_with_link"
  #     @browser.wait_until($t) { @browser.div(:class => "post-content").present? }
  #     @browser.wait_until($t) { @browser.img(:src => /image_preview/).present? }

  #     assert @browser.div(:class => "post-content").present?
  #     assert @browser.img(:src => /image_preview/).present? 
  #   end
  
  #   return title
  # end

  def conversation_detail(type, post_name = nil)
    if !(post_name == nil)
      #sort_by_old_in_conversation_list #comment out sort by old for now
      #@browser.wait_until($t) { @browser.div(:class => "col-lg-8 col-md-8 widget-container zone main").div(:class => "post-collection").div(:class => "post media ").exists? }
      until @browser.text.include? post_name
      @browser.execute_script("window.scrollBy(0,1900)")
      @browser.link(:text => "Show more").click
      @browser.wait_until { @browser.div(:class => "post-collection").exists? }
      @browser.text.include? post_name
      end
      @browser.link(:text => post_name).when_present.click
    if (type == "question")
      @browser.wait_until { @browser.div(:class => /ember-view depth-1 answer post/).exists? }
      assert @browser.div(:class => /ember-view depth-1 answer post/).exists?
      assert @browser.h3(:class => "media-heading root-post-title").text.include? post_name
    end
    if (type == "discussion")
      @browser.wait_until($t) { @browser.div(:class => /depth-0 discussion/).exists? }
      assert @browser.div(:class => "conversation-content").exists?
      assert @browser.h3(:class => "media-heading root-post-title").text.include? post_name
    end
    if (type == "blog")
      @browser.wait_until($t) { @browser.div(:class => "conversation-content").exists? }
      assert @browser.h3(:class => "media-heading root-post-title").text.include? post_name
    end
  #end
  else
    @browser.wait_until { @browser.div(:class => "post-collection").present? }
    @browser.div(:class => "post-collection").div(:class => "media-heading").link.when_present.click
    if (type == "question")
      @browser.wait_until { @browser.div(:class => /row conversation-root-post/).exists? }
      assert @browser.div(:class => /row conversation-root-post/).exists?
    end
    if (type == "discussion")
      @browser.wait_until($t) { @browser.div(:class => /row conversation-root-post/).exists? }
      assert @browser.div(:class => /row conversation-root-post/).exists?
    end
    if (type == "blog")
      @browser.wait_until($t) { @browser.div(:class => /ember-view root-post/).exists? }
      assert @browser.div(:class => /ember-view root-post/).exists?
    end
    end

  end

  def conversation_detail_reply
    if ( !@browser.div(:class => /ember-view depth-1/).present? )
        answer_text = "Comment/Reply by Watir - #{get_timestamp}"
        @browser.textarea(:class => "ember-view ember-text-area form-control").when_present.focus
        @browser.wait_until($t) { @browser.div(:class => "group text-right").exists? }
        @browser.textarea(:class => "ember-view ember-text-area form-control").when_present.set answer_text
        @browser.button(:text => "Submit").when_present.click
        @browser.wait_until { @browser.div(:class => /ember-view depth-1/).present? }
      end
  end

  def insert_video(video_url)
    @browser.link(:text => "Insert Video").when_present.click
    @browser.text_field(:id => "insert-video-input").when_present.set video_url
    @browser.button(:class => "btn btn-primary btn-sm").when_present.click
  end

  def comment_root_post(comment_text,link=false)
    @browser.textarea(:class => "ember-view ember-text-area form-control").when_present.focus
    @browser.wait_until($t) { @browser.div(:class => "group text-right").present? }
    @browser.textarea(:class => "ember-view ember-text-area form-control").when_present.set comment_text
    sleep 2
    if link
      @browser.wait_until($t) {@browser.div(:class => "visible-preview").present?}
    end
    @browser.button(:value => /Submit/).when_present.click
    sleep 2
    if !link
      @browser.wait_until($t) { @browser.div(:class => "media-body", :text => /#{comment_text}/).exists? }
    end
  end

  def at_mention_product(product_hint)
    @browser.textarea(:class => "ember-view ember-text-area form-control").when_present.focus
    @browser.wait_until($t) { @browser.div(:class => "group text-right").present? }
    comment_text = "reply by Watir - #{get_timestamp} "
    mention_text = comment_text + "@" + product_hint
    @browser.textarea(:class => "ember-view ember-text-area form-control").when_present.focus
    @browser.textarea(:class => "ember-view ember-text-area form-control").set mention_text
    @browser.wait_until($t) {@browser.div(:class => "at-list-wrap").present?}
    @browser.wait_until($t) {@browser.p(:class => "at-list-title").present?}
    @browser.send_keys :enter
    @browser.wait_until($t) {@browser.div(:class => "wmd-preview").div(:class => "conversation-product").present?}
    @browser.button(:value => /Submit/).when_present.click
    post = @browser.div(:class => "depth-1", :text => /#{comment_text}/)
    post_card = post.div(:class => "conversation-product")
    #@browser.wait_until($t) { post.present? }
    #@browser.execute_script("window.scrollBy(0,-2000)")
    if @browser.div(:class => "pull-right sort-by dropdown").span(:class => "dropdown-toggle", :text => /Oldest/).exists?
      sort_by_new_in_conversation_detail
    end
    #@browser.execute_script("window.scrollBy(0,6000)")
    @browser.wait_until($t) { post_card.present? }
    post_card.link(:class => "btn btn-primary pull-left product-buy-left-link", :text => "Buy Now").href
  end

  def reply_to_comment(reply_text, comment_name=nil)
    comment_div = get_post(1,comment_name)
    comment_div.link(:text => "Reply").when_present.click
    @browser.wait_until($t) { comment_div.div(:class => "group text-right").exists? }
    comment_div.textarea(:class => "ember-view ember-text-area form-control").when_present.set reply_text
    sleep 2
    comment_div.button(:value => /Submit/).when_present.click
    sleep 2
    @browser.wait_until($t) { @browser.p(:text => reply_text).exists? }
  end

  def like_root_post
    like_post(0)
  end

  def unlike_root_post
    unlike_post(0)
  end

  def like_comment(comment_name=nil)
    like_post(1,comment_name)
  end

  def unlike_comment(comment_name=nil)
    unlike_post(1,comment_name)
  end

  def like_reply(reply_name=nil)
    like_post(2,reply_name)
  end

  def unlike_reply(reply_name=nil)
    unlike_post(2,reply_name)
  end

  def follow_root_post
    follow_post(0)
  end

  def unfollow_root_post
    unfollow_post(0)
  end

  def follow_comment(comment_name=nil)
    follow_post(1,comment_name)
  end

  def unfollow_comment(comment_name=nil)
    unfollow_post(1,comment_name)
  end

  def follow_reply(reply_name=nil)
    follow_post(2,reply_name)
  end

  def unfollow_reply(reply_name=nil)
    unfollow_post(2,reply_name)
  end

  def ques_and_ans_detail
    @browser.link(:class => "disc  btn-default", :text => /Discussions/).when_present.click
    @browser.wait_until($t){ @browser.div(:class => "post-collection").exists? }
    @browser.wait_until($t){ @browser.div(:class => "post-collection").div(:class => "post media").exists? }
  end

  def report_root_post
    report_post(0)
  end

  def report_comment(post_name=nil)
    report_post(1,post_name)
  end

  def report_reply(post_name=nil)
    trigger_report(2,post_name)
  end

  def feature_root_post
    feature_post(0)
  end

  def feature_comment(post_name=nil)
    feature_post(1,post_name)
  end

  def feature_reply(post_name=nil)
    feature_post(2,post_name)
  end

  def unfeature_root_post
    unfeature_post(0)
  end

  def unfeature_comment(post_name=nil)
    unfeature_post(1,post_name)
  end

  def unfeature_reply(post_name=nil)
    unfeature_post(2,post_name)
  end

  def like_post(level,post_name=nil)
    like_element = get_post(level,post_name).link(:class => "like")
    like_element.when_present.click
    @browser.wait_until($t) { (like_element.text =~ /Unlike/ )}
  end

  def unlike_post(level,post_name=nil)
    like_element = get_post(level,post_name).link(:class => "like")
    like_element.when_present.click
    @browser.wait_until($t) { (like_element.text =~ /Like/ )}
  end

  def follow_post(level,post_name=nil)
    like_element = get_post(level,post_name).link(:class => "follow")
    sleep 2
    like_element.when_present.click
    @browser.wait_until($t) { (like_element.text =~ /Unfollow/ )}
  end

  def unfollow_post(level,post_name=nil)
    like_element = get_post(level,post_name).link(:class => "follow")
    sleep 2
    like_element.when_present.click
    @browser.wait_until($t) { (like_element.text =~ /Follow/ )}
  end

  # TODO: Navjeet
  # All steps below should be in a single test only for feature/unfeature 
  # and not be tied to the act of featuring/unfeaturing as a helper

  def do_feature_post(level)
    refute_nil @browser.execute_script "return $(\".depth-#{level} .feature-class:contains('Feature')\").click()"
  end

  def do_unfeature_post(level)
    refute_nil @browser.execute_script "return $(\".depth-#{level} .feature-class:contains('Stop Featuring')\").click()"
  end

  def feature_post(level,post_name=nil)    
    post = get_post(level,post_name)
    post.span(:class => "dropdown-toggle").when_present.click
    @browser.wait_until { post.link(:text => /Feature/).present? }
    post.link(:text => /Feature/).when_present.click
    @browser.wait_until { @browser.link(:class => "feature-class featured-link").exists? }
    
    assert @browser.link(:class => "feature-class featured-link").exists?
  end

  def unfeature_post(level,post_name=nil)
    post = get_post(level,post_name)
    post.span(:class => "dropdown-toggle").when_present.click
    post.link(:text => "Stop Featuring").when_present.click
    sleep 2
    @browser.wait_until($t){ !get_post(level,post_name).class_name.include? "feature"}
    assert (!get_post(level,post_name).class_name.include? "feature")
  end

  def report_post(level,post_name=nil)
    trigger_menu("Report this content",level,post_name)
  end

  def trigger_menu(menu_name,level,post_name=nil)
    post = get_post(level,post_name)
    post.span(:class => "dropdown-toggle").when_present.click
    menu = post.link(:text => /#{menu_name}/)
    sleep 1
    menu.when_present.click
    return menu
  end

  def get_post(level,post_name=nil,count=0)
    if post_name
      element = @browser.div(:class => /depth-#{level}/,:text => /#{post_name}/)
    else
      element = @browser.div(:class => /depth-#{level}/) #,:index => count)
    end

    @browser.wait_until($t){ element.exists? }
    return element
  end

  def sort_by_old_in_conversation_detail
    @browser.div(:class => "clearfix").div(:class => "pull-right sort-by dropdown").span(:class => "dropdown-toggle").span(:class => "icon-down fs-7").when_present.click
    @browser.wait_until($t) { @browser.div(:class => "pull-right sort-by dropdown open").exists? }
    @browser.link(:text => "Oldest").click
    sleep 1
    @browser.wait_until($t) { @browser.div(:class => "pull-right sort-by dropdown").text.include? "Sorted by: Oldest"}
    assert @browser.div(:class => "pull-right sort-by dropdown").text.include? "Sorted by: Oldest"
  end

  def sort_by_new_in_conversation_detail
    @browser.div(:class => "col-lg-8 col-md-9").span(:class=> "icon-down fs-7").when_present.click
    @browser.wait_until($t) { @browser.div(:class => "col-lg-8 col-md-9").div(:class => "pull-right sort-by dropdown open").present?}
    @browser.link(:text => "Newest").click
    @browser.wait_until { @browser.div(:class => "pull-right sort-by dropdown").text.include? "Sorted by: Newest"}
    @browser.wait_until { @browser.div(:class => /ember-view depth-1/).exists? }
    sleep 1
        
    assert @browser.div(:class => "pull-right sort-by dropdown").text.include? "Sorted by: Newest"
  end

  def topic_widgets_in_conversation_topic_type(network, networkslug, topicname, topictype)
    network_landing(network)
    main_landing("regular", "logged")
    @browser.link(:class => "ember-view", :text => topicname).when_present.click
    @browser.wait_until($t) { @browser.div(:class => "widget-container col-lg-3 col-md-4 zone side").exists? }
    if (topictype == "engagement")
      create_conversation($network, $networkslug, topicname, "discussion", "Discussion created by Watir for Widgets - #{get_timestamp}", false)
      assert @browser.div(:class => "widget-container col-lg-3 col-md-4 zone side").div(:class => "widget", :text => /Most Liked Posts/).exists?
      assert @browser.div(:class => "widget-container col-lg-3 col-md-4 zone side").div(:class => "featured-topics", :text => /Featured Topics/).exists?
      assert @browser.div(:class => "widget-container col-lg-3 col-md-4 zone side").div(:class => "widget", :text => /Popular Discussions/).exists?
      assert (!@browser.div(:class => "widget-container col-lg-3 col-md-4 zone side").div(:class => "widget", :text => /Open Questions/).present?)
    else
      create_conversation($network, $networkslug, topicname, "question", "Question created by Watir for Widgets - #{get_timestamp}", false)
      assert @browser.div(:class => "widget-container col-lg-3 col-md-4 zone side").div(:class => "widget", :text => /Popular Answers/).exists?
      assert @browser.div(:class => "widget-container col-lg-3 col-md-4 zone side").div(:class => "widget", :text => /Featured Posts/).exists?
      assert @browser.div(:class => "widget-container col-lg-3 col-md-4 zone side").div(:class => "widget", :text => /Most Featured Posts/).exists?
      assert @browser.div(:class => "widget-container col-lg-3 col-md-4 zone side").div(:class => "widget", :text => /Open Questions/).exists?
      assert (!@browser.div(:class => "widget-container col-lg-3 col-md-4 zone side").div(:class => "widget", :text => /Popular Discussions/).present?)
    end
  end
end
