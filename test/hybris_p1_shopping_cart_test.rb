require File.expand_path(File.dirname(__FILE__) + "/hybris_watir_test.rb")
require File.expand_path(File.dirname(__FILE__) + "/../lib/test_helper.rb")
require File.expand_path(File.dirname(__FILE__) + "/../lib/hybris_test.rb")


class HybrisP1ShoppingTest < HybrisWatirTest
  include HybrisTest
  
  def test_00410_shopping_cart
    open_site
    go_to_review_from_homepage
    shopping_cart
  end

end