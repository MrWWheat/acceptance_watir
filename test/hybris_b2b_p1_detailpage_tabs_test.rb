require File.expand_path(File.dirname(__FILE__) + "/hybris_watir_test.rb")
require File.expand_path(File.dirname(__FILE__) + "/../lib/test_helper.rb")
require File.expand_path(File.dirname(__FILE__) + "/../lib/hybris_test.rb")


class HybrisP1DetailpageTabsTest < HybrisWatirTest
  include HybrisTest

  def test_00070_sort_reviews
    open_site
    product_detail($product_id_many)
    sort_reviews
  end

  def test_00080_sort_questions
    open_site
    product_detail($product_id_many)
    sort_questions
  end

  def test_00090_paging_questions
    open_site
    product_detail($product_id_many)
    paging_questions
  end

  def test_00110_paging_reviews
    open_site
    product_detail($product_id_many)
    paging_reviews
  end

  def test_00120_show_more_answers
    open_site
    product_detail($product_id_many)
    show_more_answers
  end

  def test_00130_paging_blogs
    open_site
    product_detail($product_id_many)
    paging_blogs
  end

  def test_00140_paging_discussions
    open_site
    product_detail($product_id_many)
    paging_discussions
  end

  def test_00150_sort_blogs
    open_site
    product_detail($product_id_many)
    sort_blogs
  end

  def test_00160_sort_discussions
    open_site
    product_detail($product_id_many)
    sort_discussions
  end

  def test_00200_vote_questions_mapped
    open_site
    product_detail($product_id_many)
    login_hybris($hybrisuser)
    vote_qustion
    log_out
  end

end