require 'pages/community/ui_design/editors/base'

class PropEditors::Community::CarouselLayout < PropEditors::Base
  def initialize(browser, parent_css)
    super(browser, parent_css)
  end

  def change_settings(settings)
    settings.each do |s|
      case s[:type]
      when :page
        set_page_num(s[:value])
      else
        raise "Type #{s[:type]} not supported yet"
      end 
    end   
  end

  def page_num_input
    @browser.text_field(:css => @parent_css + " input")
  end 

  def set_page_num(num)
    page_num_input.when_present.set(num)
  end 
end  