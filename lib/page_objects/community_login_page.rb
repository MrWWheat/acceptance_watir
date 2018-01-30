require File.expand_path(File.dirname(__FILE__) + "/page_object.rb")

class CommunityLoginPage < PageObject
 
  attr_accessor :login_body, 
  :register_body, 
  :login_password_field, 
  :login_user_field, 
  :login_username_placeholder, 
  :login_password_placeholder, 
  :login_login_button, 
  :login_page_title, 
  :username_dropdown, 
  :password_reset_page, 
  :forgot_password_captcha, 
  :login_facebook_button, 
  :login_twitter_button, 
  :login_linkedin_button, 
  :login_gmail_button,
  :login_page_register_text, 
  :faq_body, 
  :login_page_faq_text, 
  :confirm_body, 
  :register_page_title, 
  :register_page_username,
  :register_page_password, 
  :register_page_email, 
  :register_page_captcha_code, 
  :register_page_register_button, 
  :register_page_signin_text, 
  :register_page_faq_text, 
  :invalid_login, 
  :account_comp_name, 
  :account_first_name, 
  :account_last_name, 
  :account_email_name, 
  :account_job_title, 
  :account_bio, 
  :signout_link, 
  :topnav_signin, 
  :topnav_notification, 
  :policy_warning, 
  :policy_warning_primary_button, 
  :username, 
  :register, 
  :signin_link, 
  :dropdown_open,
  :signin_page, 
  :register_page, 
  :topnav, 
  :login_link, 
  :caret, 
  :caret_dropdown, 
  :login_url, 
  :login_page,
  :login_submit,
  :account_user_name

  def initialize(browser)
    super
    @topnav = @browser.div(:class => "navbar topbar-nav")
    @signin_link = @browser.link(:class => "login ember-view login", :href => /sign_in/)
    @register_link = @browser.link(:class => "login ember-view login", :href => /sign_up/)
    @register_body = @browser.div(:class => "row signup-subheading")
    @login_page_title = @browser.div(:class => "col-lg-offset-2 col-md-offset-1 col-md-8 signin-header", :text => /Sign In to/) # "#{$network}"/)
    @login_body = @browser.div(:class => "row signin-body")

    @login_user_field = @browser.text_field(:id => "member_login")
    @login_password_field = @browser.text_field(:id => "member_password")
    @login_login_button = @browser.input(:class => "btn btn-primary", :value => "Sign in")
    @login_submit = @browser.button(:type => "submit")

    @username_dropdown = @browser.link(:class => "dropdown-toggle profile")
    @username = @browser.link(:class => "dropdown-toggle username")
    @dropdown_open = @browser.div(:class=>"dropdown open").ul(:class => "dropdown-menu dropdown-menu-right")

    @login_username_placeholder = @browser.input(:placeholder => "Enter Username or Email")
    @login_password_placeholder = @browser.input(:placeholder => "Enter Password")

    @login_forgot_password_link = @browser.link(:class => "forgot-password-text ember-view forgot-password-text")
    @password_reset_page = @browser.div(:class => "container member-reset-password-page")
    @login_page_register_link = @browser.link(:class => "ember-view", :text => "Register.")
    @login_page_register_text = @browser.div(:class => "row signin-links signin-links-1").div(:class => "col-md-12")
    @login_page_faq_link = @browser.link(:class => "ember-view", :text => "Review our FAQ.")
    @login_page_faq_text = @browser.div(:class => "col-md-12", :text => /Have a question?/)
    @faq_body = @browser.div(:class => "container registration-faq")
    @login_page_confirm_instrc_link = @browser.div(:class => "row  signin-links signin-last-link").div(:class => "col-md-12").link(:class => "ember-view", :text => "Didn't receive confirmation email?")
    @confirm_body = @browser.div(:class => "container member-reset-password-page")

    @login_facebook_button = @browser.link(:text => /Sign in with Facebook/)
    @fb_url = "facebook.com/login.php?"
    @fb_email_field = @browser.text_field(:id => "email")
    @fb_password_field = @browser.text_field(:id => "pass")
    @fb_login = @browser.button(:type => "submit" , :value => "Log In")

    @login_twitter_button = @browser.link(:text => /Sign in with Twitter/)
    @twitter_url = "twitter.com/oauth/authenticate?"
    @twitter_email_field = @browser.text_field(:id => "username_or_email")
    @twitter_pass_field = @browser.text_field(:id => "password")
    @twitter_login = @browser.input(:type => "submit" , :value => "Sign In")

    @account_page = @browser.div(:class => "col-md-12 signin-header")
    @account_save = @browser.input(:value => "Save")
    @account_user_name = @browser.text_field(:placeholder => "Enter Username")
    @account_first_name = @browser.text_field(:placeholder => "Enter First Name")
    @account_last_name = @browser.text_field(:placeholder => "Enter Last Name")
    @account_email_name = @browser.text_field(:placeholder => "Enter Email")
    @account_comp_name = @browser.text_field(:placeholder => "Enter Company Name")
    @account_job_title = @browser.text_field(:placeholder => "Enter Job Title")
    @account_bio = @browser.text_field(:placeholder => "Enter Bio")

    @login_linkedin_button = @browser.link(:text => /Sign in with LinkedIn/)
    @linkedin_url = "linkedin.com/uas/oauth/authorize?"
    @linkedin_email_field = @browser.text_field(:id => "session_key-oauthAuthorizeForm")
    @linkedin_pass = @browser.text_field(:id => "session_password-oauthAuthorizeForm")
    @linkedin_login = @browser.input(:type => "submit" , :value => "Allow access")

    @login_gmail_button = @browser.link(:text => /Sign in with Google/)
    @gmail_url = "accounts.google.com/ServiceLogin?"
    @gmail_email_field = @browser.text_field(:id => "Email")
    @gmail_next_button = @browser.input(:value => "Next")
    @gmail_pass = @browser.text_field(:id => "Passwd")
    @gmail_login = @browser.input(:type => "submit" , :value => "Sign in")
    @gmail_approve_access = @browser.button(:id => "submit_approve_access")

    @forgot_password_page_title = @browser.div(:class => "col-md-7", :text => /Reset Your Password/)
    @forgot_password_email = @browser.div(:class => "col-md-5 col-lg-3 col-xs-12").input(:id => "member_login")
    @forgot_password_captcha = @browser.img(:alt => "captcha")
    @forgot_password_submit_button = @browser.div(:class => "col-lg-3 col-md-3 col-sm-3 col-xs-4").input(:class => "btn btn-primary", :value => "Get instructions")

    @register = @browser.link(:class => "ember-view", :text => "Register.")
    @register_page_title = @browser.div(:class => "col-lg-offset-2 col-md-offset-1 col-md-8 signin-header", :text => /Register for/)
    @register_page_username = @browser.input(:id => "member_username")
    @register_page_password = @browser.input(:id => "member_email")
    @register_page_email = @browser.input(:id => "member_password")
    @register_page_signin_link = @browser.link(:class => "ember-view", :text => "Sign in.")
    @register_page_signin_text = @browser.div(:class => "col-md-12", :text => /Already have an account?/)
    @register_page_captcha_code = @browser.img(:alt => "captcha")
    @register_page_register_button = @browser.input(:class => "btn btn-primary", :value => " Register")
    @register_page_faq_link = @browser.link(:class => "ember-view", :text => "Review our FAQ.")
    @register_page_faq_text = @browser.div(:class => "col-md-12", :text => /Have a question?/)

    @invalid_login = @browser.div(:text => "Invalid username, email address, or password.")

    @signin_page = @browser.div(:class => "row signin-body")
    @signin = browser.link(:class => "ember-view btn btn-default" , :text => /Sign in/)
    @register_page = @browser.div(:class => "row signup-subheading")
    @member_login = @browser.text_field(:id => "member_login")
    @member_password = @browser.text_field(:id => "member_password")
    @login_submit = @browser.button(:type => "submit")

    @login_link = @browser.link(:class, "login ember-view login")
    @login_url = "#{$base_url}/n/#{$networkslug}/members/sign_in"
    @login_page = @browser.div(:class => "row signin-body")

    @signout_link = @browser.link(:text => /Sign Out/)

    @topnav_signin = @browser.link(:class => "login ember-view login")

    @topnav_notification = @browser.link(:class => "dropdown-toggle notification")

    @policy_warning = @browser.div(:id => "policy-warning")
    @policy_warning_primary_button = @browser.div(:class => "policy-warning-button").button(:class => "btn btn-primary")
    @caret = @browser.div(:class => /topbar-nav/).span(:class => "caret")
    @caret_dropdown = @browser.div(:class => "dropdown open")

  end

  def goto_homepage
    @homepage = CommunityHomePage.new(@browser)
  	@browser.goto @homepage.home_url
  	@browser.wait_until($t) { @homepage.home_topic_widget.present? }
  end

  def goto_aboutpage
    @aboutpage = CommunityAboutPage.new(@browser)
  	@browser.goto @aboutpage.about_url
  	@browser.wait_until($t) { @aboutpage.about_widget.present? } 
  end

  def click_signin_link
  	goto_aboutpage
  	if @username_dropdown.present?
      signout
    end 
  	@signin_link.click
  	@browser.wait_until($t) { @login_body.present? }
  end

  def click_signin_register_link
  	if !@register_link.present?
  	 click_signin_link
  	end
  	goto_aboutpage
  	@signin_link.click
  	@browser.wait_until($t) { @login_body.present? }
  	@register.click
  	@browser.wait_until($t) { @register_body.present? }
  end

  def check_username_field
  	if @register_body.present? || !@login_body.present?
  	 goto_aboutpage
  	 click_signin_link
  	end
  	@browser.wait_until($t) { @login_user_field.present? }
  end

  def check_pass_field
  	if @register_body.present? || !@login_body.present?
  	 goto_aboutpage
  	 click_signin_link
  	end
  	@browser.wait_until($t) { @login_password_field.present? }
  end

  def check_login_username_field_placeholder
  	if @register_body.present? || !@login_body.present?
  	 goto_aboutpage
  	 click_signin_link
  	end
  	@browser.wait_until($t) { @login_user_field.present? }
  	@browser.wait_until($t) { @login_username_placeholder.present? }
  end

  def check_login_pass_field_placeholder
  	if @register_body.present? || !@login_body.present?
  	 goto_aboutpage
  	 click_signin_link
  	end
  	@browser.wait_until($t) { @login_password_field.present? }
  	@browser.wait_until($t) { @login_password_placeholder.present? }
  end

  def check_signin_button
  	if @register_body.present? || !@login_body.present?
  	 goto_aboutpage
  	 click_signin_link
  	end
  	@browser.wait_until($t) { @login_login_button.present? }
  end

  def check_login_page_title
  	if @register_body.present? || !@login_body.present?
  	 goto_aboutpage
  	 click_signin_link
  	end
  	@browser.wait_until($t) { @login_page_title.present? }
  end

  def login(user)
  	if !@login_body.present? || @register_body.present?
  		goto_aboutpage
  		click_signin_link
  	end
  	@login_user_field.set user[2]
    @login_password_field.set user[1]
    @browser.screenshot.save screenshot_dir('userpwd.png')

    @browser.wait_until($t) { @login_submit.present? }
    @login_submit.click

    @browser.wait_until($t) { @username_dropdown.present?}
    assert @username_dropdown.exists?
    $logged_in_user = user # save for next time
  end

  def check_forgot_password_link
  	if @register_body.present? || !@login_body.present?
  	 goto_aboutpage
  	 click_signin_link
  	end
  	@login_forgot_password_link.click
  	@browser.wait_until($t) { @password_reset_page.present? }
  	@browser.wait_until($t) { @forgot_password_captcha.present? }
  end

  def check_social_login_button
  	if @register_body.present? || !@login_body.present?
  	 goto_aboutpage
  	 click_signin_link
  	end
  	@browser.wait_until($t) { @login_facebook_button.present? }
  	@browser.wait_until($t) { @login_linkedin_button.present? }
  	@browser.wait_until($t) { @login_twitter_button.present? }
  	@browser.wait_until($t) { @login_gmail_button.present? }
  end

  def check_register_link_on_login
  	if @register_body.present? || !@login_body.present?
  	 goto_aboutpage
  	 click_signin_link
  	end
  	@login_page_register_link.click
  	@browser.wait_until($t) { @register_body.present? }
  end

  def check_register_link_text_on_login
  	if @register_body.present? || !@login_body.present?
  	 goto_aboutpage
  	 click_signin_link
  	end
  	@browser.wait_until($t) { @login_page_register_text.present? }
  end

  def check_faq_link
  	if @register_body.present? || !@login_body.present?
  	 goto_aboutpage
  	 click_signin_link
  	end
  	@login_page_faq_link.click
  	@browser.wait_until($t) { @faq_body.present? }
  end

  def check_faq_text
  	if @register_body.present? || !@login_body.present?
  	 goto_aboutpage
  	 click_signin_link
  	end
  	@browser.wait_until($t) { @login_page_faq_text.present? }
  end

  def check_confirm_instrc_link
  	if @register_body.present? || !@login_body.present?
  	 goto_aboutpage
  	 click_signin_link
  	end
  	@login_page_confirm_instrc_link.click
  	@browser.wait_until($t) { @confirm_body.present? }
  end

  def do_social_login(social_site_type)
  	if @register_body.present? || !@login_body.present?
  	 goto_aboutpage
  	 click_signin_link
  	end

    if (social_site_type == "Facebook")
     @login_facebook_button.when_present.click
     @browser.url.include? (@fb_url)
     @fb_email_field.when_present.set $user6[0]
     @fb_password_field.when_present.set $user6[1]
     @fb_login.when_present.click   
     @topicdetailpage = CommunityTopicDetailPage.new(@browser)
     @aboutpage = CommunityAboutPage.new(@browser)
     @browser.wait_until($t) { @aboutpage.about_widget.present? || @topicdetailpage.topic_page.present? || @account_page.present?} 
     if @account_page.present?
      policy_warning
      if @account_first_name.present?
       @account_first_name.set "watir"
      end
      if @account_last_name.present?
       @account_last_name.set "socialfb"
      end
      if @account_email_name.present?
       @account_email_name.set "watirsocialfb@gmail.com"
      end
      if @account_comp_name.present?
       @account_comp_name.set "SAP"
      end
      if @account_job_title.present?
       @account_job_title.set "HR"
      end 
      if @account_bio.present?
       @account_bio.set "Bio set by Social Watir"
      end
      @account_save.click
      @profilepage = CommunityProfilePage.new(@browser)
      @browser.wait_until($t) { @profilepage.profile_page.present? }
     end
    end

    if (social_site_type == "Linkedin")
     @login_linkedin_button.when_present.click
     @browser.url.include? (@linkedin_url)
     @linkedin_email_field.when_present.set $user7[0]
     @linkedin_pass.when_present.set $user7[1]
     @linkedin_login.when_present.click
     @topicdetailpage = CommunityTopicDetailPage.new(@browser)
     @aboutpage = CommunityAboutPage.new(@browser)
     @browser.wait_until($t) { @aboutpage.about_widget.present? || @topicdetailpage.topic_page.present? || @account_page.present?}
     if @account_page.present?
      policy_warning
      if @account_first_name.present?
       @account_first_name.set "watir"
      end
      if @account_last_name.present?
       @account_last_name.set "sociallink"
      end
      if @account_email_name.present?
       @account_email_name.set "watirsociallink@gmail.com"
      end
      if @account_comp_name.present?
       @account_comp_name.set "SAP"
      end
      if @account_job_title.present?
       @account_job_title.set "HR"
      end
      if @account_bio.present?
       @account_bio.set "Bio set by Social Watir"
      end
      @account_save.click
      @profilepage = CommunityProfilePage.new(@browser)
      @browser.wait_until($t) { @profilepage.profile_page.present? }
     end
    end

    if (social_site_type == "Google")
      @login_gmail_button.when_present.click
      @browser.url.include? (@gmail_url)
      @gmail_email_field.when_present.set $user8[0]
      @gmail_next_button.click
      @gmail_pass.when_present.set $user8[1]
      @gmail_login.when_present.click
      @topicdetailpage = CommunityTopicDetailPage.new(@browser)
      @aboutpage = CommunityAboutPage.new(@browser)
      @browser.wait_until($t) { @aboutpage.about_widget.present? || @topicdetailpage.topic_page.present? || @account_page.present?}
      if @account_page.present?
       policy_warning
       if @account_user_name.present?
        @account_user_name.set "watirgoogle"
       end
       if @account_first_name.present?
        @account_first_name.set "watir"
       end
       if @account_last_name.present?
        @account_last_name.set "socialtwi"
       end
       if @account_email_name.present?
        @account_email_name.set "watirsocial@gmail.com"
       end
       if @account_comp_name.present?
        @account_comp_name.set "SAP"
       end
       if @account_job_title.present?
         @account_job_title.set "HR"
       end
       if @account_bio.present?
        @account_bio.set "Bio set by Social Watir"
       end
       @browser.execute_script("window.scrollBy(0,4000)")
       @account_save.click
       @profilepage = CommunityProfilePage.new(@browser)
       @browser.wait_until($t) { @profilepage.profile_page.present? }
      end

      @topicdetailpage = CommunityTopicDetailPage.new(@browser)
      if @browser.url != @topicdetailpage.topicpage_url
       @browser.goto @topicdetailpage.topicpage_url
       @browser.wait_until($t) { @topicdetailpage.topic_page.present?}
      end
      if @gmail_approve_access.present?
       accept = @gmail_approve_access
       @browser.wait_until($t) {
        accept.present? && !accept.attribute_value("disabled") #accept button is disabled initially, therefore waiting for it to be not disabled anymore
       }

       accept.when_present.click
      end
    end

    if (social_site_type == "Twitter")
      @login_twitter_button.when_present.click
      @browser.url.include? (@twitter_url)
      @twitter_email_field.when_present.set $user9[0]
      @twitter_pass_field.when_present.set $user9[1]
      @twitter_login.when_present.click
      @topicdetailpage = CommunityTopicDetailPage.new(@browser)
      @aboutpage = CommunityAboutPage.new(@browser)
      @browser.wait_until($t) { @aboutpage.about_widget.present? || @topicdetailpage.topic_page.present? || @account_page.present?}
      if @account_page.present?
       policy_warning
       if @account_first_name.present?
        @account_first_name.set "watir"
       end
       if @account_last_name.present?
        @account_last_name.set "socialtwi"
       end
       if @account_email_name.present?
        @account_email_name.set "watirsocialtwi@gmail.com"
       end
       if @account_comp_name.present?
        @account_comp_name.set "SAP"
       end
       if @account_job_title.present?
        @account_job_title.set "HR"
       end
       if @account_bio.present?
        @account_bio.set "Bio set by Social Watir"
       end
       @account_save.click
       @profilepage = CommunityProfilePage.new(@browser)
       @browser.wait_until($t) { @profilepage.profile_page.present? }
    end
      
      # authorize = @browser.input(:id => "allow" , :value => "Authorize app")
      # @browser.wait_until($t) {
      #   authorize.exists?
      # }
      # authorize.when_present.click

    end
    @adminpage = CommunityAdminPage.new(@browser)
    @browser.wait_until($t) { @adminpage.caret.present? }
    @browser.wait_until($t) { @username_dropdown.present? }

  end

  def check_register_page_title
  	if @register_body.present? || !@login_body.present?
  	 goto_aboutpage
  	 click_signin_link
  	end
  	click_signin_register_link
  	@browser.wait_until($t) { @register_page_title.present? }

  end

  def check_register_username_field
  	if @register_body.present? || !@login_body.present?
  	 goto_aboutpage
  	 click_signin_link
  	end
  	click_signin_register_link
  	@browser.wait_until($t) { @register_page_username.present? }
  end

  def check_register_pass_field
  	if @register_body.present? || !@login_body.present?
  	 goto_aboutpage
  	 click_signin_link
  	end
  	click_signin_register_link
  	@browser.wait_until($t) { @register_page_password.present? }
  end

  def check_register_email_field
  	if @register_body.present? || !@login_body.present?
  	 goto_aboutpage
  	 click_signin_link
  	end
  	click_signin_register_link
  	@browser.wait_until($t) { @register_page_email.present? }
  end

  def check_register_captcha_field
  	if @register_body.present? || !@login_body.present?
  	 goto_aboutpage
  	 click_signin_link
  	end
  	click_signin_register_link
  	@browser.wait_until($t) { @register_page_captcha_code.present? }
  end

  def check_register_button
  	if @register_body.present? || !@login_body.present?
  	 goto_aboutpage
  	 click_signin_link
  	end
  	click_signin_register_link
  	@browser.wait_until($t) { @register_page_register_button.present? }
  end

  def check_signin_link_from_register
  	if @register_body.present? || !@login_body.present?
  	 goto_aboutpage
  	 click_signin_link
  	end
  	click_signin_register_link
  	@browser.wait_until($t) { @register_page_signin_link.present? }
  	@register_page_signin_link.click
  	@browser.wait_until($t) { @login_body.present? }
  end

  def check_signin_link_text_from_register
      	if @register_body.present? || !@login_body.present?
  	 goto_aboutpage
  	 click_signin_link
  	end
  	click_signin_register_link
  	@browser.wait_until($t) { @register_page_signin_text.present? }
  end

  def check_faq_link_from_register
  	if @register_body.present? || !@login_body.present?
  	 goto_aboutpage
  	 click_signin_link
  	end
  	click_signin_register_link
  	@browser.wait_until($t) { @register_page_faq_link.present? }
  	@register_page_faq_link.click
  	@browser.wait_until($t) { @faq_body.present? }
  end

  def check_faq_link_text_from_register
  	if @register_body.present? || !@login_body.present?
  	 goto_aboutpage
  	 click_signin_link
  	end
  	click_signin_register_link
  	@browser.wait_until($t) { @register_page_faq_text.present? }
  end

  def check_invalid_username_login
  	user5 = ["invalid", "password"]
    #@aboutpage = CommunityAboutPage.new(@browser)
    about_landing($network)

    if @register_body.present? || !@login_body.present?
  	 goto_aboutpage
  	 click_signin_link
  	end
    @signin_link.when_present.click
    @browser.wait_until { @login_body.present? }
    
    @login_user_field.set user5[0]
    @login_password_field.set user5[1]
    assert @login_submit.present?
    @login_submit.when_present.click

    @browser.wait_until($t) {
      @invalid_login.present?
    }  
  end

  def check_invalid_password_login
  	user5 = ["invalid", "password"]
  	goto_homepage
  	if @register_body.present? || !@login_body.present?
  	 goto_aboutpage
  	 click_signin_link
  	end

    @signin_link.when_present.click
    @browser.wait_until { @login_body.exists? }
    
    @login_user_field.set user5[0]
    @login_password_field.when_present.set "invalidpassword"
    assert @login_submit.present?
    @login_submit.when_present.click
    @browser.wait_until {
      @invalid_login.exists?
    }
  end

  def login_with(with, user)
  	if @register_body.present? || !@login_body.present?
  	 goto_aboutpage
  	 click_signin_link
  	end
  	if with == "username"
  	@login_user_field.set user[2]
  	end
  	if with == "email"
  	@login_user_field.set user[0]
  	end

    @login_password_field.set user[1]
    @browser.screenshot.save screenshot_dir('userpwd.png')

    @browser.wait_until($t) { @login_submit.present? }
    @login_submit.click

    @browser.wait_until($t) { @username_dropdown.exists?}
    assert @username_dropdown.exists?
  end

  def sign_out
    about_login("regis", "logged") 
    signout
  end

end