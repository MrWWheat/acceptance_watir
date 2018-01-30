require File.expand_path(File.dirname(__FILE__) + "/hybris_watir_test.rb")
require File.expand_path(File.dirname(__FILE__) + "/../lib/test_helper.rb")
require File.expand_path(File.dirname(__FILE__) + "/../lib/hybris_test.rb")


class HybrisB2BP1LoginTest < HybrisWatirTest
  include HybrisTest

  def test_00300_facebooklogin_nomapped
    open_site
    product_detail($product_id_many)
    precondition_user_not_mapped($hybrisusertemp, nil)
    social_login_nomapped(:facebook,$facebook_user,$hybrisusertemp)
    log_out
  end

  def test_00301_twitterlogin_nomapped
    open_site
    product_detail($product_id_many)
    precondition_user_not_mapped($hybrisusertemp, nil)
    social_login_nomapped(:twitter,$twitter_user,$hybrisusertemp)
    log_out
  end

  def test_00302_linkedinlogin_nomapped
    open_site
    product_detail($product_id_many)
    precondition_user_not_mapped($hybrisusertemp, nil)
    social_login_nomapped(:linkedin,$linkedin_user,$hybrisusertemp)
    log_out
  end
end