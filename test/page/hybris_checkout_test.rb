require 'watir_test'
require 'pages/hybris/home'
require 'pages/hybris/list'
require 'pages/hybris/shopping_cart'
require 'pages/hybris/checkout'
require 'pages/community/conversation/conversation_create'
require 'pages/community/conversationdetail'
require 'pages/mail_catcher'
require 'actions/hybris/common'
require 'actions/hybris/api'

class HybrisCheckoutTest < WatirTest

  def setup
    super
    @hybris_home_page = Pages::Hybris::Home.new(@config)
    @hybris_list_page = Pages::Hybris::List.new(@config)
    @hybris_checkout_page = Pages::Hybris::Checkout.new(@config)
    @hybris_shopping_cart_page = Pages::Hybris::ShoppingCart.new(@config)
    @convcreate_page = Pages::Community::ConversationCreate.new(@config)
    @community_conversationdetail_page = Pages::Community::ConversationDetail.new(@config)
    @mail_catcher = Pages::MailCatcher.new(@config)
    @common_actions = Actions::Common.new(@config)
    @api_actions = Actions::Api.new(@config)

    puts "[[[ #{name} ::: nil ]]]" if @config.verbose?
    @browser = @c.browser
    @hybris_home_page.start!(user_for_test)

    @review_1 = nil
    @review_2 = nil
  end

  def teardown
    super
    @api_actions.delete_review(@config.users[:network_admin], @review_1) if @review_1
    @api_actions.delete_review(@config.users[:network_admin], @review_2) if @review_2
  end

  user :hybris_user1
  p1
  def test_00010_verified_purchaser

    title = "review-#{Time.now.utc.to_i}"
    desc = "content-#{Time.now.utc.to_i}"

    @common_actions.search 'b'

    @hybris_list_page.put_item_into_shpping_cart 0
    @hybris_list_page.put_item_into_shpping_cart 1
    @hybris_list_page.go_to_shopping_cart
    @hybris_shopping_cart_page.check_out
    @hybris_checkout_page.place_order
    order_number = @hybris_checkout_page.get_order_number

    @browser.goto @config.mail_catcher_url

    # mail_link = @mail_catcher.goto_mail order_number
    mail_links = @mail_catcher.get_order_mails order_number, 2

    @browser.goto mail_links[0]
    @mail_catcher.goto_review 0
    # create review
    @convcreate_page.fill_in_fields_then_submit_review(title: title, 
                                                       details: [{type: :text, content: desc}], 
                                                       star: 1)
    @browser.wait_until { @community_conversationdetail_page.conv_content.present? }
    @review_1 = @community_conversationdetail_page.get_review_id
    assert @community_conversationdetail_page.conv_detail.present?, "Verified buyer not show"
    assert @community_conversationdetail_page.conv_title.text == title, "review title not match #{title}"
    assert @community_conversationdetail_page.conv_des.text.include?(desc), "review title not match #{desc}"

    @browser.goto mail_links[1]
    @mail_catcher.goto_review 0
    # create review
    @convcreate_page.fill_in_fields_then_submit_review(title: title, 
                                                       details: [{type: :text, content: desc}], 
                                                       star: 1)
    @browser.wait_until { @community_conversationdetail_page.conv_content.present? }

    @review_2 = @community_conversationdetail_page.get_review_id
    assert @community_conversationdetail_page.conv_detail.present?, "Verified buyer not show"
    assert @community_conversationdetail_page.conv_title.text == title, "review title not match #{title}"
    assert @community_conversationdetail_page.conv_des.text.include?(desc), "review title not match #{desc}"
  end

end