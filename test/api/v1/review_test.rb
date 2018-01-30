require 'airborne'
require_relative '../api_test_config'
require_relative '../helper/api_test_data_builder'

describe 'Review API' do
  puts 'Review APIs'
  include APITestDataBuilder

  before(:all) {
    @config = APITestConfig.new
    @api_url = '/api/v1/OData'

    # @review_id_get = @config.api_data["review_id_get"]
    @topic_uuid = @config.api_data['topic_id_get']

    @headers = {:Authorization => "Bearer #{@config.access_token}", 
                :Accept => "application/json", 
                :content_type => "application/json", 
                :verify_ssl => false}

    # create a review before test the following api
    review_obj = create_review_in_topic(@topic_uuid, @api_url, @headers)

    @conv_uuid = review_obj.conversation_id
    @root_post_id = review_obj.root_post_id
    @review_id = review_obj.review_id
  }

  after(:all) {
    # delete the review
    delete "#{@api_url}/Conversations('#{@conv_uuid}')", nil, @headers
    expect_status(204)
  }

  # Test these APIs:
  # => [GET] /Reviews('{id}')
  it 'should get a specific review' do
    get "#{@api_url}/Reviews('#{@review_id}')", @headers
    expect_status(200)
    expect_json("d.results", Id: @review_id, Recommended: true, Purchased: false)
  end 

  # Test these APIs:
  # => [PATCH] /Reviews('{id}')
  it 'should update a specific review' do
    body = {d: {Recommended: false, RatingValue: 4}}
    patch "#{@api_url}/Reviews('#{@review_id}')", body, @headers
    expect_status(204)
  end  
end
