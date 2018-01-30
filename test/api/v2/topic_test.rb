require 'airborne'
require_relative '../api_test_config'
require_relative '../helper/api_v2_test_data_builder'

# Usage:
#   APITestConfig will initialize the same as watir config
#   all api test related test data are put in /test/api/data/config.yml, such as topic_id_get, application_id, secret_id etc,.

#   NOTE:
#   When testing an API call which create data in test target system. Please make sure PATCH and DELETE testing in a single test if possible
#   otherwise, there will be additional preconditions to setup for every delete test.

describe 'Topics' do
  puts 'Topic APIs v2'
  include APIV2TestDataBuilder

  before(:all) {
    @config = APITestConfig.new
    @api_base_url = '/api/v2'
    @topic_id_get = @config.api_data['topic_id_get']
    @product_id_get = @config.api_data['product_id_get']
    @search_keyword = @config.api_data['search_keyword']
    @headers = {:Authorization => "Bearer #{@config.access_token}",
                :Accept => "application/json",
                :content_type => "application/json",
                :verify_ssl => false}
  }

  it 'can get all topics' do
    get "#{@api_base_url}/topics", @headers
    expect_status(200)
    expect_json_keys('data.*', [:id, :title, :pretty_title, :description, :type,
                                :is_featured, :is_active])
  end

  it 'can post a topic' do
    body = {"title":"test api post title - " + Time.now.to_s,
            "description": "description - " + Time.now.to_s,
            "type": "engagement"
    }
    post "#{@api_base_url}/topics", body, @headers
    expect_status(201)
  end

  it 'can get topic by id' do
    get "#{@api_base_url}/topics/#{@topic_id_get}", @headers
    expect_status(200)
    expect_json_keys('data', [:id, :title, :pretty_title, :description, :type,
                              :is_featured, :is_active])
  end

  # it 'can put a topic'do
  #
  # end

  it 'can patch topic'do
    timestamp = Time.now.utc.to_s.gsub(/[-: ]/,'')
    description = "Watir, pronounced water, is an open-source (BSD) family of Ruby libraries for automating web browsers.- #{timestamp}"
    body = {
        "description":description
    }
    patch "#{@api_base_url}/topics/#{@topic_id_get}", body, @headers
    expect_status(200)
    expect_json('data.description', description)

  end

  it 'can get all blogs of a topic by id' do
    get "#{@api_base_url}/topics/#{@topic_id_get}/blogs", @headers
    expect_status(200)
    expect_json_keys('data.*', [:id, :title, :html_content, :is_featured, :is_closed, :is_visible,
                                :like_count, :follow_count, :reply_count, :vote_count, :view_count,
                                :created_at, :updated_at, :creator, :has_featured, :_ref_link])
    expect_json_keys('data.*.creator', [:id, :firstname, :lastname, :fullname, :username, :email,
                                        :type, :provider, :profile_photo_url, :profile_photo_48x48_url,
                                        :profile_photo_140x140_url, :created_at, :_ref_link])
  end

  it 'can post a blog of a topic' do
    body = {"title":"title - test api of post a new topic blog",
            "html_content": "description - test api of post a new topic blog"
    }
    post "#{@api_base_url}/topics/#{@topic_id_get}/blogs", body, @headers
    expect_status(201)
    expect_json_keys('data', [:id, :title, :html_content, :is_featured, :is_closed, :is_visible,
                                :like_count, :follow_count, :reply_count, :vote_count, :view_count,
                                :created_at, :updated_at, :creator, :has_featured, :_ref_link])
    expect_json_keys('data.creator', [:id, :firstname, :lastname, :fullname, :username, :email,
                                        :type, :provider, :profile_photo_url, :profile_photo_48x48_url,
                                        :profile_photo_140x140_url, :created_at, :_ref_link])
  end

  it 'can get all questions of a topic by id' do
    get "#{@api_base_url}/topics/#{@topic_id_get}/questions", @headers
    expect_status(200)
    expect_json_keys('data.*', [:id, :title, :html_content, :is_featured, :is_closed, :is_visible,
                                :like_count, :follow_count, :reply_count, :vote_count, :view_count,
                                :created_at, :updated_at, :creator, :has_best_answer, :_ref_link])
    expect_json_keys('data.*.creator', [:id, :firstname, :lastname, :fullname, :username, :email,
                                        :type, :provider, :profile_photo_url, :profile_photo_48x48_url,
                                        :profile_photo_140x140_url, :created_at, :_ref_link])
  end

  it 'can post a question of a topic' do
    body = {"title":"title - test api of post a new topic question",
            "html_content": "description - test api of post a new topic question"
    }
    post "#{@api_base_url}/topics/#{@topic_id_get}/questions", body, @headers
    expect_status(201)
    expect_json_keys('data', [:id, :title, :html_content, :is_featured, :is_closed, :is_visible,
                              :like_count, :follow_count, :reply_count, :vote_count, :view_count,
                              :created_at, :updated_at, :creator, :has_best_answer, :_ref_link])
    expect_json_keys('data.creator', [:id, :firstname, :lastname, :fullname, :username, :email,
                                      :type, :provider, :profile_photo_url, :profile_photo_48x48_url,
                                      :profile_photo_140x140_url, :created_at, :_ref_link])
  end

  it 'can get all reviews of a topic by id' do
    get "#{@api_base_url}/topics/#{@topic_id_get}/reviews", @headers
    expect_status(200)
    expect_json_keys('data.*', [:id, :title, :html_content, :is_featured, :is_closed, :is_visible,
                                :like_count, :follow_count, :reply_count, :vote_count, :view_count,
                                :created_at, :updated_at, :creator, :has_featured, :_ref_link])
    expect_json_keys('data.*.creator', [:id, :firstname, :lastname, :fullname, :username, :email,
                                        :type, :provider, :profile_photo_url, :profile_photo_48x48_url,
                                        :profile_photo_140x140_url, :created_at, :_ref_link])
  end

  it 'can post a review of a topic' do
    body = {"title":"test api post title - " + Time.now.to_s,
            "description": "description - " + Time.now.to_s,
            "type": "engagement"
    }
    response = post "#{@api_base_url}/topics", body, @headers
    topic_id = JSON.parse(response)['data']['id']
    post "#{@api_base_url}/topics/#{topic_id}/activate", {}, @headers
    expect_json('code', "OK_RESOURCE_UPDATED")
    expect_json('message', "resource updated")
    body2 = {"title":"title - test api of post a new topic review",
            "html_content": "description - test api of post a new topic review",
            "rating": 5
    }
    response2 = post "#{@api_base_url}/topics/#{topic_id}/reviews", body2, @headers
    expect_status(201)
    expect_json_keys('data', [:id, :title, :html_content, :is_featured, :is_closed, :is_visible,
                              :like_count, :follow_count, :reply_count, :vote_count, :view_count,
                              :created_at, :updated_at, :creator, :has_featured, :helpful_count,
                              :not_helpful_count, :recommended, :purchased, :rating, :_ref_link])
    expect_json_keys('data.creator', [:id, :firstname, :lastname, :fullname, :username, :email,
                                      :type, :provider, :profile_photo_url, :profile_photo_48x48_url,
                                      :profile_photo_140x140_url, :created_at, :_ref_link])
    review_id = JSON.parse(response2)['data']['id']
    delete "#{@api_base_url}/reviews/#{review_id}", nil, @headers
    expect_status(200)
    expect_json("message", "resource deleted")
  end

  it 'can feature a topic' do
    body = {
    }
    post "#{@api_base_url}/topics/#{@topic_id_get}/feature", body, @headers
    expect_status(200)
    expect_json('data.is_featured', true)
  end

  it 'can unfeature a topic' do
    body = {
    }
    post "#{@api_base_url}/topics/#{@topic_id_get}/unfeature", body, @headers
    expect_status(200)
    expect_json('data.is_featured', false)
  end

  it 'can follow a topic' do
    body = {"level_of_interest":"high"
    }
    post "#{@api_base_url}/topics/#{@topic_id_get}/follow", body, @headers
    expect_status(200)
  end

  it 'can unfollow a topic' do
    body = {
    }
    post "#{@api_base_url}/topics/#{@topic_id_get}/unfollow", body, @headers
    expect_status(200)
  end

  it 'can deactivate a topic' do
    body = {
    }
    post "#{@api_base_url}/topics/#{@topic_id_get}/deactivate", body, @headers
    expect_status(200)
    expect_json('data.is_active', false)
  end

  it 'can activate a topic' do
    body = {
    }
    post "#{@api_base_url}/topics/#{@topic_id_get}/activate", body, @headers
    expect_status(200)
    expect_json('data.is_active', true)
  end

  it 'can get, post and publish draft topics'do
    body = {}
    post "#{@api_base_url}/topics/#{@topic_id_get}/draft", body, @headers
    expect_status(201)
    get "#{@api_base_url}/topics/#{@topic_id_get}/draft", @headers
    expect_status(200)
    post "#{@api_base_url}/topics/#{@topic_id_get}/draft/publish", body, @headers
    expect_status(200)
  end

  it 'can put draft topic' do
    title = "test api post title - " + Time.now.to_s
    description = "description - " + Time.now.to_s
    body = {"title":title,
            "description": description,
            "type": "engagement"
    }
    post "#{@api_base_url}/topics", body, @headers
    expect_status(201)
    topic_id = JSON.parse(response)['data']['id']
    body2 = {}
    post "#{@api_base_url}/topics/#{topic_id}/draft", body2, @headers
    body3 = {"title":title + " edited",
            "description": description + " edited",
            "type": "engagement"
    }
    put "#{@api_base_url}/topics/#{topic_id}/draft", body3, @headers
    expect_status(200)
    expect_json('data.title', title + " edited")
    expect_json('data.description', description + " edited")
    post "#{@api_base_url}/topics/#{topic_id}/draft/publish", body, @headers
    expect_status(200)
  end

  it 'can patch draft topic' do
    title = "test api post title - " + Time.now.to_s
    description = "description - " + Time.now.to_s
    body = {"title":title,
            "description": description,
            "type": "engagement"
    }
    post "#{@api_base_url}/topics", body, @headers
    expect_status(201)
    topic_id = JSON.parse(response)['data']['id']
    body2 = {}
    post "#{@api_base_url}/topics/#{topic_id}/draft", body2, @headers
    body3 = {"type": "support"
    }
    patch "#{@api_base_url}/topics/#{topic_id}/draft", body3, @headers
    expect_status(200)
    expect_json('data.type', "support")
    post "#{@api_base_url}/topics/#{topic_id}/draft/publish", body, @headers
    expect_status(200)
  end

  it 'can delete draft topic' do
    body = {"title":"test api post title - " + Time.now.to_s,
            "description": "description - " + Time.now.to_s,
            "type": "engagement"
    }
    post "#{@api_base_url}/topics", body, @headers
    expect_status(201)
    topic_id = JSON.parse(response)['data']['id']
    body2 = {}
    post "#{@api_base_url}/topics/#{topic_id}/draft", body2, @headers
    expect_status(201)
    delete "#{@api_base_url}/topics/#{topic_id}/draft", nil, @headers
    expect_status(200)
    expect_json('code', 'OK_RESOURCE_DELETED')
  end

  context 'after create a new topic' do
    before(:each) do
      # create a new topic
      body = {"title":"test api post title - " + Time.now.to_s,
              "description": "description - " + Time.now.to_s,
              "type": "engagement"
      }
      post "#{@api_base_url}/topics", body, @config.user_headers(:network_admin)
      expect_status(201)
      @topic_id = JSON.parse(response)['data']['id']

      # activate it
      post "#{@api_base_url}/topics/#{@topic_id}/activate", nil, @config.user_headers(:network_admin)
      expect_status(200)
    end

    # Test these APIs:
    # => [GET] /topics/{id}/overview
    # Depend on these APIs:
    # => [POST] /topics
    # => [POST] /topics/{id}/blogs
    # => [POST] /topics/{id}/questions
    # => [POST] /topics/{id}/reviews
    # => [DELETE] /topics/{id}
    it 'can get the top 3 blogs, questions, and reviews in a batch' do
      # Discussion is removed from our product.
      # # create a discussion
      # @disc_title = "disc_apitest_" + Time.now.to_s
      # @disc_html_content = "<p>#{@disc_title}</p>"
      # body = {"title": @disc_title, "html_content": @disc_html_content}
      # post "#{@api_base_url}/topics/#{@topic_id}/discussions", body, @config.user_headers(:regular_user2)
      # expect_status(201)
      # @disc_id = JSON.parse(response)['data']['id']

      # create a blog
      @blog_title = "blog_apitest_" + Time.now.to_s
      @blog_html_content = "<p>#{@blog_title}</p>"
      body = {"title": @blog_title, "html_content": @blog_html_content}
      post "#{@api_base_url}/topics/#{@topic_id}/blogs", body, @config.user_headers(:network_admin)
      expect_status(201)
      @blog_id = JSON.parse(response)['data']['id']

      # create four questions
      @question_1_obj = create_question_in_topic(@topic_id, @api_base_url, @config.user_headers(:regular_user2))
      @question_1_id = @question_1_obj.id
      @question_2_obj = create_question_in_topic(@topic_id, @api_base_url, @config.user_headers(:regular_user2))
      @question_2_id = @question_2_obj.id
      @question_3_obj = create_question_in_topic(@topic_id, @api_base_url, @config.user_headers(:regular_user2))
      @question_3_id = @question_3_obj.id
      @question_4_obj = create_question_in_topic(@topic_id, @api_base_url, @config.user_headers(:regular_user2))
      @question_4_id = @question_4_obj.id

      # create a review
      @review_obj = create_review_in_topic(@topic_id, @api_base_url, @config.user_headers(:regular_user2))
      @review_id = @review_obj.id

      # get overview of the topic by anonymous user
      get "#{@api_base_url}/topics/#{@topic_id}/overview", nil
      expect_status(200)
      expect_json_sizes("data", 5)
      expect_json_keys("data.*", [:id, :title, :html_content, :is_featured])
      expect_json('data.0', id: @blog_id, title: @blog_title, html_content: @blog_html_content, is_featured: false)
      # EN-2717
      # expect_json('data.1', id: @question_4_id, is_featured: false)
      # expect_json('data.2', id: @question_3_id, is_featured: false)
      # expect_json('data.3', id: @question_2_id, is_featured: false)
      expect_json('data.4', id: @review_id, is_featured: false)

      get "#{@api_base_url}/topics/#{@topic_id}/overview?limit=4", nil
      expect_status(200)
      expect_json_sizes("data", 6)
    end     

    # Test these APIs:
    # => [GET] /topics/{id}/member_metrics
    # Depend on these APIs:
    # => [POST] /topics
    # => [DELETE] /topics/{id}
    it 'can get the member metrics per different params' do
      # user 1 create two questions
      @question_1_obj = create_question_in_topic(@topic_id, @api_base_url, @config.user_headers(:regular_user1))
      @question_2_obj = create_question_in_topic(@topic_id, @api_base_url, @config.user_headers(:regular_user1))
      # user 2 create one question
      @question_3_obj = create_question_in_topic(@topic_id, @api_base_url, @config.user_headers(:regular_user2))
      
      # get member metrics per most_posts
      get "#{@api_base_url}/topics/#{@topic_id}/member_metrics?metric=most_posts", nil
      expect_status(200)
      expect_json_sizes("data", 2)
      expect_json_keys("data.*", [:id, :count, :is_member_max, :metric, :member, :topic])
      expect_json("data.0.member", username: @config.users[:regular_user1].username)
      expect_json("data.0.count", 2)
      expect_json("data.1.member", username: @config.users[:regular_user2].username)
      expect_json("data.1.count", 1)
      expect_json("data.*", metric: "most_posts")
      expect_json("data.*.topic", id: @topic_id)

      # get member metrics per most_recent_activity
      get "#{@api_base_url}/topics/#{@topic_id}/member_metrics?metric=most_recent_activity", nil
      expect_status(200)
      expect_json_sizes("data", 2)
      expect_json_keys("data.*", [:id, :count, :is_member_max, :metric, :member, :topic])
      expect_json("data.0.member", username: @config.users[:regular_user2].username)
      expect_json("data.0.count", 1)
      expect_json("data.1.member", username: @config.users[:regular_user1].username)
      expect_json("data.1.count", 2)
      expect_json("data.*", metric: "most_recent_activity")
      expect_json("data.*.topic", id: @topic_id)

      # no member metric for most_liked_posts and most_featured_posts for now
      get "#{@api_base_url}/topics/#{@topic_id}/member_metrics?metric=most_liked_posts", nil
      expect_status(200)
      expect_json_sizes("data", 0)
      get "#{@api_base_url}/topics/#{@topic_id}/member_metrics?metric=most_featured_posts", nil
      expect_status(200)
      expect_json_sizes("data", 0)

      # question 1 created by user 1 is liked once
      post "#{@api_base_url}/questions/#{@question_1_obj.id}/like", nil, @config.user_headers(:regular_user2)
      expect_status(200)
      # question 3 created by user 2 is liked by three members
      post "#{@api_base_url}/questions/#{@question_3_obj.id}/like", nil, @config.user_headers(:network_admin)
      expect_status(200)
      post "#{@api_base_url}/questions/#{@question_3_obj.id}/like", nil, @config.user_headers(:regular_user1)
      expect_status(200)
      post "#{@api_base_url}/questions/#{@question_3_obj.id}/like", nil, @config.user_headers(:regular_user2)
      expect_status(200)

      # get member metric per most_liked_posts
      get "#{@api_base_url}/topics/#{@topic_id}/member_metrics?metric=most_liked_posts", nil
      expect_status(200)
      expect_json_sizes("data", 2)
      expect_json_keys("data.*", [:id, :count, :is_member_max, :metric, :member, :topic])
      expect_json("data.0.member", username: @config.users[:regular_user2].username)
      expect_json("data.0.count", 3)
      expect_json("data.1.member", username: @config.users[:regular_user1].username)
      expect_json("data.1.count", 1)
      expect_json("data.*", metric: "most_liked_posts")
      expect_json("data.*.topic", id: @topic_id)

      # create a reply for the question 1 created by user 1
      body = { html_content: "reply 1"}
      post "#{@api_base_url}/questions/#{@question_1_obj.id}/replies", body, @config.user_headers(:regular_user1)
      expect_status(201)
      reply_id = JSON.parse(response)['data']['id']

      # feature the three posts created by user 1
      post "#{@api_base_url}/replies/#{reply_id}/feature", nil, @config.user_headers(:network_admin)
      expect_status(200)
      post "#{@api_base_url}/questions/#{@question_1_obj.id}/feature", nil, @config.user_headers(:network_admin)
      expect_status(200)
      post "#{@api_base_url}/questions/#{@question_2_obj.id}/feature", nil, @config.user_headers(:network_admin)
      expect_status(200)

      # feature the only one question created by user 2
      post "#{@api_base_url}/questions/#{@question_3_obj.id}/feature", nil, @config.user_headers(:network_admin)
      expect_status(200)

      # get member metric per most_featured_posts
      get "#{@api_base_url}/topics/#{@topic_id}/member_metrics?metric=most_featured_posts", nil
      expect_status(200)
      expect_json_sizes("data", 2)
      expect_json_keys("data.*", [:id, :count, :is_member_max, :metric, :member, :topic])
      expect_json("data.0.member", username: @config.users[:regular_user1].username)
      expect_json("data.0.count", 3)
      expect_json("data.1.member", username: @config.users[:regular_user2].username)
      expect_json("data.1.count", 1)
      expect_json("data.*", metric: "most_featured_posts")
      expect_json("data.*.topic", id: @topic_id)

      get "#{@api_base_url}/topics/#{@topic_id}/member_metrics?metric=most_posts", nil
      expect_status(200)
      expect_json_sizes("data", 2)
      expect_json("data.0.count", 3)
    end
    
    after(:each) do
      if !@topic_id.nil?
        delete "#{@api_base_url}/topics/#{@topic_id}", nil, @config.user_headers(:network_admin)
        expect_status(200)
      end
    end  
  end 
end