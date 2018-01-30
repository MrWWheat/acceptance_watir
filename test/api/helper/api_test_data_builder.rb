
# helper module for preparing data before execute api test cases
module APITestDataBuilder
  def delete_all_reviews_in_topic(topic_id, api_url, headers)
    response = get "#{api_url}/Topics('#{topic_id}')/Reviews", headers
    
    if (response.code == 200) # 200 means there are existing reviews.
      JSON.parse(response)["d"]["results"].each { |r| 
        existing_conv_id = r["Id"]
        delete "#{api_url}/Conversations('#{existing_conv_id}')", nil, headers
        expect_status(204)
      }
    end  
  end 

  def create_review_in_topic(topic_id, api_url, headers)
    # delete all existing reviews to make sure the following review can be created
    delete_all_reviews_in_topic(topic_id, api_url, headers)

    conv_title = "review_apitest_" + Time.now.to_s
    body = {"d":{"Title": conv_title,"HtmlContent":"<p>#{conv_title}</p>",
                 "TypeTrait":"review","RatingValue":5,"Recommended":true}}
    response = post "#{api_url}/Topics('#{topic_id}')/Conversations", body, headers
    expect_status(201)

    conversation_id = JSON.parse(response)["d"]["results"]["Id"]
    root_post_id = JSON.parse(response)["d"]["results"]["RootPostId"]
    review_id = JSON.parse(response)["d"]["results"]["Review"]["Id"]

    Review.new(conv_title, conversation_id, root_post_id, review_id)
  end
  
  def create_question_in_topic(topic_id, api_url, headers)
    # create a new question
    q_title = "q_apitest_" + Time.now.to_s
    body = {"d":{"Title": q_title,"HtmlContent":"<p>#{q_title}</p>","TypeTrait":"question"}}
    response = post "#{api_url}/Topics('#{topic_id}')/Conversations", body, headers
    expect_status(201)

    conversation_id = JSON.parse(response)["d"]["results"]["Id"]
    root_post_id = JSON.parse(response)["d"]["results"]["RootPostId"]

    Conversation.new(q_title, conversation_id, root_post_id)
  end

  # create a reply post in a conversation
  def create_post_in_conversation(content, parent_post_id, api_url, headers)
    body = {"d":{"HtmlContent":"<div class=input><p>#{content}</p></div>"}}
    response = post "#{@api_url}/Posts('#{parent_post_id}')/Posts", body, headers
    expect_status(201)

    post_id = JSON.parse(response)["d"]["results"]["Id"]
  end 

  def vote_question(vote_option, conversation_id, api_url, headers)
    if vote_option == :up
      body = {d: {VoteResult: "up"}}
    elsif vote_option == :down
      body = {d: {VoteResult: "down"}}
    else
      raise "Invalid vote option: #{vote_option}!"  
    end 
    response = post "#{api_url}/Conversations('#{conversation_id}')/Votes", body, headers
    expect_status(201)
    # expect_json("d.results", VoteResult: 1)

    vote_id = JSON.parse(response)["d"]["results"]["Id"]
  end

  def upload_conversation_attachment(api_url, headers, conversation_id, source_file, attachment_name=nil)
    file = File.new(source_file, "rb")
    filename = attachment_name.nil? ? "conv-attachment-#{Time.now.to_i}" : attachment_name
    body = {:multipart => true, :File => file, :Filename => filename} 
    post "#{api_url}/Conversations('#{conversation_id}')/AttachmentUpload()", body, headers
    expect_status(201)

    # return the attachment id
    JSON.parse(response)["d"]["results"]["Id"]
  end

  def upload_network_attachment(api_url, slug, headers, source_file, attachment_name=nil)
    file = File.new(@file_to_upload, "rb")
    filename = attachment_name.nil? ? "net-attachment-#{Time.now.to_i}" : attachment_name

    body = {:multipart => true, :File => file, :Filename => filename} 
    post "#{api_url}/Networks('#{slug}')/AttachmentUpload()", body, headers
    expect_status(201)

    # return the attachment id
    JSON.parse(response)["d"]["results"]["Id"]
  end

  def link_attachment(api_url, headers, conversation_id, attachment_id)
    body = {d:{:Id => attachment_id}}
    post "#{api_url}/Conversations('#{conversation_id}')/AttachmentLink()", body, headers
    expect_status(204)
  end

  def delete_conversation_attachment(api_url, headers, conversation_id, attachment_id)
    body = {d:{:Id => attachment_id}}
    post "#{api_url}/Conversations('#{conversation_id}')/AttachmentDelete()", body, headers
    expect_status(204)
  end  

  def delete_network_attachment(api_url, slug, headers, attachment_id)
    body = {d:{:Id => attachment_id}}
    post "#{api_url}/Networks('#{slug}')/AttachmentDelete()", body, headers
    expect_status(204)
  end  
  
  class Conversation
    attr_reader :title, :conversation_id, :root_post_id

    def initialize(title, conversation_id, root_post_id)
      @title = title
      @conversation_id = conversation_id
      @root_post_id = root_post_id
    end
  end

  class Review < Conversation
    attr_reader :review_id

    def initialize(title, conversation_id, root_post_id, review_id)
      super(title, conversation_id, root_post_id)
      @review_id = review_id
    end 
  end
end