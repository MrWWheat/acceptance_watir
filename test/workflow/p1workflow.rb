require File.expand_path(File.dirname(__FILE__) + "/../excelsior_watir_test.rb")
require File.expand_path(File.dirname(__FILE__) + "/../../lib/page_objects/page_object.rb")
require File.expand_path(File.dirname(__FILE__) + "/../../lib/test_helper.rb")

require File.expand_path(File.dirname(__FILE__) + "/../../lib/watir_lib.rb")

module P1workflow
  include WatirLib

  def test_00010_login
    PageObject.new(@browser).about_landing($networkslug)
    PageObject.new(@browser).main_landing("regular", "logged")
    #topic_sort_by_name
  end

  def xtest_00020_topic_list_view
    PageObject.new(@browser).network_landing($network)
    #main_landing("regular")
    if @browser.div(:class => "topics-grid row").exists?
       @browser.div(:class => "topic-view-option icon-list").when_present.click
       @browser.wait_until ($t) { @browser.div(:class => "topics-list row").exists? }
       assert @browser.div(:class => "topics-list row").exists?
    
       @browser.div(:class => "topic-view-option icon-grid").when_present.click
       @browser.wait_until($t) { @browser.div(:class => "topics-grid row").exists? }
       assert @browser.div(:class => "row").exists?, "Topics row doesn't exist"
    end
  end  

  def xtest_00030_topic_gallery_view
    PageObject.new(@browser).network_landing($networkslug)
    @browser.div(:class => "topic-view-option icon-list").when_present.click
    @browser.wait_until($t) { @browser.div(:class => "topics-list row").exists? }
    if @browser.div(:class => "topics-list row").exists?
       @browser.div(:class => "topic-view-option icon-grid").when_present.click
       @browser.wait_until($t) { @browser.div(:class => "topics-grid row").exists? }
       assert @browser.div(:class => "topic-avatar").exists?, "Topics grid view avatar doesn't exist"
    end
  end

  def xtest_00031_anon_topic_detail
    network_landing($networkslug)
    main_landing("anon", "visitor")
    topic_detail("A Watir Topic")
  end

  def xtest_00032_anon_post_conv
    network_landing($networkslug)
    main_landing("anon", "visitor")
    topic_detail("A Watir Topic")
    choose_post_type("question")
    conversation_detail("question")
    
    @browser.textarea(:class => "ember-view ember-text-area form-control").when_present.focus
    @browser.wait_until($t) { @browser.div(:class => "row signin-body").exists? }
    assert @browser.div(:class => "row signin-login").present?
  end

  def xtest_00033_anon_search
    network_landing($networkslug)
    main_landing("anon", "visitor")
    topic_detail("A Watir Topic")
    searchtext = "Watir Test Question1 ?"

    @browser.text_field(:class => "ember-view ember-text-field typeahead form-control tt-input").when_present.set searchtext
    @browser.wait_until($t) { @browser.span(:class => "tt-dropdown-menu").exists? }

    @browser.send_keys :enter
    @browser.wait_until { @browser.div(:class => "row filters search-facets").exists? }
    assert @browser.div(:class => "row filters search-facets").exists?
    #@browser.link(:text => /Questions/).when_present.click
    #@browser.wait_until { @browser.div(:class => "col-lg-8").present? }
    assert @browser.div(:class => "media-heading").text.include? searchtext
  end

  def xtest_00034_anon_post_like
    network_landing($networkslug)
    main_landing("anon", "visitor")
    topic_detail("A Watir Topic")
    choose_post_type("question")
    conversation_detail("question")
    @browser.link(:class => "like").when_present.click
    @browser.wait_until($t) { @browser.div(:class => "row signin-login").present? }
    assert @browser.div(:class => "row signin-login").present?
  end

  def xtest_00035_anon_post_follow
    network_landing($networkslug)
    main_landing("anon", "visitor")
    topic_detail("A Watir Topic")
    choose_post_type("question")
    conversation_detail("question")
    @browser.link(:class => "follow").when_present.click
    @browser.wait_until($t) { @browser.div(:class => "row signin-login").present? }
    assert @browser.div(:class => "row signin-login").present?
  end

  def xtest_00036_topic_detail
    network_landing($networkslug)
    topic_uuid = topic_detail("A Watir Topic")
    #puts "#{uuid}"
  end

  def xtest_00037_feature_unfeature_topic
    network_landing($network)
    main_landing("regular", "logged")
    topic_detail("A Watir Topic")
    @browser.wait_until { @browser.div(:class => "row topic-filter-set").present? }
    assert @browser.div(:class => "row topic-filter-set").present?
    if @browser.button(:class => "btn btn-default btn-sm admin-dark-btn", :text => "Unfeature Topic").present?
      unfeature_topic
    end
    feature_topic
    @browser.link(:href => "/n/#{$networkslug}", :class => "ember-view").click
    @browser.wait_until { @browser.div(:id => "topics").div(:class => "col-sm-12 col-lg-4 col-md-4").div(:class => "topic").div(:class => "topic-tile-body").exists? }
    assert @browser.div(:id => "topics").div(:class => "col-sm-12 col-lg-4 col-md-4").div(:class => "topic").div(:class => "topic-tile-body").exists?
    @browser.button(:class => "btn btn-default", :text => "Featured").click
    @browser.wait_until { @browser.div(:class => "col-sm-12 col-lg-4 col-md-4").exists? }
    assert @browser.div(:class => "col-sm-12 col-lg-4 col-md-4").exists?
    assert @browser.div(:class => "col-sm-12 col-lg-4 col-md-4", :text => /A Watir Topic/).exists?
    assert @browser.div(:class => "col-sm-12 col-lg-4 col-md-4", :text => /A Watir Topic/).div(:class => "topic").div(:class => "topic-tile-body").span(:class => "icon-favorite").exists?
    @browser.link(:class => "ember-view", :text => "A Watir Topic").click
    @browser.wait_until($t) { @browser.div(:class => "topic-filters").exists? }
    assert @browser.div(:class => "row title").text.include? "A Watir Topic"
    assert @browser.div(:class => "topic-filters").exists?
    if @browser.button(:class => "btn btn-default btn-sm admin-dark-btn", :text => "Unfeature Topic").present?
      unfeature_topic
    end
  end

  def xtest_00040_create_question
    create_conversation($network, $networkslug, "A Watir Topic", "question", "Q created by Watir - #{get_timestamp}", false)
  end

  def test_00050_answer_question
    PageObject.new(@browser).network_landing($network)
    PageObject.new(@browser).main_landing("regular", "logged")
    PageObject.new(@browser).topic_detail("A Watir Topic")
    PageObject.new(@browser).choose_post_type("question")
    PageObject.new(@browser).conversation_detail("question")
    sleep 2
    answer_text = "Answered by Watir - #{get_timestamp}"
    @browser.textarea(:class => "ember-view ember-text-area form-control").when_present.focus
    @browser.wait_until($t) { @browser.div(:class => "group text-right").present? }
    @browser.textarea(:class => "ember-view ember-text-area form-control").when_present.set answer_text
    @browser.button(:class => "btn btn-sm btn-primary", :text => "Submit").when_present.click
    if @browser.button(:class => "btn", :value => /Sort by: Oldest/).exists?
      PageObject.new(@browser).sort_by_new_in_conversation_detail
    end
    @browser.wait_until($t) { @browser.div(:class => "media-body", :text => /#{answer_text}/).exists? }
    assert @browser.div(:class => "media-body", :text => /#{answer_text}/).exists?, "Watir posted answer doesn't exist"
  end

  def xtest_00051_suggested_q_post
    network_landing($network)

    main_landing("regular", "logged")
    topic_detail("A Watir Topic")
    new_question = "watir"
    @browser.wait_until($t) { @browser.div(:class => "topic-filters").exists? }
    @browser.button(:text => /New/).when_present.click
    
    @browser.wait_until($t) { @browser.div(:class => "row post-type-picker").exists? }
    @browser.text_field(:class => "form-control ember-view ember-text-field").when_present.set new_question
    @browser.wait_until($t) { @browser.div(:class => "shown").present? }
    sleep 2
    assert @browser.form.ul.present?
    assert @browser.form.ul.li.text =~ /#{new_question}/i
    total = @browser.form.ul.lis.length

    matches = @browser.form.ul.lis(:text => /#{new_question}/i).length
    assert_equal total, matches, "Some autocompletes did not match '#{new_question}'"
 end  

 def xtest_00053_suggested_q_post_link
    network_landing($network)
    main_landing("regular", "logged")
    topic_detail("A Watir Topic")
 
    new_question = "Watir"
    @browser.wait_until($t) { @browser.div(:class => "topic-filters").exists? }
    @browser.button(:text => /New/).when_present.click
    
    @browser.wait_until($t) { @browser.div(:class => "row post-type-picker").exists? }
    @browser.text_field(:class => "form-control ember-view ember-text-field").when_present.set new_question
    @browser.wait_until($t) { @browser.div(:class => "shown").present? }
    assert @browser.form.ul.present?

    conv_link = @browser.form.ul.link.text
    #conv_link_href = @browser.link(:text => conv_link).href
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

  def test_00052_edit_conversation
    PageObject.new(@browser).network_landing($network)
    PageObject.new(@browser).main_landing("regular", "logged")
    PageObject.new(@browser).topic_detail("A Watir Topic")
    PageObject.new(@browser).choose_post_type("question")
    PageObject.new(@browser).conversation_detail("question")
    @browser.wait_until($t) { @browser.div(:class => "featured-post-collection").exists? }

    desc = "Watir edited root post - #{get_timestamp}"
   
    @browser.div(:class => "dropdown pull-right").span(:class => "dropdown-toggle").when_present.click
    @browser.wait_until {@browser.link(:class => "feature-class").present? }
    assert @browser.link(:class => "feature-class").exists?
    @browser.link(:text => "Edit").when_present.click

    @browser.wait_until($t) { @browser.div(:class => "note-editable").exists? }
    assert @browser.div(:class => "note-editable").exists?
    @browser.execute_script('$("div.note-editable").text('+"'"+desc+"')")
    @browser.execute_script('$("div.note-editable").blur()')
    @browser.wait_until { @browser.div(:class => "note-editable").text.include? desc }

    @browser.execute_script("window.scrollBy(0,500)")
    @browser.button(:class => "btn btn-primary", :value => /Submit/).when_present.click
    @browser.wait_until {@browser.div(:class => /ember-view/).exists? }
    assert @browser.div(:class => /ember-view/).exists? 
    assert @browser.div(:class => /ember-view/).text.include? desc
    @browser.refresh #added to check if edits are lost after browser hard refresh
    @browser.wait_until($t) {@browser.div(:class => /ember-view/).exists? }
    assert @browser.div(:class => /ember-view/).exists? 
    @browser.wait_until{ @browser.div(:class => /ember-view/).text.include? desc}
    assert @browser.div(:class => /ember-view/).text.include? desc
  end  

  def xtest_00060_create_question_with_link
    create_conversation($network, $networkslug, "A Watir Topic", "question_with_link", "Q with link created by Watir - #{get_timestamp}", false)
  end


  def test_00070_feature_unfeature_an_answer
    PageObject.new(@browser).network_landing($network)
    PageObject.new(@browser).main_landing("regular", "logged")
    PageObject.new(@browser).topic_detail("A Watir Topic")
    PageObject.new(@browser).choose_post_type("question")
    PageObject.new(@browser).conversation_detail("question")
    #conv_url = @browser.url
    assert @browser.div(:class => /ember-view/).exists?

    if @browser.span(:class => "featured").exists?
      PageObject.new(@browser).unfeature_root_post
    end
    PageObject.new(@browser).feature_root_post
    PageObject.new(@browser).unfeature_root_post

    if ( !(@browser.div(:class => /ember-view depth-1 answer post/).present?)) # ||  @browser.div(:class => "dropdown pull-right open").link(:text => /Reinstate/).present? || @browser.div(:class => "dropdown pull-right open").link(:text => /Permanently Remove/).present?)
     answer_text = "Answered by Watir - #{get_timestamp}"
     @browser.textarea(:class => "ember-view ember-text-area form-control").when_present.focus
     @browser.wait_until($t) { @browser.div(:class => "group text-right").present? }
     @browser.textarea(:class => "ember-view ember-text-area form-control").when_present.set answer_text
     @browser.button(:class => "btn btn-sm btn-primary", :text => "Submit").when_present.click
     if @browser.button(:class => "btn", :value => /Sort by: Oldest/).exists?
      PageObject.new(@browser).sort_by_new_in_conversation_detail
     end
     @browser.wait_until($t) { @browser.div(:class => "media-body", :text => /#{answer_text}/).exists? }
    
    end
    if (@browser.div(:class => /ember-view depth-1 answer feature/).present? || @browser.div(:class => /ember-view depth-1 feature answer post/).present? )
       @browser.div(:class => /ember-view depth-1/).span(:class => "dropdown-toggle").when_present.click
       @browser.wait_until($t) { @browser.div(:class => /ember-view depth-1/).div(:class => "dropdown pull-right open").present? }
       @browser.link(:class => "feature-class featured-link",:text => "Unmark as best answer").when_present.click
       sleep(1)
       assert ( !@browser.div(:class => /ember-view depth-1 answer feature post/).present? || !@browser.div(:class => /ember-view depth-1 feature answer post/).present? )
    end 
    
    @browser.div(:class => /ember-view depth-1/).span(:class => "dropdown-toggle").click
     if ( @browser.div(:class => "dropdown pull-right open").link(:text => /Reinstate/).present? || @browser.div(:class => "dropdown pull-right open").link(:text => /Permanently Remove/).present? )
     answer_text = "Answered by Watir - #{get_timestamp}"
     @browser.textarea(:class => "ember-view ember-text-area form-control").when_present.focus
     @browser.wait_until($t) { @browser.div(:class => "group text-right").present? }
     @browser.textarea(:class => "ember-view ember-text-area form-control").when_present.set answer_text
     @browser.button(:class => "btn btn-sm btn-primary", :text => "Submit").when_present.click
     @browser.wait_until { !@browser.i(:class => "fa-spinner").present? }
     #if @browser.button(:class => "btn", :value => /Oldest/).present?
      PageObject.new(@browser).sort_by_new_in_conversation_detail
     #end
     @browser.wait_until($t) { @browser.div(:class => "media-body", :text => /#{answer_text}/).exists? }
     @browser.div(:class => /ember-view depth-1/).span(:class => "dropdown-toggle").click
     end
    @browser.wait_until($t) { @browser.div(:class => "dropdown pull-right open").link(:class => "feature-class", :text => /Mark as best answer/).present? }
    @browser.div(:class => "dropdown pull-right open").link(:class => "feature-class", :text => /Mark as best answer/).click
    #@browser.wait_until { @browser.div(:class => /ember-view depth-1 accepted_answer answer post/).exists? }
    #@browser.refresh
    featured_post = @browser.div(:class => /ember-view depth-1 answer feature/)
    @browser.wait_until($t) { featured_post.present? || @browser.div(:class => /ember-view depth-1 feature answer/).present? }
    assert featured_post.present? || @browser.div(:class => /ember-view depth-1 feature answer/).present?
    @browser.span(:css => "#featured-post-collection .depth-1.answer.feature.post .dropdown-toggle").when_present.click
    # @browser.div(:class => /ember-view depth-1 feature/).span(:class => "dropdown-toggle").when_present.click
    #unmark_link = @browser.div(:class => "featured-post-collection").div(:class => /ember-view depth-1/).div(:class => "dropdown pull-right open").link(:class => "feature-class featured-link",:text => /Unmark as best answer|Stop Featuring/)
    #@browser.wait_until($t) { unmark_link.present? }
    #assert unmark_link.present?
    #unmark_link.click
    #@browser.div(:class => /ember-view depth-1/).span(:class => "dropdown-toggle").when_present.click
    @browser.ul(:css => "#featured-post-collection .depth-1.answer.feature.post .dropdown-menu").link(:class => "feature-class featured-link",:text => "Unmark as best answer").when_present.click
    # @browser.div(:class => /ember-view depth-1/).div(:class => "dropdown pull-right open").link(:class => "feature-class featured-link",:text => "Unmark as best answer").when_present.click
    @browser.wait_until($t) { !@browser.div(:class => /ember-view depth-1 answer feature post/).present?}
    sleep(1)
    assert !@browser.div(:class => /ember-view depth-1 answer feature post/).present?
    @browser.wait_until($t) { !featured_post.present? || !@browser.div(:class => /ember-view depth-1 answer feature post/).present?  }
    assert !featured_post.present? || !@browser.div(:class => /ember-view depth-1 answer feature post/).present?
  end

  def xtest_00080_create_discussion
    create_conversation($network, $networkslug, "A Watir Topic", "discussion", "Discussion created by Watir - #{get_timestamp}", false)
  end

  # def test_00090_comment_on_discussion
  #   PageObject.new(@browser).network_landing($network)
  #   PageObject.new(@browser).main_landing("regular", "logged")
  #   PageObject.new(@browser).topic_detail("A Watir Topic")
  #   PageObject.new(@browser).choose_post_type("discussion")
  #   PageObject.new(@browser).conversation_detail("discussion")
  #   #conversation_detail("Watir Test Discussion2 !", "discussion")
    
  #   comment_text = "Commented by Watir - #{get_timestamp}"
  #   @browser.textarea(:class => "ember-view ember-text-area form-control").when_present.focus
  #   @browser.wait_until($t) { @browser.div(:class => "group text-right").exists? }
  #   assert @browser.div(:class => "group text-right").exists?
  #   @browser.textarea(:class => "ember-view ember-text-area form-control").when_present.set comment_text
  #   @browser.button(:value => /Submit/).when_present.click
   
  #   if @browser.div(:class => "pull-right sort-by dropdown").span(:class => "dropdown-toggle", :text => /Oldest/).present?
  #     PageObject.new(@browser).sort_by_new_in_conversation_detail
  #   end

  #   @browser.wait_until($t) { @browser.div(:class => "input", :text => /#{comment_text}/).exists?}
  #   assert @browser.div(:class => "input", :text => /#{comment_text}/).exists? 
  # end

  def xtest_00100_feature_unfeature_comment
    PageObject.new(@browser).network_landing($network)
    PageObject.new(@browser).main_landing("regular", "logged")
    PageObject.new(@browser).topic_detail("A Watir Topic")
    PageObject.new(@browser).choose_post_type("question")
    PageObject.new(@browser).conversation_detail("question")
    @browser.wait_until($t) { @browser.div(:class => /ember-view/).exists? }

    if @browser.span(:class => "featured").exists?
      PageObject.new(@browser).unfeature_root_post
    end
    PageObject.new(@browser).feature_root_post
    PageObject.new(@browser).unfeature_root_post
    if !(@browser.div(:class => /ember-view depth-1 post/).present?)
      #PageObject.new(@browser).conversation_detail_reply
     answer_text = "Comment by Watir - #{get_timestamp}"
     @browser.textarea(:class => "ember-view ember-text-area form-control").when_present.focus
     @browser.wait_until($t) { @browser.div(:class => "group text-right").present? }
     @browser.textarea(:class => "ember-view ember-text-area form-control").when_present.set answer_text
     @browser.button(:class => "btn btn-sm btn-primary", :text => "Submit").when_present.click
     if @browser.button(:class => "btn", :value => /Sort by: Oldest/).exists?
      PageObject.new(@browser).sort_by_new_in_conversation_detail
     end
     @browser.wait_until($t) { @browser.div(:class => "media-body", :text => /#{answer_text}/).exists? }
     #assert @browser.div(:class => "media-body", :text => /#{answer_text}/).exists?, "Watir posted answer doesn't exist"
    
    end
    
    if (@browser.div(:class => "featured-post-collection").div(:class => /ember-view depth-1 feature post/).present?)
      @browser.div(:class => /ember-view depth-1/).span(:class => "dropdown-toggle").when_present.click
       @browser.div(:class => "dropdown pull-right open").link(:class => "feature-class featured-link",:text => "Stop Featuring").when_present.click
       sleep(1)
       assert (!@browser.div(:class => "media featured-post").exists?)
       @browser.div(:class => /ember-view depth-1/).span(:class => "dropdown-toggle").when_present.click
       @browser.wait_until($t) { @browser.link(:class => "feature-class").present? }
    end
    @browser.div(:class => /ember-view depth-1/).span(:class => "dropdown-toggle").when_present.click
    if ( @browser.div(:class => "dropdown pull-right open").link(:text => /Reinstate/).present? || @browser.div(:class => "dropdown pull-right open").link(:text => /Permanently Remove/).present? )
     answer_text = "Answered by Watir - #{get_timestamp}"
     @browser.textarea(:class => "ember-view ember-text-area form-control").when_present.focus
     @browser.wait_until($t) { @browser.div(:class => "group text-right").present? }
     @browser.textarea(:class => "ember-view ember-text-area form-control").when_present.set answer_text
     @browser.button(:class => "btn btn-sm btn-primary", :text => "Submit").when_present.click
     @browser.wait_until { !@browser.i(:class => "fa-spinner").present? }
     PageObject.new(@browser).sort_by_new_in_conversation_detail
     @browser.wait_until($t) { @browser.div(:class => "media-body", :text => /#{answer_text}/).exists? }
     @browser.div(:class => /ember-view depth-1/).span(:class => "dropdown-toggle").click
     end
    @browser.div(:class => "dropdown pull-right open").link(:class => "feature-class", :text => /Feature this comment/).when_present.click
    @browser.wait_until { @browser.div(:class => "featured-post-collection").present? }
    assert @browser.div(:class => "featured-post-collection").present?
    @browser.div(:class => /ember-view depth-1/).span(:class => "dropdown-toggle").when_present.click
    unfeature_link = @browser.div(:class => "dropdown pull-right open").link(:class => "feature-class featured-link",:text => /Stop Featuring/)
    @browser.wait_until($t) { unfeature_link.present? }
    assert unfeature_link.present?
    unfeature_link.click
    @browser.wait_until($t) { !@browser.div(:class => /ember-view depth-1 feature post/).present? }
    sleep(1)
    assert !@browser.div(:class => /ember-view depth-1 feature post/).present?
  end

  def xtest_00101_create_discussion_with_link
    create_conversation($network, $networkslug, "A Watir Topic", "discussion_with_link", "Discussion with link created by Watir - #{get_timestamp}" , false)
  end

  def xtest_00103_create_blog_with_video
    create_conversation($network, $networkslug, "A Watir Topic", "blog_with_video", "Blog with video created by Watir - #{get_timestamp}", false)
  end

  def xtest_00110_post_comment_highlevel_notification
    network_landing($network)
    main_landing("regular", "logged")
    admin_check($networkslug)
    topic_detail("A Watir Topic")
    choose_post_type("discussion")
    conversation_detail("discussion")
    assert @browser.div(:class => /ember-view/).present?
    follow_disc_element = @browser.link(:class => "follow", :index => 0)
    if follow_disc_element.text =~ /Follow/ #added check for admin follow for root post
    follow_disc_element.when_present.click
    @browser.wait_until($t) { (follow_disc_element.text =~ /Unfollow/)}
    end
    signout

    network_landing($network)
    main_landing("regis2", "logged")
    topic_detail("A Watir Topic")
    choose_post_type("discussion")
    conversation_detail("discussion")
    reply = "Reply on root posted by Watir User2 - #{get_timestamp}"
    @browser.textarea(:class => "ember-view ember-text-area form-control").when_present.focus
    @browser.wait_until($t) { @browser.div(:class => "group text-right").button(:value => /Submit/).exists? }
    assert @browser.div(:class => "group text-right").present?

    @browser.textarea(:class => "ember-view ember-text-area form-control").when_present.set reply
    @browser.button(:value => /Submit/).when_present.click
    @browser.wait_until ($t) { !@browser.button(:value => /Submit/).present? }
    sort_by_new_in_conversation_detail
    
    @browser.wait_until($t) { @browser.div(:class => /ember-view/).text.include? reply }
    signout

    about_landing($network)
    main_landing("regular", "logged")
    @browser.wait_until($t) { @browser.div(:class => "container").exists? }
    @browser.refresh
    @browser.link(:class => "dropdown-toggle notification").when_present.click
    @browser.wait_until($t) { @browser.div(:class => "ember-view notification-item notification-item new").exists? }
    assert @browser.div(:class => "dropdown nav-notification open").ul(:class =>  "dropdown-menu dropdown-menu-right notification-dropdown").exists?
    if @browser.div(:class =>  "dropdown nav-notification open").ul(:class =>  "dropdown-menu dropdown-menu-right notification-dropdown").exists?
       assert @browser.div(:class => "ember-view notification-item notification-item new").div(:class => "body").span(:class => "text").text.include? $user4[3]+" replied to "
       assert (@browser.div(:class => "ember-view notification-item notification-item new").div(:class => "body").span(:class => "date").text.include? "a few seconds ago") || (@browser.div(:class => "ember-view notification-item notification-item new").div(:class => "body").span(:class => "date").text.include? "a minute ago")|| (@browser.div(:class => "ember-view notification-item notification-item new").div(:class => "body").span(:class => "date").text.include? "minutes ago")
    end
    signout
  end

  def xtest_00111_notification_detail
    about_landing($network)
    main_landing("regular", "logged")
    @browser.wait_until($t) { @browser.div(:class => "container").exists? }
    @browser.link(:class => "dropdown-toggle notification").when_present.click
    sleep 3
    @browser.wait_until($t) { @browser.div(:class => "panel-footer show-all-link").exists? }
    @browser.div(:class => "panel-footer show-all-link", :text => "View All").when_present.click
    @browser.wait_until($t) { @browser.div(:class => "notification-block row").exists? }
    @browser.wait_until($t) { @browser.div(:class => "col-xs-12 col-sm-12 col-md-12 col-lg-12").exists? }
    assert @browser.div(:class => "notification-block row").div(:class => "col-xs-12 col-sm-12 col-md-12 col-lg-12").div(:class => "ember-view notification-item notification-item new").present?
    assert @browser.div(:class => "mark-all-read-page pull-right").present?
  end

  def xtest_00112_notification_conv_link
    network_landing($network)
    main_landing("regis2", "logged")
    topic_detail("A Watir Topic")
    choose_post_type("blog")
    conversation_detail("blog")
    title = @browser.h3(:class => "media-heading root-post-title").text
    reply = "Reply on root posted by Watir User2 - #{get_timestamp}"
    @browser.textarea(:class => "ember-view ember-text-area form-control").when_present.focus
    @browser.wait_until($t) { @browser.div(:class => "group text-right").button(:value => /Submit/).exists? }
    assert @browser.div(:class => "group text-right").present?

    @browser.textarea(:class => "ember-view ember-text-area form-control").when_present.set reply
    @browser.button(:value => /Submit/).when_present.click
    sort_by_new_in_conversation_detail
    
    @browser.wait_until($t) { @browser.div(:class => /ember-view/, :text => /#{reply}/).present? }
    signout

    about_landing($network)
    main_landing("regular", "logged")
    @browser.wait_until($t) { @browser.div(:class => "container").exists? }
    @browser.link(:class => "dropdown-toggle notification").when_present.click
    @browser.wait_until { @browser.div(:class => "panel-footer show-all-link").present? }
    first_link = @browser.div(:class => "notification-popup").div(:class => "ember-view notification-item notification-item")
    @browser.wait_until($t) { first_link.present? }
    first_link.click
    conv = @browser.div(:class => "media-body").h3(:text => /#{title}/)
    @browser.wait_until($t) { conv.present? }
    assert conv.present?
  end

  def xtest_00120_stop_highlevel_notification
    network_landing($network)
    main_landing("regular", "logged")
    admin_check($networkslug)
    topic_detail("A Watir Topic")
    choose_post_type("blog")
    conversation_detail("blog")
    assert @browser.div(:class => /ember-view/).exists?
    follow_disc_element = @browser.link(:class => "follow")
    @browser.wait_until($t) { follow_disc_element.present? }
    if follow_disc_element.text =~ /Unfollow/
    follow_disc_element.when_present.click
    @browser.wait_until { (follow_disc_element.text =~ /Follow/)}
    end
    assert @browser.link(:class => "follow", :text => /Follow/).present?
    caret = @browser.span(:class => "caret")
    @browser.wait_until($t) {
      caret.exists?
    }
    caret.click
    
    @browser.link(:text => /Sign Out/).when_present.click
    @browser.wait_until($t) { @browser.div(:class => "ember-view").text.include? "Sign In / Register" }
    assert @browser.div(:class => "ember-view").text.include? "Sign In / Register"
    network_landing($network)
    main_landing("regis", "logged")
    topic_detail("A Watir Topic")
    choose_post_type("blog")
    conversation_detail("blog")
    
    reply = "Reply on root posted by Watir User1 - #{get_timestamp}"
    @browser.textarea(:class => "ember-view ember-text-area form-control").when_present.focus

    @browser.wait_until($t) { @browser.div(:class => "group text-right").exists? }
    @browser.textarea(:class => "ember-view ember-text-area form-control").when_present.set reply

    @browser.wait_until($t) { @browser.div(:class => "conversation-content").exists? }
    @browser.button(:value => /Submit/).when_present.click
    @browser.wait_until($t) { @browser.div(:class => "ember-view depth-1 post").exists? }
    assert @browser.div(:class => "ember-view depth-1 post").exists?

    sort_by_new_in_conversation_detail
    @browser.wait_until($t){ @browser.div(:class => /ember-view/).text.include? reply }
    signout
    about_landing($network)
    main_landing("admin", "logged")
    @browser.wait_until($t) { @browser.div(:class => "container").exists? }
    @browser.refresh
    @browser.link(:class => "dropdown-toggle notification").when_present.click
    @browser.wait_until($t) { @browser.div(:class => "ember-view notification-item notification-item new").exists? }
    assert !(@browser.div(:class => "ember-view notification-item notification-item new").div(:class => "body").span(:class => "text").text.include? $user3[3]+" replied to your post: " )
    assert !(@browser.div(:class => "ember-view notification-item notification-item new").div(:class => "body").span(:class => "date").text.include? "a few seconds ago" ) || !(@browser.div(:class => "ember-view notification-item notification-item new").div(:class => "body").span(:class => "date").text.include? "a minute ago")

    network_landing($network)
    main_landing("regular", "logged")
    topic_detail("A Watir Topic")
    choose_post_type("blog")
    conversation_detail("blog")
    follow_disc_element = @browser.link(:class => "follow", :index => 0)
    follow_disc_element.when_present.click
    @browser.wait_until($t) { (follow_disc_element.text =~ /Unfollow/)}
  end  

  def xtest_00121_aggregated_like_notification
    network_landing($network)
    main_landing("regular", "logged")
    topic_detail("A Watir Topic")
    choose_post_type("blog")
    conversation_detail("blog")
    follow_disc_element = @browser.link(:class => "follow", :text => "Follow")

    if (@browser.link(:class => "follow", :text => "Follow").present?)
        follow_disc_element.when_present.click
        @browser.wait_until { (@browser.link(:class => "follow", :text =>"Unfollow").present? )}
        assert @browser.link(:class => "follow",:text => "Unfollow").present?
    end  
    assert @browser.link(:class => "follow",:text => "Unfollow").present?
    signout

    network_landing($network)
    main_landing("mod", "logged")
    topic_detail("A Watir Topic")
    choose_post_type("blog")
    conversation_detail("blog")
    textarea = @browser.textarea(:class => "ember-text-area")
    @browser.wait_until { textarea.exists? }
    like_disc_element = @browser.link(:class => "like", :index => 0)
    sleep 1
    if @browser.link(:class => "like", :text => /Unlike/).exists?
         like_disc_element.when_present.click
         assert_equal 0, like_disc_element.text =~ /Like/
    end
    like_disc_element.when_present.click
    assert_equal 0, like_disc_element.text =~ /Unlike/
    signout

    network_landing($network)
    main_landing("regis", "logged")
    topic_detail("A Watir Topic")
    choose_post_type("blog")
    conversation_detail("blog")
    textarea = @browser.textarea(:class => "ember-text-area")
    @browser.wait_until { textarea.exists? }
    like_disc_element = @browser.link(:class => "like", :index => 0)
    sleep 2
    if @browser.link(:class => "like", :text => /Unlike/).exists?
         like_disc_element.when_present.click
         assert_equal 0, like_disc_element.text =~ /Like/
    end
    like_disc_element.when_present.click
    assert_equal 0, like_disc_element.text =~ /Unlike/
    signout

    about_landing($network)
    main_landing("regular", "logged")
    @browser.wait_until { @browser.div(:class => "container").exists? }
    @browser.refresh
    @browser.link(:class => "dropdown-toggle notification").when_present.click
    #@browser.wait_until { @browser.div(:class => "col-xs-9").exists? }
    @browser.wait_until($t) { @browser.div(:class => "ember-view notification-item notification-item new").exists? }
    assert @browser.div(:class => "dropdown nav-notification open").ul(:class =>  "dropdown-menu dropdown-menu-right notification-dropdown").exists?
    assert @browser.div(:class => "ember-view notification-item notification-item new").div(:class => "body").span(:class => "text").text.include? $user2[3]+" and "+$user3[3]+" liked your post: "
    assert (@browser.div(:class => "ember-view notification-item notification-item new").div(:class => "body").span(:class => "date").text.include? "a few seconds ago") || (@browser.div(:class => "ember-view notification-item notification-item new").div(:class => "body").span(:class => "date").text.include? "a minute ago")|| (@browser.div(:class => "ember-view notification-item notification-item new").div(:class => "body").span(:class => "date").text.include? "minutes ago")
 end
  

  def xtest_00130_search_posts
    network_landing($network)
    main_landing("regular", "logged")
    topic_detail("A Watir Topic")
    searchtext = "Watir Test Question1 ?"

    @browser.wait_until { @browser.text_field(:class => "ember-view ember-text-field typeahead form-control tt-input", :placeholder => "Search...").present?}
    assert @browser.text_field(:class => "ember-view ember-text-field typeahead form-control tt-input", :placeholder => "Search...").present?
    @browser.text_field(:class => "ember-view ember-text-field typeahead form-control tt-input").when_present.set searchtext
    @browser.wait_until($t) { @browser.span(:class => "tt-dropdown-menu").exists? }

    #@browser.span(:class => "tt-dropdown-menu").when_present.click
    @browser.send_keys :enter
    #@browser.execute_script('var e = jQuery.Event("keypress"); e.which = 13; $(".tt-dropdown-menu").trigger(e)')
    #@browser.div(:class => "ember-view").i(:class => "ember-view icon-search icon-search-input").when_present.click
    @browser.wait_until { @browser.div(:class => "row filters search-facets").exists? }
    assert @browser.div(:class => "row filters search-facets").exists?
    #@browser.link(:text => /Questions/).when_present.click
    #@browser.wait_until { @browser.div(:class => "col-lg-8").present? }
    assert @browser.div(:class => "media-heading").text.include? searchtext
  end

  def xtest_00140_search_results_pagination
    network_landing($network)
    topic_name = "A Watir Topic With Many Posts"
    if !(@browser.link(:class => "ember-view", :text => topic_name).present?)
         topic_sort_by_name
       end
    @browser.link(:class => "ember-view", :text => "A Watir Topic With Many Posts").when_present.click
    search_box = @browser.div(:class => /search-form/).text_field(:class => /tt-input/)
    @browser.wait_until($t) { search_box.present? }

    searchtext = "Watir"

    assert search_box.present?
    search_box.set searchtext
    @browser.wait_until($t) { @browser.span(:class => "tt-dropdown-menu").present? }
    @browser.send_keys :enter
    @browser.wait_until { @browser.div(:class => "row filters search-facets").present? }
    assert @browser.div(:class => "row filters search-facets").present?
    assert @browser.link(:text => /Next/).present? # next link
    assert @browser.link(:text => /2/).present? #page number 2

    sleep 1
    assert_equal 20, @browser.divs(:class => "post").length
    @browser.execute_script("window.scrollBy(0,4000)")
    @browser.link(:text => /Next/).click
    @browser.wait_until($t) { @browser.div(:class => "post media").present? }
    assert_operator 1, :<=, @browser.divs(:class => "post").length
    assert @browser.link(:text => /Previous/).present?
    assert @browser.link(:text => /2/, :class => /pagination-link ember-view active disabled/).present?
  end

  def xtest_00150_admin_moderation
    about_landing($network)
    main_landing("admin", "logged")
    admin_check($networkslug)
    @browser.div(:class =>"dropdown open").link(:href => "/admin/#{$networkslug}").when_present.click
    @browser.wait_until { @browser.div(:class => "topics-list row").exists? }
    assert @browser.div(:class => "sidebar-nav").exists? 
    @browser.link(:href => "/admin/#{$networkslug}/moderation").when_present.click
    @browser.wait_until { @browser.div(:id => "threshold").exists? }
    @browser.link(:href => "/admin/#{$networkslug}/moderation?setPage=1&tabName=flaggedPosts").when_present.click
    @browser.wait_until($t) { @browser.link(:href => "/admin/#{$networkslug}/moderation?setPage=1&tabName=flaggedPosts").exists? }
    assert @browser.link(:href => "/admin/#{$networkslug}/moderation?setPage=1&tabName=flaggedPosts").present?
    signout
  end  

  def xtest_00160_report_a_content
    mod_flag_threshold($network, $networkslug)
    #registered user reporting the content
    about_landing($network)
    main_landing("regis", "logged")
    root_post = "Q created by Watir for flag - #{get_timestamp}"
    descrip = "Watir test description - #{get_timestamp}"
    flag_msg = "This post has been flagged as inappropriate; it has been temporarily removed and brought to the attention of the site moderators."
    create_conversation($network, $networkslug, "A Watir Topic", "question", root_post, false)
    answer_text = "Answered by Watir - #{get_timestamp}"
    @browser.textarea(:class => "ember-view ember-text-area form-control").when_present.focus
    @browser.wait_until($t) { @browser.div(:class => "group text-right").exists? }
    @browser.textarea(:class => "ember-view ember-text-area form-control").when_present.set answer_text
    #@browser.execute_script('$("div.group text-right").blur()')
    @browser.button(:value => /Submit/).when_present.click
  
    @browser.wait_until { @browser.div(:class => "media-body", :text => /#{answer_text}/).exists? }
    @browser.div(:class => /depth-1/).span(:class => "dropdown-toggle").when_present.click
    
    @browser.wait_until($t) { @browser.ul(:class => "dropdown-menu moderator-post-actions-menu").exists? }
    if (!@browser.link(:text => "Flag as inappropriate").exists? )
        puts "User is not a moderator....Signing in the moderator"
        signout
        network_landing($network)
        main_landing("regular", "logged")
        topic_detail("A Watir Topic")
        choose_post_type("question")
        if !(@browser.link(:text => root_post))
         sort_by_old_in_conversation_list
         @browser.wait_until($t) { @browser.div(:class => "col-lg-8 col-md-8 widget-container zone main").div(:class => "post-collection").div(:class => "post media ").exists? }
        end 
        @browser.link(:text => root_post).when_present.click
        @browser.wait_until($t) { @browser.div(:class => "ember-view depth-0 question post conversation").exists? }
        assert @browser.div(:class => "conversation-content").exists?
        @browser.div(:class => /depth-1/).span(:class => "dropdown-toggle").when_present.click
        @browser.wait_until($t) { @browser.link(:class => "feature-class").exists? }
        assert @browser.link(:class => "feature-class").exists?
    end

    if (@browser.link(:text => "Reinstate this content").exists? )
        puts "The post appears to be already flagged...."
    end

    @browser.link(:text => /Flag as inappropriate/).when_present.click
    @browser.wait_until($t) { @browser.span(:class => "icon-flag pull-right").exists? }
    assert @browser.span(:class => "icon-flag pull-right").exists?
    signout
    
    #admin-moderator checking the post is flagged
    about_landing($network)
    main_landing("admin", "logged")
    caret = @browser.span(:class => "caret")
    @browser.wait_until($t){
    caret.exists?
    }
    caret.click
    @browser.div(:class=>"dropdown open").link(:href => "/admin/#{$networkslug}").when_present.click
    @browser.wait_until($t) { @browser.div(:class => "sidebar-nav").exists? }
    @browser.link(:href => "/admin/#{$networkslug}/moderation").when_present.click
    @browser.wait_until { @browser.link(:href => "/admin/#{$networkslug}/moderation?setPage=1&tabName=flaggedPosts").exists? }
    @browser.link(:href => "/admin/#{$networkslug}/moderation?setPage=1&tabName=flaggedPosts").when_present.click
    @browser.wait_until($t) { @browser.div(:class => "flagged-posts").exists? }
    assert @browser.div(:class => "flagged-posts").exists?

    #@browser.execute_script("window.scrollBy(0,500)")
    assert @browser.div(:class => "media-body").link(:class => "ember-view", :text => answer_text).present? 
    @browser.div(:class => "media-body").link(:class => "ember-view", :text => answer_text).when_present.click
    sleep 2
    @browser.wait_until($t) { @browser.div(:class => /ember-view/).exists? }
    @browser.wait_until($t) { @browser.div(:class => "media-body").text.include? root_post }
    assert @browser.div(:class => "media-body").text.include? root_post
    @browser.div(:class => /depth-1/).span(:class => "dropdown-toggle").when_present.click
    @browser.wait_until($t) { @browser.link(:class => "feature-class").exists? }
    assert @browser.link(:text => "Reinstate this content").exists?
    signout
 end 

 def xtest_00161_flag_msg
    mod_flag_threshold($network, $networkslug)
    #registered user reporting the content
    about_landing($network)
    main_landing("regis2", "logged")
    root_post = "Q created by Watir for flag msg test - #{get_timestamp}"
    descrip = "Watir test description - #{get_timestamp}"
    flag_msg = "This post has been flagged as inappropriate; it has been temporarily removed and brought to the attention of the site moderators."
    create_conversation($network, $networkslug, "A Watir Topic", "question", root_post, false)
    answer_text = "Answered by Watir - #{get_timestamp}"
    @browser.textarea(:class => "ember-view ember-text-area form-control").when_present.focus
    @browser.wait_until($t) { @browser.div(:class => "group text-right").exists? }
    @browser.textarea(:class => "ember-view ember-text-area form-control").when_present.set answer_text
    @browser.button(:value => /Submit/).when_present.click
    @browser.wait_until($t) { @browser.div(:class => "media-body", :text => /#{answer_text}/).exists? }
    @browser.div(:class => /ember-view depth-1/).span(:class => "dropdown-toggle").when_present.click
    
    @browser.wait_until($t) { @browser.ul(:class => "dropdown-menu moderator-post-actions-menu").exists? }
    if (!@browser.link(:text => "Flag as inappropriate").exists? )
        puts "User is not a moderator....Signing in the moderator"
        signout
        network_landing($network)
        main_landing("regular", "logged")
        topic_detail("A Watir Topic")
        choose_post_type("question")
        @browser.link(:text => root_post).when_present.click
        @browser.wait_until($t) { @browser.div(:class => "ember-view depth-0 question post conversation").exists? }
        assert @browser.div(:class => "conversation-content").exists?
        @browser.div(:class => /ember-view depth-1/).span(:class => "dropdown-toggle").when_present.click
        @browser.wait_until($t) { @browser.link(:class => "feature-class").exists? }
        assert @browser.link(:class => "feature-class").exists?
    end

    if (@browser.link(:text => "Reinstate this content").exists? )
        puts "The post appears to be already flagged...."
    end

    @browser.link(:text => /Flag as inappropriate/).when_present.click
    @browser.wait_until { @browser.span(:class => "icon-flagged").present? }
    assert @browser.span(:class => "icon-flagged").present?
    #@browser.wait_until {!@browser.div(:class => /depth-1/).div(:class => "ember-view").div(:class => "dropdown pull-right").ul(:class => "dropdown-menu moderator-post-actions-menu").li(:index =>1).exist? }
    #assert (!@browser.div(:class => /depth-1/).div(:class => "ember-view").div(:class => "dropdown pull-right").ul(:class => "dropdown-menu moderator-post-actions-menu").li(:index =>2).exist?) 
    url = @browser.url
    signout
    @browser.goto url
    @browser.wait_until($t) { @browser.div(:class => "media post-body").present? }
    assert @browser.div(:class => "media post-body").div(:class => "input", :text => /#{flag_msg}/).present?
 end

  def xtest_00180_social_login_with_facebook
    social_user_registration_and_login("Facebook")
    social_user_registration_and_login_verification($user6)
  end

  def xtest_00200_social_login_with_linkedin
    social_user_registration_and_login("Linkedin")
    social_user_registration_and_login_verification($user7)
  end 

  def xtest_00220_social_login_with_twitter
    social_user_registration_and_login("Twitter")
    social_user_registration_and_login_verification($user9)
  end


  def xtest_00230_make_member_network_admin
    promote_user_role($network, $networkslug, $user3, "netadmin")
    revert_user_role($network, $networkslug, $user3, "netadmin")
  end  

  def xtest_00240_make_member_network_mod
    promote_user_role($network, $networkslug, $user3, "netmod")
    revert_user_role($network, $networkslug, $user3, "netmod")
  end  

  def xtest_00250_upload_image_under_branding
    about_landing($network)
    main_landing("admin", "logged")
    branding_url = $base_url + "/admin/#{$networkslug}/branding" 
    @browser.goto  branding_url
    @browser.wait_until($t) {
      @browser.h5(:text => "Change Logo").exists?
    }

    assert @browser.file_field(:class=> "ember-view ember-text-field files file photo-browse-input btn btn-default btn-sm").exists?
    #uploading sephora logo
    if $os == "windows"
      @browser.execute_script('$(".photo-upload-browse").removeClass("photo-upload-browse")')
    end
    @browser.file_field(:class=> "ember-view ember-text-field files file photo-browse-input btn btn-default btn-sm").set("#{$rootdir}/seeds/development/images/sephora-logo.jpg")
    @browser.wait_until($t) {
      @browser.div(:class => "cropper-canvas cropper-modal cropper-crop").exists? #&& @browser.div(:class => "crop-preview").exists?
    }
    
    @browser.div(:class => "modal-footer").button(:class => "btn btn-primary btn-sm file-upload-select-button", :text => "Select Photo").click
    @browser.wait_until($t) { !@browser.div(:class => "cropper-canvas cropper-modal cropper-crop").present?}
    
    @browser.refresh # for asserting img src
    @browser.wait_until($t) { @browser.img(:class => "nav-logo").present? }
    img = @browser.img(:class => "nav-logo" , :src => /sephora-logo.jpg/)
    @browser.wait_until($t) {
      img.exists?
    }
    assert img.exists?
    
    #uploading saplogo back
    if $os == "windows"
      @browser.wait_until{ @browser.file_field(:class=> "ember-view ember-text-field files file photo-browse-input btn btn-default btn-sm").exist? }
      @browser.execute_script('$(".photo-upload-browse").removeClass("photo-upload-browse")')
    end
    @browser.wait_until($t) { @browser.file_field(:class=> "ember-view ember-text-field files file photo-browse-input btn btn-default btn-sm").exists? }
    @browser.file_field(:class=> "ember-view ember-text-field files file photo-browse-input btn btn-default btn-sm").set("#{$rootdir}/seeds/development/images/saplogo.png")
    @browser.wait_until($t) {
      @browser.div(:class => "cropper-canvas cropper-modal cropper-crop").exists? #&& @browser.div(:class => "crop-preview").exists?
    }

    @browser.button(:class => "btn btn-primary btn-sm file-upload-select-button", :text => "Select Photo").when_present.click
    @browser.wait_until($t) { !@browser.div(:class => "cropper-canvas cropper-modal cropper-crop").present?}
    @browser.refresh
    @browser.wait_until($t) { @browser.img(:class => "nav-logo").present? }
    
    img = @browser.img(:class => "nav-logo", :src => /saplogo.png/)
    @browser.wait_until {
      img.exists?
    }

    signout
  end   

  def xtest_00270_create_new_engagement_topic
    topicname = create_new_topic($network, $networkslug, "engagement", false)
    topic_widgets_in_topic_type($network, $networkslug, topicname, "engagement")
  end   

  def xtest_00260_topic_breadcrumb
    network_landing($network)
    main_landing("regis", "logged")
    topic_detail("A Watir Topic")
    choose_post_type("question")
    @browser.wait_until ($t) { @browser.div(:class => "post media ").exists? }
    @browser.div(:class => "media-heading").link(:class => "media-heading ember-view media-heading").click
    @browser.wait_until { @browser.div(:class => /row conversation-root-post/).exists? }
    assert @browser.div(:class => /row conversation-root-post/).exists? 

    @browser.div(:class => "breadcrumbs col-lg-6 col-md-6").span(:text => /A Watir Topic/).when_present.click
    @browser.wait_until($t) { @browser.div(:class => "topic-filters").exists? }
    assert @browser.div(:class => "topic-filters").exists?
    choose_post_type("question")
    @browser.wait_until ($t) { @browser.div(:class => "post media ").exists? }
    @browser.div(:class => "media-heading").link(:class => "media-heading ember-view media-heading").click
    @browser.wait_until { @browser.div(:class => /row conversation-root-post/).exists? }
    assert @browser.div(:class => /row conversation-root-post/).exists? 
    
    @browser.div(:class => "conversation-content").link(:href => "/n/#{$networkslug}").when_present.click
    @browser.wait_until($t) { @browser.div(:class => "topics-grid row").exists? }
    assert @browser.wait_until($t) { @browser.div(:class => "topics-grid row").exists? }
  end

    def xtest_00280_open_questions_widget
    network_landing($network)
    topic_name = "A Watir Topic With Many Posts"
    @browser.wait_until { @browser.div(:class => "topics").div(:class => "topics-grid row").div(:id => "topics").div(:class => "col-sm-12 col-lg-4 col-md-4").present?}
    assert @browser.div(:class => "topics").div(:class => "topics-grid row").div(:id => "topics").div(:class => "col-sm-12 col-lg-4 col-md-4").present?
       if !(@browser.link(:class => "ember-view", :text => topic_name).present?)
         topic_sort_by_name
       end
       @browser.link(:class => "ember-view", :text => topic_name).when_present.click
       @browser.wait_until($t) { @browser.div(:class => "topic-filters").exists? }
       assert @browser.div(:class => "topic-filters").exists?

    if @browser.div(:class => "topic-create-wizard").div(:class => "container").div(:class => "row").div(:class => "button-align-right").button(:class => "btn btn-primary btn-sm", :text => "Publish Changes").exists?
      @browser.div(:class => "topic-create-wizard").div(:class => "container").div(:class => "row").div(:class => "button-align-right").button(:class => "btn btn-primary btn-sm", :text => "Publish Changes").click
      @browser.wait_until($t) { @browser.div(:class => "buttons col-lg-6 col-md-6").div(:class => "btn-toolbar pull-right").div(:class => "btn-group").button(:class => "btn btn-default btn-sm admin-dark-btn topic-admin-buttons").exists? }
      assert @browser.div(:class => "buttons col-lg-6 col-md-6").div(:class => "btn-toolbar pull-right").div(:class => "btn-group").button(:class => "btn btn-default btn-sm admin-dark-btn topic-admin-buttons").present?
    end
    @browser.wait_until($t) { @browser.div(:class => "topic-overview").present? }
    assert @browser.div(:class => "topic-overview").present?
    @browser.execute_script("window.scrollBy(0,7000)")
    @browser.wait_until { @browser.div(:class => "widget open_questions", :text => /Open Questions/).present? }
    open_questions_widget = @browser.div(:class => "widget open_questions" , :text => /Open Questions/)
    assert open_questions_widget.present?

    @browser.wait_until($t) {
      open_questions_widget.li.present?
    }

    assert open_questions_widget.link(:text => /Watir Test Question/).present?

    open_questions_widget.link(:text => /Watir Test Question/).when_present.click
    @browser.wait_until($t) { @browser.div(:class => "media-body").h3(:class => "media-heading root-post-title").present?}
    assert @browser.div(:class => "media-body", :text => /Watir Test Question/).present?
    assert !@browser.div(:class => "media featured-post").present?, "Make sure no post is featured for this question"
  end

  def xtest_00281_top_contributors_widget #seed data issue for creator
    network_landing($network)
    main_landing("regular", "logged")
    topic_name = "A Watir Topic For Widgets"

    @browser.wait_until { @browser.div(:class => "topics").div(:class => "topics-grid row").div(:id => "topics").div(:class => "col-sm-12 col-lg-4 col-md-4").present?}
    assert @browser.div(:class => "topics").div(:class => "topics-grid row").div(:id => "topics").div(:class => "col-sm-12 col-lg-4 col-md-4").present?
    #topic_detail(topic_name)
       if !@browser.text.include? topic_name
         topic_sort_by_name
         @browser.wait_until { @browser.div(:class => "topics").div(:class => "topics-grid row").div(:id => "topics").div(:class => "col-sm-12 col-lg-4 col-md-4").present?}
       end
       topic_sort_by_name
       @browser.link(:class => "ember-view", :text => topic_name).when_present.click
       @browser.wait_until($t) { @browser.div(:class => "topic-filters").exists? }
       assert @browser.div(:class => "topic-filters").exists?
    choose_post_type("discussion")
    # Make sure watir admin is not in top contributors on this topic
    # If assertion fails, fix the data by unliking all posts.
    top_contributors_widget = @browser.div(:class => "widget top_contributors")# , :text => /Top Contributors/)
    @browser.wait_until($t) {
      top_contributors_widget.span(:class => /icon-discussion/).present? ||
        top_contributors_widget.li.present?
    }
    if top_contributors_widget.text.include? "#{$user1[3]}"
      main_landing("regis", "logged")
      topic_detail("A Watir Topic For Widgets")
      choose_post_type("discussion")
      @browser.wait_until ($t) { @browser.div(:class => "post media ").exists? }
      @browser.link(:text => /::PD1:: Discussion1 posted to test popular discussion widget?/).when_present.click
      @browser.wait_until($t) { @browser.div(:class => "row conversation-root-post").exists? }
      #assert @browser.div(:class => "conversation-content").exists?
      assert @browser.div(:class => "row conversation-root-post").present?
      like_disc_element = @browser.link(:class => "like", :text => /Like|Unlike/)
      @browser.wait_until($t) { like_disc_element.present? }
      if like_disc_element.text == "Unlike"
        like_disc_element.click
        @browser.wait_until($t) { @browser.link(:class => "like", :text => /Like/).present? }
      end

      main_landing("regular", "logged")
      topic_detail("A Watir Topic For Widgets")
      choose_post_type("discussion")
    end
    assert top_contributors_widget.text !~ /#{$user1[3]}/, "Please fix topic data by unliking all posts in 'A Watir Topic for Widgets'"
    
    #@browser.div(:class => "media-heading").link.click
    @browser.link(:text => /::PD1:: Discussion1 posted to test popular discussion widget?/).when_present.click
    @browser.wait_until($t) { @browser.div(:class => "row conversation-root-post").exists? }
    #assert @browser.div(:class => "conversation-content").exists?
    assert @browser.div(:class => "row conversation-root-post").present?
    follow_disc_element = @browser.link(:class => "follow")
    if @browser.link(:class => "follow", :text => "Follow").present? #added check for admin follow for root post
    follow_disc_element.when_present.click
    sleep 2
    @browser.wait_until($t) { @browser.link(:class => "follow", :text => "Unfollow").present? }
    end
    signout
    main_landing("regis", "logged")
    topic_name = "A Watir Topic For Widgets"
    @browser.wait_until { @browser.div(:id => "topics").div(:class => "col-sm-12 col-lg-4 col-md-4").present?}
    assert @browser.div(:id => "topics").div(:class => "col-sm-12 col-lg-4 col-md-4").present?
       if !(@browser.link(:class => "ember-view", :text => /#{topic_name}/).present?)
         topic_sort_by_name
       end
       @browser.link(:class => "ember-view", :text => /#{topic_name}/).when_present.click
       @browser.wait_until($t) { @browser.div(:class => "topic-filters").present? }
       assert @browser.div(:class => "topic-filters").present?
    choose_post_type("discussion")
    @browser.link(:text => /::PD1:: Discussion1 posted to test popular discussion widget?/).when_present.click
    @browser.wait_until($t) { @browser.div(:class => "row conversation-root-post").present? }
    #assert @browser.div(:class => "conversation-content").present?
    assert @browser.div(:class => "row conversation-root-post").present?
    like_disc_element = @browser.link(:class => "like", :text => /Like|Unlike/)
    @browser.wait_until($t) { like_disc_element.present? }
    if like_disc_element.text == "Unlike"
      like_disc_element.click
      @browser.wait_until($t) { @browser.link(:class => "like", :text => /Like/).present? }
    end
    assert like_disc_element.present?
    like_disc_element.click
    @browser.wait_until($t) { @browser.link(:class => "like", :text => "Unlike").present?}
    @browser.link(:class => "ember-view", :href => /a-watir-topic-for-widgets/).when_present.click
    @browser.wait_until($t) { @browser.div(:class => "topic-filters").present? }
    assert @browser.div(:class => "topic-filters").present?
    if @browser.div(:class => "topic-create-wizard").button(:class => "btn btn-primary btn-sm", :text => "Publish Changes").present?
      @browser.div(:class => "topic-create-wizard").button(:class => "btn btn-primary btn-sm", :text => "Publish Changes").click
      @browser.wait_until($t) { @browser.div(:class => "buttons col-lg-6 col-md-6").div(:class => "btn-toolbar pull-right").div(:class => "btn-group").button(:class => "btn btn-default btn-sm admin-dark-btn topic-admin-buttons").present? }
      assert @browser.div(:class => "buttons col-lg-6 col-md-6").div(:class => "btn-toolbar pull-right").div(:class => "btn-group").button(:class => "btn btn-default btn-sm admin-dark-btn topic-admin-buttons").present?
    end
    @browser.execute_script("window.scrollBy(0,7000)")
    @browser.wait_until($t) { @browser.div(:class => "widget top_contributors").span(:class => "ember-view network-profile-link").present? }
    assert top_contributors_widget.present?

    @browser.wait_until($t) {
      top_contributors_widget.li.present?
    }

    assert top_contributors_widget.link(:text => $user1[3]).present?
    #assert top_contributors_widget.text.include? $user1[3]

    top_contributors_widget.link(:text => $user1[3]).when_present.click
    @browser.wait_until($t) { @browser.div(:class => "profile-box-background").present?}
    assert @browser.div(:class => "col-md-10 col-lg-10 col-xs-12 col-sm-12").text.include? $user1[3]
    @browser.link(:text => /Topics/).when_present.click
    @browser.wait_until($t) { @browser.div(:class => "topics-grid row").present? }
    assert @browser.div(:class => "topics-grid row").present?
    topic_name = "A Watir Topic For Widgets"
    @browser.wait_until { @browser.div(:class => "topics").div(:class => "topics-grid row").div(:id => "topics").present? }
    assert @browser.div(:class => "topics").div(:class => "topics-grid row").div(:id => "topics").present? #div(:class => "col-sm-12 col-lg-4 col-md-4").div(:class => "topic").present?
       if !(@browser.link(:class => "ember-view", :text => topic_name).present?)
         topic_sort_by_name
       end
       @browser.link(:class => "ember-view", :text => topic_name).when_present.click
       @browser.wait_until($t) { @browser.div(:class => "topic-filters").present? }
       assert @browser.div(:class => "topic-filters").present?
    choose_post_type("discussion")
    @browser.link(:text => /::PD1:: Discussion1 posted to test popular discussion widget?/).when_present.click
    @browser.wait_until($t) { @browser.div(:class => "ember-view").present? }
    #assert @browser.div(:class => "conversation-content").present?
    assert @browser.div(:class => "ember-view").present?
    like_disc_element = @browser.link(:class => "like", :text => /Unlike/)
    like_disc_element.when_present.click
    @browser.wait_until($t) { @browser.link(:class => "like", :text => /Like/).present? }
    assert @browser.link(:class => "like", :text => /Like/).present?
    signout
  end

  def xtest_00290_recent_searches_widget
    network_landing($network)
    topic_detail("A Watir Topic")
    searchtext = "Watir Test Question1 ?"

    if @browser.div(:class => "topic-create-wizard").div(:class => "container").div(:class => "row").div(:class => "button-align-right").button(:class => "btn btn-primary btn-sm", :text => "Publish Changes").exists?
      @browser.div(:class => "topic-create-wizard").div(:class => "container").div(:class => "row").div(:class => "button-align-right").button(:class => "btn btn-primary btn-sm", :text => "Publish Changes").click
      @browser.wait_until($t) { @browser.div(:class => "buttons col-lg-6 col-md-6").div(:class => "btn-toolbar pull-right").div(:class => "btn-group").button(:class => "btn btn-default btn-sm admin-dark-btn topic-admin-buttons").exists? }
      assert @browser.div(:class => "buttons col-lg-6 col-md-6").div(:class => "btn-toolbar pull-right").div(:class => "btn-group").button(:class => "btn btn-default btn-sm admin-dark-btn topic-admin-buttons").present?
    end
    @browser.wait_until($t) { @browser.text_field(:class => "ember-view ember-text-field typeahead form-control tt-input").exists? }
    @browser.text_field(:class => "ember-view ember-text-field typeahead form-control tt-input").when_present.set searchtext
    @browser.wait_until($t) { @browser.span(:class => "tt-dropdown-menu").exists? }
    @browser.send_keys :enter
    #sleep 2
    @browser.wait_until { @browser.div(:class => "row filters search-facets").exists? }

    recent_searchs_widget= @browser.div(:class => "widget recent_search" , :text => /Recent Searches/)
    @browser.wait_until { recent_searchs_widget.present? }
    assert recent_searchs_widget.present?
    
    @browser.wait_until($t) {
      recent_searchs_widget.link(:text => searchtext).present?
    }

    assert recent_searchs_widget.link(:text => searchtext).present?
  end

  def xtest_00300_popular_answers_widget #skipping for now due to seed data issue, will be fixed in reseeding
    network_landing($network)
    topic_name = "A Watir Topic With Many Posts"
    assert @browser.div(:class => "topics").div(:class => "topics-grid row").div(:id => "topics").div(:class => "col-sm-12 col-lg-4 col-md-4").present?
       if !(@browser.link(:class => "ember-view", :text => topic_name).present?)
         topic_sort_by_name
       end
       @browser.link(:class => "ember-view", :text => topic_name).when_present.click
       @browser.wait_until($t) { @browser.div(:class => "topic-filters").exists? }
       assert @browser.div(:class => "topic-filters").exists?

    if @browser.div(:class => "topic-create-wizard").div(:class => "container").div(:class => "row").div(:class => "button-align-right").button(:class => "btn btn-primary btn-sm", :text => "Publish Changes").exists?
      @browser.div(:class => "topic-create-wizard").div(:class => "container").div(:class => "row").div(:class => "button-align-right").button(:class => "btn btn-primary btn-sm", :text => "Publish Changes").click
      @browser.wait_until($t) { @browser.div(:class => "buttons col-lg-6 col-md-6").div(:class => "btn-toolbar pull-right").div(:class => "btn-group").button(:class => "btn btn-default btn-sm admin-dark-btn topic-admin-buttons").exists? }
      assert @browser.div(:class => "buttons col-lg-6 col-md-6").div(:class => "btn-toolbar pull-right").div(:class => "btn-group").button(:class => "btn btn-default btn-sm admin-dark-btn topic-admin-buttons").present?
    end
    @browser.wait_until($t) { @browser.div(:class => "topic-overview").exists? }
    assert @browser.div(:class => "topic-overview").exists?
    @browser.execute_script("window.scrollBy(0,7000)")
    @browser.wait_until($t) { @browser.div(:class => "widget popular_answers").exists? }
    popular_answers_widget = @browser.div(:class => "widget popular_answers" , :text => /Popular Answers/)
    @browser.wait_until($t) {
      popular_answers_widget.present?
    }
    assert popular_answers_widget.present?

    @browser.wait_until($t) { popular_answers_widget.link(:text => /::PA1:: Question1/).present? }
    assert popular_answers_widget.link(:text => /::PA1:: Question1/).present?

    popular_answers_widget.link(:text => /::PA1:: Question1/).click
    @browser.wait_until($t) { @browser.div(:class => "media-body", :text => /::PA1:: Question1/).present?}

    assert @browser.div(:class => "media-body", :text => /::PA1:: Question1/).present?
    assert @browser.div(:class => "featured-post-collection").present?, "Make sure answer is featured for this question"
  end
  
  if ENV["USE_FIXTURES"]
    # TODO store cookies such that they can be accessed in a distributed environment
    # may be namespaced by the domain?
    
    def test_save_session
      PageObject.new(@browser).network_landing($networkslug)
      PageObject.new(@browser).login($user4)    
      @browser.cookies.delete '_ga'
      @browser.cookies.delete '_gat'
      @browser.cookies.save "cookies.yml" # <- TODO qualify by the username or something 
    end

    def test_restore_session
      PageObject.new(@browser).network_landing($networkslug)
      @browser.wait
      refute_match /watir2/, @browser.text
      
      @browser.cookies.clear
      @browser.cookies.load "cookies.yml"
      PageObject.new(@browser).network_landing($networkslug)
      assert_match /watir2/, @browser.text
    end

    def test_00310_popular_discussions_widget_fixtures    
      topic = topics(:a_watir_topic_for_widgets)
      

      @browser.goto topic.url
      @browser.wait
      @browser.execute_script("window.scrollBy(0,7000)")
      popular_discussions_widget = @browser.div(:class => "widget popular_discussions")
      assert popular_discussions_widget.exists?
      @browser.wait_until {
        0 == @browser.execute_script("return $('.popular_discussions').find('.fa-spinner').length")
      }
      popular_discussions_one = popular_discussions_widget.link(:text => /::PD1:: Discussion1/)
      
      assert popular_discussions_one.exists?, "Discussion link not found"
      popular_discussions_one.click
      @browser.wait_until($t) { @browser.div(:class => "media-heading").present?}
      
      assert @browser.div(:class => "media-body", :text => /::PD1:: Discussion1/).exists?
      assert @browser.div(:class => "featured-post-collection").exists?, "Make sure comment is featured for this discussion"
    end
  end
  
  def xtest_00310_popular_discussions_widget    
    network_landing($network)
    topic_name = "A Watir Topic For Widgets"
    assert @browser.div(:class => "topics").div(:class => "topics-grid row").div(:id => "topics").div(:class => "col-sm-12 col-lg-4 col-md-4").present?
       if !(@browser.link(:class => "ember-view", :text => topic_name).present?)
         topic_sort_by_name
       end
       @browser.link(:class => "ember-view", :text => topic_name).when_present.click
       @browser.wait_until($t) { @browser.div(:class => "topic-filters").exists? }
       assert @browser.div(:class => "topic-filters").exists? #changing topic here to get topictype = engagement

    if @browser.div(:class => "topic-create-wizard").div(:class => "container").div(:class => "row").div(:class => "button-align-right").button(:class => "btn btn-primary btn-sm", :text => "Publish Changes").exists?
      @browser.div(:class => "topic-create-wizard").div(:class => "container").div(:class => "row").div(:class => "button-align-right").button(:class => "btn btn-primary btn-sm", :text => "Publish Changes").click
      @browser.wait_until($t) { @browser.div(:class => "buttons col-lg-6 col-md-6").div(:class => "btn-toolbar pull-right").div(:class => "btn-group").button(:class => "btn btn-default btn-sm admin-dark-btn topic-admin-buttons").exists? }
      assert @browser.div(:class => "buttons col-lg-6 col-md-6").div(:class => "btn-toolbar pull-right").div(:class => "btn-group").button(:class => "btn btn-default btn-sm admin-dark-btn topic-admin-buttons").present?
    end
    @browser.wait_until($t) { @browser.div(:class => "topic-overview").exists? }
    assert @browser.div(:class => "topic-overview").exists?
    @browser.wait_until($t) { @browser.div(:class => "widget-container zone side col-lg-4 col-md-4").exists? }
    @browser.execute_script("window.scrollBy(0,16000)")
    popular_discussions_widget = @browser.div(:class => "widget popular_discussions")
    assert popular_discussions_widget.exists?

    @browser.wait_until($t) {
      popular_discussions_widget.li.exists?
    }

    assert popular_discussions_widget.link(:text => /::PD1:: Discussion1/).exists?
  
    popular_discussions_widget.link(:text => /::PD1:: Discussion1/).when_present.click
    @browser.wait_until { @browser.div(:class => /row conversation-root-post/).exists? }

    assert @browser.div(:class => "media-body", :text => /::PD1:: Discussion1/).exists?
    assert @browser.div(:class => "featured-post-collection").exists?, "Make sure comment is featured for this question"
  end


  def test_00311_login_widget_on_topic_page
    PageObject.new(@browser).network_landing_topic_wait($network)

    if (@browser.link(:class => "dropdown-toggle profile").present?)
      PageObject.new(@browser).signout
    end
      
    PageObject.new(@browser).topic_detail("A Watir Topic")
    @browser.wait_until { @browser.div(:class => "topic-filters").exists? }
    assert @browser.div(:class => "topic-filters").exists?
    @browser.wait_until { @browser.div(:class => "widget sign-in").exists? }

    sign_in_widget = @browser.div(:class => "widget sign-in" , :text => /Join the Conversation/)
    assert sign_in_widget.exists?
    login_from_widget($user3)
    refute sign_in_widget.exists?
  end

  def test_00312_login_widget_on_conversation_page
    PageObject.new(@browser).network_landing_topic_wait($network)

    if (@browser.link(:class => "dropdown-toggle profile").present?)
      PageObject.new(@browser).signout
    end
      
    PageObject.new(@browser).topic_detail("A Watir Topic")
    @browser.wait_until { @browser.div(:class => "topic-overview").exists? }
    assert @browser.div(:class => "topic-overview").exists?
    PageObject.new(@browser).choose_post_type("question")
    PageObject.new(@browser).conversation_detail("question")

    sign_in_widget = @browser.div(:class => "widget sign-in")
    assert sign_in_widget.exists?
    login_from_widget($user3)
    refute sign_in_widget.exists?
  end

  def test_00313_action_panel_widget_add_question
    PageObject.new(@browser).network_landing($network)

    if (@browser.div(:class => "pull-right flex-content-center").text.include? "Sign In / Register")
      PageObject.new(@browser).login($user3)
    end

    PageObject.new(@browser).topic_detail("A Watir Topic")
    @browser.wait_until { @browser.div(:class => "topic-overview").exists? }
    assert @browser.div(:class => "topic-overview").exists?
    PageObject.new(@browser).choose_post_type("question")
    PageObject.new(@browser).conversation_detail("question")

    action_panel_widget = @browser.div(:class => "widget" , :text => /Join the Conversation/)
    assert action_panel_widget.exists?
    @browser.link(:class => "ember-view" , :text => "Ask a New Question").when_present.click
    @browser.wait_until($t) { @browser.div(:class => "row post-type-picker").exists? }

    PageObject.new(@browser).create_conversation($network, $networkslug, "A Watir Topic", "question", "Q from action panel widget created by Watir - #{get_timestamp}")
  end

  # def test_00314_action_panel_widget_add_discussion
  #   PageObject.new(@browser).network_landing($network)

  #   if (@browser.div(:class => "pull-right flex-content-center").text.include? "Sign In / Register")
  #     PageObject.new(@browser).login($user3)
  #   end

  #   PageObject.new(@browser).topic_detail("A Watir Topic")
  #   @browser.wait_until { @browser.div(:class => "topic-overview").exists? }
  #   assert @browser.div(:class => "topic-overview").exists?
  #   PageObject.new(@browser).choose_post_type("discussion")
  #   PageObject.new(@browser).conversation_detail("discussion")

  #   action_panel_widget = @browser.div(:class => "widget" , :text => /Join the Conversation/)
  #   assert action_panel_widget.exists?
  #   @browser.link(:class => "ember-view" , :text => "Add a New Discussion").when_present.click
  #   @browser.wait_until($t) { @browser.div(:class => "row post-type-picker").exists? }

  #   PageObject.new(@browser).create_conversation($network, $networkslug, "A Watir Topic", "discussion", "Discussion from action panel widget created by Watir - #{get_timestamp}")
  # end

  def xtest_00315_featured_topics_widget
    network_landing($network) # goes to the network home page
    main_landing("regular", "logged") #
    topic_name = "A Watir Topic For Widgets"
    topic_detail(topic_name)
    @browser.wait_until { @browser.div(:class => "topic-filters").exists? }
    assert @browser.div(:class => "topic-filters").exists?
    if @browser.button(:class => "btn btn-default btn-sm admin-dark-btn", :text => "Unfeature Topic").present?
      unfeature_topic
    end
    feature_topic
    @browser.link(:href => "/n/#{$networkslug}", :class => "ember-view").click
    @browser.wait_until { @browser.div(:id => "topics").div(:class => "col-sm-12 col-lg-4 col-md-4").div(:class => "topic").div(:class => "topic-tile-body").exists? }
    assert @browser.div(:id => "topics").div(:class => "col-sm-12 col-lg-4 col-md-4").div(:class => "topic").div(:class => "topic-tile-body").exists?
    @browser.wait_until { @browser.button(:class => "btn btn-default", :text => "Featured").present? }
    @browser.button(:class => "btn btn-default", :text => "Featured").click
    
    @browser.wait_until { @browser.div(:id => "topics").div(:class => "col-sm-12 col-lg-4 col-md-4").div(:class => "topic").div(:class => "topic-tile-body").exists? }
    #assert @browser.div(:class => "topics").text.include? topic_name
    assert @browser.link(:class => "ember-view", :text => topic_name).present?
    
    @browser.button(:class => "btn btn-default", :text => "All").click
    @browser.wait_until { @browser.div(:class => "topics").div(:class => "col-sm-12 col-lg-4 col-md-4").present? }
    assert @browser.div(:class => "topics").div(:class => "col-sm-12 col-lg-4 col-md-4").present?
    if ( !@browser.link(:class => "ember-view").h4(:text => topic_name).present?)
         topic_sort_by_name
    end
    @browser.link(:class => "ember-view", :text => "A Watir Topic").when_present.click
    @browser.wait_until($t) { @browser.div(:class => "topic-filters").exists? }
    if @browser.button(:class => "btn btn-default btn-sm admin-dark-btn", :text => "Unfeature Topic").present?
      unfeature_topic
    end
    assert @browser.div(:class => "topic-filters").exists?
    @browser.wait_until { @browser.div(:class => "widget featured_topics").ul(:class => "media-list").exists? }
    assert @browser.div(:class => "widget featured_topics").exists?
    assert @browser.div(:class => "widget featured_topics").text.include? topic_name
    @browser.div(:class => "widget featured_topics").ul.li(:class => "media").div(:class => "media-left").div(:class => "media-body").link(:class => "ember-view", :text => topic_name).click
    @browser.wait_until($t) { @browser.div(:class => "topic-filters").exists? }
    assert @browser.div(:class => "col-md-12").text.include? topic_name
    assert @browser.div(:class => "topic-filters").exists?
    if @browser.button(:class => "btn btn-default btn-sm admin-dark-btn", :text => "Unfeature Topic").present?
      unfeature_topic
    end
  end

  def xtest_00316_featured_post_widget
    network_landing($network)
    main_landing("regular", "logged")
    topic_detail("A Watir Topic With Many Posts")
    topic_url = @browser.url
    choose_post_type("discussion")
    conversation_detail("discussion")
    title = @browser.h3(:class => "media-heading root-post-title").text
    title_firstword = title.split(' ')
    #puts "#{title_firstword[0]}"
    #puts "#{title}"
    if @browser.span(:class => "featured").exists?
      unfeature_root_post
    end
    feature_root_post
    @browser.goto topic_url
    @browser.wait_until { @browser.div(:class => "row topic-filter-set").present? }
    @browser.execute_script("window.scrollBy(0,7000)")
    sleep 2
    @browser.wait_until($t) { @browser.div(:class => "widget featured_posts").ul(:class => "media-list").present? }
    
    #assert @browser.div(:class => "widget featured_posts").link(:class => "ember-view", :text => /#{title_firstword[0]}/).present? #{}"Watir Test Discussion2 !"
    @browser.div(:class => "widget featured_posts").link(:class => "ember-view", :text => /#{title_firstword[0]}/).click
    
    @browser.wait_until($t) { @browser.div(:class => /depth-0 discussion/).exists? }
    title2 = @browser.h3(:class => "media-heading root-post-title").text
    assert title == title2
    @browser.goto topic_url
    choose_post_type("discussion")
    
    @browser.link(:class => "media-heading ember-view media-heading", :text => "#{title}").when_present.click
    @browser.wait_until($t) { @browser.div(:class => /depth-0 discussion/).exists? }
    if @browser.span(:class => "crumb-icon icon-favorite").exists?
      unfeature_root_post
    end
    
    @browser.goto topic_url
    @browser.wait_until($t) { @browser.div(:class => "widget featured_posts").present? }
    @browser.execute_script("window.scrollBy(0,2000)")
    assert ( !@browser.div(:class => "widget featured_posts", :text => /#{title}/).present? )
  end
  
  def test_00320_create_blog
    PageObject.new(@browser).about_landing($network)
    PageObject.new(@browser).main_landing("regular", "logged")
    PageObject.new(@browser).create_conversation($network, $networkslug, "A Watir Topic", "blog", "Blog created by Watir - #{get_timestamp}", false)
  end
  
  def test_00330_comment_on_blog
    PageObject.new(@browser).network_landing($network)
    PageObject.new(@browser).main_landing("regular", "logged")
    PageObject.new(@browser).topic_detail("A Watir Topic")
    PageObject.new(@browser).choose_post_type("blog")
    PageObject.new(@browser).conversation_detail("blog")
    assert @browser.div(:class => /ember-view/).present?

    comment_text = "commented by Watir - #{get_timestamp}"
    comment_root_post(comment_text)
  end
  
  def test_00340_feature_unfeature_blog_and_comment
    PageObject.new(@browser).network_landing($network)
    PageObject.new(@browser).main_landing("regular", "logged")
    PageObject.new(@browser).topic_detail("A Watir Topic")
    PageObject.new(@browser).choose_post_type("blog")
    PageObject.new(@browser).conversation_detail("blog")
    assert @browser.div(:class => /ember-view/).present?

    if (@browser.span(:class => "crumb-icon icon-favorite").present?)
      PageObject.new(@browser).unfeature_root_post
    end
    PageObject.new(@browser).feature_root_post
    PageObject.new(@browser).unfeature_root_post

    if !(@browser.div(:class => /ember-view depth-1 post/).present?)
    #  PageObject.new(@browser).conversation_detail_reply
     answer_text = "Comment by Watir - #{get_timestamp}"
     @browser.textarea(:class => "ember-view ember-text-area form-control").when_present.focus
     @browser.wait_until($t) { @browser.div(:class => "group text-right").present? }
     @browser.textarea(:class => "ember-view ember-text-area form-control").when_present.set answer_text
     @browser.button(:class => "btn btn-sm btn-primary", :text => "Submit").when_present.click
     if @browser.button(:class => "btn", :value => /Sort by: Oldest/).exists?
      PageObject.new(@browser).sort_by_new_in_conversation_detail
     end
     @browser.wait_until($t) { @browser.div(:class => "media-body", :text => /#{answer_text}/).exists? }
    
    end

    if (@browser.div(:class => /ember-view depth-1 feature post/).present?)
      PageObject.new(@browser).unfeature_comment
    end
    PageObject.new(@browser).feature_comment
    PageObject.new(@browser).unfeature_comment
    PageObject.new(@browser).signout
  end

  def xtest_00350_set_home_page_banner_image
    about_landing($network)
    main_landing("admin", "logged")
    home_page_layout_url = $base_url #+ "/#/n/#{$networkslug}/home" 
    @browser.goto  home_page_layout_url
    @browser.wait_until($t) {
     @browser.div(:class => "zone header").exists?
    }

    edit_button_link = @browser.button(:class => "ember-view btn btn-default btn-sm admin-dark-btn", :text => "Edit Home Page")
    assert edit_button_link.exists?, "Edit Button should Show"

    homebannerimage1 = ("#{$rootdir}/seeds/development/images/chicagoRiverView.jpeg")
    homebannerimage2 = ("#{$rootdir}/seeds/development/images/chicagoNightView.jpg")

    @browser.button(:text => "Edit Home Page").when_present.click
    
    if @browser.link(:text => "browse").exists?
      assert @browser.link(:text => "browse").exists?
    else

      assert @browser.button(:class => "btn btn-default btn-sm admin-dark-btn", :text => "Change Photo").exists?
    end

    sleep 3
    if $os == "windows"
      @browser.execute_script('$(".photo-upload-browse").removeClass("photo-upload-browse")')
    end
    
    @browser.file_field(:class => "files").set homebannerimage1

    @browser.wait_until($t) {@browser.div(:class => "cropper-canvas").exists? }
    @browser.button(:class => "btn btn-primary", :text => "Select Photo").when_present.click

    sleep 3
    
    @browser.wait_until($t) { @browser.div(:class => "ember-view uploader-component widget banner normal home").exists? }
    banner_image1 = @browser.div(:class => "ember-view uploader-component widget banner normal home").style   
    assert_match /chicagoRiverView.jpeg/, banner_image1, "background url should match chicagoRiverView.jpeg"

    assert @browser.button(:class => "btn btn-default btn-sm admin-dark-btn", :text => "Change Photo").exists?

    @browser.wait_until($t) { @browser.div(:class => "modal-header").exists? }
    sleep 3
    if $os == "windows"
      @browser.execute_script('$(".photo-upload-browse").removeClass("photo-upload-browse")')
    end
    @browser.file_field(:class => "files").set homebannerimage2
    @browser.wait_until($t) {@browser.div(:class => "cropper-canvas").exists? }
    @browser.button(:class => "btn btn-primary", :text => "Select Photo").when_present.click
    sleep 3
    @browser.wait_until($t) { @browser.div(:class => "ember-view uploader-component widget banner normal home").exists? }
    banner_image2 = @browser.div(:class => "ember-view uploader-component widget banner normal home").style

    assert_match /chicagoNightView.jpg/, banner_image2, "background url should match chicagoNightView.jpg"
  end

  def xtest_00360_edit_and_save_profile
    about_landing($network)
    main_landing("regis", "logged")
    caret = @browser.span(:class => "caret")
    @browser.wait_until($t){
      caret.exists?
    }
    caret.click

    bio = "Bio edited by Watir - #{get_timestamp}"
    @browser.div(:class=>"dropdown open").link(:text => "My Profile").when_present.click
    @browser.wait_until($t) { @browser.div(:class => "row profile-box").exists? }
    assert @browser.button(:class => "shown btn btn-primary btn-sm shown", :text => "Edit Profile").present?
    @browser.button(:class => "shown btn btn-primary btn-sm shown", :text => "Edit Profile").when_present.click
    @browser.wait_until($t) { @browser.div(:class => "edit-profile").exists? }
    @browser.execute_script("window.scrollBy(0,800)")
    @browser.textarea(:class => "form-control form-control ember-view ember-text-area form-control").when_present.set bio
    @browser.div(:class => "col-md-4 col-xs-12 col-lg-4 col-md-offset-6").button(:class => "btn btn-primary").when_present.click
    #@browser.wait_until { !@browser.div(:class => "col-md-4 col-xs-4 col-lg-4 col-md-offset-6").button(:class => "btn btn-primary")}
    sleep 4
    bg_box = @browser.div(:class => "profile-box-background")
    @browser.execute_script('$("div.profile-box-background").scrollTop(200)')
    @browser.wait_until($t) { @browser.div(:class => "profile-box-background").exists? }
    @browser.wait_until($t) { @browser.div(:class => "shown container").div(:class => "shown row profile-info-extra").div(:class => "col-lg-12").text.include? bio}
    assert @browser.div(:class => "shown container").div(:class => "shown row profile-info-extra").div(:class => "col-lg-12").text.include? bio
  end

    def xtest_00370_edit_profilepic
    about_landing($network)
    main_landing("regis", "logged")
    caret = @browser.span(:class => "caret")
    @browser.wait_until($t){
      caret.exists?
    }
    caret.click

    profilepic = "#{$rootdir}/seeds/development/images/profilepic.jpeg"
    @browser.div(:class=>"dropdown open").link(:text => "My Profile").when_present.click
    @browser.wait_until($t) { @browser.div(:class => "row profile-box").exists? }
    @browser.div(:class => "profile-photo-edit-icon photo-edit").when_present.click

    if @browser.div(:class => "ember-view uploader-component profile-selected-image has-image").exists?
      @browser.form(:class => "ember-view").div(:class => "left-align photo-upload-browse-button").button(:class => " btn btn-default photo-change").exists?
      @browser.button(:class => " btn btn-default", :value => /Delete Photo/).when_present.click
      @browser.wait_until($t) { @browser.div(:class => "modal-footer").button(:class => "btn btn-primary", :text => "Delete Photo").present? }
      @browser.div(:class => "modal-footer").button(:class => "btn btn-primary", :text => "Delete Photo").when_present.click
      @browser.wait_until { !@browser.div(:class => "modal-dialog").present? }
      @browser.wait_until($t) { @browser.div(:class => "ember-view uploader-component profile-selected-image has-image").present? }
      assert @browser.div(:class => "ember-view uploader-component profile-selected-image has-image").present?
      @browser.wait_until { @browser.div(:class => "profile-photo-edit-icon photo-edit").span(:class => "icon-add-photo").present? }
      @browser.span(:class => "icon-add-photo").when_present.click
    end


    @browser.wait_until($t) { @browser.div(:class => "modal-content").exists? }
    @browser.file_field(:class => "file").set profilepic
    @browser.wait_until { @browser.div(:class => "cropper-canvas cropper-modal cropper-crop").exists? }
    @browser.button(:class => "btn btn-primary btn-sm file-upload-select-button", :text => "Select Photo").when_present.click
    @browser.wait_until { !@browser.div(:class => "modal-content").present? }
    @browser.refresh
    @browser.wait_until($t) { @browser.div(:class => "ember-view uploader-component profile-selected-image").present? }
    profile_image1 = @browser.div(:class => "ember-view uploader-component profile-selected-image").style
    assert_match /profilepic.jpeg/ , profile_image1, "profile image should match profilepic.jpeg"

    # #removing profile pic for next test run
    @browser.wait_until($t) { @browser.div(:class => "profile-photo-edit-icon photo-edit").present? }
    @browser.div(:class => "profile-photo-edit-icon photo-edit").when_present.click
    @browser.wait_until($t) { @browser.div(:class => "modal-content").present? }
    @browser.div(:class => "modal-content").button(:class => "btn btn-default btn-sm other", :text => "Delete Photo").when_present.click
    @browser.wait_until($t) { @browser.button(:class => "btn btn-primary", :text => "Delete Photo").present? }
    @browser.button(:class => "btn btn-primary", :text => "Delete Photo").when_present.click

    sleep 2
    @browser.refresh
    if @browser.div(:class => "modal-content").exists?
      @browser.button(:class => "close").click 
    end
    @browser.wait_until { !@browser.div(:class => "modal-content").present? }
    @browser.wait_until($t) { @browser.div(:class => "ember-view uploader-component profile-selected-image").present? }
    no_profile_image = @browser.div(:class => "ember-view uploader-component profile-selected-image").style
    assert_match /person_shadow/ , no_profile_image, "profile image should match person shadow"
  end
  
  def xtest_00380_homepage_qd_widget
    network_landing($network)
    main_landing("regular", "logged")
    topic_detail("A Watir Topic")
    choose_post_type("discussion")
    #conversation_detail("Watir Test Discussion2 !", "discussion")
    conversation_detail("discussion")
    title = @browser.h3(:class => "media-heading root-post-title").text
    #puts "#{title}"
    if @browser.span(:class => "featured").exists?
      unfeature_root_post
    end
    feature_root_post

    home_page_layout_url = $base_url #+ "/#/n/#{$networkslug}/home" 
    @browser.goto  home_page_layout_url
    @browser.wait_until($t) {
     @browser.div(:class => "row widget search").exists?
    }
    @browser.execute_script("window.scrollBy(0,2000)")
    @browser.wait_until($t) { @browser.div(:class => "widget featured_discussions", :text => /#{title}/).present? }
    assert @browser.div(:class => "widget featured_discussions", :text => /#{title}/).present? #{}"Watir Test Discussion2 !"
    @browser.goto "#{$base_url}"+"/n/#{$networkslug}"
    @browser.wait_until($t) { @browser.div(:class => "topics-grid row").exists? }
    assert @browser.div(:class => "topics").div(:class => "topics-grid row").exists?
    topic_detail("A Watir Topic")
    choose_post_type("discussion")
    #conversation_detail("discussion")
    @browser.link(:class => "media-heading ember-view media-heading", :text => title).when_present.click
    @browser.wait_until($t) { @browser.div(:class => /depth-0 discussion/).exists? }
    if @browser.span(:class => "featured").exists?
      unfeature_root_post
    end
    home_page_layout_url = $base_url #+ "/#/n/#{$networkslug}/home" 
    @browser.goto  home_page_layout_url
    @browser.wait_until($t) {
     @browser.div(:class => "row widget search").exists?
    }
    assert @browser.div(:class => "row widget search").exists?
    @browser.wait_until { @browser.div(:class => "widget featured_blog_posts").exists?}
  
    @browser.execute_script("window.scrollBy(0,2000)")

    if @browser.div(:class => "widget featured_discussions").exists?
      assert @browser.div(:class => "widget featured_discussions").exists?
    end
    assert @browser.div(:class => "widget featured_blog_posts").exists?
    assert !@browser.div(:class => "widget featured_discussions").link(:text => "Watir Test Discussion2 !").exists?


  end

  def xtest_00390_register_link
    login_register_modal_open_helper
    assert @browser.div(:class => "row signin-links signin-links-1").div(:class => "col-md-12").present?
    @browser.link(:text => "Register.").when_present.click
    @browser.wait_until($t) { @browser.div(:class => "row signup-subheading").present? }
    assert @browser.div(:class => "col-md-12" , :text => "Register with email address").exists?
    assert @browser.div(:class => "col-md-12 member-captcha").exists?
  end

  def xtest_00400_forgot_password_link
    login_register_modal_open_helper
    assert @browser.link(:class => "forgot-password-text", :text => "Forgot your Password?").present?
    @browser.link(:text => "Forgot your Password?").when_present.click
    @browser.wait_until($t) { @browser.div(:class => "container").present? }
    assert @browser.div(:class => "col-md-7").h4.text.include? "Reset Your Password"
    assert @browser.div(:class => "col-md-7").exists?
  end

  def xtest_00410_faq_link
    login_register_modal_open_helper
    assert @browser.link(:text => "Review our FAQ.").present?
    @browser.link(:text => "Review our FAQ.").when_present.click
    @browser.wait_until($t) {@browser.div(:class => "container registration-faq").present?}
    assert @browser.div(:class => "row").h3.text.include? "FAQ" 
  end

  def xtest_00420_confirmation_instructions
    login_register_modal_open_helper
    assert @browser.link(:text => "Didn't receive confirmation instructions?").present?
    @browser.link(:text => "Didn't receive confirmation instructions?").when_present.click
    @browser.wait_until($t) { @browser.div(:class => "container").present? }
    assert @browser.div(:class => "col-md-12").h4.text.include? "Get Confirmation Instructions"
    assert @browser.div(:class => "col-md-12").exists?
  end

  def xtest_00500_signout
    about_landing($network)
    main_landing("regis", "logged") 
    signout
  end

end
