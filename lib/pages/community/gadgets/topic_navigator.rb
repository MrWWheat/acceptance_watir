require 'pages/community/gadgets/base'

class Gadgets::Community::TopicNavigator < Gadgets::Base
  def initialize(config)
    super(config, ".gadget-topic-navigator")
  end

  def floated?
    @browser.div(:css => @gadget_css + " .topic-fixed-navigator").present?
  end
  
  def selected_filter
    @browser.div(:css => @gadget_css + " .topic-filter-selected")
  end  

  def questions_filter_link
    @browser.element(:css => @gadget_css + " .topic-filter [data-hash='#topic-conversation-questions']")
  end
  
  def blogs_filter_link
    @browser.element(:css => @gadget_css + " .topic-filter [data-hash='#topic-conversation-blogs']")
  end

  def reviews_filter_link
    @browser.element(:css => @gadget_css + " .topic-filter [data-hash='#topic-conversation-reviews']")
  end 

  def toolbar
    @browser.div(:css => @gadget_css + " .btn-toolbar")
  end

  def create_new_btn
    @browser.button(:css => @gadget_css + " .btn-toolbar .btn-primary")
  end  

  def create_new_question_menu_item
    @browser.ul(:css => ".topic-follow-button .dropdown .dropdown-menu").link(:text => "Question")
  end
  
  def create_new_blog_menu_item
    @browser.ul(:css => ".topic-follow-button .dropdown .dropdown-menu").link(:text => "Blog")
  end

  def create_new_review_menu_item
    @browser.ul(:css => ".topic-follow-button .dropdown .dropdown-menu").link(:text => "Review")
  end  

  def follow_topic_btn
    toolbar.button(:text => "Follow Topic")
  end

  def unfollow_topic_btn
    toolbar.button(:text => "Unfollow Topic")
  end 

  def selected_filter_type
    selected_filter_text = selected_filter.when_present.text

    post_type = nil
    case selected_filter_text
    when "Questions"
      post_type = :question
    when "Blogs"
      post_type = :blog
    when "Reviews"
      post_type = :review
    else
      raise "Cannot recogize the filter type #{selected_filter_text}"
    end

    return post_type
  end

  def select_filter_type(type)
    case type
    when :question
      questions_filter_link.when_present.click
      sleep 2
      @browser.wait_until { selected_filter_type == type } 
    when :blog
      blogs_filter_link.when_present.click
      sleep 2
      @browser.wait_until { selected_filter_type == type } 
    when :review
      reviews_filter_link.when_present.click
      sleep 2
      @browser.wait_until { selected_filter_type == :review || selected_filter_type == :blog } 
    else
      raise "Invalid filter type input: #{type}"  
    end
  end  
end