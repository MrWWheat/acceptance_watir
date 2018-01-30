require 'watir_test'
require 'pages/community/admin_ecom_and_oauth'

class AdminEcomAndOauthTest < WatirTest

  def setup
    super
    @admin_ecom_and_oauth_page = Pages::Community::AdminEcomAndOauth.new(@config)
    # assigning @current_page helps error reporting
    #  give good contextual data
    @current_page = @admin_ecom_and_oauth_page
    puts "[[[ #{name} ::: #{user_for_test} ]]]" if @config.verbose?
    @browser = @config.browser
    @admin_ecom_and_oauth_page.start!(user_for_test)
  end

  def teardown
    super
  end

  user :network_admin

  p1
  
  def test_00010_check_hybris_option
    # navigate to Admin->E-commerce Integration page
    @admin_ecom_and_oauth_page.navigate_to_ecomm_int

    # verify the Setting tab is present by default
    assert @admin_ecom_and_oauth_page.ecomm_int_settings_page.present?

    # verify the "All Products" radio option is checked by default
    assert !@admin_ecom_and_oauth_page.ecomm_int_settings_active_prod_radio.attribute_value("checked")
    assert @admin_ecom_and_oauth_page.ecomm_int_settings_all_prod_radio.attribute_value("checked")
  end

  def test_00020_check_hybris_config_tab
    # navigate to Admin->E-commerce Integration page
    @admin_ecom_and_oauth_page.navigate_to_ecomm_int

    # switch to Configuration tab
    @admin_ecom_and_oauth_page.switch_to_ecomm_int_tab(:config)

    # verify the Configuration tab is present
    assert @admin_ecom_and_oauth_page.ecomm_int_config_page.present?
    assert @admin_ecom_and_oauth_page.ecomm_int_config_save_button.present?
    assert @admin_ecom_and_oauth_page.ecomm_int_config_sync_button.present?
  end

  def test_00021_check_sync_successful
    @admin_ecom_and_oauth_page.navigate_to_ecomm_int
    @admin_ecom_and_oauth_page.switch_to_ecomm_int_tab(:config)
    @browser.wait_until { @admin_ecom_and_oauth_page.ecomm_int_config_sync_button.present?}
    @admin_ecom_and_oauth_page.ecomm_int_config_sync_button.when_present.click
    @browser.wait_until { @admin_ecom_and_oauth_page.toast_success_message.present? }
    @browser.wait_until { !@admin_ecom_and_oauth_page.toast_message.present? }
    @browser.execute_script("window.scrollBy(0,-400)")
    @admin_ecom_and_oauth_page.switch_to_ecomm_int_tab(:history)
    @browser.wait_until { @admin_ecom_and_oauth_page.ecomm_int_history_rows[2].text.include?("queued") || \
           @admin_ecom_and_oauth_page.ecomm_int_history_rows[2].text.include?("working") }
    for i in 0..5
      sleep(60)
      @browser.refresh
      @admin_ecom_and_oauth_page.switch_to_ecomm_int_tab(:history)
      if @admin_ecom_and_oauth_page.ecomm_int_history_rows[2].text.include?"failed"
        puts @admin_ecom_and_oauth_page.ecomm_int_history_rows[2].text.gsub("\n",' ')
        break
      elsif @admin_ecom_and_oauth_page.ecomm_int_history_rows[2].text.include?"working"
        puts @admin_ecom_and_oauth_page.ecomm_int_history_rows[2].text.gsub("\n",' ')
      elsif @admin_ecom_and_oauth_page.ecomm_int_history_rows[2].text.include?"completed"
        puts @admin_ecom_and_oauth_page.ecomm_int_history_rows[2].text.gsub("\n",' ')
        break
      end
    end
    assert @admin_ecom_and_oauth_page.ecomm_int_history_rows[2].text.include?"completed"
  end


  p2
  def test_00030_check_hybris_history_tab
    # navigate to Admin->E-commerce Integration page
    @admin_ecom_and_oauth_page.navigate_to_ecomm_int

    # switch to History tab
    @admin_ecom_and_oauth_page.switch_to_ecomm_int_tab(:history)

    # verify the History tab is present
    assert @admin_ecom_and_oauth_page.ecomm_int_history_page.present?
    assert @admin_ecom_and_oauth_page.ecomm_int_history_resync_button.present?
  end

  p1
  def test_00040_check_oauth_config_option
    # navigate to Admin->OAuth Configuration page
    @admin_ecom_and_oauth_page.navigate_to_oauth_config

    # verify OAuth page is present including New Application button
    assert @admin_ecom_and_oauth_page.oauth_page.present?
    assert @admin_ecom_and_oauth_page.oauth_page_new_app_button.present?
  end

  def test_00050_oauth_new_app_cancel_button 
    # navigate to Admin->OAuth Configuration page
    @admin_ecom_and_oauth_page.navigate_to_oauth_config

    # click New Application dialog
    @admin_ecom_and_oauth_page.oauth_page_new_app_button.when_present.click
    @browser.wait_until($t) { @admin_ecom_and_oauth_page.oauth_new_app_dialog.present? }

    assert @admin_ecom_and_oauth_page.oauth_new_app_dialog.present?

    # click Cancel button in New Application dialog
    @admin_ecom_and_oauth_page.oauth_new_app_cancel_button.when_present.click  
    @browser.wait_until($t) { !@admin_ecom_and_oauth_page.oauth_new_app_dialog.present? }

    assert !@admin_ecom_and_oauth_page.oauth_new_app_dialog.present?
  end

  def test_00060_check_oauth_new_app_field_and_button
    # navigate to Admin->OAuth Configuration page
    @admin_ecom_and_oauth_page.navigate_to_oauth_config

    # click New Application button
    @admin_ecom_and_oauth_page.oauth_page_new_app_button.when_present.click

    # verify Name, Callback field, Create, Cancel button are present in the New Application dialog
    @browser.wait_until($t) { @admin_ecom_and_oauth_page.oauth_new_app_name_field.present? }
    assert @admin_ecom_and_oauth_page.oauth_new_app_name_field.present?
    @browser.wait_until($t) { @admin_ecom_and_oauth_page.oauth_new_app_callback_field.present? }
    assert @admin_ecom_and_oauth_page.oauth_new_app_callback_field.present?
    @browser.wait_until($t) { @admin_ecom_and_oauth_page.oauth_new_app_create_button.present? }
    assert @admin_ecom_and_oauth_page.oauth_new_app_create_button.present?
    @browser.wait_until($t) { @admin_ecom_and_oauth_page.oauth_new_app_cancel_button.present? }
    assert @admin_ecom_and_oauth_page.oauth_new_app_cancel_button.present?
  end

end