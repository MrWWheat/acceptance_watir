require 'pages/community/admin'
require 'pages/community/home'

class Pages::Community::EventDetail < Pages::Community

  def initialize(config, options = {})
    super(config)
  end

  pic_view							{ div(:class => "event-banner-container") }
  content_view						{ div(:class => /(event-description-container|gadget-event-detial-content)/) }
  related_topics_view				{ links(:class=> "title")}

  register_btn						{ button(:id => "register-button", :text => "Register") }
  unregister_btn						{ button(:id => "register-button", :text => "Unregister") }
  attending_lists					{ div(:class => "attending-container").divs }

  like_btn							{ span(:class => "icon-thumb-up") }
  like_number_text				    { div(:class => "event-meta-container").span }

  reply_box							{ textarea(:id => "wmd-input")}

  drop_down_btn         { span(:class => "icon-dropdown") }
  drop_down_export_btn    { link(:text => /Export Event/) }
  drop_down_edit_btn      { link(:text => /Edit Event/) }

  title                   { div(:class => "gadget-event-detial-content").h4 }
  desc                    { div(:class => "gadget-event-detial-content").div.p }
  location_div            { div(:class => "event-address-container") }

  def wait_until_loaded
  	@browser.wait_until { content_view.present? }
  end

  def attend_event
    @browser.wait_until{register_btn.present? || unregister_btn.present?}
  	sleep 3
    if !unregister_btn.present?
      register_btn.when_present.click
    end
    sleep 3
    @browser.wait_until { attending_lists.size > 0 }
  end

  def like_event
    @browser.wait_until{ like_btn.present? && like_number_text.present?}
  	is_liked = like_btn.parent.class_name.include? "action-done"
  	before_number = like_number_text.text[/\d+/].to_i
    like_btn.when_present.click
    if is_liked
      after_number = before_number - 1
    else
      after_number = before_number + 1
    end
    @browser.wait_until { like_number_text.text.include? after_number.to_s }
  end

  def reply_event

  end

  def do_menu_action action
    drop_down_btn.when_present.click
    case action
    when :edit
      drop_down_edit_btn.when_present.click
    when :export
      drop_down_export_btn.when_present.click
    else
      raise "#{@option} operation is unsupported yet"
    end
  end

  def trigger_edit_event
    do_menu_action :edit
  end

  def export_event
    file_entries_before_download = Dir.entries(@config.download_dir)
    do_menu_action :export
    wait_file_download(@config.download_dir, file_entries_before_download, "calendar.ics", wait_time=30)
  end

end