require 'pages/community/gadgets/base'

class Gadgets::Community::TopicConversations < Gadgets::Base
  def initialize(config, gadget_css)
    super(config, gadget_css)
  end

  def sort_by_toggle
    @browser.element(:css => @gadget_css + " .sort-by.dropdown .dropdown-toggle")
  end
  
  def sort_by_newest_menu_item
    @browser.ul(:css => @gadget_css + " .sort-by.dropdown .dropdown-menu").link(:text => /Newest/)
  end

  def sort_by_oldest_menu_item
    @browser.ul(:css => @gadget_css + " .sort-by.dropdown .dropdown-menu").link(:text => /Oldest/)
  end  
end

class Gadgets::Community::TopicQuestions < Gadgets::Community::TopicConversations
  def initialize(config)
    super(config, ".gadget-topic-questions")
  end
end

class Gadgets::Community::TopicBlogs < Gadgets::Community::TopicConversations
  def initialize(config)
    super(config, ".gadget-topic-blogs")
  end
end

class Gadgets::Community::TopicReviews < Gadgets::Community::TopicConversations
  def initialize(config)
    super(config, ".gadget-topic-reviews")
  end
end