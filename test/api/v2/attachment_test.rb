require 'airborne'
require_relative '../api_test_config'
require_relative '../helper/api_v2_test_data_builder'

attachment_id = ""
attachment_url = ""
attachment_filename = "test.png"
attachment_blog_id = ""
describe 'Attachment' do
  puts 'attachment api test v2'
  include APIV2TestDataBuilder
  before(:all) {
    @config = APITestConfig.new
    @api_base_url = '/api/v2'
    @topic_id_get = @config.api_data['topic_id_get']
    @headers = { :Authorization => "Bearer #{@config.access_token}",
                :Accept => "application/json",
                :content_type => "application/json",
                :verify_ssl => false }
  }

  it 'add attachments' do
    body = {:multipart => true, :filename => attachment_filename, :file => File.new(@config.data_dir + '/test.png', "rb")}  
    response = post "#{@api_base_url}/attachments",body, @headers
    expect_status(201)
    expect_json_keys('data', [:id, :filename, :url, :filesize])
    data = JSON.parse(response)["data"]
    attachment_id = data["id"]
    attachment_url = data["url"]
    #a issue found
    attachment_filename = data["filename"]
  end

  it 'get attachments' do
    response = get "#{@api_base_url}/attachments/#{attachment_id}", @headers
    expect_status(200)
    expect_json_keys('data', [:id, :filename, :url, :filesize])
    expect_json("data.url", attachment_url)
    expect_json("data.filename", attachment_filename)
  end

  it 'update attachments' do
    attachment_filename = "changed" + attachment_filename
    body = {:filename => attachment_filename}
    reponse = put "#{@api_base_url}/attachments/#{attachment_id}",body, @headers
    expect_status(200)
    expect_json_keys('data', [:id, :filename, :url, :filesize])
    expect_json("data.filename", attachment_filename)

    attachment_filename = "edit" + attachment_filename
    body = {:filename => attachment_filename}
    reponse = patch "#{@api_base_url}/attachments/#{attachment_id}",body, @headers
    expect_status(200)
    expect_json_keys('data', [:id, :filename, :url, :filesize])
    expect_json("data.filename", attachment_filename)
  end

  it 'link attachments' do
  	blog = create_conversation_in_topic("blog", @topic_id_get, @api_base_url, @headers)
    attachment_blog_id = blog[:id]
    body = { :attachment_id => attachment_id }
    response = post "#{@api_base_url}/blogs/#{attachment_blog_id}/link_attachment", body, @headers
    expect_status(200)
    expect_json_keys('data', [:id, :filename, :url, :filesize])
    expect_json("data.filename", attachment_filename)
    expect_json("data.id", attachment_id)

    question = create_conversation_in_topic("question", @topic_id_get, @api_base_url, @headers)
    attachment_question_id = question[:id]
    body = { :attachment_id => attachment_id }
    response = post "#{@api_base_url}/questions/#{attachment_question_id}/link_attachment", body, @headers
    expect_status(400)
    expect_json("code", "ERR_ATTACHMENT_ALREADY_LINKED")
  end

  it  'delete attachments' do
  	response = delete "#{@api_base_url}/attachments/#{attachment_id}",{}, @headers
    expect_status(200)
    expect_json("status", 200)
    expect_json("code", "OK_RESOURCE_DELETED")

    response = get "#{@api_base_url}/blogs/#{attachment_blog_id}/attachments", @headers
    data = JSON.parse(response)["data"]
    expect(data.size).to be 0
  end
end
