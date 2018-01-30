require 'minitest'
require "minitest/autorun"
#require 'test_helper2'
require File.expand_path(File.dirname(__FILE__) + "/../test/test_helper2.rb")
require 'watir_config'
require 'lazy_dsl_tag_collector'
#require 'pages/base'

class WatirTest < MiniTest::Test
  def setup
    @config ||= WatirConfig.new
    @c = @config
    WatirConfig.startup_browser # idempotent, will not create a new resource if it's already open
  end

  def teardown
    puts "\n\n" if @c.extra_whitespace?
    unless passed?
      @timestamp = Time.now.utc.to_i.to_s
      @c.screenshot!(@NAME + '_' + @timestamp)
    end
  rescue Selenium::WebDriver::Error::UnhandledAlertError
    puts "ALERT DIALOG: Closing and reopening the browser to fix this issue"
    #@browser.close
    #end
    WatirConfig.shutdown_browser
    WatirConfig.startup_browser
  end

  def user_for_test
    specified_user = self.class.users_list.find_tag(self.name.to_sym)
    specified_user.nil? ? :anonymous : specified_user
  end

  def prio_for_test
    self.class.priorities_list.find_tag(self.name.to_sym)
  end

  #minimal insertion to make p1 test filtering easy...
  def self.methods_matching re
    method_symbols = public_instance_methods(true).grep(re)
    case ENV['WATIR_PRIO']
      when /^p\d+/
        return (method_symbols & self.priorities_list.list_by_tag(ENV['WATIR_PRIO'].to_sym,method_symbols)).map(&:to_s)
      when /^-p\d+/
        return (method_symbols - self.priorities_list.list_by_tag(ENV['WATIR_PRIO'][1..-1].to_sym,method_symbols)).map(&:to_s)
      else
        return method_symbols.map(&:to_s)
    end
  end

  def self.priorities_list
    self.const_set(:PRIORITIES_LIST, LazyDslTagCollector.new) unless self.const_defined?(:PRIORITIES_LIST)
    self::PRIORITIES_LIST
  end

  def self.users_list
    self.const_set(:USERS_LIST, LazyDslTagCollector.new) unless self.const_defined?(:USERS_LIST)
    self::USERS_LIST
  end

  def self.method_missing name, *args
    case name
      when :user
        return self.users_list.next_tag(args[0],self.public_instance_methods(true))
      when /^p\d+$/
        # no args, tag is implicit in the method_missing name
        return self.priorities_list.next_tag(name,self.public_instance_methods(true))
    end
    super
  end

end
