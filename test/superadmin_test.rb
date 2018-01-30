require File.expand_path(File.dirname(__FILE__) + "/excelsior_watir_test.rb")
require File.expand_path(File.dirname(__FILE__) + "/../lib/test_helper.rb")
require File.expand_path(File.dirname(__FILE__) + "/../lib/watir_lib.rb")


class SuperAdminTest < ExcelsiorWatirTest
  include WatirLib

  def test_00010_superadmin_login
  	superadmin_login_helper($superadmin_url, $user11)	
  end

  def test_00020_registerd_user_search
  	superadmin_login_helper($superadmin_url, $user11)
  	search_registered_user_helper($user5)
  end

  def xtest_00030_add_and_remove_network_admin
  	superadmin_login_helper($superadmin_url, $user11)
  	go_to_networks
  	edit_network
  	delete_network_admin($user10)
  	@browser.link(:href => "/super/networks", :text => "Back").when_present.click
  	search_registered_user_helper($user11)
  	
  end

end