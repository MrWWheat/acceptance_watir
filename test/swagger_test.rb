require File.expand_path(File.dirname(__FILE__) + "/hybris_watir_test.rb")
require File.expand_path(File.dirname(__FILE__) + "/../lib/test_helper.rb")
require File.expand_path(File.dirname(__FILE__) + "/../lib/hybris_test.rb")


class HybrisP1Test < HybrisWatirTest
  include HybrisTest
  @@token = nil
  @@topic_id = nil
  @@conversation_id = nil
  def setup
    super
    unless @@token
      ouath_app = get_app_id_secret_api
      body = {"grant_type": "password",
            "client_id": ouath_app[:app_id],
            "client_secret": ouath_app[:app_secret],
            "username": $communityadmin[0],
            "password": $communityadmin[1]}
      oauth_url = $community_base_url + "/oauth/token"
      response = HTTParty.post(oauth_url, :body => body, :verify => false)
      @@token = response.parsed_response["access_token"]
      puts "token: " + @@token
    end
    open_swagger  
    set_token @@token
  end

  def test_00010_test_swagger_get_api
    response = get_topics_api $network_slug
    assert_code get_response_code
    @@topic_id = response["d"]["results"][0]["Id"]
  end

  def test_00020_test_swagger_post_api
    unless @@topic_id
      set_topic_id
    end
    response = post_conversation_api @@topic_id, "question-#{get_timestamp}","content-#{get_timestamp}"
    assert_code get_response_code
    @@conversation_id = response["d"]["results"]["Id"]
  end

  def test_00030_test_swagger_patch_api
    unless @@conversation_id
      set_conversation_id
    end
    patch_conversation_api @@conversation_id, "question-#{get_timestamp}","content-#{get_timestamp}"
    assert_code get_response_code
  end

  def test_00040_test_swagger_delete_api
    unless @@conversation_id
      set_conversation_id
    end
    delete_conversation_api @@conversation_id
    assert_code get_response_code
  end

  def set_topic_id
    response = get_topics_api $network_slug
    @@topic_id = response["d"]["results"][0]["Id"]
  end

  def set_conversation_id
    set_topic_id
    response = post_conversation_api @@topic_id, "question-#{get_timestamp}","content-#{get_timestamp}"
    @@conversation_id = response["d"]["results"]["Id"]
  end

  def get_app_id_secret_api
    puts "get app id and secret"
    rtn = api_login_community($communityadmin)
    json = JSON.parse(rtn.to_json)
    cookie = api_get_cookie(rtn)
    csrfToken = JSON.parse(rtn.body)['csrfToken']

    headers = {
      "Cookie" => cookie,
      "Content-Type" => "application/json"
    }

    get_app_id_secret_url = "#{$community_base_url}/api/v1/OData/Networks('#{$network_slug}')/OAuthApplications"

    response = HTTParty.get(get_app_id_secret_url, :headers => headers, :verify => false)
    oauth = {
      :app_id => response.parsed_response["d"]["results"][0]["Uid"],
      :app_secret => response.parsed_response["d"]["results"][0]["Secret"]
    }  
  end

  def assert_code code
    assert code == 200 || code == 201 || code == 204
  end
end