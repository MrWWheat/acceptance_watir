require File.expand_path(File.dirname(__FILE__) + "/page_object.rb")
class HybrisHomePageObject < PageObject

  def initialize(browser)
    super
    @url = $base_url
    @popularQuestions = @browser.div(:id => "homepage-widget-addon-question")
    @popularReviews = @browser.div(:id => "homepage-widget-addon-review")
    @questionContent = @popularQuestions.div(:id => /Excelsior-Controller-HomePageQuestion/)
    @reviewContent = @popularReviews.div(:id => /Excelsior-Controller-HomePageReview/)

    @first_item_title = @browser.div(:class => "e-post-title ellipsis")
    @first_item_content = @browser.div(:class => "e-post-content")

  end

  def open
    @browser.goto @url
  end

  def check_questions
    @browser.wait_until{ @questionContent.exists? }
    @browser.wait_until{ @questionContent.div(:class => "e-post cols e-post-homepage").exists? }
  end

  def check_reviews
    @browser.wait_until{ @reviewContent.div(:class => "e-post cols e-post-homepage").exists? }
  end

  def go_to_first_review
    check_reviews
    link = @reviewContent.link(:index =>1)
    @browser.execute_script('arguments[0].scrollIntoView();', link)
    link.when_present.click
    @browser.wait_until{ @browser.windows.size > 1 }
    @browser.windows.last.use
    sleep 8 # wait for community js load
  end 

  def check_font_size font
    @browser.wait_until{ @first_item_content.present? }
    assert @first_item_title.style('font-size') == font, "expect font size #{font}, but got font size #{@first_item_title.style('font-size')}"
    assert @first_item_content.style('font-size') == font, "expect font size #{font}, but got font size #{@first_item_content.style('font-size')}"
  end
end