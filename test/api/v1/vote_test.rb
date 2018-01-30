require 'airborne'
require_relative '../api_test_config'
require_relative '../helper/api_test_data_builder'

describe 'Vote' do
  puts 'Vote APIs'
  include APITestDataBuilder

  before(:all) {
    @config = APITestConfig.new
    @api_url = '/api/v1/OData'

    @topic_uuid = @config.api_data['topic_id_get']

    @headers = {:Authorization => "Bearer #{@config.access_token}", 
                :Accept => "application/json", 
                :content_type => "application/json", 
                :verify_ssl => false}
  }
  
  context 'after create a new question' do
    before(:context) do
      # create a new question
      question_obj = create_question_in_topic(@topic_uuid, @api_url, @headers)

      @q_title = question_obj.title
      @conv_uuid = question_obj.conversation_id
      @root_post_id = question_obj.root_post_id

      # vote up for the question
      @vote_up_id = vote_question(:up, @conv_uuid, @api_url, @headers)
    end

    after(:context) do
      # delete the conversation
      delete "#{@api_url}/Conversations('#{@conv_uuid}')", nil, @headers
      expect_status(204)
    end  

    # Test these APIs:
    # => [GET] /Votes('{id}')
    it 'can get a specific vote' do
      get "#{@api_url}/Votes('#{@vote_up_id}')", @headers
      expect_status(200)
      expect_json("d.results", Id: @vote_up_id)
    end 
  end  
end
