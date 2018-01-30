require 'pages/community/gadgets/base'

class Gadgets::Community::UpcomingEvents < Gadgets::Base
  def initialize(config)
    super(config, ".gadget-upcoming-events")
  end

  def header
    @browser.element(:css => @gadget_css + " .h7")
  end 
end