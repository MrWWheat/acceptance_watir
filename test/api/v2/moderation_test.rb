require 'airborne'
require_relative '../api_test_config'

describe 'Moderation' do
  puts 'Moderation APIs v2'

  before(:all) {
    @config = APITestConfig.new
    @api_base_url = '/api/v2'

    @headers = { :Authorization => "Bearer #{@config.access_token}",
                 :Accept => "application/json",
                 :content_type => "application/json",
                 :verify_ssl => false }
  }

  it 'Get moderation' do
    get "#{@api_base_url}/moderation", @headers

    expect_status(200)
    expect_json_keys('data', [:type, :profanity_enabled, :threshold])
  end

  it 'Patch moderation' do
    # backup the old moderation settings
    get "#{@api_base_url}/moderation", @headers

    expect_status(200)
    old_type = JSON.parse(response)["data"]["type"]
    old_threshold = JSON.parse(response)["data"]["threshold"]

    # update the moderation settings
    body = {
        :type => "pending_admin_moderation_post_shown",
        :profanity_enabled => true,
        :threshold => 3
    }
    patch "#{@api_base_url}/moderation", body, @headers

    expect_status(200)
    expect_json_keys('data', [:type, :profanity_enabled, :threshold])

    # revert to the old setting
    body = {
        :type => old_type,
        :profanity_enabled => true,
        :threshold => old_threshold
    }

    patch "#{@api_base_url}/moderation", body, @headers

    expect_status(200)
  end

end