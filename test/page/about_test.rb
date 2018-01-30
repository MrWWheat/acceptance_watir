require 'watir_test'
require 'pages/community/about'
require 'pages/community/home'

class AboutTest < WatirTest

  def setup
    super
    @about_page = Pages::Community::About.new(@config)
    @home_page = Pages::Community::Home.new(@config)
    @layout_page = Pages::Community::Layout.new(@config)
    # assigning @current_page helps error reporting
    #  give good contextual data
    @current_page = @about_page
    puts "[[[ #{name} ::: #{user_for_test} ]]]" if @config.verbose?
    @browser = @config.browser
    @about_page.start!(user_for_test)
    @browser.goto @about_page.about_url
    sleep 1
  end

  def teardown
    super
  end

  user :network_admin
  p1
  def test_00010_aboutpage
    expected_title = @c.network_name + " About"

    assert_all_keys({
      :body => @browser.body.present?,
      # :widget => @about_page.about_widget.present?,
      :banner => @about_page.about_banner.present? || @about_page.about_inverted_banner.present?,
      :footer => @home_page.footer.present?,
      :title_match => (@browser.title.downcase == expected_title.downcase),
    }) 
  end

  p2
  def test_00040_aboutpage_network_breadcrumb
    assert @about_page.breadcrumb_link.present?, "Did not find breadcrumb link"
    @about_page.breadcrumb_link.click
    @browser.wait_until { @about_page.topic_page.present? }
    assert @about_page.topic_page.present?
  end

  user :anonymous
  p1
  def test_00070_about_page_edit_banner_button_for_anon
    assert !@about_page.about_edit.present?
  end

  user :regular_user3
  def test_00080_about_page_edit_banner_button_for_regular
    assert !@about_page.about_edit.present?
  end
end