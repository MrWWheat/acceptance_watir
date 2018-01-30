require 'airborne'
require_relative '../api_test_config'

# Usage:
#   APITestConfig will initialize the same as watir config
#   all api test related test data are put in /test/api/data/config.yml, such as topic_id_get, application_id, secret_id etc,.

#   NOTE:
#   When testing an API call which create data in test target system. Please make sure PATCH and DELETE testing in a single test if possible
#   otherwise, there will be additional preconditions to setup for every delete test.

describe 'Search' do
  puts 'Search APIs v2'

  before(:all) {
    @config = APITestConfig.new
    @api_base_url = '/api/v2'
    @search_keyword = @config.api_data['search_keyword']
    @headers = {:Authorization => "Bearer #{@config.access_token}",
                :Accept => "application/json",
                :content_type => "application/json",
                :verify_ssl => false}
  }

  it 'can search by key words' do
    get "#{@api_base_url}/search?q=#{@search_keyword}", @headers
    expect_status(200)
  end

end