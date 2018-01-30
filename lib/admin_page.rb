module AdminPage
  def revert_user_role(network, networkslug, username, role)
      about_landing(networkslug)
      main_landing("regular", "logged")
      caret = @browser.div(:class => /topbar-nav/).span(:class => "caret")
      @browser.wait_until($t){
      caret.present?
      }
      caret.click
      @browser.wait_until { @browser.div(:class=>"dropdown open").link(:href => "/admin/#{networkslug}").present? }
      assert @browser.div(:class=>"dropdown open").link(:href => "/admin/#{networkslug}").present?    
      @browser.div(:class=>"dropdown open").link(:href => "/admin/#{networkslug}").when_present.click
      @browser.wait_until($t) { @browser.div(:class => "sidebar-nav").present? }

    if role == "netmod"
      @browser.link(:href => "/admin/#{networkslug}/permission").when_present.click
      @browser.link(:href => "#network-moderators").when_present.click
      @browser.wait_until($t) { @browser.div(:id => "network-moderators").div(:class => "member-card-container container-fluid").exists? }
      @browser.div(:class => "member-card-internal", :text => /#{$user3[3]}/).i(:class => "fa fa-trash-o fa-2x delete-member-icon").when_present.click
      
      @browser.wait_until($t) { !@browser.div(:id => "network-moderators").link(:text => /#{$user3[3]}/).exists?}
      #assert @browser.div(:id => "network-moderators").div(:class =>"alert alert-success alert-dismissible display-block").exists?
      assert ( !@browser.div(:id => "network-moderators").link(:text => /#{$user3[3]}/).exists?)
      signout
    end

    if role == "netadmin"
      @browser.link(:href => "/admin/#{networkslug}/permission").when_present.click
      @browser.div(:class => "member-card-internal", :text => /#{$user3[3]}/).i(:class => "fa fa-trash-o fa-2x delete-member-icon").when_present.click
      @browser.wait_until($t) { !@browser.div(:class => "member-card-internal").link(:text => /Watir User1/).exists? }
      sleep 2
      #commenting out for now for display msg
      #assert @browser.div(:class => "ember-view").div(:class => "container").div.div(:class => "row").div(:class => "col-sm-9").div(:id => "network-permission").div(:class => "tab-content").div(:id => "network-administrators").div.div(:class => "alert-box").div(:class =>"alert alert-success alert-dismissible display-block").exists?
      assert ( !@browser.link(:text => /#{$user3[3]}/).exists?)
      signout
    end

    if role == "topicmod"
      @browser.link(:href => "/admin/#{networkslug}/permission").when_present.click
      @browser.link(:href => "#topic-permission").when_present.click
      @browser.wait_until($t) { @browser.div(:id => "topic-permission").exists? }
      @browser.select_list(:class => "ember-view ember-select form-control accessible-topic").select("A Watir Topic")
      sleep 2
      @browser.link(:href => "#topic-moderators").when_present.click
      @browser.wait_until($t) { @browser.div(:id => "network-moderators").div(:class => "member-card-container container-fluid").exists? }
      assert @browser.div(:id => "topic-moderators").div(:class => "member-card-container container-fluid").exists?
      @browser.select_list(:class => "ember-view ember-select form-control accessible-topic").select("A Watir Topic")
      @browser.wait_until($t) { @browser.div(:id => "topic-moderators").link(:text => /#{$user3[3]}/).exists? }
      @browser.div(:id => "topic-moderators").div(:class => "member-card-internal", :text => $user3[3]).i.when_present.click
      @browser.wait_until($t) {!@browser.div(:id => "topic-moderators").link(:text => /#{$user3[3]}/).exists?}
      #assert @browser.div(:id => "topic-moderators").div.div(:class => "alert-box").div(:class =>"alert alert-success alert-dismissible display-block").exists?
      assert (!@browser.div(:id => "topic-moderators").link(:text => /#{$user3[3]}/).exists?)
      signout
    end

    if role == "topicadmin"
      @browser.link(:href => "/admin/#{networkslug}/permission").when_present.click
      @browser.link(:href => "#topic-permission").when_present.click
      @browser.wait_until($t) { @browser.div(:id => "topic-permission").exists? }
      @browser.select_list(:class => "ember-view ember-select form-control accessible-topic").select("A Watir Topic")
      sleep 2
      @browser.link(:href => "#topic-administrators").when_present.click
      @browser.wait_until($t) { @browser.div(:id => "topic-administrators").div(:class => "member-card-container container-fluid").exists? }
      assert @browser.div(:id => "topic-administrators").div(:class => "member-card-container container-fluid").exists?
      @browser.select_list(:class => "ember-view ember-select form-control accessible-topic").select("A Watir Topic")
      @browser.wait_until($t) { @browser.div(:id => "topic-administrators").link(:text => /#{$user3[3]}/).exists? }
      @browser.div(:id => "topic-administrators").div(:class => "member-card-internal", :text => /#{$user3[3]}/).i.when_present.click
      @browser.wait_until($t) {!@browser.div(:id => "topic-administrators").link(:text => /#{$user3[3]}/).exists?}
      #assert @browser.div(:id => "topic-administrators").div(:class =>"alert alert-success alert-dismissible display-block").exists?
      assert (!@browser.div(:id => "topic-administrators").link(:text => /#{$user3[3]}/).exists?)
      signout
    end
  end

  def promote_user_role (network, networkslug, username, role)
    about_landing(networkslug)
    main_landing("regular", "logged")
    admin_check(networkslug)
    mod_flag_threshold(network, networkslug)
    main_landing("admin", "logged") #adding in case if previous test run fails or previous user is still logged in
    
    caret = @browser.div(:class => /topbar-nav/).span(:class => "caret")
    @browser.wait_until($t){
      caret.present?
    }
    caret.click
    @browser.wait_until($t) { @browser.div(:class=>"dropdown open").link(:href => "/admin/#{networkslug}").exists? }
    @browser.div(:class=>"dropdown open").link(:href => "/admin/#{networkslug}").when_present.click
    @browser.wait_until($t){ @browser.div(:class => "sidebar-nav").exists? }
    @browser.wait_until($t) { @browser.link(:class => "btn btn-primary pull-right ember-view" , :text => "+ New Topic").exists? }
    assert @browser.link(:class => "btn btn-primary pull-right ember-view" , :text => "+ New Topic").exists?
    
    if role == "netadmin"
      @browser.link(:href => "/admin/#{networkslug}/permission").when_present.click
      @browser.wait_until($t) { @browser.link(:href => "#network-permission").exists? }
      if (@browser.link(:text => "#{$user3[3]}").present? )
        @browser.div(:class => "member-card-internal", :text => /#{$user3[3]}/).i(:class => "fa fa-trash-o fa-2x delete-member-icon").when_present.click
      
        @browser.wait_until($t) { !@browser.div(:id => "network-moderators").link(:text => /#{$user3[3]}/).exists?}
        #assert @browser.div(:id => "network-moderators").div(:class =>"alert alert-success alert-dismissible display-block").exists?
        assert ( !@browser.div(:id => "network-moderators").link(:text => /#{$user3[3]}/).exists?)
      end
      @browser.div(:id => "network-administrators").div(:class => "row").div(:class => "col-sm-2").input(:id => "addMember").when_present.click
      @browser.wait_until($t) { @browser.div(:class => "modal-body").exists? }
      @browser.text_field(:class => "form-control ember-view ember-text-field").when_present.set $user3[0]
      sleep 2
      @browser.div(:class => "modal-content").div(:class => "modal-footer").button(:class => "btn btn-primary", :text => /Add/).when_present.click
      sleep 3
      @browser.wait_until($t) { @browser.div(:id => "network-administrators").div(:class => "member-card-container container-fluid", :text => /#{$user3[3]}/).present?}
      assert @browser.div(:id => "network-administrators").link(:text => /#{$user3[3]}/).exists?
    end

    if role == "netmod"
      @browser.link(:href => "/admin/#{networkslug}/permission").when_present.click
      @browser.wait_until($t) { @browser.link(:href => "#network-permission").exists? }
      @browser.link(:href => "#network-moderators").when_present.click
      @browser.wait_until($t) { @browser.div(:class => "member-card-internal").exists? }
      assert @browser.div(:class => "member-card-internal").exists? 
      if (@browser.link(:text => "#{$user3[3]}").present? )
        @browser.div(:class => "member-card-internal", :text => /#{$user3[3]}/).i(:class => "fa fa-trash-o fa-2x delete-member-icon").when_present.click
      
        @browser.wait_until($t) { !@browser.div(:id => "network-moderators").link(:text => /#{$user3[3]}/).exists?}
        assert ( !@browser.div(:id => "network-moderators").link(:text => /#{$user3[3]}/).exists?)
      end

      @browser.div(:id => "network-moderators").div(:class => "row").div(:class => "col-sm-2").input(:id => "addMember").when_present.click
      @browser.wait_until($t) { @browser.div(:class => "modal-body").exists? }
      @browser.div(:id => "addNetworkModeratorModal").text_field(:class => /ember-text-field/).when_present.set $user3[0]
      sleep 4
      @browser.div(:id => "addNetworkModeratorModal").button(:class => "btn btn-primary", :text => /Add/).when_present.click
      sleep 3
      @browser.wait_until($t) {@browser.div(:id => "network-moderators").div(:class => "member-card-container container-fluid", :text => /#{$user3[3]}/).present?}
      assert @browser.div(:id => "network-moderators").link(:text => /#{$user3[3]}/).exists?
    end  

    if role == "topicadmin"
      @browser.link(:href => "/admin/#{networkslug}/permission").when_present.click
      @browser.link(:href => "#topic-permission").when_present.click
      @browser.wait_until($t) { @browser.div(:id => "topic-permission").present? }
      @browser.select_list(:class => "ember-view ember-select form-control accessible-topic").select("A Watir Topic")
      sleep 2
      if (@browser.link(:text => "#{$user3[3]}").present?)
        @browser.div(:class => "member-card-internal", :text => /#{$user3[3]}/).i(:class => "fa fa-trash-o fa-2x delete-member-icon").when_present.click
      
        @browser.wait_until($t) { !@browser.div(:id => "network-moderators").link(:text => /#{$user3[3]}/).exists?}
        #assert @browser.div(:id => "network-moderators").div(:class =>"alert alert-success alert-dismissible display-block").exists?
        assert ( !@browser.div(:id => "network-moderators").link(:text => /#{$user3[3]}/).exists?)
      end
      @browser.div(:id => "topic-administrators").div(:class => "row").div(:class => "col-sm-2").input(:id => "addMember").when_present.click
      @browser.wait_until($t) { @browser.div(:id => "topic-administrators").div(:class => "modal-body").exists? }
      @browser.div(:id => "topic-administrators").text_field(:class => /ember-text-field/).when_present.set $user3[0]
      @browser.wait_until($t) { @browser.div(:class => "modal-content").div(:class => "modal-footer").button(:class => "btn btn-primary", :text => /Add/).present? }
      @browser.div(:id => "topic-administrators").button(:class => "btn btn-primary", :text => /Add/).when_present.click
      @browser.wait_until($t) { @browser.div(:id => "topic-administrators").link(:text => /#{$user3[3]}/).exists? }
      assert @browser.div(:id => "topic-administrators").link(:text => /#{$user3[3]}/).exists?
    end

    if role == "topicmod"
      @browser.link(:href => "/admin/#{networkslug}/permission").when_present.click
      @browser.link(:href => "#topic-permission").when_present.click
      @browser.wait_until($t) { @browser.div(:id => "topic-permission").exists? }
      @browser.select_list(:class => "ember-view ember-select form-control accessible-topic").select("A Watir Topic")
      sleep 2
      @browser.link(:href => "#topic-moderators").when_present.click
      @browser.wait_until($t){ @browser.div(:id => "topic-moderators").div(:class => "member-card-container container-fluid").exists? }
      assert @browser.div(:id => "topic-moderators").div(:class => "member-card-container container-fluid").exists?
      if (@browser.link(:text => "#{$user3[3]}").present?)
        @browser.div(:class => "member-card-internal", :text => /#{$user3[3]}/).i(:class => "fa fa-trash-o fa-2x delete-member-icon").when_present.click
      
        @browser.wait_until($t) { !@browser.div(:id => "network-moderators").link(:text => /#{$user3[3]}/).exists?}
        #assert @browser.div(:id => "network-moderators").div(:class =>"alert alert-success alert-dismissible display-block").exists?
        assert ( !@browser.div(:id => "network-moderators").link(:text => /#{$user3[3]}/).exists?)
      end
      @browser.select_list(:class => "ember-view ember-select form-control accessible-topic").select("A Watir Topic")
      assert @browser.div(:id => "topic-moderators").div(:class => "member-card-container container-fluid").exists? 
      @browser.div(:id => "topic-moderators").div(:class => "row").div(:class => "col-sm-2").input(:id => "addMember").when_present.click
      @browser.wait_until($t) { @browser.div(:class => "modal-body").exists? }
      @browser.div(:id => "addTopicModeratorModal").text_field(:class => /ember-text-field/).when_present.set $user3[0]
      @browser.wait_until($t) { @browser.div(:class => "modal-content").div(:class => "modal-footer").button(:class => "btn btn-primary", :text => /Add/).present? }
      @browser.div(:id => "addTopicModeratorModal").button(:class => "btn btn-primary", :text => /Add/).when_present.click
      @browser.wait_until($t) { @browser.div(:id => "topic-moderators").div(:class => "member-card-container container-fluid", :text => /#{$user3[3]}/).exists?}
      assert @browser.div(:id => "topic-moderators").link(:text => /#{$user3[3]}/).exists?
    end

    signout
    main_landing("regis", "logged")
    
    caret = @browser.div(:class => /topbar-nav/).span(:class => "caret")
    @browser.wait_until($t){
      caret.present?
    }
    caret.click
    admin_link = @browser.link(:href => "/admin/#{networkslug}")
    @browser.wait_until { admin_link.present? }
    assert admin_link.present?    
    admin_link.click
    @browser.wait_until { @browser.div(:class => "sidebar-nav").exists? }

    if role == "netadmin"
      @browser.link(:href => "/admin/#{networkslug}/permission").when_present.click
      @browser.wait_until($t) { @browser.link(:href => "#network-permission").exists? }
      assert @browser.div(:class => "member-card-container container-fluid").exists? 
      signout
    end

    if role == "netmod"
      @browser.link(:href => "/admin/#{networkslug}/moderation").when_present.click
      @browser.wait_until($t) { @browser.link(:href => "/admin/#{$networkslug}/moderation?setPage=1&tabName=flaggedPosts").exists? }
      assert @browser.link(:href => "/admin/#{$networkslug}/moderation?setPage=1&tabName=flaggedPosts").exists?
      assert !@browser.link(:href => "/admin/#{$networkslug}/topics").exists?
      assert !@browser.link(:href => "/admin/#{$networkslug}/homePage").exists?
      assert !@browser.link(:href => "/admin/#{$networkslug}/aboutPage").exists?
      assert !@browser.link(:href => "/admin/#{$networkslug}/analytics").exists?
      assert !@browser.link(:href => "/admin/#{$networkslug}/embedding").exists?
      assert !@browser.link(:href => "/admin/#{$networkslug}/disclosures").exists?
      assert !@browser.link(:href => "/admin/#{$networkslug}/branding").exists?
      assert !@browser.link(:href => "/admin/#{$networkslug}/email_designer").exists?
      assert !@browser.link(:href => "/admin/#{$networkslug}/profile_field").exists?
      assert !@browser.link(:href => "/admin/#{$networkslug}/permission").exists?
      assert !@browser.link(:href => "/admin/#{$networkslug}/reporting").exists?
      signout
    end

    if(role == "topicmod")
      @browser.link(:href => "/admin/#{networkslug}/moderation").when_present.click
      @browser.wait_until($t) { @browser.link(:href => "/admin/#{$networkslug}/moderation?setPage=1&tabName=flaggedPosts").exists? }
      assert @browser.link(:href => "/admin/#{$networkslug}/moderation?setPage=1&tabName=flaggedPosts").exists?
      assert !(@browser.input(:name => "flag_threshold").exists?)

      @browser.div(:class => "collapse navbar-collapse").ul(:class => "nav navbar-nav").link(:text => /Topics/).when_present.click
     # @browser.div(:id => "topnav").link(:text => "Topics").when_present.click
      @browser.wait_until($t) { @browser.div(:class => "topics-grid row").exists? }
      topic_detail("A Watir Topic")
      @browser.link(:href => %r{/discussion/}).when_present.click
      @browser.wait_until($t) { @browser.div(:class => "featured-post-collection").exists? }
      assert @browser.div(:class => "conversation-content").exists?
      comment_text = "Commented by Watir1 for moderation - #{get_timestamp}"
      @browser.textarea(:class => "ember-view ember-text-area form-control").when_present.focus
      @browser.wait_until($t) { @browser.div(:class => "group text-right").present? }
      #assert @browser.div(:class => "group text-right").exists?
      @browser.textarea(:class => "ember-view ember-text-area form-control").set comment_text
      @browser.textarea(:class => "ember-view ember-text-area form-control").focus
      assert @browser.button(:class => "btn btn-sm btn-primary").present?
      @browser.button(:class => "btn btn-sm btn-primary").click
      sleep 2
      sort_by_new_in_conversation_detail
      @browser.wait_until($t) { @browser.div(:class => "media-body", :text => /#{comment_text}/).present?}
      assert @browser.div(:class => "media-body", :text => /#{comment_text}/).present? 
      @browser.div(:class => /ember-view depth-1/).span(:class => "dropdown-toggle").when_present.click
      @browser.link(:text => /Flag as inappropriate/).when_present.click

      caret = @browser.div(:class => /topbar-nav/).span(:class => "caret")
      @browser.wait_until($t){
      caret.present?
    }
    caret.click
     @browser.link(:href => "/admin/#{networkslug}").when_present.click
     @browser.wait_until($t){ @browser.wait_until { @browser.div(:class => "sidebar-nav").exists? } }
    
     @browser.link(:href => "/admin/#{networkslug}/moderation").when_present.click
     moderation_link = @browser.link(:href => "/admin/#{$networkslug}/moderation?setPage=1&tabName=flaggedPosts")
     @browser.wait_until($t) { moderation_link.present? }
     assert moderation_link.present?
     moderation_link.click
     flagged_post = @browser.div(:class => "flagged-posts").link(:text => /#{comment_text}/)
     @browser.wait_until($t) { flagged_post.present? }
     assert flagged_post.present?
     signout
    end

    if(role == "topicadmin")
     @browser.link(:href => "/admin/#{networkslug}/permission").when_present.click
     @browser.wait_until($t) { @browser.link(:href => "#topic-administrators").present? }
     assert @browser.link(:href => "#topic-administrators").present?
     assert @browser.link(:href => "#topic-moderators").present?
     signout
    end
  end

  def set_google_ads_params(networkslug, client_id, banner_slot_id, side_slot_id)
    admin_check(networkslug)
    @browser.link(:href => "/admin/#{networkslug}").when_present.click
    @browser.wait_until($t) { @browser.div(:class => "navbar-collapse collapse sidebar-navbar-collapse").exists? }
    @browser.link(:href => "/admin/#{networkslug}/embedding").when_present.click
    @browser.wait_until($t){ @browser.div(:text => /Advertising/).present? }
    container = @browser.div(:class => "embedding-containner")
    container.text_field(:class => "ember-view ember-text-field", :index => 0).set client_id
    container.text_field(:class => "ember-view ember-text-field", :index => 1).set banner_slot_id
    container.text_field(:class => "ember-view ember-text-field", :index => 2).set side_slot_id
    @browser.button(:class => "btn btn-primary", :type => "submit").when_present.click
    @browser.wait_until($t){ @browser.alert.exists? }
    assert_equal "setting saved!", @browser.alert.text
    @browser.alert.ok
    @browser.wait_until($t){ @browser.div(:text => /Embedding Content ID/).present? }
  end

  def enable_profanity_blocker (networkslug, enable)
    caret = @browser.div(:class => /topbar-nav/).span(:class => "caret")
    @browser.wait_until($t){ caret.present? }
    caret.click
    @browser.div(:class=>"dropdown open").link(:href => "/admin/#{networkslug}").when_present.click
    @browser.wait_until($t) { @browser.div(:class => "sidebar-nav").present? }
    @browser.link(:href => /moderation/).when_present.click
    @browser.link(:href => /profanityBlocker/).when_present.click
    import = @browser.file_field(:class => /profanity-import-input/)
    if enable
      if @browser.button(:id => "profanity_enable_btn").present?
        @browser.button(:id => "profanity_enable_btn").when_present.click
      end 
      @browser.wait_until($t) {import.exists?}
      import.set("#{$rootdir}/seeds/development/files/blocklist.csv")
      dialog = @browser.div(:id => "profanity-upload-success")
      @browser.wait_until($t) { dialog.present? }
      dialog.button.when_present.click
    else
      if @browser.button(:id => "profanity_disable_btn").present?
        @browser.button(:id => "profanity_disable_btn").when_present.click 
      end
      @browser.wait_until($t) {!import.exists?}
    end
  end
end

