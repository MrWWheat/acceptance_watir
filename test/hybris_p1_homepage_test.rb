require File.expand_path(File.dirname(__FILE__) + "/hybris_watir_test.rb")
require File.expand_path(File.dirname(__FILE__) + "/../lib/test_helper.rb")
require File.expand_path(File.dirname(__FILE__) + "/../lib/hybris_test.rb")


class HybrisP1HomepageTest < HybrisWatirTest
  include HybrisTest

  def test_00010_homepage
    open_site
    check_homepage
  end

  def test_00020_product_list_page
    open_site
    product_list("Brands","Canon")
    check_listpage
  end

  def test_00410_shopping_cart
    open_site
    go_to_review_from_homepage
    shopping_cart
  end

  def test_00510_reset_theme
    landing_community_adminpage
    reset_theme
    open_site
    verify_font_size "12px"
  end

  def test_00511_theme_builder_change_font
    landing_community_adminpage
    change_theme "12px"
    open_site
    verify_font_size "12px"
  end

end