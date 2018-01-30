require_relative "./page_object"

class HybrisProductDetailPageObject < PageObject
  def initialize(browser)
    super
    @most_recent_review = @browser.div(:id => "ex-panel-review")
    @no_review_link = @browser.div(:id => "e-review-first")
    @read_all_reviews_link = @most_recent_review.link(:id => "e-panel-footer-read-all-reviews")
    @write_review = @most_recent_review.link(:id => "e-panel-footer-write-review")

    @most_recent_question = @browser.div(:id => "ex-panel-question")
    @no_question_link = @browser.div(:id => "e-question-first")
    @read_all_questions_link = @most_recent_question.link(:id => "e-panel-footer-read-all-questions")
    @write_question = @most_recent_question.link(:id => "e-panel-footer-ask-question")

    @recent_review_title = @browser.div(:id => /Excelsior-Controller-SimpleReview/).p(:class => "e-post-title")
    @recent_question_title = @browser.div(:id => /Excelsior-Controller-SimpleQuestion/).p(:class => "e-post-title")

    @tabs = @browser.div(:class => "tabs")
    @question_tab = @tabs.link(:id => "tab_qa")
    @review_tab = @tabs.link(:id => "tab_review")
    @blog_tab = @tabs.link(:id => "tab_blog")
    @discussion_tab = @tabs.link(:id => "tab_discussion")

    @show_more_answers = @browser.p(:class => "e-more-answer")

    @error_msg = @browser.div(:id => "qaTab-error-message")

    @productDetails = @browser.div(:class => "product-details")
  end

  def check_loaded
  	@browser.wait_until{ @most_recent_review.present? }
  	@browser.wait_until{ @most_recent_question.present? }
  	@browser.wait_until{ @tabs.present? }
    # changed for bug EN-2174
    # @browser.wait_until{ @review_tab.text =~ /CUSTOMER REVIEWS\(\d+\)/}
    @browser.wait_until{ @review_tab.text =~ /CUSTOMER REVIEWS/}
  end

  def check_detail_desc product_hint
    @browser.wait_until{ @productDetails.present? }
    @browser.wait_until{ @productDetails.text.include? product_hint }
    check_loaded
  end

  def go_to_review
    check_loaded
    @recent_review_title.when_present.click
    @browser.wait_until{ @browser.windows.size > 1 }
    @browser.windows.last.use
    sleep 8 # wait for community js load
  end

  def go_to_question
    check_loaded
    @recent_question_title.when_present.click
    @browser.wait_until{ @browser.windows.size > 1 }
    @browser.windows.last.use
    sleep 8 # wait for community js load
  end

  def check_recent_review(review_title=nil)
    check_loaded
  	if review_title
  		@browser.wait_until{ @recent_review_title.text.include? review_title }
      mtch = @recent_review_title.parent.href.match(/.*review\/(\w+)\//)[1]
      return mtch
  	else
  		@browser.wait_until{ @no_review_link.present? }
      return nil
  	end
  end

  def check_recent_question(question_title=nil)
    check_loaded
  	if question_title
  		@browser.wait_until{ @recent_question_title.text.include? question_title }
  	else
  		@browser.wait_until{ @no_question_link.present? }
  	end
  end

  def read_all_reviews
    check_loaded
  	@read_all_reviews_link.when_present.click
  	@browser.wait_until{ @review_tab.span(:class => "current-info").exists? }
  end

  def read_all_questions
    check_loaded
  	@read_all_questions_link.when_present.click
  	@browser.wait_until{ @question_tab.span(:class => "current-info").exists? }
  end

  def write_review_from_snippet_link
  	check_loaded
    if has_reviews?
      @write_review.when_present.click
    else
      @no_review_link.when_present.click
    end
  	wait_for_page
  end

  def has_reviews?
    !@no_review_link.present?
  end

  def has_questions?
    !@no_question_link.present?
  end

  def ask_question_from_snippet_link
    check_loaded
    if has_questions?
      @write_question.when_present.click
    else
      @no_question_link.when_present.click
    end
    wait_for_page
  end

  def check_reivew_number
    rn1 = get_review_number
    s1 = @review_number_sinppet.text
    rn2 = s[1, s.length - 2].to_i
    s2 = @browser.p(:class => "review-count").text
    rn3 = s2.partition(" ").first
    rn1 == rn2 && rn2 == rn3
  end

  def get_review_number
    s = @review_tab.text
    s[/\d+/].to_i
  end

  def get_question_number
    s = @question_tab.text
    s[/\d+/].to_i
  end

  def get_current_tab_number
    @tabs.li(:class => "active").text[/\d+/].to_i
  end

  def current_tabbody
    @browser.div(:xpath => "//div[contains(@class, 'tabhead') and contains(@class, 'active')]/following-sibling::div")
  end

  def activate_tab(tab)
    if tab == :blog
      tab_to = @blog_tab
    elsif tab == :discussion
      tab_to = @discussion_tab
    end

    tab_to.when_present.click
    @browser.wait_until { current_tabbody.div(:class => "toolbar-list-sort").present? }
  end

  def vote_up
    @browser.wait_until { current_tabbody.div(:class => "e-post", :index =>0).present? }
    vote = current_tabbody.div(:class => "e-post", :index =>0).span(:class => "e-post-vote")
    vote_number = vote.span(:index => 0)
    number = vote_number.text.to_i
    vote.i(:class => "sap-icon icon-up").when_present.click
    @browser.wait_until(120){ (number == vote_number.text.to_i - 1 ) || ( @error_msg.text.include? "Twice") }
  end

  def vote_down
    @browser.wait_until { current_tabbody.div(:class => "e-post", :index =>0).present? }
    vote = current_tabbody.div(:class => "e-post", :index =>0).span(:class => "e-post-vote")
    vote_number = vote.span(:index => 0)
    number = vote_number.text.to_i
    vote.i(:class => "sap-icon icon-down").when_present.click
    @browser.wait_until(120){ (number == vote_number.text.to_i + 1 ) || ( @error_msg.text.include? "Twice") }
  end

  def sort(order)
    @browser.wait_until { current_tabbody.div(:class => "toolbar-list-sort").present? }
    select_list, first_item, number, order_t = nil
    if order == :oldest
      order_t = "Oldest"
    elsif order == :newest
      order_t = "Newest"
    elsif order == :most_reply
      order_t = "Most Replied"
    elsif order == :least_reply
      order_t = "Least Replied"
    end
    select_list = current_tabbody.div(:class => "toolbar-list-sort").select_list
    first_item = current_tabbody.div(:class => "e-post", :index =>0).div(:class => "e-post-message").link
    # Comment the number check for now because of the bug EN-2174
    # number = get_current_tab_number
    # if number != 0
      if select_list.selected_options[0].text != order_t
        first_pre = first_item.href   
        select_list.select order_t
        wait_for_page
        # if number > 1
          @browser.wait_until {first_item.href != first_pre}
        # end
      end
    # else
    #   puts "No list for sort"
    # end
  end

  def click_helpful
    @browser.wait_until { current_tabbody.div(:class => "e-post", :index =>0).present? }
    current_tabbody.div(:class => "e-post", :index =>0).button(:class => "e-post-feedback-btn e-yes").when_present.click
    @browser.wait_until { current_tabbody.div(:class => "e-post", :index =>0).div(:class => "e-post-feedback-success").present? }
  end

  def paging
    @browser.wait_until { current_tabbody.div(:class => "e-post", :index =>0).present? }
    first_item = current_tabbody.div(:class => "e-post", :index =>0).div(:class => "e-post-message").link
    # totalNum = get_current_tab_number
    pagination = current_tabbody.ul(:class => "pagination")

    # totalPage = (totalNum.to_f/5).ceil
    
    # Comment the number check for now because of the bug EN-2174
    # if totalNum <= 5
    #   assert !pagination.li(:class=>"next").exists?
    # else
      first_pre = first_item.href
      pagination.li(:class=>"next").when_present.click
      wait_for_page
      @browser.wait_until {first_item.href != first_pre}
      first_pre = first_item.href
      pagination.li(:class=>"prev").when_present.click
      wait_for_page
      @browser.wait_until {first_item.href != first_pre}
    # end
  end

  def show_more_answers
    if @show_more_answers.exists?
      s = @show_more_answers.text
      currentNum = s[/\d+/].to_i
      totalNum = s[/\/\s\d+/][/\d+/].to_i
      while currentNum < totalNum do
        begin
          @browser.execute_script('arguments[0].scrollIntoView();', @show_more_answers)
          @show_more_answers.when_present.click
          #@browser.execute_script('$(".showMoreAnswers:first").click()')  
          @browser.wait_until {currentNum != @show_more_answers.text[/\d+/].to_i}
          s = @show_more_answers.text
          currentNum = s[/\d+/].to_i
          totalNum = s[/\/\s\d+/][/\d+/].to_i
        rescue Selenium::WebDriver::Error::StaleElementReferenceError
          puts "retrying to reach element"
          retry
        end
      end
      @browser.wait_until{currentNum == totalNum}
    else
      puts "no more answers"
    end

  end
end