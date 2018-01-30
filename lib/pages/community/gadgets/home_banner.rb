require 'pages/community/gadgets/base'

class Gadgets::Community::HomeBanner < Gadgets::Base
  def initialize(config)
    super(config, ".gadget-home-banner")
  end

  def background_color
  	@browser.div(:css => @gadget_css + " .widget").when_present.style('background-color')
  end	
end  