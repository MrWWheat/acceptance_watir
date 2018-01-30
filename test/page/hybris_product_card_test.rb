require 'watir_test'
require 'pages/hybris/home'
require 'pages/hybris/detail'
require 'pages/community/home'
require 'pages/community/topic_list'
require 'pages/community/topicdetail'
require 'pages/community/conversationdetail'
require 'pages/community/conversation/conversation_create'
require 'pages/community/conversation/conversation_edit'
require 'actions/hybris/common'

class HybrisProductCardTest < WatirTest

  def setup
    super
    @hybris_home_page = Pages::Hybris::Home.new(@config)
    @hybris_detail_page = Pages::Hybris::Detail.new(@config)
    @community_home_page = Pages::Community::Home.new(@config)
    @community_topiclist_page = Pages::Community::TopicList.new(@config)
    @community_topicdetail_page = Pages::Community::TopicDetail.new(@config)
    @community_convcreate_page = Pages::Community::ConversationCreate.new(@config)
    @community_convedit_page = Pages::Community::ConversationEdit.new(@config)
    @community_conversationdetail_page = Pages::Community::ConversationDetail.new(@config)
    @common_actions = Actions::Common.new(@config)
    # @current_page = @hybris_search_page
    puts "[[[ #{name} ::: nil ]]]" if @config.verbose?
    @browser = @c.browser
    @community_home_page.start!(user_for_test)
  end

  def teardown
    super
  end

  user :regular_user1
  p1
  def test_00310_b2b_product_card_on_reply
    @community_topiclist_page.go_to_first_product

    # create a new question
    @community_topicdetail_page.goto_conversation_create_page(:question)

    @community_convcreate_page.fill_in_conversation_fields(type: :question, 
                                                           title: "Test q created by Watir - #{get_timestamp}", 
                                                           details: [{type: :text, content: "Description"}, {type: :product, hint: "d"}])

    conversation_product_name_1 = @community_convcreate_page.conversation_products[0].element(:class => "product-title").when_present.text


    # submit
    @community_convcreate_page.submit(:question)
    @browser.wait_until { @community_conversationdetail_page.conv_content.present? }

    # edit the question
    @community_conversationdetail_page.goto_edit_page

    @community_convedit_page.fill_in_conversation_fields(details: [{type: :product, hint: "m", way: :key}])

    conversation_product_name_2 = @community_convcreate_page.conversation_products[0].element(:class => "product-title").when_present.text

    # submit
    @community_convedit_page.submit(:question)
    @browser.wait_until { @community_conversationdetail_page.conv_content.present? }

    # Don't need to refresh the whole browser to see the Recently Mentioned Products widget updated
    @browser.wait_until($t) { @community_conversationdetail_page.post_content.present? && 
                              @community_conversationdetail_page.recent_mention_prod_list.present? && 
                              !@community_conversationdetail_page.recent_mention_prods_widget_spinner.exists? && 
                              @community_conversationdetail_page.prod_card_placeholders.size == 0}

    create_product_name = @community_conversationdetail_page.product_names_in_root_post[1].when_present.text
    assert create_product_name == conversation_product_name_1, "Create product name not match"
    #when beta feature on there will be double number of product_cards_in_root_post.so the link of 0,1,2,... refer to 0,2,4,... in betaon environment

    @browser.execute_script("window.scrollBy(0,-1000)")

    @community_conversationdetail_page.product_cards_in_root_post[2].link.when_present.click
    @browser.wait_until{ !@browser.windows.find { |w| w.url =~ /#{@c.hybris_url}/ }.nil?}

    @browser.window(:url => /#{@c.hybris_url}/).use do
      create_product_web_page_name = @browser.div(:class => "name").when_present.text
      assert create_product_web_page_name.include?conversation_product_name_1
      @browser.window.close
    end
    #when beta feature on there will be double number of product_cards_in_root_post.so the link of 0,1,2,... refer to 0,2,4,... in betaon environment
    create_product_link = @community_conversationdetail_page.product_cards_in_root_post[2].link.when_present.href

    # create_product_recently_mention_link = @community_conversationdetail_page.recent_mention_prod_list.links[0].when_present.href
    # assert create_product_recently_mention_link == create_product_link, "Create recent product link not match"
    @browser.wait_until($t) { @community_conversationdetail_page.recent_mention_prod_list.link(:href => create_product_link).present? }
    assert @community_conversationdetail_page.recent_mention_prod_list.link(:href => create_product_link).present?
    edit_product_name = @community_conversationdetail_page.product_names_in_root_post[0].when_present.text
    assert edit_product_name == conversation_product_name_2, "Edit Product name not match"
    @community_conversationdetail_page.product_cards_in_root_post[0].link.when_present.click
    @browser.wait_until{ !@browser.windows.find { |w| w.url =~ /#{@c.hybris_url}/ }.nil?}
    
    @browser.window(:url => /#{@c.hybris_url}/).use do
      edit_product_web_page_name = @browser.div(:class => "name").when_present.text
      assert edit_product_web_page_name.include?conversation_product_name_2
      @browser.window.close
    end

    # have to refresh due to bug EN-4386
    @browser.refresh
    @browser.wait_until { @community_conversationdetail_page.conv_content.present? }

    edit_product_link = @community_conversationdetail_page.product_cards_in_root_post[0].link.when_present.href
    # edit_product_recently_mention_link = @community_conversationdetail_page.recent_mention_prod_list.links[1].when_present.href
    # assert edit_product_recently_mention_link == edit_product_link, "Edit recent product link not match - #{edit_product_recently_mention_link} - #{edit_product_link}"

    @browser.wait_until($t) { @community_conversationdetail_page.recent_mention_prod_list.link(:href => edit_product_link).present? }
    assert @community_conversationdetail_page.recent_mention_prod_list.link(:href => edit_product_link).present?
  end

  user :regular_user1
  p1
  def test_00311_b2b_product_card_on_root_post
    @community_topiclist_page.go_to_first_product
    @community_topicdetail_page.create_conversation(type: :question, 
                                                    title: "Test q created by Watir - #{get_timestamp}", 
                                                    details: [{type: :product, hint: "d"}])

    reply_product_name_1 = @community_conversationdetail_page.create_reply :mention_type => "at", :hint => "m"
    reply_product_name_2 = @community_conversationdetail_page.edit_reply :mention_type => "at", :hint => "w"

    # Need to refresh the whole browser to see the Recently Mentioned Products widget updated
    @browser.refresh
    @browser.wait_until($t) { @community_conversationdetail_page.post_content.present? && 
                              @community_conversationdetail_page.recent_mention_prod_list.present? && 
                              !@community_conversationdetail_page.recent_mention_prods_widget_spinner.exists? && 
                              @community_conversationdetail_page.prod_card_placeholders.size == 0}

    reply_product_name = @community_conversationdetail_page.product_names_in_comments.last.when_present.text
    assert reply_product_name == reply_product_name_1, "Create product name not match"

    @hybris_home_page.scroll_to_element @community_conversationdetail_page.reply_dropdown_arrow
    #when beta feature on there will be double number of product_cards_in_root_post.so the link of 0,1,2,... refer to 0,2,4,... in betaon environment
    @community_conversationdetail_page.product_cards_in_comments[-2].link.when_present.click

    @browser.wait_until{ !@browser.windows.find { |w| w.url =~ /#{@c.hybris_url}/ }.nil?}

    @browser.window(:url => /#{@c.hybris_url}/).use do
      reply_product_web_page_name = @browser.div(:class => "name").when_present.text
      assert reply_product_web_page_name.include?reply_product_name_1

      @browser.window.close
    end

    reply_product_text = @community_conversationdetail_page.product_cards_in_comments[-2].link.when_present.text

    reply_product_recently_mention_text = @community_conversationdetail_page.recent_mention_prod_list.when_present.text
    assert reply_product_recently_mention_text.include?reply_product_text

    edit_product_name = @community_conversationdetail_page.product_names_in_comments.first.when_present.text
    assert edit_product_name == reply_product_name_2, "Edit Product name not match"
    @community_conversationdetail_page.product_cards_in_comments.first.link.when_present.click
    @browser.wait_until{ !@browser.windows.find { |w| w.url =~ /#{@c.hybris_url}/ }.nil?}
    @browser.window(:url => /#{@c.hybris_url}/).use do
      edit_product_web_page_name = @browser.div(:class => "name").when_present.text
      assert edit_product_web_page_name.include?reply_product_name_2
      @browser.window.close
    end
    edit_product_text = @community_conversationdetail_page.product_cards_in_comments.first.link.when_present.text
    edit_product_recently_mention_text = @community_conversationdetail_page.recent_mention_prod_list.when_present.text
    assert edit_product_recently_mention_text.include? edit_product_text

  end

end