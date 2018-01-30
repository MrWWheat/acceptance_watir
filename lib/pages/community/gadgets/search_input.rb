require 'pages/community/gadgets/base'

class Gadgets::Community::SearchInput < Gadgets::Base
  def initialize(config)
    super(config, ".gadget-search-input")
  end

  def input_field
    @browser.text_field(:css => @gadget_css + " input")
  end 
end  