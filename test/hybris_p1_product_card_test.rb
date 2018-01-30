require File.expand_path(File.dirname(__FILE__) + "/hybris_watir_test.rb")
require File.expand_path(File.dirname(__FILE__) + "/../lib/test_helper.rb")
require File.expand_path(File.dirname(__FILE__) + "/../lib/hybris_test.rb")


class HybrisP1ProductCardTest < HybrisWatirTest
  include HybrisTest

  def test_00310_product_card_on_reply
    product_hint = "D"
    product_edit_hint = "1"
    open_site
    login_hybris($hybrisuser)
    go_to_review_from_homepage
    at_mention_product_on_reply(product_hint)
    edit_mention_product_on_reply(product_edit_hint)
  end

  def test_00311_product_card_on_root_post
    product_hint = "D"
    product_edit_hint = "1"
    open_site
    login_hybris($hybrisuser)
    go_to_review_from_homepage
    at_mention_product_on_root_post(product_hint)
  end

end