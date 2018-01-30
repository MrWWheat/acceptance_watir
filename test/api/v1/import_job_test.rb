require 'airborne'
require_relative '../api_test_config'

describe 'Import Job' do
  puts 'Import Job APIs'

  before(:all) {
    @config = APITestConfig.new
    @api_base_url = '/api/v1/OData'
    @network_id_get = @config.api_data['network_id_get']
    @headers = { :Authorization => "Bearer #{@config.access_token}",
                :Accept => "application/json",
                :content_type => "application/json",
                :verify_ssl => false }

    body = {"d":{}}
    response = post "#{@api_base_url}/Networks('#{@network_id_get}')/ImportJobs",body, @headers
    expect_status(201)
    @job_id = JSON.parse(response)["d"]["results"]["Id"]
  }

  it 'File upload to import jobs' do
    body = {:multipart => true, :file => File.new(@config.data_dir + '/import_review.csv', "rb")}  
    response = post "#{@api_base_url}/ImportJobs('#{@job_id}')/FileUpload()",body, @headers
    expect_status(204)
  end

  it 'Get a specific ImportJob' do
    response = get "#{@api_base_url}/ImportJobs('#{@job_id}')", @headers
    expect_status(200)
    expect_json_keys(
      "d.results", [:Id, :Status, :Total, :Success, :Fail, :Fail]
    )
    expect_json(
      "d.results", Id: @job_id
    )
  end
  
end
