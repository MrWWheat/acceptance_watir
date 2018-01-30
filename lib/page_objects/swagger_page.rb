require_relative "./page_object"

class SwaggerPageObject < PageObject

  APIS = {
    	:get_topics => "Network_get_Networks_id_Topics",
    	:post_conversation => "Topic_post_Topics_id_Conversations",
    	:patch_conversation => "Conversation_patch_Conversations_id",
    	:delete_conversation => "Conversation_delete_Conversations_id"
  }
  attr_reader :response
  attr_reader :response_code
  def initialize(browser)
    super
    @swagger_url = $community_base_url + "/swagger/index.html"
    @swagger_container = @browser.div(:id => "swagger-ui-container")
    @current_api = @browser.div(:id => APIS[:get_topics])
    @oauth_token = @browser.text_field(:id => "input_apiKey")
    @set_token = @browser.div(:id => "explore")
  end

  def open
    @browser.goto @swagger_url
    check_loaded
  end

  def check_loaded
    @browser.wait_until{ @swagger_container.present? }
  end

  def set_oauth_token token
  	@oauth_token.when_present.set token
  	@set_token.when_present.click
  	check_loaded
  end

  def send_api api_key, params
    go_to_api(APIS[api_key])
    params.each do |key,value|
      input(key.to_s, value)
    end   
    try
    @response
  end

  def go_to_api key
  	@current_api = @browser.li(:id => key)
  	@browser.execute_script('arguments[0].scrollIntoView();', @current_api)
  end

  def try
  	@current_api.input(:name => "commit").when_present.click
  	current_dialog = @current_api.div(:id => "modal-" + @current_api.id)
  	@browser.wait_until{ current_dialog.present? }
  	@response_code = current_dialog.div(:class => "response_code").text.to_i
  	response = current_dialog.div(:class => "response_body").text
  	begin
	  @response = JSON.parse(response)
	rescue JSON::ParserError => e
	  @response = nil
	end
	current_dialog.button.when_present.click
  end

  def input(key, value)
    @current_api.text_field(:name => key).when_present.set value
  end
end