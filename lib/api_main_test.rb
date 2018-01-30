require 'minitest'
require "minitest/autorun"
require 'api_main_config'
require 'lazy_dsl_tag_collector'
require 'pages/base'

class ApiMainTest < MiniTest::Test
  def setup
    @config ||= WatirConfig.new
    @c = @config
  #  WatirConfig.startup_browser # idempotent, will not create a new resource if it's already open
  end

  def teardown
    puts "\n\n" if @c.extra_whitespace?
  end

  def user_for_test
    specified_user = self.class.users_list.find_tag(self.name.to_sym)
    specified_user.nil? ? :anonymous : specified_user
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
