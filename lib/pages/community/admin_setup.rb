require 'pages/community/admin'
require 'pages/community/home'
require 'pages/community/login'
require 'pages/community/layout'
require 'pages/community/profile'
require 'watir_config'
#require 'pages/base'

class Pages::Community::AdminSetup < Pages::Community::Admin

  def initialize(config, options = {})
    super(config)
    # @url = config.base_url + "/n/#{config.slug}/home"
    @url = config.base_url + "/admin/#{@config.slug}/general_setup"
  end

  community_name_input				{ div(:class => "instance-name").input }

end