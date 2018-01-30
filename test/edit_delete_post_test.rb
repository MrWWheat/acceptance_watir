require File.expand_path(File.dirname(__FILE__) + "/excelsior_watir_test.rb")
require File.expand_path(File.dirname(__FILE__) + "/../lib/test_helper.rb")
require File.expand_path(File.dirname(__FILE__) + "/../lib/watir_lib.rb")


class EditDeletePostTest < ExcelsiorWatirTest
  include WatirLib

  def test_00010_edit_reply
    network_landing($network)
    main_landing("regis", "logged")
    topic_detail("A Watir Topic")
    choose_post_type("question")
    sort_by_old_in_conversation_list
    title = "Watir Test Question2 ?"
    @browser.wait_until($t) { @browser.link(:text => /#{title}/).present? }
    conversation_detail("question", title)
    desc = "Watir edited reply - #{get_timestamp}"
    dropdown = @browser.div(:class => "depth-1").span(:class => "dropdown-toggle")
    dropdown.when_present.click
    edit_link = @browser.div(:class => "depth-1").link(:text => /Edit/)
    @browser.wait_until($t) { edit_link.present? }
    edit_link.click

    textarea = @browser.div(:class => "depth-1").textarea
    @browser.wait_until($t) { textarea.exists? }
    assert textarea.exists?
    refute textarea.text.nil?, "No old text"
    refute_equal "", textarea.value, "Has blank old text"
    refute_equal desc, textarea.value, "Old text not different"

    textarea.set desc
    submit_button = @browser.div(:class => "depth-1").button(:class => "btn-primary")
    assert submit_button.present?
    submit_button.click
    @browser.wait_until($t) { !submit_button.present? }
    edited_reply = @browser.div(:class => "depth-1").div(:class => "post-content", :text => /#{desc}/)
    assert edited_reply.present?
  end  
end
