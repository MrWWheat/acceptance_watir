require 'watir_test'
require 'pages/hybris/home'
require 'actions/hybris/common'
require 'actions/hybris/api'

class HybrisDetailTest < WatirTest

  def setup
    super
    @hybris_home_page = Pages::Hybris::Home.new(@config)
    @hybris_detail_page = Pages::Hybris::Detail.new(@config)
    @common_actions = Actions::Common.new(@config)
    @api_actions = Actions::Api.new(@config)
    @topicdetail_page = Pages::Community::TopicDetail.new(@config)
    # @hybris_detail_page = Pages::HybrisDetail.new(@config)
    # assigning @current_page helps error reporting
    #  give good contextual data
    @current_page = @hybris_home_page
    puts "[[[ #{name} ::: nil ]]]" if @config.verbose?
    @browser = @config.browser
    @hybris_home_page.start!(user_for_test)
    @uuid = nil
    @need_break_mapping = false
  end

  def teardown
    super
    @api_actions.delete_review(@config.users[:network_admin], @uuid) if @uuid
    if @need_break_mapping && (@api_actions.is_user_mapped? @config.users[:hybris_user2], @config.users[:regular_user2])
      @api_actions.break_mapping(@config.users[:regular_user2])
    end
  end

  user :anonymous
  p1
  def test_00030_b2b_product_detail_page_with_no_content
    @common_actions.go_to_product_detail(@config.product_id_blank)

    assert @hybris_detail_page.to_be_first_review_link.present?, "to be first review link does not present"
    assert @hybris_detail_page.to_be_first_question_link.present?, "to be first question link does not present"
  end

  user :anonymous
  p1
  def test_00040_b2b_product_detail_page
    @common_actions.go_to_product_detail(@config.product_id_many)
    @hybris_detail_page.read_all_reviews_link.when_present.click
    assert @browser.link(:id => "tab_review").text =~ /CUSTOMER REVIEWS/
    @hybris_home_page.scroll_to_element @hybris_detail_page.read_all_questions_link
    @hybris_detail_page.read_all_questions_link.when_present.click
    assert @browser.link(:id => "tab_qa").text =~ /Q&A/
  end

  # user :hybris_user1
  # p1
  # def test_00050_b2b_write_review_mapped
  #   rating = 4
  #   title = "review-#{Time.now.utc.to_i}"
  #   desc = "content-#{Time.now.utc.to_i}"
  #   recommended = true
  #
  #   @common_actions.go_to_product_detail(@config.product_id_write)
  #
  #   @common_actions.precondition_user_mapped(@config.users[:regular_user1])
  #
  #   @uuid = @common_actions.write_review(:link, rating, title, desc, recommended)
  #
  #   assert @hybris_detail_page.most_recent_review.p(:class => "e-post-title").text == title, "review title not match #{title}"
  #   assert @hybris_detail_page.most_recent_review.div(:class => "e-post-content").text == desc, "review description not match #{desc}"
  # end

  user :hybris_user2
  p1
  # def test_00051_b2b_write_review_nomapped
  #   rating = 4
  #   title = "review-#{Time.now.utc.to_i}"
  #   desc = "content-#{Time.now.utc.to_i}"
  #   recommended = true
  #   @common_actions.go_to_product_detail(@config.product_id_write)
  #
  #   @common_actions.precondition_user_not_mapped
  #
  #   @hybris_detail_page.write_review_link.when_present.click
  #   assert !@hybris_detail_page.has_login?, "The user has mapped"
  #   @hybris_detail_page.login_community @config.users[:regular_user2]
  #   @hybris_detail_page.create_review rating:rating, title: title, desc:desc, recommended:recommended
  #
  #   @uuid = @hybris_detail_page.get_review_uuid_by_title title
  #   @need_break_mapping = true
  #
  #   assert @hybris_detail_page.most_recent_review.p(:class => "e-post-title").text == title, "review title not match #{title}"
  #   assert @hybris_detail_page.most_recent_review.div(:class => "e-post-content").text == desc, "review description not match #{desc}"
  # end
  #
  # user :hybris_user1
  # p1
  # def test_00060_b2b_ask_question_mapped
  #   title = "question-#{Time.now.utc.to_i}"
  #   desc = "content-#{Time.now.utc.to_i}"
  #
  #   @common_actions.go_to_product_detail(@config.product_id_write)
  #
  #   @common_actions.precondition_user_mapped(@config.users[:regular_user1])
  #
  #   @common_actions.ask_question(:button, title, desc)
  #
  #   assert @hybris_detail_page.most_recent_question.p(:class => "e-post-title").text == title, "question title not match #{title}"
  #   assert @hybris_detail_page.most_recent_question.div(:class => "e-post-content").text == desc, "question descrition not match #{desc}"
  # end


  user :hybris_user2
  p1
  # def test_00061_b2b_ask_question_nomapped
  #   title = "question-#{Time.now.utc.to_i}"
  #   desc = "content-#{Time.now.utc.to_i}"
  #
  #   @common_actions.go_to_product_detail(@config.product_id_write)
  #
  #   @common_actions.precondition_user_not_mapped
  #
  #   @hybris_detail_page.write_question_link.when_present.click
  #   assert !@hybris_detail_page.has_login?, "The user has mapped or has written review before"
  #   @hybris_detail_page.login_community @config.users[:regular_user2]
  #   @hybris_detail_page.create_question title: title, desc:desc
  #
  #   @need_break_mapping = true
  #
  #   assert @hybris_detail_page.most_recent_question.p(:class => "e-post-title").text == title, "question title not match #{title}"
  #   assert @hybris_detail_page.most_recent_question.div(:class => "e-post-content").text == desc, "question descrition not match #{desc}"
  # end

  def test_00630_check_product_banner_name
    @browser.goto @topicdetail_page.productpage_url
    @browser.wait_until($t) { @topicdetail_page.first_product_link.present?}
    first_product_name = @topicdetail_page.first_product_link.text
    @topicdetail_page.goto_first_productdetail_page
    @browser.wait_until($t) { @topicdetail_page.product_detail_banner_title.present?}
    assert @topicdetail_page.product_detail_banner_title.text.include? first_product_name[0,35]
  end
  
  def test_00640_check_product_read_more_url
    @browser.goto @topicdetail_page.productpage_url
    @topicdetail_page.product_sort_by_name
    @browser.wait_until($t) { @topicdetail_page.first_product_link.present?}
    first_product_name = @topicdetail_page.first_product_link.text
    @topicdetail_page.goto_first_productdetail_page
    @browser.wait_until($t) { @topicdetail_page.product_detail_banner_title.present?}
    @topicdetail_page.product_detail_banner_readmore.when_present.click
    @browser.window(:url => /#{@c.hybris_url}/).when_present.use do
      @browser.wait_until($t) { @hybris_detail_page.product_name.present?}
      assert @hybris_detail_page.product_name.text.include? first_product_name[0,35]
      @browser.window.close
    end
  end

end
