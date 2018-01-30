require 'watir_test'
require 'pages/community/admin'
require 'pages/community/about'
require 'pages/community/layout'
require 'pages/community/topic_list'
require 'pages/community/conversationdetail'
require 'pages/community/admin_profanity_blocker'
class AdminProfanityBlockerTest < WatirTest

  def setup
    super
   # @about_page = Pages::Community::About.new(@config)
   # @admin_page = Pages::Community::Admin.new(@config)
   # @layout_page = Pages::Community::Layout.new(@config)
    @admin_pb_page = Pages::Community::AdminProfanityBlocker.new(@config)
    @convdetail_page = Pages::Community::ConversationDetail.new(@config)
    @topicdetail_page = Pages::Community::TopicDetail.new(@config)
    @topiclist_page = Pages::Community::TopicList.new(@config)
    @topic_name = "A Watir Topic"
    # assigning @current_page helps error reporting
    #  give good contextual data
    @current_page = @admin_pb_page
    puts "[[[ #{name} ::: #{user_for_test} ]]]" if @config.verbose?
    @browser = @config.browser
    @admin_pb_page.start!(user_for_test)
  end

  def teardown
    super
  end

  p1

  user :network_admin
  def test_00010_enable_profanity_blocker
    @admin_pb_page.enable_profanity_blocker($networkslug, true)
    #check community post
    title_before = "watir test profanity blocker - #{get_timestamp}"

    @topicdetail_page = @topiclist_page.go_to_topic(@topic_name)
    @topicdetail_page.create_conversation(type: :question, 
                                          title: title_before, 
                                          details: [{type: :text, content: title_before}])

    title_after = title_before.gsub("profanity blocker", "********* *******")
    assert @convdetail_page.conv_title.when_present.text == title_after
    assert @convdetail_page.conv_des.when_present.text == title_after

    # comment_root_post
    # reply_to_comment
    # #check hybris post
    # create_post_from_hybris
  end

  user :network_admin
  def test_00020_disable_profanity_blocker
    @admin_pb_page.enable_profanity_blocker($networkslug, false)
    title_before = "watir test profanity blocker - #{get_timestamp}"
    @topicdetail_page = @topiclist_page.go_to_topic(@topic_name)
    @topicdetail_page.create_conversation(type: :question, 
                                          title: title_before, 
                                          details: [{type: :text, content: title_before}])

    unless @convdetail_page.conv_title.when_present.text == title_before
      # sometimes, the profanity bocker doesn't take effect
      @browser.refresh
      @browser.wait_until { @convdetail_page.conv_content.present? }
    end  

    assert @convdetail_page.conv_title.when_present.text == title_before
    assert @convdetail_page.conv_des.when_present.text == title_before
  end

end