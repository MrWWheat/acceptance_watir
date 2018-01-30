require 'watir_test'
require 'pages/hybris/home'
require 'pages/hybris/search'
require 'actions/hybris/common'
require 'actions/hybris/api'

class HybrisSearchpageTest < WatirTest

  def setup
    super
    @hybris_home_page = Pages::Hybris::Home.new(@config)
    @hybris_search_page = Pages::Hybris::Search.new(@config)
    @common_actions = Actions::Common.new(@config)
    # @current_page = @hybris_search_page
    puts "[[[ #{name} ::: nil ]]]" if @config.verbose?
    @browser = @c.browser
    @hybris_home_page.start!(user_for_test)
  end

  def teardown
    super
  end

  def test_00170_b2b_sort_search_result_from_community
    @common_actions.search 'a'
    @hybris_search_page.activate_tab :community
    @hybris_search_page.sort_product :oldest
    @hybris_search_page.sort_product :newest
  end

  def test_00180_b2b_filter_search_result
    @common_actions.search 'a'
    @hybris_search_page.activate_tab :community
    @hybris_search_page.filter :questions
    @hybris_search_page.activate_tab :community
    @hybris_search_page.filter :reviews
    @hybris_search_page.activate_tab :community
    @hybris_search_page.filter :blogs
  end

  def test_00190_b2b_paging_search_result
    @common_actions.search 'a'
    @hybris_search_page.activate_tab :community
    @hybris_search_page.paging
  end

end