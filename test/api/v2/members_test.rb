require 'airborne'
require_relative '../api_test_config'

describe 'Members' do
  puts 'Members APIs v2'

  before(:all) {
    @config = APITestConfig.new
    @api_base_url = '/api/v2'
    @member_id_get = @config.api_data['member_id_get']
    @headers = { :Authorization => "Bearer #{@config.access_token}",
                 :Accept => "application/json",
                 :content_type => "application/json",
                 :verify_ssl => false }
  }

  it 'Get member by member ID' do
    get "#{@api_base_url}/members/#{@member_id_get}", @headers

    expect_status(200)
    expect_json_keys('data', [:id, :firstname, :lastname, :fullname, :username])
  end

  it 'Get member by member ID' do
    get "#{@api_base_url}/members/#{@member_id_get}/get_profile_fields", @headers

    expect_status(200)
    expect_json_keys('data.*', [:field_section, :field_name, :value])
  end

  it 'Post to subscribe email notifications' do
    post "#{@api_base_url}/members/#{@member_id_get}/subscribe_to_email_notifications", nil, @headers

    expect_status(200)
    expect_json_keys('data', [:id, :firstname, :lastname, :fullname, :username])
  end

  it 'Post to unsubscribe email notifications' do
    post "#{@api_base_url}/members/#{@member_id_get}/unsubscribe_from_email_notifications", nil, @headers

    expect_status(200)
    expect_json_keys('data', [:id, :firstname, :lastname, :fullname, :username])
  end

  it 'Post to mark all notifications read' do
    post "#{@api_base_url}/members/#{@member_id_get}/mark_all_notifications_read", nil, @headers

    expect_status(200)
    expect_json_keys('data', [:id, :firstname, :lastname, :fullname, :username])
  end

  it 'Post to upload profie photo' do
    body = {
        :multipart => true,
        :file => File.new(@config.data_dir + '/test.png', 'r'),
        :id => 22,
        :options => "profile_photo",
        'photo.crop.x': 18.14736842105256,
        'photo.crop.y': 0.18421052631572066,
        'photo.crop.width': 107.8526315789474,
        'photo.crop.height': 70.8526315789474
    }

    post "#{@api_base_url}/members/#{@member_id_get}/upload_profile_photo", body, @headers
    expect_status(200)
    expect_json_keys('data', [:id, :firstname, :lastname, :fullname, :username])
  end

  it 'Post to remove profile photo' do
    post "#{@api_base_url}/members/#{@member_id_get}/delete_profile_photo", nil, @headers

    expect_status(200)
    expect_json_keys('data', [:id, :firstname, :lastname, :fullname, :username])
  end

  # it 'Post to register a user and remove it'

  it 'Get member posts' do
    get "#{@api_base_url}/members/#{@member_id_get}/replies", @headers

    expect_status(200)
    expect_json_keys('data.*', [:id, :parent_id, :html_content, :is_visible, :is_featured])
  end

end
