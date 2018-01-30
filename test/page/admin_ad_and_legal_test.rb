require 'watir_test'
require 'pages/community/admin_ad_and_legal'
require 'pages/community/about'
require 'pages/community/home'
require 'pages/community/login'
require 'pages/community/ui_design/design'

class AdminAdAndLegalTest < WatirTest

  def setup
    super
    @admin_ad_and_legal_page = Pages::Community::AdminAdAndLegal.new(@config)
    @about_page = Pages::Community::About.new(@config)
    @home_page = Pages::Community::Home.new(@config)
    @login_page = Pages::Community::Login.new(@config)
    # assigning @current_page helps error reporting
    #  give good contextual data
    @current_page = @admin_ad_and_legal_page
    puts "[[[ #{name} ::: #{user_for_test} ]]]" if @config.verbose?
    @browser = @config.browser
    @admin_ad_and_legal_page.start!(user_for_test)
  end

  def teardown
    super
  end

  user :network_admin
  
  p2
  
  def xtest_00010_check_advertising_option_present
    assert @admin_ad_and_legal_page.advertising_google_button.present?    
  end

  def xtest_00020_check_advertising_option_work
   
   @admin_ad_and_legal_page.google_embed_id.set "ca-pub-8464600688944785"
   @admin_ad_and_legal_page.google_top_banner.set "7717419156"
   @admin_ad_and_legal_page.google_side_banner.set "9115119620"  
   @admin_ad_and_legal_page.google_ad_save.click
   @browser.wait_until { @admin_ad_and_legal_page.google_embed_id.present? }
   assert @admin_ad_and_legal_page.google_embed_id.present?
  end

  def test_00030_check_legal_disclosure_tab
    # All footer settings are moved to Admin->UI Customization.
    # The test should be covered there.
    @admin_ad_and_legal_page.here.click
    design_page = Pages::Community::UICustomizationDesign.new(@config)
    @browser.wait_until { design_page.design_content_panel.present? }
    assert design_page.design_content_panel.present?
  end

  # def test_00040_check_legal_preview_publish
  #     # All footer settings are moved to Admin->UI Customization.
  #     # The test should be covered there.  
  #   # go to legal tab
  #   @admin_ad_and_legal_page.navigate_to_legal
  #   assert @admin_ad_and_legal_page.footer_text.present?

  #   # check Publish and Preview button are present
  #   @browser.wait_until($t) { @admin_ad_and_legal_page.legal_publish_button.present? }
  #   assert @admin_ad_and_legal_page.legal_publish_button.present?
  #   @browser.wait_until($t) { @admin_ad_and_legal_page.legal_preview_button.present? } 
  #   assert @admin_ad_and_legal_page.legal_preview_button.present?  
  # end

  # def test_00050_set_footer
  #     # All footer settings are moved to Admin->UI Customization.
  #     # The test should be covered there.
  #   # go to legal tab
  #   @admin_ad_and_legal_page.navigate_to_legal
  #   assert @admin_ad_and_legal_page.footer_text.present?

  #   # change footer settings and publish
  #   footer_link = "http://go.sap.com/product/content-collaboration/community-powered-commerce.html"
  #   @admin_ad_and_legal_page.set_footer(footer_link)

  #   # go to home page and verify the footer
  #   @browser.goto @home_page.url
    
  #   @browser.wait_until { @home_page.footer.present? }
  #   assert @home_page.footer.present?
  #   @browser.wait_until { @home_page.footer.text.include?(footer_link) }
  #   assert @home_page.footer.text.include?(footer_link)
  # end

  # def test_00060_set_privacy_contact_imprint_and_tou
  #     # All footer settings are moved to Admin->UI Customization.
  #     # The test should be covered there.

  #   # go to legal tab
  #   @admin_ad_and_legal_page.navigate_to_legal
  #   assert @admin_ad_and_legal_page.footer_text.present?

  #   legal_link = @browser.url
  #   privacy_link = "http://go.sap.com/corporate/en/legal/privacy.html"
  #   tou_link = "http://go.sap.com/corporate/en/legal/terms-of-use.html"
  #   contact_link = "https://go.sap.com/registration/contact.html"
  #   imprint_link = "http://go.sap.com/corporate/en/legal/impressum.html"
    
  #   # set some legal fields
  #   @browser.wait_until { @admin_ad_and_legal_page.tou_text.present? }
  #   assert @admin_ad_and_legal_page.tou_text.present?
  #   @admin_ad_and_legal_page.tou.set tou_link

  #   @admin_ad_and_legal_page.contactus.set contact_link

  #   @browser.wait_until { @admin_ad_and_legal_page.privacy_text.present? }
  #   assert @admin_ad_and_legal_page.privacy_text.present?
  #   @admin_ad_and_legal_page.privacy.set privacy_link

  #   @browser.wait_until { @admin_ad_and_legal_page.imprint_text.present? }
  #   assert @admin_ad_and_legal_page.imprint_text.present?
  #   @admin_ad_and_legal_page.imprint.set imprint_link

  #   # preview the legal changes
  #   @admin_ad_and_legal_page.legal_preview_button.when_present.click
  #   @browser.wait_until { @admin_ad_and_legal_page.legal_preview_close_button.present? }
  #   assert @admin_ad_and_legal_page.legal_preview_close_button.present?
  #   @admin_ad_and_legal_page.legal_preview_close_button.click
  #   @browser.wait_until { !@admin_ad_and_legal_page.legal_preview_close_button.present? }
  #   assert !@admin_ad_and_legal_page.legal_preview_close_button.present?
  #   @browser.wait_until { !@admin_ad_and_legal_page.modal.present?}
  #   assert !@admin_ad_and_legal_page.modal.present?
  #   @browser.wait_until { @admin_ad_and_legal_page.legal_publish_button.present? }
  #   assert @admin_ad_and_legal_page.legal_publish_button.present?

  #   # publish changes
  #   @admin_ad_and_legal_page.publish_changes
 
  #   # go to Home page
  #   @browser.goto @home_page.url
  #   @browser.wait_until($t) { @home_page.footer.present? }

  #   @browser.wait_until($t) { @home_page.footer_link.present? }
  #   assert @home_page.footer_link.present?

  #   # verify the legal changes take effect in the footer
  #   @browser.wait_until($t) { @home_page.footer_link.text =~ /Privacy Policy/ }
  #   assert @home_page.footer_link.text =~ /Privacy Policy/
    
  #   @browser.wait_until($t) { @home_page.footer_link.text =~ /Terms of Use/ }
  #   @browser.wait_until($t) { @home_page.tou_link.present? }
  #   assert @home_page.tou_link.present?
  #   assert @home_page.footer_link.text =~ /Terms of Use/
    
  #   @browser.wait_until($t) { @home_page.footer_link.text =~ /Contact Us/ }
  #   assert @home_page.footer_link.text =~ /Contact Us/
    
  #   @browser.wait_until($t) { @home_page.footer_link.text =~ /Imprint/ }
  #   assert @home_page.footer_link.text =~ /Imprint/

  #   # verify Terms of Use link
  #   assert @home_page.tou_link.href =~ /#{tou_link}/

  #   # go to Admin->Legal page
  #   @browser.goto legal_link
  #   @browser.wait_until($t) { @admin_ad_and_legal_page.footer_text.present? }
  #   assert @admin_ad_and_legal_page.footer_text.present?

  #   # clear these legal fields
  #   @admin_ad_and_legal_page.tou.clear
  #   @admin_ad_and_legal_page.contactus.clear
  #   @admin_ad_and_legal_page.privacy.clear
  #   @admin_ad_and_legal_page.imprint.clear

  #   @browser.wait_until($t) { @admin_ad_and_legal_page.legal_publish_button.present? }
  #   assert @admin_ad_and_legal_page.legal_publish_button.present?
    
  #   # publish the changes and verify the publish success message
  #   @admin_ad_and_legal_page.publish_changes  
  #   assert @admin_ad_and_legal_page.legal_confirm_msg.present?
  # end

  def test_00070_check_legal_cookie_msg 
    # go to legal tab
    @admin_ad_and_legal_page.navigate_to_legal

    # verify legal cookie message and Show Message button present
    @browser.wait_until($t) { @admin_ad_and_legal_page.legal_cookie_msg.present? }
    assert @admin_ad_and_legal_page.legal_cookie_msg.present?

    @browser.wait_until($t) { @admin_ad_and_legal_page.legal_show_cookie_msg_button.present? }
    assert @admin_ad_and_legal_page.legal_show_cookie_msg_button.present?
  end

  def test_00080_set_legal_cookie_msg
    # go to Admin->Legal tab
    @admin_ad_and_legal_page.navigate_to_legal

    # click Show Message button
    @admin_ad_and_legal_page.scroll_to_element(@admin_ad_and_legal_page.legal_show_cookie_msg_button)
    @browser.execute_script("window.scrollBy(0,-200)") # in case overlapped by top navigator bar
    @admin_ad_and_legal_page.legal_show_cookie_msg_button.when_present.click

    @browser.wait_until($t) { @admin_ad_and_legal_page.cookie_proceed_button.present? }
    assert @admin_ad_and_legal_page.cookie_proceed_button.present?

    # click Proceed button on Confirm dialog
    @admin_ad_and_legal_page.cookie_proceed_button.when_present.click
    @browser.wait_until($t) { !@admin_ad_and_legal_page.cookie_proceed_button.present? }
    assert !@admin_ad_and_legal_page.cookie_proceed_button.present?
    # until see "... successfully saved!" toast message
    @browser.wait_until($t) { @admin_ad_and_legal_page.toast_success_message.present? }
    assert @admin_ad_and_legal_page.toast_success_message.present?

    # refresh web browser
    @browser.refresh
    @browser.wait_until($t) { @admin_ad_and_legal_page.legal_show_cookie_msg_button.present? }
    assert @admin_ad_and_legal_page.legal_show_cookie_msg_button.present?

    # verify policy warning message is prompted
    @browser.wait_until($t) { @admin_ad_and_legal_page.layout.policy_warning_primary_button.present? }
    assert @admin_ad_and_legal_page.layout.policy_warning_primary_button.present?
  end

end