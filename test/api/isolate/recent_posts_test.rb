require 'airborne'
require 'time'
require_relative '../api_test_config'
require_relative '../helper/api_v2_test_data_builder'

describe 'Recent Posts API' do
  puts 'Recent Posts API v2'
  include APIV2TestDataBuilder

  before(:all) do
    @config = APITestConfig.new
    @api_url = '/api/v2'

    @topic_id = @config.api_data['topic_id_get']

    @admin_headers = {:Authorization => "Bearer #{@config.access_token}", 
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

    # set moderation to low level. otherwise, some cases will fail.
    get "#{@api_url}/moderation", @admin_headers

    expect_status(200)
    @old_mod_type = JSON.parse(response)["data"]["type"]
    @old_mod_threshold = JSON.parse(response)["data"]["threshold"]

    if @old_mod_type != "community_moderation_post_shown"
      @new_mod_type = "community_moderation_post_shown"
      @new_mod_threshold = 2

      body = {
        :type => @new_mod_type,
        :profanity_enabled => true,
        :threshold => @new_mod_threshold
      }
      patch "#{@api_url}/moderation", body, @admin_headers

      expect_status(200)
    end                  
  end

  after(:all) do
    # revert the moderation setting
    unless @new_mod_type.nil?
      body = {
        :type => @old_mod_type,
        :profanity_enabled => true,
        :threshold => @old_mod_threshold
      }
      patch "#{@api_url}/moderation", body, @admin_headers

      expect_status(200)
    end  
  end

  context 'after create a question with 1 reply' do
    before(:context) do
      # create a question
      @q_title = "q_apitest_" + Time.now.to_s
      @html_content = "<p>#{@q_title}</p>"
      body = {"title": @q_title, "html_content": @html_content}
      post "#{@api_url}/topics/#{@topic_id}/questions", body, @user_1_headers
      expect_status(201)

      @question_id = JSON.parse(response)["data"]["id"]
      @question_created_date = JSON.parse(response)["data"]["created_at"]

      # create a reply for the question
      body = { html_content: "reply 1"}
      response = post "#{@api_url}/questions/#{@question_id}/replies", body, @user_2_headers
      expect_status(201)

      @reply1_id = JSON.parse(response)["data"]["id"]   
    end
    
    after(:context) do
      # delete the question
      delete "#{@api_url}/questions/#{@question_id}", nil, @admin_headers
      expect_status(200)
    end

    it 'should not get posts whose moderation_status!=clear or traits!=question or answer' do
      get "#{@api_url}/recent_posts?_filters={\"traits.equals\":\"featured_question\",\"updated_at.afters\":\"#{@question_created_date}\"}", nil

      expect_status(200)
      expect_json_sizes("data", 0)
      expect_json("metadata.pagination.total_count", 0)

      get "#{@api_url}/recent_posts?_filters={\"traits.equals\":\"accepted_answer\",\"updated_at.afters\":\"#{@question_created_date}\"}", nil
      expect_status(200)
      expect_json_sizes("data", 0)

      get "#{@api_url}/recent_posts?_filters={\"moderation_status.equals\":\"1\",\"updated_at.afters\":\"#{@question_created_date}\"}", nil
      expect_status(200)
      expect_json_sizes("data", 0)

      get "#{@api_url}/recent_posts?_filters={\"moderation_status.equals\":\"2\",\"updated_at.afters\":\"#{@question_created_date}\"}", nil
      expect_status(200)
      expect_json_sizes("data", 0)

      get "#{@api_url}/recent_posts?_filters={\"moderation_status.equals\":\"3\",\"updated_at.afters\":\"#{@question_created_date}\"}", nil
      expect_status(200)
      expect_json_sizes("data", 0)

      get "#{@api_url}/recent_posts?_filters={\"moderation_status.equals\":\"4\",\"updated_at.afters\":\"#{@question_created_date}\"}", nil
      expect_status(200)
      expect_json_sizes("data", 0)

      get "#{@api_url}/recent_posts?_filters={\"moderation_status.equals\":\"5\",\"updated_at.afters\":\"#{@question_created_date}\"}", nil
      expect_status(200)
      expect_json_sizes("data", 0)

      get "#{@api_url}/recent_posts?_filters={\"moderation_status.equals\":\"6\",\"updated_at.afters\":\"#{@question_created_date}\"}", nil
      expect_status(200)
      expect_json_sizes("data", 0)

      get "#{@api_url}/recent_posts?_filters={\"moderation_status.equals\":\"7\",\"updated_at.afters\":\"#{@question_created_date}\"}", nil
      expect_status(200)
      expect_json_sizes("data", 0)
    end  

    it 'should get only the root post of the question with filter traits=question' do
      get "#{@api_url}/recent_posts?_filters={\"traits.equals\":\"question\",\"updated_at.afters\":\"#{@question_created_date}\"}", nil

      expect_status(200)
      expect_json_sizes("data", 1)
      expect_json("data.0", contents: @q_title, traits: ["question"], moderation_status: "moderation_status_clear")
      expect_json_keys('data.*', [:id, :traits, :parent_id, :contents, :moderation_status, :created_at, :updated_at])
    end

    it 'should get only the answer with filter traits=answer' do
      get "#{@api_url}/recent_posts?_filters={\"traits.equals\":\"answer\",\"updated_at.afters\":\"#{@question_created_date}\"}", nil

      expect_status(200)
      expect_json_sizes("data", 1)
      expect_json("data.0", id: @reply1_id, traits: ["answer"], moderation_status: "moderation_status_clear")
      expect_json_keys('data.*', [:id, :traits, :parent_id, :contents, :moderation_status, :created_at, :updated_at])
    end

    # 'should get both the root post and the reply without traits filtered'
    it 'should get the conversation info with _extends=conversation' do
      get "#{@api_url}/recent_posts?_extends=[\"conversation\"]&_filters={\"updated_at.afters\":\"#{@question_created_date}\"}", nil

      expect_status(200)
      expect_json_sizes("data", 2)
      expect_json("data.0", contents: @q_title, traits: ["question"], moderation_status: "moderation_status_clear")
      expect_json("data.1", id: @reply1_id, traits: ["answer"], moderation_status: "moderation_status_clear")
      expect_json("data.*._conversation", id: @question_id)
      expect_json_keys('data.*', [:id, :traits, :parent_id, :contents, :moderation_status, :created_at, :updated_at])
      expect_json_keys("data.*._conversation", [:id, :title, :html_content])
    end
  end  

  context 'after create a featured question with 1 best_answer' do
    before(:context) do
      # create a question
      @q_title = "q_apitest_" + Time.now.to_s
      @html_content = "<p>#{@q_title}</p>"
      body = {"title": @q_title, "html_content": @html_content}
      post "#{@api_url}/topics/#{@topic_id}/questions", body, @user_1_headers
      expect_status(201)

      @question_id = JSON.parse(response)["data"]["id"]
      @question_created_date = JSON.parse(response)["data"]["created_at"]

      # create a reply for the question
      body = { html_content: "reply 1"}
      post "#{@api_url}/questions/#{@question_id}/replies", body, @user_2_headers
      expect_status(201)

      @reply1_id = JSON.parse(response)["data"]["id"] 

      # create another reply for the question
      body = { html_content: "reply 2"}
      post "#{@api_url}/questions/#{@question_id}/replies", body, @user_2_headers
      expect_status(201)

      @reply2_id = JSON.parse(response)["data"]["id"]

      # feature the question
      post "#{@api_url}/questions/#{@question_id}/feature", nil, @admin_headers
      expect_status(200)

      # mark the first reply as best answer
      post "#{@api_url}/replies/#{@reply1_id}/feature", nil, @admin_headers
      expect_status(200)
    end
    
    after(:context) do
      # delete the question
      delete "#{@api_url}/questions/#{@question_id}", nil, @admin_headers
      expect_status(200)
    end

    it 'should get the featured question with filter traits=featured_question' do
      get "#{@api_url}/recent_posts?_filters={\"traits.equals\":\"question\",\"updated_at.afters\":\"#{@question_created_date}\"}", nil
      expect_status(200)
      expect_json_sizes("data", 1)

      get "#{@api_url}/recent_posts?_filters={\"traits.equals\":\"featured_question\",\"updated_at.afters\":\"#{@question_created_date}\"}", nil
      expect_status(200)
      expect_json_sizes("data", 1)
    end 

    it 'should get the accepted answer with filter traits=accepted_answer' do
      get "#{@api_url}/recent_posts?_filters={\"traits.equals\":\"answer\",\"updated_at.afters\":\"#{@question_created_date}\"}", nil

      expect_status(200)
      expect_json_sizes("data", 2)

      get "#{@api_url}/recent_posts?_filters={\"traits.equals\":\"accepted_answer\",\"updated_at.afters\":\"#{@question_created_date}\"}", nil
      expect_status(200)
      expect_json_sizes("data", 1)
      expect_json("data.0", id: @reply1_id)
    end 
  end 

  context 'after create a escalated question with 1 question' do
    before(:context) do
      # create a question
      @q_title = "q_apitest_" + Time.now.to_s
      @html_content = "<p>#{@q_title}</p>"
      body = {"title": @q_title, "html_content": @html_content}
      post "#{@api_url}/topics/#{@topic_id}/questions", body, @user_1_headers
      expect_status(201)

      @question_id = JSON.parse(response)["data"]["id"]
      @question_created_date = JSON.parse(response)["data"]["created_at"]

      # create a reply for the question
      body = { html_content: "reply 1"}
      post "#{@api_url}/questions/#{@question_id}/replies", body, @user_2_headers
      expect_status(201)

      @reply1_id = JSON.parse(response)["data"]["id"]

      sleep 1

      # create another reply for the question
      body = { html_content: "reply 2"}
      post "#{@api_url}/questions/#{@question_id}/replies", body, @user_2_headers
      expect_status(201)

      @reply2_id = JSON.parse(response)["data"]["id"]

      # escalate the first question
      post "#{@api_url}/questions/#{@question_id}/escalate", nil, @admin_headers
      expect_status(200)

      # create another question
      @q_title = "q_apitest_" + Time.now.to_s
      @html_content = "<p>#{@q_title}</p>"
      body = {"title": @q_title, "html_content": @html_content}
      post "#{@api_url}/topics/#{@topic_id}/questions", body, @user_1_headers
      expect_status(201)

      @question2_id = JSON.parse(response)["data"]["id"]

      # create another reply for the question
      body = { html_content: "reply 3"}
      post "#{@api_url}/questions/#{@question2_id}/replies", body, @user_2_headers
      expect_status(201)

      @reply3_id = JSON.parse(response)["data"]["id"]
    end
    
    after(:context) do
      unless @question_id.nil?
        # delete the question
        delete "#{@api_url}/questions/#{@question_id}", nil, @admin_headers
        expect_status(200)
      end

      unless @question2_id.nil?
        # delete the question
        delete "#{@api_url}/questions/#{@question2_id}", nil, @admin_headers
        expect_status(200)
      end
    end

    it 'should get the escalated question with filter moderation_status=escalated' do
      get "#{@api_url}/recent_posts?_filters={\"moderation_status.equals\":\"5\",\"updated_at.afters\":\"#{@question_created_date}\"}", nil
      expect_status(200)
      expect_json_sizes("data", 1)
    end

    it 'should get all replies with filter traits=answer' do
      get "#{@api_url}/recent_posts?_filters={\"traits.equals\":\"answer\", \"updated_at.afters\":\"#{@question_created_date}\"}", nil

      expect_status(200)
      expect_json_sizes("data", 3)
      expect_json("data.*", traits: ["answer"])
    end  

    it 'should get the replies under the escalated question with ans2esc=true' do
      get "#{@api_url}/recent_posts?_filters={\"updated_at.afters\":\"#{@question_created_date}\"}&ans2esc=true", nil

      # only return replies. root posts won't be included.
      expect_status(200)
      expect_json_sizes("data", 2)
      expect_json("data.*", traits: ["answer"])
    end

    it 'should get the replies with filter traits=answer and ans2esc=true' do
      get "#{@api_url}/recent_posts?_filters={\"traits.equals\":\"answer\", \"updated_at.afters\":\"#{@question_created_date}\"}&ans2esc=true", nil

      expect_status(200)
      expect_json_sizes("data", 2)
    end

    it 'should get empty result with filter moderation_status=escalated and traits=answer' do
      # no escalated answer at all
      get "#{@api_url}/recent_posts?_filters={\"moderation_status.equals\":\"5\", \"traits.equals\":\"answer\", \"updated_at.afters\":\"#{@question_created_date}\"}", nil
      expect_status(200)
      expect_json_sizes("data", 0)
    end

    it 'should get empty result with filter moderation_status=escalated and traits=answer and ans2esc=true' do
      # no escalated answer at all
      get "#{@api_url}/recent_posts?_filters={\"moderation_status.equals\":\"5\", \"traits.equals\":\"answer\", \"updated_at.afters\":\"#{@question_created_date}\"}&ans2esc=true", nil
      expect_status(200)
      skip "Blocked by bug EN-2614"
      expect_json_sizes("data", 0)
    end

    it 'should get replies in correct orders with _order set' do
      get "#{@api_url}/recent_posts?_filters={\"updated_at.afters\":\"#{@question_created_date}\"}&ans2esc=true&_order={\"updated_at\":\"asc\"}", nil
      expect_status(200)
      expect_json_sizes("data", 2)
      expect_json("data.0", id: @reply1_id)
      expect_json("data.1", id: @reply2_id)

      get "#{@api_url}/recent_posts?_filters={\"updated_at.afters\":\"#{@question_created_date}\"}&ans2esc=true&_order={\"updated_at\":\"desc\"}", nil
      expect_status(200)
      expect_json_sizes("data", 2)
      expect_json("data.0", id: @reply2_id)
      expect_json("data.1", id: @reply1_id)
    end  
  end  

  context 'after create all kinds of conversations' do
    before(:context) do
      # create a question
      @q_title = "q_apitest_" + Time.now.to_s
      @html_content = "<p>#{@q_title}</p>"
      body = {"title": @q_title, "html_content": @html_content}
      post "#{@api_url}/topics/#{@topic_id}/questions", body, @user_1_headers
      expect_status(201)

      @question_id = JSON.parse(response)["data"]["id"]
      @question_created_date = JSON.parse(response)["data"]["created_at"]

      # create a reply for the question
      body = { html_content: "reply 1"}
      response = post "#{@api_url}/questions/#{@question_id}/replies", body, @user_2_headers
      expect_status(201)

      @reply1_id = JSON.parse(response)["data"]["id"]

      # # escalate the question
      # post "#{@api_url}/questions/#{@question_id}/escalate", nil, @admin_headers
      # expect_status(200)

      # delete all existing reviews by admin user
      delete_all_reviews_in_topic(@topic_id, @api_url, @admin_headers)
      # create a review before test the following api
      review_obj = create_review_in_topic(@topic_id, @api_url, @admin_headers)
      @review_id = review_obj.id

      # create a blog
      blog = create_conversation_in_topic("blog", @topic_id, @api_url, @admin_headers)
      @blog_id = blog[:id]
    end
    
    after(:context) do
      unless @question_id.nil?
        # delete the question
        delete "#{@api_url}/questions/#{@question_id}", nil, @admin_headers
        expect_status(200)
      end

      unless @review_id.nil?
        # delete the review
        delete "#{@api_url}/reviews/#{@review_id}", nil, @admin_headers
        expect_status(200)
      end

      unless @blog_id.nil?
        # delete the blog
        delete "#{@api_url}/blogs/#{@blog_id}", nil, @admin_headers
        expect_status(200)
      end
    end  

    it 'should get all root posts and replies without filter traits set' do
      get "#{@api_url}/recent_posts?_filters={\"updated_at.afters\":\"#{@question_created_date}\"}", nil
      expect_status(200)
      expect_json_sizes("data", 4)
    end
  end
end
