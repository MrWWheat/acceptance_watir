require 'pages/community/conversation/conversation_input'

class Pages::Community::ConversationEdit < Pages::Community::ConversationInput
  def initialize(config, options = {})
    super(config)

    @parent_css = ".edit-post"
  end
end