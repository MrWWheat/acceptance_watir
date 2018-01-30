require 'watir_test'
require 'pages/community/admin_analytics'

class AdminAnalyticsTest < WatirTest

  def setup
    super
    @admin_analytics_page = Pages::Community::AdminAnalytics.new(@config)
    # assigning @current_page helps error reporting
    #  give good contextual data
    @current_page = @admin_analytics_page
    puts "[[[ #{name} ::: #{user_for_test} ]]]" if @config.verbose?
    @browser = @config.browser
    @admin_analytics_page.start!(user_for_test)
  end

  def teardown
    super
  end

  user :network_admin

  p2
  def test_00010_check_3rd_party_analytics_option
   assert @admin_analytics_page.analytic_provider_btn.present?
   assert @admin_analytics_page.analytic_submit_btn.present?
  end
end