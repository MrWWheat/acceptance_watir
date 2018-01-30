#abort "Please unset http_proxy, HTTP_PROXY. Aborting!" if ENV["http_proxy"] || ENV["HTTP_PROXY"]
#require File.expand_path(File.dirname(__FILE__) + "/lib/test_helper.rb")
#require 'minitest/reporters'
#require "minitest/reporters"
#Minitest::Reporters.use!
TESTOPTS = ENV["TESTOPTS"] unless defined?(TESTOPTS)
#if ENV['ENABLE_REPORTING'] == 'true'
#  require 'ci/reporter/rake/minitest'
#  task :minitest => 'ci:setup:minitest'
#require 'minitest/reporters'
#Minitest::Reporters.use! [Minitest::Reporters::SpecReporter.new, MiniTest::Reporters::JUnitReporter.new]
#end
require 'rake'
require 'rake/testtask'
require 'byebug'
# Celluloid.task_class = Celluloid::TaskThread
task default: %w[watir:test]

namespace :watir do
desc 'Runs watir tests'
task :test, :instance, :network_slug, :browser do |t, args|
  instance = args[:instance] ?  args[:instance] : show_directions
  network_slug = args[:network_slug] ? args[:network_slug] : show_directions
  browser = args[:browser] ? args[:browser] : show_directions

  if ENV["TEST"]
    sh "ruby -I:lib #{ENV["TEST"]} #{TESTOPTS} #{instance} #{network_slug} #{browser} --name /test_0/; true"
  else
    Dir.glob("test/page/*_test.rb") do |test_file|
      sh "ruby -I:lib #{test_file} #{TESTOPTS} #{instance} #{network_slug} #{browser} --name /test_0/; true"
    end
  end
end

task :test_p1, :instance, :network_slug, :browser do |t, args|
  instance = args[:instance]
  network_slug = args[:network_slug]
  browser = args[:browser]

  if ENV["TEST"]
    sh "ruby -I:lib #{ENV["TEST"]} #{TESTOPTS} #{instance} #{network_slug} #{browser} --name /test_p1/; true" 
  else
    Dir.glob("test/page/*page_test.rb") do |test_file|
      sh "ruby -I:lib #{test_file} #{TESTOPTS} #{instance} #{network_slug} #{browser} --name /test_p1/; true" 
    end
  end
  end
end

def show_directions
  require 'yaml'
  config = YAML.load_file(File.expand_path(File.dirname(__FILE__) + "/config/config.yml"))
  valid_instances = config["env"]
  message = ["\nYou must specify an instance and a network_slug"]
  message << "USAGE: rake watir:test instance network_slug [browser]"
  message << "Valid instances and slugs from config/config.yml\n"
  valid_instances.each do |key, value|
    message << key.upcase
    value.keys.each do |slug|
      if key == "local"
        message << "rake 'watir:test[#{key},#{slug},chrome]'"
      else
        message << "rake 'watir:test[#{key},#{slug},BROWSER]'"
      end
    end
    message << ""
  end

  message << "Here are the brower strings that are supported:"
  message << "firefox ie chrome chrome-proxy headless ghostdriver"

  message << "\n\n"

  fail message.join("\n")


end

Rake::TestTask.new do |t|
  t.libs << "."
  t.test_files = FileList['test/page/*_test.rb']
  t.verbose = true
end

namespace :watir2 do
  desc 'Run watir tests'
  task :test, :landscape, :slug, :browser, :prio do |t, args|
    raise "no landscape specified" unless args[:landscape]
    ENV['WATIR_LANDSCAPE'] = args[:landscape]
    raise "no network specified" unless args[:slug]
    ENV['WATIR_SLUG'] = args[:slug]
    raise "no browser specified" unless args[:browser]
    ENV['WATIR_BROWSER'] = args[:browser]
    ENV['WATIR_PRIO'] = args[:prio] if args[:prio]
    Rake::Task[:test].invoke
  end
end

namespace :API do
  desc 'Run All API tests - for single run: LANDSCAPE=local version=2 SLUG=nike rspec test/api/v2/topic_test.rb'
  task :test, :landscape, :slug, :threads, :version do |t, args|
    raise "no landscape specified" unless args[:landscape]
    ENV['LANDSCAPE'] = args[:landscape]
    raise "no network specified" unless args[:slug]
    ENV['SLUG'] = args[:slug]
    ENV['THREADS'] = args[:threads]
    ENV['VERSIONS'] = args[:version]
    sh 'LANDSCAPE=' + args[:landscape] + ' SLUG=' + args[:slug] + ' rspec test/api/isolate/oauth_token_test.rb'
    sh 'LANDSCAPE=' + args[:landscape] + ' SLUG=' + args[:slug] + ' rspec test/api/isolate/recent_posts_test.rb' if args[:version] == "2"
    sh 'parallel_rspec -n ' + args[:threads] + ' test/api/v'+args[:version]+'/*_test.rb'
  end
end

#
# namespace :test2 do
#   desc 'Run watir tests'
#   task :watir, :landscape, :slug, :browser do |t, args|
#     require 'byebug'
#     byebug
#     landscape = args[:landscape]
#     slug = args[:slug]
#     browser = args[:browser]
#     Rake::Task[:test].invoke
#   end
# end
