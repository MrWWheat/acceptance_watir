require 'watir_test'
require 'pages/community/admin_widget_theme'

class AdminHomeTest < WatirTest

  def setup
    super
    @admin_widget_theme_page = Pages::Community::AdminWidgetTheme.new(@config)
    # assigning @current_page helps error reporting
    #  give good contextual data
    @current_page = @admin_widget_theme_page
    puts "[[[ #{name} ::: #{user_for_test} ]]]" if @config.verbose?
    @browser = @config.browser
    @admin_widget_theme_page.start!(user_for_test)
  end

  def teardown
    super
  end

  user :network_admin

  p1
  def test_00010_check_widget_theme
    assert @admin_widget_theme_page.widget_theme_edit_btn.present?
  end
  

  def test_00020_change_theme
    current_title_font_size = @admin_widget_theme_page.widget_sample_preview_title.when_present.style("font-size")
    current_content_font_size = @admin_widget_theme_page.widget_sample_preview_content.when_present.style("font-size")

    @admin_widget_theme_page.change_theme("16px")

    new_title_font_size = @admin_widget_theme_page.widget_sample_preview_title.when_present.style("font-size")
    new_content_font_size = @admin_widget_theme_page.widget_sample_preview_content.when_present.style("font-size")
    
    assert_match "16px", new_title_font_size 
    assert_match "16px", new_content_font_size
  end

  def test_00030_reset_theme
    @admin_widget_theme_page.reset_theme

    new_title_font_size = @admin_widget_theme_page.widget_sample_preview_title.when_present.style("font-size")
    new_content_font_size = @admin_widget_theme_page.widget_sample_preview_content.when_present.style("font-size")

    assert_match "12px", new_title_font_size
    assert_match "12px", new_content_font_size
  end
end