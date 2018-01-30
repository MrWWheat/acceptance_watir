require 'pages/community/gadgets/base'

class Gadgets::Community::AboutNavigator < Gadgets::Base
  def initialize(config)
    super(config, ".about-navigation")
  end

  def items
    @browser.lis(:css => @gadget_css + " li")
  end
  
  def item_at_index(index)
    @browser.li(:css => @gadget_css + " li:nth-of-type(#{index+1})")
  end  
end