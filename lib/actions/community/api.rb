require 'actions/base'

class Actions::CommunityAPI < Actions::Base
  def initialize(config)
    super(config)
  end

  def get_reviews_from_topic(user, topic_id)
    establish_session(user)
    @config.api.get(user, "/api/v2/topics/#{topic_id}/reviews")
  end

  def delete_review(user, id)
    @config.api.establish_session(user)
    @config.api.delete(user, "/api/v2/reviews/#{id}")
    puts "Delete review #{id}"
  end

  def delete_review_by_user(user, topic_id)
    response = get_reviews_from_topic(user, topic_id)

    reviews_count = response["data"].size

    return if reviews_count == 0

    review_id = nil
    response["data"].each do |review|
      if review["creator"]["username"] == user.username
        review_id = review["id"]
        break
      end  
    end 

    delete_review(user, review_id) unless review_id.nil?
  end  

  def delete_question(user, id)
    @config.api.establish_session(user)
    @config.api.delete(user, "/api/v2/questions/#{id}")
    puts "Delete question #{id}"
  end 

  def delete_blog(user, id)
    @config.api.establish_session(user)
    @config.api.delete(user, "/api/v2/blogs/#{id}")
    puts "Delete question #{id}"
  end 

  def delete_conversation(type, user, id)
    @config.api.establish_session(user)

    case type
    when :question
      delete_question(user, id)
    when :review
      delete_review(user, id)
    when :blog
      delete_blog(user, id)
    else
      raise "type #{type} not supported yet"
    end

    puts "Delete #{type} #{id}"
  end 

  def create_question(user, topic_id, title, description)
    establish_session(user)
    body = {title: title, html_content: description}
    response = @config.api.post(user, "/api/v2/topics/#{topic_id}/questions", body: body.to_json)
    puts "Create a question"
    response["data"]["id"]
  end  

  def create_reply_in_question(user, question_id, reply_content)
    establish_session(user)
    body = {html_content: reply_content}
    response = @config.api.post(user, "/api/v2/questions/#{question_id}/replies", body: body.to_json)
    puts "Create a reply in a question"
    response["data"]
  end

  def create_reply_to_reply(user, reply_id, reply_content)
    establish_session(user)
    body = {html_content: reply_content}
    response = @config.api.post(user, "/api/v2/questions/#{question_id}/replies", body: body.to_json)
    puts "Create a reply in a question"
    response["data"]
  end

  def create_topic(user, title, description, type)
    body = { title: title, description: description, type: "engagement" }
    response = @config.api.post(user, "/api/v2/topics", body: body.to_json)
    topic_id = response["data"]["id"]
    
    @config.api.post(user, "/api/v2/topics/#{topic_id}/activate", body: body.to_json)
    puts "Create a topic"
    topic_id
  end 

  def delete_topic(user, topic_id)
    @config.api.establish_session(user)
    @config.api.delete(user, "/api/v2/topics/#{topic_id}")
    puts "Delete topic #{topic_id}"
  end
  
  def activate_topic(user, topic_id)
    establish_session(user)
    response = @config.api.post(user, "/api/v2/topics/#{topic_id}/activate")
    p "Activate topic #{topic_id}"
  end

  def unfollow_topic(user, topic_id)
    establish_session(user)
    response = @config.api.post(user, "/api/v2/topics/#{topic_id}/unfollow")
    p "Unfollow topic #{topic_id}"
  end
end  
