require 'api_main_test'
require 'api_helper'

class ApiTest < ApiMainTest 
 config = YAML.load_file(File.expand_path(File.dirname(__FILE__) + "/../../config/config.yml"))

############################### HOME PAGE ################################################
##########################################################################################
user :anon
 def test_00010_get_homepage
  base_url = @c.base_url
  start = Time.now
  response = @c.api.get("anon",
      "/api/v1/OData/Networks('#{@c.slug}')",
       query: {expand: 'HomeLayout,SearchLayout,AboutLayout,EcfConfig,EnabledBusinessTemplate' }     
    )
  puts response.request.last_uri.to_s

  raise "unable to get home layouts via api" unless response.code == 200||204

  puts response.code
  puts response.body
  puts response_time = Time.now - start
  assert_equal 200, response.code
  assert response.body, "/home_banner/"
 end

 def test_00011_get_homepage_topic_widget
  start = Time.now
  response = @c.api.get("anon",
      "/api/v1/OData/Networks('#{@c.slug}')/Topics",
       query: { expand: 'LastPost,LandingLayout,ConversationLayout,Product&%24expand=LastPost%2CLandingLayout%2CConversationLayout&%24top=3&%24filter=IsActive&%24orderby=IsFeatured+desc%2CUpdatedAt+desc' }
      
    )
  puts response.request.last_uri.to_s

  raise "unable to get home topics via api" unless response.code == 200||204
  puts response.code
  #puts response.body
  puts response_time = Time.now - start
 
  assert_equal 200, response.code
 end

 def test_00012_get_homepage_open_q_widget
  start = Time.now
  response = @c.api.get("anon",
      "/api/v1/OData/Networks('#{@c.slug}')/WidgetConversations?%24top=3&%24orderby=FollowCount+desc&%24filter=TypeTrait+eq+%27question%27+and+(HasFeatured+eq+false)",
       query: { expand: 'PageLayout' }
      
    )
  puts response.request.last_uri.to_s

  raise "unable to get home open qs via api" unless response.code == 200||204
  puts response.code
  puts response.body
  puts response_time = Time.now - start
  assert_equal 200, response.code
  r = response.parsed_response["d"]["results"]
  r.each do |post_type|
    post_type["TypeTrait"]
    assert post_type["TypeTrait"] == "question"
  end
  assert !(response.body.include? "discussion|discussions|blog|blogs")
 end

 def test_00013_get_homepage_featured_d_widget
  start = Time.now
  response = @c.api.get("anon",
      "/api/v1/OData/Networks('#{@c.slug}')/WidgetConversations?%24top=3&%24filter=TypeTrait+eq+%27discussion%27&%24orderby=IsFeatured+desc%2CUpdatedAt+desc",
       query: { expand: 'PageLayout' }
      
    )
  puts response.request.last_uri.to_s

  raise "unable to get home featured discussions via api" unless response.code == 200||204
  puts response.code
  puts response.body
  puts response_time = Time.now - start
  assert_equal 200, response.code
  r = response.parsed_response["d"]["results"]
  r.each do |post_type|
    post_type["TypeTrait"]
    assert post_type["TypeTrait"] == "discussion"
  end
  assert !(response.body.include? "question|questions|blog|blogs")
 end

 def test_00014_get_homepage_featured_q_widget
  start = Time.now
  response = @c.api.get("anon",
      "/api/v1/OData/Networks('#{@c.slug}')/WidgetConversations?%24top=3&%24filter=TypeTrait+eq+%27question%27&%24orderby=IsFeatured+desc%2CUpdatedAt+desc",
       query: { expand: 'PageLayout' }
      
    )
  puts response.request.last_uri.to_s

  raise "unable to get home topics via api" unless response.code == 200||204
  puts response.code
  puts response.body
  puts response_time = Time.now - start
  assert_equal 200, response.code
  r = response.parsed_response["d"]["results"]
  r.each do |post_type|
    post_type["TypeTrait"]
    assert post_type["TypeTrait"] == "question"
  end

  assert !(response.body.include? "discussion|discussions|blog|blogs")
 end

 def test_00015_get_homepage_featured_b_widget
  start = Time.now
  response = @c.api.get("anon",
      "/api/v1/OData/Networks('#{@c.slug}')/WidgetConversations?%24top=3&%24filter=TypeTrait+eq+%27blog%27&%24orderby=IsFeatured+desc%2CUpdatedAt+desc",
       query: { expand: 'PageLayout' }
      
    )
  puts response.request.last_uri.to_s

  raise "unable to get home topics via api" unless response.code == 200||204
  puts response.code
  puts response.body
  puts response_time = Time.now - start
  assert_equal 200, response.code
  r = response.parsed_response["d"]["results"]
  r.each do |post_type|
    post_type["TypeTrait"]
    assert post_type["TypeTrait"] == "blog"
  end
  assert !(response.body.include? "discussion|discussions|question|questions")
 end
 #########################################################################################


 ################################## TOPIC PAGE ###########################################
 #########################################################################################

def test_00020_get_topic_page
  start = Time.now
  response = @c.api.get("anon",
      "/api/v1/OData/Networks('#{@c.slug}')/Topics",
       query: { expand: "LastPost,LandingLayout,ConversationLayout,Product&%24top=13&%24skip=0&%24orderby=UpdatedAt+desc&%24filter=TopicSort+eq+null&network=#{@c.slug}" }
      
    )
  puts response.request.last_uri.to_s

  raise "unable to get topics on topic page via api" unless response.code == 200||204
  puts response.code
  puts response.body
  puts response_time = Time.now - start
  assert_equal 200, response.code
end
#########################################################################################



############################## ABOUT PAGE ###############################################
#########################################################################################

def test_00030_get_about
  base_url = @c.base_url
  start = Time.now
  response = @c.api.get("anon",
      "/api/v1/OData/Networks('#{@c.slug}')?$expand=HomeLayout,SearchLayout,AboutLayout,EcfConfig,EnabledBusinessTemplate"
      
    )
  puts response.request.last_uri.to_s


  raise "unable to get home layouts via api" unless response.code == 200||204

  puts response.code
  puts response.body
  puts response_time = Time.now - start
  assert_equal 200, response.code
  assert_includes response.body, "about_banner"
end

#########################################################################################

################################### TOPIC DETAIL PAGE ###################################
#########################################################################################

def test_00040_eng_topic_detail_page
  res = @c.api.get("anon",
      "/api/v1/OData/Networks('#{@c.slug}')/Topics"
      
    )
  topic_info = res.parsed_response["d"]["results"]
  topic_info.each do |topic|
    if topic["Title"] == 'A Watir Topic'
     @eng_top_uuid = topic["Id"]
    end
  end
  start = Time.now
  response = @c.api.get("anon",
      "/api/v1/OData/Topics('#{@eng_top_uuid}')",
       query: { expand: "LastPost,LandingLayout,ConversationLayout,Product" }
      
    )
  puts response.request.last_uri.to_s

  raise "unable to get topic detail via api" unless response.code == 200||204
  puts response.code
  #puts response.body
  puts response_time = Time.now - start
  assert_equal 200, response.code

end

user :oauth
def test_00041_post_create_disc

  res = @c.api.get("anon",
      "/api/v1/OData/Networks('#{@c.slug}')/Topics"
      
    )
  topic_info = res.parsed_response["d"]["results"]
  topic_info.each do |topic|
    if topic["Title"] == 'A Watir Topic'
     @eng_top_uuid = topic["Id"]
    end
  end
  title = "conv via api - #{Time.now.getutc}"
  start = Time.now
    response = HTTParty.post("#{@c.base_url}/api/v1/OData/Topics('#{@eng_top_uuid}')/Conversations",
     body: {"d": {"Title": title, "HtmlContent": "<p>api test</p>", "TypeTrait": "discussion"}}.to_json,
     headers: {"Content-Type" => "application/json",
       "Authorization" => "#{@c.users[:oauth].token}"},
      :verify => false
   #  :client_options => {:ssl => {:ca_path => '/etc/ssl/certs'}}} 
     )
    puts response.request.last_uri.to_s
    puts response.code
    puts response_time = Time.now - start
    puts r = response.body

    raise "unable to create discussion via api" unless response.code == 201
end



user :anon

def test_00042_get_disc_by_topicid
 res = @c.api.get("anon",
      "/api/v1/OData/Networks('#{@c.slug}')/Topics"
      
    )
  topic_info = res.parsed_response["d"]["results"]
  topic_info.each do |topic|
    if topic["Title"] == 'A Watir Topic'
     @eng_top_uuid = topic["Id"]
    end
  end
 start = Time.now
  response = @c.api.get("anon", 
    "/api/v1/OData/Topics('#{@eng_top_uuid}')/Discussions"
     )
  puts response.request.last_uri.to_s
  puts response.code
  #puts response.body
  puts response_time = Time.now - start
  assert_equal 200, response.code
  assert_includes response.body, '"TypeTrait":"discussion"'
  refute_includes response.body, '"TypeTrait":"question"'
  refute_includes response.body, '"TypeTrait":"blog"'
end

def test_00043_get_q_by_topicid
 res = @c.api.get("anon",
      "/api/v1/OData/Networks('#{@c.slug}')/Topics"
      
    )
  topic_info = res.parsed_response["d"]["results"]
  topic_info.each do |topic|
    if topic["Title"] == 'A Watir Topic'
     @eng_top_uuid = topic["Id"]
    end
  end
 start = Time.now
  response = @c.api.get("anon", 
    "/api/v1/OData/Topics('#{@eng_top_uuid}')/Qnas"
     )
  puts response.request.last_uri.to_s
  puts response.code
  #puts response.body
  puts response_time = Time.now - start
  assert_equal 200, response.code
  assert_includes response.body, '"TypeTrait":"question"'
  refute_includes response.body, '"TypeTrait":"blog"'
  refute_includes response.body, '"TypeTrait":"discussion"'
end

def test_00044_get_blog_by_topicid
 res = @c.api.get("anon",
      "/api/v1/OData/Networks('#{@c.slug}')/Topics"
      
    )
  topic_info = res.parsed_response["d"]["results"]
  topic_info.each do |topic|
    if topic["Title"] == 'A Watir Topic'
     @eng_top_uuid = topic["Id"]
    end
  end
 start = Time.now
  response = @c.api.get("anon", 
    "/api/v1/OData/Topics('#{@eng_top_uuid}')/Blogs"
     )
  puts response.request.last_uri.to_s
  puts response.code
  #puts response.body
  puts response_time = Time.now - start
  assert_equal 200, response.code
  assert_includes response.body, '"TypeTrait":"blog"'
  refute_includes response.body, '"TypeTrait":"question"'
  refute_includes response.body, '"TypeTrait":"discussion"'
end

def test_00045_get_review_by_topicid
 res = @c.api.get("anon",
      "/api/v1/OData/Networks('#{@c.slug}')/Topics"
      
    )
  topic_info = res.parsed_response["d"]["results"]
  topic_info.each do |topic|
    if topic["Title"] == 'A Watir Topic'
     @eng_top_uuid = topic["Id"]
    end
  end
 start = Time.now
  response = @c.api.get("anon", 
    "/api/v1/OData/Topics('#{@eng_top_uuid}')/Reviews"
     )
  puts response.request.last_uri.to_s
  puts response.code
  #puts response.body
  puts response_time = Time.now - start
  assert_equal 200, response.code
  assert_includes response.body, '"TypeTrait":"review"'
  refute_includes response.body, '"TypeTrait":"question"'
  refute_includes response.body, '"TypeTrait":"discussion"'
  refute_includes response.body, '"TypeTrait":"blog"'
end

#########################################################################################

################################### CONVERSATION DETAIL PAGE ############################
#########################################################################################

def test_00050_get_conv_by_id
  res1 = @c.api.get("anon",
      "/api/v1/OData/Networks('#{@c.slug}')/Topics"
      
    )
  topic_info = res1.parsed_response["d"]["results"]
  topic_info.each do |topic|
    if topic["Title"] == 'A Watir Topic'
     @eng_top_uuid = topic["Id"]
    end
  end
  res2 = @c.api.get("anon",
      "/api/v1/OData/Networks('#{@c.slug}')/Conversations"
      
    )
  conv_info = res2.parsed_response["d"]["results"]
  conv_id = conv_info.first["Id"]
  conv_title = conv_info.first["Title"]

  start = Time.now
  response = @c.api.get("anon",
    "/api/v1/OData/Conversations('#{conv_id}')"
    )
  puts response.request.last_uri.to_s
  puts response.code
  puts response_time = Time.now - start
  assert_includes response.body, "#{conv_title}"
  raise "unable to get conv via api" unless response.code == 200
end

###########################################################################################################

############################## ADMIN TESTS ##########################################

user :oauth
def test_00092_post_new_topic
  title = "New Engagment Topic via api - #{Time.now.getutc}"
  start = Time.now
  
  response = HTTParty.post("#{@c.base_url}/api/v1/OData/Networks('#{@c.slug}')/Topics",
   body: {"d":{"Id": "null","Title": title,"Caption": "t1","TopicType": "engagement","IsFeatured": "false","IsActive": false,"IsBeingEdited": true,"HasAds": false}}.to_json,
   headers: {"Content-Type" => "application/json",
    "Authorization" => "#{@c.users[:oauth].token}"},
    :verify => false 
   )
   puts response.request.last_uri.to_s
   puts response.code
    
   r = response.parsed_response
   return new_topic_uuid = r["d"]["results"]["Id"]

   raise "unable to create new topic in step 1 via api" unless response.code == 201
  response = HTTParty.get("#{@c.base_url}/api/v1/OData/Topics('#{new_topic_uuid}')",
   headers: {"Content-Type" => "application/json",
   "Authorization" => "#{@c.users[:oauth].token}"},
   query: { expand: "LastPost,LandingLayout,ConversationLayout,Product"},
   :verify => false 
      
  )
  raise "unable to get new topic in step 2 via api" unless response.code == 200

  response = HTTParty.post("#{@c.base_url}/api/v1/OData/Topics('#{new_topic_uuid}')/Activate()",
     
   headers: {"Content-Type" => "application/json",
   "Authorization" => "#{@c.users[:oauth].token}"},
   :verify => false 
  )
  puts response.request.last_uri.to_s
  puts response.code
  puts response_time = Time.now - start
  puts r = response.body
  raise "unable to activate new topic in step 3 via api" unless response.code == 204
end

def test_00093_delete_topic
  new_topic_uuid = test_00092_post_new_topic
  puts "#{new_topic_uuid}"

  response = HTTParty.delete("#{@c.base_url}/api/v1/OData/Topics('#{new_topic_uuid}')",
   headers: {"Content-Type" => "application/json",
   "Authorization" => "#{@c.users[:oauth].token}"},
   :verify => false 
      
  )
  raise "unable to delete new topic via api" unless response.code == 204

end

def test_00094_get_conv_post
  
  res2 = @c.api.get("anon",
      "/api/v1/OData/Networks('#{@c.slug}')/Conversations"
      
    )
  conv_info = res2.parsed_response["d"]["results"]
  conv_id = conv_info.first["Id"]
  conv_title = conv_info.first["Title"]

  start = Time.now
  response = HTTParty.get("#{@c.base_url}/api/v1/OData/Conversations('#{conv_id}')/Posts",
    :verify => false
    )
  puts response.request.last_uri.to_s
  puts response.code
  puts response_time = Time.now - start
  assert_includes response.body, "#{conv_title}"
  raise "unable to get conv via api" unless response.code == 200

end

def test_00095_get_conv_topic
  
  res2 = @c.api.get("anon",
      "/api/v1/OData/Networks('#{@c.slug}')/Conversations"
      
    )
  conv_info = res2.parsed_response["d"]["results"]
  conv_id = conv_info.first["Id"]
  conv_title = conv_info.first["Title"]

  start = Time.now
  response = HTTParty.get("#{@c.base_url}/api/v1/OData/Conversations('#{conv_id}')/Topic",
    :verify => false
    )
  puts response.request.last_uri.to_s
  #puts response.code
  puts response_time = Time.now - start
  
  assert_includes response.body, "TopicType"
  raise "unable to get conv via api" unless response.code == 200

end

def test_00096_get_post
  start = Time.now
  
  response = @c.api.get("anon",
      "/api/v1/OData/Posts",
      :verify => false
      
    )
  post_info = response.parsed_response["d"]["results"]
  post_id = post_info.first["Id"]
  post_title = post_info.first["Title"]

  start = Time.now
  
  puts response.request.last_uri.to_s
  puts response_time = Time.now - start
  
  assert_includes response.body, "Excelsior.Post"
  raise "unable to get conv via api" unless response.code == 200
end

def test_00097_post_a_new_post_to_post

  res1 = @c.api.get("anon",
      "/api/v1/OData/Networks('#{@c.slug}')/Topics",
      :verify => false
      
    )
  topic_info = res1.parsed_response["d"]["results"]
  topic_info.each do |topic|
    if topic["Title"] == 'A Watir Topic With Many Posts'
     @sup_top_uuid = topic["Id"]
    end
  end
  res2 = @c.api.get("anon",
      "/api/v1/OData/Topics('#{@sup_top_uuid}')/LastPost"
      
    )
  post_info = res2.parsed_response["d"]["results"]
  post_id = post_info["Id"]

  start = Time.now
  
  response = HTTParty.post("#{@c.base_url}/api/v1/OData/Posts('#{post_id}')/Posts",
    body: {"d":{"HtmlContent": "<div class=input><p>Post via API </p></div>","Traits": ""}}.to_json,
    headers: {"Content-Type" => "application/json",
    "Authorization" => "#{@c.users[:oauth].token}",
    "Accept"=> "application/json"},
    :verify => false     
    )
  
  puts response.request.last_uri.to_s
  puts response_time = Time.now - start
  
  raise "unable to create new post via api" unless response.code == 201
end

def test_00098_flag_a_post
  res1 = @c.api.get("anon",
      "/api/v1/OData/Networks('#{@c.slug}')/Topics"
      
    )
  topic_info = res1.parsed_response["d"]["results"]
  topic_info.each do |topic|
    if topic["Title"] == 'A Watir Topic With Many Posts'
     @sup_top_uuid = topic["Id"]
    end
  end
  res2 = @c.api.get("anon",
      "/api/v1/OData/Topics('#{@sup_top_uuid}')/LastPost"
      
    )
  post_info = res2.parsed_response["d"]["results"]
  post_id = post_info["Id"]

  start = Time.now
  
  res3 = HTTParty.post("#{@c.base_url}/api/v1/OData/Posts('#{post_id}')/Posts",
    body: {"d":{"HtmlContent": "<div class=input><p>Post via API </p></div>","Traits": ""}}.to_json,
    headers: {"Content-Type" => "application/json",
    "Authorization" => "#{@c.users[:oauth].token}",
    "Accept"=> "application/json"},
    :verify => false     
    )
    new_post_info = res3.parsed_response["d"]["results"]
    return new_post_id = new_post_info["Id"]
    res4 = HTTParty.post("#{@c.base_url}/api/v1/OData/Posts('#{new_post_id}')/Flag()", 
     body: {"d":{}}.to_json,
     headers: {"Content-Type" => "application/json",
    "Authorization" => "#{@c.users[:oauth].token}",
    "Accept"=> "application/json"},
    :verify => false

    )
  
    puts res4.request.last_uri.to_s
    puts response_time = Time.now - start
    raise "unable to flag new post via api" unless res4.code == 204
end

def test_00099_remove_a_post
  postid = test_00098_flag_a_post
  start = Time.now
  res4 = HTTParty.post("#{@c.base_url}/api/v1/OData/Posts('#{postid}')/Remove()", 
     body: {"d":{}}.to_json,
     headers: {"Content-Type" => "application/json",
    "Authorization" => "#{@c.users[:oauth].token}",
    "Accept"=> "application/json"},
    :verify => false

    )
  
    puts res4.request.last_uri.to_s
    puts response_time = Time.now - start
    raise "unable to flag new post via api" unless res4.code == 204
end

def xtest_00100_reinstate_a_post
end

def test_00101_search
  search_word = "api"
  start = Time.now
  res1 = @c.api.get("anon",
      "/api/v1/OData/Networks('#{@c.slug}')/SearchedPosts?search=#{search_word}",
      :verify => false
      
    )

   res2 = res1.parsed_response
   result = res2["d"]["results"]
   i = 0
   len = result.length
   while i<len    
    puts result[i]['OriginalContent']
    puts result[i]['ConversationReference']['Title'] 
    
    raise "unable to search via api" unless (res1.code == 200) 
    if !(result[i]['OriginalContent'].include? search_word)
     assert result[i]['ConversationReference']['Title'], search_word
    elsif !(result[i]['ConversationReference']['Title'].include? search_word)
     assert result[i]['OriginalContent'], search_word
    end
    
    i=i+1
   end
  puts res1.request.last_uri.to_s
  puts response_time = Time.now - start  
end


##########################################################################################################


############################## SUPER ADMIN/TENANT MANAGER TESTS ##########################################
##########################################################################################################

##### skipping old superadmin api tests as it's being replaced by new tenant manager ##########
user :superadmin_user
 def xtest_00200_create_new_network
  response = HTTParty.post("https://ch-candidate-system.mo.sap.corp/admin/api/v1/OData/Networks.json",
    :body => { "d": {"Name": "api", "Domain": "ch-candidate-api.mo.sap.corp", "Id": "api", "Locale": "en"}}.to_json,
    :headers => {"Authorization" => "Bearer 7345f1ef74322e19916d1040d705bfa6ef6f20b7e27e903ba1c685dd67f67420",
      "Content-Type" => "application/json",
      "Accept" => "application/json"},
      :verify => false)
  puts response.body
  puts response.code
  assert_equal 201, response.code
 end

 def xtest_00210_delete_new_network
  response = HTTParty.delete("https://ch-candidate-system.mo.sap.corp/admin/api/v1/OData/Networks('api')/Destroy()",
    #:body => { "d": {"Name": "api", "Domain": "ch-candidate-api.mo.sap.corp", "Id": "api", "Locale": "en"}}.to_json,
    :headers => {"Authorization" => "Bearer 7345f1ef74322e19916d1040d705bfa6ef6f20b7e27e903ba1c685dd67f67420",
      "Content-Type" => "application/json",
      "Accept" => "application/json"},
      :verify => false
      )
  puts response.body
  puts response.code
  assert_equal 200, response.code
 end

 def xtest_00220_clone_network
  response = HTTParty.post("https://ch-candidate-system.mo.sap.corp/admin/api/v1/OData/Networks('api')/Clone()",
    #:body => { "d": {"Name": "api", "Domain": "ch-candidate-api.mo.sap.corp", "Id": "api", "Locale": "en"}}.to_json,
    :headers => {"Authorization" => "Bearer 7345f1ef74322e19916d1040d705bfa6ef6f20b7e27e903ba1c685dd67f67420",
      "Content-Type" => "application/json",
      "Accept" => "application/json"},
      :verify => false
      )
  puts response.body
  puts response.code
  assert_equal 201, response.code
 end

end
