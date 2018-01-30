require File.expand_path(File.dirname(__FILE__) + "/excelsior_watir_test.rb")
require File.expand_path(File.dirname(__FILE__) + "/../lib/test_helper.rb")
require File.expand_path(File.dirname(__FILE__) + "/../lib/watir_lib.rb")


class CloseConversationTest < ExcelsiorWatirTest
  include WatirLib

  def test_00010_close_and_reopen_conversation
    network_landing($network)
    main_landing("admin", "logged")
    topic_detail("A Watir Topic")
    choose_post_type("question")
    sort_by_old_in_conversation_list
    title = "Q created by Watir -" # pick the first watir created conversation
    conversation = @browser.link(:text => /#{title}/)
    @browser.wait_until($t) { conversation.present? }
    title = conversation.text # Change to the exact title with timestamp
    conversation_detail("question", title)
    dropdown = @browser.div(:class => "depth-0").span(:class => "dropdown-toggle")
    dropdown.when_present.click
    close_or_reopen_link = @browser.div(:class => "depth-0").link(:text => /Close|Reopen/)
    reopen_link = @browser.div(:class => "depth-0").link(:text => /Reopen/)
    close_link = @browser.div(:class => "depth-0").link(:text => /Close/)
    @browser.wait_until($t) { close_or_reopen_link.present? }
    closed_message = @browser.element(:class => "closed-response")
    if reopen_link.present?
      reopen_link.click # Fail on next assert but reopen for the next test run to pass
      @browser.wait_until($t) { !closed_message.present? }
    end
    assert close_link.present?, "Admin did not have a Close link for conversation"
    close_link.click

    confirm_button = @browser.button(:class => "btn-primary", :text => /Close Conversation/)
    @browser.wait_until($t) { confirm_button.present? }
    confirm_button.click

    @browser.wait_until($t) { closed_message.present? }
    assert_equal "This conversation is closed", closed_message.text
    dead_reply = @browser.span(:class => "dead-link", :text => /Reply/)
    assert dead_reply.present?, "Did not have a dead reply link"
    refute @browser.textarea.present?, "Has a visible text input element"

    # Now reopen conversation so the test can be run multiple times by itself
    dropdown.click
    @browser.wait_until($t) { reopen_link.present? }
    assert reopen_link.present?, "Admin did not have a Reopen link for conversation"
    reopen_link.click

    @browser.wait_until($t) { !closed_message.present? }
    refute dead_reply.present?, "Still has dead reply links"
    assert @browser.textarea.present?, "Does not have a reply box after reopen"
  end
end
