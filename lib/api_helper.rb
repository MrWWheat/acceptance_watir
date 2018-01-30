require 'httparty'

class ApiHelper
   
  def initialize(config)
    @config = config
    @user_sessions = {}
  end

  def establish_session(user)
    get(user, "/version")
  end

  def get(user, url, options = {})

    if user == "anon" 
      if options[:query]
      response = HTTParty.get(@config.base_url + url, headers: {"Content-Type" => "application/json",
      "Accept" => "application/json"}, query: options[:query], :verify => false)
      else
       response = HTTParty.get(@config.base_url + url, headers: {"Content-Type" => "application/json",
      "Accept" => "application/json"}, :verify => false)
      end
    else
     headers = get_headers_for_user(user).merge("Accept" => "application/json")
     response = HTTParty.get(@config.base_url + url, headers: headers, :verify => false)
    end
    #request(user,:get, url)
  end

  def post(user, url, options = {})
     headers = get_headers_for_user(user).merge("Accept" => "application/json", "Content-Type" => "application/json")
     headers.merge(options[:headers]) if options[:headers]
  
    if options[:body]
      HTTParty.post(@config.base_url + url, headers: headers, body: options[:body], :verify => false)
    else
      HTTParty.post(@config.base_url + url, headers: headers, :verify => false)
    end
  end

  def delete(user, url, options = {})
    headers = get_headers_for_user(user).merge("Accept" => "application/json")
    headers.merge(options[:headers]) if options[:headers]
    if options[:body]
      HTTParty.delete(@config.base_url + url, headers: headers, body: options[:body], :verify => false)
    else
      HTTParty.delete(@config.base_url + url, headers: headers, :verify => false)
    end
  end

  def get_headers_for_user(user)
    @user_sessions[user.user_ref] ||= ApiHelper::UserSession.new(@config, user)
    @user_sessions[user.user_ref].headers
  end

  def get_mapping_uid_for_user(user)
    @user_sessions[user.user_ref].mapping_uid
  end

  def get_uuid_for_user(user)
    establish_session(user)
    @user_sessions[user.user_ref].uuid
  end

  class UserSession

    attr_reader :user, :csrfToken, :cookie, :uuid, :mapping_uid
    def initialize(config, user)
      @config = config
      @user = user
      establish!
    end

    def establish!
      # byebug
      response = HTTParty.get(@config.base_url + "/n/#{@config.slug}/members/sign_in", :verify => false)
      #response = HTTParty.get(@config.base_url + "/iframe/comment", "verify" => false)

      token = Hash[response.body.split("\n").grep(/meta.*csrf/).map(&:strip).map { |meta| meta =~ /name="(.*?)" content="(.*?)"/ && [$1, $2] }]

      cookie = self.class.session_cookie_from_response(response)

      headers = { "Cookie" => cookie, "X-CSRF-Token" => token["csrf-token"],"Content-Type" => "application/json", "Accept" => "application/json" }

      post_data = {"registered_user": {"login": @user.username, "password": @user.password, "network_slug": @config.slug},"utf8": "✓"}

      login_response = HTTParty.post(@config.base_url + "/registered_users/sign_in", body: post_data.to_json, headers: headers, :verify => false)
      @cookie = self.class.session_cookie_from_response(login_response)
      @csrfToken = JSON.parse(login_response.body)['csrfToken']
      @uuid = JSON.parse(login_response.body)['uuid']
      @mapping_uid = JSON.parse(login_response.body)['mapping_uid']
    end

    def self.session_cookie_from_response(response)
      response.headers['set-cookie'].match(/_excelsior_session=\w+/)[0]
    end

    def headers
      { "Cookie" => @cookie, "X-CSRF-Token" => @csrfToken }
    end
  end
end