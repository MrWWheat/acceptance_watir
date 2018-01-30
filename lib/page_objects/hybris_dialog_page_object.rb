require File.expand_path(File.dirname(__FILE__) + "/page_object.rb")
class HybrisDialogPageObject < PageObject

  def initialize(browser)
    super
    @login = {
    	:username => @browser.text_field(:id => "login-username"),
    	:password => @browser.text_field(:id => "login-password"),
    	:sumbit => @browser.button(:id => "logonbtn")
    }

    @social_facebook = @browser.link(:id => "social_facebook")
    @social_twitter = @browser.link(:id => "social_twitter")
    @social_linkedin = @browser.link(:id => "social_linkedin")
    @social_google = @browser.link(:id => "social_google")

    @review_title = @browser.text_field(:id => "reviewArea-Titletext0")
    @review_content = @browser.text_field(:id => "reviewArea-Detailstextarea1")
    @review_recommand_yes = @browser.input(:id => "recommended-yes")
    @review_recommand_no = @browser.input(:id => "recommended-no")
    @review_sumbit = @browser.button(:id => "review-area-submitForm")

    @question_title = @browser.text_field(:id => "question-area-title")
    @question_content = @browser.text_field(:id => "question-area-description")
    @question_sumbit = @browser.button(:id => "question-area-submitForm")

    @cancel = @browser.button(:id => "excelsior-close-modal-button")

    @star = [
    	@browser.label(:for => "star1", :class => "full"),
    	@browser.label(:for => "star2", :class => "full"),
    	@browser.label(:for => "star3", :class => "full"),
    	@browser.label(:for => "star4", :class => "full"),
    	@browser.label(:for => "star5", :class => "full")
    ]

    @close = @browser.button(:class => "mfp-close")

    @review_warning = @browser.div(:text => /Welcome back/)

  end

  def close
    @close.when_present.click
  end

  def has_login?
    !@browser.div(:id => "excelsior-login").present?
  end

  def check_loaded
    @browser.wait_until{ @browser.div(:class => "mfp-content").present? }
  end

  def login(user)
    if !has_login?
      @login[:username].when_present.set user[0]
      @login[:password].when_present.set user[1]
      @login[:sumbit].when_present.click
      wait_for_page
    end
  end

  def social_login(type,social_user)
    if type == :facebook
      @social_facebook.when_present.click
      @browser.wait_until{ @browser.windows.last.use.url.include? ("facebook.com/login.php?")}
      sleep 2
      @browser.text_field(:id => "email").when_present.set social_user[0]
      @browser.text_field(:id => "pass").when_present.set social_user[1]
      @browser.button(:type => "submit" , :value => "Log In").when_present.click
      # load chicago
      @browser.wait_until{ @browser.div(:class => "topics")}
      sleep 5
      @browser.windows.last.use.url
    end

    if type == :twitter
      @social_twitter.when_present.click
      @browser.wait_until{ @browser.windows.last.use.url.include? ("twitter.com/oauth/authenticate?")}
      @browser.text_field(:id => "username_or_email").when_present.set social_user[0]
      @browser.text_field(:id => "password").when_present.set social_user[1]
      @browser.input(:type => "submit" , :value => "Sign In").when_present.click
      #for window close error
      sleep 5
      @browser.windows.last.use.url
    end

    if type == :linkedin
      @social_linkedin.when_present.click
      @browser.wait_until{ @browser.windows.last.use.url.include? ("linkedin.com/uas/oauth/authorize?")}
      @browser.text_field(:id => "session_key-oauthAuthorizeForm").when_present.set social_user[0]
      @browser.text_field(:id => "session_password-oauthAuthorizeForm").when_present.set social_user[1]
      @browser.input(:type => "submit" , :value => "Allow access").when_present.click
      sleep 5
      @browser.windows.last.use.url
    end

    if type == :google
      @social_google.when_present.click
      @browser.url.include? ("accounts.google.com/ServiceLogin?")
      @browser.text_field(:id => "Email").when_present.set social_user[0]
      @browser.text_field(:id => "Passwd").when_present.set social_user[1]
      @browser.input(:type => "submit" , :value => "Sign in").when_present.click

      accept = @browser.button(:id => "submit_approve_access")
      @browser.wait_until($t) {
        accept.present? && !accept.attribute_value("disabled") #accept button is disabled initially, therefore waiting for it to be not disabled anymore
      }
      accept.when_present.click
    end
    @browser.wait_until{ @close.present? }
  end

  def create_review(rating,title,content)
    create_review_content(rating, title,content)
  end

  def create_question (title,content)
  	create_quesion_content(title, content)
  end

  private
  def create_review_content(rating, title,content)
    @star[rating - 1].when_present.click
    @review_title.when_present.set title
   	# @browser.execute_script('$("div.note-editable").text("'+content+'")')
   	@review_content.when_present.set content
    @review_recommand_yes.when_present.click
   	@review_sumbit.when_present.click
   	check_create(title,content)
  end

  def create_quesion_content(title,content)
    @question_title.when_present.set title
    # @browser.execute_script('$("div.note-editable").text("'+content+'")')
    @question_content.when_present.set content
    # wait for similar question sugguestion ready
    sleep 3
    @question_sumbit.when_present.click
    check_create(title,content)
  end

  def check_create(title,content)
  	wait_for_page
  	@browser.wait_until{ @browser.p(:class => "e-post-title ellipsis", :text => /#{title}/).exists? }
  	@browser.wait_until{ @browser.div(:class => "e-post-content", :text => /#{content}/).exists? }
  end
end