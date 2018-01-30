require 'watir_test'
require 'pages/yaas/home'
require 'pages/yaas/detail'
require 'pages/yaas/login'
require 'pages/yaas/layout'
require 'pages/yaas/checkout'
require 'pages/yaas/shopping_cart'
require 'pages/community/topic_list'
require 'pages/community/topicdetail'
require 'pages/community/conversationdetail'
require 'pages/community/layout'

class YaasBasicTest < WatirTest

  def setup
    super
    @yaas_home_page = Pages::Yaas::Home.new(@config)
    @yaas_detail_page = Pages::Yaas::Detail.new(@config)
    @yaas_login_page = Pages::Yaas::Login.new(@config)
    @yaas_layout_page = Pages::Yaas::Layout.new(@config)
    @community_topic_list_page = Pages::Community::TopicList.new(@config)
    @topicdetail_page = Pages::Community::TopicDetail.new(@config)
    @convdetail_page = Pages::Community::ConversationDetail.new(@config)
    @community_layout_page = Pages::Community::Layout.new(@config)
    @yaas_checkout_page = Pages::Yaas::Checkout.new(@config)
    @yaas_shoppingcart_page = Pages::Yaas::ShoppingCart.new(@config)

    @current_page = @yaas_home_page
    puts "[[[ #{name} ::: nil ]]]" if @config.verbose?
    @browser = @c.browser
    @yaas_login_page.start!(user_for_test)
  end

  def teardown
    super
  end

  user :regular_user1
  def test_00010_write_review_test
    @yaas_home_page.go_to_first_product_detail_page
    @yaas_detail_page.ask_question_btn.when_present.click
    @yaas_detail_page.create_question
  end

  user :anonymous
  def test_00020_shopping_cart_test
    @browser.goto @c.base_url
    @community_topic_list_page.go_to_first_product
    @topicdetail_page.topic_post_link.when_present.click
    @convdetail_page.add_to_cart
    @community_layout_page.checkout_button.when_present.click
    @browser.window(:url => /#{@c.yaas_url}/).when_present.use do
      @browser.wait_until { @yaas_checkout_page.checkout_form.present?}
      sleep(2)
      @yaas_home_page.goto_home_page
      @yaas_layout_page.shopping_cart_btn.when_present.click
      @browser.wait_until { @yaas_shoppingcart_page.first_item_name.present? }
      assert !@yaas_shoppingcart_page.empty_cart.present?
      assert @yaas_shoppingcart_page.first_item_qty.value == "1"
      @yaas_shoppingcart_page.continue_shopping_btn.when_present.click
    end
  end

end
