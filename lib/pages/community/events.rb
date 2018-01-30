require 'pages/community'
require 'minitest/assertions'

class Pages::Community::Events < Pages::Community

  def initialize(config, options = {})
    super(config)
    @url = config.base_url + "/n/#{config.slug}/events"

    #puts @network_name = config.network_name
    #puts @base_url = config.base_url
    #puts @@slug = config.slug  
  end

  events_new                               { div(:class => "col-md-12").span(:class => "icon-add", :text => "New Event")}
 
  def go_to_events(name)
    @browser.link(:text => name).when_present.click
  end

end
