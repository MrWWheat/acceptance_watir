require 'airborne'
require_relative '../api_test_config'

describe 'Network' do
  puts 'Network APIs v2'

  before(:all) {
    @config = APITestConfig.new
    @api_base_url = '/api/v2'

    @headers = { :Authorization => "Bearer #{@config.access_token}",
                 :Accept => "application/json",
                 :content_type => "application/json",
                 :verify_ssl => false }
  }

  it 'Get network' do
    get "#{@api_base_url}/network", @headers

    expect_status(200)
    expect_json_keys('data', [:slug, :domain, :name])
  end

end