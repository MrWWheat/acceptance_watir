require 'pages'

module Gadgets
  module Community
  end 
end 

class Gadgets::Base
  attr_reader :gadget_css

  def initialize(config, gadget_css)
    @config = config
    @browser = config.browser
    @gadget_css = gadget_css
  end

  def present?
    @browser.element(:css => @gadget_css).present?
  end

  def loading_spinner
    @browser.element(:css => @gadget_css + " .fa-spinner")
  end

  def select
    @browser.lis(:css => ".s-gadget").each do |g|
      if @browser.element(:css => "##{g.id} #{@gadget_css}").present?
        g.click
        break
      end  
    end
    # @browser.element(:css => @gadget_css).parent.when_present.click
  end

  # only useable in ui customization page
  def active?
    @browser.element(:css => @gadget_css).parent
  end  
end