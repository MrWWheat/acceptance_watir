require 'pages/community'

class Pages::Community::ResetPassword < Pages::Community

  def initialize(config, options = {})
    super(config)
    # @url = config.base_url + "/n/#{config.slug}"
  end

  def start!(user)
    super(user, @url, topic_page)
  end

  new_password_input              { text_field(:id => "member_password")}
  new_password_confirm_input      { text_field(:id => "member_password_confirmation")}
  reset_btn                       { button(:class => "btn btn-primary")}
  sign_in_btn                     { link(:text => /Sign in/)}

  def reset_password password
    @browser.wait_until($t) { new_password_input.present?}
    new_password_input.when_present.set password
    new_password_confirm_input.when_present.set password
    reset_btn.when_present.click
  end

end