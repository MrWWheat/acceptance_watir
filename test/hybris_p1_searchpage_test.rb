require File.expand_path(File.dirname(__FILE__) + "/hybris_watir_test.rb")
require File.expand_path(File.dirname(__FILE__) + "/../lib/test_helper.rb")
require File.expand_path(File.dirname(__FILE__) + "/../lib/hybris_test.rb")


class HybrisP1SearchpageTest < HybrisWatirTest
  include HybrisTest
  
  def test_00170_sort_search_result_from_community
    open_site
    search_product('a')
    sort_community_search_result
  end

  def test_00180_filter_search_result
    open_site
    search_product('a')
    filter_community_search_result_by_questions
    filter_community_search_result_by_reviews
    filter_community_search_result_by_blogs
    filter_community_search_result_by_discussions
  end
  
  def test_00190_paging_search_result
    open_site
    search_product('a')
    paging_community_search_result
  end

end