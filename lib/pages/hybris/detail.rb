require 'pages/hybris'

class Pages::Hybris::Detail < Pages::Hybris

	def initialize(config, options = {})
    super(config)
    @url=config.hybris_url
  end

  loading_spinner                     { div(:class => "excelsior-loading") }
  most_recent_review									{ div(:id => /ex-panel-review/) }
  most_recent_review_title_field      { p(:css => "#ex-panel-review .e-post-title") }
  most_recent_review_content_field    { div(:css => "#ex-panel-review .e-post-content") }
  to_be_first_review_link						  { div(:id => "e-review-first") }
  read_all_reviews_link								{ div(:id => "ex-panel-review").link(:id => "e-panel-footer-read-all-reviews") }
  write_review_link                   { div(:id => "ex-panel-review").link(:id => "e-panel-footer-write-review") }
  product_name                        { div(:class => "name")}

  most_recent_question								{ div(:id => "ex-panel-question") }
  most_recent_question_title_field    { p(:css => "#ex-panel-question .e-post-title") }
  most_recent_question_content_field  { div(:css => "#ex-panel-question .e-post-content") }
  to_be_first_question_link						{ div(:id => "e-question-first") }
  read_all_questions_link							{ div(:id => "ex-panel-question").link(:id => "e-panel-footer-read-all-questions") }
  write_question_link									{ div(:id => "ex-panel-question").link(:id => "e-panel-footer-ask-question") }

  recent_review_title									{ div(:id => /Excelsior-Controller-SimpleReview/).p(:class => "e-post-title") }
  recent_question_title								{ div(:id => /Excelsior-Controller-SimpleQuestion/).p(:class => "e-post-title") }

  tabs																{ div(:css => ".tabs.js-tabs.tabs-responsive") }
  question_tab												{ link(:id => "tab_qa") }
  review_tab													{ link(:id => "tab_review") }
  blog_tab														{ link(:id => "tab_blog") }
  discussion_tab											{ link(:id => "tab_discussion") }
  active_tab_head                     { link(:css => "div.tabs ul.tabs-list .active a") }

  question_tab_body                   { div(:id => "tabBody_qas") }
  review_tab_body                     { div(:id => "tabBody_reviews") }
  blog_tab_body                       { div(:id => "tabBody_blogs") } 
  discussion_tab_body                 { div(:id => "tabBody_discussions") }

  write_review_btn                    { button(:id => "excelsior-write-review") }
  ask_question_btn                    { button(:id => "excelsior-ask-question") }

  review_tab_select_list              { select(:css => "#Excelsior-Controller-ReviewTab-ex-reviews select") }
  question_tab_select_list            { select(:css => "#Excelsior-Controller-QuestionTab-ex-questions select") }

  pagination_next_btn_in_active_tab   { li(:css => ".tabs .tabhead.active + .tabbody .excelsior-page-bar .next") }
  pagination_prev_btn_in_active_tab   { li(:css => ".tabs .tabhead.active + .tabbody .excelsior-page-bar .prev") }

  # review modal
  review_modal                        { div(:id => "rw-write-review") }
  review_title_field                  { text_field(:id => "reviewArea-Titletext0") }
  review_description_field            { textarea(:id => "reviewArea-Detailstextarea1") }
  review_submit_btn                   { button(:id => "review-area-submitForm") }
  review_cancel_btn                   { button(:id => "excelsior-close-modal-button") }

  review_recommand_yes                { input(:id => "recommended-yes") }
  review_recommand_no                 { input(:id => "recommended-no") }

  # question modal
  question_modal                      { div(:id => "as-ask-question") }
  question_title_field                { text_field(:id => "question-area-title") }
  question_description_field          { textarea(:id => "question-area-description") }
  question_submit_btn                 { button(:id => "question-area-submitForm") }
  question_cancel_btn                 { button(:id => "excelsior-close-modal-button") }

  current_tab_body										{ div(:xpath => "//div[@class='tabBody'][@style='display: block\;']") }
  sort_div														{ div(:xpath => "//div[@class='tabBody'][@style='display: block\;']").div(:class => /toolbar-list-sort/) }
  sort																{ div(:xpath => "//div[@class='tabBody'][@style='display: block\;']").div(:class => /toolbar-list-sort/).select_list }
	list_first_item											{ div(:xpath => "//div[@class='tabBody'][@style='display: block\;']").div(:class => "e-post", :index =>0) }
	list_first_item_link								{ div(:xpath => "//div[@class='tabBody'][@style='display: block\;']").div(:class => "e-post", :index =>0).div(:class => "e-post-message").link }
  paging															{ div(:xpath => "//div[@class='tabBody'][@style='display: block\;']").ul(:class => "pagination") }
  show_more_answers										{ p(:class => "e-more-answer") }

  error_msg														{ div(:id => "qaTab-error-message") }

  productDetails											{ div(:class => "productDetailsPanel") }

  login_modal                         { div(:id => "excelsior-login")}
  login_username                      { text_field(:id => "login-username")}
  login_password                      { text_field(:id => "login-password")}
  login_sumbit                        { button(:id => "logonbtn")}

  dialog_modal                        { div(:class => "mfp-content") }

  prod_already_reviewed_dlg           { div(:id => "excelsior-message") }

  socail_login_modal                  { div(:id => "social") }
  facebook_login                      { link(:id => "social_facebook") }
  twitter_login                       { link(:id => "social_twitter") }
  linkedin_login                      { link(:id => "social_linkedin") }
  google_login                        { link(:id => "social_google") }

  def nav_to_review_tab
    review_tab.when_present.click
    sleep 3
    @browser.wait_until { write_review_btn.visible? }
  end

  def nav_to_question_tab
    question_tab.when_present.click
    sleep 3
    @browser.wait_until { ask_question_btn.visible? }
  end

  def rate(rating=5)
    case rating
    when 5
      @browser.label(:for => "star5").when_present.click
    when 4
      @browser.label(:for => "star4").when_present.click
    when 3
      @browser.label(:for => "star3").when_present.click
    when 2
      @browser.label(:for => "star2").when_present.click
    when 1
      @browser.label(:for => "star1").when_present.click
    else 
      raise "Invalid rating #{rating}!"
    end
  end

  def recommended(opt=true)
    if opt
      review_recommand_yes.when_present.click
    end
  end

  def get_review_uuid_by_title(title)
    most_recent_review.div(:class => "e-post-message").link.href.match(/\/review\/(\w+)\//)[1]
  end
  
  def social_login_nomapped type
    @browser.wait_until($t) {most_recent_review.present?}
    write_question_link.when_present.click
    @browser.wait_until($t) {socail_login_modal.present?}
    socail_login type
  end

  def socail_login type
    case type
      when :facebook
        facebook_login.when_present.click
      when :twitter
        twitter_login.when_present.click
      when :linkedin
        linkedin_login.when_present.click
      when :google
        google_login.when_present.click
    end
  end

  def has_login?
    @browser.wait_until{ dialog_modal.present? }
    !login_modal.present?
  end

  def login_community(user)
    if !has_login?
      login_username.when_present.set user.email
      login_password.when_present.set user.password
      login_sumbit.when_present.click
      @browser.wait_until { review_modal.visible? || question_modal.visible? }
    end
  end

  def create_review(rating:5, title:"title-#{Time.now.to_i.to_s}", desc:"description-#{Time.now.to_i.to_s}", recommended:false)
    @browser.wait_until{ review_modal.present? }

    rate(rating)
    review_title_field.when_present.set title
    review_description_field.when_present.set desc
    recommended(recommended)
    review_submit_btn.when_present.click

    @browser.wait_until { !review_modal.visible? && most_recent_review.when_present.p(:class => "e-post-title").present?}
    @browser.wait_until(60) { most_recent_review.when_present.p(:class => "e-post-title").when_present.text == title }
  end

  def create_question(title:"title-#{Time.now.to_i.to_s}", desc:"description-#{Time.now.to_i.to_s}")
    @browser.wait_until { question_modal.present? }

    question_title_field.when_present.set title
    question_description_field.when_present.set desc
    question_submit_btn.when_present.click

    @browser.wait_until { !question_modal.visible? && most_recent_question.when_present.p(:class => "e-post-title").present?}
    @browser.wait_until(60) { most_recent_question.when_present.p(:class => "e-post-title").when_present.text == title }
  end

  def go_to_community_by_review
    most_recent_review.when_present.p(:class => "e-post-title").when_present.click
  end
  # def check_detail_desc product_hint
  #   @browser.wait_until($t) { productDetails.present? }
  #   # @browser.wait_until($t) { productDetails.h1.text.include? product_hint }
  #   check_loaded
  # end

  # def check_loaded
  #   @browser.wait_until{ most_recent_review.present? }
  #   @browser.wait_until{ most_recent_question.present? }
  #   @browser.wait_until{ tabs.present? }
  # end

  def click_read_all_reviews_link
    # Turn off animation effect applied to tabs first when click "Read all Reviews" or "Read all Q/As" link
    # so that ui actions won't be blocked by the animation.
    # e.g. "Read all Reviews" link is not clickable when click it and animation is not complete.
    @browser.execute_script("if (!$.fx.off) $.fx.off = true;") 
    read_all_reviews_link.when_present.click
    @browser.wait_until { tab_active?(:review) }
    @browser.wait_until { review_tab_body.present? }
  end 

  def click_read_all_questions_link
    # Turn off animation effect applied to tabs first when click "Read all Reviews" or "Read all Q/As" link
    # so that ui actions won't be blocked by the animation.
    # e.g. "Read all Reviews" link is not clickable when click it and animation is not complete.
    @browser.execute_script("if (!$.fx.off) $.fx.off = true;") 

    read_all_questions_link.when_present.click
    @browser.wait_until { tab_active?(:question) }
    @browser.wait_until { question_tab_body.present? }
  end

  def tab_active?(tab)
    case tab
    when :review
      review_tab.parent.attribute_value("class").include?("active") 
    when :question
      question_tab.parent.attribute_value("class").include?("active") 
    when :blog
      blog_tab.parent.attribute_value("class").include?("active") 
    when :discussion
      discussion_tab.parent.attribute_value("class").include?("active") 
    else
      raise "Current tab #{tab} is not supported yet"
    end
  end 

  def sort(tab, order)
    order_v = nil
    case order
    when :oldest
      order_v = "CreatedAt+asc"
    when :newest
      order_v = "CreatedAt+desc"
    when :most_reply
      order_v = "ReplyCount+desc"
    when :least_reply
      order_v = "ReplyCount+asc"
    else
      raise "Order #{order} is not supported in the current tab"
    end  

    # Wait until the order select is present in the active tab     
    @browser.wait_until { get_order_select_in_tab(tab).present? }

    number = get_items_number_in_tab(tab)

    if number.nil? || number == 0
      puts "Number in the tab header of #{tab} is #{number}"
      @config.screenshot!("no_list_for_sort_in_detail_tab_" + Time.now.to_s)
    end  

    # When number equal nil, there might be some problems happening.
    # Ignore the number check at that time
    if number.nil? || number > 0 
      if get_order_select_in_tab(tab).value != order_v
        first_item_href_pre = get_first_item_in_tab(tab).href
        get_order_select_in_tab(tab).select_value(order_v)

        if number != 1
          @browser.wait_until {  get_first_item_in_tab(tab).href != first_item_href_pre }
        end  
      end 
    end 
  end 

  def get_tab_body_css(tab)
    tab_body_css = nil
    case tab
    when :review
      tab_body_css = "#tabBody_reviews"
    when :question
      tab_body_css = "#tabBody_qas"
    when :blog
      tab_body_css = "#tabBody_blogs"
    when :discussion
      tab_body_css = "#tabBody_discussions"
    end

    tab_body_css
  end

  def get_order_select_in_tab(tab)
    @browser.select(:css => "#{get_tab_body_css(tab)} .toolbar-list-sort select")
  end  

  def get_first_item_in_tab(tab)
    @browser.link(:css => "#{get_tab_body_css(tab)} .e-list .e-post .e-post-message a").when_present
  end

  def get_items_number_in_tab(tab)
    tab_head_text = nil
    case
    when :review
      tab_head_text = review_tab.when_present.text
    when :question
      tab_head_text = question_tab.when_present.text
    when :blog
      tab_head_text = blog_tab.when_present.text
    when :discussion
      tab_head_text = discussion_tab.when_present.text
    end

    # Sometimes, the tab head title doesn't contain item numbers. This might be caused by any of these reasons:
    # a) Bug EN-2174
    # b) Some unknown reason which only happen during automation testing.
    tab_head_text[/\d+/].nil? ? nil : tab_head_text[/\d+/].to_i
  end 

  def paging_in_tab(tab, paging_option)
    @browser.wait_until { @browser.ul(:css => "#{get_tab_body_css(tab)} .e-list").present? }
    
    first_item_href_pre = get_first_item_in_tab(tab).href 

    if paging_option == :next
      pagination_next_btn_in_active_tab.when_present.click
    elsif paging_option == :prev
      pagination_prev_btn_in_active_tab.when_present.click
    else
      #TODO: 
      raise "Illegal parameter #{paging_option}"
    end  
    
    @browser.wait_until { get_first_item_in_tab(tab).href !=  first_item_href_pre }      
  end

  # Get the css selector for the question at index from the question item list in the question tab.
  # index is starting from 0.
  def get_question_css_at_index(index)
    "#tabBody_qas .e-list > li:nth-child(#{index+1}) "
  end

  def get_question_vote_num_at_index(index)
    vote_number_css = get_question_css_at_index(index) + ".e-post-vote span"
    @browser.span(:css => vote_number_css).when_present.text.to_i
  end 

  def vote_question_at_index_for_user(index, vote_option, first_time=true, user=nil)
    vote_up_icon_css = get_question_css_at_index(index) + ".e-post-vote .icon-up"
    vote_down_icon_css = get_question_css_at_index(index) + ".e-post-vote .icon-down"
    
    old_num_before_vote = get_question_vote_num_at_index(index)

    if vote_option == :up
      expected_new_vote_num = old_num_before_vote + 1
      @browser.i(:css => vote_up_icon_css).when_present.click
    elsif vote_option == :down
      expected_new_vote_num = old_num_before_vote - 1
      @browser.i(:css => vote_down_icon_css).when_present.click
    else
      raise "Illegal parameter #{vote_option}" 
    end

    login_community(user) unless user.nil?

    if first_time
      @browser.wait_until { get_question_vote_num_at_index(index) == expected_new_vote_num }
    else
      @browser.wait_until { error_msg.visible? } 
    end  
  end

  def get_more_answers_current_num_at_index(index)
    num_pair = @browser.p(:css => get_question_css_at_index(index) + ".e-more-answer").when_present.text
    current_num = num_pair[/\d+/].to_i
  end

  def get_more_answers_total_num_at_index(index)
    num_pair = @browser.p(:css => get_question_css_at_index(index) + ".e-more-answer").when_present.text
    total_num = num_pair[/\/\s\d+/][/\d+/].to_i
  end  

  def click_show_more_answers_at_index(index)
    show_more_answers_css = get_question_css_at_index(index) + ".e-more-answer"

    @browser.wait_until { @browser.p(:css => show_more_answers_css).exists? }

    num_diff_before_click = get_more_answers_total_num_at_index(index) - get_more_answers_current_num_at_index(index)
    
    @browser.p(:css => show_more_answers_css).when_present.click

    if num_diff_before_click == 0
      # All anwsers are shown. Nothing will happen when click Show more answers link.
      return
    else
      # At most 5 more anwsers will be shown for once click
      expected_new_added_num = num_diff_before_click >= 5 ? 5 : num_diff_before_click
      @browser.wait_until { (get_more_answers_total_num_at_index(index) - get_more_answers_current_num_at_index(index)) \
      == (num_diff_before_click - expected_new_added_num) }
    end
  end

  def click_show_more_answers_to_end_at_index(index)
    times_at_most =  get_more_answers_total_num_at_index(index) / 5 + 1

    until get_more_answers_total_num_at_index(index) == get_more_answers_current_num_at_index(index) do
      click_show_more_answers_at_index(index)

      times_at_most = times_at_most - 1
      # Break to avoid indefinite call when some unknown error happen
      break if times_at_most < 0
    end  
  end

  def switch_to_tab(tab)
    case tab
    when :review
      review_tab.when_present.click
      @browser.wait_until { review_tab_body.present? }
    when :question
      question_tab.when_present.click
      @browser.wait_until { question_tab_body.present? }
    when :blog
      blog_tab.when_present.click
      @browser.wait_until { blog_tab_body.present? }
    when :discussion
      discussion_tab.when_present.click 
      @browser.wait_until { discussion_tab_body.present? }
    end
  end

  def review_widget_empty?
    to_be_first_review_link.present?
  end
  
  def question_widget_empty?
    to_be_first_question_link.present?
  end

  def go_to_recent_review
    most_recent_review_title_field.when_present.click

    @browser.wait_until{ @browser.windows.size > 1 }
    @browser.windows.last.use
    # sleep 8
  end
  
  def go_to_recent_question
    most_recent_question_title_field.when_present.click

    @browser.wait_until{ @browser.windows.size > 1 }
    @browser.windows.last.use
    # sleep 8
  end  

  def get_review_uuid_from_prod_already_reviewed_dlg
    prod_already_reviewed_dlg.link.href.match(/\/review\/(\w+)\//)[1]
  end 

  # def check_detail_desc product_hint
  #   @browser.wait_until{ productDetails.present? }
  #   @browser.wait_until{ productDetails.h1.text.include? product_hint }
  #   check_loaded
  # end

  # def go_to_review
  #   check_loaded
  #   recent_review_title.when_present.click
  #   @browser.wait_until{ @browser.windows.size > 1 }
  #   @browser.windows.last.use
  #   sleep 8 # wait for community js load
  # end

  # def go_to_question
  #   check_loaded
  #   recent_question_title.when_present.click
  #   @browser.wait_until{ @browser.windows.size > 1 }
  #   @browser.windows.last.use
  #   sleep 8 # wait for community js load
  # end

  # def check_recent_review(review_title=nil)
  #   check_loaded
  # 	if review_title
  # 		@browser.wait_until{ recent_review_title.text.include? review_title }
  #     mtch = recent_review_title.parent.href.match(/.*review\/(\w+)\//)[1]
  #     return mtch
  # 	else
  # 		@browser.wait_until{ no_review_link.present? }
  #     return nil
  # 	end
  # end

  # def check_recent_question(question_title=nil)
  #   check_loaded
  # 	if question_title
  # 		@browser.wait_until{ recent_question_title.text.include? question_title }
  # 	else
  # 		@browser.wait_until{ no_question_link.present? }
  # 	end
  # end

  # def read_all_reviews
  #   check_loaded
  # 	read_all_reviews_link.when_present.click
  # 	@browser.wait_until{ review_tab.span(:class => "current-info").exists? }
  # end

  # def read_all_questions
  #   check_loaded
  # 	read_all_questions_link.when_present.click
  # 	@browser.wait_until{ question_tab.span(:class => "current-info").exists? }
  # end

  # def write_review_from_snippet_link
  # 	check_loaded
  #   if has_reviews?
  #     write_review.when_present.click
  #   else
  #     no_review_link.when_present.click
  #   end
  # 	wait_for_page
  # end

  # def has_reviews?
  #   !no_review_link.present?
  # end

  # def has_questions?
  #   !no_question_link.present?
  # end

  # def ask_question_from_snippet_link
  #   check_loaded
  #   if has_questions?
  #     write_question.when_present.click
  #   else
  #     no_question_link.when_present.click
  #   end
  #   wait_for_page
  # end

  # def check_reivew_number
  #   rn1 = get_review_number
  #   s1 = review_number_sinppet.text
  #   rn2 = s[1, s.length - 2].to_i
  #   s2 = @browser.p(:class => "review-count").text
  #   rn3 = s2.partition(" ").first
  #   rn1 == rn2 && rn2 == rn3
  # end

  # def get_review_number
  #   s = review_tab.text
  #   s[/\d+/].to_i
  # end

  # def get_question_number
  #   s = question_tab.text
  #   s[/\d+/].to_i
  # end

  # def get_current_tab_number
  #   s = tabs.li(:class => "current").text
  #   s[/\d+/].to_i
  # end

  # def activate_tab(tab)
  #   if tab == :blog
  #     tab_to = blog_tab
  #   elsif tab == :discussion
  #     tab_to = discussion_tab
  #   end

  #   tab_to.when_present.click
  #   @browser.wait_until{ sort_div.present? }
  # end

  # def vote_up
  #   @browser.wait_until { list_first_item.present? }
  #   vote = list_first_item.span(:class => "e-post-vote")
  #   vote_number = vote.span(:index => 0)
  #   number = vote_number.text.to_i
  #   vote.i(:class => "sap-icon icon-up").when_present.click
  #   @browser.wait_until(120){ (number == vote_number.text.to_i - 1 ) || ( error_msg.text.include? "Twice") }
  # end

  # def vote_down
  #   @browser.wait_until { list_first_item.present? }
  #   vote = list_first_item.span(:class => "e-post-vote")
  #   vote_number = vote.span(:index => 0)
  #   number = vote_number.text.to_i
  #   vote.i(:class => "sap-icon icon-down").when_present.click
  #   @browser.wait_until(120){ (number == vote_number.text.to_i + 1 ) || ( error_msg.text.include? "Twice") }
  # end

  # def sort(order)
  #   @browser.wait_until{ sort.present? }
  #   select_list, first_item, number, order_t = nil
  #   if order == :oldest
  #     order_t = "Oldest"
  #   elsif order == :newest
  #     order_t = "Newest"
  #   elsif order == :most_reply
  #     order_t = "Most Replied"
  #   elsif order == :least_reply
  #     order_t = "Least Replied"
  #   end
  #   select_list = sort
  #   first_item = list_first_item_link
  #   number = get_current_tab_number
  #   if number != 0
  #     if select_list.selected_options[0].text != order_t
  #       first_pre = first_item.href   
  #       select_list.select order_t
  #       wait_for_page
  #       if number > 1
  #         @browser.wait_until {first_item.href != first_pre}
  #       end
  #     end
  #   else
  #     puts "No list for sort"
  #   end
  # end

  # def click_helpful
  #   @browser.wait_until { list_first_item.present? }
  #   list_first_item.button(:class => "e-post-feedback-btn e-yes").when_present.click
  #   @browser.wait_until { list_first_item.div(:class => "e-post-feedback-success").present? }
  # end

  # def paging
  #   @browser.wait_until { list_first_item.present? }
  #   first_item = list_first_item_link
  #   totalNum = get_current_tab_number
  #   pagination = paging

  #   totalPage = (totalNum.to_f/5).ceil
    
  #   if totalNum <= 5
  #     assert !pagination.li(:class=>"next").exists?
  #   else
  #     first_pre = first_item.href
  #     sleep 1 until pagination.li(:class=>"next").present?
  #     pagination.li(:class=>"next").click
  #     wait_for_page
  #     @browser.wait_until {first_item.href != first_pre}
  #     first_pre = first_item.href
  #     pagination.li(:class=>"prev").when_present.click
  #     wait_for_page
  #     @browser.wait_until {first_item.href != first_pre}
  #   end
  # end

  # def show_more_answers
  #   if show_more_answers.exists?
  #     s = show_more_answers.text
  #     currentNum = s[/\d+/].to_i
  #     totalNum = s[/\/\s\d+/][/\d+/].to_i
  #     while currentNum < totalNum do
  #       begin
  #         @browser.execute_script('arguments[0].scrollIntoView();', show_more_answers)
  #         show_more_answers.when_present.click
  #         #@browser.execute_script('$(".showMoreAnswers:first").click()')  
  #         @browser.wait_until {currentNum != show_more_answers.text[/\d+/].to_i}
  #         s = show_more_answers.text
  #         currentNum = s[/\d+/].to_i
  #         totalNum = s[/\/\s\d+/][/\d+/].to_i
  #       rescue Selenium::WebDriver::Error::StaleElementReferenceError
  #         puts "retrying to reach element"
  #         retry
  #       end
  #     end
  #     @browser.wait_until{currentNum == totalNum}
  #   else
  #     puts "no more answers"
  #   end

  # end
end