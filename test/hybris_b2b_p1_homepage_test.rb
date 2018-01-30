require File.expand_path(File.dirname(__FILE__) + "/hybris_watir_test.rb")
require File.expand_path(File.dirname(__FILE__) + "/../lib/test_helper.rb")
require File.expand_path(File.dirname(__FILE__) + "/../lib/hybris_test.rb")


class HybrisB2BP1HomepageTest < HybrisWatirTest
  include HybrisTest

  def test_00010_homepage
    open_site
    check_homepage
  end

end