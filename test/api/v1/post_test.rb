require 'airborne'
require_relative '../api_test_config'
require_relative '../helper/api_test_data_builder'

describe 'Post' do
  puts 'Post APIs'
  include APITestDataBuilder

  before(:all) {
    @config = APITestConfig.new
    @api_url = '/api/v1/OData'
    @network_id = @config.api_data['network_id_get']
    @topic_uuid = @config.api_data['topic_id_get']

    @headers = {:Authorization => "Bearer #{@config.access_token}", 
                :Accept => "application/json", 
                :content_type => "application/json", 
                :verify_ssl => false}

    @user_1_headers = {:Authorization => "Bearer #{@config.get_access_token_by_user(:regular_user1)}",
                       :Accept => "application/json", 
                       :content_type => "application/json", 
                       :verify_ssl => false}
    @user_2_headers = {:Authorization => "Bearer #{@config.get_access_token_by_user(:regular_user2)}",
                       :Accept => "application/json", 
                       :content_type => "application/json", 
                       :verify_ssl => false}                             
  }

  context 'after create a new question and an answer' do
    before(:context) do
      # create a new question
      question_obj = create_question_in_topic(@topic_uuid, @api_url, @headers)

      @q_title = question_obj.title
      @conv_uuid = question_obj.conversation_id
      @root_post_id = question_obj.root_post_id
      
      # create a reply under the root post 
      @depth_1_reply_content = 'reply 1'
      @depth_1_reply_post_id = create_post_in_conversation(@depth_1_reply_content, @root_post_id, @api_url, @headers)

      # create a reply to the 1st reply 
      @depth_2_reply_content = 'reply 1.1'
      @depth_2_reply_post_id = create_post_in_conversation(@depth_2_reply_content, @depth_1_reply_post_id, @api_url, @headers)
    end

    after(:context) do
      # delete the question
      delete "#{@api_url}/Conversations('#{@conv_uuid}')", nil, @headers
      expect_status(204)
    end  

    # Test these APIs:
    # => [GET] /Posts('{id}')
    it 'should get the answer post ' do
      get "#{@api_url}/Posts('#{@depth_1_reply_post_id}').json"
      expect_status(200)
      expect_json('d.results', 
        Id: @depth_1_reply_post_id, 
        OriginalContent: @depth_1_reply_content)
    end 

    # Test these APIs:
    # => [PATCH] /Posts('{id}')
    it 'should update the answer post' do
      new_reply_content = @depth_1_reply_content + '-edit'
      body = {"d":{"HtmlContent": new_reply_content,"OriginalContent": new_reply_content,"Traits":"answer"}}
      patch "#{@api_url}/Posts('#{@depth_1_reply_post_id}')", body, @headers
      expect_status(204)
    end

    # Test these APIs:
    # => [GET] /Posts('{id}')/Children
    it 'should get children of the depth 1 answer post' do
      response = get "#{@api_url}/Posts('#{@depth_1_reply_post_id}')/Children.json"
      expect_status(200)
      expect_json_sizes("d", results: 1) 
      expect_json("d.results.0", Id: @depth_2_reply_post_id) 
    end  

    # Test these APIs:
    # => [GET] /Posts('{id}')/Conversation
    it 'should get the conersation information where the answer post is on' do
      get "#{@api_url}/Posts('#{@depth_1_reply_post_id}')/Conversation.json"
      expect_status(200)
      expect_json('d.results', 
        Id: @conv_uuid, 
        Title: @q_title)
    end

    # Test these APIs:
    # => [[GET] /Posts('{id}')/Depth1Ancestor
    it 'should get the depth 1 ancestor of the depth 2 answer post' do
      get "#{@api_url}/Posts('#{@depth_2_reply_post_id}')/Depth1Ancestor.json"
      expect_status(200)
      expect_json('d.results', Id: @depth_1_reply_post_id)
    end

    # Test these APIs:
    # => [POST] /Posts('{id}')/Like()
    # => [GET] /Posts('{id}')/Likes
    # => [POST] /Posts('{id}')/Unlike()
    it 'should like the post, get the likes and unlike the post' do
      # !!! Currently, 400 error occurs when like the root post. 
      # So, just test non-root post here.

      # like the depth 1 reply post by first user
      post "#{@api_url}/Posts('#{@depth_1_reply_post_id}')/Like()", nil, @user_1_headers
      expect_status(204)
      # like the depth 1 reply post by second user
      post "#{@api_url}/Posts('#{@depth_1_reply_post_id}')/Like()", nil, @user_2_headers
      expect_status(204)

      # get the likes
      response = get "#{@api_url}/Posts('#{@depth_1_reply_post_id}')/Likes.json"
      expect_status(200)
      expect_json_sizes("d", results: 2) 
      expect_json_types("d.results.*", 
        Id: :string, 
        Direction: :int, 
        Creator: :object) 

      # unlike by first user
      post "#{@api_url}/Posts('#{@depth_1_reply_post_id}')/Unlike()", nil, @user_1_headers
      expect_status(204)

      get "#{@api_url}/Posts('#{@depth_1_reply_post_id}')/Likes.json"
      expect_status(200)
      expect_json_sizes("d", results: 1) 

      # unlike by second user
      post "#{@api_url}/Posts('#{@depth_1_reply_post_id}')/Unlike()", nil, @user_2_headers
      expect_status(204)

      get "#{@api_url}/Posts('#{@depth_1_reply_post_id}')/Likes.json"
      expect_status(204)
    end 

    # Test these APIs:
    # => [POST] /Posts('{id}')/Feature()
    # => [POST] /Posts('{id}')/Unfeature()
    it 'should feature, unfeature the post' do
      post "#{@api_url}/Posts('#{@depth_1_reply_post_id}')/Feature()", nil, @headers
      expect_status(204)

      post "#{@api_url}/Posts('#{@depth_1_reply_post_id}')/Unfeature()", nil, @headers
      expect_status(204)
    end

    # Test these APIs:
    # => [POST] /Posts('{id}')/Follow()
    # => [POST] /Posts('{id}')/Unfollow()
    it 'should follow, unfollow the post' do
      post "#{@api_url}/Posts('#{@depth_1_reply_post_id}')/Follow()", nil, @headers
      expect_status(204)

      post "#{@api_url}/Posts('#{@depth_1_reply_post_id}')/Unfollow()", nil, @headers
      expect_status(204)
    end 

    # Test these APIs:
    # => [POST] /Posts('{id}')/Escalate()
    # => [POST] /Posts('{id}')/Deescalate()
    it 'should escalate, deescalate the post' do
      # !!! Escalate/Deescalate can only work for root post. 500 error occur for replies
      post "#{@api_url}/Posts('#{@root_post_id}')/Escalate()", nil, @headers
      expect_status(204)

      post "#{@api_url}/Posts('#{@root_post_id}')/Deescalate()", nil, @headers
      expect_status(204)
    end  

    # Test these APIs:
    # => [GET] /Posts('{id}')/Parent
    it 'should get the parent of the post' do
      get "#{@api_url}/Posts('#{@depth_1_reply_post_id}')/Parent.json"
      expect_status(200)
      expect_json('d.results', 
        Id: @root_post_id, 
        OriginalContent: @q_title)
    end  

    # TODO: 
    # Test these APIs:
    # => [GET] /Posts('{id}')/Publisher
    # it 'should get publisher' do
    #   byebug
    #   get "#{@api_url}/Posts('#{@depth_1_reply_post_id}')/Publisher.json"
    #   expect_status(200)
    #   #Invalid::Undefined method
    # end 
  end 

  context 'after create a new question' do
    before(:context) do
      # create a new question
      question_obj = create_question_in_topic(@topic_uuid, @api_url, @headers)

      @q_title = question_obj.title
      @conv_uuid = question_obj.conversation_id
      @root_post_id = question_obj.root_post_id
    end

    after(:context) do
      # delete the question
      delete "#{@api_url}/Conversations('#{@conv_uuid}')", nil, @headers
      expect_status(204)
    end

    # Test these APIs:
    # => [POST] /Posts('{id}')/Posts
    # => [GET] /Posts('{id}')/Posts
    # => [DELETE] /Posts('{id}')
    it 'should create, get, delete a new answer post' do
      # create a reply under the root post 
      @depth_1_reply_content = 'reply 1'
      body = {"d":{"HtmlContent":"<div class=input><p>#{@depth_1_reply_content}</p></div>"}}
      response = post "#{@api_url}/Posts('#{@root_post_id}')/Posts", body, @headers
      expect_status(201)
      expect_json('d.results', OriginalContent: @depth_1_reply_content)

      @depth_1_reply_post_id = JSON.parse(response)["d"]["results"]["Id"]

      # get the replies under the root post
      response = get "#{@api_url}/Posts('#{@root_post_id}')/Posts.json"
      expect_status(200)
      expect_json_keys('d.results.*', [:Id, :OriginalContent, :Depth])

      delete "#{@api_url}/Posts('#{@depth_1_reply_post_id}')", nil, @headers
      expect_status(204)
    end

    context 'then create a new answer post with two products mentioned' do
      before(:context) do
        # get all the products and select the first two to mention later
        response = get "#{@api_url}/Networks('#{@network_id}')/Products.json"
        expect_status(200)

        product_1_name = JSON.parse(response)["d"]["results"][0]["Name"]
        product_1_id = JSON.parse(response)["d"]["results"][0]["Id"]
        product_2_name = JSON.parse(response)["d"]["results"][1]["Name"]
        product_2_id = JSON.parse(response)["d"]["results"][1]["Id"]
        
        # create an answer post with two products mentioned under the root post
        body = {"d":{"HtmlContent":"<div class=input><p>reply 1 <span data-uuid=\"#{product_1_id}\" class=\"product-mention\">#{product_1_name}</span> \
                                                                <span data-uuid=\"#{product_2_id}\" class=\"product-mention\">#{product_2_name}</span> </p></div>","Traits":""}}
        response = post "#{@api_url}/Posts('#{@root_post_id}')/Posts", body, @headers
        expect_status(201)

        @depth_1_reply_post_id = JSON.parse(response)["d"]["results"]["Id"]

        # build up the relation between post and mentioned products
        body = {"d":{"PostId":"#{@depth_1_reply_post_id}","ProductUuid":"#{product_1_id}"}}
        response = post "#{@api_url}/Posts('#{@depth_1_reply_post_id}')/ProductMentions", body, @headers
        expect_status(201)
        expect_json_types('d.results', Id: :string, ProductId: :int)

        @mentioned_prod_1_id = JSON.parse(response)["d"]["results"]["Id"]

        body = {"d":{"PostId":"#{@depth_1_reply_post_id}","ProductUuid":"#{product_2_id}"}}
        response = post "#{@api_url}/Posts('#{@depth_1_reply_post_id}')/ProductMentions", body, @headers
        expect_status(201)

        @mentioned_prod_2_id = JSON.parse(response)["d"]["results"]["Id"]
      end

      # Test these APIs:
      # => [GET] /Posts('{id}')/ProductMentions
      it 'should get the product mentions on the post' do
        get "#{@api_url}/Posts('#{@depth_1_reply_post_id}')/ProductMentions.json"
        expect_status(200)
        expect_json_sizes('d', results: 2)
        expect_json("d.results.0", Id: @mentioned_prod_1_id)
        expect_json("d.results.1", Id: @mentioned_prod_2_id)
      end  
    end   
  end 

  context 'after create a new question for a product' do
    before(:context) do
      # get all the products and select the first two to mention later
      response = get "#{@api_url}/Networks('#{@network_id}')/Products.json"
      expect_status(200)

      product_1_id = JSON.parse(response)["d"]["results"][0]["Id"]
      post_id = JSON.parse(response)["d"]["results"][0]["Topic"]["__metadata"]["uri"].match(/Topics\('(\w+)'\)/)[1]

      # create a new question
      question_obj = create_question_in_topic(@topic_uuid, @api_url, @headers)

      @q_title = question_obj.title
      @conv_uuid = question_obj.conversation_id
      @root_post_id = question_obj.root_post_id

      # create a reply under the root post 
      @depth_1_reply_content = 'reply 1'
      @depth_1_reply_post_id = create_post_in_conversation(@depth_1_reply_content, @root_post_id, @api_url, @headers)
    end 

    after(:context) do
      # delete the question
      delete "#{@api_url}/Conversations('#{@conv_uuid}')", nil, @headers
      expect_status(204)
    end

    # TODO:
    # # Test these APIs:
    # # => [GET] /Posts('{id}')/GetProduct()
    # it 'should get the product info which the question belongs to' do
    #   response = get "#{@api_url}/Posts('#{@root_post_id}')/GetProduct()", @headers
    #   expect_status(200)
    #   #TODO: return no product data. # EN-2262
    # end  
  end 

  # Test these APIs:
  # => [POST] /Posts('{id}')/Flag() 
  # => [POST] /Posts('{id}')/Reinstate()
  # => [POST] /Posts('{id}')/Approve()
  # => [POST] /Posts('{id}')/Reject()
  # => [POST] /Posts('{id}')/Remove()
  # Depend on these APIs:
  # => [GET] /NetworkConfigurations('{id}}
  # => [PATCH] /NetworkConfigurations('{id}}
  # => [POST] /Topics('{id}')/Conversations
  # => [DELETE] /Conversations('{id}')
  context 'after set Moderation option to Moderation on immediate posts' do
    before(:context) do
      response = get "#{@api_url}/NetworkConfigurations('#{@network_id}')", @headers
      expect_status(200)

      @old_m_threshold = JSON.parse(response)["d"]["results"]["ModerationThreshold"]
      @old_m_type = JSON.parse(response)["d"]["results"]["ModerationType"]

      body = {"d":{"ModerationThreshold":10,"ModerationType":"pending_admin_moderation_post_shown"}}
      response = patch "#{@api_url}/NetworkConfigurations('#{@network_id}')", body, @headers
      expect_status(204)
    end

    after(:context) do
      # restore the old moderation settings
      body = {"d":{"ModerationThreshold": @old_m_threshold,"ModerationType": @old_m_type}}
      response = patch "#{@api_url}/NetworkConfigurations('#{@network_id}')", body, @headers
      expect_status(204)
    end 

    before(:each) do
      # normal user 1 to create a new question
      question_obj = create_question_in_topic(@topic_uuid, @api_url, @user_1_headers)

      @conv_uuid = question_obj.conversation_id
      @root_post_id = question_obj.root_post_id
    end 

    after(:each) do
      # delete the question
      delete "#{@api_url}/Conversations('#{@conv_uuid}')", nil, @headers
      expect_status(204)
    end  

    it 'should flag, reinstate the post' do
      post "#{@api_url}/Posts('#{@root_post_id}')/Flag()", nil, @headers
      expect_status(204)

      post "#{@api_url}/Posts('#{@root_post_id}')/Reinstate()", nil, @headers
      expect_status(204)
    end 

    it 'should approve the post' do
      # approve by admin user
      post "#{@api_url}/Posts('#{@root_post_id}')/Approve()", nil, @headers
      expect_status(204)
    end

    it 'should reject, permanently remove the post' do
      # reject by admin user
      # Note: This api is not explicit to use in UI action. But 
      # the result of reject should be equivalent with that the post is flagged by the last user 
      # which reach to the Threshold in Admin->Morderation->Settings
      post "#{@api_url}/Posts('#{@root_post_id}')/Reject()", nil, @headers
      expect_status(204)

      post "#{@api_url}/Posts('#{@root_post_id}')/Remove()", nil, @headers
      expect_status(204)
    end
  end 
end
