require "minitest/reporters"
require "minitest/reporters/progress_reporter"
require "minitest/unit"
require "minitest/assertions"

require "watir"
require "selenium-webdriver"
require "watir-webdriver"
require 'watir-webdriver-performance'
require "watir-webdriver/wait"

require 'byebug'

require 'set'


class MiniTest::Test
  Minitest::Reporters.use! [Minitest::Reporters::SpecReporter.new, MiniTest::Reporters::JUnitReporter.new]

  def self.test_order
    :alpha
  end

  def get_timestamp
    return Time.now.utc.to_s.gsub(/[-: ]/,'')
  end

  def beta_feature_enabled? beta_feature
      downcased_env = Hash[ENV.map {|k,v|[k.downcase, v]}]
      beta_feature = beta_feature.downcase
      if downcased_env.include? beta_feature
        return downcased_env[beta_feature]
      elsif @c.beta_feature[beta_feature]
        return @c.beta_feature[beta_feature]
      elsif (downcased_env.include? "all") || (@c.beta_feature["all"])
        return true
      else
        return false
      end    
  end

  def wait_file_download(download_dir, entries_before_download, expected_filename_part, wait_time=30)
    file_name = nil

    # wait until the expected file is downloaded
    wait_time.times do
      difference = Dir.entries(download_dir) - entries_before_download
      if difference.size > 0
        file_name = difference.find { |f| f.include?(expected_filename_part) } 
        break if (!file_name.nil? && !file_name.end_with?("download")) # mid file format ***.crdownload
      end  
      sleep 1
    end

    # make sure the downloaded file is not 0 size
    unless file_name.nil?
      file_path = File.join(download_dir, file_name)
      raise "Size of the downloaded file #{file_name} is 0" if File.size(file_path) == 0
      return file_path
    else
      return nil  
    end 
  end  
end

# tag some context into every error message
module Minitest
  module Assertions
    #attr_accessor :assertions
    def assert test, msg = nil
      self.assertions += 1
      unless test then
        msg ||= "Failed assertion, no message given."
        msg = msg.call if Proc === msg
        if @current_page.nil?
          (Kernel.caller - Kernel.caller.grep(/gem/)).grep(/_test\.rb/).last.match(/^([^:]+):/)
          test_file = $1
          puts " >"
          puts " >"
          puts " > Warning: @current page is not set in this test. Setting it helps error messages give contextual data"
          puts " > ( 'setup' method in #{test_file} )"
          puts " >"
          puts " >"
        else
          msg = "[ #{@current_page.url} ] " + msg
        end
        raise Minitest::Assertion, msg
      end
      true
    end

    def assert_includes collection, obj, msg = nil
      msg = message(msg) {
        "Expected #{mu_pp(collection)} to include #{mu_pp(obj)}"
      }
      assert_respond_to collection, :include?
      assert collection.include?(obj), msg
    end

    def assert_all_keys hash, msg = nil
      expected = hash.keys.to_set
      found = hash.select { |k,v| v }.keys.to_set
      if msg.nil? && !(expected - found).empty?
        results = hash.map do |k,v|
          "[%s] : %s" % [ (v ? " PASS " : "!FAIL!"), k ]
        end
        msg = "The following keys (and associated assertions) had some failures:\n" + results.join("\n")
      end
      assert_equal hash.keys.to_set, hash.select { |k,v| v }.keys.to_set, msg
    end

    def assert_equal_case_insensitive(expected, actual)
      assert_equal expected.downcase, actual.downcase
    end

    def assert_not_equal_case_insensitive(expected, actual)
      assert expected.downcase != actual.downcase
    end
  end

  module Reporters
    class SpecReporter
      def record(test)
        super
        reported_name = "%s:%s(%s)" % [test.prio_for_test, test.name, test.user_for_test]
        print pad_test(reported_name)
        print_colored_status(test)
        print(" (%.2fs)" % test.time)
        puts
        if !test.skipped? && test.failure
          print_info(test.failure)
          puts
        end
      end
    end
  end
end

MiniTest.after_run do
  Pages::Base.report_unused_dom
   WatirConfig.shutdown_browser
end

unless %w{WATIR_LANDSCAPE WATIR_SLUG WATIR_BROWSER}.all? { |var| ENV.has_key?(var) }
  unless ARGV.size >= 3
    raise "Missing landscape,slug,browser parameters to run tests"
  end
  ENV['WATIR_LANDSCAPE'] = ARGV.shift
  ENV['WATIR_SLUG'] = ARGV.shift
  ENV['WATIR_BROWSER'] = ARGV.shift

  if ARGV.any? && (ARGV[0] =~ /^-?p\d+$/)
    ENV['WATIR_PRIO'] = ARGV.shift
  end

end

# Clean up the old screenshots. This is necessary when integrate with Jenkins. 
# Otherwise, old screenshots might be visible for even sucessful cases in the next run for Jenkins job.
FileUtils.rm_rf(Dir.glob(File.dirname(__FILE__) + "/../screenshots/*"))

# #require File.expand_path(File.dirname(__FILE__) + "/../lib/page_objects/page_object.rb")
# require File.expand_path(File.dirname(__FILE__) + "/../lib/test_helper")
#
# class ExcelsiorWatirTest < MiniTest::Test
#
#   def self.before_tests
#     # Code that should run before all tests. Once.
#     @@browser = nil
#
#   end
#   before_tests # This runs when class is loaded
#
#   $os = "" # operating system
#   $failure = 0 # number of failures
#   $failed_tests = "" # list of failed tests
#
#   $basedir = File.expand_path(File.dirname(__FILE__)).to_s
#   $rootdir = File.expand_path(File.dirname(__FILE__) + "../..")
#
#   config = YAML.load_file(File.expand_path(File.dirname(__FILE__) + "/../config/config.yml"))
#
#   $browser = config["config"]["browser"]
#   $browser_port = '9812'
#
#   $instance, $networkslug, browser = ARGV
#   if browser
#     params = browser.split(':')
#     $browser = params[0]
#     $browser_port = params[1] if params[1]
#   end
#
#   $base_url = config["env"][$instance][$networkslug]["base_url"]
#   $superadmin_url = config["env"][$instance][$networkslug]["superadmin_url"]
#   $network = config["env"][$instance][$networkslug]["network"]
#   $login_type = config["env"][$instance][$networkslug]["login_type"]
#   $user1 = config["env"][$instance][$networkslug]["user1"]
#   $user2 = config["env"][$instance][$networkslug]["user2"]
#   $user3 = config["env"][$instance][$networkslug]["user3"]
#   $user4 = config["env"][$instance][$networkslug]["user4"]
#   $user5 = config["env"][$instance][$networkslug]["user5"]
#   $user6 = config["env"][$instance][$networkslug]["user6"]
#   $user7 = config["env"][$instance][$networkslug]["user7"]
#   $user8 = config["env"][$instance][$networkslug]["user8"]
#   $user9 = config["env"][$instance][$networkslug]["user9"]
#   $user10 = config["env"][$instance][$networkslug]["user10"]
#   $user11 = config["env"][$instance][$networkslug]["user11"]
#   $user12 = config["env"][$instance][$networkslug]["user12"]
#   $workflow = config["config"]["workflow"]
#   #$t = config["config"]["timeout"] # timeout value
#
#
#
#   $t = config["env"][$instance][$networkslug]["timeout"]
#
#   def screenshot_dir(filename)
#     FileUtils.mkdir_p(File.expand_path(File.dirname(__FILE__) + "/../screenshots"))
#     File.expand_path(File.dirname(__FILE__) + "/../screenshots/#{filename}")
#   end
#
#   def setup
#
#
#     # OS version check
#     if (/cygwin|mswin|mingw|bccwin|wince|emx/ =~ RUBY_PLATFORM) == nil
#       $os = "linux"
#     else
#       $os = "windows"
#     end
#
#     # init browser objects
#     unless @@browser
#       setup_browser($browser)
#       @@browser = $b
#       $b.screenshot.save screenshot_dir('404a.png') #for debugging in jenkins for prod
#       Watir::Wait.until { $b.body.present? }
#       $b.screenshot.save screenshot_dir('404b.png')
#
#     else
#     end
#
#     @browser ||= $b
#
#     @browser.window.maximize
#
#     # clear policy warning if present
#
#     # @browser.after_hooks.add do |browser|
#     #   policy_warning_button_present = browser.execute_script('return $(".policy-warning-button button").length') > 0 rescue false
#     #   browser.execute_script 'return $(".policy-warning-button button").trigger("click")' if policy_warning_button_present
#     # end
#   end
#
#   # Add any common cleanup here
#   # When adding a teardown method in a specific test class,
#   # make sure to call super
#   def teardown
#     #Minitest::Reporters.use! [Minitest::Reporters::SpecReporter.new, MiniTest::Reporters::JUnitReporter.new]
#     @browser.screenshot.save screenshot_dir('failed.png') unless passed?
#       # Do a browser operation. If exception caused, handle it.
#       #   @browser.div(:class => "non-existent").present
#       # put line of code which triggers alert on page
#   rescue Selenium::WebDriver::Error::UnhandledAlertError
#     puts "ALERT DIALOG: Closing and reopening the browser to fix this issue"
#     #@browser.close
#     #end
#     $b.quit
#     setup_browser
#     @browser = $b
#     @browser.window.maximize
#   end
#
# end


