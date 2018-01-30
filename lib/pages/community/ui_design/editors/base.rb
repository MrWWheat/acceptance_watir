require 'pages'

module PropEditors
  module Community
  end 
end

class PropEditors::Base
  # attr_reader :parent_css

  def initialize(browser, parent_css)
    @browser = browser
    @parent_css = parent_css
    @gadget = nil
  end

  def editor
    @browser.element(:css => @parent_css)
  end
    
  def head
    @browser.element(:css => @parent_css + " .collapsible-head")
  end 

  def name
    head.when_present.text
  end

  def subname_select
    @browser.select(:css => @parent_css + " .styling-header select")
  end  

  def present?
    editor.present?
  end

  def global?
    @browser.element(:css => @parent_css + " .global-item").exists?
  end  

  def expanded?
    editor.class_name.include?("expand")
  end  

  def expand
    head.when_present.click unless expanded?
  end 

  def select_subname(subname)
    subname_select.select_value(subname) unless subname_select.value == subname
    @browser.wait_until { subname_select.value == subname }
    sleep 1 # wait until the correct prop fields are updated
  end

  def set_gadget(gadget)
    @gadget = gadget
  end 

  def scroll_to_element(element)
    @browser.execute_script('arguments[0].scrollIntoView();', element)
  end
end 