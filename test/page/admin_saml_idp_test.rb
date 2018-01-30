require 'watir_test'
require 'pages/community/admin_saml_idp'

class AdminSamlIdpTest < WatirTest

  def setup
    super
    @admin_saml_idp_page = Pages::Community::AdminSamlIdp.new(@config)
    @current_page = @admin_saml_idp_page
    puts "[[[ #{name} ::: #{user_for_test} ]]]" if @config.verbose?
    @browser = @config.browser
    @admin_saml_idp_page.start!(user_for_test)
  end

  def teardown
    super
  end

  user :network_admin

  p1

  def test_00010_test_create_and_delete_saml_idp_with_generating_keys
    @admin_saml_idp_page.navigate_to_saml_tab
    assert @admin_saml_idp_page.saml_idp_settings_page.present?

    idp_issuer = "#{@config.slug}-for-watir-test-1"

    @admin_saml_idp_page.create_new_idp(idp_issuer)

    certificate_key = @admin_saml_idp_page.certificate_key_input.value
    private_key = @admin_saml_idp_page.private_key_input.value

    # click 'Back to all IDPs' btn to go to IDP list page
    @admin_saml_idp_page.view_back_to_list_btn.when_present.click
    @browser.wait_until { @admin_saml_idp_page.idp_list.idp_exists?(idp_issuer) }

    # view the newly created idp
    @admin_saml_idp_page.idp_list.view_idp(idp_issuer)

    assert_equal @admin_saml_idp_page.private_key_input.when_present.value, private_key
    assert_equal @admin_saml_idp_page.certificate_key_input.when_present.value, certificate_key

    # click 'Back to all IDPs' btn to go to IDP list page
    @admin_saml_idp_page.view_back_to_list_btn.when_present.click
    @browser.wait_until { @admin_saml_idp_page.idp_list.idp_exists?(idp_issuer) }

    # delete the idp
    @admin_saml_idp_page.delete_idp(idp_issuer)
    assert !@admin_saml_idp_page.idp_list.idp_exists?(idp_issuer)
  end

  def test_00020_test_create_and_delete_saml_idp_with_importing_keys
    @admin_saml_idp_page.navigate_to_saml_tab
    assert @admin_saml_idp_page.saml_idp_settings_page.present?

    idp_issuer = "#{@config.slug}-for-watir-test-2"

    @admin_saml_idp_page.create_new_idp(idp_issuer, :import)

    certificate_key = @admin_saml_idp_page.certificate_key_input.value
    private_key = @admin_saml_idp_page.private_key_input.value

    # click 'Back to all IDPs' btn to go to IDP list page
    @admin_saml_idp_page.view_back_to_list_btn.when_present.click
    @browser.wait_until { @admin_saml_idp_page.idp_list.idp_exists?(idp_issuer) }

    # view the newly created idp
    @admin_saml_idp_page.idp_list.view_idp(idp_issuer)

    assert_equal @admin_saml_idp_page.private_key_input.when_present.value, private_key
    assert_equal @admin_saml_idp_page.certificate_key_input.when_present.value, certificate_key
    
    # click 'Back to all IDPs' btn to go to IDP list page
    @admin_saml_idp_page.view_back_to_list_btn.when_present.click
    @browser.wait_until { @admin_saml_idp_page.idp_list.idp_exists?(idp_issuer) }

    # delete the idp
    @admin_saml_idp_page.delete_idp(idp_issuer)
    assert !@admin_saml_idp_page.idp_list.idp_exists?(idp_issuer)
  end
end