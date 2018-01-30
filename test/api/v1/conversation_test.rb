require 'airborne'
require_relative '../api_test_config'
require_relative '../helper/api_test_data_builder'

describe 'Conversation' do
  puts 'Conversation APIs'
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

  context 'after create a new review conversation' do
    before(:context) do
      # create a review before test the following api
      review_obj = create_review_in_topic(@topic_uuid, @api_url, @headers)

      @conv_title = review_obj.title
      @conv_uuid = review_obj.conversation_id
      @root_post_id = review_obj.root_post_id
    end 

    # Test these APIs:
    # => [GET] /Conversations('{id}')
    it 'can get the conversation' do
      # get the conversation
      get "#{@api_url}/Conversations('#{@conv_uuid}')", @headers
      expect_status(200)
      expect_json("d.results", Title: @conv_title)
    end 

    # Test these APIs:
    # => [PATCH] /Conversations('{id}')
    # Depend on these APIs:
    # => [GET] /Conversations('{id}')
    it 'can patch the conversation' do
      # update the conversation
      conv_new_title = "#{@conv_title}-edit"
      body = {"d":{"Title": conv_new_title}}
      patch "#{@api_url}/Conversations('#{@conv_uuid}')", body, @headers
      expect_status(204)

      # get the edited conversation
      get "#{@api_url}/Conversations('#{@conv_uuid}')", @headers
      expect_status(200)
      expect_json("d.results", Title: conv_new_title)
    end

    # Test these APIs:
    # => [GET] /Conversations('{id}')/FeaturedReplies
    # Depend on these APIs:
    # => [POST] /Posts('{id}')/Posts
    # => [POST] /Posts('{id}')/Feature()
    it 'can get the featured replies of the conversation' do
      # create a reply under the root post  
      body = {"d":{"HtmlContent":"<div class=input><p>reply 1</p></div>"}}
      response = post "#{@api_url}/Posts('#{@root_post_id}')/Posts", body, @headers
      expect_status(201)

      @reply_post_id = JSON.parse(response)["d"]["results"]["Id"]

      # feature the reply post
      post "#{@api_url}/Posts('#{@reply_post_id}')/Feature()", nil, @headers
      expect_status(204)

      # get the featured reply
      get "#{@api_url}/Conversations('#{@conv_uuid}')/FeaturedReplies", @headers
      expect_status(200)

      expect_json_sizes("d", results: 1)
      expect_json("d.results.0", 
        Id: "#{@reply_post_id}", 
        OriginalContent: "reply 1", 
        IsFeatured: true, 
        Traits: "feature")
      expect_json("d.results.0.ConversationReference", Id: "#{@conv_uuid}")
    end

    # Test these APIs:
    # => [GET] /Conversations('{id}')/Likes
    # Depend on these APIs:
    # => [POST] /Posts('{id}')/Like()
    it 'can get the likes of the conversation' do
      # like the conversation through another user
      @another_user_headers = {:Authorization => "Bearer #{@config.get_access_token_by_user(:regular_user1)}",
      :Accept => "application/json", :content_type => "application/json", :verify_ssl => false}

      post "#{@api_url}/Posts('#{@root_post_id}')/Like()", nil, @another_user_headers
      expect_status(204)

      get "#{@api_url}/Conversations('#{@conv_uuid}')/Likes", @headers
      expect_status(200)
      expect_json_sizes("d", results: 1)
      expect_json_keys("d.results.0", [:Id, :Direction])
    end

    # Test these APIs:
    # => [GET] /Conversations('{id}')/NotFeaturedReplies
    # Depend on these APIs:
    # => [POST] /Posts('{id}')/Posts
    it 'can get replies not featured on the conversation' do
      # create a reply under the root post  
      body = {"d":{"HtmlContent":"<div class=input><p>reply 2</p></div>"}}
      response = post "#{@api_url}/Posts('#{@root_post_id}')/Posts", body, @headers
      expect_status(201)

      @reply_post_2_id = JSON.parse(response)["d"]["results"]["Id"]

      # create another reply under the reply 
      body = {"d":{"HtmlContent":"<div class=input><p>reply 2.1</p></div>"}}
      response = post "#{@api_url}/Posts('#{@reply_post_2_id}')/Posts", body, @headers
      expect_status(201)

      @reply_post_2_1_id = JSON.parse(response)["d"]["results"]["Id"]

      # get replies not featured
      get "#{@api_url}/Conversations('#{@conv_uuid}')/NotFeaturedReplies", @headers
      expect_status(200)

      expect_json_sizes("d", results: 2)
      expect_json("d.results.0", Id: "#{@reply_post_2_id}", OriginalContent: "reply 2", IsFeatured: false, Traits: nil, Depth: 1)
      expect_json("d.results.1", Id: "#{@reply_post_2_1_id}", OriginalContent: "reply 2.1", IsFeatured: false, Traits: nil, Depth: 2)
    end 

    # Test these APIs:
    # => [GET] /Conversations('{id}')/PageLayout
    it 'can get page layout of the conversation' do
      # get page layout of the conversation
      get "#{@api_url}/Conversations('#{@conv_uuid}')/PageLayout", @headers
      expect_status(200)
      expect_json_keys("d.results", [:__metadata, :Id, :CreatorId, :PageName, :LayoutName, :Config])
      expect_json("d.results.__metadata", type: "Excelsior.PageLayout")
    end 

    # Test these APIs:
    # => [GET] /Conversations('{id}')/ProductReview
    it 'can get the product review on the conversation' do
      get "#{@api_url}/Conversations('#{@conv_uuid}')/ProductReview", @headers
      expect_status(200)
      expect_json('d.results', Recommended: true, Purchased: false, RatingValue: "5.0")
    end 

    # Test these APIs:
    # => [GET] /Conversations('{id}')/Topic
    it 'can get the topic information of the conversation' do
      response = get "#{@api_url}/Conversations('#{@conv_uuid}')/Topic", @headers
      expect_status(200)
      expect_json_keys('Topic', [:network_id, :id, :title, :topic_type, 
                                 :is_featured, :is_active, :view_count, :conversations_view_count])
      expect_json('Topic', uuid: @topic_uuid)
    end 

    # Test these APIs:
    # => [POST] /Conversations('{id}')/Close() 
    it 'can close the conversation' do
      post "#{@api_url}/Conversations('#{@conv_uuid}')/Close()", nil, @headers
      expect_status(204)
    end 

    # Test these APIs:
    # => [POST] /Conversations('{id}')/Reopen() 
    it 'can reopen the conversation' do
      post "#{@api_url}/Conversations('#{@conv_uuid}')/Reopen()", nil, @headers
      expect_status(204)
    end 

    # Test these APIs:
    # => [POST] /Conversations('{id}')/ReviewHelpful()
    it 'can mark the review as helpful' do
      post "#{@api_url}/Conversations('#{@conv_uuid}')/ReviewHelpful()", nil, @headers
      expect_status(204)
    end 

    # Test these APIs:
    # => [POST] /Conversations('{id}')/ReviewNotHelpful()
    it 'can mark the review as not helpful' do
      post "#{@api_url}/Conversations('#{@conv_uuid}')/ReviewNotHelpful()", nil, @headers
      expect_status(204)
    end 

    # Test these APIs:
    # => [DELETE] /Conversations('{id}')
    it 'can delete the conversation' do
      delete "#{@api_url}/Conversations('#{@conv_uuid}')", nil, @headers
      expect_status(204)
    end 
  end 

  context 'after create a new question' do
    before(:context) do
      # create a question
      question_obj = create_question_in_topic(@topic_uuid, @api_url, @headers)

      @q_title = question_obj.title
      @conv_uuid = question_obj.conversation_id
      @root_post_id = question_obj.root_post_id
    end

    # Test these APIs:
    # => [POST] /Conversations('{id}')/Votes
    # => [GET] /Conversations('{id}')/Votes
    it 'can vote and get votes on the question' do
      # vote up for the question
      body = {d: {VoteResult: "up"}}
      response = post "#{@api_url}/Conversations('#{@conv_uuid}')/Votes", body, @headers
      expect_status(201)
      expect_json("d.results", VoteResult: 1)

      vote_up_id = JSON.parse(response)["d"]["results"]["Id"]

      get "#{@api_url}/Conversations('#{@conv_uuid}')/Votes", @headers
      expect_status(200)
      expect_json_sizes("d", results: 1)
      expect_json("d.results.0", Id: "#{vote_up_id}", VoteResult: 1)

      # vote down for the question by another user
      @another_user_headers = {:Authorization => "Bearer #{@config.get_access_token_by_user(:regular_user1)}",
                               :Accept => "application/json", 
                               :content_type => "application/json", 
                               :verify_ssl => false}

      body = {d: {"VoteResult": "down"}}
      response = post "#{@api_url}/Conversations('#{@conv_uuid}')/Votes", body, @another_user_headers
      expect_status(201) 

      vote_down_id = JSON.parse(response)["d"]["results"]["Id"]

      get "#{@api_url}/Conversations('#{@conv_uuid}')/Votes", @headers
      expect_status(200)
      expect_json_sizes("d", results: 2)
      expect_json("d.results.0", Id: "#{vote_up_id}", VoteResult: 1) 
      expect_json("d.results.1", Id: "#{vote_down_id}", VoteResult: -1)                       
    end 
    
    context 'then create bunch of replies' do
      before(:context) do
        first_reply_post_id = nil
        # prepare more than 20 replies under the root post  
        0.upto(20) { |i|
          post_id = create_post_in_conversation("reply #{i}", @root_post_id, @api_url, @headers)
          
          first_reply_post_id = post_id if i == 0
        }

        # create a reply post under the first reply
        if !first_reply_post_id.nil?
          # body = {"d":{"HtmlContent":"<div class=input><p>reply 0.0</p></div>"}}
          # response = post "#{@api_url}/Posts('#{first_reply_post_id}')/Posts", body, @headers
          # expect_status(201)
          create_post_in_conversation("reply 0.0", first_reply_post_id, @api_url, @headers)
        end
      end
        
      # Test these APIs:  
      # => [GET] /Conversations('{id}')/PaginatedPosts
      it 'can get the paginated posts on the conversation' do
        get "#{@api_url}/Conversations('#{@conv_uuid}')/PaginatedPosts", @headers
        expect_status(200)

        # PaginatedPosts will return replies in the order what user see them in UI
        expect_json_sizes("d", results: 21) # get the first 20 posts of depth = 1 plus their replies
        expect_json("d.results.0", OriginalContent: @q_title) # root post
        expect_json("d.results.1", OriginalContent: "reply 0") # first reply
        expect_json("d.results.2", OriginalContent: "reply 0.0") # reply for first reply
      end

      # Test these APIs:
      # => [GET] /Conversations('{id}')/Posts
      it 'can get the posts in the conversation' do
        get "#{@api_url}/Conversations('#{@conv_uuid}')/Posts", @headers
        expect_status(200)

        # Posts will return replies in the ascending order of their creation date
        expect_json_sizes("d", results: 20) # get the first 20 posts of depth = 1
        expect_json("d.results.0", OriginalContent: @q_title) # root post
        expect_json("d.results.1", OriginalContent: "reply 0") # first reply
        expect_json("d.results.2", OriginalContent: "reply 1") # second reply
      end 
    end

    after(:context) do
      # delete the conversation
      delete "#{@api_url}/Conversations('#{@conv_uuid}')", nil, @headers
      expect_status(204)
    end  
  end 
end
