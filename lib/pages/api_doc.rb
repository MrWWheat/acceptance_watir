require 'pages/base'
require 'httparty'
require 'json'

class Pages::APIDoc < Pages::Base

  def initialize(config, options = {})
    super(config)
  end

  def self.layout_class
    Pages::APIDoc
  end

  def get_token
	ouath_app = get_app_id_secret_api
	body = {"grant_type": "password",
	      "client_id": ouath_app[:app_id],
	      "client_secret": ouath_app[:app_secret],
	      "username": @c.users[:network_admin].username,
	      "password": @c.users[:network_admin].password}
	oauth_url = @c.base_url + "/oauth/token"
	response = HTTParty.post(oauth_url, :body => body, :verify => false)
	response.parsed_response["access_token"]
  end

  def get_app_id_secret_api
    puts "get app id and secret"
    rtn = api_login_community(@c.users[:network_admin])
    json = JSON.parse(rtn.to_json)
    cookie = api_get_cookie(rtn)
    csrfToken = JSON.parse(rtn.body)['csrfToken']

    headers = {
      "Cookie" => cookie,
      "Content-Type" => "application/json"
    }

    get_app_id_secret_url = "#{@c.base_url}/api/v1/OData/Networks('#{@c.slug}')/OAuthApplications"

    response = HTTParty.get(get_app_id_secret_url, :headers => headers, :verify => false)
    oauth = {
      :app_id => response.parsed_response["d"]["results"][0]["Uid"],
      :app_secret => response.parsed_response["d"]["results"][0]["Secret"]
    }  
  end

  def api_get_cookie(resp)
    mtch = resp.headers['set-cookie'].match(/_excelsior_session=\w+\;/)[0]
  end

  def api_get_csrf_token(resp)
    csrf = resp.body.match('<meta name="csrf-token" content="(?<csrf>.*)" \/>')["csrf"]
  end

  def api_login_community(community_user)
    iframe_url = @c.base_url + "/iframe/comment"
    sign_in_url = @c.base_url + "/registered_users/sign_in.json"
    resp = HTTParty.get(iframe_url,  :verify => false)

    cookie = api_get_cookie(resp)
    crsf_token = api_get_csrf_token(resp)

    headers = {
      "Cookie" => "#{cookie}",
      "X-CSRF-Token" => "#{crsf_token}",
      "Content-Type" => "application/json"
    }

    post_data = {"registered_user": {"login": community_user.username, "password": community_user.password,"network_slug": @c.slug},"utf8": "✓"}.to_json

    rtn = HTTParty.post(sign_in_url, body: post_data, :headers => headers, :verify => false)
  end

  def api_register_user user
    token = get_token
    post_body = {
      "firstname": user.username,
      "lastname": user.username,
      "username": user.username,
      "password": user.password,
      "confirm_password": user.password,
      "email": user.email
    }
    headers = {:Authorization => "Bearer #{token}", 
                :Accept => "application/json", 
                :content_type => "application/json", 
                :verify_ssl => false}  
    register_url = @c.base_url + "/api/v2/members/register"
    response = HTTParty.post(register_url, :body => post_body, :header => headers, :verify => false)
    response["status"]
  end

  def start!
  	@browser.goto @url
    if @browser.url.include? "dev-portal"
      @browser.link(:href => "#/api-list").when_present.click
      @browser.link(:href => "#/api-all").when_present.click
      @browser.wait_until { token_span.present? }
    else
      @browser.wait_until{ oauth_token.present? }
    end
  end

  def check_loaded
    @browser.wait_until{ @swagger_container.present? }
  end

  def set_oauth_token token
  	@oauth_token.when_present.set token
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