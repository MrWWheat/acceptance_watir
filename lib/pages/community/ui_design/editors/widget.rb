require 'pages/community/ui_design/editors/base'

class PropEditors::Community::Widget < PropEditors::Base
  def initialize(browser, parent_css)
    super(browser, parent_css)
  end

  def e_commerce_terms_of_use_url
  	@browser.text_field(:css => @parent_css + " .prop-group:nth-of-type(2) .gadget-layout-url input")
  end

  def e_commerce_privacy_policy_url
  	@browser.text_field(:css => @parent_css + " .prop-group:nth-of-type(3) .gadget-layout-url input")
  end

  def e_commerce_imprint_url
  	@browser.text_field(:css => @parent_css + " .prop-group:nth-of-type(4) .gadget-layout-url input")
  end

  def e_commerce_contact_us_url
  	@browser.text_field(:css => @parent_css + " .prop-group:nth-of-type(5) .gadget-layout-url input")
  end

  def terms_of_use_url
    @browser.text_field(:css => @parent_css + " .prop-group:nth-of-type(3) .gadget-layout-url input")
  end

  def privacy_policy_url
    @browser.text_field(:css => @parent_css + " .prop-group:nth-of-type(4) .gadget-layout-url input")
  end

  def imprint_url
    @browser.text_field(:css => @parent_css + " .prop-group:nth-of-type(5) .gadget-layout-url input")
  end

  def contact_us_url
    @browser.text_field(:css => @parent_css + " .prop-group:nth-of-type(6) .gadget-layout-url input")
  end
end