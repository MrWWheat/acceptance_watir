module SuperAdminPage
	def superadmin_login_helper(superadmin_url, user)
		@browser.goto superadmin_url
		if (@browser.text_field(:id => "super_admin_login").exists?)
		@browser.wait_until($t) { @browser.div(:class => "field").exists? }
		@browser.text_field(:id => "super_admin_login").set user[2]
		@browser.text_field(:id => "super_admin_password").set user[1]
    @browser.screenshot.save screenshot_dir('userpwd.png')
    @browser.input(:type => "submit", :value => "Log in").when_present.click
		@browser.wait_until($t) { @browser.div(:class => "pull-right").exists?}
		end
    assert @browser.div(:class => "pull-right", :text => /#{user[2]}/).exists?
	end

	def search_registered_user_helper(user)
		@browser.link(:href => "/super/registered_users").when_present.click
		@browser.wait_until($t) { @browser.input(:id => "registered_user_username" , :type => "text").exists? }
		@browser.text_field(:id => "registered_user_username", :type =>"text").when_present.set user[2]
		@browser.input(:type => "submit").when_present.click
		@browser.wait_until($t) { @browser.table(:id => "sa-member-result").exists? } 
		assert @browser.td(:text => user[0]).exists?		
	end

	def go_to_networks
		@browser.link(:href => "/super/networks", :text => /Networks/).when_present.click
		@browser.wait_until($t) { @browser.table(:class => "table").exists?}
	end

	def edit_network
		@browser.link(:href => "/super/networks/2/edit", :text => "Edit").when_present.click
		@browser.wait_until($t) { @browser.form(:id => "edit_network_2").exists?}
		@browser.link(:href => "/super/networks/2", :text => "Show").when_present.click
	end

	def delete_network_admin(user)
		user_email = @browser.table.td(:text => /#{user[0]}/)
		byebug
		parent_cell = user_email.parent
		sibling_user_email = parent_cell.td(:index => 3).text
		byebug
		@browser.link(:text => sibling_user_email).when_present.click
		@browser.wait_until($t) { @browser.link(:text => "Edit").exists? }
		@browser.link(:text => "Edit").when_present.click
		@browser.wait_until($t) { @browser.form(:class => "edit_registered_user").exists? }
		@browser.input(:id => "registered_user_is_admin", :type => "checkbox").when_present.click
		@browser.input(:type => "submit").when_present.click
		@browser.wait_until($t) { @browser.p(:id => "notice", :text => "Network Admin was successfully updated.").exists?}
	end


end