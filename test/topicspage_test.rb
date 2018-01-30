require File.expand_path(File.dirname(__FILE__) + "/excelsior_watir_test.rb")
require File.expand_path(File.dirname(__FILE__) + "/../lib/test_helper.rb")
require File.expand_path(File.dirname(__FILE__) + "/../lib/page_objects/community_home_page.rb")
require File.expand_path(File.dirname(__FILE__) + "/../lib/page_objects/community_topics_page.rb")
require File.expand_path(File.dirname(__FILE__) + "/../lib/watir_lib.rb")
require File.expand_path(File.dirname(__FILE__) + "/../lib/page_objects/community_topics_page.rb")


class TopicsPageTest < ExcelsiorWatirTest
  include WatirLib

  def setup
    super
    @topicspage = CommunityTopicsPage.new(@browser)    
    @search_page = CommunitySearchPage.any_page_search_bar(@browser) 
  end

  #============ ANON & REGULAR USER TESTS ==========================#
  #=================================================================#

  #======== topicspage, topnav tests ============#
  def test_00010_topicspage_loads
    @topicspage.goto_topics_page
  	assert @browser.body.present?
    assert @topicspage.topics_grid_view.present?
  end

  def test_00020_topicspage_network_breadcrumb
    if !@topicspage.topics_grid_view.present?
      @topicspage.goto_topics_page
    end
    @topicspage.check_breadcrumb_link
    @homepage = CommunityHomePage.new(@browser)
    assert @homepage.home.present?
  end

  def test_00030_topicspage_search_bar_present
    if !@topicspage.topics_grid_view.present?
      @topicspage.goto_topics_page
    end
    @topicspage.check_page_search_bar
    assert @topicspage.search_bar.present?
  end

  def test_00040_topicspage_search_works
    if !@topicspage.topics_grid_view.present?
      @topicspage.goto_topics_page
    end    
    @search_page.search("test")    
    assert @search_page.results_keyword.text.include?("test"), 'keyword should be present in count results found for: "test"'
  end

  def test_00050_topic_sort_by_name
    if !@topicspage.topics_grid_view.present?
      @topicspage.goto_topics_page
    end
    @browser.wait_until($t) { @topicspage.topic_tile.present? }
    topic_sort_by_name
  end

  def test_00060_check_topics_list_view
    @topicspage.goto_topics_list_view
    assert @topicspage.topics_list_view_link_selected.present?
    assert @topicspage.topic_listed_row.present? 
  end

  def test_00070_go_to_topic_detail_from_grid_view
    @topicspage.goto_topics_page
    @topicspage.goto_topic_detail_page_from_topictile_on_grid_view
    @topicdetailpage = CommunityTopicDetailPage.new(@browser)
    assert @topicdetailpage.topicdetail.present?
  end

  def test_00080_go_to_topic_detail_from_list_view
    @topicspage.goto_topics_list_view
    @topicspage.goto_topic_detail_page_from_topicname_on_list_view
    @topicdetailpage = CommunityTopicDetailPage.new(@browser)
    assert @topicdetailpage.topicdetail.present?
  end

  def test_00090_no_activated_topics_filter_for_anon_users
    @topicspage.goto_topics_page
    @loginpage = CommunityLoginPage.new(@browser)
    if @loginpage.username_dropdown.present?
      @loginpage.signout 
    end
    assert_equal false, @topicspage.activated_topics_filter_button.present?
  end

  def test_00100_topicspage_follow_or_unfollow_topic_for_anon_user
    @topicspage.goto_topics_page
    @topicspage.policy_warning
    @loginpage = CommunityLoginPage.new(@browser)
    if @loginpage.username_dropdown.present?
      @loginpage.signout 
    end
    follow_unfollow_button = @topicspage.all_topic_follow_unfollow_buttons[0]
    assert_includes [CommunityTopicsPage::FOLLOWING_TEXT, CommunityTopicsPage::UNFOLLOW_TEXT, CommunityTopicsPage::FOLLOW_TEXT], follow_unfollow_button.text
    follow_unfollow_button.click
    #@topicdetailpage = CommunityTopicDetailPage.new(@browser)
    @loginpage = CommunityLoginPage.new(@browser)
    @browser.wait_until($t) { @loginpage.signin_page.present? }
    assert @loginpage.signin_page.present?
  end

  def test_00200_no_new_topic_create_button_for_anon_user
    @topicspage.goto_topics_page
    @topicspage.policy_warning
    @loginpage = CommunityLoginPage.new(@browser)
    if @loginpage.username_dropdown.present?
      @loginpage.signout 
    end
    assert_equal false, @topicspage.topic_create_link.present?
  end

  def test_00300_no_activated_topics_filter_for_reg_users
    @topicspage.main_landing("regis3", "logged")
    @topicspage.goto_topics_page
    assert_equal false, @topicspage.activated_topics_filter_button.present?
  end

  def test_00400_no_new_topic_create_button_for_reg_user
    @topicspage.main_landing("regis3", "logged")
    @topicspage.goto_topics_page
    assert_equal false, @topicspage.topic_create_link.present?
  end

  def test_00500_topicspage_show_more_not_present
    @topicspage.goto_topics_page
    if @topicspage.all_topic_tiles.length < CommunityTopicsPage::NUM_TOPICS_ON_PAGE
      assert_equal false, @topicspage.show_more_button.present?
    end        
  end

  def test_00600_topicspage_show_more_works
    @topicspage.goto_topics_page
    @topicspage.policy_warning    
    if @topicspage.show_more_button.present?
      num_existing_topics = @topicspage.all_topic_tiles.length
      #assert_operator 5, :>=, 4
      assert_equal CommunityTopicsPage::NUM_TOPICS_ON_PAGE, num_existing_topics, "should have 12 topics at least"
      # assert_operator num_existing_topics, :>, 0, "should be more than one topic on page"      
      @topicspage.show_more_button.click
      @browser.wait_until {
        @topicspage.all_topic_tiles.length > num_existing_topics
      }
      num_total_topics = @topicspage.all_topic_tiles.length
      assert_operator num_total_topics, :>, num_existing_topics, "total topics should be more than existing topics or show more button should not be present"
    end    
  end


   #========== ADMIN USER TOPICSPAGE TESTS ===================#
  #===========================================================#


  def xtest_00700_topicspage_featured_topics_in_grid_view
    @topicspage.main_landing("admin", "logged")  
    if not @topicspage.topics_grid_view.present?
      @topicspage.goto_topics_page
    end
    @topicspage.goto_topic_detail_page_from_topictile_on_grid_view    
    featured_topic_title = @topicspage.topicname.text
    @topicspage.click_topic_feature
    @topicspage.goto_topics_page
    @topicspage.click_featured_topics_button
    @topicspage.check_featured_topics_in_grid_view
    assert @topicspage.featured_topic_icon_grid_view.present?
    assert_equal featured_topic_title, @topicspage.topic_tile_link.text
    # ensure all topics that are featured have the featured icon
    assert_equal @topicspage.all_topic_tiles.length, @topicspage.all_featured_topic_icons.length, "All topics in Featured filter are not featured"
  end

  def xtest_00800_topicspage_featured_topics_in_list_view
    @topicspage.main_landing("admin", "logged")  
    @topicspage.goto_topics_list_view
    @topicspage.goto_topic_detail_page_from_topicname_on_list_view
    featured_topic_title = @topicspage.topicname.text
    @topicspage.click_topic_feature
    @topicspage.goto_topics_list_view
    @topicspage.click_featured_topics_button
    @topicspage.check_featured_topics_in_list_view
    assert @topicspage.featured_topic_icon_list_view.present?

    # title could be truncated and contain dots...        
    list_view_featured_topic_title = @topicspage.list_view_topic_title.text.gsub("...", "")    
    assert_match /#{list_view_featured_topic_title}/, featured_topic_title
    assert_equal @topicspage.all_topic_listed_rows.length, @topicspage.all_featured_topic_icons.length, "All topics in Featured filter are not featured"
  end


  def test_00900_new_topic_create_button_for_admin_user
    @topicspage.main_landing("admin", "logged")
    @topicspage.goto_topics_page
    assert @topicspage.topic_create_link.present? 
  end

  def test_01000_create_new_engagement_topic
    @topicspage.main_landing("admin", "logged")
    @topicspage.goto_topics_page
    @topicspage.click_new_topic_create_link
    @topicdetailpage = CommunityTopicDetailPage.new(@browser)
    assert @topicdetailpage.new_topic_title.present?
    @topicspage.set_new_topic_details("engagement", false)
    @topicspage.image_set("filetile")
    @topicspage.topic_create_steps_after_image_set("filetile")
    @browser.wait_until($t) { @topicspage.image_upload_link.present? }
    
    @topicspage.image_set("filebanner")
    @topicspage.topic_create_steps_after_image_set("filebanner")
    # assertions for topic name and descrp
  end

  def test_01100_topicspage_follow_topic_reg_user    
    @topicspage.main_landing("admin", "logged")
    @topicspage.goto_topics_page
    
    follow_button = @topicspage.follow_topic     #save the return value
    assert_includes [CommunityTopicsPage::FOLLOWING_TEXT, CommunityTopicsPage::UNFOLLOW_TEXT], follow_button.text
    @topicspage.goto_topic_detail_page_from_topictile_on_grid_view  
    assert @topicspage.topic_detail_page_unfollow_button.present?
    # @topicdetailpage = CommunityTopicDetailPage.new(@browser)
    # assert_equal true, @topicdetailpage.check_topicdetail_follow_topic_button
  end

  def test_01200_topicspage_unfollow_topic    
    @topicspage.main_landing("admin", "logged")
    @topicspage.goto_topics_page

    unfollow_button = @topicspage.unfollow_topic    
    assert_includes [CommunityTopicsPage::FOLLOW_TEXT], unfollow_button.text
    @topicspage.goto_topic_detail_page_from_topictile_on_grid_view  
    assert @topicspage.topic_detail_page_follow_button.present?
  end

  def test_01300_topicspage_activated_topics
    @topicspage.main_landing("admin", "logged")
    @topicspage.goto_topics_page
    @topicspage.topics_filter_by_activated_button
    topic_title = @topicspage.goto_topic_detail_page_from_topictile_on_grid_view

    @topicdetailpage = CommunityTopicDetailPage.new(@browser)
    assert @topicdetailpage.topic_deactivate_button.present?

    #Disabling following code as deactivating any random topic might cause intruption for other parallely running tests for the same topic
    
    # @topicdetailpage.deactivate_a_topic
    # assert @topicdetailpage.topic_activate_button.present?
    # @topicspage.goto_topics_page
    # @topicspage.topics_filter_by_activated_button
    
    # # get all topic titles on the page
    # # assert the topic just deactivated is not present in the list

    # @topicspage.all_topic_tiles.each do |topic|      
    #   assert topic.div(:class => "topic-avatar").text != topic_title
    # end
  end

end