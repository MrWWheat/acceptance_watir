require File.expand_path(File.dirname(__FILE__) + "/../lib/test_helper")

class HybrisWatirTest < MiniTest::Test

  def self.before_tests
    # Code that should run before all tests. Once.
    @@browser = nil
  end
  before_tests # This runs when class is loaded

  $os = "" # operating system
  $failure = 0 # number of failures
  $failed_tests = "" # list of failed tests
  
  $basedir = File.expand_path(File.dirname(__FILE__)).to_s
  
  config = YAML.load_file(File.expand_path(File.dirname(__FILE__) + "/../config/config_hybris.yml"))

  $browser = config["config"]["browser"]
  
  instance, site = ARGV

  ARGV.each do |instance, site|
    $instance = "#{instance}"
    $site = "#{site}"
  end
  
  $instance = "#{instance}"
  $site = "#{site}"

  $base_url = config["env"][$instance][$site]["base_url"]
  $community_base_url = config["env"][$instance][$site]["community_base_url"]
  $network_slug = config["env"][$instance][$site]["network_slug"]
  $communityadmin = config["env"][$instance][$site]["adminuser"]
  $hybrisuser = config["env"][$instance][$site]["user1"]["hybrisuser"]
  $communityuser = config["env"][$instance][$site]["user1"]["communityuser"]
  $hybrisuser2 = config["env"][$instance][$site]["user2"]["hybrisuser"]
  $communityuser2 = config["env"][$instance][$site]["user2"]["communityuser"]
  $hybrisusertemp = config["env"][$instance][$site]["user_temp"]["hybrisuser"]
  $product_id_blank = config["env"][$instance][$site]["product_id_blank"]
  $product_id_many = config["env"][$instance][$site]["product_id_many"]
  $product_id_write = config["env"][$instance][$site]["product_id_write"]
  $facebook_user = config["social_account"]["facebook_user"]
  $twitter_user = config["social_account"]["twitter_user"]
  $linkedin_user = config["social_account"]["linkedin_user"]
  $google_user = config["social_account"]["google_user"]
  $t = config["env"][$instance][$site]["timeout"]
  
  $user3 = ['','','','',''] #initialize a dummy $user3 required in page_object.rb which is not needed in hybris watir test
  # clean up old screenshot
  files = Dir[$basedir + "/../screenshots/*.png"]
  files.each do |file|
    FileUtils.rm(file, :force => true) if file.match(/hybris_test_\d+.*/)
  end

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
      Watir::Wait.until { $b.body.present? }

    else
    end
    @browser ||= $b
    initialize_pages
    @browser.window.maximize
  end  

  def teardown
    unless passed?
      @timestamp = Time.now.utc.to_i.to_s
      @attachment = @browser.screenshot.save screenshot_dir("hybris_" + @NAME + '_' + @timestamp + '.png')
    end
    until @browser.windows.size <= 1
      @browser.windows.last.close
    end
  end
end


