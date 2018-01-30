require 'watir_test'
require 'pages/hybris/home'
require 'actions/hybris/common'

class HybrisDetailTabsTest < WatirTest
  def setup
    super
    @hybris_home_page = Pages::Hybris::Home.new(@config)
    @hybris_detail_page = Pages::Hybris::Detail.new(@config)
    @common_actions = Actions::Common.new(@config)
    #@api_actions = Actions::Api.new(@config)

    @current_page = @hybris_home_page
    @hybris_home_page.start!(user_for_test)
  end

  def teardown
    super
  end

  user :anonymous
  p1
  def test_00070_b2b_sort_reviews
    @common_actions.go_to_product_detail(@config.product_id_many)

    @hybris_detail_page.click_read_all_reviews_link

    first_review_href_pre_sort = @hybris_detail_page.get_first_item_in_tab(:review).href

    @hybris_detail_page.sort(:review, :oldest)
    assert @hybris_detail_page.get_first_item_in_tab(:review).href != first_review_href_pre_sort, 
           "Sort as Oldest doesn't work"

    @hybris_detail_page.sort(:review, :newest)
    assert @hybris_detail_page.get_first_item_in_tab(:review).href == first_review_href_pre_sort, 
           "Sort as Newest doesn't work"
  end

  user :anonymous
  p1
  def test_00080_b2b_sort_questions
    @common_actions.go_to_product_detail(@config.product_id_many)

    @hybris_detail_page.click_read_all_questions_link

    first_q_href_pre_sort = @hybris_detail_page.get_first_item_in_tab(:question).href

    @hybris_detail_page.sort(:question, :oldest)
    assert @hybris_detail_page.get_first_item_in_tab(:question).href != first_q_href_pre_sort, 
    			 "Sort as Oldest doesn't work"

    @hybris_detail_page.sort(:question, :newest)
    assert @hybris_detail_page.get_first_item_in_tab(:question).href == first_q_href_pre_sort, 
    			 "Sort as Newest doesn't work"

    @hybris_detail_page.sort(:question, :most_reply)
    assert @hybris_detail_page.get_first_item_in_tab(:question).href != first_q_href_pre_sort, 
    			 "Sort as most_reply doesn't work"

    first_q_href_pre_sort = @hybris_detail_page.get_first_item_in_tab(:question).href

    @hybris_detail_page.sort(:question, :least_reply)
    assert @hybris_detail_page.get_first_item_in_tab(:question).href != first_q_href_pre_sort, 
    			 "Sort as least_reply doesn't work"
  end

  # user :anonymous
  # p1
  # def test_00090_b2b_paging_questions
  #   @common_actions.go_to_product_detail(@config.product_id_many)
  #
  #   @hybris_detail_page.click_read_all_questions_link
  #
  # 	first_q_href_pre_pgn = @hybris_detail_page.get_first_item_in_tab(:question).href
  # 	@hybris_detail_page.paging_in_tab(:question, :next)
  #
  # 	assert @hybris_detail_page.get_first_item_in_tab(:question).href != first_q_href_pre_pgn,
  # 				"Pagination to Next page does't work"
  #
  # 	@hybris_detail_page.paging_in_tab(:question, :prev)
  #
  # 	assert @hybris_detail_page.get_first_item_in_tab(:question).href == first_q_href_pre_pgn,
  # 				"Pagination to Prev page does't work"
  # end

  # user :anonymous
  # p1
  # def test_00110_b2b_paging_reviews
  #   @common_actions.go_to_product_detail(@config.product_id_many)
  #
  #   @hybris_detail_page.click_read_all_reviews_link
  #
  # 	first_review_href_pre_pgn = @hybris_detail_page.get_first_item_in_tab(:review).href
  # 	@hybris_detail_page.paging_in_tab(:review, :next)
  #
  # 	assert @hybris_detail_page.get_first_item_in_tab(:review).href != first_review_href_pre_pgn,
  # 				"Pagination to Next page does't work"
  #
  # 	@hybris_detail_page.paging_in_tab(:review, :prev)
  #
  # 	assert @hybris_detail_page.get_first_item_in_tab(:review).href == first_review_href_pre_pgn,
  # 				"Pagination to Prev page does't work"
  # end

  # user :anonymous
  # p1
  # def test_00120_b2b_show_more_answers
  # 	@common_actions.go_to_product_detail(@config.product_id_many)
  #
  # 	@hybris_detail_page.click_read_all_questions_link
  #
  # 	@hybris_detail_page.sort(:question, :most_reply)
  #
  # 	@hybris_detail_page.click_show_more_answers_to_end_at_index(0)
  #
  # 	assert @hybris_detail_page.get_more_answers_current_num_at_index(0) ==
  # 				 @hybris_detail_page.get_more_answers_total_num_at_index(0),
  # 				 "Current number of more answers doesn't equal the total number"
  #
  #   cur_num_before_final_click = @hybris_detail_page.get_more_answers_current_num_at_index(0)
  #
  #   @hybris_detail_page.click_show_more_answers_at_index(0)
  #
  #   assert @hybris_detail_page.get_more_answers_current_num_at_index(0) == cur_num_before_final_click,
  #   			 "Current number is changed even click after no more any answers"
  # end

  # user :anonymous
  # p1
  # def test_00130_b2b_paging_blogs
  #   @common_actions.go_to_product_detail(@config.product_id_many)
  #
  #   @hybris_detail_page.switch_to_tab(:blog)
  #
  # 	first_review_href_pre_pgn = @hybris_detail_page.get_first_item_in_tab(:blog).href
  # 	@hybris_detail_page.paging_in_tab(:blog, :next)
  #
  # 	assert @hybris_detail_page.get_first_item_in_tab(:blog).href != first_review_href_pre_pgn,
  # 				"Pagination to Next page does't work"
  #
  # 	@hybris_detail_page.paging_in_tab(:blog, :prev)
  #
  # 	assert @hybris_detail_page.get_first_item_in_tab(:blog).href == first_review_href_pre_pgn,
  # 				"Pagination to Prev page does't work"
  # end

 	# user :anonymous
 	# p1
  # def test_00140_b2b_paging_discussions
  #   @common_actions.go_to_product_detail(@config.product_id_many)
  #
  #   @hybris_detail_page.switch_to_tab(:discussion)
  #
  # 	first_review_href_pre_pgn = @hybris_detail_page.get_first_item_in_tab(:discussion).href
  # 	@hybris_detail_page.paging_in_tab(:discussion, :next)
  #
  # 	assert @hybris_detail_page.get_first_item_in_tab(:discussion).href != first_review_href_pre_pgn,
  # 				"Pagination to Next page does't work"
  #
  # 	@hybris_detail_page.paging_in_tab(:discussion, :prev)
  #
  # 	assert @hybris_detail_page.get_first_item_in_tab(:discussion).href == first_review_href_pre_pgn,
  # 				"Pagination to Prev page does't work"
  # end

  user :anonymous
  p1
  def test_00150_b2b_sort_blogs
    @common_actions.go_to_product_detail(@config.product_id_many)
    
    @hybris_detail_page.switch_to_tab(:blog)

    first_review_href_pre_sort = @hybris_detail_page.get_first_item_in_tab(:blog).href

    @hybris_detail_page.sort(:blog, :oldest)
    assert @hybris_detail_page.get_first_item_in_tab(:blog).href != first_review_href_pre_sort, 
    			 "Sort as Oldest doesn't work"

    @hybris_detail_page.sort(:blog, :newest)
    assert @hybris_detail_page.get_first_item_in_tab(:blog).href == first_review_href_pre_sort, 
    			 "Sort as Newest doesn't work"
  end

  # Deprecated: Discussion has been rmoved from our product
  # user :anonymous
  # p1
  # def xtest_00160_b2b_sort_discussions
  #   @common_actions.go_to_product_detail(@config.product_id_many)
    
  #   @hybris_detail_page.switch_to_tab(:discussion)

  #   first_review_href_pre_sort = @hybris_detail_page.get_first_item_in_tab(:discussion).href

  #   @hybris_detail_page.sort(:discussion, :oldest)
  #   assert @hybris_detail_page.get_first_item_in_tab(:discussion).href != first_review_href_pre_sort, 
  #   			 "Sort as Oldest doesn't work"

  #   @hybris_detail_page.sort(:discussion, :newest)
  #   assert @hybris_detail_page.get_first_item_in_tab(:discussion).href == first_review_href_pre_sort, 
  #   			 "Sort as Newest doesn't work"
  # end

  # user :hybris_user1
  # p1
  # def test_00200_b2b_vote_questions_mapped
  #   @common_actions.go_to_product_detail(@config.product_id_many)
  #
  #   @hybris_detail_page.click_read_all_questions_link
  #
  #   old_vote_num = @hybris_detail_page.get_question_vote_num_at_index(0)
  #   @hybris_detail_page.vote_question_at_index_for_user(0, :up)
  #
  #   assert @hybris_detail_page.get_question_vote_num_at_index(0) == old_vote_num + 1, "Vote number is not added by 1"
  #
  #   @hybris_detail_page.vote_question_at_index_for_user(0, :up, false) # true: vote up for the second time
  #
  #   assert @hybris_detail_page.error_msg.visible?, "Error message 'Can't vote Twice' is not displayed"
  #
  #   @hybris_detail_page.vote_question_at_index_for_user(0, :down)
  #
  #   assert @hybris_detail_page.get_question_vote_num_at_index(0) == old_vote_num, "Vote number is not decreased by 1"
  # end
end