require 'pages/base'

class Pages::SuperAdmin < Pages::Base

  def initialize(config, options = {})
    super(config)
    @url = config.superadmin_url
  end

  def self.layout_class
    Pages::SuperAdmin
  end

  # login page
  login_modal                           { div(:class => "super-admin") }
  login_username                        { text_field(:id => "super_admin_login") }
  login_password                        { text_field(:id => "super_admin_password") }
  login_btn                             { button(:value => /Log In/) }
  logout_btn                            { link(:href => /\/super\/auth\/sign_out/) }

  # home page
  sidebar_nav                           { div(:class => "admin-navbar") }

  # community tab
  community_new_btn                     { link(:href => /\/super\/networks\/new/) }
  component_table                       { table(:class => "table") }

  # community page
  beta_feature_table                    { tables(:class => "table")[1] }

  def login_super_admin
    @browser.wait_until($t) {login_modal.present?}
    login_username.when_present.set @c.users["superadmin_user"].username
    login_password.when_present.set @c.users["superadmin_user"].password
    login_btn.when_present.click
  end

  def go_to_community_tab network_slug
    @browser.wait_until($t) {sidebar_nav.present?}
    sidebar_nav.links[1].when_present.click
    @browser.wait_until($t) {community_new_btn.present?}
    component_table.when_present.trs.each do |elem|
      if elem.text.include? network_slug
        elem.tds[0].link.click
        break
      end
    end
  end

  def toggle_sso_switch type, beta_feature_name
    @browser.wait_until($t) {beta_feature_table.present?}
    beta_feature_table.trs.each do |elem|
      if elem.text.include? beta_feature_name
        case type
          when :up
            elem.checkbox(:id => "beta_feature_enabled").set true
          when :down
            elem.checkbox(:id => "beta_feature_enabled").set false
        end
        elem.button(:name => /commit/).click
        sleep 3
        break
      end
    end
  end

  def logout!
    logout_btn.when_present.click
  end

end