require 'pages/community/gadgets/base'

class Gadgets::Community::Banner < Gadgets::Base
  def initialize(config)
    super(config, ".gadget-banner")
  end

  def widget
    @browser.div(:css => @gadget_css + " .widget")
  end
    
  def bg_color
    widget.when_present.style('background-color')
  end

  def bg_image
    widget.when_present.style('background-image')
  end  
end  