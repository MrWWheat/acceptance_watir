require 'airborne'
require_relative '../api_test_config'
require_relative '../helper/api_v2_test_data_builder'

attachment_id = ""
attachment_url = ""
attachment_filename = "test.png"
attachment_question_id = ""

describe 'Question API' do
  puts 'Question APIs v2'
  include APIV2TestDataBuilder

  before(:all) {
    @config = APITestConfig.new
    @api_url = '/api/v2'

    @topic_id_get = @config.api_data['topic_id_get']

    @headers = {:Authorization => "Bearer #{@config.access_token}", 
                :Accept => "application/json", 
                :content_type => "application/json", 
                :verify_ssl => false}        

    # create a question before test the following api
    question_obj = create_question_in_topic(@topic_id_get, @api_url, @headers)


    @question_id = question_obj.id
    @question_title = question_obj.title
    @question_html = question_obj.html_content

    @user_1_headers = {:Authorization => "Bearer #{@config.get_access_token_by_user(:regular_user1)}",
                       :Accept => "application/json", 
                       :content_type => "application/json", 
                       :verify_ssl => false}

    @user_2_headers = {:Authorization => "Bearer #{@config.get_access_token_by_user(:regular_user2)}",
                       :Accept => "application/json", 
                       :content_type => "application/json", 
                       :verify_ssl => false}               
  }

  after(:all) {
    # # delete the question
    # delete "#{@api_url}/questions/#{@question_id}", nil, @headers
    # expect_status(200)
  }

  # Test these APIs:
  # => [GET] /questions
  it 'should get all questions' do
    response = get "#{@api_url}/questions?_order={\"is_featured\":\"desc\",\"updated_at\":\"desc\"}&_page=1&_per_page=5", nil
    expect_status(200)
    expect_json_keys('data.*', [:id, :title, :html_content, :is_featured])
    expect_json(code: "OK_RESOURCE_FETCHED", message: "resource fetched")
    expect_json('metadata.pagination', page: 1, per_page: 5)
    expect_json('metadata.order', is_featured: "desc", updated_at: "desc")

    expect(JSON.parse(response)["data"].size).to be >= 1
  end  

  # Test these APIs:
  # => [GET] /questions/{id}
  # => [PATCH] /questions/{id}
  it 'should get/patch a specific question' do
    response = get "#{@api_url}/questions/#{@question_id}", nil
    expect_status(200)
    expect_json("data", id: @question_id, title: @question_title, html_content: @question_html)
    expect_json(status: 200, code: "OK_RESOURCE_FETCHED", message: "resource fetched")
    expect_json_keys('data', [:id, :title, :html_content, :is_featured, :is_closed, 
                              :is_visible, :like_count, :follow_count, :reply_count])

    q_title_new = @question_title + "-edit"
    q_html_content_new = @question_html + "-edit"
    body = {"title": q_title_new, "html_content": q_html_content_new}
    response = patch "#{@api_url}/questions/#{@question_id}", body, @headers
    expect_status(200)
    expect_json(status: 200, code: "OK_RESOURCE_UPDATED", message: "resource updated")
    expect_json("data", id: @question_id, title: q_title_new, html_content: q_html_content_new)
  end

  # Test these APIs:
  # => [POST] /questions/{id}/close
  # => [POST] /questions/{id}/reopen
  it 'should close/reopen a specific question' do
    # can't closed by other non-admin users
    post "#{@api_url}/questions/#{@question_id}/close", nil, @user_2_headers
    expect_status(403)
    expect_json(status: 403, code: "ERR_FORBIDDEN", message: "insufficient permissions")

    post "#{@api_url}/questions/#{@question_id}/close", nil, @headers
    expect_status(200)
    expect_json("data", id: @question_id, is_closed: true)
    expect_json(status: 200, code: "OK_RESOURCE_UPDATED", message: "resource updated")
    expect_json_keys('data', [:id, :title, :html_content, :is_featured, :is_closed, 
                              :is_visible, :like_count, :follow_count, :reply_count])

    # can't reopen by other non-admin users
    post "#{@api_url}/questions/#{@question_id}/reopen", nil, @user_2_headers
    expect_status(403)
    expect_json(status: 403, code: "ERR_FORBIDDEN", message: "insufficient permissions")

    post "#{@api_url}/questions/#{@question_id}/reopen", nil, @headers
    expect_status(200)
    expect_json("data", id: @question_id, is_closed: false)
    expect_json(status: 200, code: "OK_RESOURCE_UPDATED", message: "resource updated")
    expect_json_keys('data', [:id, :title, :html_content, :is_featured, :is_closed, 
                              :is_visible, :like_count, :follow_count, :reply_count])
  end

  # Test these APIs:
  # => [POST] /questions/{id}/escalate
  # => [POST] /questions/{id}/deescalate
  it 'should deescalate/escalate a specific question' do
    # can't escalate by other non-admin user
    post "#{@api_url}/questions/#{@question_id}/escalate", nil, @user_2_headers
    expect_status(403)
    expect_json(status: 403, code: "ERR_FORBIDDEN", message: "insufficient permissions")

    # can escalate by himself
    post "#{@api_url}/questions/#{@question_id}/escalate", nil, @headers
    expect_status(200)    
    expect_json("data", id: @question_id, moderation_status: "moderation_status_escalated")
    expect_json(status: 200, code: "OK_RESOURCE_UPDATED", message: "resource updated")
    expect_json_keys('data', [:id, :title, :html_content, :is_featured, :is_closed, 
                              :is_visible, :like_count, :follow_count, :reply_count])

    # can't deescalate by other non-admin user
    post "#{@api_url}/questions/#{@question_id}/deescalate", nil, @user_2_headers
    expect_status(403)
    expect_json(status: 403, code: "ERR_FORBIDDEN", message: "insufficient permissions")

    # can deescalate by himself
    post "#{@api_url}/questions/#{@question_id}/deescalate", nil, @headers
    expect_status(200)

    expect_json("data", id: @question_id, moderation_status: "moderation_status_clear")
    expect_json(status: 200, code: "OK_RESOURCE_UPDATED", message: "resource updated")
    expect_json_keys('data', [:id, :title, :html_content, :is_featured, :is_closed, 
                              :is_visible, :like_count, :follow_count, :reply_count])
  end

  # Test these APIs:
  # => [POST] /questions/{id}/feature
  # => [POST] /questions/{id}/unfeature
  it 'should feature/unfeature a specific question' do
    # can't feature by other non-admin user
    post "#{@api_url}/questions/#{@question_id}/feature", nil, @user_2_headers
    expect_status(403)
    expect_json(status: 403, code: "ERR_FORBIDDEN", message: "insufficient permissions")

    # can feature by himself
    post "#{@api_url}/questions/#{@question_id}/feature", nil, @headers
    expect_status(200)
    expect_json("data", id: @question_id, is_featured: true)
    expect_json(status: 200, code: "OK_RESOURCE_UPDATED", message: "resource updated")
    expect_json_keys('data', [:id, :title, :html_content, :is_featured, :is_closed, 
                              :is_visible, :like_count, :follow_count, :reply_count])

    # can't unfeature by other non-admin user 
    post "#{@api_url}/questions/#{@question_id}/unfeature", nil, @user_2_headers
    expect_status(403)
    expect_json(status: 403, code: "ERR_FORBIDDEN", message: "insufficient permissions")

    # can unfeature by himself
    post "#{@api_url}/questions/#{@question_id}/unfeature", nil, @headers
    expect_status(200)
    expect_json("data", id: @question_id, is_featured: false)
    expect_json(status: 200, code: "OK_RESOURCE_UPDATED", message: "resource updated")
    expect_json_keys('data', [:id, :title, :html_content, :is_featured, :is_closed, 
                              :is_visible, :like_count, :follow_count, :reply_count])
  end

  # Test these APIs:
  # => [POST] /questions/{id}/flag
  # => [POST] /questions/{id}/reinstate
  it 'should flag a specific question' do
    # flag by other non-admin user
    post "#{@api_url}/questions/#{@question_id}/flag", nil, @user_2_headers
    expect_status(200)
    expect_json("data", id: @question_id)
    expect_json_keys('data', [:id, :title, :html_content, :is_featured, :is_closed, 
                              :is_visible, :like_count, :follow_count, :reply_count])

    # cannot reinstate by other non-admin users
    post "#{@api_url}/questions/#{@question_id}/reinstate", nil, @user_2_headers
    expect_status(403)
    expect_json(status: 403, code: "ERR_FORBIDDEN", message: "insufficient permissions")

    # reinstate by himself
    post "#{@api_url}/questions/#{@question_id}/reinstate", nil, @headers
    expect_status(200)
    expect_json("data", id: @question_id)
    expect_json_keys('data', [:id, :title, :html_content, :is_featured, :is_closed, 
                              :is_visible, :like_count, :follow_count, :reply_count])

    # cannot flag again
    post "#{@api_url}/questions/#{@question_id}/flag", nil, @user_2_headers
    expect_status(400)
    expect_json(status: 400, code: "ERR_BAD_REQUEST", message: "The post cannot be flagged as it has been flagged by the same user or cleared by the moderator")
  end

  # Test these APIs:
  # => [POST] /questions/{id}/follow
  # => [POST] /questions/{id}/unfollow
  it 'should follow/unfollow a specific question' do
    post "#{@api_url}/questions/#{@question_id}/follow", nil, @headers
    expect_status(200)
    expect_json("data", id: @question_id, follow_count: 1) # no change

    post "#{@api_url}/questions/#{@question_id}/follow", nil, @user_2_headers
    expect_status(200)
    expect_json("data", id: @question_id, follow_count: 2)
    expect_json_keys('data', [:id, :title, :html_content, :is_featured, :is_closed, 
                              :is_visible, :like_count, :follow_count, :reply_count])

    post "#{@api_url}/questions/#{@question_id}/unfollow", nil, @user_2_headers
    expect_status(200)
    expect_json("data", id: @question_id, follow_count: 1)
    expect_json_keys('data', [:id, :title, :html_content, :is_featured, :is_closed, 
                              :is_visible, :like_count, :follow_count, :reply_count])

    post "#{@api_url}/questions/#{@question_id}/unfollow", nil, @headers
    expect_status(200)
    expect_json("data", id: @question_id, follow_count: 0)
  end

  # Test these APIs:
  # => [POST] /questions/{id}/like
  # => [POST] /questions/{id}/unlike
  it 'should like/unlike a specific question' do
    post "#{@api_url}/questions/#{@question_id}/like", nil, @user_2_headers
    expect_status(200)
    expect_json("data", id: @question_id, like_count: 1)
    expect_json_keys('data', [:id, :title, :html_content, :is_featured, :is_closed, 
                              :is_visible, :like_count, :follow_count, :reply_count])

    post "#{@api_url}/questions/#{@question_id}/unlike", nil, @user_2_headers
    expect_status(200)
    expect_json("data", id: @question_id, like_count: 0)
    expect_json_keys('data', [:id, :title, :html_content, :is_featured, :is_closed, 
                              :is_visible, :like_count, :follow_count, :reply_count])

    # like by creator
    post "#{@api_url}/questions/#{@question_id}/like", nil, @headers
    expect_status(200)
    expect_json("data", id: @question_id, like_count: 1)
    expect_json_keys('data', [:id, :title, :html_content, :is_featured, :is_closed, 
                              :is_visible, :like_count, :follow_count, :reply_count])

    # unlike by creator himself
    post "#{@api_url}/questions/#{@question_id}/unlike", nil, @headers
    expect_status(200)
    expect_json("data", id: @question_id, like_count: 0)
    expect_json_keys('data', [:id, :title, :html_content, :is_featured, :is_closed, 
                              :is_visible, :like_count, :follow_count, :reply_count])
  end 

  # Test these APIs:
  # => [POST] /questions/{id}/replies
  # => [POST] /replies/{id}/replies
  # => [GET] /questions/{id}/replies
  it 'should create/get a replies' do
    # create a reply for the question
    body = { html_content: "reply 1"}
    response = post "#{@api_url}/questions/#{@question_id}/replies", body, @headers
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

    # create a reply for the new reply
    body = { html_content: "reply 1.3" }
    response = post "#{@api_url}/replies/#{reply1_id}/child_replies", body, @headers
    expect_status(201)

    reply1_3_id = JSON.parse(response)["data"]["id"]

    # create a reply for the new reply
    body = { html_content: "reply 1.4" }
    response = post "#{@api_url}/replies/#{reply1_id}/child_replies", body, @headers
    expect_status(201)

    reply1_4_id = JSON.parse(response)["data"]["id"]

    # create another reply for the question
    body = { html_content: "reply 2" }
    response = post "#{@api_url}/questions/#{@question_id}/replies", body, @headers
    expect_status(201)

    reply2_id = JSON.parse(response)["data"]["id"]
    reply2_parent_id = JSON.parse(response)["data"]["parent_id"]

    response = get "#{@api_url}/questions/#{@question_id}/replies", @user_2_headers
    expect_status(200)
    expect_json('metadata.pagination', page: 1, per_page: 12, total_pages: 1, total_count: 2)
    expect_json_keys('data.*', [:id, :parent_id, :html_content, :last_three_child_replies])
    expect_json('data.0', id: reply1_id, parent_id: reply1_parent_id, html_content: "reply 1")
    expect_json('data.1', id: reply2_id, parent_id: reply2_parent_id, html_content: "reply 2")
    expect_json_sizes("data.0.last_three_child_replies", 3)
    expect_json('data.0.last_three_child_replies.0', id: reply1_2_id, parent_id: reply1_id)
    expect_json('data.0.last_three_child_replies.1', id: reply1_3_id, parent_id: reply1_id)
    expect_json('data.0.last_three_child_replies.2', id: reply1_4_id, parent_id: reply1_id)
    expect_json_sizes("data.1.last_three_child_replies", 0)

    # test the _extends works
    response = get "#{@api_url}/questions/#{@question_id}/replies?_extends=%5B%22conversation%22%5D", @user_2_headers
    expect_status(200)
    expect_json('metadata.extends.0', "conversation")
    expect_json_keys('data.*', [:id, :parent_id, :html_content, :last_three_child_replies, :_conversation])
  end

  # Test these APIs:
  # => [GET] /questions/{id}/best_answer
  # => [GET] /questions/{id}/non_best_answer
  # Depend on these APIs:
  # => [GET] /questions/{id}/replies
  # => [GET] /replies/{id}/child_replies
  it 'should get best answers for a specific question' do
    response = get "#{@api_url}/questions/#{@question_id}/replies", @headers
    expect_status(200)

    reply1_id = JSON.parse(response)["data"][0]["id"]
    reply1_parent_id = JSON.parse(response)["data"][0]["parent_id"]
    reply2_id = JSON.parse(response)["data"][1]["id"]
    reply2_parent_id = JSON.parse(response)["data"][1]["parent_id"]

    response = get "#{@api_url}/replies/#{reply1_id}/child_replies", @headers

    reply1_1_id = JSON.parse(response)["data"][0]["id"]
    reply1_2_id = JSON.parse(response)["data"][1]["id"]
    reply1_3_id = JSON.parse(response)["data"][2]["id"]
    reply1_4_id = JSON.parse(response)["data"][3]["id"]

    response = post "#{@api_url}/replies/#{reply1_id}/feature", nil, @headers
    expect_status(200)

    response = get "#{@api_url}/questions/#{@question_id}/best_answer", @user_2_headers
    expect_status(200)
    expect_json_keys('data.*', [:id, :parent_id, :html_content, :last_three_child_replies])
    expect_json('data.0', id: reply1_id, parent_id: reply1_parent_id)
    expect_json_sizes("data", 1) 

    # it will return all replies and their child replies
    response = get "#{@api_url}/questions/#{@question_id}/non_best_answers", @user_2_headers
    expect_status(200)
    expect_json_keys('data.*', [:id, :parent_id, :html_content])
    expect_json_sizes("data", 5) 
    expect_json('data.0', id: reply1_1_id, parent_id: reply1_id)
    expect_json('data.1', id: reply1_2_id, parent_id: reply1_id)
    expect_json('data.2', id: reply1_3_id, parent_id: reply1_id)
    expect_json('data.3', id: reply1_4_id, parent_id: reply1_id)
    expect_json('data.4', id: reply2_id, parent_id: reply2_parent_id)
  end

  # Test these APIs:
  # => [PATCH] /questions/{id}
  # => [POST] /questions/{id}/close
  # => [POST] /questions/{id}/reopen
  # => [POST] /questions/{id}/escalate
  # => [POST] /questions/{id}/deescalate
  # => [POST] /questions/{id}/feature
  # => [POST] /questions/{id}/unfeature
  # => [POST] /questions/{id}/flag
  # => [POST] /questions/{id}/reinstate
  # => [POST] /questions/{id}/follow
  # => [POST] /questions/{id}/unfollow
  # => [POST] /questions/{id}/like
  # => [POST] /questions/{id}/unlike
  # => [POST] /questions/{id}/replies
  it 'cannot post or patch by anonymous user' do
    # body = {"title": "test", "html_content": "test"}
    patch "#{@api_url}/questions/#{@question_id}", nil, nil
    expect_status(403)
    expect_json(status: 403, code: "ERR_FORBIDDEN", message: "insufficient permissions")

    post "#{@api_url}/questions/#{@question_id}/close", nil, nil
    expect_status(403)

    post "#{@api_url}/questions/#{@question_id}/reopen", nil, nil
    expect_status(403)

    post "#{@api_url}/questions/#{@question_id}/escalate", nil, nil
    expect_status(403)

    post "#{@api_url}/questions/#{@question_id}/deescalate", nil, nil
    expect_status(403)

    post "#{@api_url}/questions/#{@question_id}/feature", nil, nil
    expect_status(403)

    post "#{@api_url}/questions/#{@question_id}/unfeature", nil, nil
    expect_status(403)

    post "#{@api_url}/questions/#{@question_id}/flag", nil, nil
    expect_status(403)

    post "#{@api_url}/questions/#{@question_id}/reinstate", nil, nil
    expect_status(403)

    post "#{@api_url}/questions/#{@question_id}/follow", nil, nil
    expect_status(403)

    post "#{@api_url}/questions/#{@question_id}/unfollow", nil, nil
    expect_status(403)

    post "#{@api_url}/questions/#{@question_id}/like", nil, nil
    expect_status(403)

    post "#{@api_url}/questions/#{@question_id}/unlike", nil, nil
    expect_status(403)

    body = { html_content: "reply 1"}
    post "#{@api_url}/questions/#{@question_id}/replies", body, nil
    expect_status(403)

    delete "#{@api_url}/questions/#{@question_id}", nil, nil
    expect_status(403)
  end  

  # Test these APIs:
  # => [DELETE] /questions/{id}
  it 'should delete a specific question' do
  	# delete the question
    delete "#{@api_url}/questions/#{@question_id}", nil, @headers
    expect_status(200)
  end

  it 'post an attachment in question' do
    question = create_conversation_in_topic("question", @topic_id_get, @api_url, @headers)
    attachment_question_id = question[:id]
    body = {:multipart => true, :filename => attachment_filename, :file => File.new(@config.data_dir + '/test.png', "rb")}
    response = post "#{@api_url}/questions/#{attachment_question_id}/attachments", body, @headers
    expect_status(201)
    expect_json("code", "OK_RESOURCE_CREATED")
    expect_json_keys('data', [:id, :filename, :url, :filesize])
    data = JSON.parse(response)["data"]
    attachment_id = data["id"]
    attachment_url = data["url"]
    #a issue found
    attachment_filename = data["filename"]
  end

  it 'get an attachment in question' do
    response = get "#{@api_url}/questions/#{attachment_question_id}/attachments", @headers
    expect_status(200)
    expect_json("code", "OK_RESOURCE_FETCHED")
    expect_json_keys('data.*', [:id, :filename, :url, :filesize])
    expect_json("data.*.id", attachment_id)
    expect_json("data.*.url", attachment_url)
    expect_json("data.*.filename", attachment_filename)
  end

  it 'delete an attachment in question' do
    response = delete "#{@api_url}/questions/#{attachment_question_id}/attachments", {}, @headers
    expect_status(200)
    expect_json("code", "OK_RESOURCE_DELETED")
    response = get "#{@api_url}/questions/#{attachment_question_id}/attachments", @headers
    data = JSON.parse(response)["data"]
    expect(data.size).to be 0
  end
end  