# Excelsior watir test helper
require "rubygems"
require "bundler"
require "watir"
require "minitest"
require "minitest/autorun"
require "selenium-webdriver"
require "watir-webdriver"
require 'watir-webdriver-performance'
require "yaml"
require "rbconfig"
require "minitest/reporters"
require "minitest/unit"
require "fileutils"
require 'byebug'
require 'bacon'
require 'rake'
require 'rake/testtask'
require 'fileutils'
require "watir-webdriver/wait"
require 'httparty'
require File.expand_path(File.dirname(__FILE__) + "/chrome_driver_process.rb")


# Test report options
case ENV["REPORT"]
  when "short"
  Minitest::Reporters.use! [Minitest::Reporters::DefaultReporter.new(:color => true), MiniTest::Reporters::JUnitReporter.new]
  when "progress"
  Minitest::Reporters.use! Minitest::Reporters::ProgressReporter.new
  else
  Minitest::Reporters.use! Minitest::Reporters::SpecReporter.new
end
# Helpers and overrides


class MiniTest::Test
  Minitest::Reporters.use! [Minitest::Reporters::SpecReporter.new, MiniTest::Reporters::JUnitReporter.new]
  #MiniTest::Ci.auto_clean = false


  #### Test execution order ####
  def self.test_order
    :alpha
  end

  #### Browser set up ####
  def setup_browser(browser)
    $b = case browser
      when "firefox"
        profile = Selenium::WebDriver::Firefox::Profile.new
        # profile.proxy = Selenium::WebDriver::Proxy.new :http => ''
        profile['network.proxy.type'] = 1
        # profile['network.proxy.autoconfig_url'] = "http://proxy.wdf.sap.corp:8080"
        # profile['network.proxy.autoconfig_url'] = "http://proxy:8083/"
        # profile['network.proxy.ssl'] = "http://proxy.wdf.sap.corp:8080"
        profile['network.proxy.http'] = "proxy.wdf.sap.corp"
        profile['network.proxy.http_port'] = 8080
        profile['network.proxy.ssl'] = "proxy.wdf.sap.corp"
        profile['network.proxy.ssl_port'] = 8080
        profile['network.proxy.no_proxies_on'] = "*.mo.sap.corp"
        Watir::Browser.new :firefox, :profile => profile

      when "ie"
        Watir::Browser.new :ie

      when "chrome"
        ChromeDriverProcess.start
        Watir::Browser.new :remote, url: ChromeDriverProcess.remote_url
        #puts "#{@browser}"
      when "chrome-proxy"
         Watir::Browser.new :chrome, :switches => %w[--proxy-server=proxy.wdf.sap.corp:8080]

      when "headless"
        # This is to run browser headlessly by using Xvfb (X virtual frame buffer) to not opening a visible browser.
        # This only works on linux machine
        require "headless"
        @headless ||= Headless.new(
          display:         101,
          destroy_at_exit: false,
          reuse:           true
        )

        profile = Selenium::WebDriver::Firefox::Profile.new
        profile['network.proxy.type'] = 2
        #profile['network.proxy.autoconfig_url'] = "http://proxy.wdf.sap.corp:8080"
        profile['network.proxy.autoconfig_url'] = "http://proxy.successfactors.com:8083"
        #profile['network.proxy.ssl'] = "http://proxy.wdf.sap.corp:8080"
        #profile.proxy = Selenium::WebDriver::Proxy.new :http => 'proxy.successfactors.com:8083'
        @headless.start
        #$t = 90

        Watir::Browser.new :firefox , :profile => profile
        #Watir::Browser.start $base_url

      when "ghostdriver"
        @headless.start
        Watir::Browser.new :phantomjs # this is a solution for running headless mode on mac
      else
        raise "Invalid browser type #{browser}! Exit!"
        exit
    end
  end

end

  MiniTest.after_run do
    begin
      $b.quit if $b # close browser
    rescue Errno::ECONNREFUSED
    ensure
      ChromeDriverProcess.exit
    end
  end

  def beta_feature_enabled? beta_feature
      downcased_env = Hash[ENV.map {|k,v|[k.downcase, v]}]
      beta_feature = beta_feature.downcase
      if downcased_env.include? beta_feature
        return downcased_env[beta_feature]
      elsif $beta_feature[beta_feature]
        return $beta_feature[beta_feature]
      elsif (downcased_env.include? "all") || ($beta_feature["all"])
        return true
      else
        return false
      end
  end

  def login_from_widget(user)
    return if user == $logged_in_user
    @browser.link(:class => "ember-view btn btn-default" , :text => /Sign in/).when_present.click
    login_helper(user)
  end

  def login_helper(user)
    @browser.text_field(:id => "member_login").set user[2]
    @browser.text_field(:id => "member_password").set user[1]
    @browser.screenshot.save screenshot_dir('userpwd.png')

    assert @browser.button(:type => "submit").present?
    @browser.button(:type => "submit").click

    @browser.wait_until { @browser.link(:class => "dropdown-toggle profile").exists?}
    assert @browser.link(:class => "dropdown-toggle profile").exists?
    $logged_in_user = user # save for next time
  end

  def login_register_modal_open_helper
    about_landing($network)
    if ( !@browser.link(:class => "login ember-view login", :text => "Sign In").present?)
      signout
    end
    assert @browser.link(:class => "login ember-view login", :text => "Sign In").present?
    @browser.link(:class => "login ember-view login", :text => "Sign In").when_present.click
    @browser.wait_until($t) { @browser.div(:class => /signin-header/).present? }
  end

  def sort_by_old_in_conversation_detail
    @browser.div(:class => "pull-right sort-by dropdown").span(:class => "icon-down fs-7").when_present.click
    @browser.wait_until($t) { @browser.div(:class => "col-lg-8 col-md-7").div(:class => "pull-right sort-by dropdown open").exists? }
    @browser.link(:text => "Oldest").click
    sleep 1
    @browser.wait_until($t) { @browser.div(:class => "pull-right sort-by dropdown").text.include? "Sorted by: Oldest"}
    assert @browser.div(:class => "pull-right sort-by dropdown").text.include? "Sorted by: Oldest"
  end

  def sort_by_new_in_conversation_detail
    @browser.div(:class => "pull-right sort-by dropdown").span(:class=> "icon-down fs-7").when_present.click
    @browser.wait_until($t) { @browser.div(:class => "col-lg-8 col-md-7").div(:class => "pull-right sort-by dropdown open").present?}
    @browser.link(:text => "Newest").click
    @browser.wait_until { @browser.div(:class => "pull-right sort-by dropdown").text.include? "Sorted by: Newest"}
    @browser.wait_until { @browser.div(:class => /ember-view depth-1/).exists? }
    sleep 1

    assert @browser.div(:class => "pull-right sort-by dropdown").text.include? "Sorted by: Newest"
  end

  def get_timestamp
    return Time.now.utc.to_s.gsub(/[-: ]/,'')
  end




# def login(user)
#     #puts "#{user.inspect}"
#     #puts "#{$logged_in_user.inspect}"
#     return if user == $logged_in_user
#     if ( !@browser.link(:class, "login ember-view login").present?) || (@browser.link(:class => "dropdown-toggle username").exists?)
#       signout
#     end
#     if @browser.link(:class, "login ember-view login").present?
#       @browser.screenshot.save screenshot_dir('login.png') #for jenkins test

#       #@browser.div(:class => "navbar topbar-nav").div(:class => "pull-right flex-content-center").link(:text => /Sign In/).when_present.click
#       @browser.goto "#{$base_url}/n/#{$networkslug}/members/sign_in"
#       @browser.wait_until($t) { @browser.div(:class => "row signin-body").present? }
#       @browser.screenshot.save screenshot_dir('signin.png')
#       login_helper(user)
#     end
#   end



  # def main_landing(type, user)
  #     @browser.goto "#{$base_url}/n/#{$networkslug}"

  #   if (( !@browser.link(:class, "login ember-view login").present?) || (@browser.link(:class => "dropdown-toggle username").present?) || (@browser.link(:class => "dropdown-toggle notification").present? ))
  #     signout
  #   end

  #   if user == "logged"
  #      case type
  #       when "social-fb"
  #         login($user6)
  #       when "social-link"
  #         login($user7)
  #       when "social-g"
  #         login($user8)
  #       when "social-twi"
  #         login($user9)
  #       when "regis"
  #         login($user3)
  #       when "regis2"
  #         login($user4)
  #       when "regis3"
  #         login($user5)
  #       when "admin"
  #         login($user1)
  #       when "mod"
  #         login($user2)
  #       when "adminonly"
  #         login($user10)
  #       when "regular"
  #         login($user1) #user1 is admin and moderator
  #       else
  #       raise "Invalid user type! Exit.."
  #      end
  #     assert ( !@browser.div(:class => "login ember-view login").present?)
  #     assert @browser.link(:class => "dropdown-toggle username").exists?
  #     @browser.wait_until { @browser.div(:class => "topics").div(:class => "col-sm-12 col-lg-4 col-md-4").present? }
  #     assert @browser.div(:class => "topics").div(:class => "col-sm-12 col-lg-4 col-md-4").present?
  #   end

  #   if user == "visitor"
  #     case type
  #      when "anon"
  #      if @browser.link(:class => "dropdown-toggle username").present?
  #        signout
  #      end
  #     assert @browser.link(:class => "login ember-view login").text.include? "Sign In"
  #     @browser.wait_until { @browser.div(:class => "topics").div(:class => "col-sm-12 col-lg-4 col-md-4").present? }
  #     assert @browser.div(:class => "topics").div(:class => "col-sm-12 col-lg-4 col-md-4").present?
  #    else
  #     raise "Invalid user type! Exit.."
  #     end
  #   end
  #   if @browser.div(:id => "policy-warning").present?

  #       policy_warning
  #     end

  # end

  # def about_landing(networkSlug)
  #   @browser.goto "#{$base_url}/n/#{$networkslug}/about"
  #   @browser.wait_until { @browser.span(:class => "icon-slim-arrow-right", :text => "About").present? }
  # end

  # def network_landing(networkslug)
  #   @browser.goto "#{$base_url}/n/#{$networkslug}"
  # end

  # # If logged in as admin
  # def go_to_admin_page(networkslug)
  #   admin_page_link = @browser.div(:class=>"dropdown open").link(:href => "/admin/#{networkslug}")
  #   unless admin_page_link.present?
  #     caret = @browser.div(:class => /topbar-nav/).span(:class => "caret")
  #     @browser.wait_until($t) { caret.present? }
  #     caret.click
  #     @browser.wait_until($t) { admin_page_link.present? }
  #   end
  #   admin_page_link.click
  # end

  # def registring_and_login_with_social_user
  #   @browser.goto $base_url
  #   @browser.wait_until($t) { @browser.body.present? }

  #   if @browser.link(:class => "dropdown-toggle username").present?
  #     signout
  #   end

  #   assert @browser.link(:class => "login", :text => /Sign In/).present?, "No Sign In link found"
  #   @browser.link(:class => "login", :text => /Sign In/).click
  #   @browser.wait_until($t) { @browser.div(:class => "row signin-body").present? }
  # end

  # def signout
  #   $logged_in_user = nil

  #   username = @browser.link(:class => "dropdown-toggle username")

  #   @browser.wait_until($t){
  #     username.exists?
  #   }
  #   username.click
  #   #@browser.execute_script('$("#mobileProfile").attr("class", "dropdown open")')
  #   sleep 2
  #   @browser.link(:text => /Sign Out/).click
  #   @browser.wait_until($t) { @browser.div(:class => "navbar topbar-nav").link(:text => /Sign In/).present? }
  #   assert @browser.div(:class => "navbar topbar-nav").link(:text => /Sign In/).present?
  # end

  # def admin_check(networkslug)
  #   username = @browser.link(:class => "dropdown-toggle username")

  #   @browser.wait_until($t){
  #     username.exists?
  #   }
  #   username.click

  #   if !@browser.link(:href => "/admin/#{networkslug}").exists?
  #       puts "User not an admin...Logging in admin user.."
  #       login($user1) # will do a logout before login
  #       @browser.goto "#{$base_url}"+"/n/#{networkslug}"
  #       caret = @browser.span(:class => "caret")
  #       @browser.wait_until($t){
  #       caret.present?
  #      }
  #     caret.click
  #   end
  #   @browser.wait_until($t) { @browser.link(:href => "/admin/#{networkslug}").exists? }
  #   assert @browser.link(:href => "/admin/#{networkslug}").exists?
  #   return networkslug
  # end

  # def mod_flag_threshold(network, networkslug)
  #   about_landing(network)
  #  # if ( !@browser.div(:class => "pull-right flex-content-center").text.include? "Sign In / Register")
  #  # signout
  #  #end
  #   main_landing("admin", "logged")
  #   caret = @browser.span(:class => "caret")
  #   @browser.wait_until($t){
  #     caret.present?
  #   }
  #   caret.click
  #   @browser.div(:class=>"dropdown open").link(:href => "/admin/#{networkslug}").when_present.click
  #   @browser.wait_until { @browser.div(:class => "topics-list row").exists? }
  #   assert @browser.div(:class => "navbar-collapse collapse sidebar-navbar-collapse").exists?
  #   @browser.link(:href => "/admin/#{networkslug}/moderation").when_present.click
  #   @browser.wait_until { @browser.link(:text => "Flagged Posts").exists? }
  #   assert @browser.link(:text => "Flagged Posts").exists?
  #   @browser.link(:text => "Moderation Threshold").when_present.click

  #   @browser.text_field(:name => "flag_threshold").when_present.clear
  #   @browser.text_field(:name => "flag_threshold").when_present.set "1"
  #   @browser.button(:class => "btn btn-primary", :value => /Save/).when_present.click
  #   assert @browser.div(:class => "alert alert-success alert-dismissible").exists?
  # end

  # def social_user_registration_and_login(social_site_type)
  #   registring_and_login_with_social_user

  #   if (social_site_type == "Facebook")
  #     @browser.link(:text => /Sign in with Facebook/).when_present.click
  #     @browser.url.include? ("facebook.com/login.php?")
  #     @browser.text_field(:id => "email").when_present.set $user6[0]
  #     @browser.text_field(:id => "pass").when_present.set $user6[1]
  #     @browser.button(:type => "submit" , :value => "Log In").when_present.click

  #   end

  #   if (social_site_type == "Linkedin")
  #     @browser.link(:text => /Sign in with LinkedIn/).when_present.click
  #     @browser.url.include? ("linkedin.com/uas/oauth/authorize?")
  #     @browser.text_field(:id => "session_key-oauthAuthorizeForm").when_present.set $user7[0]
  #     @browser.text_field(:id => "session_password-oauthAuthorizeForm").when_present.set $user7[1]
  #     @browser.input(:type => "submit" , :value => "Allow access").when_present.click
  #   end

  #   if (social_site_type == "Google")
  #     @browser.link(:text => /Sign in with Google/).when_present.click
  #     @browser.url.include? ("accounts.google.com/ServiceLogin?")
  #     @browser.text_field(:id => "Email").when_present.set $user8[0]
  #     @browser.text_field(:id => "Passwd").when_present.set $user8[1]
  #     @browser.input(:type => "submit" , :value => "Sign in").when_present.click

  #     accept = @browser.button(:id => "submit_approve_access")
  #     @browser.wait_until($t) {
  #       accept.present? && !accept.attribute_value("disabled") #accept button is disabled initially, therefore waiting for it to be not disabled anymore
  #     }

  #     accept.when_present.click
  #   end

  #   if (social_site_type == "Twitter")
  #     @browser.link(:text => /Sign in with Twitter/).when_present.click
  #     @browser.url.include? ("twitter.com/oauth/authenticate?")
  #     @browser.text_field(:id => "username_or_email").when_present.set $user9[0]
  #     @browser.text_field(:id => "password").when_present.set $user9[1]
  #     @browser.input(:type => "submit" , :value => "Sign In").when_present.click
  #   end

  # end

  # def social_user_registration_add_username(username)   #Going to excelsior page and adding the username for excelsior
  #   @browser.wait_until($t) {  @browser.div(:id => "member_edit").present? }
  #   @browser.text_field(:id => "member_username").when_present.set username[2]
  #   @browser.input(:class => "btn btn-primary" , :type => "submit" , :value => "Update").when_present.click
  # end

  # def social_user_registration_and_login_verification(username)  #asserting for the give username to appear in the top nav
  #   @browser.wait_until($t) {  @browser.link(:class => "dropdown-toggle username").exists? }

  #   assert @browser.span(:class => "caret").present?
  #   signout
  # end

  # def policy_warning
  #   if @browser.div(:id => "policy-warning").present?
  #     @browser.div(:class => "policy-warning-button").button(:class => "btn btn-primary").click
  #     @browser.wait_until { !@browser.div(:id => "policy-warning").present? }
  #     assert !@browser.div(:id => "policy-warning").present?
  #   end
  # end

  # def topic_publish
  #   if @browser.div(:class => "topic-create-wizard").div(:class => "container").div(:class => "row").div(:class => "button-align-right").button(:class => "btn btn-primary btn-sm", :text => "Publish Changes").exists?
  #     @browser.div(:class => "topic-create-wizard").div(:class => "container").div(:class => "row").div(:class => "button-align-right").button(:class => "btn btn-primary btn-sm", :text => "Publish Changes").click
  #     @browser.wait_until($t) { @browser.div(:class => "buttons col-lg-6 col-md-6").div(:class => "btn-toolbar pull-right").div(:class => "btn-group").button(:class => "btn btn-default btn-sm admin-dark-btn topic-admin-buttons").exists? }
  #     assert @browser.div(:class => "buttons col-lg-6 col-md-6").div(:class => "btn-toolbar pull-right").div(:class => "btn-group").button(:class => "btn btn-default btn-sm admin-dark-btn topic-admin-buttons").present?
  #   end
  # end

  # def topic_sort_by_name
  #   topic_name = "A Watir Topic"
  #   if @browser.button(:class => "btn btn-default dropdown-toggle filter-dropdown sap-regular-dropdown", :text => "Sort by: Newest").present?
  #     @browser.screenshot.save screenshot_dir('topicsort.png')
  #     refute_nil @browser.execute_script 'return $(".topic-sort-drop-down >button").trigger("click")', "Failed to open the dropdown"
  #     refute_nil @browser.execute_script 'return $(".filter-dropdown a:contains(\'Name\')").trigger("click")', "Failed to Name sort option in the dropdown"
  #     @browser.wait_until {@browser.link(:class => "ember-view", :text => /#{topic_name}/).present?}
  #     assert @browser.link(:class => "ember-view", :text => /#{topic_name}/).present?
  #   end
  # end



  # def post_detail(post_name=nil,type)
  #   choose_post_type(type)
  #   @browser.wait_until($t){ !@browser.i(:class => "fa fa-spinner fa-2x fa-spin").exists? }
  #   if post_name
  #     @browser.link(:text => post_name).when_present.click
  #   else
  #     @browser.link(:class => "ember-view media-heading", :index => 0).when_present.click
  #   end
  #   textarea = @browser.textarea(:class => "ember-view ember-text-area form-control")
  #   @browser.wait_until($t) { textarea.exists? }
  #   @browser.wait_until($t) { @browser.div(:class => /ember-view/).exists? }
  #   @browser.wait_until($t) { @browser.div(:class => "conversation-content").exists? }
  #   sleep 2
  # end

  # def choose_post_type(type)
  #   if type == "discussion"
  #     typeclass = "disc"
  #     typetext = "Discussions"
  #   elsif type == "question"
  #     typeclass = "ques "
  #     typetext = "Questions"
  #   elsif type == "blog"
  #     typeclass = "blog"
  #     typetext = "Blogs"
  #   end
  #   link = @browser.link(:text => typetext)
  #   link.when_present.click
  #   #@browser.wait_until($t) { link.class_name.include? "disabled" }
  #   @browser.wait_until { @browser.div(:class => "media-body").exists? }
  #   assert @browser.div(:class => "media-body").exists?
  # end


  # def conversation_detail(type, post_name = nil)
  #   if !(post_name == nil)

  #     until @browser.text.include? post_name
  #     @browser.execute_script("window.scrollBy(0,1900)")
  #     @browser.link(:text => "Show more").click
  #     @browser.wait_until { @browser.div(:class => "post-collection").exists? }
  #     @browser.text.include? post_name
  #     end
  #     @browser.link(:text => post_name).when_present.click
  #   if (type == "question")
  #     @browser.wait_until { @browser.div(:class => /ember-view depth-1 answer post/).exists? }
  #     assert @browser.div(:class => /ember-view depth-1 answer post/).exists?
  #     assert @browser.h3(:class => "media-heading root-post-title").text.include? post_name
  #   end
  #   if (type == "discussion")
  #     @browser.wait_until($t) { @browser.div(:class => /depth-0 discussion/).exists? }
  #     assert @browser.div(:class => "conversation-content").exists?
  #     assert @browser.h3(:class => "media-heading root-post-title").text.include? post_name
  #   end
  #   if (type == "blog")
  #     @browser.wait_until($t) { @browser.div(:class => "conversation-content").exists? }
  #     assert @browser.h3(:class => "media-heading root-post-title").text.include? post_name
  #   end

  # else
  #   @browser.link(:class => "media-heading ember-view media-heading").when_present.click
  #   if (type == "question")
  #     @browser.wait_until { @browser.div(:class => /row conversation-root-post/).exists? }
  #     assert @browser.div(:class => /row conversation-root-post/).exists?
  #   end
  #   if (type == "discussion")
  #     @browser.wait_until($t) { @browser.div(:class => /row conversation-root-post/).exists? }
  #     assert @browser.div(:class => /row conversation-root-post/).exists?
  #   end
  #   if (type == "blog")
  #     @browser.wait_until($t) { @browser.div(:class => /ember-view root-post/).exists? }
  #     assert @browser.div(:class => /ember-view root-post/).exists?
  #   end
  #   end

  # end

  # def feature_post(level,post_name=nil)
  #   post = get_post(level,post_name)
  #   post.span(:class => "dropdown-toggle").when_present.click
  #   @browser.wait_until { post.link(:text => /Feature/).present? }
  #   post.link(:text => /Feature/).when_present.click
  #   @browser.wait_until { @browser.link(:class => "feature-class featured-link").exists? }

  #   assert @browser.link(:class => "feature-class featured-link").exists?
  # end

  # def unfeature_post(level,post_name=nil)
  #   post = get_post(level,post_name)
  #   post.span(:class => "dropdown-toggle").when_present.click
  #   post.link(:text => "Stop Featuring").when_present.click
  #   sleep 2
  #   @browser.wait_until($t){ !get_post(level,post_name).class_name.include? "feature"}
  #   assert (!get_post(level,post_name).class_name.include? "feature")
  # end

  # def feature_root_post
  #   feature_post(0)
  # end

  # def feature_comment(post_name=nil)
  #   feature_post(1,post_name)
  # end

  # def feature_reply(post_name=nil)
  #   feature_post(2,post_name)
  # end

  # def unfeature_root_post
  #   unfeature_post(0)
  # end

  # def unfeature_comment(post_name=nil)
  #   unfeature_post(1,post_name)
  # end

  # def unfeature_reply(post_name=nil)
  #   unfeature_post(2,post_name)
  # end

  # def get_post(level,post_name=nil,count=0)
  #   if post_name
  #     element = @browser.div(:class => /depth-#{level}/,:text => /#{post_name}/)
  #   else
  #     element = @browser.div(:class => /depth-#{level}/) #,:index => count)
  #   end

  #   @browser.wait_until($t){ element.exists? }
  #   return element
  # end

  # def goto_topicdetail_page(topictype)
  #   case topictype
  #    when "support"
  #     topic_sort_by_name
  #     @browser.wait_until($t) { @topic_page.present? }
  #     @topic_support.when_present.click
  #    when "engagement"
  #     if !@browser.text.include?(@engagement_topicname)
  #     topic_sort_by_name
  #   end
  #   @browser.execute_script("window.scrollBy(0,1000)")
  #     @topic_engagement.when_present.click
  #   when "engagement2"
  #    if !@browser.text.include?(@engagement2_topicname)
  #     topic_sort_by_name
  #     @browser.wait_until($t) { @topic_page.present? }
  #    end
  #    @browser.execute_script("window.scrollBy(0,3000)")
  #     @topic_engagement2.when_present.click
  #    else
  #     raise "Invalid post type! Exit.."
  #    end
  #   @browser.wait_until($t) { @topic_filter.present? }
  #   #assert @topic_filter.present?
  # end



# def create_conversation(network, networkslug, topic_name, posttype, title, widget=true)

#   if ( !widget)
#     @browser.goto "#{$base_url}"+"/n/#{networkslug}"
#     @browser.wait_until($t){ @browser.div(:id => "topics").present? }

#     if (@browser.div(:class => "pull-right flex-content-center").text.include? "Sign In")
#     network_landing(network)
#     main_landing("regular", "logged")
#     end
#     #puts topic_name
#     topic_detail(topic_name)
#     @browser.wait_until($t) { @browser.div(:class => "topic-filters").exists? }
#     assert @browser.div(:class => "topic-follow-button").exists?

#     if @browser.div(:class => "topic-create-wizard").div(:class => "container").div(:class => "row").div(:class => "button-align-right").button(:class => "btn btn-primary btn-sm", :text => "Publish Changes").exists?
#       @browser.div(:class => "topic-create-wizard").div(:class => "container").div(:class => "row").div(:class => "button-align-right").button(:class => "btn btn-primary btn-sm", :text => "Publish Changes").click
#       @browser.wait_until($t) {@browser.button(:class => "btn btn-default btn-sm admin-dark-btn", :text => "Edit Topic").present? }
#       assert @browser.button(:class => "btn btn-default btn-sm admin-dark-btn", :text => "Edit Topic")
#     end

#     if posttype == "review"
#       @browser.link(:class => "blog ", :text => "Reviews").click
#       @browser.wait_until($t) { @browser.div(:class => "btn-group").button(:class => "btn btn-primary", :text => "New Review").present? }
#       @browser.div(:class => "btn-group").button(:class => "btn btn-primary", :text => "New Review").click
#     #end
#     else
#       @browser.button(:class => "btn btn-primary", :text => /Create New/).when_present.click

#       @browser.wait_until($t) { @browser.div(:class => "row topic-content").exists? }
#     end
#   end

#     @browser.text_field(:class => "form-control ember-view ember-text-field").when_present.set title

#     if posttype == "question" || posttype == "question_with_image"
#       @browser.wait_until($t) { @browser.div(:class => "shown").exists? } #suggested posts
#       #@browser.wait_until($t) { @browser.div(:class => "post-type question chosen").present? }
#       if !@browser.div(:class => "post-type blog chosen").present?
#        @browser.div(:class => "post-type question ").when_present.click
#       end
#       @browser.wait_until($t) { @browser.div(:class => "post-type question chosen").present? }
#     end
#     if posttype == "discussion" || posttype == "discussion_with_link"
#       @browser.wait_until($t) { @browser.div(:class => "shown").exists? } #suggested posts
#       if !@browser.div(:class => "post-type discussion chosen").present?
#        @browser.div(:class => "post-type discussion ").when_present.click
#       end
#       @browser.wait_until($t) { @browser.div(:class => "post-type discussion chosen").present? }
#     end
#     if posttype == "blog" || posttype == "blog_with_video"
#       if !@browser.div(:class => "post-type blog chosen").present?
#        @browser.div(:class => "post-type blog ").when_present.click
#       end
#       @browser.wait_until($t) { @browser.div(:class => "post-type blog chosen").present? }
#     end

#     if posttype == "discussion_with_link" #always have link in it
#       @browser.execute_script('$("button[data-event=showLinkDialog]").get(1).click()')
#       @browser.wait_until($t) {
#         @browser.text_field(:class => "note-link-text").present?
#       }
#       link_href = "http://google.com"
#       link_title = "Google"

#       assert @browser.text_field(:class => "note-link-text").present?, "link modal not present"
#       @browser.text_field(:class => "note-link-text").set(link_title)
#       @browser.text_field(:class => "note-link-url").when_present.set(link_href)
#       @browser.button(:class => "note-link-btn").when_present.click

#       assert @browser.link(:text => link_title, :href => link_href).present?, "Link not present in the editor"
#     end

#     if posttype == "question_with_link" #always have link in it
#       if !@browser.div(:class => "post-type question chosen").present?
#        @browser.div(:class => "post-type question ").when_present.click
#       end
#       @browser.wait_until($t) { @browser.div(:class => "post-type question chosen").present? }
#       @browser.execute_script('$("button[data-event=showLinkDialog]").get(1).click()')
#       @browser.wait_until($t) {
#         @browser.text_field(:class => "note-link-text").present?
#       }
#       link_href = "http://google.com"
#       link_title = "Google"

#       assert @browser.text_field(:class => "note-link-text").present?, "link modal not present"
#       @browser.text_field(:class => "note-link-text").set(link_title)
#       @browser.text_field(:class => "note-link-url").when_present.set(link_href)
#       @browser.button(:class => "note-link-btn").when_present.click

#       assert @browser.link(:text => link_title, :href => link_href).present?, "Link not present in the editor"
#     end


#     if posttype == "blog_with_video"
#       @browser.execute_script('$("button[data-event=showVideoDialog]").click()')
#       @browser.wait_until($t) {
#         @browser.text_field(:class => "note-video-url").present?
#       }

#       video_url = "https://www.youtube.com/watch?v=prCKZg5ONGg"

#       assert @browser.text_field(:class => "note-video-url").present?, "Modal for video not present"
#       @browser.text_field(:class => "note-video-url").set(video_url)
#       @browser.button(:class => "btn-primary note-video-btn").when_present.click
#       #assert @browser.div(:class => "conversation-content").exists?

#     end

#     @browser.execute_script('$("div.note-editable").html($("div.note-editable").html() + " Watir test description")')
#     @browser.execute_script('$("div.note-editable").blur()') #needed to communicate the description back to the parent element. the blur events fires fine during manual creation.
#     @browser.execute_script("window.scrollBy(0,600)")
#     @browser.wait_until($t) { @browser.div(:class => "controls text-right").button(:class => "btn btn-primary").exists? }
#     @browser.div(:class => "controls text-right").button(:class => "btn btn-primary", :value => /Submit/).when_present.click
#     #@browser.wait_until($t) { !@browser.div(:class => "controls text-right").button(:class => "btn btn-primary", :value => /Submit/).present? }
#     @browser.wait_until { @browser.div(:class => /depth-0/).exists?}

#     return title
#   end
