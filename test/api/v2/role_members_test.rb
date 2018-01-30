require 'airborne'
require_relative '../api_test_config'

describe 'Role Members' do
  puts 'Role Members APIs v2'

  before(:all) {
    @config = APITestConfig.new
    @api_base_url = '/api/v2'
    @normaluser_id_get = @config.api_data['normaluser_id_get']
    @topic_id_get = @config.api_data['topic_id_get']
    @headers = { :Authorization => "Bearer #{@config.access_token}",
                 :Accept => "application/json",
                 :content_type => "application/json",
                 :verify_ssl => false }
  }

  it 'Get admins' do
    get "#{@api_base_url}/role_members/network/admin", @headers

    expect_status(200)
    expect_json_keys('data.*', [:permission_group_type, :identity_id, :topic_id, :actor, :_ref_link])
  end

  it 'Post to promote a admin' do
    post "#{@api_base_url}/role_members/network/admin/#{@normaluser_id_get}", nil, @headers

    expect_status(201)
    expect_json_keys('data', [:permission_group_type, :identity_id, :topic_id, :actor, :_ref_link])
  end

  it 'Get admin by ID' do
    get "#{@api_base_url}/role_members/network/admin/#{@normaluser_id_get}", @headers

    expect_status(200)
    expect_json_keys('data', [:permission_group_type, :identity_id, :topic_id, :actor, :_ref_link])
  end

  it 'Revoke admin permission' do
    delete "#{@api_base_url}/role_members/network/admin/#{@normaluser_id_get}", nil, @headers

    expect_status(200)
  end

  it 'Get moderators' do
    get "#{@api_base_url}/role_members/network/moderator", @headers

    expect_status(200)
    expect_json_keys('data.*', [:permission_group_type, :identity_id, :topic_id, :actor, :_ref_link])
  end

  it 'Post to promote a moderator' do
    post "#{@api_base_url}/role_members/network/moderator/#{@normaluser_id_get}", nil, @headers

    expect_status(201)
    expect_json_keys('data', [:permission_group_type, :identity_id, :topic_id, :actor, :_ref_link])
  end

  it 'Get moderator by ID' do
    get "#{@api_base_url}/role_members/network/moderator/#{@normaluser_id_get}", @headers

    expect_status(200)
    expect_json_keys('data', [:permission_group_type, :identity_id, :topic_id, :actor, :_ref_link])
  end

  it 'Revoke moderator permission' do
    delete "#{@api_base_url}/role_members/network/moderator/#{@normaluser_id_get}", nil, @headers

    expect_status(200)
  end

  it 'Get bloggers' do
    get "#{@api_base_url}/role_members/network/blogger", @headers

    expect_status(200)
    expect_json_keys('data.*', [:permission_group_type, :identity_id, :topic_id, :actor, :_ref_link])
  end

  it 'Post to promote a blogger' do
    post "#{@api_base_url}/role_members/network/blogger/#{@normaluser_id_get}", nil, @headers

    expect_status(201)
    expect_json_keys('data', [:permission_group_type, :identity_id, :topic_id, :actor, :_ref_link])
  end

  it 'Get blogger by ID' do
    get "#{@api_base_url}/role_members/network/blogger/#{@normaluser_id_get}", @headers

    expect_status(200)
    expect_json_keys('data', [:permission_group_type, :identity_id, :topic_id, :actor, :_ref_link])
  end

  it 'Revoke blogger permission' do
    delete "#{@api_base_url}/role_members/network/blogger/#{@normaluser_id_get}", nil, @headers

    expect_status(200)
  end

  it 'Promote a topic admin and some actions' do
    post "#{@api_base_url}/role_members/topics/#{@topic_id_get}/admin/#{@normaluser_id_get}", nil, @headers

    expect_status(201)
    expect_json_keys('data', [:permission_group_type, :identity_id, :topic_id, :actor, :_ref_link])

    get "#{@api_base_url}/role_members/topics/#{@topic_id_get}/admin/#{@normaluser_id_get}", @headers

    expect_status(200)
    expect_json_keys('data', [:permission_group_type, :identity_id, :topic_id, :actor, :_ref_link])

    get "#{@api_base_url}/role_members/topics/#{@topic_id_get}/admin", @headers

    expect_status(200)
    expect_json_keys('data.*', [:permission_group_type, :identity_id, :topic_id, :actor, :_ref_link])

    delete "#{@api_base_url}/role_members/topics/#{@topic_id_get}/admin/#{@normaluser_id_get}", nil, @headers

    expect_status(200)
  end

  it 'Promote a topic moderator and some actions' do
    post "#{@api_base_url}/role_members/topics/#{@topic_id_get}/moderator/#{@normaluser_id_get}", nil, @headers

    expect_status(201)
    expect_json_keys('data', [:permission_group_type, :identity_id, :topic_id, :actor, :_ref_link])

    get "#{@api_base_url}/role_members/topics/#{@topic_id_get}/moderator/#{@normaluser_id_get}", @headers

    expect_status(200)
    expect_json_keys('data', [:permission_group_type, :identity_id, :topic_id, :actor, :_ref_link])

    get "#{@api_base_url}/role_members/topics/#{@topic_id_get}/moderator", @headers

    expect_status(200)
    expect_json_keys('data.*', [:permission_group_type, :identity_id, :topic_id, :actor, :_ref_link])

    delete "#{@api_base_url}/role_members/topics/#{@topic_id_get}/moderator/#{@normaluser_id_get}", nil, @headers

    expect_status(200)
  end

  it 'Promote a topic blogger and some actions' do
    post "#{@api_base_url}/role_members/topics/#{@topic_id_get}/blogger/#{@normaluser_id_get}", nil, @headers

    expect_status(201)
    expect_json_keys('data', [:permission_group_type, :identity_id, :topic_id, :actor, :_ref_link])

    get "#{@api_base_url}/role_members/topics/#{@topic_id_get}/blogger/#{@normaluser_id_get}", @headers

    expect_status(200)
    expect_json_keys('data', [:permission_group_type, :identity_id, :topic_id, :actor, :_ref_link])

    get "#{@api_base_url}/role_members/topics/#{@topic_id_get}/blogger", @headers

    expect_status(200)
    expect_json_keys('data.*', [:permission_group_type, :identity_id, :topic_id, :actor, :_ref_link])

    delete "#{@api_base_url}/role_members/topics/#{@topic_id_get}/blogger/#{@normaluser_id_get}", nil, @headers

    expect_status(200)
  end

end
