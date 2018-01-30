require File.expand_path(File.dirname(__FILE__) + "/excelsior_watir_test.rb")
require File.expand_path(File.dirname(__FILE__) + "/../lib/test_helper.rb")
require File.expand_path(File.dirname(__FILE__) + "/../lib/watir_lib.rb")

class QuestionTest < ExcelsiorWatirTest
include WatirLib
  
  def test_00010_reply_to_answer_of_question
    reply_text = "Replied by Watir - #{get_timestamp}"
    network_landing($network)
    main_landing("regular", "logged")
    topic_detail("A Watir Topic")
    choose_post_type("question")
    conversation_detail("question")
    if ( !@browser.div(:class => /ember-view depth-1 answer post/).present?)
        conversation_detail_reply
    end
    textarea = @browser.textarea(:class => "ember-view ember-text-area form-control")
    @browser.wait_until { textarea.exists? }
    assert @browser.div(:class => "ember-view post-collection").exists?
    @browser.link(:text => "Reply").when_present.click

    @browser.wait_until { @browser.div(:class => "group text-right").exists? }
    @browser.execute_script("window.scrollBy(0,200)")
    @browser.div(:class => /ember-view depth-1 answer post/).textarea(:class => "ember-view ember-text-area form-control", :placeholder => "Write a reply...").when_present.set reply_text
    sleep 2
    @browser.button(:value => /Submit/).when_present.click
    #@browser.wait_until { @browser.div(:class => "ember-view depth-2 post").exists? }
    @browser.execute_script("window.scrollBy(0,300)")
    @browser.wait_until { @browser.divs(:class => "ember-view depth-2 post").last.text.include? reply_text }
    assert @browser.divs(:class => "ember-view depth-2 post").last.text.include? reply_text #exists? 
  end

  def test_00020_like_and_unlike_question_and_reply
    network_landing($network)
    main_landing("regis", "logged")
    topic_detail("A Watir Topic")
    choose_post_type("question")
    conversation_detail("question")
    like_quest_element = @browser.link(:class => "like", :index => 0)
    sleep 1
    if (@browser.link(:class => "like", :index => 0).text =~ /Unlike/)
        like_quest_element.when_present.click
        assert_equal 0, like_quest_element.text =~ /Like/
    end
    like_quest_element.when_present.click
    assert_equal 0, like_quest_element.text =~ /Unlike/

    if ( !@browser.div(:class => /ember-view depth-1 answer post/).present?)
        conversation_detail_reply
    end
    like_ans_element = @browser.div(:class => /ember-view depth-1 answer post/).link(:class => "like")
    if (@browser.div(:class => /ember-view depth-1 answer post/).link(:class => "like").text =~ /Unlike/)
        like_ans_element.when_present.click
        assert_equal 0, like_ans_element.text =~ /Like/
    end
    like_ans_element.when_present.click
    assert_equal 0, like_quest_element.text =~ /Unlike/
    #next Unliking both the discussion and comment
    like_quest_element.when_present.click
    assert_equal 0, like_quest_element.text =~ /Like/
    like_ans_element.when_present.click
    assert_equal 0, like_quest_element.text =~ /Like/
    signout
    #login($user1)
  end

  def test_00030_follow_and_unfollow_question_and_answer 
    network_landing($network)
    main_landing("regular", "logged")
    topic_detail("A Watir Topic")
    choose_post_type("question")
    conversation_detail("question")

    textarea = @browser.textarea(:class => "ember-view ember-text-area form-control")
    @browser.wait_until { textarea.exists? }
    follow_quest_element = @browser.link(:class => "follow", :index => 0)
    follow_quest_element.when_present.click
    @browser.wait_until { (follow_quest_element.text =~ /Follow/)}
    if ( !@browser.div(:class => /ember-view depth-1 answer post/).present?)
        conversation_detail_reply
    end
    follow_ans_element = @browser.link(:class => "follow", :index => 1)
    follow_ans_element.when_present.click
    @browser.wait_until { (follow_ans_element.text =~ /Follow/) }
    #next unfollowing both the discussion and comment:
    follow_quest_element = @browser.link(:class => "follow", :index => 0)
    follow_quest_element.when_present.click
    @browser.wait_until { (follow_quest_element.text =~ /Unfollow/)}
    follow_ans_element = @browser.link(:class => "follow", :index => 1)
    follow_ans_element.when_present.click
    @browser.wait_until { (follow_ans_element.text =~ /Unfollow/) }
  end

 def test_00040_feature_comment_after_one_level
    network_landing($network)
    main_landing("regular", "logged")
    topic_detail("A Watir Topic")
    choose_post_type("question")
    conversation_detail("question")
    
    reply1 = "Reply on level1 posted by Watir - #{get_timestamp}"
    reply2 = "Reply on level2 posted by Watir - #{get_timestamp}"
    #@browser.div(:class => /ember-view depth-1/).link(:text => /Reply/).when_present.click
    @browser.textarea(:class => "ember-view ember-text-area form-control").when_present.focus
    @browser.wait_until { @browser.div(:class => "group text-right").exists? }
    @browser.textarea(:class => "ember-view ember-text-area form-control").when_present.set reply1
    @browser.button(:value => /Submit/).when_present.click
    sort_by_new_in_conversation_detail
    @browser.wait_until { @browser.div(:class => "media-body", :text => /#{reply1}/).exists? }
    assert @browser.div(:class => "media-body", :text => /#{reply1}/).exists?, "Watir posted answer doesn't exist"

    @browser.link(:text => /Reply/).when_present.click
    @browser.textarea(:class => "ember-view ember-text-area form-control", :placeholder => "Write a reply...").when_present.focus
    @browser.wait_until { @browser.div(:class => "group text-right").exists? }
    @browser.textarea(:class => "ember-view ember-text-area form-control", :placeholder => "Write a reply...").when_present.set reply2
    @browser.button(:value => /Submit/).when_present.click


    @browser.wait_until { @browser.div(:class => /ember-view depth-2 post/).exists? }
    @browser.execute_script('$("div.pull-right sort-by dropdown").scrollTop(1200)')
    @browser.div(:class => /ember-view depth-2/).span(:class => "dropdown-toggle").when_present.click
    @browser.wait_until { @browser.link(:class => "feature-class").exists? }
    assert @browser.link(:class => "feature-class").exists? 

  end

end
