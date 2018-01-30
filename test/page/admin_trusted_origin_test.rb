require 'watir_test'
require 'pages/community/admin_trusted_origin'

class AdminTrustedOriginTest < WatirTest

  def setup
    super
    @admin_trusted_origin_page = Pages::Community::AdminTrustedOrigin.new(@config)
    @current_page = @admin_trusted_origin_page
    puts "[[[ #{name} ::: #{user_for_test} ]]]" if @config.verbose?
    @browser = @config.browser
    @admin_trusted_origin_page.start!(user_for_test)
  end

  def teardown
    super
  end

  user :network_admin

  p1

  def test_00010_test_create_edit_and_delete_trusted_origin

    name = "trusted_origin_#{get_timestamp}"
    url = "https://www.google.com"

    @admin_trusted_origin_page.create_trusted_origin(name,url)
    @browser.wait_until { @admin_trusted_origin_page.trusted_origin_list.trusted_origin_exists?(name) }

    # view the newly created origin
    @admin_trusted_origin_page.trusted_origin_list.view_trusted_origin(name)
    assert_equal @admin_trusted_origin_page.name_input.when_present.value, name
    assert_equal @admin_trusted_origin_page.origin_input.when_present.value, url

    # click 'Back' btn to go to origin list page
    @admin_trusted_origin_page.back_link.when_present.click
    @browser.wait_until { @admin_trusted_origin_page.trusted_origin_list.trusted_origin_exists?(name) }

    edit_name = "#{name}-edited"
    edit_url = "https://jam4.sapjam.com"
    # edit the newly created origin
    @admin_trusted_origin_page.edit_trusted_origin(edit_name,edit_url,name,url)
    @browser.wait_until { @admin_trusted_origin_page.trusted_origin_list.trusted_origin_exists?(edit_name) }

    # delete the origin
    @admin_trusted_origin_page.delete_trusted_origin(edit_name)
    assert !@admin_trusted_origin_page.trusted_origin_list.trusted_origin_exists?(edit_name)
  end
end