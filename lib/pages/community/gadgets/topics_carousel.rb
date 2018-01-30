require 'pages/community/gadgets/base'

class Gadgets::Community::TopicsCarousel < Gadgets::Base
  def initialize(config)
    super(config, ".gadget-featured-topics-carousel")
  end

  def header
    @browser.element(:css => @gadget_css + " h6")
  end

  def topic_title 
    @browser.element(:css => @gadget_css + " .topic-avatar .customization-topic-title")
  end  

  def page_count
    @browser.lis(:css => @gadget_css + " .carousel-indicators [data-target='#featuredTopicCarousel']").size
  end 

  def left_arrow
    @browser.element(:css => @gadget_css + " .icon-slim-arrow-left")
  end
  
  def right_arrow
    @browser.element(:css => @gadget_css + " .icon-slim-arrow-right")
  end 

  def active_page_num
    @browser.li(:css => @gadget_css + ".carousel-indicators .active[data-target='#featuredTopicCarousel']").attribute_value("data-slide-to").to_i
  end  
end  