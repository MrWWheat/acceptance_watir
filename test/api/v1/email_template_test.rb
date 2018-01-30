require 'airborne'
require_relative '../api_test_config'

describe 'Email Template' do
  puts 'Email Template APIs'

  before(:all) {
    @config = APIConfig.new
    @api_base_url = @config.base_url + '/api/v1/OData'
    @users = @config.users
  }

  # Sample
  # it 'Get topic by ID' do
  #   get "https://ch-candidate-b2c.mo.sap.corp/api/v1/OData/Topics('TsKYviHSS6z9ECPlpgznvX').json"
  #   expect_json('d.results', Title: 'DC Car Battery Adapter')
  # end
  
  
end
