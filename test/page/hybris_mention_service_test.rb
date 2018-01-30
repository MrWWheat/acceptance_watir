require 'watir_test'
require 'pages/hybris/home'
require 'pages/hybris/detail'
require 'pages/community'
require 'pages/community/home'
require 'pages/community/topic_list'
require 'pages/community/topicdetail'
require 'pages/community/conversationdetail'
require 'actions/hybris/common'
require 'pages/community/searchpage'
require 'pages/community/admin'
require 'pages/community/admin_tag'

class HybrisAtMention < WatirTest

  def setup
    super
    @hybris_home_page = Pages::Hybris::Home.new(@config)
    @hybris_detail_page = Pages::Hybris::Detail.new(@config)
    @community_page = Pages::Community.new(@config)
    @community_home_page = Pages::Community::Home.new(@config)
    @community_topiclist_page = Pages::Community::TopicList.new(@config)
    @community_topicdetail_page = Pages::Community::TopicDetail.new(@config)
    @community_convcreate_page = Pages::Community::ConversationCreate.new(@config)
    @community_convedit_page = Pages::Community::ConversationEdit.new(@config)
    @community_conversationdetail_page = Pages::Community::ConversationDetail.new(@config)
    @community_search_page = Pages::Community::Search.new(@config)
    @community_admin_page = Pages::Community::Admin.new(@config)
    @community_admin_tags_page = Pages::Community::AdminTags.new(@config)

    @common_actions = Actions::Common.new(@config)
    # @current_page = @hybris_search_page
    puts "[[[ #{name} ::: nil ]]]" if @config.verbose?
    @browser = @c.browser
    @community_home_page.start!(user_for_test)
    @tag1 = nil
    @tag2 = nil
  end

  def teardown
    super
    # @community_page.about_login("network_admin","logged")
    # if @tag1 != nil
    #   @community_admin_page.navigate_in
    #   @community_admin_page.switch_to_sidebar_item(:tags)
    #   @community_admin_tags_page.filter_tags(@tag1.delete "#")
    #   sleep(3)
    #   @community_admin_tags_page.delete_presented_all_tags(@tag1.delete "#")
    # end
    # if @tag2 != nil
    #   @community_admin_page.navigate_in
    #   @community_admin_page.switch_to_sidebar_item(:tags)
    #   @community_admin_tags_page.filter_tags(@tag2.delete "#")
    #   sleep(3)
    #   @community_admin_tags_page.delete_presented_all_tags(@tag2.delete "#")
    # end
  end

  user :regular_user1
  p1
  def test_00010_at_mention_in_root_post
    @community_topiclist_page.go_to_first_product
    # create a new question
    @community_topicdetail_page.goto_conversation_create_page(:question)
    @community_convcreate_page.fill_in_conversation_fields(type: :question, 
                                                           title: "Test q created by Watir - #{get_timestamp}", 
                                                           details: [{type: :text, content: "Description"}, {type: :product, hint: "d", way: :icon}])
    # get the product card name
    conversation_product_name_1  = @community_convcreate_page.conversation_products[0].element(:class => "product-title").when_present.text
    # submit
    @community_convcreate_page.submit(:question)
    @browser.wait_until { @community_conversationdetail_page.conv_content.present? }

    # edit the question to add a new product card
    @community_conversationdetail_page.goto_edit_page
    @community_convedit_page.fill_in_conversation_fields(details: [{type: :product, hint: "m", way: :key}])

    conversation_product_name_2 = @community_convedit_page.conversation_products[0].element(:class => "product-title").when_present.text
    # submit
    @community_convedit_page.submit(:question)
    @browser.wait_until { @community_conversationdetail_page.conv_content.present? }

    # Don't need to refresh the whole browser to see the Recently Mentioned Products widget updated
    @browser.wait_until($t) { @community_conversationdetail_page.post_content.present? &&
                              # @community_conversationdetail_page.recent_mention_prod_list.present? &&
                              !@community_conversationdetail_page.recent_mention_prods_widget_spinner.exists? && 
                              @community_conversationdetail_page.prod_card_placeholders.size == 0}                                                      
    create_product_name = @community_conversationdetail_page.product_names_in_root_post[1].when_present.when_present.text
    assert create_product_name == conversation_product_name_1, "Create product name not match"
    @browser.execute_script("window.scrollBy(0,-1000)")

    @community_conversationdetail_page.product_cards_in_root_post[2].link.when_present.click
    @browser.wait_until{ !@browser.windows.find { |w| w.url =~ /#{@c.hybris_url}/ }.nil?}

    @browser.window(:url => /#{@c.hybris_url}/).use do
      create_product_web_page_name = @browser.div(:class => "name").when_present.text
      assert create_product_web_page_name.include? conversation_product_name_1
      @browser.window.close
    end
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
      assert edit_product_web_page_name.include? conversation_product_name_2
      @browser.window.close
    end

    edit_product_link = @community_conversationdetail_page.product_cards_in_root_post[0].link.when_present.href
    # edit_product_recently_mention_link = @community_conversationdetail_page.recent_mention_prod_list.links[1].when_present.href
    # assert edit_product_recently_mention_link == edit_product_link, "Edit recent product link not match - #{edit_product_recently_mention_link} - #{edit_product_link}"
    @browser.wait_until($t) { @community_conversationdetail_page.recent_mention_prod_list.link(:href => edit_product_link).present? }
    assert @community_conversationdetail_page.recent_mention_prod_list.link(:href => edit_product_link).present?
  end

  user :regular_user1
  p1
  def test_00020_at_mention_in_reply
    @community_topiclist_page.go_to_first_product
    @community_topicdetail_page.create_conversation(type: :question, 
                                                    title: "Test q created by Watir - #{get_timestamp}", 
                                                    details: [{type: :product, hint: "d"}])

    reply_product_name_1 = @community_conversationdetail_page.create_reply :mention_type => "at", :hint => "m", :mention_way => "key"
    reply_product_name_2 = @community_conversationdetail_page.edit_reply :mention_type => "at", :hint => "w", :mention_way => "icon"
    
    # Need to refresh the whole browser to see the Recently Mentioned Products widget updated
    @browser.refresh
    @browser.wait_until($t) { @community_conversationdetail_page.post_content.present? && 
                              # @community_conversationdetail_page.recent_mention_prod_list.present? &&
                              !@community_conversationdetail_page.recent_mention_prods_widget_spinner.exists? && 
                              @community_conversationdetail_page.prod_card_placeholders.size == 0}
    reply_product_name = @community_conversationdetail_page.product_names_in_comments.last.when_present.text
    assert reply_product_name == reply_product_name_1, "Create product name not match"
    @hybris_home_page.scroll_to_element @community_conversationdetail_page.reply_dropdown_arrow
    @community_conversationdetail_page.product_cards_in_comments[-2].link.when_present.click
    @browser.wait_until{ !@browser.windows.find { |w| w.url =~ /#{@c.hybris_url}/ }.nil?}

    @browser.window(:url => /#{@c.hybris_url}/).use do
      reply_product_web_page_name = @browser.div(:class => "name").when_present.text
      assert reply_product_web_page_name.include? reply_product_name_1
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
      assert edit_product_web_page_name.include? reply_product_name_2
      @browser.window.close
    end
    edit_product_text = @community_conversationdetail_page.product_cards_in_comments.first.link.when_present.text
    edit_product_recently_mention_text = @community_conversationdetail_page.recent_mention_prod_list.when_present.text
    assert edit_product_recently_mention_text.include? edit_product_text

  end
  user :regular_user1
  p1
  def test_00030_tag_in_root_post
    @community_topiclist_page.go_to_first_product
    @community_topicdetail_page.create_conversation(type: :question, 
                                                    title: "Test q created by Watir - #{get_timestamp}", 
                                                    details: [{type: :tag, hint: "d", way: :icon}])
    con_url = @browser.url
    @tag1 = @community_conversationdetail_page.tag_link.text
    @community_conversationdetail_page.tag_link.when_present.click
    # @browser.wait_until { @community_search_page.search_result_page.present? }
    assert @community_search_page.results_searched_out?(keyword: @tag1, match_content: :details, timeout: 5*60)
    assert @community_search_page.results_keyword.text.include? @tag1
    # assert @community_search_page.search_result_posts[0].text.include? @tag1.delete("#")

    @browser.goto con_url
    @community_conversationdetail_page.edit_conversation(details: [{type: :tag, content: "tag#{Time.now.utc.to_i}", way: :key}])

    @browser.wait_until($t) { @community_conversationdetail_page.post_content.present? &&
        @community_conversationdetail_page.prod_card_placeholders.size == 0}
    @tag2 = @community_conversationdetail_page.tag_link.text

    @browser.execute_script("window.scrollBy(0,-1000)")

    @community_conversationdetail_page.tag_link.when_present.click
    # @browser.wait_until { @community_search_page.search_result_page.present? }
    assert @community_search_page.results_searched_out?(keyword: @tag2, match_content: :details, timeout: 10*60), "Cannot search out #{@tag2} after 10 minutes"
    assert @community_search_page.results_keyword.text.include? @tag2
    # assert @community_search_page.search_result_posts[0].text.include? @tag2.delete("#")
  end

  user :regular_user1
  p1
  def test_00040_tag_in_reply
    @community_topiclist_page.go_to_first_product
    @community_topicdetail_page.create_conversation(type: :question, 
                                                    title: "Test q created by Watir - #{get_timestamp}", 
                                                    details: [{type: :product, hint: "d"}])

    @community_conversationdetail_page.create_reply :mention_type => "tag", :mention_way => "key"
    @browser.wait_until {@community_conversationdetail_page.conv_content.present?}
    con_url = @browser.url
    # @tag1 = @community_conversationdetail_page.tag_link.text
    # @community_conversationdetail_page.tag_link.when_present.click
    # @browser.wait_until { @community_search_page.search_result_page.present? }
    # assert @community_search_page.results_keyword.text.include? @tag1
    # assert @community_search_page.search_result_posts[0].text.include? @tag1.delete("#")
    #blocked by EN-2621

    @browser.goto con_url
    @community_conversationdetail_page.edit_reply :mention_type => "tag", :mention_way => "icon", :hint => "d"
    @browser.wait_until($t) { @community_conversationdetail_page.post_content.present? &&
        @community_conversationdetail_page.prod_card_placeholders.size == 0 &&
    #     @community_conversationdetail_page.tag_links[1].present? }
    # @tag2 = @community_conversationdetail_page.tag_links[1].text
    # @community_conversationdetail_page.tag_links[1].when_present.click
    #changed by EN-2621

        @community_conversationdetail_page.tag_links[0].present? }
    @tag2 = @community_conversationdetail_page.tag_links[0].text
    @community_conversationdetail_page.tag_links[0].when_present.click
    skip "Blocked by bug EN-2990"
    # @browser.wait_until { @community_search_page.search_result_page.present? }
    assert @community_search_page.results_searched_out?(keyword: @tag2, match_content: :details)
    assert @community_search_page.results_keyword.text.include? @tag2
    # assert @community_search_page.search_result_posts[0].text.include? @tag2.delete("#")
  end

  user :regular_user1
  p1
  def test_00050_mention_tooltip_check
    #check tooltip in creating root post
    @community_topiclist_page.go_to_first_product
    @community_topicdetail_page.goto_conversation_create_page(:question)
    @browser.execute_script("window.scrollBy(0,400)")
    @community_convcreate_page.mention_prod_icon.when_present.click
    sleep 2
    @community_convcreate_page.mention_blue_tooltip_close_btn.when_present.click
    sleep 2
    @community_convcreate_page.mention_prod_icon.when_present.hover
    @browser.wait_until{ @community_convcreate_page.mention_prod_icon_tooltip.present?}
    assert @community_convcreate_page.mention_prod_icon_tooltip.text == "@mention a product in your post"
    @community_convcreate_page.mention_tag_icon.when_present.hover
    @browser.wait_until{ @community_convcreate_page.mention_tag_icon_tooltip.present?}
    assert @community_convcreate_page.mention_tag_icon_tooltip.text == "Add a tag"

    #check tooltip in creating reply
    @community_convcreate_page.fill_in_fields_then_submit_conversation(type: :question, 
                                                    title: "Test q created by Watir - #{get_timestamp}", 
                                                    details: [{type: :product, hint: "d"}])
    @browser.wait_until { @community_conversationdetail_page.conv_content.present? }
    @browser.wait_until { @community_conversationdetail_page.reply_text_field.present? }
    @community_conversationdetail_page.scroll_to_element @community_conversationdetail_page.reply_text_field
    @browser.execute_script("window.scrollBy(0,-200)")
    @community_conversationdetail_page.reply_text_field.when_present.click
    sleep 1 # sometimes, hover later doesn't work without this sleep
    @browser.wait_until { @community_conversationdetail_page.tooltip_mention_btns[0].present? }
    @community_conversationdetail_page.scroll_to_element @community_conversationdetail_page.tooltip_mention_btns[0]
    @browser.execute_script("window.scrollBy(0,-200)")
    @community_conversationdetail_page.tooltip_mention_btns[0].when_present.hover
    @browser.wait_until{ @community_conversationdetail_page.mention_tooltips[0].present?}
    assert @community_conversationdetail_page.mention_tooltips[0].text == "@mention a product in your reply"
    @community_conversationdetail_page.scroll_to_element @community_conversationdetail_page.tooltip_tag_btns[0]
    @browser.execute_script("window.scrollBy(0,-200)")
    @community_conversationdetail_page.tooltip_tag_btns[0].when_present.hover
    @browser.wait_until{ @community_conversationdetail_page.mention_tooltips[1].present?}
    assert @community_conversationdetail_page.mention_tooltips[1].text == "Add a tag"

    #check tooltip in livechat
    @community_conversationdetail_page.scroll_to_element @community_conversationdetail_page.livechat_link
    @browser.execute_script("window.scrollBy(0,-400)")
    @community_conversationdetail_page.livechat_link.when_present.click
    @browser.wait_until{ @community_conversationdetail_page.livechat_sender.present?}
    @community_conversationdetail_page.tooltip_mention_btns[1].when_present.hover
    @browser.wait_until{ @community_conversationdetail_page.mention_tooltips[2].present?}
    assert @community_conversationdetail_page.mention_tooltips[2].text == "@mention a product in your chat"
    @community_conversationdetail_page.tooltip_tag_btns[1].when_present.hover
    @browser.wait_until{ @community_conversationdetail_page.mention_tooltips[3].present?}
    assert @community_conversationdetail_page.mention_tooltips[3].text == "Add a tag"
  end

end