require 'watir_test'
require 'pages/community/admin'
require 'pages/community/layout'
require 'pages/community/admin_console_setup'

#Note!!!
# The case to change community name will be conflict with some cases:
# e.g. test_00011_topicpage, test_00010_aboutpage
# So, please run these cases in a separate environment.

class AdminConsoleSetupTest < WatirTest

  def setup
    super
    @admin_console_setup_page = Pages::Community::AdminConsoleSetup.new(@config)
    @home_page = Pages::Community::Home.new(@config)
    @login_page = Pages::Community::Login.new(@config)

    # assigning @current_page helps error reporting
    #  give good contextual data
    @current_page = @admin_console_setup_page
    puts "[[[ #{name} ::: #{user_for_test} ]]]" if @config.verbose?
    @browser = @config.browser
    @admin_console_setup_page.start!(user_for_test)
  end

  def teardown
    super
  end

  p1

  user :network_admin
  def test_00010_change_network_name
    origin_name = @admin_console_setup_page.community_name_input.value
    change_name = "community_name_#{get_timestamp}"
    @admin_console_setup_page.change_community_name change_name
    #community nav does not support this
    #assert @admin_console_setup_page.community_name_span.text.downcase.include? change_name.downcase
    assert @admin_console_setup_page.community_name_input.value == change_name
    @admin_console_setup_page.change_community_name origin_name
  end

  def test_00020_change_language
    origin_language = "en"
    change_language = "zh-CN"
    @admin_console_setup_page.change_community_language change_language
    assert @admin_console_setup_page.save_btn.text.include? "保存"
    @admin_console_setup_page.change_community_language origin_language
    assert @admin_console_setup_page.save_btn.text.include? "Save"
  end

end