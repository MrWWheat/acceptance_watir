
class Pages::Community::AdminTags < Pages::Community::Admin

  def initialize(config, options = {})
    super(config)
    @url = config.base_url + "/admin/#{config.slug}/tags"
  end

  def start!(user)
    super(user, @url, admin_home_content)
  end

  tag_newtag_tab                         { ul(:id => "tagTabs").link(:text => /New Tags/)}
  tag_newtag_type                        { text_field(:id => "tags-input")}
  tag_newtag_import                      { link(:id => "import-btn")}
  tag_newtag_save_button                 { button(:class => "btn btn-primary save")}
  tag_newtag_clear_button                { button(:class =>"btn btn-default delete_all")}
  tag_newtag_fileinput                   { file_field(:css => ".tags-import-input") }                

  tag_managetag_tab                      { ul(:id => "tagTabs").link(:text => /All Tags/)}
  tag_all_checkbox
  tag_managetag_delete_button            { span(:class => "delete-btn").link(:id => "delete-btn")}
  tag_managetag_filter                   { text_field(:id => "tagSearchInput")}
  tag_download_btn                       { link(:id =>"download-btn")}

  tag_delete_confirm_button              { button(:class => "btn btn-primary", :text => /Confirm/)}
  tag_delete_cancel_button               { button(:class => "btn btn-default", :text => /Cancel/)}

  tag_import_close_btn                   { div(:class => "modal fade in").button(:class => "btn btn-default")}
  tag_list                               { div(:id => "tags-list")}
  tag                                    { div(:id => "tags")}
  no_tag                                 { div(:css => "#tags #no-tag") }
  taglist_first_tag                      { div(:css => "#tags div") }
  taglist_spinner                        { element(:css => "#no-tag .fa-spinner") }

  def navigate_in
    super

    switch_to_sidebar_item(:tags)

    # wait until 3rd Party Analytics option is selected
    @browser.wait_until($t) { sidebar_item(:tags).attribute_value("class").include?("active") }
    @browser.wait_until($t) { tag_newtag_tab.present? }
  end 

  def input_tags(tag_content)
    tag_newtag_tab.when_present.click
    tag_newtag_type.when_present.set(tag_content)
  end

  def import_tags(file_name)
    # show the file uploader so as to set file to it
    unless tag_newtag_fileinput.present?
      @browser.execute_script("arguments[0].setAttribute('style', 'display:block !important')", tag_newtag_fileinput)
    end

    tag_newtag_fileinput.set(file_name)
    # hide the file uploader
    @browser.execute_script("arguments[0].setAttribute('style', 'display:none !important')", tag_newtag_fileinput)

    tag_import_close_btn.when_present.click
    sleep(2)
    scroll_to_element tag_managetag_tab
    @browser.execute_script("window.scrollBy(0,-200)") # in case overlapped by top navigator bar
    tag_managetag_tab.when_present.click
  end

  def create_tags(tag_content)
    tag_newtag_tab.when_present.click
    tag_newtag_type.when_present.set(tag_content)
    tag_newtag_save_button.when_present.click
  end

  def filter_tags (tag_content)
    scroll_to_element tag_managetag_tab
    @browser.execute_script("window.scrollBy(0,-200)") # in case overlapped by top navigator bar
    tag_managetag_tab.when_present.click
    tag_managetag_filter.set(tag_content)
    @browser.wait_until { tag_managetag_filter.value == tag_content }
    tag_managetag_filter.send_keys(:enter)
    @browser.wait_until { taglist_first_tag.when_present.text == tag_content }
    @browser.wait_until { !taglist_spinner.present? }
  end

  def delete_presented_all_tags (tag_content)
    @browser.wait_until($t) {@browser.div(:id => "tags-list").text.include? tag_content}
    @browser.div(:id => "tag-actions").span(:class => "tags-all").label(:text => /All/).checkbox.when_present.set true
    @browser.wait_until($t) {!tag_managetag_delete_button.attribute_value("class").include? "disabled"}
    tag_managetag_delete_button.click
    tag_delete_confirm_button.when_present.click
  end

  def download_file
    tag_managetag_tab.when_present.click
    tag_download_btn.when_present.click
  end


end