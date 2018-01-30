# Before you copy/paste this code, ask yourself: do i know what files i am including?
# Do i actually need to include these files?
#  What if someone puts a file in that directory that i don't expect or don't want?
#  whose fault is it that it breaks? the person who put the file in a reasonable place, or the person who included it blindly?

require File.expand_path(File.dirname(__FILE__) + "/topic_page.rb")
require File.expand_path(File.dirname(__FILE__) + "/conversation_page.rb")
require File.expand_path(File.dirname(__FILE__) + "/admin_page.rb")
require File.expand_path(File.dirname(__FILE__) + "/superadmin_page.rb")
Dir[File.expand_path(File.dirname(__FILE__)+"/page_objects/*.rb")].each do |file|
  require file 
end

#Dir[File.expand_path(File.dirname(__FILE__)+"/*.rb")].each do |file|
#  require file unless file =~ /api_helper|watir_config|watir_test|lazy_dsl_tag_collector/
#end

module WatirLib

  if ENV["USE_FIXTURES"]
    def deprecate(method, message)
      puts "DEPRECATION WARNING: #{method}: #{message}"
    end
    
    Fixtures.load

    %w(topics users conversations posts).each do |method_name|
      define_method method_name do |*args|      
        Fixtures.find(method_name, *args)
      end
    end
  end
  
  include TopicPage
  include ConversationPage
  include AdminPage
  include SuperAdminPage
end