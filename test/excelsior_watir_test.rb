
require File.expand_path(File.dirname(__FILE__) + "/../lib/test_helper")
require File.expand_path(File.dirname(__FILE__) + "/../lib/page_objects/page_object.rb")
class ExcelsiorWatirTest < MiniTest::Test

  def self.before_tests
    # Code that should run before all tests. Once.
    @@browser = nil
    
  end
  before_tests # This runs when class is loaded

  $os = "" # operating system
  $failure = 0 # number of failures
  $failed_tests = "" # list of failed tests
  
  $basedir = File.expand_path(File.dirname(__FILE__)).to_s
  $rootdir = File.expand_path(File.dirname(__FILE__) + "../..")
  
  config = YAML.load_file(File.expand_path(File.dirname(__FILE__) + "/../config/config.yml"))
  
  $browser = config["config"]["browser"]
  $browser_port = '9812'

  $instance, $networkslug, browser = ARGV
  if browser
    params = browser.split(':')
    $browser = params[0]
    $browser_port = params[1] if params[1]
  end

  $base_url = config["env"][$instance][$networkslug]["base_url"]
  $superadmin_url = config["env"][$instance][$networkslug]["superadmin_url"]
  $network = config["env"][$instance][$networkslug]["network"]
  $login_type = config["env"][$instance][$networkslug]["login_type"]
  $user1 = config["env"][$instance][$networkslug]["user1"]
  $user2 = config["env"][$instance][$networkslug]["user2"]
  $user3 = config["env"][$instance][$networkslug]["user3"]
  $user4 = config["env"][$instance][$networkslug]["user4"]
  $user5 = config["env"][$instance][$networkslug]["user5"]
  $user6 = config["env"][$instance][$networkslug]["user6"]
  $user7 = config["env"][$instance][$networkslug]["user7"]
  $user8 = config["env"][$instance][$networkslug]["user8"]
  $user9 = config["env"][$instance][$networkslug]["user9"]
  $user10 = config["env"][$instance][$networkslug]["user10"]
  $user11 = config["env"][$instance][$networkslug]["user11"]
  $user12 = config["env"][$instance][$networkslug]["user12"]
  $workflow = config["config"]["workflow"]

  $beta_feature = Hash.new
  if config["env"][$instance][$networkslug]["beta_feature_enabled"]
    config["env"][$instance][$networkslug]["beta_feature_enabled"].each do |key|
      $beta_feature[key.downcase] = true
    end
  end
  #$t = config["config"]["timeout"] # timeout value

  
  
  $t = config["env"][$instance][$networkslug]["timeout"] 
  
  def screenshot_dir(filename)
    FileUtils.mkdir_p(File.expand_path(File.dirname(__FILE__) + "/../screenshots"))
    File.expand_path(File.dirname(__FILE__) + "/../screenshots/#{filename}")
  end

  def setup 

    
    # OS version check
    if (/cygwin|mswin|mingw|bccwin|wince|emx/ =~ RUBY_PLATFORM) == nil
      $os = "linux"
    else
      $os = "windows"
    end

    # init browser objects
    unless @@browser
      setup_browser($browser)
      @@browser = $b    
      $b.screenshot.save screenshot_dir('404a.png') #for debugging in jenkins for prod
      Watir::Wait.until { $b.body.present? }
      $b.screenshot.save screenshot_dir('404b.png')

    else
    end
    
    @browser ||= $b   
    
    @browser.window.maximize

  #   def self.check_and_create_topic
  #   PageObject.new(@browser).about_login("regular", "logged")
  #   PageObject.new(@browser).topic_sort_by_name

  #   if !@browser.text.include? PageObject.new(@browser).support_topicname 
  #    PageObject.new(@browser).create_new_topic("#{$network}", "#{$networkslug}", "support", false, PageObject.new(@browser).support_topicname)
  #   end  
  #   if !@browser.text.include? PageObject.new(@browser).engagement_topicname 
  #    PageObject.new(@browser).create_new_topic("#{$network}", "#{$networkslug}", "engagement", false, PageObject.new(@browser).engagement_topicname)
  #   end  
  #   if !@browser.text.include? PageObject.new(@browser).engagement2_topicname 
  #    PageObject.new(@browser).create_new_topic("#{$network}", "#{$networkslug}", "engagement", false, PageObject.new(@browser).engagement2_topicname)
  #   end  

  # end
  # check_and_create_topic

    # clear policy warning if present

    # @browser.after_hooks.add do |browser|      
    #   policy_warning_button_present = browser.execute_script('return $(".policy-warning-button button").length') > 0 rescue false
    #   browser.execute_script 'return $(".policy-warning-button button").trigger("click")' if policy_warning_button_present      
    # end
  end  

  

  # Add any common cleanup here
  # When adding a teardown method in a specific test class,
  # make sure to call super
  def teardown
    #Minitest::Reporters.use! [Minitest::Reporters::SpecReporter.new, MiniTest::Reporters::JUnitReporter.new]
    @browser.screenshot.save screenshot_dir('failed.png') unless passed?
    # Do a browser operation. If exception caused, handle it.
 #   @browser.div(:class => "non-existent").present
    # put line of code which triggers alert on page
  rescue Selenium::WebDriver::Error::UnhandledAlertError
    puts "ALERT DIALOG: Closing and reopening the browser to fix this issue"
    #@browser.close
  #end
    $b.quit
    setup_browser
    @browser = $b
    @browser.window.maximize
  end

end


