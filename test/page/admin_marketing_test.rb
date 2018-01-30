require 'watir_test'
require 'pages/community/admin_marketing'

class AdminMarketingTest < WatirTest

  def setup
    super
    @admin_marketing_page = Pages::Community::AdminMarketing.new(@config)
    @current_page = @admin_marketing_page
    puts "[[[ #{name} ::: #{user_for_test} ]]]" if @config.verbose?
    @browser = @config.browser
    @admin_marketing_page.start!(user_for_test)
  end

  def teardown
    super
  end

  user :network_admin
  p1
  def test_00010_check_marketing_sync_successful
    @admin_marketing_page.navigate_to_marketing_int
    @browser.wait_until { @admin_marketing_page.marketing_int_config_page.present? }
    @browser.wait_until { @admin_marketing_page.marketing_int_config_sync_button.present?}
    @admin_marketing_page.marketing_int_config_sync_button.when_present.click
    @browser.wait_until { @admin_marketing_page.marketing_int_config_sync_suc_info.present? }
    for i in 0..5
      @browser.refresh
      @admin_marketing_page.switch_to_marketing_int_tab(:history)
      if @admin_marketing_page.marketing_int_history_content.text.include?"Progress"
        sleep(30)
      else
        @admin_marketing_page.marketing_int_history_rows.each_with_index do |div_item,index|
            puts div_item.text.gsub("\n",' ')
        end
        break
      end
    end
    assert !(@admin_marketing_page.marketing_int_history_content.text.include?"Failed"),"SYNC FAILURE"
  end


end