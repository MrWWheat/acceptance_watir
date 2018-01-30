require 'watir_test'
require 'pages/api_doc/devportal'

class DevPortalTest < WatirTest
  @@token = nil
  @@topic_id = nil
  @@conversation_id = nil
  def setup
    super
    @devportal_page = Pages::APIDoc::DevPortal.new(@config)
    # assigning @current_page helps error reporting
    #  give good contextual data
    puts "[[[ #{name} ::: #{user_for_test} ]]]" if @config.verbose?
    @browser = @config.browser
    unless @@token
      @@token = @devportal_page.get_token
      puts "token: " + @@token
    end
    @devportal_page.start!
    @devportal_page.token_span.when_present.click
    @devportal_page.set_oauth_token @@token
  end

  def teardown
    super
  end

  p1
  def test_00010_test_devportal_get_api
    response = @devportal_page.get_topics_api
    @@topic_id = response[/\"id\":\s\"([A-Za-z0-9]+)/,1]
    assert response.include? "\"status\": 200"

  end

  def test_00020_test_devportal_post_api
    set_topic_id
    response = @devportal_page.post_conversation_api @@topic_id, "question-#{get_timestamp}","content-#{get_timestamp}"
    @@conversation_id = response[/\"id\":\s\"([A-Za-z0-9]+)/,1]
    assert response.include? "\"status\": 201"
  end

  def test_00030_test_devportal_patch_api
    set_conversation_id
    response = @devportal_page.patch_conversation_api @@conversation_id, "question-#{get_timestamp}","content-edit-#{get_timestamp}"
    assert response.include? "\"status\": 200"
  end

  def test_00040_test_devportal_delete_api
    set_conversation_id
    response = @devportal_page.delete_conversation_api @@conversation_id
    assert response.include? "\"status\": 200"
  end

  def set_topic_id
    unless @@topic_id
      # response = JSON.parse(@devportal_page.get_topics_api)
      @@topic_id = @devportal_page.get_topics_api[/\"id\":\s\"([A-Za-z0-9]+)/,1]
    end
  end

  def set_conversation_id
    set_topic_id
    unless @@conversation_id
      response = post_conversation_api @@topic_id, "question-#{get_timestamp}","content-#{get_timestamp}"
      @@conversation_id = response[/\"id\":\s\"([A-Za-z0-9]+)/,1]
    end
  end

end
