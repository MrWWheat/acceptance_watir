require 'pages/community'

class Pages::Community::Settings < Pages::Community

  def initialize(config, options = {})
    super(config)
    # @url = config.base_url + "/n/#{config.slug}"
  end

  def start!(user)
    super(user, @url, topic_page)
  end

  post_content                    { div(:class => "post-content") }
  member_mapping                  { text_field(:id => "member_mapping") }
  mapping_off_button              { button(:class => "mapToggle", :text => /OFF/) }
  # save_button                     { button(:name => "commit", :value => /Save/) }
  save_button                     { button(:value => /Save/) }

  activity_list                   { div(:id => "activity") }
  save_confirm_dialog             { div(:id => "save-confirm") }
  ok_btn_in_save_confirm_dialog   { button(:id => "confirm-save") }
  save_success_msg                { div(:id => "sucess-message") }

  def break_mapping
    @browser.wait_until($t) {member_mapping.present?}
    @browser.wait_until($t) { mapping_off_button.present? }
    scroll_to_element mapping_off_button
    mapping_off_button.when_present.click
    # @browser.execute_script('arguments[0].scrollIntoView();', save_button)
    save_button.when_present.click

    # confirm the change
    ok_btn_in_save_confirm_dialog.when_present.click
    @browser.wait_until($t) { save_success_msg.present? }
  end


end