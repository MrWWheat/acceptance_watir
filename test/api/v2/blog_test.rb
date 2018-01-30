require 'airborne'
require_relative '../api_test_config'
require_relative '../helper/api_v2_test_data_builder'
require 'pdf-reader'

attachment_id = ""
attachment_url = ""
attachment_filename = "test.png"
attachment_blog_id = ""

describe 'Blog' do
  puts 'blog api test v2'
  include APIV2TestDataBuilder
  before(:all) {
    @config = APITestConfig.new
    @api_base_url = '/api/v2'
    @topic_id_get = @config.api_data['topic_id_get']
    @headers = { :Authorization => "Bearer #{@config.access_token}",
                :Accept => "application/json",
                :content_type => "application/json",
                :verify_ssl => false }
    blog = create_conversation_in_topic("blog", @topic_id_get, @api_base_url, @headers)
    @blog_id_get = blog[:id]
    @blog_title = blog[:title]
    @blog_content = blog[:content]
  }

  it 'Get blogs' do
    get "#{@api_base_url}/blogs", @headers
    expect_status(200)
    expect_json("metadata.pagination.page", 1)
    expect_json_keys('metadata.pagination', [:type, :page, :total_pages, :per_page])
    expect_json_keys("data.0", [:id, :title, :html_content, :creator])
  end

  it 'Get blog by Id' do
    response = get "#{@api_base_url}/blogs/#{@blog_id_get}", @headers
    expect_status(200)
    expect_json("data.id", @blog_id_get)
    expect_json("data.title", @blog_title)
    expect_json("data.html_content", @blog_content)
    expect_json_keys('data', [:id, :title, :html_content, :creator])
  end

  it 'Patch blog by id' do
    response = get "#{@api_base_url}/blogs/#{@blog_id_get}", @headers
    origin_title = JSON.parse(response)['data']['title']
    edit_content = "#{@blog_content} - edited"
    body = {"html_content": edit_content }
    patch "#{@api_base_url}/blogs/#{@blog_id_get}", body, @headers
    expect_status(200)
    expect_json("data.id", @blog_id_get)
    expect_json("data.html_content", edit_content)
  end

  it 'Feature blog by id' do
    post "#{@api_base_url}/blogs/#{@blog_id_get}/feature",{}, @headers
    expect_status(200)
    expect_json("data.is_featured", true)
  end

  it 'Uneature blog by id' do
    post "#{@api_base_url}/blogs/#{@blog_id_get}/unfeature",{}, @headers
    expect_status(200)
    expect_json("data.is_featured", false)
  end

  it 'Unfollow blog by id' do
    post "#{@api_base_url}/blogs/#{@blog_id_get}/unfollow",{}, @headers
    expect_status(200)
    expect_json("data.follow_count", 0)
  end

  it 'Follow blog by id' do
    post "#{@api_base_url}/blogs/#{@blog_id_get}/follow",{}, @headers
    expect_status(200)
    expect_json("data.follow_count", 1)
  end

  it 'Like blog by id' do
    post "#{@api_base_url}/blogs/#{@blog_id_get}/like",{}, @headers
    expect_status(200)
    expect_json("data.like_count", 1)
  end

  it 'Unlike blog by id' do
    post "#{@api_base_url}/blogs/#{@blog_id_get}/unlike",{}, @headers
    expect_status(200)
    expect_json("data.like_count", 0)
  end

  it 'Close blog by id' do
    body = {}
    post "#{@api_base_url}/blogs/#{@blog_id_get}/close",body, @headers
    expect_status(200)
    expect_json("data.is_closed", true)	
  end

  it 'Reopen blog by id' do
    body = {}
    post "#{@api_base_url}/blogs/#{@blog_id_get}/reopen",body, @headers
    expect_status(200)
    expect_json("data.is_closed", false)	
  end

  it 'Post replies (Create with 1 featured reply and 1 not featured reply)' do
    content = "reply blog via api v2 test - #{Time.now.utc.to_i}"
    body = {"html_content": content }
    post "#{@api_base_url}/blogs/#{@blog_id_get}/replies", body, @headers
    expect_status(201)
    expect_json("data.contents", content)

    content2 = "reply blog via api v2 test featured - #{Time.now.utc.to_i}"
    body2 = {"html_content": content2 }
    response = post "#{@api_base_url}/blogs/#{@blog_id_get}/replies", body2, @headers
    expect_status(201)
    expect_json("data.contents", content2)

    post_id = JSON.parse(response)["data"]["id"]
    post "#{@api_base_url}/replies/#{post_id}/feature", {}, @headers
    expect_status(200)
    expect_json("data.is_featured", true)
  end

  it 'Get featured replies' do
    response = get "#{@api_base_url}/blogs/#{@blog_id_get}/featured_replies", @headers
    expect_status(200)
    expect_json("data.0.is_featured", true);
  end

  it 'Get not featured replies' do
    response = get "#{@api_base_url}/blogs/#{@blog_id_get}/not_featured_replies", @headers
    expect_status(200)
    expect_json("data.0.is_featured", false);
  end

  it 'Get posts' do
    response = get "#{@api_base_url}/blogs/#{@blog_id_get}/replies", @headers
    expect_status(200)
    expect_json_keys('data.0', [:id, :is_visible, :html_content, :creator])
  end

  it 'Get blog pdf' do
    response = get "#{@api_base_url}/blogs/#{@blog_id_get}/pdf", @headers
    expect_status(200)
    reader = PDF::Reader.new(StringIO.new(response.body))
    expect(reader.pages.size).to be 1
    expect(reader.pages[0].text).to include @blog_title
  end

  it 'Flag blog by id' do
    post "#{@api_base_url}/blogs/#{@blog_id_get}/flag",{}, @headers
    expect_status(200)
    expect_json("data.moderation_status", "moderation_status_temporarily_removed")
  end

  it 'Reinstate blog by id' do
    post "#{@api_base_url}/blogs/#{@blog_id_get}/reinstate",{}, @headers
    expect_status(200)
    expect_json("data.moderation_status", "moderation_status_reinstated")

    reponse = post "#{@api_base_url}/blogs/#{@blog_id_get}/flag",{}, @headers
    expect_status(400)
    #expect_json("exception.message", "The post cannot be flagged as it has been flagged by the same user or cleared by the moderator")
  end

  it 'Delete blog by id' do
    delete "#{@api_base_url}/blogs/#{@blog_id_get}",{}, @headers
    expect_status(200)
    expect_json("message", "resource deleted")
  end

  it 'post an attachment in blog' do
    blog = create_conversation_in_topic("blog", @topic_id_get, @api_base_url, @headers)
    attachment_blog_id = blog[:id]
    body = {:multipart => true, :filename => attachment_filename, :file => File.new(@config.data_dir + '/test.png', "rb")}
    response = post "#{@api_base_url}/blogs/#{attachment_blog_id}/attachments", body, @headers
    expect_status(201)
    expect_json("code", "OK_RESOURCE_CREATED")
    expect_json_keys('data', [:id, :filename, :url, :filesize])
    data = JSON.parse(response)["data"]
    attachment_id = data["id"]
    attachment_url = data["url"]
    #a issue found
    attachment_filename = data["filename"]
  end

  it 'get an attachment in blog' do
    response = get "#{@api_base_url}/blogs/#{attachment_blog_id}/attachments", @headers
    expect_status(200)
    expect_json("code", "OK_RESOURCE_FETCHED")
    expect_json_keys('data.*', [:id, :filename, :url, :filesize])
    expect_json("data.*.id", attachment_id)
    expect_json("data.*.url", attachment_url)
    expect_json("data.*.filename", attachment_filename)
  end

  it 'delete an attachment in blog' do
    response = delete "#{@api_base_url}/blogs/#{attachment_blog_id}/attachments", {}, @headers
    expect_status(200)
    expect_json("code", "OK_RESOURCE_DELETED")
    response = get "#{@api_base_url}/blogs/#{attachment_blog_id}/attachments", @headers
    data = JSON.parse(response)["data"]
    expect(data.size).to be 0
  end

end
