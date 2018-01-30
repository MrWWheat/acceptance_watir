require 'watir_test'
require 'pages/community/gated'
require 'pages/community/events'
require 'pages/community/about'
require 'pages/community/topicdetail'
require 'pages/community/login'
require 'pages/community/home'

class GatedTest < WatirTest

  def setup
    super
    @browser = @config.browser
    @base_url = @base_url = @config.base_url.chomp('/')

    @gated_page = Pages::Community::Gated.new(@config)
    @topiclist_page = Pages::Community::TopicList.new(@config)
    @topicdetail_page = Pages::Community::TopicDetail.new(@config)

    @home_page = Pages::Community::Home.new(@config)
    @events_page = Pages::Community::Events.new(@config)
    @about_page = Pages::Community::About.new(@config)

    @current_page = @topicdetail_page
    puts "[[[ #{name} ::: #{user_for_test} ]]]" if @config.verbose?
   
    #@topicdetail_page.start!(user_for_test)
  end

  def teardown
    super
  end

user :network_admin

  def test_00010_topic_view_all_sign_out
    @browser.goto @base_url
    @gated_page.admin_login_link.when_present.click

    @login_page = Pages::Community::Login.new(@config)
    @browser.wait_until { @login_page.user_dropdown.present? || @login_page.login_link.present? }
    @login_page.login_admin(@c.users["network_admin"])
    @browser.refresh
    @topiclist_page.logout!
    assert @login_page.login_url == @browser.url, "Not Signin Page"
    
  end

  def test_00020_question_edit_page_sign_out
    @browser.goto @base_url
    @gated_page.admin_login_link.when_present.click

    @login_page = Pages::Community::Login.new(@config)
    @browser.wait_until { @login_page.user_dropdown.present? || @login_page.login_link.present? }
    @login_page.login_admin(@c.users["network_admin"])
    @browser.refresh

    @topicdetail_page.topic_detail("A Watir Topic For Widgets")
    @topicdetail_page.choose_post_type("question")

    @topicdetail_page.goto_conversation_create_page(:question)

    @topicdetail_page.logout!
    assert @login_page.login_url == @browser.url, "Not Signin Page"
  end

  def test_00030_product_page_sign_out
    @browser.goto @base_url 
    @gated_page.admin_login_link.when_present.click

    @login_page = Pages::Community::Login.new(@config)
    @browser.wait_until { @login_page.user_dropdown.present? || @login_page.login_link.present? }
    @login_page.login_admin(@c.users["network_admin"])
    @browser.refresh

    @topiclist_page.navigate_bar_product.when_present.click
    @browser.wait_until { @browser.ready_state == "complete" }
    @topiclist_page.logout!
    @browser.wait_until{@login_page.login_body.present?}
    assert @login_page.login_url == @browser.url, "Not Signin Page"   
  end

    def test_00040_events_page_sign_out
      @browser.goto @base_url
      @gated_page.admin_login_link.when_present.click

      @login_page = Pages::Community::Login.new(@config)
      @browser.wait_until { @login_page.user_dropdown.present? || @login_page.login_link.present? }
      @login_page.login_admin(@c.users["network_admin"])
      @browser.refresh
      @topiclist_page.navigate_bar_event.when_present.click
      @browser.wait_until { @browser.ready_state == "complete" }
      @events_page.logout!
      @browser.wait_until{@login_page.login_body.present?}
      assert @login_page.login_url == @browser.url, "Not Signin Page"
  end

    def test_00050_eventsdetail_page_sign_out
      @browser.goto @base_url
      @gated_page.admin_login_link.when_present.click

      @login_page = Pages::Community::Login.new(@config)
      @browser.wait_until { @login_page.user_dropdown.present? || @login_page.login_link.present? }
      @login_page.login_admin(@c.users["network_admin"])
      @browser.refresh

      @topiclist_page.navigate_bar_event.when_present.click

      @events_page.go_to_events("A Watir Event")
      sleep 2
      @events_page.logout!
      @browser.wait_until{@login_page.login_submit.present?}
      # puts  @login_page.login_url
      # puts @browser.url
      assert @login_page.login_url == @browser.url, "Not Signin Page"

  end

    def test_00060_about_page_sign_out
      @browser.goto @base_url
      @gated_page.admin_login_link.when_present.click

      @login_page = Pages::Community::Login.new(@config)
      @browser.wait_until { @login_page.user_dropdown.present? || @login_page.login_link.present? }
      @login_page.login_admin(@c.users["network_admin"])
      @browser.refresh

      @topiclist_page.navigate_bar_about.click

      @about_page.logout!
      assert @login_page.login_url == @browser.url, "Not Signin Page"
  end

    def test_00070_open_question_search_page_sign_out
      @browser.goto @base_url
      @gated_page.admin_login_link.when_present.click

      @login_page = Pages::Community::Login.new(@config)
      @browser.wait_until { @login_page.user_dropdown.present? || @login_page.login_link.present? }
      @login_page.login_admin(@c.users["network_admin"])
      @browser.refresh

      @browser.wait_until { !@topiclist_page.layout_loading_block.present? }
      #@topiclist_page.navigate_bar_home.when_present.click
      @topiclist_page.navigate_bar_home.when_present.click
      @browser.wait_until { @browser.ready_state == "complete" }

      @browser.execute_script("window.scrollBy(0,2000)")
      @home_page.open_question_viewall.when_present.click

      @home_page.logout!
      assert @login_page.login_url == @browser.url, "Not Signin Page"
  end

    def test_00080_user_unable_access_page
      #homepage url test
      @homepage_url = @base_url + "/n/#{@config.slug}/home"
      @browser.goto @homepage_url
      assert @gated_page.admin_login_link.present?, "Not Redirect To Gated Page" 
      
      #topic gallery view url test
      @topic_gallery_view_url = @base_url + "/n/#{@config.slug}"
      @browser.goto @topic_gallery_view_url
      assert @gated_page.admin_login_link.present?, "Not Redirect To Gated Page" 
      
      #random topic detail url test
      @browser.goto @base_url
      @gated_page.admin_login_link.present?
      @gated_page.admin_login_link.when_present.click

      @login_page = Pages::Community::Login.new(@config)
      @browser.wait_until { @login_page.user_dropdown.present? || @login_page.login_link.present? }

      @login_page.login!(@c.users["network_admin"])
      @browser.refresh
      @topiclist_page.goto_first_topic

      sleep 1
      topic_url = @browser.url
      @topicuuid = topic_url.split("/topic/")[1].split("/")[0]
      @topicname = topic_url.split("/topic/")[1].split("/")[2]
      @topicdetail_page.logout!

      @browser.goto @base_url +"/topic/"+"#{@topicuuid}"+"/#{@c.slug}/"+ "/#{@topicname}"
      assert @gated_page.admin_login_link.present?, "Not Redirect To Gated Page" 
      
      #event gallery view url test
      @events_page_url = @base_url + "/n/#{@config.slug}/events"
      @browser.goto @events_page_url
      assert @gated_page.admin_login_link.present?, "Not Redirect To Gated Page" 

      #profile view url test
      @browser.goto @base_url
      @gated_page.admin_login_link.present?
      @gated_page.admin_login_link.when_present.click

      @login_page = Pages::Community::Login.new(@config)
      @browser.wait_until { @login_page.user_dropdown.present? || @login_page.login_link.present? }

      @login_page.login!(@c.users["network_admin"])
      @browser.refresh

      #@login_page.profile_icon.click
      profile_url = @browser.url
      @profileuuid = topic_url.split("/profile/")[1]

      @topicdetail_page.logout!

      @browser.goto @base_url + "/n/#{@c.slug}/profile/" + "#{@prodfileuuid}"
      assert @gated_page.admin_login_link.present?, "Not Redirect To Gated Page" 
    end

    def test_00090_user_able_access_register_page
      @browser.goto @base_url
      @gated_page.admin_login_link.present?
      @gated_page.admin_login_link.when_present.click

      @login_page = Pages::Community::Login.new(@config)
      @browser.wait_until {  @login_page.register.present? }
      @login_page.register.click

      @browser.wait_until {  @login_page.register_page_username.present? }
      assert @login_page.register_page_username.present?, "Redirect To Gated Page, User Not See Correct Page"
    end
end