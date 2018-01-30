require 'airborne'
require_relative '../api_test_config'

# Usage:
#   APITestConfig will initialize the same as watir config
#   all api test related test data are put in /test/api/data/config.yml, such as topic_id_get, application_id, secret_id etc,.

#   NOTE:
#   When testing an API call which create data in test target system. Please make sure PATCH and DELETE testing in a single test if possible
#   otherwise, there will be additional preconditions to setup for every delete test. 

describe 'Topics' do
  puts 'Topic APIs'

  before(:all) {
    @config = APITestConfig.new
    @api_base_url = '/api/v1/OData'
    @topic_id_get = @config.api_data['topic_id_get']
    @topic_with_review_id_get = @config.api_data['topic_with_review_id_get']
    @topic_with_product_id_get = @config.api_data['topic_with_product_id_get']
    @headers = {:Authorization => "Bearer #{@config.access_token}", :Accept => "application/json", :content_type => "application/json", :verify_ssl => false}
  }

  it 'should be create, activate, deactivate and delete topic' do
    # create new topic
  	body = {"d":{"Title":"test_apiapi4","Caption":"test_apiapi4","TopicType":"engagement","IsFeatured":"false","IsActive":"false","IsBeingEdited":"true","HasAds":"false"}}
    response = post "#{@api_base_url}/Networks('#{@config.slug}')/Topics", body, @headers
    expect_status(201)

    # get both main topic id and draft topic id
    if response.code == 201
      main_post_id = JSON.parse(response)["d"]["results"]["Id"]
      draft_post_id = JSON.parse(response)["d"]["results"]["DraftTwinId"]
    end

    # activate the main and draft topic
    body = {"d": {"Title":"test_apiapi4","Caption":"test_apiapi4","IsActive": true}}
    response = patch "#{@api_base_url}/Topics('#{main_post_id}')", body, @headers
    body = {"d": {"Title":"test_apiapi4","Caption":"test_apiapi4","IsActive": true}}
    response = patch "#{@api_base_url}/Topics('#{draft_post_id}')", body, @headers
    expect_status(204)

    # deactivate main and draft post
    body = {"d": {"Title":"test_apiapi4","Caption":"test_apiapi4","IsActive": false}}
    response = patch "#{@api_base_url}/Topics('#{draft_post_id}')", body, @headers
    expect_status(204)
    response = patch "#{@api_base_url}/Topics('#{main_post_id}')", body, @headers
    expect_status(204)

    # delete post
    response = delete "#{@api_base_url}/Topics('#{main_post_id}')", nil, @headers
    expect_status(204)

  end

  it 'cannot create a topic with empty name' do
    body = {"d":{"Title":"","Caption":"test_apiapi4","TopicType":"engagement","IsFeatured":"false","IsActive":"false","IsBeingEdited":"true","HasAds":"false"}}
    response = post "#{@api_base_url}/Networks('#{@config.slug}')/Topics", body, @headers
    expect_status(400)

    body = {"d":{"Title":"test_apiapi4","Caption":"","TopicType":"engagement","IsFeatured":"false","IsActive":"false","IsBeingEdited":"true","HasAds":"false"}}
    response = post "#{@api_base_url}/Networks('#{@config.slug}')/Topics", body, @headers
    expect_status(400)
  end  

  it 'Get topic by ID' do
    get "#{@api_base_url}/Topics('#{@topic_id_get}').json", @header
    expect_status(200)

    expect_json_keys('d.results', [:Id, :Title, :Caption, :IsActive])
    expect_json('d.results.Id', @topic_id_get)
  end

  it 'Get topic blogs by ID' do
    get "#{@api_base_url}/Topics('#{@topic_id_get}')/Blogs.json", @headers
    expect_status(200)

    expect_json_keys('d.results.0', [:Id, :Title, :HtmlContent, :TypeTrait])
    expect_json('d.results.0.TypeTrait', 'blog')
  end

  # undefine?
  # it 'Get topic content by ID' do
  #   res = get "#{@api_base_url}/Topics('#{@topic_id_get}')/Contents.json", @headers
  #   expect_status(204)
  # end

  it 'Get topic conversationLayout by ID' do
    res = get "#{@api_base_url}/Topics('#{@topic_id_get}')/ConversationLayout.json", @headers
    expect_status(200)

    expect_json_keys('d.results', [:Id, :CreatorId, :PageName, :LayoutName, :Config])
    expect_json_types('d.results', Id: :string)
  end

  it 'Get topic conversations by ID' do
    res = get "#{@api_base_url}/Topics('#{@topic_id_get}')/Conversations.json", @headers
    expect_status(200)

    expect_json_keys('d.results.0', [:Id, :Title, :HighlightedTitle, :OriginalContent, :HtmlContent])
    expect_json_types('d.results.0', Id: :string)
  end

  # undefind
  # it 'Get topic courses by ID' do
  #   res = get "#{@api_base_url}/Topics('#{@topic_id_get}')/Courses.json", @headers
  #   expect_status(204)
  # end

  it 'Get topic defaultAdminGroup by ID' do
    res = get "#{@api_base_url}/Topics('#{@topic_id_get}')/DefaultAdminGroup.json", @headers
    expect_status(200)

    expect_json_keys('d.results', [:Id, :Name, :Description, :Members])
    expect_json_types('d.results', Id: :string)
  end

  it 'Get topic defaultModeratorGroup by ID' do
    res = get "#{@api_base_url}/Topics('#{@topic_id_get}')/DefaultModeratorGroup.json", @headers
    expect_status(200)

    expect_json_keys('d.results', [:Id, :Name, :Description, :Members])
    expect_json_types('d.results', Id: :string)
  end

  it 'Get topic discussions by ID' do
    res = get "#{@api_base_url}/Topics('#{@topic_id_get}')/Discussions.json", @headers
    expect_status(200)

    expect_json_keys('d.results.0', [:Id, :Title, :HighlightedTitle, :OriginalContent, :HtmlContent])
    expect_json_types('d.results.0', Id: :string)
  end

  it 'Get topic featuredPosts by ID' do
    res = get "#{@api_base_url}/Topics('#{@topic_id_get}')/FeaturedPosts.json", @headers
    expect_status(200)

    expect_json_keys('d.results.0', [:Id, :OriginalContent, :HtmlContent])
    expect_json_types('d.results.0', Id: :string)
  end

  it 'Get topic featuredQuestions by ID' do
    res = get "#{@api_base_url}/Topics('#{@topic_id_get}')/FeaturedQuestions.json", @headers
    expect_status(200)

    expect_json_keys('d.results.0', [:Id, :Title, :HighlightedTitle, :OriginalContent, :HtmlContent])
    expect_json_types('d.results.0', Id: :string)
  end

  # undefined?
  # it 'Get topic follows by ID' do
  #   res = get "#{@api_base_url}/Topics('#{@topic_id_get}')/Follows.json", @headers
  #   expect_status(200)
  # end

  it 'Get topic landingLayout by ID' do
    res = get "#{@api_base_url}/Topics('#{@topic_id_get}')/LandingLayout.json", @headers
    expect_status(200)

    expect_json_keys('d.results', [:Id, :CreatorId, :PageName, :LayoutName, :Config])
    expect_json_types('d.results', Id: :string)
  end

  it 'Get topic lastPost by ID' do
    res = get "#{@api_base_url}/Topics('#{@topic_id_get}')/LastPost.json", @headers
    expect_status(200)

    expect_json_keys('d.results', [:Id, :OriginalContent, :HtmlContent])
    expect_json_types('d.results', Id: :string)
  end

  it 'Get topic likedQuestionAggregations by ID' do
    res = get "#{@api_base_url}/Topics('#{@topic_id_get}')/LikedQuestionAggregations.json", @headers
    expect_status(200)

    expect_json_keys('d.results.0', [:Id, :Name, :Count])
    expect_json_types('d.results.0', Id: :string)
  end

  it 'Get topic memberMetrics by ID' do
    res = get "#{@api_base_url}/Topics('#{@topic_id_get}')/MemberMetrics.json?metric=most_posts", @headers
    expect_status(200)

    expect_json_keys('d.results.0', [:Id, :Count])
    expect_json_types('d.results.0', Id: :string)
  end

  it 'Get topic network by ID' do
    res = get "#{@api_base_url}/Topics('#{@topic_id_get}')/Network.json", @headers
    expect_status(200)

    expect_json_keys('d.results', [:Id, :Name, :Domain])
    expect_json_types('d.results', Id: :string)
  end

  it 'Get topic pageLayouts by ID' do
    res = get "#{@api_base_url}/Topics('#{@topic_id_get}')/PageLayouts.json", @headers
    expect_status(200)

    expect_json_keys('d.results.0', [:Id, :CreatorId, :PageName, :LayoutName, :Config])
    expect_json_types('d.results.0', Id: :string)
  end

  it 'Get topic product by ID' do
    res = get "#{@api_base_url}/Topics('#{@topic_with_product_id_get}')/Product.json", @headers
    expect_status(200)

    expect_json_keys('d.results', [:Id, :Code, :Name, :Description, :Summary])
    expect_json_types('d.results', Id: :string)
  end

  # undefined
  # it 'Get topic productReviews by ID' do
  #   res = get "#{@api_base_url}/Topics('#{@topic_id_get}')/ProductReviews.json", @headers
  #   expect_status(200)
  # end

  it 'Get topic qnas by ID' do
    res = get "#{@api_base_url}/Topics('#{@topic_id_get}')/Qnas.json", @headers
    expect_status(200)

    expect_json_keys('d.results.0', [:Id, :Title, :HighlightedTitle, :OriginalContent, :HtmlContent])
    expect_json_types('d.results.0', Id: :string)
  end

  # undefined?
  # it 'Get topic relatedProducts by ID' do
  #   res = get "#{@api_base_url}/Topics('#{@topic_id_get}')/RelatedProducts.json", @headers
  #   expect_status(200)
  # end

  it 'Get topic reviews by ID' do
    res = get "#{@api_base_url}/Topics('#{@topic_with_review_id_get}')/Reviews.json", @headers
    expect_status(200)

    expect_json_keys('d.results.0', [:Id, :Title, :HighlightedTitle, :OriginalContent, :HtmlContent])
    expect_json_types('d.results.0', Id: :string)
  end

  # need to setup hrbirs?
  # it 'Get topic similarProducts by ID' do
  #   res = get "#{@api_base_url}/Topics('#{@topic_id_get}')/SimilarProducts.json", @headers
  #   expect_status(200)
  # end

  # undefined?
  # it 'Get topic similarTopics by ID' do
  #   res = get "#{@api_base_url}/Topics('#{@topic_id_get}')/SimilarTopics.json", @headers
  #   expect_status(200)
  # end

  it 'Get topic widgetConversations by ID' do
    res = get "#{@api_base_url}/Topics('#{@topic_id_get}')/WidgetConversations.json", @headers
    expect_status(200)

    expect_json_keys('d.results.0', [:Id, :Title, :HighlightedTitle, :OriginalContent, :HtmlContent])
    expect_json_types('d.results.0', Id: :string)
  end

  it 'Get topic Overview by ID' do
    res = get "#{@api_base_url}/Topics('#{@topic_id_get}')/Overview().json", @headers
    expect_status(200)

    expect_json_keys('d.results.0', [:Id, :Title, :HighlightedTitle, :OriginalContent, :HtmlContent])
    expect_json_types('d.results.0', Id: :string)
  end

  it 'Post a new topic conversation' do

    body = {"d":
                {"Title": "test_api_discussion",
                 "HtmlContent": "<p>hello</p>",
                 "TypeTrait": "discussion",
                 "TagsNames": "test",
                 "UnderProductTopic": true
                }
    }
    res = post "#{@api_base_url}/Topics('#{@topic_id_get}')/Conversations.json", body, @headers
    expect_status(201)

    expect_json_keys('d.results', [:Id, :Title, :HighlightedTitle, :OriginalContent, :HtmlContent])
    expect_json_types('d.results', Id: :string)

  end

  it 'Follow and unfollow a Topic' do

    body = {"d":
                {}
    }

    res = post "#{@api_base_url}/Topics('#{@topic_id_get}')/Follow().json", body, @headers
    expect_status(204)

    res = post "#{@api_base_url}/Topics('#{@topic_id_get}')/Unfollow().json", body, @headers
    expect_status(204)

  end

  it 'Active a topic' do
    body = {"d":
                {}
    }

    res = post "#{@api_base_url}/Topics('#{@topic_id_get}')/Activate().json", body, @headers
    expect_status(204)

  end

  it 'Quit topic edit' do
    body = {"d":
                {}
    }

    res = post "#{@api_base_url}/Topics('#{@topic_id_get}')/CancelEdits().json", body, @headers
    expect_status(204)

  end

  it 'Feature and unfeature a topic' do

    body = {"d":
                {}
    }

    res = post "#{@api_base_url}/Topics('#{@topic_id_get}')/Feature().json", body, @headers
    expect_status(204)

    res = post "#{@api_base_url}/Topics('#{@topic_id_get}')/Unfeature().json", body, @headers
    expect_status(204)

  end

  it 'Upload and delete a file' do

    body = {:multipart => true, :file => File.new(@config.data_dir + '/test.png', "rb"), :options => "tile"}

    res = post "#{@api_base_url}/Topics('#{@topic_id_get}')/FileUpload().json", body, @headers
    expect_status(204)

    body = {"d": {"attribute": "tile"}}
    res = post "#{@api_base_url}/Topics('#{@topic_id_get}')/FileDelete().json", body, @headers
    expect_status(204)

  end



end