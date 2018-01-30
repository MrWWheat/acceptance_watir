require 'watir_test'
require 'pages/community/home' 
require 'pages/community/about'
require 'pages/community/topic_list' 
require 'pages/community/topicdetail'
require 'pages/community/conversationdetail'

class SeoTest < WatirTest
  def setup
    super
    @home_page = Pages::Community::Home.new(@config)
    @topiclist_page = Pages::Community::TopicList.new(@config)
    @about_page = Pages::Community::About.new(@config)
    @topicdetail_page = Pages::Community::TopicDetail.new(@config)
    @convdetail_page = Pages::Community::ConversationDetail.new(@config)

    @browser = @config.browser
    @base_url = @config.base_url.chomp('/')
    @gated = @config.gated_community?
  end

  def teardown
    super
  end

  user :anonymous
  p1
  def test_00010_sitemaps_entrypoint
    @browser.goto @base_url + "/robots.txt"

    @browser.wait_until { @browser.ready_state == "complete" }

    if @gated
      assert !@browser.text.include?("Sitemap")
    else
      assert @browser.text.include?("Sitemap: #{@base_url}/sitemaps/conversations0.xml")
      assert @browser.text.include?("Sitemap: #{@base_url}/sitemaps/main.xml")
      assert @browser.text.include?("Sitemap: #{@base_url}/sitemaps/topics0.xml")     
    end  
  end

  def test_00020_sitemaps_main
    sitemap_main_url = "#{@base_url}/sitemaps/main.xml"

    if @gated
      @browser.goto sitemap_main_url
      @browser.wait_until { @browser.ready_state == "complete" }

      assert !@browser.text.include?(@base_url)
    else
      @browser.goto sitemap_main_url
      @browser.wait_until { @browser.ready_state == "complete" }

      main_urls = @browser.text.gsub("\n", '').scan(/<loc>([^<]+)<\/loc>/).flatten
      home_url = main_urls[0]
      topics_url = main_urls[1]
      prods_url = main_urls[2]
      about_url = main_urls[3]

      @browser.goto home_url
      @browser.wait_until { @home_page.homebanner.present? }
      assert @home_page.homebanner.present?

      @browser.goto topics_url
      @browser.wait_until { @topiclist_page.topic_list.present? }
      assert @topiclist_page.topic_list.present?

      @browser.goto prods_url
      @browser.wait_until { @topiclist_page.topic_list.present? }
      assert @topiclist_page.topic_list.present?

      @browser.goto about_url
      @browser.wait_until { @about_page.about_banner.present? }
      assert @about_page.about_banner.present?
    end  
  end
  
  def test_00040_sitemaps_topics
    sitemap_topics_url = "#{@base_url}/sitemaps/topics0.xml"

    if @gated
      @browser.goto sitemap_topics_url
      @browser.wait_until { @browser.ready_state == "complete" }

      assert !@browser.text.include?(@base_url)
    else
      @browser.goto sitemap_topics_url
      @browser.wait_until { @browser.ready_state == "complete" }

      prod_urls = @browser.text.gsub("\n", '').scan(/<loc>([^<]+)<\/loc>/).flatten

      return if prod_urls.size == 0

      prod_urls.each do |prod_url|
        assert prod_url.include?(@base_url), "Invalid product url #{prod_url}"
      end

      test_prod_url = prod_urls[rand(0...prod_urls.size)]

      @browser.goto test_prod_url

      @browser.wait_until { @topicdetail_page.product_detail_banner.present? || @topicdetail_page.topic_filter.present? }
      assert @topicdetail_page.product_detail_banner.present? || @topicdetail_page.topic_filter.present?
    end  
  end

  def test_00050_sitemaps_conversations
    sitemap_convs_url = "#{@base_url}/sitemaps/conversations0.xml"

    if @gated
      @browser.goto sitemap_convs_url
      @browser.wait_until { @browser.ready_state == "complete" }

      assert !@browser.text.include?(@base_url)
    else
      @browser.goto sitemap_convs_url
      @browser.wait_until { @browser.ready_state == "complete" }

      test_conv_url = @browser.element(:css => ".collapsible-content .text").when_present.text

      ## Do not take the following code because Net::ReadTimeout error will happen when too many conversations:
      # conv_urls = @browser.text.gsub("\n", '').scan(/<loc>([^<]+)<\/loc>/).flatten

      # return if conv_urls.size == 0

      # conv_urls.each do |conv_url|
      #   assert conv_url.include?(@base_url), "Invalid product url #{conv_url}"
      # end

      # test_conv_url = conv_urls[rand(0...conv_urls.size)]

      @browser.goto test_conv_url

      @browser.wait_until { @convdetail_page.conv_detail.present? }
      assert @convdetail_page.conv_detail.present?
    end  
  end

  def test_00060_keywords
    @browser.goto @base_url
    if @gated 
      @gated_page.gated_page_link.present?
      @gated_page.gated_page_link.when_present.click

      @login_page = Pages::Community::Login.new(@config)
      @browser.wait_until { @login_page.user_dropdown.present? || @login_page.login_link.present? }
      @login_page.login!(@c.users["network_admin"])
    end

    @topiclist_page.go_to_first_product
    @browser.wait_until { @browser.ready_state == "complete" }
    @browser.wait_until { @topicdetail_page.product_detail_banner.present? }

    @browser.wait_until { @topicdetail_page.product_detail_ld_json.exist? }
    assert @topicdetail_page.product_detail_ld_json.exist?

    prodname_in_script = @topicdetail_page.product_detail_ld_json.attribute_value("text").scan(/\"name\":\"([^\"]+)\",/).flatten[0]
    assert @topicdetail_page.product_detail_banner_title.when_present.text == prodname_in_script
  end

  def test_00070_escaped_fragment
    return if @gated #TODO

    ef_url = "?_escaped_fragment_"

    # check Home page
    @browser.goto @home_page.url + ef_url
    @browser.wait_until { @home_page.homebanner.present? }
    assert !@browser.script.exist?

    # check About page
    @browser.goto @about_page.url + ef_url
    @browser.wait_until { @about_page.about_banner.present? }
    assert !@browser.script.exist?

    # check Products page
    @topiclist_page.navigate_in(:product)
    @browser.goto @topiclist_page.productlist_page_url + ef_url
    assert !@browser.script.exist?
    @topiclist_page.navigate_in(:product)

    # check Product page
    if @topiclist_page.topiccard_list.topic_cards.size > 0
      @topiclist_page.go_to_first_product(false)
      product_url = @browser.url

      @browser.goto @browser.url + ef_url
      @browser.wait_until { @topicdetail_page.product_detail_banner.present? }
      assert !@browser.script(:css => "script:not([type='application/ld+json'])").exist?
      assert @topicdetail_page.product_detail_ld_json.exist?
      prodname_in_script = @topicdetail_page.product_detail_ld_json.attribute_value("text").scan(/\"name\":\"([^\"]+)\",/).flatten[0]
      assert @topicdetail_page.product_detail_banner_title.when_present.text == prodname_in_script

      # check question detail page
      @browser.goto product_url
      @browser.wait_until { @topicdetail_page.topic_filter.present? }

      if @topicdetail_page.questionlist_widget.posts.size > 0
        @topicdetail_page.goto_conversation(type: :question)
        @browser.goto @browser.url + ef_url
        @browser.wait_until { @convdetail_page.conv_detail.present? }
        assert !@browser.script(:css => "script:not([type='application/ld+json'])").exist?
        assert @topicdetail_page.product_detail_ld_json.exist?
        assert @topicdetail_page.product_detail_ld_json.attribute_value("text").scan(/\"name\":\"([^\"]+)\",/).flatten[0] == prodname_in_script
      end
    end 

    # check Topics page
    @topiclist_page.navigate_in(:topic)
    @browser.goto @topiclist_page.url + ef_url
    assert !@browser.script.exist?
    @topiclist_page.navigate_in(:topic)

    # check Topic page
    if @topiclist_page.topiccard_list.topic_cards.size > 0
      @topiclist_page.goto_first_topic
      topic_url = @browser.url

      @browser.goto @browser.url + ef_url
      @browser.wait_until { @topicdetail_page.topic_filter.present? }
      assert !@browser.script.exist?

      # check question detail page
      @browser.goto topic_url
      @browser.wait_until { @topicdetail_page.topic_filter.present? }
      @topicdetail_page.goto_conversation(type: :question)
      @browser.goto @browser.url + ef_url
      @browser.wait_until { @convdetail_page.conv_detail.present? }
      assert !@browser.script.exist?
    end 
  end 
end    