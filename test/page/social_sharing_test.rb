require 'watir_test'
require 'pages/community'
require 'pages/community/home'
require 'pages/community/topic_list'
require 'pages/community/topicdetail'
require 'pages/community/conversationdetail'
require 'pages/community/social_sharing'
require 'httparty'
require 'cgi'
require 'nokogiri'

class SocialSharingTest < WatirTest

  def setup
    super
    @community_home_page = Pages::Community::Home.new(@config)
    @community_topic_list_page = Pages::Community::TopicList.new(@config)
    @community_topic_detail_page = Pages::Community::TopicDetail.new(@config)
    @community_conversationdetail_page = Pages::Community::ConversationDetail.new(@config)
    @community_social_sharing_page = Pages::Community::SocialSharing.new(@config)

    @browser = @c.browser
    @community_home_page.start!(user_for_test)
    
    @community_topic_list_page.go_to_first_product
    @post_title = "test social sharing of - #{get_timestamp}"
    @post_description = "description - #{get_timestamp}"
    @community_topic_detail_page.create_conversation(title: @post_title, details: [{type: :text, content: @post_description}])
    @browser.wait_until { @community_conversationdetail_page.root_post_title.present? }

  end

  def teardown
    super
  end

  user :regular_user1

  def test_00010_facebook_sharing
    @community_conversationdetail_page.facebook_sharing_button.when_present.click
    @community_social_sharing_page.social_sharing :facebook, @post_title

    skip "Blocked by bug EN-4397"
    #check count
    @browser.wait_until{ @community_conversationdetail_page.facebook_sharing_button.present? }
    conversation_url = @browser.url
    check_share_count :facebook, conversation_url

    # comment the following codes since it is unstable due to dependence on third-party sites
    # @community_social_sharing_page.social_sharing_check :facebook
    # assert @community_social_sharing_page.facebook_first_post_content.text.include?(@post_title), "facebook sharing content not match"
    # assert @community_social_sharing_page.facebook_post_image.present?
    # @community_social_sharing_page.social_post_delete :facebook
  end

  def test_00020_twitter_sharing
    @community_conversationdetail_page.twitter_sharing_button.when_present.click
    @community_social_sharing_page.social_sharing :twitter, @post_title

    #check count
    @browser.wait_until{ @community_conversationdetail_page.twitter_sharing_button.present? }
    conversation_url = @browser.url
    check_share_count :twitter, conversation_url

    # comment the following codes since it is unstable due to dependence on third-party sites
    # @community_social_sharing_page.social_sharing_check :twitter
    # @browser.refresh
    # assert @community_social_sharing_page.twitter_post_title.text == @post_title, "twitter sharing title not match"
    # @browser.wait_until($t){ @community_social_sharing_page.twitter_post_product_card.present? }
    # assert @community_social_sharing_page.twitter_post_product_card.present?
    # @community_social_sharing_page.social_post_delete :twitter
  end

  def test_00030_linkedin_sharing
    @community_conversationdetail_page.linkedin_sharing_button.when_present.click
    @community_social_sharing_page.social_sharing :linkedin, @post_title

    #check count
    @browser.wait_until{ @community_conversationdetail_page.linkedin_sharing_button.present? }
    conversation_url = @browser.url
    check_share_count :linkedin, conversation_url

    # comment the following codes since it is unstable due to dependence on third-party sites
    # @community_social_sharing_page.social_sharing_check :linkedin
    # assert !@community_social_sharing_page.linkedin_no_product_img.present?
    # assert @community_social_sharing_page.linkedin_post_title.text == @post_title, "linkedin sharing title not match"
    # assert @c.base_url.include? (@community_social_sharing_page.linkedin_post_sitelink.text)
    # @community_social_sharing_page.social_post_delete :linkedin
  end

  def test_00040_google_sharing
    @community_conversationdetail_page.google_sharing_button.when_present.click
    @browser.wait_until { @browser.window(:url => /google.com/).present? }
    # comment the following codes since it is unstable due to dependence on third-party sites
    # @community_social_sharing_page.social_sharing :google, @post_title

    #check count
    # @browser.wait_until{ @community_conversationdetail_page.google_sharing_button.present? }
    # conversation_url = @browser.url
    # check_share_count :google, conversation_url
  end  

  def test_00001_url_check
    url = @browser.url + '?_escaped_fragment_=true'
    @browser.goto url
    @browser.wait_until { @community_conversationdetail_page.root_post_title.present? }
    assert @community_conversationdetail_page.root_post_title.text == @post_title, "title not match"
  end

  def check_share_count social_media, conversation_url
    config = {:http_proxyaddr => "proxy.wdf.sap.corp", :http_proxyport => 8080}
    share_count_api = nil
    share_url = nil
    sleep 10 # need to wait some time to see the count change
    # refresh to check updated UI
    @community_conversationdetail_page.user_check_post_by_url(conversation_url)
    if social_media == :facebook
      share_count_ui = @community_conversationdetail_page.facebook_sharing_button.when_present.text.to_i
      url = "https://graph.facebook.com/#{CGI.escape(conversation_url)}"
      response = HTTParty.get(url,config)
      if response["error"] == nil
        share_count_api = response["share"]["share_count"]
        share_url = response["id"]
      else
        puts "facebook api call fail"
        share_count_api = share_count_ui
        share_url = conversation_url
      end
    elsif social_media == :twitter
      share_count_ui = @community_conversationdetail_page.twitter_sharing_button.when_present.text.to_i
      url = "https://opensharecount.com/count.json?url=#{CGI.escape(conversation_url)}"
      response = HTTParty.get(url,config)
      share_count_api = response["count"]
      share_url = response["url"]
    elsif social_media == :linkedin
      share_count_ui = @community_conversationdetail_page.linkedin_sharing_button.when_present.text.to_i
      url = "https://www.linkedin.com/countserv/count/share?url=#{CGI.escape(conversation_url)}&format=json"
      response =  HTTParty.get(url,config)
      share_count_api = response["count"]
      share_url = response["url"]
    elsif social_media == :google
      share_count_ui = @community_conversationdetail_page.google_sharing_button.when_present.text.to_i
      url = "https://plusone.google.com/_/+1/fastbutton?url=#{CGI.escape(conversation_url)}"
      response =  HTTParty.get(url,config)
      page = Nokogiri::HTML(response)
      share_count_api = page.css("div#aggregateCount")[0].text.to_i
      share_url = conversation_url
    end
    assert_equal share_count_api, share_count_ui, "share count doesn't match"
    assert share_url == conversation_url    
  end

end