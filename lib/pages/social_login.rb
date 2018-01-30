require 'pages/base'

class Pages::SocialLogin < Pages::Base

  def initialize(config, options = {})
    super(config)
    @url = config.hybris_url
    @user = nil
    @modal = nil
    @username = nil
    @password = nil
    @button = nil
  end

  def self.layout_class
    Pages::SocialLogin
  end

  community_home_page                     { div(:id => "chicago") }

  facebook_login_modal                    { div(:id => "loginform") }
  facebook_login_username                 { text_field(:id => "email")}
  facebook_login_password                 { text_field(:id => "pass") }
  facebook_login_button                   { element(:id => "loginbutton") }
  facebook_login_button_2                 { label(:class => /uiButtonConfirm/)}

  twitter_login_modal                     { form(:id => "oauth_form") }
  twitter_login_username                  { text_field(:id => "username_or_email") }
  twitter_login_password                  { text_field(:id => "password") }
  twitter_login_button                    { button(:id => "allow") }

  linkedin_login_modal                    { form(:name => "oauthAuthorizeForm") }
  linkedin_login_username                 { text_field(:id => "session_key-oauthAuthorizeForm") }
  linkedin_login_password                 { text_field(:id => "session_password-oauthAuthorizeForm") }
  linkedin_login_button                   { button(:class => "allow", :value => "Allow access") }

  def socail_login type
    @user = type.to_s + "_user"
    @modal = eval(type.to_s + "_login_modal")
    @username = eval(type.to_s + "_login_username")
    @password = eval(type.to_s + "_login_password")
    @button = eval(type.to_s + "_login_button")

    @browser.wait_until($t) {@modal.present?}
    @username.when_present.set @config.users[@user].email
    @password.when_present.set @config.users[@user].password
    @button.when_present.click

    # case type
    #   when :facebook
    #     @browser.wait_until($t) {community_home_page.present? || @browser.windows.size <= 1}
    #     if @browser.windows.size > 1
    #       @browser.window.close
    #     else
    #       @browser.windows.last.use
    #     end
    # end
  end

end