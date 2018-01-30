require 'pages/community/gadgets/base'

class Gadgets::Community::TextElement < Gadgets::Base
  def initialize(config, options = {})
    super(config, ".gadget-text-element")
    @options = options
  end

  def present?
    gadget_obj.nil? ? false : gadget_obj.present?
  end

  def gadget_obj
    result = nil
    unless @options[:title].nil? 
      @browser.elements(:css => ".gadget-text-element").each do |t|
        if t.h2.when_present.text == @options[:title]
          result = t
          break
        end
      end 
    else 
      result = @browser.element(:css => ".gadget-text-element")  
    end 

    return result 
  end  

  def select
    @browser.lis(:css => ".s-gadget").each do |g|
      next unless @browser.element(:css => "##{g.id} .gadget-text-element").present?
      unless @options[:title].nil?
        if @browser.element(:css => "##{g.id} .gadget-text-element h2").when_present.text == @options[:title]
          g.click
          break
        end
      else
        super    
      end  
    end
  end  

  def title
    gadget_obj.element(:css => ".text-element h2")
  end
  
  def content
    gadget_obj.div(:css => ".text-element .content")
  end 
end