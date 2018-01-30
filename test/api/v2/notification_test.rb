require 'airborne'
require_relative '../api_test_config'

describe 'Notification' do
  puts 'Notification APIs v2'

  before(:all) {
    @config = APITestConfig.new
    @api_base_url = '/api/v2'

    @headers = { :Authorization => "Bearer #{@config.access_token}",
                 :Accept => "application/json",
                 :content_type => "application/json",
                 :verify_ssl => false }
  }

  it 'Get notifications' do
    get "#{@api_base_url}/notifications", @headers

    expect_status(200)
    expect_json_keys('data.*', [:id, :followable_type, :is_read, :is_event_target_creator, :event_type, :notification_type, :new_conversation_count])
  end

end