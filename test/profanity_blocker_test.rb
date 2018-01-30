require File.expand_path(File.dirname(__FILE__) + "/excelsior_watir_test.rb")
require File.expand_path(File.dirname(__FILE__) + "/../lib/test_helper.rb")
require File.expand_path(File.dirname(__FILE__) + "/../lib/page_objects/community_home_page.rb")
require File.expand_path(File.dirname(__FILE__) + "/../lib/watir_lib.rb")

class ProfanityBlockerTest < ExcelsiorWatirTest
  include WatirLib

  def setup
    super
    @loginpage = CommunityLoginPage.new(@browser)
  end
  #now works only on firefox
  def test_00010_profanity_blocker
  	@loginpage.login($user1)
    enable_profanity_blocker($networkslug, true)
    #check community post
    title_before = "watir test profanity blocker - #{get_timestamp}"
    title_after = PageObject.new(@browser).create_conversation($network, $networkslug, "A Watir Topic", "discussion", title_before, false)
    title_before["test profanity"] = "**** *********"
    assert title_before == title_after
    # comment_root_post
    # reply_to_comment
    # #check hybris post
    # create_post_from_hybris
    enable_profanity_blocker($networkslug, false)
    title2_before = "watir test profanity blocker - #{get_timestamp}"
    title2_after = PageObject.new(@browser).create_conversation($network, $networkslug, "A Watir Topic", "question", title2_before, false)
    assert title2_before == title2_after
  end

end
