require 'airborne'
require_relative '../api_test_config'
require_relative '../helper/api_test_data_builder'

describe 'Attachment' do
  puts 'Attachment APIs'
  include APITestDataBuilder

  before(:all) do
    @config = APITestConfig.new
    @api_url = '/api/v1/OData'

    @topic_uuid = @config.api_data['topic_id_get']

    @admin_headers = {:Authorization => "Bearer #{@config.access_token}", 
                :Accept => "application/json", 
                :content_type => "application/json", 
                :verify_ssl => false}

    @user_1_headers = {:Authorization => "Bearer #{@config.get_access_token_by_user(:regular_user1)}",
                       :Accept => "application/json", 
                       :content_type => "application/json", 
                       :verify_ssl => false}

    # create a question
    question_obj = create_question_in_topic(@topic_uuid, @api_url, @admin_headers)
    @conv_uuid = question_obj.conversation_id  

    @file_to_upload = @config.data_dir + '/test.png'            
  end

  after(:all) do
    # delete the question
    delete "#{@api_url}/Conversations('#{@conv_uuid}')", nil, @admin_headers
    expect_status(204)
  end 
  
  # Test these APIs:
  # => [GET] /Conversations('{id}')/Attachments
  # => [POST] /Conversations('{id}')/AttachmentUpload()
  # => [POST] /Conversations('{id}')/AttachmentDelete()
  # => [POST] /Conversations('{id}')/AttachmentDeleteAll()
  it 'can upload/delete attachments to a question' do
    # upload three attachments to the question
    attachment_ids = []
    (0..2).each do |i|
      file = File.new(@file_to_upload, "rb")
      filename = "con-attachment#{i}" 
      body = {:multipart => true, :File => file, :Filename => filename} 
      post "#{@api_url}/Conversations('#{@conv_uuid}')/AttachmentUpload()", body, @admin_headers
      expect_status(201)
      expect_json("d.results", Filename: filename)
      expect_json_keys("d.results", [:Id, :Filename, :Url, :Filesize, :MimeType])
      attachment_ids << JSON.parse(response)["d"]["results"]["Id"]
    end 

    # anonymous user can get the attachments
    get "#{@api_url}/Conversations('#{@conv_uuid}')/Attachments.json", nil
    expect_status(200)
    expect_json_sizes("d.results", 3)
    expect_json_keys("d.results.*", [:Id, :Filename, :Url, :Filesize, :MimeType])
    expect_json("d.results.0", Id: attachment_ids[0], Filename: "con-attachment0")
    expect_json("d.results.1", Id: attachment_ids[1], Filename: "con-attachment1")
    expect_json("d.results.2", Id: attachment_ids[2], Filename: "con-attachment2")

    # delete the first attachment
    body = {d:{:Id => attachment_ids[0]}}
    post "#{@api_url}/Conversations('#{@conv_uuid}')/AttachmentDelete()", body, @admin_headers
    expect_status(204)

    # get the remaining two attachments
    get "#{@api_url}/Conversations('#{@conv_uuid}')/Attachments.json", nil
    expect_status(200)
    expect_json_sizes("d.results", 2)
    expect_json("d.results.0", Id: attachment_ids[1], Filename: "con-attachment1")
    expect_json("d.results.1", Id: attachment_ids[2], Filename: "con-attachment2")

    # delete all the two attachments
    post "#{@api_url}/Conversations('#{@conv_uuid}')/AttachmentDeleteAll()", nil, @admin_headers
    expect_status(204)

    # get nothing
    get "#{@api_url}/Conversations('#{@conv_uuid}')/Attachments", @admin_headers
    expect_status(204)
  end

  # Test these APIs:
  # => [POST] /Networks('{id}')/AttachmentUpload()
  # => [POST] /Networks('{id}')/AttachmentDelete()
  # => [POST] /Networks('{id}')/AttachmentDeleteMulti()
  it 'can upload/delete attachments to network' do
    # upload three attachments to the network
    attachment_ids = []
    (0..2).each do |i|
      file = File.new(@file_to_upload, "rb")
      filename = "net-attachment#{i}"

      body = {:multipart => true, :File => file, :Filename => filename} 
      post "#{@api_url}/Networks('#{@config.slug}')/AttachmentUpload()", body, @admin_headers
      expect_status(201)
      expect_json("d.results", Filename: filename)
      expect_json_keys("d.results", [:Id, :Filename, :Url, :Filesize, :MimeType])
      attachment_ids << JSON.parse(response)["d"]["results"]["Id"]
    end

    # delete a single network attachment
    body = {d:{:Id => attachment_ids[0]}}
    post "#{@api_url}/Networks('#{@config.slug}')/AttachmentDelete()", body, @admin_headers
    expect_status(204)

    # delete multiple network attachments
    body = {d:{:Ids => attachment_ids[1] + "," + attachment_ids[2]}}
    post "#{@api_url}/Networks('#{@config.slug}')/AttachmentDeleteMulti()", body, @admin_headers
    expect_status(204)
  end

  # Test these APIs:
  # => [POST] /Conversations('{id}')/AttachmentLink()
  # => [POST] /Conversations('{id}')/AttachmentMultiLink()
  it 'can link network attachment to a question' do
    # upload three attachments to the network
    attachment_ids = []
    (3..5).each do |i|
      file = File.new(@file_to_upload, "rb")
      filename = "net-attachment#{i}"

      body = {:multipart => true, :File => file, :Filename => filename} 
      post "#{@api_url}/Networks('#{@config.slug}')/AttachmentUpload()", body, @admin_headers
      expect_status(201)
      expect_json("d.results", Filename: filename)
      expect_json_keys("d.results", [:Id, :Filename, :Url, :Filesize, :MimeType])
      attachment_ids << JSON.parse(response)["d"]["results"]["Id"]
    end

    # link the first attachment to the question
    body = {d:{:Id => attachment_ids[0]}}
    post "#{@api_url}/Conversations('#{@conv_uuid}')/AttachmentLink()", body, @admin_headers
    expect_status(204)

    get "#{@api_url}/Conversations('#{@conv_uuid}')/Attachments.json", nil
    expect_status(200)
    expect_json_sizes("d.results", 1)

    # link the other two attachments to the question
    body = {d:{:Ids => attachment_ids[1] + "," + attachment_ids[2]}}
    post "#{@api_url}/Conversations('#{@conv_uuid}')/AttachmentMultiLink()", body, @admin_headers
    expect_status(204)

    get "#{@api_url}/Conversations('#{@conv_uuid}')/Attachments.json", @admin_headers
    expect_status(200)
    expect_json_sizes("d.results", 3)
  end

  # TESTCASE:
  # 1. network attachment cannot be deleted from network after it is linked.
  # 2. linked attachment can only be deleted from its converstation
  it 'cannot delete an attachment after it is linked' do
    file = File.new(@file_to_upload, "rb")
    filename = "net-attachment6"

    body = {:multipart => true, :File => file, :Filename => filename} 
    post "#{@api_url}/Networks('#{@config.slug}')/AttachmentUpload()", body, @admin_headers
    expect_status(201)
    attachment_id = JSON.parse(response)["d"]["results"]["Id"]

    # link it to the question
    body = {d:{:Id => attachment_id}}
    post "#{@api_url}/Conversations('#{@conv_uuid}')/AttachmentLink()", body, @admin_headers
    expect_status(204)

    # cannot delete via network api
    body = {d:{:Id => attachment_id}}
    post "#{@api_url}/Networks('#{@config.slug}')/AttachmentDelete()", body, @admin_headers
    expect_status(400)

    # can delete from conversation api
    body = {d:{:Id => attachment_id}}
    post "#{@api_url}/Conversations('#{@conv_uuid}')/AttachmentDelete()", body, @admin_headers
    expect_status(204)
  end 

  # TESTCASE:
  # Can upload attachments with duplicate names
  it 'can upload attachments with duplicate names' do
    file = File.new(@file_to_upload, "rb")
    filename = "con-attachment7"
    body = {:multipart => true, :File => file, :Filename => filename} 
    post "#{@api_url}/Conversations('#{@conv_uuid}')/AttachmentUpload()", body, @admin_headers
    expect_status(201)

    file = File.new(@file_to_upload, "rb")
    filename = "con-attachment7"
    body = {:multipart => true, :File => file, :Filename => filename} 
    post "#{@api_url}/Conversations('#{@conv_uuid}')/AttachmentUpload()", body, @admin_headers
    expect_status(201)
  end

  # TESTCASE:
  # Localization
  it 'can upload attachment with chinese name' do
    file = File.new(@config.data_dir + '/中文文件.png', "rb")
    filename = "con-attachment10"
    body = {:multipart => true, :File => file, :Filename => filename} 
    post "#{@api_url}/Conversations('#{@conv_uuid}')/AttachmentUpload()", body, @admin_headers
    expect_status(201)
    expect_json("d.results", Filename: filename)

    file = File.new(@config.data_dir + '/中文文件.png', "rb")
    filename = "中文文件"
    body = {:multipart => true, :File => file, :Filename => filename} 
    post "#{@api_url}/Conversations('#{@conv_uuid}')/AttachmentUpload()", body, @admin_headers
    expect_status(201)
    expect_json("d.results", Filename: filename)
  end

  # TESTCASE:
  # Cannot upload attachment with file size > 4MB
  it 'cannot upload attachment with file size > 4MB' do
    file = File.new(@config.data_dir + '/test_4mb.txt', "rb")
    filename = "con-attachment11"
    body = {:multipart => true, :File => file, :Filename => filename} 
    post "#{@api_url}/Conversations('#{@conv_uuid}')/AttachmentUpload()", body, @admin_headers
    #skip "blocked by bug EN-2852"
    expect_status(400)
  end 

  # TESTCASE:
  # 1. Only admin user can upload attachment.
  # 2. Only the owner of converstaion can upload attachment to it.
  context 'after create a question by user 1' do
    before(:context) do
      # create a question by user 1
      question_obj = create_question_in_topic(@topic_uuid, @api_url, @user_1_headers)
      @conv1_uuid = question_obj.conversation_id 
    end
    
    after(:context) do
      # delete the question
      delete "#{@api_url}/Conversations('#{@conv1_uuid}')", nil, @admin_headers
      expect_status(204)
    end

    it 'can upload attachment to a question created by others' do
      # cannot upload attachment by non-admin user
      file = File.new(@file_to_upload, "rb")
      filename = "con-attachment8"
      body = {:multipart => true, :File => file, :Filename => filename} 
      post "#{@api_url}/Conversations('#{@conv1_uuid}')/AttachmentUpload()", body, @user_1_headers
      expect_status(403)

      file = File.new(@file_to_upload, "rb")
      filename = "con-attachment9"

      # admin can upload attachment to a question created by others
      body = {:multipart => true, :File => file, :Filename => filename} 
      post "#{@api_url}/Conversations('#{@conv1_uuid}')/AttachmentUpload()", body, @admin_headers
      expect_status(201)
    end

    it 'cannot upload network attachment by non-admin user' do
      file = File.new(@file_to_upload, "rb")
      filename = "net-attachment10"
      body = {:multipart => true, :File => file, :Filename => filename} 
      post "#{@api_url}/Networks('#{@config.slug}')/AttachmentUpload()", body, @user_1_headers
      expect_status(403)
    end

    context 'after upload a network attachment' do
      before(:context) do
        # admin upload a network attachment
        @attachment_id = upload_network_attachment(@api_url, @config.slug, @admin_headers, @file_to_upload)
      end

      it 'cannot link attachment by non-admin user' do
        # link it to the question
        body = {d:{:Id => @attachment_id}}
        post "#{@api_url}/Conversations('#{@conv_uuid}')/AttachmentLink()", body, @user_1_headers
        expect_status(403)
      end  
      
      after(:context) do
        delete_network_attachment(@api_url, @config.slug, @admin_headers, @attachment_id)
      end  
    end  
  end

  # TESTCASE:
  # Moderator user have read, update???, create, delete permission on attachment
  context 'after create a question by moderator user' do
    before(:context) do
      @moderator_user_headers = {:Authorization => "Bearer #{@config.get_access_token_by_user(:network_moderator)}",
                       :Accept => "application/json", 
                       :content_type => "application/json", 
                       :verify_ssl => false}

      # create a question by moderator user
      question_obj = create_question_in_topic(@topic_uuid, @api_url, @moderator_user_headers)
      @conv2_uuid = question_obj.conversation_id 
    end
    
    after(:context) do
      # delete the question
      delete "#{@api_url}/Conversations('#{@conv2_uuid}')", nil, @moderator_user_headers
      expect_status(204)
    end

    it 'can upload attachment to a question by moderator user' do
      upload_conversation_attachment(@api_url, @moderator_user_headers, @conv2_uuid, @file_to_upload)

      get "#{@api_url}/Conversations('#{@conv2_uuid}')/Attachments.json", @moderator_user_headers
      expect_status(200)
    end

    it 'can upload attachment to network and link to a question by moderator user' do
      # admin upload a network attachment
      attachment_id = upload_network_attachment(@api_url, @config.slug, @moderator_user_headers, @file_to_upload)

      # link the first attachment to the question
      body = {d:{:Id => attachment_id}}
      post "#{@api_url}/Conversations('#{@conv2_uuid}')/AttachmentLink()", body, @moderator_user_headers
      expect_status(204)

      # can delete from conversation api
      body = {d:{:Id => attachment_id}}
      post "#{@api_url}/Conversations('#{@conv2_uuid}')/AttachmentDelete()", body, @moderator_user_headers
      expect_status(204)
    end

    # TODO: requirement is not clear for this case
    # it 'can link network attachment uploaded by admin to a question by moderator' do
    #   # admin upload a network attachment
    #   attachment_id = upload_network_attachment(@api_url, @config.slug, @admin_headers, @file_to_upload)

    #   # link the first attachment to the question
    #   body = {d:{:Id => attachment_id}}
    #   post "#{@api_url}/Conversations('#{@conv2_uuid}')/AttachmentLink()", body, @moderator_user_headers
    #   expect_status(201)

    #   # can delete from conversation api
    #   body = {d:{:Id => attachment_id}}
    #   post "#{@api_url}/Conversations('#{@conv2_uuid}')/AttachmentDelete()", body, @moderator_user_headers
    #   expect_status(204)
    # end 
  end  
end