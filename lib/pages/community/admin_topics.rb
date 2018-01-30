require 'pages/community/admin'
require 'pages/community/home'

class Pages::Community::AdminTopics < Pages::Community::Admin

  def initialize(config, options = {})
    super(config)
    @url = config.base_url + "/admin/#{@config.slug}/topics"
  end

  def start!(user)
    # login starting from Home page
    @home_page = Pages::Community::Home.new(@config)
    @home_page.start!(user)

    navigate_in
  end

  def navigate_in
    @browser.goto @url

    @browser.wait_until($t) { admin_topics_content.present? }
    @browser.wait_until($t) { topic_last_activity_at_index(0).present? } 
    accept_policy_warning
  end 

  def topic_edit_cancel_modal_cleanup!
    if cancel_existing_topic_button.present?
      cancel_existing_topic_button.click
      @browser.wait_until { @browser.div(:css => '.modal-content').present? }
      @browser.wait_until { @browser.div(:css => '.modal-content').button(:text => /Cancel Topic Edit/).present? }
      @browser.div(:css => '.modal-content').button(:text => /Cancel Topic Edit/).click
      @browser.wait_until { !@browser.div(:css => '.modal-content').present? }
      @browser.wait_until { !@browser.div(:css => ".modal-backdrop.fade").present? }
    end
  ensure
    clean_up_modals!
  end

  def topic_new_cancel_modal_cleanup!
    if new_topic_cancel.present?
      new_topic_cancel.click
      @browser.wait_until { @browser.div(:css => '.modal-content').present? }
      @browser.wait_until { @browser.div(:css => '.modal-content').button(:text => /Cancel New Topic/).present? }
      @browser.div(:css => '.modal-content').button(:text => /Cancel New Topic/).click
      @browser.wait_until { !@browser.div(:css => '.modal-content').present? }
      @browser.wait_until { !@browser.div(:css => ".modal-backdrop.fade").present? }
    end
  ensure
    clean_up_modals!
  end

  def topic_item_css_at_index(index)
    ".content-wrapper .shown .topics-table-body:nth-child(#{index+1})"
  end

  # def topic_item_action_btn_css_at_index(index)
  #   topic_item_css_at_index(index) + " .topic-action-drop-down button.dropdown-toggle"
  # end

  def topic_item_edit_action_css_at_index(index)
    topic_item_css_at_index(index) + " .topic-title .actions span:nth-of-type(1) a"
  end

  def topic_item_view_action_css_at_index(index)
    topic_item_css_at_index(index) + " .topic-title .actions span:nth-of-type(3) a"
  end

  def topic_feature_icon_at_index(index)
    @browser.span(:css => topic_item_css_at_index(index) + " .feature-icon span")
  end

  def topic_last_activity_at_index(index)
    @browser.span(:css => topic_item_css_at_index(index) + " .topic-footer-label")
  end  

  def topic_avatar_at_index(index)
    @browser.img(:css => topic_item_css_at_index(index) + " .favorite-icon-item img")
  end

  def topic_default_avatar_at_index(index)
    @browser.div(:css => topic_item_css_at_index(index) + " .favorite-icon-item .topic-list-no-avatar")
  end  

  def edit_topic_at_index(index)
    @browser.link(:css => topic_item_edit_action_css_at_index(index)).when_present.click
  end

  def view_topic_at_index(index)
    @browser.link(:css => topic_item_view_action_css_at_index(index)).when_present.click
  end  

  def filter_topic_by_tab(tab)
    admin_topics_list_filter_button.when_present.click
    @browser.wait_until {topic_list_activated_link.present? }
    case tab
    when :activated
     topic_list_activated_link.click
    when :deactivated
     topic_list_deactivated_link.click
    when :featured
     topic_list_fetured_link.click
    when :not_featured
     topic_list_not_fetured_link.click
    end
    @browser.wait_until { topic_list_status[1].present? || topic_empty_list.present? }
  end

  def get_index_of_certain_title(title)
    index = -1
    topic_titles.each do |item|
      if item.text.include? title
        break
      end
      index += 1
    end
    index == (topic_titles.size - 1) ? -1 : (index + 1)
  end

  admin_topics_content        { div(:css => ".content-wrapper .shown .topics-table-body") }
  #topic_edit                  { div(:class => "col-md-2 topic-admin-actions", :index => 7).link(:text => "Edit") }

  topic_title          { div( :class => "topic-title col-md-6") }
  topic_titles         { divs(:class => "topic-title col-md-6") }
  # topic_last_activity  { span(:class => "topic-footer-label") }
  # topic_feature_icon   { div(:class => "col-md-3 feature-icon") }
  topic_img            { div(:class => "col-md-9").link(:class => "ember-view").img }
  topic_no_img         { div(:class => "col-md-9").link(:class => "ember-view").div(:class => "topic-list-no-avatar") }
  # topic_edit           { div(:class => "col-md-2 topic-admin-actions", :index => 7).link(:text => "Edit") }
  # topic_view           { div(:class => "col-md-2 topic-admin-actions").link(:class => "ember-view", :text => "View") }
  topic_new            { link(:text => "+ New Topic") }

  new_topic_title_field                { text_field(:id => "new-topic-title") }
  new_topic_desc                       { text_field(:id => "topic-caption-input") }
  new_topic_browse                     { link(:text => "browse") }
  new_topic_tile_banner_file           { file_field(:class => "files") }
  new_topic_img_cropper                { div(:class => "cropper-canvas") }
  new_topic_img_select_button          { button(:class => "btn btn-primary btn-sm file-upload-select-button", :text => "Select Photo") }
  new_topic_tile_selected_img          { div(:class => "ember-view uploader-component topic-tile-upload") }
  #new_topic_banner_selected_img        { div(:class => "ember-view uploader-component widget banner normal topic") }
  new_topic_tile_banner_change_button  { button(:class => "btn btn-default", :text => "Change Photo") }
  new_topic_tile_banner_delete_button  { button(:class => "btn btn-default", :text => "Delete Photo") }
  new_topic_default_topictype          { div(:class => "topic-type-selection-box engagement chosen") }
  new_topic_eng_topictype              { div(:class => "topic-type-selection-box engagement") }
  new_topic_eng_chosen                 { div(:class => "topic-type-selection-box support chosen", :text => /Engagement/) }
  new_topic_sup_topictype              { div(:class => "topic-type-selection-box support", :text => /Q&A/) }
  new_topic_sup_chosen                 { div(:class => "topic-type-selection-box support chosen", :text => /Q&A/) }
  advertise_check                      { div(:text => /Enable advertising/).input(:class => "ember-view ember-checkbox") }
  new_topic_next_design_button         { button(:class => "btn btn-primary", :text => /Next: Design/) }
  new_topic_next_design_page           { div(:class => "row topic-create-title") }
  topic_type_text                      { div(:class => "topic-type-text") }
  design_side_zone                     { div(:class => "widget-container col-lg-4 col-md-3 side zone") }
  new_topic_banner_selected_img        { div(:class => "ember-view uploader-component widget banner normal topic") }
  next_view_topic_button               { button(:class => "btn btn-primary", :text => /Next: View Topic/) }
  activate_topic_button                { button(:class => "btn btn-primary", :text => /Activate Topic/) }
  edit_topic_button                    { button(:class => "btn btn-default", :text => /Edit Topic/) }
  deactivate_topic_button              { link(:class => "btn btn-default", :text => "Deactivate Topic") }
  feature_topic_button                 { button(:class => "btn btn-default", :text => "Feature Topic") }
  new_topictitle                       { div(:class => "row title") }
  #ad_banner                            { div(:id => "ads_banner") }
  #ad_side                              { div(:id => "ads_side") }

  topic_popular_disc_widget       { div(:class => "widget popular_discussions") }
  topic_popular_answer_widget     { div(:class => "widget popular_answers") }
  pop_disc_widget                 { div(:class => "widget popular_discussions") }
  pop_ans_widget                  { div(:class => "widget popular_answers") }
  ad_banner                       { div(:id => "ads_banner") }
  ad_side                         { div(:id => "ads_side") }

  new_topic_cancel                { div(:class => "col-md-1").link(:text => "Cancel") }
  cancel_existing_topic_button    { div(:class => "modal-content").button(:text => "Cancel Topic Edit") }
  cancel_new_draft_topic_button   { div(:class => "modal-content").button(:text => "Cancel New Topic") }
  topic_no_avatar_img             { div(:class => "topic-list-no-avatar") }
  cancel_new_topic_footer         { div(:class => "modal-content") }


  admin_topic_search_input        { text_field(:css => ".admin-search-input input")}
  admin_topics_list_filter_button { button(:id => "admin-topics-list-filter")}
  topic_list_all_link             { link(:text => "All")}
  topic_list_activated_link       { link(:text => "Activated")}
  topic_list_deactivated_link     { link(:text => "Deactivated")}
  topic_list_fetured_link         { link(:text => "Featured")}
  topic_list_not_fetured_link     { link(:text => "Not Featured")}

  topic_list_status               { spans(:class => "admin-topic-status")}
  topic_list_feature_icons        { elements(:css => ".feature-icon span")}
  topic_list_loading_block        { div(:class => "loading-block")}
  topic_empty_list                { h4(:class => "empty-container-text")}
  topic_sort_by_button            { button(:css => ".admin-topic-last-modified button")}
  topic_list_show_more_button     { div(:class => "amdin-show-more")}
  topic_list_activity_time        { div(:class => "topic-footer-label")}

  topicdetail   { div(:class => "topic-filters") }
  topicname     { div(:class => "row title") }

end