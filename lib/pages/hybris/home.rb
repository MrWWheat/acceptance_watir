require 'pages/hybris'

class Pages::Hybris::Home < Pages::Hybris
  
  def initialize(config, options = {})
    super(config)
    @url = config.hybris_url
  end

  popular_questions       { div(:id => "homepage-widget-addon-question") }
  popular_reviews         { div(:id => "homepage-widget-addon-review") }
  question_content        { div(:id => /Excelsior-Controller-HomePageQuestion/) }
  review_content          { div(:id => /Excelsior-Controller-HomePageReview/) }

  first_question_title    { div(:id => /Excelsior-Controller-HomePageQuestion/).div(:class => "e-post-title ellipsis") }
  first_question_content  { div(:id => /Excelsior-Controller-HomePageQuestion/).div(:class => "e-post-content") }

  first_review_title      { div(:id => /Excelsior-Controller-HomePageReview/).div(:class => "e-post-title ellipsis") }
  first_review_content    { div(:id => /Excelsior-Controller-HomePageReview/).div(:class => "e-post-content") }

  def start!(user)
    super(user, @url, excelsior_homepage)
  end

  def check_questions
    @browser.wait_until{ question_content.exists? }
    @browser.wait_until{ question_content.div(:class => "e-post-homepage").exists? }
  end

  def check_reviews
    @browser.wait_until{ review_content.present? }
    @browser.wait_until{ review_content.div(:class => "e-post-homepage").exists? }
  end

  def check_font_size font
    @browser.wait_until{ first_item_content.present? }
    assert first_item_title.style('font-size') == font, "expect font size #{font}, but got font size #{@first_item_title.style('font-size')}"
    assert first_item_content.style('font-size') == font, "expect font size #{font}, but got font size #{@first_item_content.style('font-size')}"
  end

  def list(category=nil, sub_category=nil)
    if category && sub_category
      root = navigation_bar.li(:class => "La  auto parent", :text => /#{category}/)
      root.when_present.hover
      root.link(:text => /#{sub_category}/).when_present.click
    elsif category
      navigation_bar.li(:class => "La  auto", :text => /#{category}/).when_present.click
    else
      navigation_bar.li(:class => "La  auto", :index => 0).when_present.click
    end
  end

  def go_to_first_review
    check_reviews
    link = review_content.link(:index =>1)
    scroll_to_element link
    link.when_present.click
    @browser.wait_until{ @browser.windows.size > 1 }
    @browser.windows.last.use
  end 
end