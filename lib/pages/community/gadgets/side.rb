require 'pages/community/gadgets/base'

class Gadgets::Community::Side < Gadgets::Base
  def link(type:, condition_type:, condition_val:)
    raise "Not implemented yet"
  end  
end  

class Gadgets::Community::SideSignIn < Gadgets::Community::Side
  def initialize(config)
    super(config, ".side-gadget.gadget-side-sign")
  end

  def signin_link
    @browser.link(:css => @gadget_css + " a[href$=sign_in]")
  end 

  def register_link
    @browser.link(:css => @gadget_css + " a[href$=sign_up]")
  end 

  def link(type:, condition_type: nil, condition_val: nil)
    case type
    when :signin
      signin_link
    when :register
      register_link
    end  
  end  
end

# side gadget - Live Chat
class Gadgets::Community::SideLiveChat < Gadgets::Community::Side
  def initialize(config)
    super(config, ".side-gadget.gadget-live-chat")
  end
end

# side gadget - Trending Tags
class Gadgets::Community::SideTrendingTags < Gadgets::Community::Side
  def initialize(config)
    super(config, ".side-gadget.gadget-trend-tags")
  end

  def tag_items
    @browser.links(:css => @gadget_css + " .tag-item a")
  end  

  def link(type: nil, condition_type: :index, condition_val: 0)
    tag_items[condition_val] 
  end 
end

# side gadget - Topics
class Gadgets::Community::SideFeaturedTopics < Gadgets::Community::Side
  def initialize(config)
    super(config, ".side-gadget.gadget-featured-topics")
  end

  def topics
    result = []

    @browser.lis(:css => @gadget_css + " li").each_with_index do |item, index|
      result << FeaturedTopic.new(@browser, @gadget_css + " li:nth-child(#{index+1})")
    end

    result  
  end

  def topic_at_title(title)
    topics.find { |t| title.include?(t.title) || title.include?(t.title.match(/(.*)...$/)[1]) }
  end  

  def link(type:, condition_type: :index, condition_val: 0)
    case condition_type
    when :index  
      case type
      when :title 
        topics[condition_val].title_link
      when :avatar
        topics[condition_val].avatar
      end 
    when :title
      case type
      when :title
        topic_at_title(condition_val).title_link
      when :avatar
        topic_at_title(condition_val).avatar
      end  
    end    
  end 

  class FeaturedTopic
    def initialize(browser, parent_css)
      @browser = browser
      @parent_css = parent_css
    end 

    def title_link
      @browser.link(:css => @parent_css + " .side-gadget-link")
    end 

    def title
      title_link.when_present.text
    end 

    def avatar
      @browser.div(:css => @parent_css + " [class*=avatar]")
    end 

    def followers_count
      @browser.element(:css => @parent_css + " .media-body .meta-text").when_present.text.match(/(\d*)/)[1]
    end 
  end 
end

# side gadget - Join the Conversation
class Gadgets::Community::SideJoinConversation < Gadgets::Community::Side
  def initialize(config)
    super(config, ".side-gadget.gadget-join-conversation")
  end

  def ask_question_link
    @browser.div(:css => @gadget_css).link(:text => /Question/)
  end
  
  def add_blog_link
    @browser.div(:css => @gadget_css).link(:text => /Blog/)
  end 

  def link(type:, condition_type: nil, condition_val: nil)
    case type
    when :question
      ask_question_link
    when :blog
      add_blog_link
    end
  end  
end

# side gadget - Related Products
class Gadgets::Community::SideRelatedProducts < Gadgets::Community::Side
  def initialize(config)
    super(config, ".side-gadget.gadget-related-products")
  end

  def product_links
    @browser.links(:css => @gadget_css + " .side-gadget-link")
  end

  def link(type: nil, condition_type: :index, condition_val: 0)
    product_links[condition_val]
  end  
end

# side gadget - Recently Mentioned Products
class Gadgets::Community::SideRecentMentiondProds < Gadgets::Community::Side
  def initialize(config)
    super(config, ".side-gadget.gadget-recently-mentioned-products")
  end
end

# side gadget - Popular Answers
class Gadgets::Community::SidePopularAnswers < Gadgets::Community::Side
  def initialize(config)
    super(config, ".side-gadget.gadget-popular-answers")
  end

  def answers
    result = []

    @browser.lis(:css => @gadget_css + " li").each_with_index do |item, index|
      result << PopularAnswer.new(@browser, @gadget_css + " li:nth-child(#{index+1})")
    end

    result  
  end 

  def link(type: nil, condition_type: :index, condition_val: 0)
    case type
    when :title
      answers[condition_val].title_link
    when :author 
      answers[condition_val].author_link
    end  
  end

  class PopularAnswer
    def initialize(browser, parent_css)
      @browser = browser
      @parent_css = parent_css
    end

    def title_link
      @browser.link(:css => @parent_css + " .text a")
    end  

    def title
      title_link.when_present.text
    end 

    def author_link
      @browser.link(:css => @parent_css + " .author a")
    end 

    def author
      author_link.when_present.text
    end  

    def like_count
      @browser.div(:css => @parent_css + " .author").when_present.text.match(/(\d*)$/)[1]
    end  
  end  
end

# side gadget - Top Contributors
class Gadgets::Community::SideTopContributors < Gadgets::Community::Side
  def initialize(config)
    super(config, ".side-gadget.gadget-top-contributors")
  end

  def user_items
    @browser.links(:css => @gadget_css + " .network-profile-pill a")
  end

  def user_item_at_index(index)
    @browser.link(:css => @gadget_css + " .media-list li:nth-child(#{index+1}) .network-profile-pill a")
  end 

  def link(type: nil, condition_type: :index, condition_val: 0)
    user_item_at_index(condition_val)
  end 
end

# side gadget - Recent Searches
class Gadgets::Community::SideRecentSearches < Gadgets::Community::Side
  def initialize(browser)
    super(browser, ".side-gadget.gadget-recently-search:not(.gadget-related-search)")
  end

  def link(type: nil, condition_type: :text, condition_val:)
    @browser.div(:css => @gadget_css).link(:class => /side-gadget-link/, :text => condition_val)
  end 
end

# side gadget - Featured Posts
class Gadgets::Community::SideFeaturedPosts < Gadgets::Community::Side
  def initialize(config)
    super(config, ".side-gadget.gadget-featured-posts")
  end

  def posts
    result = []

    @browser.lis(:css => @gadget_css + " li").each_with_index do |item, index|
      result << FeaturedPost.new(@browser, @gadget_css + " li:nth-child(#{index+1})")
    end

    result  
  end

  def posts_at_title(title)
    posts.find { |t| title.include?(t.title) || title.include?(t.title.match(/(.*)...$/)[1]) }
  end  

  def link(type:, condition_type: :index, condition_val: 0)
    case condition_type
    when :index  
      case type
      when :title 
        posts[condition_val].title_link
      when :author
        posts[condition_val].author_link
      end 
    when :title
      case type
      when :title
        posts_at_title(condition_val).title_link
      when :author
        posts_at_title(condition_val).author_link
      end  
    end    
  end

  class FeaturedPost
    def initialize(browser, parent_css)
      @browser = browser
      @parent_css = parent_css
    end

    def title_link
      @browser.link(:css => @parent_css + " .side-gadget-link")
    end 

    def title
      title_link.when_present.text
    end 

    def author_link
      @browser.link(:css => @parent_css + " .author .network-profile-pill a")
    end 
  end
end

  # side gadget - Open Questions
class Gadgets::Community::SideOpenQuestions < Gadgets::Community::Side
  def initialize(config)
    super(config, ".side-gadget.gadget-open-questions")
  end

  def posts
    result = []

    @browser.lis(:css => @gadget_css + " li").each_with_index do |item, index|
      result << OpenQuestion.new(@browser, @gadget_css + " li:nth-child(#{index+1})")
    end

    result  
  end

  def posts_at_title(title)
    posts.find { |t| title.include?(t.title) }
  end  

  def link(type:, condition_type: :index, condition_val: 0)
    case condition_type
    when :index  
      case type
      when :title 
        posts[condition_val].title_link
      when :author
        posts[condition_val].author_link
      end 
    when :title
      case type
      when :title
        posts_at_title(condition_val).title_link
      when :author
        posts_at_title(condition_val).author_link
      end  
    end    
  end

  class OpenQuestion
    def initialize(browser, parent_css)
      @browser = browser
      @parent_css = parent_css
    end

    def title_link
      @browser.link(:css => @parent_css + " .side-gadget-link")
    end 

    def title
      title_link.when_present.text
    end 

    def author_link
      @browser.link(:css => @parent_css + " .author .network-profile-pill a")
    end

    def author
      author_link.when_present.text
    end  

    def like_count
      @browser.div(:css => @parent_css + " .author").when_present.text.match(/(\d*)$/)[1]
    end
  end
end
