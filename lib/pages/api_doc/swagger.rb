require 'pages/api_doc'
require 'minitest/assertions'

class Pages::APIDoc::Swagger < Pages::APIDoc

  def initialize(config, options = {})
    super(config)
    @url = config.base_url + "/swagger/index.html"
    @APIS = {
    	:get_topics => "Network_get_Networks_id_Topics",
    	:post_conversation => "Topic_post_Topics_id_Conversations",
    	:patch_conversation => "Conversation_patch_Conversations_id",
    	:delete_conversation => "Conversation_delete_Conversations_id"
  }
  end

  swagger_container   	  { div(:id => "swagger-ui-container") }
  oauth_token  		  	  { text_field(:id => "input_apiKey") }
  set_token          	  { div(:id => "explore") }

  def set_oauth_token token
  	oauth_token.when_present.set token
  	set_token.when_present.click
  end

  def get_topics_api network
    params = {
      "id": network
    }
    send_api(:get_topics,params)
  end

  def post_conversation_api topic_id, title, content
    params = {
      "id": topic_id,
      "Conversation": "{\"d\":{\"HtmlContent\":\"<p>"+content+"</p>\",\"OriginalContent\":\""+content+"\",\"Title\":\""+title+"\",\"TypeTrait\":\"question\"}}"
    }
    send_api(:post_conversation,params)
  end
  
  def patch_conversation_api conversation_id, title, content
    params = {
      "id": conversation_id,
      "Conversation": "{\"d\":{\"HtmlContent\":\"<p>"+content+"</p>\",\"OriginalContent\":\""+content+"\",\"Title\":\""+title+"\",\"TypeTrait\":\"question\"}}"
    }
    send_api(:patch_conversation,params)
  end

  def delete_conversation_api conversation_id
    params = {
      "id": conversation_id
    }
    send_api(:delete_conversation,params)
  end

  def send_api api_key, params
    current_api = @browser.li(:id => @APIS[api_key])
    @browser.wait_until { current_api.present? }
  	scroll_to_element current_api
    params.each do |key,value|
      current_api.text_field(:name => key.to_s).when_present.set value
    end   
    current_api.input(:name => "commit").when_present.click
  	current_dialog = current_api.div(:id => "modal-" + current_api.id)
  	@browser.wait_until{ current_dialog.present? }
  	response_code = current_dialog.div(:class => "response_code").text.to_i
  	response = current_dialog.div(:class => "response_body").text
  	begin
	  response = JSON.parse(response)
	rescue JSON::ParserError => e
	  response = nil
	end
	current_dialog.button.when_present.click
    { :code => response_code, :response => response }
    
  end

end