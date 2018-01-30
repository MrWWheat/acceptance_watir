require File.expand_path(File.dirname(__FILE__) + "/hybris_watir_test.rb")
require File.expand_path(File.dirname(__FILE__) + "/../lib/test_helper.rb")
require File.expand_path(File.dirname(__FILE__) + "/../lib/hybris_test.rb")


class HybrisB2BP1DetailpageMainTest < HybrisWatirTest
  include HybrisTest

  def test_00030_product_detail_page_with_no_content
    open_site
    product_detail($product_id_blank)
    check_detailpage_with_no_content
  end

  def test_00040_product_detail_page
    open_site
    product_detail($product_id_many)
    #check_detailpage
    read_all_reviews
    sleep 1
    read_all_questions
    sleep 1
  end

  def test_00050_write_review_with_hybrislogin_mapped
    open_site
    product_detail($product_id_write)
    precondition_user_mapped($hybrisuser,$communityuser)
    write_review_with_hybrislogin_mapped($hybrisuser, $communityuser, 4,"review-#{get_timestamp}","content-#{get_timestamp}")
    log_out
  end

  def test_00051_write_review_with_hybrislogin_nomapped
    open_site
    product_detail($product_id_write)
    precondition_user_not_mapped($hybrisuser2, $communityuser2)
    write_review_with_hybrislogin_nomapped($hybrisuser2,$communityuser2, 4,"review-#{get_timestamp}","content-#{get_timestamp}")
    log_out
  end

  def test_00060_ask_question_mapped
    open_site
    product_detail($product_id_write)
    precondition_user_mapped($hybrisuser,$communityuser)
    login_hybris($hybrisuser)
    ask_question_mapped("question-#{get_timestamp}","content-#{get_timestamp}")
    log_out
  end

  def test_00061_ask_question_with_hybrislogin_nomapped
    open_site
    product_detail($product_id_write)
    precondition_user_not_mapped($hybrisuser2, $communityuser2)
    ask_question_with_hybrislogin_nomapped($hybrisuser2, $communityuser2, "question-#{get_timestamp}","content-#{get_timestamp}")
    log_out
  end

end