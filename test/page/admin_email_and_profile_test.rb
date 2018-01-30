require 'watir_test'
require 'pages/community/admin_email_and_profile'

class AdminEmailAndProfileTest < WatirTest

  def setup
    super
    @admin_email_and_profile_page = Pages::Community::AdminEmailAndProfile.new(@config)
    # assigning @current_page helps error reporting
    #  give good contextual data
    @current_page = @admin_email_and_profile_page
    puts "[[[ #{name} ::: #{user_for_test} ]]]" if @config.verbose?
    @browser = @config.browser
    @admin_email_and_profile_page.start!(user_for_test)
  end

  def teardown
    super
  end

  user :network_admin

  p1
  def test_00010_check_email_designer_option
    # navigate to Admin->Email Designer page
    @admin_email_and_profile_page.navigate_to_email_designer

    # verify the email designer page is present including "Edit Email Template" button 
    assert @admin_email_and_profile_page.email_designer_page.present?
    assert @admin_email_and_profile_page.email_designer_edit_button.present?
  end

  def test_00020_edit_email_template
    # navigate to Admin->Email Designer page
    @admin_email_and_profile_page.navigate_to_email_designer

    email_text_color = "color:#0000A0"
    email_text_color_hex = "0000A0"
    email_text_color_rgb = "rgb(0, 0, 160)"

    # click "Edit Email Template" button
    @admin_email_and_profile_page.email_designer_edit_button.click
    @browser.wait_until($t) { @admin_email_and_profile_page.email_edit_page.present? }
    assert @admin_email_and_profile_page.email_edit_page.present?

    # toggle on Edit icon on Email Background
    @browser.execute_script('$("div.email-edit").css("display", "block")')
    @browser.wait_until($t) { @admin_email_and_profile_page.email_edit_icon.present? }
    assert @admin_email_and_profile_page.email_edit_icon.present?

    # click Edit icon
    @admin_email_and_profile_page.email_edit_icon.when_present.click
    @browser.wait_until($t) { @admin_email_and_profile_page.email_bg_textarea.present? }
    assert @admin_email_and_profile_page.email_bg_textarea.present?

    # set color for Email background
    @browser.execute_script('$("int_background_style ember-view ember-text-area").focus()')
    @browser.execute_script('$("int_background_style ember-view ember-text-area").val(" ")')
    sleep 2
    @admin_email_and_profile_page.email_bg_textarea.set email_text_color
    @browser.execute_script('$("textarea.int_background_style ember-view ember-text-area").blur()')

    sleep 2 # !!!Do not remove. Otherwise the case will fail sometimes.
    @browser.wait_until($t) { @admin_email_and_profile_page.email_bg_textarea.value == email_text_color }

    # click Preview button
    @admin_email_and_profile_page.email_preview_button.click
    @browser.wait_until($t) { @admin_email_and_profile_page.email_preview_page.present? }
    assert @admin_email_and_profile_page.email_preview_page.present?

    # verify the background is changed
    preview_email = @admin_email_and_profile_page.email_preview_bg_style.style
    #puts preview_email = #0000A0.to_s(16) #hex
    assert_match email_text_color_rgb, preview_email, "Preview settings doesn't match with set value"

    # click Ok button on Preview dialog
    @browser.wait_until($t) { @admin_email_and_profile_page.email_preview_ok_button.present? }
    assert @admin_email_and_profile_page.email_preview_ok_button.present?
    @admin_email_and_profile_page.email_preview_ok_button.when_present.click
    
    @browser.wait_until($t) { !@admin_email_and_profile_page.email_preivew_dialog.present? }
    assert !@admin_email_and_profile_page.email_preivew_dialog.present?
    @browser.wait_until($t) { !@admin_email_and_profile_page.email_preview_page.present? }
    assert !@admin_email_and_profile_page.email_preview_page.present?

    # verify the buttons in Edit Email Template page are present
    @browser.wait_until($t) { @admin_email_and_profile_page.email_edit_publish_button.present? }
    assert @admin_email_and_profile_page.email_edit_publish_button.present?
    @browser.wait_until($t) { @admin_email_and_profile_page.email_cancel_button.present? }
    assert @admin_email_and_profile_page.email_cancel_button.present?

    # click Cancel button in Edit Email Template page
    @admin_email_and_profile_page.email_cancel_button.when_present.click

    # verify Cancel Confirmation dialog is prompted
    @browser.wait_until($t) { @admin_email_and_profile_page.email_edit_cancel_confirm_dialog.present? }
    assert @admin_email_and_profile_page.email_edit_cancel_confirm_dialog.present?
    @browser.wait_until($t) { @admin_email_and_profile_page.email_edit_cancel_confirm_cancel_btn.present? }
    assert @admin_email_and_profile_page.email_edit_cancel_confirm_cancel_btn.present?

    # click Cancel button on Cancel Confirmation dialog
    @admin_email_and_profile_page.email_edit_cancel_confirm_cancel_btn.when_present.click

    # verify the Cancel Confirmation dialog is closed and back to Email Designer page
    @browser.wait_until($t) { !@admin_email_and_profile_page.email_edit_cancel_confirm_dialog.present? }
    assert !@admin_email_and_profile_page.email_edit_cancel_confirm_dialog.present?
    @browser.wait_until($t) { @admin_email_and_profile_page.email_designer_page.present? }
    assert @admin_email_and_profile_page.email_designer_page.present?
  end

  p2
  def test_00040_profile_field_option
    # navigate to Admin->Profile Fields page
    @admin_email_and_profile_page.navigate_to_profile_fields

    assert @admin_email_and_profile_page.profile_field_page.present?
  end

  def xtest_00050_check_mandatory_profile_field
    skip
  end
end