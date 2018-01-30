require 'watir_test'
require 'pages/api_doc/swagger'

class SwaggerTest < WatirTest
  @@token = nil
  @@topic_id = nil
  @@conversation_id = nil
  def setup
    super
    @swagger_page = Pages::APIDoc::Swagger.new(@config)
    # assigning @current_page helps error reporting
    #  give good contextual data
    puts "[[[ #{name} ::: #{user_for_test} ]]]" if @config.verbose?
    @browser = @config.browser
    unless @@token
      @@token = @swagger_page.get_token
      puts "token: " + @@token
    end
    @swagger_page.start!
    @swagger_page.set_oauth_token @@token
  end

  def teardown
    super
  end

  p1
  def test_00010_test_swagger_get_api
    result = @swagger_page.get_topics_api @c.slug
    assert_code result[:code]
    @@topic_id = result[:response]["d"]["results"][0]["Id"]
  end

  def test_00020_test_swagger_post_api
    set_topic_id
    result = @swagger_page.post_conversation_api @@topic_id, "question-#{get_timestamp}","content-#{get_timestamp}"
    assert_code result[:code]
    @@conversation_id = result[:response]["d"]["results"]["Id"]
  end

  def test_00030_test_swagger_patch_api
    set_conversation_id
    result = @swagger_page.patch_conversation_api @@conversation_id, "question-#{get_timestamp}","content-#{get_timestamp}"
    assert_code result[:code]
  end

  def test_00040_test_swagger_delete_api
    set_conversation_id
    result = @swagger_page.delete_conversation_api @@conversation_id
    assert_code result[:code]
  end

  def set_topic_id
  	unless @@topic_id
      result = @swagger_page.get_topics_api @c.slug
      @@topic_id = result[:response]["d"]["results"][0]["Id"]
    end
  end

  def set_conversation_id
  	set_topic_id
  	unless @@conversation_id
      result = @swagger_page.post_conversation_api @@topic_id, "question-#{get_timestamp}","content-#{get_timestamp}"
      @@conversation_id = result[:response]["d"]["results"]["Id"]
    end  
  end

  def assert_code code
    assert code == 200 || code == 201 || code == 204
  end

end
