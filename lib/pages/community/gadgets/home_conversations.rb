require 'pages/community/gadgets/base'

class Gadgets::Community::HomeConversations < Gadgets::Base
  def initialize(config, gadget_css)
    super(config, gadget_css)
  end

  def header
    @browser.element(:css => @gadget_css + " h7")
  end  

  def posts
    result = []

    @browser.divs(:css => @gadget_css + " .post-list .post").each_with_index do |item, index|
      result << GadgetPost.new(@browser, @gadget_css + " .post-list .post:nth-of-type(#{index+1})")
    end

    result  
  end

  def view_all_link
    @browser.link(:css => @gadget_css + " .view-all")
  end 

  def click_view_all_link
    view_all_link.when_present.click
  end 

  class GadgetPost
    def initialize(browser, parent_css)
      @browser = browser
      @parent_css = parent_css
    end

    def avatar
      @browser.div(:css => @parent_css + " .media-object[alt*=person]")
    end 

    def click_avatar
      avatar.when_present.click
    end  

    def title_link
      @browser.link(:css => @parent_css + " .customization-post-title")
    end 

    def title
      title_link.when_present.text
    end  

    def click_title_link
      title_link.when_present.click
    end  

    def content
      @browser.div(:css => @parent_css + " .customization-post-content")
    end

    def author_link
      @browser.link(:css => @parent_css + " .network-profile-link a")
    end 

    def click_author_link
      author_link.when_present.click
    end  

    def in_topic_link
      @browser.link(:css => @parent_css + " .in-topic a")
    end  

    def click_topic_link
      in_topic_link.when_present.click
    end 

    def view_count
      @browser.div(:css => @parent_css + " .view-count").when_present.text
    end

    def reply_count
      reply_icon.when_present.text
    end

    def reply_icon
      @browser.div(:css => @parent_css + " .reply-count")
    end 

    def click_reply_icon
      reply_icon.when_present.click
    end  

    def like_count
      like_icon.when_present.text
    end
    
    def like_icon
      @browser.div(:css => @parent_css + " .likeAction")
    end 

    def click_like_icon
      like_icon.when_present.click
    end 

    def liked?
      like_icon.when_present.class_name.include?("likes-count-solid")
    end

    def featured?
      @browser.span(:css => @parent_css + " .details .featured").present?
    end  
  end
end

class Gadgets::Community::FeaturedQ < Gadgets::Community::HomeConversations
  def initialize(config)
    super(config, ".widget.-featured-questions")
  end
end

class Gadgets::Community::OpenQ < Gadgets::Community::HomeConversations
  def initialize(config)
    super(config, ".widget.-open-questions")
  end
end

class Gadgets::Community::FeaturedB < Gadgets::Community::HomeConversations
  def initialize(config)
    super(config, ".widget.-featured-blogs")
  end
end

class Gadgets::Community::FeaturedR < Gadgets::Community::HomeConversations
  def initialize(config)
    super(config, ".widget.-featured-reviews")
  end
end

class Gadgets::Community::HomeContent < Gadgets::Base
  def initialize(config)
    super(config, ".gadget-home-content")
  end
end
 