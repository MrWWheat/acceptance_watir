require File.expand_path(File.dirname(__FILE__) + "/excelsior_watir_test.rb")
require File.expand_path(File.dirname(__FILE__) + "/../lib/test_helper.rb")
require File.expand_path(File.dirname(__FILE__) + "/../lib/watir_lib.rb")

class AdsWidgetTest < ExcelsiorWatirTest
  include WatirLib

  def test_00010_add_topic_ads
    topic_name = "A Watir Topic"
    network_landing($network)
    main_landing("regular", "logged")
    topic_detail(topic_name)  
    if !check_ads
      set_google_ads_params($networkslug, "ca-pub-8464600688944785", "7717419156", "9115119620")
    	edit_topic($networkslug, topic_name, :advertise => true)
    	assert check_ads
      choose_post_type("discussion")
      conversation_detail("discussion")
    	assert check_ads
      edit_topic($networkslug, topic_name, :advertise => false)
      assert !check_ads
    end
  end

  def check_ads
     check_ads_widgets("banner") && check_ads_widgets("side") 
  end
   
  def check_ads_widgets(place)
     @browser.div(:id => "ads_#{place}").exists?
  end
end