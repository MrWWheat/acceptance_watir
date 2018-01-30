require 'pages/community/ui_design/editors/base'

class PropEditors::Community::NavigatorBar < PropEditors::Base
  def initialize(browser, parent_css)
    super(browser, parent_css)
  end

  def community
    @browser.input(:name => "gadget-template-main-navigator", :index => 0)
  end

  def ecommunity
    @browser.input(:name => "gadget-template-main-navigator", :index => 1)
  end

  def communityFooter
    @browser.input(:name => "gadget-template-main-footer", :index => 0)
  end

  def ecommunityFooter
    @browser.input(:name => "gadget-template-main-footer", :index => 1)
  end
end