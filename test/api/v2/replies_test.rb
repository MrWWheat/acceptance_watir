require 'airborne'
require_relative '../api_test_config'
require_relative '../helper/api_v2_test_data_builder'

describe 'Replies APIs' do
  puts 'Replies APIs'
  include APIV2TestDataBuilder

  before(:all) {
    @config = APITestConfig.new
    @api_url = '/api/v2'

    @blog_id = @config.api_data['blog_id_get']

    @headers = { :Authorization => "Bearer #{@config.access_token}",
                :Accept => "application/json",
                :content_type => "application/json",
                :verify_ssl => false }

    # create a reply before test the following api
    reply_obj = create_reply_in_blog(@blog_id, @api_url, @headers)

    @reply_id = reply_obj.id
    @reply_parent_id = reply_obj.parent_id
    @reply_html = reply_obj.html_content
  }

  after(:all) {
    # # delete the reply
    delete "#{@api_url}/replies/#{@reply_id}", nil, @headers
    expect_status(200)
  }

  # Test these APIs:
  # => [GET] /replies/{id}

  it 'should get a specific reply' do
    get "#{@api_url}/replies/#{@reply_id}", @headers
    expect_status(200)
    expect_json_keys('data', [:id, :contents, :html_content, :is_visible, :is_featured])
  end

  it 'should feature a reply' do
    post "#{@api_url}/replies/#{@reply_id}/feature", {}, @headers
    expect_status(200)
    expect_json('data.is_featured', true)
  end

  it 'should like a reply' do
    post "#{@api_url}/replies/#{@reply_id}/like", {}, @headers
    expect_status(200)
    expect_json('data.likes_count', 1)
  end

  it 'should unfeature a reply' do
    post "#{@api_url}/replies/#{@reply_id}/unfeature", {}, @headers
    expect_status(200)
    expect_json('data.is_featured', false)
  end

  it 'should unlike a reply' do
    post "#{@api_url}/replies/#{@reply_id}/unlike", {}, @headers
    expect_status(200)
    expect_json('data.likes_count', 0)
  end

  it 'should unlike a reply' do
    post "#{@api_url}/replies/#{@reply_id}/unlike", {}, @headers
    expect_status(200)
    expect_json('data.likes_count', 0)
  end

  it 'should flag a reply' do
    headers = { :Authorization => "Bearer #{@config.access_token_of_moderater}",
                :Accept => "application/json",
                :content_type => "application/json",
                :verify_ssl => false }

    post "#{@api_url}/replies/#{@reply_id}/flag", nil, headers
    expect_status(200)
    expect_json('data.flagged_by_logged_in_user', true)
    expect_json('data.moderation_status', 'moderation_status_temporarily_removed')
  end

  it 'should reinstate a reply' do
    headers = { :Authorization => "Bearer #{@config.access_token_of_moderater}",
                :Accept => "application/json",
                :content_type => "application/json",
                :verify_ssl => false }

    post "#{@api_url}/replies/#{@reply_id}/reinstate", nil, headers
    expect_status(200)
    expect_json('data.flagged_by_logged_in_user', true)
    expect_json('data.moderation_status', 'moderation_status_reinstated')
  end

  it 'should create a child reply and get the created child reply' do
    content = "<p>html content child reply #{Time.now.to_s}</p>"
    body = {"html_content": "#{content}"}
    post "#{@api_url}/replies/#{@reply_id}/child_replies", body, @headers
    expect_status(201)
    expect_json('data.parent_id', "#{@reply_id}")
    parent_id = JSON.parse(response)["data"]["parent_id"]

    get "#{@api_url}/replies/#{parent_id}/child_replies", @headers
    expect_status(200)
    expect_json('data.0.html_content', regex("child reply"))
  end



end
