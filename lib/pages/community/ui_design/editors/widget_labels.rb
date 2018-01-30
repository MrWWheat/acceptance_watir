require 'pages/community/ui_design/editors/base'

class PropEditors::Community::WidgetLabels < PropEditors::Base
  def initialize(browser, parent_css)
    super(browser, parent_css)
  end

  def change_settings(settings)
    settings.each do |s|
      case s[:type]
      when :title
        set_title(s[:value])
      when :content
        set_content(s[:value])
      else
        raise "Type #{s[:type]} not supported yet"
      end  
    end  
  end 

  def title_input
    @browser.text_field(:css => propitem_css_by_name("Title") + " input")
  end

  def set_title(title)
    title_input.when_present.set title
    @browser.wait_until { title_input.value == title }
  end  
  
  def content_input
    @browser.textarea(:css => propitem_css_by_name("Content") + " textarea")
  end  

  def set_content(content)
    content_input.when_present.set content
    @browser.wait_until { content_input.value == content }
  end  

  def propitem_css_by_name(name)
    
    pi_count = @browser.divs(:css => @parent_css + " .prop-group .prop-group").size

    result = nil

    (1..pi_count).each do |i|
      pi_css = @parent_css + " .prop-group .prop-group:nth-of-type(#{i})"
      
      next unless @browser.element(:css => pi_css + " .prop-group-title").exist?
      
      if @browser.element(:css => pi_css + " .prop-group-title").text.downcase == name.downcase
        
        result = pi_css
        break
      end  
    end

    raise "Cannot find prop #{name}" if result.nil?

    result
  end
end