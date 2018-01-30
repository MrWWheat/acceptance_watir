
# helper module for preparing data before execute api test cases
module APIV2TestDataBuilder
  def delete_all_reviews_in_topic(topic_id, api_url, headers)
    response = get "#{api_url}/topics/#{topic_id}/reviews", headers

    if (response.code == 200) # 200 means there are existing reviews.
      JSON.parse(response)["data"].each { |r|
        existing_review_id = r["id"]
        delete "#{api_url}/reviews/#{existing_review_id}", nil, headers
        expect_status(200)
      }
    end
  end

  def create_review_in_topic(topic_id, api_url, headers)
    review_title = "review_apitest_" + Time.now.to_s
    review_html_content = "<p>#{review_title}</p>"
    body = {"title": review_title, "html_content": review_html_content, "rating": 5,"recommended": true}
    response = post "#{api_url}/topics/#{topic_id}/reviews", body, headers
    expect_status(201)

    review_id = JSON.parse(response)["data"]["id"]

    Review.new(review_id, review_title, review_html_content)
  end

  def create_question_in_topic(topic_id, api_url, headers)
    # create a new question
    q_title = "q_apitest_" + Time.now.to_s
    html_content = "<p>#{q_title}</p>"
    body = {"title": q_title, "html_content": html_content}
    response = post "#{api_url}/topics/#{topic_id}/questions", body, headers
    expect_status(201)

    question_id = JSON.parse(response)["data"]["id"]

    Question.new(question_id, q_title, html_content)
  end

  def create_conversation_in_topic(type, topic_id, api_url, headers)
    title = "API_V2_test_for_#{type}_#{Time.now.to_i}"
    content = "<p>#{title}</p>"
    body = {"title": title, "html_content": content}
    response = post "#{api_url}/topics/#{topic_id}/#{type}s", body, headers
    expect_status(201)
    conversation_id = JSON.parse(response)["data"]["id"]
    { "id": conversation_id, "title": title, "content": content }
  end

  def create_reply_post(html_content, parent_post_id, api_url, headers)
    body = {"html_content": html_content}
    response = post "#{@api_url}/posts/#{parent_post_id}/post", body, headers
    expect_status(201)

    post_id = JSON.parse(response)["d"]["results"]["Id"]
  end

  def create_reply_in_blog(blog_id, api_url, headers)
    html_content = "<p>html content #{Time.now.to_s}</p>"
    body = {"html_content": html_content}
    response = post "#{api_url}/blogs/#{blog_id}/replies", body, headers
    expect_status(201)
    expect_json('data.is_featured', false)
    expect_json('data.likes_count', 0)

    reply_id = JSON.parse(response)["data"]["id"]
    parent_id = JSON.parse(response)["data"]["parent_id"]
    Reply.new(reply_id, parent_id, html_content)
  end

  # # create a reply post in a conversation
  # def create_post_in_conversation(content, parent_post_id, api_url, headers)
  #   body = {"d":{"HtmlContent":"<div class=input><p>#{content}</p></div>"}}
  #   response = post "#{@api_url}/Posts('#{parent_post_id}')/Posts", body, headers
  #   expect_status(201)

  #   post_id = JSON.parse(response)["d"]["results"]["Id"]
  # end

  # def vote_question(vote_option, conversation_id, api_url, headers)
  #   if vote_option == :up
  #     body = {d: {VoteResult: "up"}}
  #   elsif vote_option == :down
  #     body = {d: {VoteResult: "down"}}
  #   else
  #     raise "Invalid vote option: #{vote_option}!"
  #   end
  #   response = post "#{api_url}/Conversations('#{conversation_id}')/Votes", body, headers
  #   expect_status(201)
  #   # expect_json("d.results", VoteResult: 1)

  #   vote_id = JSON.parse(response)["d"]["results"]["Id"]
  # end

  class Question
    attr_reader :id, :title, :html_content

    def initialize(id, title, html_content)
      @id = id
      @title = title
      @html_content = html_content
    end
  end

  class Review
    attr_reader :id, :title, :html_content

    def initialize(id, title, html_content)
      @id = id
      @title = title
      @html_content = html_content
    end
  end

  class Reply
    attr_reader :id, :parent_id, :html_content

    def initialize(id, parent_id, html_content)
      @id = id
      @parent_id = parent_id
      @html_content = html_content
    end
  end
end
