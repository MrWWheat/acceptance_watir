require 'pages/community/gadgets/base'

class Gadgets::Community::Footer < Gadgets::Base
  def initialize(config)
    super(config, ".gadget-footer")

    @slug = @config.slug
  end

  def footer
    @browser.element(:css => @gadget_css + " .footer")
  end 
end