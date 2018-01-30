require File.expand_path(File.dirname(__FILE__) + "/page_object.rb")
class HybrisLoginPageObject < PageObject

  def initialize(browser)
    super
    @login = {
    	:email => @browser.text_field(:id => "j_username"),
    	:password => @browser.text_field(:id => "j_password"),
    	:sumbit => @browser.button(:type => "submit", :text => "Login")
    }
    @register ={
    }

  end

  def login(user)
    @login[:email].when_present.set user[0]
    @login[:password].when_present.set user[1]
    @login[:sumbit].when_present.click
    wait_for_page
  end

  def check_reviews
    @browser.wait_until{ @reviewContent.div(:class => "oneReview").exists? }
  end
  
end