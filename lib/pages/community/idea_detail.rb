class Pages::Community::IdeaDetail < Pages::Community
  def initialize(config, options = {})
    super(config)
  end

  idea_container              { div(:class => "ideas-container")}
  idea_title                  { element(:css => ".ideas-container .title") }
  operator_button             { div(:class => "operator").span(:class => "icon-navigation-down-arrow")}
  edit_idea_button            { div(:class => "operator").ul.links[0]}
  delete_idea_button          { div(:class => "operator").ul.links[1]}
  idea_desc_text              { div(:class => "description").p}
  idea_desc_tag_link          { div(:class => "description").link}

  # idea meta operation
  idea_action_container       { div(:class => "idea-action-container")}
  like_idea_button            { div(:class => "idea-action-container").links[0]}
  follow_idea_button          { div(:class => "idea-action-container").links[2]}
  reply_input                 { text_field(:id => "wmd-input")}
  reply_submit_button         { button(:id => "btn-explicit-submit") }
  # idea metadata
  idea_meta_container         { div(:class => "idea-meta-container")}
  like_count_text             { div(:class => "idea-meta-container").spans[0]}
  follow_count_text           { div(:class => "idea-meta-container").spans[2]}
  # comment 
  comment_container           { div(:class => "reply-container")}
  comment_result_text         { div(:class => "reply-container").h5}

  idea_widget_view_all_link                { div(:class => "gadget-popular-ideas").link(:text => /View All/) }

  def operate_idea operation_name
    wait_until_load
    operator_button.when_present.click
    case operation_name
    when :edit
      edit_idea_button.when_present.click
    when :delete
      delete_idea_button.when_present.click
    else
      raise "#{operation_name} not support yet"
    end
  end

  def write_reply reply_content
    wait_until_load
    old_comment_count = 0
    begin
      @browser.wait_until(5) { comment_result_text.present? }
      old_comment_count = comment_result_text.text.split(/ /)[0].to_i
    rescue
    end
    reply_input.when_present.click
    reply_input.when_present.set reply_content

    @browser.wait_until { reply_submit_button.present? }
    reply_submit_button.click
    @browser.wait_until { comment_result_text.when_present.text.split(/ /)[0].to_i == (old_comment_count + 1)}
    return true
  end

  def wait_until_load
    @browser.wait_until { idea_container.present? }
  end

  def wait_until_meta_action_load
    @browser.wait_until { idea_meta_container.present? && like_count_text.present? && follow_count_text.present? }
    @browser.wait_until { idea_action_container.present? && like_idea_button.present? && follow_idea_button.present? }
    @browser.wait_until { comment_container.present? }
  end
end
