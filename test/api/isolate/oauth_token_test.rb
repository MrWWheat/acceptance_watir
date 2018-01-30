require 'airborne'
require_relative '../api_test_config'

describe 'Oauth token test' do
  puts 'Oauth token test'

  before(:all) {
    @c = APITestConfig.new
    @token_headers = { 'Content-Type' => 'application/json', 'Accept' => 'application/json' }
    @app_id = @c.api_data['application_id']
    @sec_id = @c.api_data['secret_id']
    @base_url = @c.base_url
    @slug = @c.slug
  }

  it 'use client credential to visit V2' do
    access_token = get_access_token_by_client_credential
    isAdmin = check_permission_via_v2(access_token)
    expect(isAdmin).to be false
  end

  it 'use admin to visit V2' do
    access_token = get_access_token_by_password(:network_admin)
    isAdmin = check_permission_via_v2(access_token)
    expect(isAdmin).to be true
  end

  it 'use normal user to visit V2' do
    access_token = get_access_token_by_password(:regular_user1)
    isAdmin = check_permission_via_v2(access_token)
    expect(isAdmin).to be false
  end

  it 'use admin to visit V1' do
    access_token = get_access_token_by_password(:network_admin)
    isAdmin = check_permission_via_v1(access_token)
    expect(isAdmin).to be true
  end

  it 'use normal user to visit V1' do
    access_token = get_access_token_by_password(:regular_user1)
    isAdmin = check_permission_via_v1(access_token)
    expect(isAdmin).to be false
  end

  def get_access_token_by_password(user)
    @username = @c.users[user].username
    @password = @c.users[user].password
    url = "#{@base_url}/oauth/token?grant_type=password&client_id=#{@app_id}&client_secret=#{@sec_id}&username=#{@username}&password=#{@password}"
    response = HTTParty.post(url, body: nil, headers: @token_headers, :verify => false)
    return JSON.parse(response.body)['access_token'] if response.code == 200
    return nil
  end

  def get_access_token_by_client_credential
    url = "#{@base_url}/oauth/token?grant_type=client_credentials&client_id=#{@app_id}&client_secret=#{@sec_id}"
    response = HTTParty.post(url, body: nil, headers: @token_headers, :verify => false)
    return JSON.parse(response.body)['access_token'] if response.code == 200
    return nil
  end

  def check_permission_via_v1(access_token)
    headers = { :Authorization => "Bearer #{access_token}",
                 :Accept => "application/json",
                 :content_type => "application/json",
                 :verify_ssl => false }
    response = get "/api/v1/OData/Networks('#{@slug}').json", headers
    expect_status(200)
    permission = JSON.parse(response)["d"]["results"]["Permissions"]
    permission["CanSetLayout"] == true && permission["CanEcommerceIntegration"] == true
  end

  def check_permission_via_v2(access_token)
    headers = { :Authorization => "Bearer #{access_token}",
                 :Accept => "application/json",
                 :content_type => "application/json",
                 :verify_ssl => false }
    response = get "/api/v2/network?_extends=[\"permissions\"]", headers
    expect_status(200)
    permission = JSON.parse(response)["data"]["_permissions"]
    permission.include?("set_layout") && permission.include?("ecommerce_integration")
  end
end