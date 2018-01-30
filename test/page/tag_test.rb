require 'watir_test'
require 'pages/community/admin'
require 'pages/community/admin_tag'
require 'pages/community/login'
require 'actions/hybris/common'
require 'pages/community/home'
require 'pages/community/topicdetail'
require 'pages/community/layout'
require 'pages/community/searchpage'
require 'pages/community/topic_list'
require 'pages/community/conversationdetail'


class TagTest < WatirTest

  # Called before every test method runs. Can be used
  # to set up fixture information.

  def setup
    super
    @community_admin_page = Pages::Community::Admin.new(@config)
    @community_admin_tags_page = Pages::Community::AdminTags.new(@config)
    @community_login_page = Pages::Community::Login.new(@config)
    @common_actions = Actions::Common.new(@config)
    @community_home_page = Pages::Community::Home.new(@config)
    @community_topic_detail_page = Pages::Community::TopicDetail.new(@config)
    @community_layout_page = Pages::Community::Layout.new(@config)
    @community_search_page = Pages::Community::Search.new(@config)
    @community_topiclist_page = Pages::Community::TopicList.new(@config)
    @community_convdetail_page = Pages::Community::ConversationDetail.new(@config)

    @browser = @c.browser
    @community_home_page.start!(user_for_test)

    @file_import_path = File.expand_path(File.dirname(__FILE__) + "/../../seeds/development/files/import.csv")
  end

  # Called after every test method runs. Can be used to tear
  # down fixture information.

  def teardown
  end


  user :regular_user1
  p1
  def test_00010_normal_user_create_and_search_tags
    create_and_search_tags("tag#{Time.now.utc.to_i}")
  end

  def test_00011_normal_user_create_tags_with_capital
    create_and_search_tags("TaG#{Time.now.utc.to_i}")
  end 

  def test_00011_normal_user_create_tags_with_chinese
    create_and_search_tags("中文Tag#{Time.now.utc.to_i}")
  end

  def test_00011_normal_user_create_tags_with_korean
    create_and_search_tags("안녕하세요Tag#{Time.now.utc.to_i}")
  end 

  def test_00011_normal_user_create_tags_with_jp
    create_and_search_tags("こんにちはTag#{Time.now.utc.to_i}")
  end 

  def create_and_search_tags(tag)
    topicdetail_page = @community_topiclist_page.go_to_topic("A Watir Topic")

    # create a question with tag mentioned
    title = "test tag#{Time.now.utc.to_i}"
    topicdetail_page.create_conversation(title: title, details: [{type: :tag, content: tag}])

    @community_convdetail_page.tag_link.when_present.click

    assert @community_search_page.results_searched_out?(keyword: title, exact_match: true), "Tag title not match #{title}"

    @community_home_page.navigate_in

    @community_layout_page.search_at_topnav("##{tag}")

    assert @community_search_page.results_searched_out?(keyword: title, exact_match: true), "Tag title not match #{title}"
  end 

  user :network_admin
  p1
  def test_00020_admin_new_tag_and_clear_and_import
    @community_admin_tags_page.navigate_in
    @community_admin_tags_page.input_tags("tag1,tag2,test tag")
    @community_admin_tags_page.tag_newtag_clear_button.when_present.click
    assert @community_admin_tags_page.tag_newtag_type.value == "", "Unable to clear the input"

    tag_toimport = "csvtag1"
    @community_admin_tags_page.import_tags(@file_import_path)
    assert @browser.div(:id => "tags-list").text.include?(tag_toimport), "csv import error"
    @community_admin_tags_page.filter_tags (tag_toimport)

    assert @community_admin_tags_page.taglist_first_tag.text.include?(tag_toimport), "Error with search results"
    # Design Change: cannot delete tag anymore
    # @community_admin_tags_page.delete_presented_all_tags ("csvtag1")
    # @browser.wait_until { @community_admin_tags_page.no_tag.present? }
    # assert @community_admin_tags_page.no_tag.present?, "Delete error"
  end

  # TODO: This case can be executed in chrome for now.
  user :network_admin
  p2
  def test_00021_admin_download_tags_file
    @community_admin_tags_page.navigate_in

    file_entries_before_download = Dir.entries(@config.download_dir)

    @community_admin_tags_page.download_file

    downloaded_file = wait_file_download(@config.download_dir, file_entries_before_download, "tags-#{@c.slug}", wait_time=30)

    assert !downloaded_file.nil?, "Cannot find the file downloaded"

    arr = []
    File.open(downloaded_file).read.each_line do |line|
      arr << line
    end
    text = arr[0][1,arr[0].length-2]
    assert @community_admin_tags_page.tag.text.include?(text), "csv download error"
  ensure 
    File.delete(downloaded_file) unless downloaded_file.nil?
  end

  user :network_admin
  p1
  def test_00030_admin_create_and_filter_and_delete_all_tags
    @community_admin_tags_page.navigate_in
    tagcontent_1 = "tag#{Time.now.utc.to_i}"
    @community_admin_tags_page.create_tags(tagcontent_1)
    @community_admin_tags_page.filter_tags (tagcontent_1)

    assert @community_admin_tags_page.taglist_first_tag.text.include?(tagcontent_1), "Error with search results"
    # Design Change: cannot delete tag anymore
    # @community_admin_tags_page.delete_presented_all_tags (tagcontent_1)
    # @browser.wait_until { @community_admin_tags_page.no_tag.present? }
    # assert @community_admin_tags_page.no_tag.present?, "Delete error"
  end
end
