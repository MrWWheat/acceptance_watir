require File.expand_path(File.dirname(__FILE__) + "/excelsior_watir_test.rb")
require File.expand_path(File.dirname(__FILE__) + "/../lib/test_helper.rb")
require File.expand_path(File.dirname(__FILE__) + "/../lib/page_objects/page_object.rb")
require File.expand_path(File.dirname(__FILE__) + "/../lib/watir_lib.rb")

class AboutPageTest < ExcelsiorWatirTest
  include WatirLib
  def setup
    super
    @aboutpage = CommunityAboutPage.new(@browser)
  end

  #============ ANON & REGULAR USER TESTS ==========================#
  #=================================================================#

  #======== aboutpage, topnav, banner, text widget tests ============#
  def test_p1_00010_aboutpage
    @aboutpage.goto_about_page
  	assert @browser.body.present?
    assert @aboutpage.about_widget.present?
    @abouturl = @browser.url
    @aboutpage.newline
  end

  def test_p1_00020_aboutpage_banner
    if !@aboutpage.about_widget.present?
      @aboutpage.goto_about_page
    end
    @aboutpage.check_about_banner
    assert @aboutpage.about_banner.present? || @aboutpage.about_inverted_banner.present? 
    @aboutpage.newline
  end

  def test_p1_00030_aboutpage_text_widget
    if !@aboutpage.about_widget.present?
      @aboutpage.goto_about_page
    end
    @aboutpage.check_about_page_text_widget
    assert @aboutpage.about_text_widget.present?
    @aboutpage.newline
  end

  def test_00040_aboutpage_network_breadcrumb
    if !@aboutpage.about_widget.present?
      @aboutpage.goto_about_page
    end
    @aboutpage.check_breadcrumb_link
    assert @aboutpage.topic_page.present?
    @aboutpage.newline
  end

  def test_00050_aboutpage_footer
    if !@aboutpage.about_widget.present?
      @aboutpage.goto_about_page
    end
    @aboutpage.check_about_page_footer
    assert @aboutpage.footer.present?
    @aboutpage.newline
  end

  def test_00060_about_page_browser_title
    if !@aboutpage.about_widget.present?
      @aboutpage.goto_about_page
    end
    @aboutpage.check_browser_tab_title
    @aboutpage.newline
  end

  def test_p1_00070_about_page_edit_banner_button_for_anon
    if !@aboutpage.about_widget.present?
      @aboutpage.goto_about_page
    end
    @loginpage = CommunityLoginPage.new(@browser)
    if @loginpage.username.present?
     @aboutpage.signout
    end
    assert @aboutpage.about_edit.present? != true
    @aboutpage.newline
  end

  def test_p1_00080_about_page_edit_banner_button_for_regular
    @aboutpage.about_login("regis3", "logged")
    if !@aboutpage.about_widget.present?
      @aboutpage.goto_about_page
    end
    assert @aboutpage.about_edit.present? != true
    @aboutpage.newline
  end

  #========== ADMIN USER ABOUTPAGE TESTS ===================#
  #===========================================================#


  def test_00090_about_page_edit_banner_button_for_admin
    @aboutpage.about_login("regular", "logged")
    if !@aboutpage.about_widget.present?
      @aboutpage.goto_about_page
    end
    assert @aboutpage.about_edit.present?
    @aboutpage.newline
  end

  def test_p1_00100_about_banner_change
    @aboutpage.about_login("regular", "logged")  
    if !@aboutpage.about_widget.present?
      @aboutpage.goto_about_page
    end
    @aboutpage.check_about_edit_button
    if (@aboutpage.about_edit.present? != true)
     @aboutpage.admin_check
    end
    @aboutpage.edit_about_banner 
    @aboutpage.newline
  end

  def test_p1_00110_about_text_widget_change
    @aboutpage.about_login("regular", "logged")  
    if !@aboutpage.about_widget.present?
      @aboutpage.goto_about_page
    end
    @aboutpage.check_about_edit_button
    if (@aboutpage.about_edit.present? != true)
     @aboutpage.admin_check
    end
    @aboutpage.edit_text_widget
    @aboutpage.newline
  end


end