require 'pages/community'
require 'minitest/assertions'

class Pages::Community::Gated < Pages::Community

  def initialize(config, options = {})
    super(config)
    @url = config.base_url + "/n/#{config.slug}"
  end

  def start!(user)
    super(user, @url, gated_page_link)
  end
	gated_page_link                 { div(:id => "gate-excelsior-mask").link}
	admin_login_link				{ div(:class => "admin-login").link}
	register_link                   { div(:class => "register").link }
	gated_login_link                { div(:class => "login").link}
 end
