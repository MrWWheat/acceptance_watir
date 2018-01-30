require 'airborne'
require_relative '../api_test_config'
require_relative '../helper/api_v2_test_data_builder'

attachment_id = ""
attachment_url = ""
attachment_filename = "test.png"
attachment_review_id = ""

describe 'Review API' do
  puts 'Review APIs'
  include APIV2TestDataBuilder

  before(:all) {
    @config = APITestConfig.new
    @api_url = '/api/v2'

    # @review_id_get = @config.api_data["review_id_get"]
    @topic_id = @config.api_data['topic_id_get']

    @headers = {:Authorization => "Bearer #{@config.access_token}", 
                :Accept => "application/json", 
                :content_type => "application/json", 
                :verify_ssl => false}

    # delete all existing reviews by admin user
    delete_all_reviews_in_topic(@topic_id, @api_url, @headers)

    # create a review before test the following api
    review_obj = create_review_in_topic(@topic_id, @api_url, @headers)

    @review_id = review_obj.id
    @review_title = review_obj.title
    @review_html_content = review_obj.html_content

    @user_1_headers = {:Authorization => "Bearer #{@config.get_access_token_by_user(:regular_user1)}",
                       :Accept => "application/json", 
                       :content_type => "application/json", 
                       :verify_ssl => false}
    @user_2_headers = {:Authorization => "Bearer #{@config.get_access_token_by_user(:regular_user2)}",
                       :Accept => "application/json", 
                       :content_type => "application/json", 
                       :verify_ssl => false}

    # create another review in the topic by another user
    sleep 1 # so as to create a new review with different creation date as before
    review_2_obj = create_review_in_topic(@topic_id, @api_url, @user_1_headers) 

    @review_2_id = review_2_obj.id
    @review_2_title = review_2_obj.title
    @review_2_html_content = review_2_obj.html_content
  }

  after(:all) {

  }

  # Test these APIs:
  # => [GET] /reviews
  it 'should get all reviews' do
    response = get "#{@api_url}/reviews?_order={\"is_featured\":\"desc\",\"updated_at\":\"desc\"}&_page=1&_per_page=5", @headers
    expect_status(200)
    expect_json_keys('data.*', [:id, :title, :html_content, :is_featured])

    # all reviews are returned in reverse date order
    # # reviews_count = JSON.parse(response)["data"].size
    # comment the verification below because it will conflict with other cases
    # expect_json("data.1", id: @review_id, title: @review_title, html_content: @review_html_content) 
    # expect_json("data.0", id: @review_2_id, title: @review_2_title, html_content: @review_2_html_content) 
  end  

  # Test these APIs:
  # => [GET] /reviews/{id}
  # => [PUT] /reviews/{id}
  # => [PATCH] /reviews/{id}
  it 'should get/update a specific review' do
    get "#{@api_url}/reviews/#{@review_id}", @headers
    expect_status(200)
    expect_json_keys('data', [:id, :title, :html_content, :is_featured, :is_closed, 
                              :is_visible, :like_count, :follow_count, :reply_count])
    expect_json("data", id: @review_id, title: @review_title, html_content: @review_html_content, recommended: true, purchased: false, rating: 5)

    review_title_new = @review_title + "-edit"
    review_html_content_new = "<p>#{review_title_new}</p>"

    body = {title: review_title_new, html_content: review_html_content_new, recommended: "false", rating: 4}
    put "#{@api_url}/reviews/#{@review_id}", body, @headers
    expect_status(200)
    expect_json("data", id: @review_id, title: review_title_new, html_content: review_html_content_new, recommended: false, rating: 4)

    # TODO: EN-2518, EN-2519
    body = {title: @review_title, html_content: @review_html_content, recommended: true, rating: 5}
    patch "#{@api_url}/reviews/#{@review_id}", body, @headers
    expect_status(200)

    expect_json("data", id: @review_id, title: @review_title, html_content: @review_html_content, recommended: true, rating: 5)

    # PATCH can only change the specify properties, but PUT need to change all the required properties
    body = {title: review_title_new}
    patch "#{@api_url}/reviews/#{@review_id}", body, @headers
    expect_status(200)

    expect_json("data", id: @review_id, title: review_title_new, html_content: @review_html_content, recommended: true, rating: 5)
  end 

  # Test these APIs:
  # => [POST] /reviews/{id}/replies
  # => [POST] /replies/{id}/replies
  # => [GET] /reviews/{id}/replies
  it 'should create/get replies for a review' do
    # create a reply for the review
    body = { html_content: "reply 1"}
    response = post "#{@api_url}/reviews/#{@review_id}/replies", body, @headers
    expect_status(201)
    expect_json_keys('data', [:id, :parent_id, :last_three_child_replies, :more_child_replies_link])

    reply1_id = JSON.parse(response)["data"]["id"]
    reply1_parent_id = JSON.parse(response)["data"]["parent_id"]

    # create four child replies for the new reply
    body = { html_content: "reply 1.1" }
    response = post "#{@api_url}/replies/#{reply1_id}/child_replies", body, @headers
    expect_status(201)

    reply1_1_id = JSON.parse(response)["data"]["id"]

    body = { html_content: "reply 1.2" }
    response = post "#{@api_url}/replies/#{reply1_id}/child_replies", body, @headers
    expect_status(201)

    reply1_2_id = JSON.parse(response)["data"]["id"]

    body = { html_content: "reply 1.3" }
    response = post "#{@api_url}/replies/#{reply1_id}/child_replies", body, @headers
    expect_status(201)

    reply1_3_id = JSON.parse(response)["data"]["id"]

    body = { html_content: "reply 1.4" }
    response = post "#{@api_url}/replies/#{reply1_id}/child_replies", body, @headers
    expect_status(201)

    reply1_4_id = JSON.parse(response)["data"]["id"]

    # create another reply for the review
    body = { html_content: "reply 2" }
    response = post "#{@api_url}/reviews/#{@review_id}/replies", body, @headers
    expect_status(201)

    reply2_id = JSON.parse(response)["data"]["id"]
    reply2_parent_id = JSON.parse(response)["data"]["parent_id"]

    response = get "#{@api_url}/reviews/#{@review_id}/replies", @headers
    expect_status(200)
    expect_json('metadata.pagination', total_pages: 1, total_count: 2)
    expect_json_keys('data.*', [:id, :parent_id, :html_content, :last_three_child_replies, :more_child_replies_link])
    expect_json('data.0', id: reply1_id, parent_id: reply1_parent_id)
    expect_json('data.1', id: reply2_id, parent_id: reply2_parent_id)
    expect_json_sizes("data.0.last_three_child_replies", 3)
    expect_json('data.0.last_three_child_replies.0', id: reply1_2_id, parent_id: reply1_id)
    expect_json('data.0.last_three_child_replies.1', id: reply1_3_id, parent_id: reply1_id)
    expect_json('data.0.last_three_child_replies.2', id: reply1_4_id, parent_id: reply1_id)
    expect_json_sizes("data.1.last_three_child_replies", 0)
  end  

  # Test these APIs:
  # => [POST] /reviews/{id}/close
  # => [POST] /reviews/{id}/reopen
  it 'should close/reopen a specific review' do
    post "#{@api_url}/reviews/#{@review_id}/close", nil, @headers
    expect_status(200)
    expect_json_keys('data', [:id, :title, :html_content, :is_closed])
    expect_json("data", id: @review_id, is_closed: true)

    post "#{@api_url}/reviews/#{@review_id}/reopen", nil, @headers
    expect_status(200)
    expect_json_keys('data', [:id, :title, :html_content, :is_closed])
    expect_json("data", id: @review_id, is_closed: false)
  end
  
  # Test these APIs:
  # => [POST] /reviews/{id}/helpful
  # => [POST] /reviews/{id}/not_helpful
  it 'should mark a specific review as helpful/not helpful' do
    post "#{@api_url}/reviews/#{@review_id}/helpful", nil, @user_1_headers
    expect_status(200)
    expect_json_keys('data', [:id, :title, :html_content, :helpful_count, :not_helpful_count])
    expect_json("data", id: @review_id, helpful_count: 1)


    post "#{@api_url}/reviews/#{@review_id}/helpful", nil, @user_2_headers
    expect_status(200)
    expect_json_keys('data', [:id, :title, :html_content, :helpful_count, :not_helpful_count])
    expect_json("data", id: @review_id, helpful_count: 2)

    post "#{@api_url}/reviews/#{@review_id}/not_helpful", nil, @user_1_headers
    expect_status(200)
    expect_json_keys('data', [:id, :title, :html_content, :helpful_count, :not_helpful_count])
    expect_json("data", id: @review_id, helpful_count: 2, not_helpful_count: 1)
  end

  # Test these APIs:
  # => [POST] /reviews/{id}/escalate
  # => [POST] /reviews/{id}/deescalate
  it 'should deescalate/escalate a specific review' do
    # can't escalate by other non-admin user
    post "#{@api_url}/reviews/#{@review_id}/escalate", nil, @user_2_headers
    expect_status(403)
    expect_json(status: 403, code: "ERR_FORBIDDEN", message: "insufficient permissions")

    # can escalate by himself
    post "#{@api_url}/reviews/#{@review_id}/escalate", nil, @headers
    expect_status(200)    
    expect_json("data", id: @review_id, moderation_status: "moderation_status_escalated")
    expect_json(status: 200, code: "OK_RESOURCE_UPDATED", message: "resource updated")
    expect_json_keys('data', [:id, :title, :html_content, :is_featured, :is_closed, 
                              :is_visible, :like_count, :follow_count, :reply_count])

    # can't deescalate by other non-admin user
    post "#{@api_url}/reviews/#{@review_id}/deescalate", nil, @user_2_headers
    expect_status(403)
    expect_json(status: 403, code: "ERR_FORBIDDEN", message: "insufficient permissions")

    # can deescalate by himself
    post "#{@api_url}/reviews/#{@review_id}/deescalate", nil, @headers
    expect_status(200)

    expect_json("data", id: @review_id, moderation_status: "moderation_status_clear")
    expect_json(status: 200, code: "OK_RESOURCE_UPDATED", message: "resource updated")
    expect_json_keys('data', [:id, :title, :html_content, :is_featured, :is_closed, 
                              :is_visible, :like_count, :follow_count, :reply_count])
  end

  # Test these APIs:
  # => [POST] /reviews/{id}/feature
  # => [POST] /reviews/{id}/unfeature
  it 'should feature/unfeature a specific review' do
    # can't feature by other non-admin user
    post "#{@api_url}/reviews/#{@review_id}/feature", nil, @user_2_headers
    expect_status(403)
    expect_json(status: 403, code: "ERR_FORBIDDEN", message: "insufficient permissions")

    # can feature by himself
    post "#{@api_url}/reviews/#{@review_id}/feature", nil, @headers
    expect_status(200)
    expect_json("data", id: @review_id, is_featured: true)
    expect_json(status: 200, code: "OK_RESOURCE_UPDATED", message: "resource updated")
    expect_json_keys('data', [:id, :title, :html_content, :is_featured, :is_closed, 
                              :is_visible, :like_count, :follow_count, :reply_count])

    # can't unfeature by other non-admin user 
    post "#{@api_url}/reviews/#{@review_id}/unfeature", nil, @user_2_headers
    expect_status(403)
    expect_json(status: 403, code: "ERR_FORBIDDEN", message: "insufficient permissions")

    # can unfeature by himself
    post "#{@api_url}/reviews/#{@review_id}/unfeature", nil, @headers
    expect_status(200)
    expect_json("data", id: @review_id, is_featured: false)
    expect_json(status: 200, code: "OK_RESOURCE_UPDATED", message: "resource updated")
    expect_json_keys('data', [:id, :title, :html_content, :is_featured, :is_closed, 
                              :is_visible, :like_count, :follow_count, :reply_count])
  end

  # Test these APIs:
  # => [POST] /reviews/{id}/flag
  # => [POST] /reviews/{id}/reinstate
  it 'should flag a specific review' do
    # flag by other non-admin user
    post "#{@api_url}/reviews/#{@review_id}/flag", nil, @user_2_headers
    expect_status(200)
    expect_json("data", id: @review_id)
    expect_json_keys('data', [:id, :title, :html_content, :is_featured, :is_closed, 
                              :is_visible, :like_count, :follow_count, :reply_count])

    # cannot reinstate by other non-admin users
    post "#{@api_url}/reviews/#{@review_id}/reinstate", nil, @user_2_headers
    expect_status(403)
    expect_json(status: 403, code: "ERR_FORBIDDEN", message: "insufficient permissions")

    # reinstate by himself
    post "#{@api_url}/reviews/#{@review_id}/reinstate", nil, @headers
    expect_status(200)
    expect_json("data", id: @review_id)
    expect_json_keys('data', [:id, :title, :html_content, :is_featured, :is_closed, 
                              :is_visible, :like_count, :follow_count, :reply_count])

    # cannot flag again
    post "#{@api_url}/reviews/#{@review_id}/flag", nil, @user_2_headers
    expect_status(400)
    expect_json(status: 400, code: "ERR_BAD_REQUEST", message: "The post cannot be flagged as it has been flagged by the same user or cleared by the moderator")
  end

  # Test these APIs:
  # => [POST] /reviews/{id}/follow
  # => [POST] /reviews/{id}/unfollow
  # Depend on these APIs:
  # => [GET] /reviews/{id}
  it 'should follow/unfollow a specific review' do
    get "#{@api_url}/reviews/#{@review_id}", @headers
    expect_status(200)
    original_follow_count = JSON.parse(response)["data"]["follow_count"]

    post "#{@api_url}/reviews/#{@review_id}/follow", nil, @headers
    expect_status(200)
    expect_json("data", id: @review_id, follow_count: original_follow_count) # no change

    post "#{@api_url}/reviews/#{@review_id}/follow", nil, @user_2_headers
    expect_status(200)
    expect_json("data", id: @review_id, follow_count: original_follow_count + 1)
    expect_json_keys('data', [:id, :title, :html_content, :is_featured, :is_closed, 
                              :is_visible, :like_count, :follow_count, :reply_count])

    post "#{@api_url}/reviews/#{@review_id}/unfollow", nil, @user_2_headers
    expect_status(200)
    expect_json("data", id: @review_id, follow_count: original_follow_count)
    expect_json_keys('data', [:id, :title, :html_content, :is_featured, :is_closed, 
                              :is_visible, :like_count, :follow_count, :reply_count])

    # unfollow by creator himself
    post "#{@api_url}/reviews/#{@review_id}/unfollow", nil, @headers
    expect_status(200)
    expect_json("data", id: @review_id, follow_count: original_follow_count - 1) 
  end

  # Test these APIs:
  # => [POST] /reviews/{id}/like
  # => [POST] /reviews/{id}/unlike
  it 'should like/unlike a specific review' do
    post "#{@api_url}/reviews/#{@review_id}/like", nil, @user_2_headers
    expect_status(200)
    expect_json("data", id: @review_id, like_count: 1)
    expect_json_keys('data', [:id, :title, :html_content, :is_featured, :is_closed, 
                              :is_visible, :like_count, :follow_count, :reply_count])

    post "#{@api_url}/reviews/#{@review_id}/unlike", nil, @user_2_headers
    expect_status(200)
    expect_json("data", id: @review_id, like_count: 0)
    expect_json_keys('data', [:id, :title, :html_content, :is_featured, :is_closed, 
                              :is_visible, :like_count, :follow_count, :reply_count])

    # like by creator
    post "#{@api_url}/reviews/#{@review_id}/like", nil, @headers
    expect_status(200)
    expect_json("data", id: @review_id, like_count: 1)
    expect_json_keys('data', [:id, :title, :html_content, :is_featured, :is_closed, 
                              :is_visible, :like_count, :follow_count, :reply_count])

    # unlike by creator
    post "#{@api_url}/reviews/#{@review_id}/unlike", nil, @headers
    expect_status(200)
    expect_json("data", id: @review_id, like_count: 0)
    expect_json_keys('data', [:id, :title, :html_content, :is_featured, :is_closed, 
                              :is_visible, :like_count, :follow_count, :reply_count])
  end 

  # Test these APIs:
  # => [DELETE] /reviews/{id} 


  it 'post an attachment in review' do
    # review = create_review_in_topic(@topic_id, @api_url, @headers)
    attachment_review_id = @review_id
    body = {:multipart => true, :filename => attachment_filename, :file => File.new(@config.data_dir + '/test.png', "rb")}
    response = post "#{@api_url}/reviews/#{attachment_review_id}/attachments", body, @headers
    expect_status(201)
    expect_json("code", "OK_RESOURCE_CREATED")
    expect_json_keys('data', [:id, :filename, :url, :filesize])
    data = JSON.parse(response)["data"]
    attachment_id = data["id"]
    attachment_url = data["url"]
    #a issue found
    attachment_filename = data["filename"]
  end

  it 'get an attachment in review' do
    response = get "#{@api_url}/reviews/#{attachment_review_id}/attachments", @headers
    expect_status(200)
    expect_json("code", "OK_RESOURCE_FETCHED")
    expect_json_keys('data.*', [:id, :filename, :url, :filesize])
    expect_json("data.*.id", attachment_id)
    expect_json("data.*.url", attachment_url)
    expect_json("data.*.filename", attachment_filename)
  end

  it 'delete an attachment in review' do
    response = delete "#{@api_url}/reviews/#{attachment_review_id}/attachments", {}, @headers
    expect_status(200)
    expect_json("code", "OK_RESOURCE_DELETED")
    response = get "#{@api_url}/reviews/#{attachment_review_id}/attachments", @headers
    data = JSON.parse(response)["data"]
    expect(data.size).to be 0
  end

  it 'should delete existing reviews' do
    # delete the review
    delete "#{@api_url}/reviews/#{@review_id}", nil, @headers
    expect_status(200)
    expect_json(status: 200, code: "OK_RESOURCE_DELETED", message: "resource deleted")

    # EN-2523: Admin cannot delete reviews created by others
    delete "#{@api_url}/reviews/#{@review_2_id}", nil, @user_1_headers
    expect_status(200)
  end 
end
