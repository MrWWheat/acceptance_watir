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

end

# tag some context into every error message
module Minitest
  module Assertions
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
  end
  module Reporters
    class SpecReporter
      def record(test)
        super
        reported_name = "%s(%s)" % [test.name, test.user_for_test]
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
end

unless %w{WATIR_LANDSCAPE WATIR_SLUG}.all? { |var| ENV.has_key?(var) }
  unless ARGV.size >= 2
    raise "Missing landscape,slug parameters to run tests"
  end
  ENV['WATIR_LANDSCAPE'] = ARGV.shift
  ENV['WATIR_SLUG'] = ARGV.shift

end