require 'pages/community/conversation/conversation_input'

class Pages::Community::ConversationCreate < Pages::Community::ConversationInput
  def initialize(config, options = {})
    super(config)

    @parent_css = ".create-conversation"
  end

  question_type_picker                      { div(:css => ".create-conversation .post-type.question") }
  discussion_type_picker                    { div(:css => ".create-conversation .post-type.discussion") }
  blog_type_picker                          { div(:css => ".create-conversation .post-type.blog") }

  def select_type(type)
    # scroll to top so as to avoid the controls are overlapped by navigation bar
    @browser.execute_script("window.scrollBy(0,-1000)")

    case type
    when :question
      question_type_picker.click unless question_type_picker.class_name.include?("chosen")
      @browser.wait_until { question_type_picker.class_name.include?("chosen") }
    # discussion is removed from Jam Community
    # when :discussion
    #   discussion_type_picker.click unless discussion_type_picker.class_name.include?("chosen")
    #   @browser.wait_until { discussion_type_picker.class_name.include?("chosen") }
    when :blog
      blog_type_picker.click unless blog_type_picker.class_name.include?("chosen")
      @browser.wait_until { blog_type_picker.class_name.include?("chosen") }
    else
      raise "Type #{type} not supported yet"    
    end 
  end  
end