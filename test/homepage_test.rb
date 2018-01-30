require File.expand_path(File.dirname(__FILE__) + "/excelsior_watir_test.rb")
require File.expand_path(File.dirname(__FILE__) + "/../lib/test_helper.rb")
require File.expand_path(File.dirname(__FILE__) + "/../lib/page_objects/community_home_page.rb")
require File.expand_path(File.dirname(__FILE__) + "/../lib/watir_lib.rb")

class HomePageTest < ExcelsiorWatirTest
  include WatirLib
  def setup
    super
    @homepage = CommunityHomePage.new(@browser)
  end

  #============ ANON & REGULAR USER TESTS ==========================#
  #=================================================================#

  #======== homepage, topnav and banner tests ============#
  def test_p1_00010_homepage
    @homepage.goto_homepage
  	assert @browser.body.present?
    @profilepage = CommunityProfilePage.new(@browser)
    assert @profilepage.topnav.present?
    @homepage.newline
  end

  def test_p1_00020_homepage_banner
    if !@homepage.home.present?
      @homepage.goto_homepage
    end
    @homepage.check_homepage_banner
    assert @homepage.homebanner.present? || @homepage.home_inverted_banner.present?
    @homepage.newline
  end

  def test_00021_home_page_browser_title
    if !@homepage.home.present?
      @homepage.goto_homepage
    end
    @homepage.check_browser_tab_title
    @homepage.newline
  end

  #============ homepage search tests ==============#
  def test_p1_00030_homepage_search_bar
    if !@homepage.home.present?
      @homepage.goto_homepage
    end
    @homepage.check_homepage_search_bar
    assert @homepage.search_bar.present?
    @homepage.newline
  end

  def test_p1_00031_homepage_search
    if !@homepage.home.present?
      @homepage.goto_homepage
    end
    @homepage.search_from_homepage
    assert (@homepage.search_result_heading.text.include? "watir")|| (@homepage.search_result_heading.text.include? "Watir")
    @homepage.newline
  end

  #============= homepage featured topic widget tests ==============#
  def test_p1_00040_homepage_topic_widget
    if !@homepage.home.present?
      @homepage.goto_homepage
    end
    @homepage.check_featured_topic_widget
    assert @homepage.home_featured_topic.present?
    @homepage.newline
  end

  def test_p1_00050_homepage_topic_widget_viewall
    if !@homepage.home.present?
      @homepage.goto_homepage
    end
    if @browser.div(:id => "policy-warning").present?
        policy_warning
      end
    @homepage.goto_featured_topic_viewall
    assert @homepage.topic_page.present?
    @homepage.newline
  end

  def test_p1_00051_homepage_topic_detail
    if !@homepage.home.present?
      @homepage.goto_homepage
    end
    @homepage.check_featured_topic_widget
    @homepage.check_featured_topic_widget_link
    @homepage.newline
  end

  def test_p1_00052_homepage_topic_widget_post_count
    if !@homepage.home.present?
      @homepage.goto_homepage
    end
    @homepage.check_featured_topic_widget
    @homepage.check_featured_topic_widget_post_count
    assert @homepage.home_featured_topic_post_count.present?
    @homepage.newline
  end

  def test_p1_00053_homepage_topic_widget_last_post
    if !@homepage.home.present?
      @homepage.goto_homepage
    end
    @homepage.check_featured_topic_widget
    @homepage.check_featured_topic_widget_last_post
    assert @homepage.home_featured_topic_last_post.present?
    @homepage.newline
  end

  #================ homepage open questions widget tests ========#
  def test_p1_00060_homepage_open_q_widget
    if !@homepage.home.present?
      @homepage.goto_homepage
    end
    @homepage.check_open_question_widget
    assert @homepage.home_open_question.present?
    assert @homepage.home_open_q_desc.present?
    @homepage.newline
  end

  def test_p1_00061_homepage_open_q_conv_link
    if !@homepage.home.present?
      @homepage.goto_homepage
    end
    @homepage.check_open_question_conv
    conv_title = @homepage.home_open_q_link.text
    @homepage.check_open_q_conv_link
    assert @homepage.conv_detail.text.include? conv_title
    @homepage.newline
  end

  def test_00062_homepage_open_q_widget_q_icon
    if !@homepage.home.present?
      @homepage.goto_homepage
    end
    @homepage.check_open_question_icon
    assert @homepage.question_icon.present?
    @homepage.newline
  end

  def test_p1_00070_homepage_open_q_viewall
    if !@homepage.home.present?
      @homepage.goto_homepage
    end
    @homepage.goto_open_question_viewall
    assert @homepage.search_page.present?
    assert @homepage.search_open_q_widget.text.include? "Unanswered"
    @homepage.newline
  end

  #============ homepage featured discussions widget tests ===========#
  def test_p1_00080_homepage_featured_d_widget
    if !@homepage.home.present?
      @homepage.goto_homepage
    end
    @homepage.check_featured_discussion_widget
    assert @homepage.home_featured_discussion.present?
    @homepage.home_featured_d_desc.present?
    @homepage.newline
  end

  def test_p1_00090_homepage_featured_d_widget_viewall
    if !@homepage.home.present?
      @homepage.goto_homepage
    end
    @homepage.goto_featured_discussion_viewall
    assert @homepage.search_page.present?
    assert @homepage.search_featured_d_widget.text.include? "Featured Discussions"
    if !@browser.div(:class => "media-heading").present?
      assert !@browser.div(:class => "media-heading").present?, "No featured discussion present"
  else
    assert @browser.span(:class => "featured").present? 
    
  end
  @homepage.newline
  end

  #============ homepage featured questions widget tests =============#
  def test_p1_00100_homepage_featured_q_widget
    if !@homepage.home.present?
      @homepage.goto_homepage
    end
    @homepage.check_featured_question_widget
    assert @homepage.home_featured_question.present?
    assert @homepage.home_featured_q_desc.present?
    @homepage.newline
  end

  def test_p1_00110_homepage_featured_q_widget_viewall
    if !@homepage.home.present?
      @homepage.goto_homepage
    end
    @homepage.goto_featured_question_viewall
    assert @homepage.search_page.present?
    assert @homepage.search_featured_q_widget.text.include? "Featured"
    @homepage.newline
  end

  #============ homepage featured blogs widget tests ==============#
  def test_p1_00120_homepage_featured_b_widget
    if !@homepage.home.present?
      @homepage.goto_homepage
    end
    @homepage.check_featured_blog_widget
    assert @homepage.home_featured_blog.present?
    assert @homepage.home_featured_b_desc.present?
    @homepage.newline
  end

  def test_p1_00130_homepage_featured_b_widget_viewall
    if !@homepage.home.present?
      @homepage.goto_homepage
    end
    @homepage.goto_featured_blog_viewall
    assert @homepage.search_page.present?
    assert @homepage.search_featured_b_widget.text.include? "Featured Blogs"
    @homepage.newline
  end

  #============== homepage footer tests ===================#
  def test_p1_00140_homepage_footer
    if !@homepage.home.present?
      @homepage.goto_homepage
    end
    @homepage.check_homepage_footer
    #puts @homepage.footer.text
    assert @homepage.footer.present?
    @homepage.newline
  end

  def test_p1_00141_home_page_edit_banner_button_for_regular
    @homepage.about_login("regis3", "logged")
    if !@homepage.home.present?
      @homepage.goto_homepage
    end
    assert @homepage.home_edit.present? != true
    @homepage.newline
  end

  #========== ADMIN USER HOMEPAGE TESTS ===================#
  #===========================================================#

 def test_p1_00150_homepage_feature_a_disc
    @homepage.network_landing($network)
    @homepage.about_login("regular", "logged")
    @homepage.topic_detail("A Watir Topic")
    @homepage.choose_post_type("discussion")
    @homepage.conversation_detail("discussion")
    conv_title = @homepage.conv_title.text
    if @homepage.conv_feature.present?
      @homepage.unfeature_root_post
    end
    @homepage.feature_root_post
    @homepage.goto_homepage
    @homepage.check_featured_discussion_widget
    @homepage.check_featured_discussion_icon
    @homepage.check_featured_discussion_conv
    assert @homepage.featured_discussion_conv.text.include? conv_title

    @homepage.check_featured_d_conv_link
    @homepage.unfeature_root_post
    @homepage.goto_homepage
    @homepage.check_featured_discussion_widget
    @homepage.check_featured_discussion_conv
    assert (@homepage.featured_discussion_conv.text.include?(conv_title) != true)
    @homepage.newline
  end

  def test_p1_00160_homepage_feature_a_blog
    @homepage.network_landing($network)
    @homepage.about_login("regular", "logged")
    @homepage.topic_detail("A Watir Topic")
    @homepage.choose_post_type("blog")
    @homepage.conversation_detail("blog")
    conv_title = @homepage.conv_title.text
    if @homepage.conv_feature.present?
      @homepage.unfeature_root_post
    end
    @homepage.feature_root_post
    @homepage.goto_homepage
    @homepage.check_featured_blog_widget
    @homepage.check_featured_blog_icon
    @homepage.check_featured_b_conv_link
    assert @homepage.conv_title.text.include? conv_title

    @homepage.unfeature_root_post
    @homepage.goto_homepage
    @homepage.check_featured_blog_widget
    @homepage.check_featured_blog_conv
    assert (@homepage.featured_blog_conv.text.include?(conv_title) != true)
    @homepage.newline
  end

  def test_p1_00170_homepage_feature_topic_and_check_widget
    @homepage.about_login("regular", "logged")
    if !@homepage.home.present?
      @homepage.goto_homepage
    end
    @homepage.check_featured_topic_widget
    topicname = @homepage.home_featured_topic_link.text
    @homepage.check_featured_topic_widget_link
    @homepage.click_topic_feature
    @browser.wait_until($t) { @homepage.topic_unfeature.present? }
    @homepage.goto_homepage
    @homepage.check_featured_topic_widget
    assert @homepage.home_featured_topic_link.text.include? topicname
    @homepage.check_featured_topic_widget_link
    @homepage.click_topic_unfeature
    @homepage.newline
  end

 def test_p1_00180_homepage_banner_change
  @homepage.network_landing($network)
  @homepage.about_login("regular", "logged")  
  if !@homepage.home.present?
      @homepage.goto_homepage
  end
  @homepage.check_edit_button
  if (@homepage.home_edit.present? != true)
    @homepage.admin_check
  end
  @homepage.edit_banner 
  @homepage.newline
 end

 def xtest_p1_00190_homepage_locale_change
  @homepage.network_landing($network)
  @homepage.about_login("regular", "logged")  
  if !@homepage.home.present?
      @homepage.goto_homepage
  end
  @homepage.change_home_locale("de") 
  @homepage.newline
 end

end
