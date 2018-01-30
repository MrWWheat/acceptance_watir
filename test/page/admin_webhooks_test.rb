require 'watir_test'
require 'pages/community/admin_webhooks'

class AdminWebhooksTest < WatirTest

  def setup
    super
    @admin_webhooks_page = Pages::Community::AdminWebhooks.new @config
    p "[[[ #{name} ::: #{user_for_test} ]]]" if @config.verbose?
    @browser = @config.browser
    @admin_webhooks_page.start! user_for_test
  end

  def teardown
    super
  end

  p1

  user :network_admin
  def test_00100_check_email_and_bell_notification_checkbox
    @admin_webhooks_page.navigate_in_admin_webhooks
    @browser.wait_until { @admin_webhooks_page.new_webhook_btn.present? }

    @admin_webhooks_page.assert_email_bell_notification_checkbox
  end

  def test_00200_check_create_and_delete_webhook
    @admin_webhooks_page.navigate_in_admin_webhooks

    title = "#{@config.slug}-webhook1"
    url = "https://localhost:3000"
    @admin_webhooks_page.create_webhook(title, url)
    @admin_webhooks_page.edit_webhook_link.when_present.click

    updated_title = "#{title}-updated"
    @admin_webhooks_page.update_title updated_title
    @admin_webhooks_page.back_to_all_webhook_link.when_present.click
    @browser.wait_until { @admin_webhooks_page.new_webhook_btn.present? }

    @admin_webhooks_page.delete_webhook updated_title, url
  end
end