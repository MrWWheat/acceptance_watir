require 'pages/api_doc'
require 'minitest/assertions'

class Pages::APIDoc::DevPortal < Pages::APIDoc

  def initialize(config, options = {})
    super(config)
    @url = config.base_url + "/dev-portal/"
    @APIS = {
        :get_topics => "#/api-all/topics/topics/get",
        :post_conversation => "#/api-all/topics/topics_topic_id_questions/post",
        :patch_conversation => "#/api-all/questions/questions_id/patch",
        :delete_conversation => "#/api-all/questions/questions_id/delete"
    }
  end

  portal_container   	  { main(:id => "content") }
  raml_form			  { form(:class => "raml-console-sidebar") }
  oauth_token  		  { text_field(:id => "headers-token") }
  token_span        { span(:text => /Token:/)}
  try_tab	 		  { li(:text => /Try it/)  }
  current_api_li      { link(:href => @APIS[@current_api]) }
  submit_button 	  { button(:type => "submit", :class => "raml-console-sidebar-action")}
  body_input	      { div(:class => "CodeMirror-code") }
  response_div 		  { div(:class => "raml-console-sidebar-response") }
  response_text		  { div(:class => "raml-console-sidebar-response").div(:class => "") }



  def set_oauth_token token
    oauth_token.when_present.set token
  end

  def send_api api_key, params
    current_api_parent_li = @browser.a(:text => /#{@APIS[api_key].split("/")[2]}/)
    current_api_parent_li.when_present.click unless current_api_parent_li.parent.when_present.class_name.end_with?("expand")
    sleep 1
    current_api_li = @browser.link(:href => @APIS[api_key])
    current_api_li.when_present.click
    @browser.wait_until{ try_tab.present? }
    try_tab.when_present.click
    @browser.wait_until{ body_input.present? ||raml_form.present?}
    sleep 1
    params.each do |key,value|
      if value.is_a? Hash
        body_input.when_present.click
        @browser.send_keys value.to_json
      else
        raml_form.text_field(:name => key.to_s).when_present.set value
      end
    end
    submit_button.when_present.click
    @browser.wait_until{ response_div.present? }
    response_div.when_present.text
  end

  def get_topics_api
    params = {}
    send_api(:get_topics,params)
  end

  def post_conversation_api topic_id, title, content
    body = {"title": title,
            "html_content": content
    }
    params = {
        "topic_id": topic_id,
        "body": body
    }

    send_api(:post_conversation,params)
  end

  def patch_conversation_api conversation_id, title, content
    body = {"title": title,
            "html_content": content
    }
    params = {
        "id": conversation_id,
        "body": body
    }
    send_api(:patch_conversation,params)
  end

  def delete_conversation_api conversation_id
    params = {
        "id": conversation_id
    }
    send_api(:delete_conversation,params)
  end

end