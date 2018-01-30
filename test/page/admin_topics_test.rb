require 'watir_test'
require 'pages/community/admin_topics'
require 'pages/community/admin'
require 'pages/community/topic_list'
require 'pages/community/topicdetail'
class AdminTopicsTest < WatirTest

  def setup
    super
    @admin_topics_page = Pages::Community::AdminTopics.new(@config)
    @layout_page = Pages::Community::Layout.new(@config)
    @community_admin_page = Pages::Community::Admin.new(@config)
    @community_topiclist_page = Pages::Community::TopicList.new(@config)
    @community_topicdetail_page = Pages::Community::TopicDetail.new(@config)
    # assigning @current_page helps error reporting
    #  give good contextual data
    @current_page = @admin_topics_page
    puts "[[[ #{name} ::: #{user_for_test} ]]]" if @config.verbose?
    @browser = @config.browser
    @admin_topics_page.start!(user_for_test)
  end

  def teardown
    super
  end

  user :network_admin

  p1
  def test_00010_create_new_engagement_topic_from_admin_page
    @community_admin_page.navigate_in_from_ui
    @community_admin_page.assert_all_admin_tabs_with_network_admin_capability
    @community_admin_page.switch_to_sidebar_item :topics
    # create topic
    @admin_topics_page.topic_new.when_present.click
    assert @community_topicdetail_page.new_topic_title.present?
    @community_topiclist_page.set_new_topic_details("engagement", false)
    @community_topiclist_page.image_set("filetile")
    @community_topiclist_page.topic_create_steps_after_image_set("filetile")
    @browser.wait_until($t) { @community_topiclist_page.image_upload_link.present? }
    @community_topiclist_page.image_set("filebanner")
    @community_topiclist_page.topic_create_steps_after_image_set("filebanner")
  end

  def test_00020_edit_new_engagement_topic_from_admin_page
    index = @admin_topics_page.get_index_of_certain_title "Watir created topic"
    @admin_topics_page.edit_topic_at_index(index)

    @browser.wait_until { @admin_topics_page.new_topic_title_field.present? }
    assert @admin_topics_page.new_topic_title_field.present?
    # set detail
    @community_topiclist_page.set_new_topic_details("engagement", false)
    @community_topiclist_page.image_set_change("filetile")
    @community_topiclist_page.topic_create_steps_after_image_set("filetile")
    @community_topiclist_page.topic_next_view_button.when_present.click
    @browser.wait_until { @browser.h1(:class => "banner-title").present? }
    @community_topicdetail_page.topic_publish
  end

  def test_00030_click_topic_view_from_admin_page
    @admin_topics_page.view_topic_at_index(0)

    @browser.wait_until { @browser.div(:css => '.container .topic-content').present? }
    assert @browser.div(:css => '.container .topic-content').present?  
  end

  def test_00040_feature_and_unfeature_topic_from_admin_page
    @admin_topics_page.filter_topic_by_tab :not_featured
    if @admin_topics_page.topic_empty_list.present?
      skip
    end
    # feature the topic
    title = @admin_topics_page.topic_title.p.text
    @admin_topics_page.topic_list_feature_icons[0].click
    @browser.wait_until { (@admin_topics_page.topic_feature_icon_at_index(0).when_present.style("color").include? "240, 171, 0") }
    # visible by feature filter
    @admin_topics_page.filter_topic_by_tab :featured
    assert @admin_topics_page.topic_title.text.include? title
    # feature topic visible in topic list page
    @community_topiclist_page.navigate_in

    @browser.wait_until { !@community_topiclist_page.topiccard_list.topic_with_title(title).nil? }
    @browser.wait_until { @community_topiclist_page.topiccard_list.topic_with_title(title).feature_icon.present? }

    # unfeature the topic
    @admin_topics_page.navigate_in
    @admin_topics_page.filter_topic_by_tab :featured
    index = @admin_topics_page.get_index_of_certain_title title
    @admin_topics_page.topic_list_feature_icons[index].click
    @browser.wait_until { !(@admin_topics_page.topic_feature_icon_at_index(index).when_present.style("color").include? "240, 171, 0") }
    #unvisible in feature list
    @admin_topics_page.filter_topic_by_tab :unfeatured
    @browser.wait_until { @admin_topics_page.topic_list_status[1].present? }
    index = @admin_topics_page.get_index_of_certain_title title
    assert index != -1
  end

  def test_00050_filter_topic_from_admin_page
    @admin_topics_page.filter_topic_by_tab :activated
    if @admin_topics_page.topic_list_status.size > 1
      @admin_topics_page.topic_list_status.each do |status|
        assert !(status.attribute_value("innerText").include? "Draft")
      end
    end

    @admin_topics_page.filter_topic_by_tab :deactivated
    if @admin_topics_page.topic_list_status.size > 1
      @admin_topics_page.topic_list_status.each do |status|
        assert !(status.attribute_value("innerText").include? "Active")
      end
    end

    @admin_topics_page.filter_topic_by_tab :featured
    if @admin_topics_page.topic_list_feature_icons.size > 0
      @admin_topics_page.topic_list_feature_icons.each do |icon|
        assert icon.attribute_value("class").include? "icon-favorite"
      end
    end

    @admin_topics_page.filter_topic_by_tab :not_featured
    if @admin_topics_page.topic_list_feature_icons.size > 0
      @admin_topics_page.topic_list_feature_icons.each do |icon|
        assert icon.attribute_value("class").include? "icon-unfavorite"
      end
    end
  end

  def test_00060_show_more_topic_from_admin_page
    begin
      @browser.wait_until(5) { @admin_topics_page.topic_list_show_more_button.present? }
    rescue
      skip
    end
    @admin_topics_page.topic_list_show_more_button.click
    @browser.wait_until { @admin_topics_page.topic_list_feature_icons.size > 20 }
  end

  def test_00070_search_topic_from_admin_page
    @browser.wait_until { @admin_topics_page.admin_topic_search_input.present? }
    @admin_topics_page.admin_topic_search_input.set "watir"
    begin
      @browser.wait_until(5) { @admin_topics_page.topic_list_loading_block.present? }
    rescue
    end
    @browser.wait_until { @admin_topics_page.topic_list_feature_icons[0].present? || @admin_topics_page.topic_empty_list.present? }
    @browser.divs(:class => "topic-title col-md-6").each do |title|
      assert title.text.downcase.include? "watir"
    end
  end
# # skip
#   def test_00080_sorting_topic_from_admin_page
    
#   end

  def test_00080_check_topic_page_content
    assert_all_keys({
      :last_activity => @admin_topics_page.topic_last_activity_at_index(0).present?,
      :topic_feature_icon => @admin_topics_page.topic_feature_icon_at_index(0).present?,
      :topic_image => @admin_topics_page.topic_avatar_at_index(0).present? || 
                      @admin_topics_page.topic_default_avatar_at_index(0).present?,
      :new_topic_button => @admin_topics_page.topic_new.present?,
    })
  end

  def test_00090_activate_and_deactivate_topic
     # create topic
    @admin_topics_page.topic_new.when_present.click
    assert @community_topicdetail_page.new_topic_title.present?
    topicname = @community_topiclist_page.set_new_topic_details("engagement", false)
    @community_topiclist_page.image_set("filetile")
    @community_topiclist_page.topic_create_steps_after_image_set("filetile")
    @browser.wait_until($t) { @community_topiclist_page.image_upload_link.present? }
    @community_topiclist_page.image_set("filebanner")
    @community_topiclist_page.topic_create_steps_after_image_set("filebanner")
    # deactivate the topic
    @community_topicdetail_page.topic_deactivate_button.when_present.click
    @browser.wait_until { @community_topicdetail_page.topic_deactivate_modal1.attribute_value('style') =~ /display: block;/  }
    @community_topicdetail_page.topic_deactivate_confirm.click
    @browser.wait_until { @community_topicdetail_page.topic_activate_button.present? }

    @admin_topics_page.navigate_in
    @admin_topics_page.filter_topic_by_tab :deactivated
    index = @admin_topics_page.get_index_of_certain_title topicname
    assert index != -1
    assert @admin_topics_page.topic_list_status[index + 1].attribute_value("innerText") == "Deactivated"
    # activate the topic
    @admin_topics_page.view_topic_at_index(index)
    @browser.wait_until { @browser.div(:css => '.container .topic-content').present? }
    @community_topicdetail_page.topic_activate_button.when_present.click
    @browser.wait_until { @community_topicdetail_page.topic_deactivate_button.present? }

    @admin_topics_page.navigate_in
    @admin_topics_page.filter_topic_by_tab :activated
    index = @admin_topics_page.get_index_of_certain_title topicname
    assert index != -1
    assert @admin_topics_page.topic_list_status[index + 1].attribute_value("innerText") == "Active"
  end

  def test_00100_saving_draft_of_topic
    @admin_topics_page.topic_new.when_present.click
    assert @community_topicdetail_page.new_topic_title.present?
    topicname = @community_topiclist_page.set_new_topic_details("engagement", false)
    @community_topiclist_page.image_set("filetile")
    @community_topiclist_page.topic_create_steps_after_image_set("filetile")
    @browser.wait_until($t) { @community_topiclist_page.image_upload_link.present? }
    @community_topiclist_page.image_set("filebanner")
    @community_topiclist_page.saving_draft_when_create_topic
    # visible in admin topic list page
    @admin_topics_page.navigate_in
    index = @admin_topics_page.get_index_of_certain_title topicname
    assert index != -1
    assert @admin_topics_page.topic_list_status[index + 1].attribute_value("innerText") == "Draft"
  end

  def test_00120_check_new_topic_button_works
    @admin_topics_page.topic_new.click
    @browser.wait_until { @admin_topics_page.new_topic_title_field.present? }
  ensure
    @admin_topics_page.topic_new_cancel_modal_cleanup!
  end
end
