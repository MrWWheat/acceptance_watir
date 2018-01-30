require 'pages/community'
require 'minitest/assertions'

#include Test::Unit::Assertions

class Pages::Community::Login < Pages::Community

  def initialize(config, options = {})
    super(config)
    @url = config.base_url + "/n/#{config.slug}/members/sign_in"
    @adminurl = config.base_url + "/n/#{config.slug}/admins/sign_in"
  end

  def start!(user)
    # Note: sequence is different from base
    # first, make sure we've booted the app and the dom & necessary elements are present
    ensure_first_time_browser_boot!
    # second, go to the location we're expecting to start the given test
    ensure_correct_start_location!(@url, login_page)
    # third, make sure we are logged in as the correct user (or not logged in if anonymous)
    ensure_correct_user!(user)
  end

  login_url                     { "#{@@base_url}" + "/n/#{@@slug}/members/sign_in"}
  login_body                    { div(:class => "row signin-body") }
  login_submit                  { button(:type => "submit") }
  
  username_field                { text_field(:id => "member_login") }
  password_field                { text_field(:id => "member_password") }
  topnav_home                   { link(:class => "ember-view", :text => "Home") }
  topnav_topic                  { link(:class => "ember-view", :text => "Topics") }
  topnav_product                { link(:class => "ember-view", :text => "Products") }
  topnav_about                  { link(:class => "ember-view", :text => "About") }
  topnav_search                 { input(:class => "ember-view ember-text-field typeahead form-control tt-input") }
  topnav_logo                   { link(:class => "ember-view").element(:class => "nav-logo") }
  topnav_signin                 { link(:css => ".excelsior-nav .login") }
  topnav_notification           { link(:class => "dropdown-toggle notification") }
  signin_link                   { link(:class => /ember-view login/, :href => /sign_in/) }
  signin_page                   { div(:class => "row signin-body") }
  topnav                        { div(:css => ".gadget-main-menu,.topbar-nav") }

  register_page                 { div(:class => "row signup-subheading") }
  
  register_link                 { link(:class => "login ember-view login", :href => /sign_up/) }
  register_body                 { div(:class => "row signup-subheading") }
  login_page_title              { div(:class => "col-lg-offset-2 col-md-offset-1 col-md-8 signin-header", :text => /Sign In to/) } # "#{$network}"/)

  login_login_button            { button(:value => /Sign in/) }

  login_username_placeholder    { input(:placeholder => "Enter Username or Email") }
  login_password_placeholder    { input(:placeholder => "Enter Password") }

  login_forgot_password_link    { link(:class => "forgot-password-text ember-view forgot-password-text") }
  password_reset_page           { div(:class => "container member-reset-password-page") }
  login_page_register_link      { link(:class => "ember-view", :text => "Register.") }
  login_page_register_text      { div(:class => "row signin-links signin-links-1").div(:class => "col-md-12") }
  login_page_faq_link           { link(:class => "ember-view", :text => "Review our FAQ.") }
  login_page_faq_text           { div(:class => "col-md-12", :text => /Have a question?/) }
  faq_body                      { div(:class => "container registration-faq") }
  login_page_confirm_instrc_link { div(:class => "row  signin-links signin-last-link").div(:class => "col-md-12").link(:class => "ember-view", :text => "Didn't receive confirmation email?") }
  confirm_body                  { div(:class => "container member-reset-password-page") }

  login_error_msg               { div(:class => "error-alert") }

  login_facebook_button         { link(:text => /Sign in with Facebook/) }
  fb_url                        { "facebook.com/login.php?" }
  fb_email_field                { text_field(:id => "email") }
  fb_password_field             { text_field(:id => "pass") }
  fb_login                      { button(:type => "submit" , :value => "Log In") }

  login_twitter_button          { link(:text => /Sign in with Twitter/) }
  twitter_url                   { "twitter.com/oauth/authenticate?" }
  twitter_email_field           { text_field(:id => "username_or_email") }
  twitter_pass_field            { text_field(:id => "password") }
  twitter_login                 { input(:type => "submit" , :value => "Sign In") }

  account_page                  { div(:class => "col-md-12 signin-header") }
  account_save                  { button(:value => "Save") }
  account_user_name             { text_field(:placeholder => "Enter Username") }
  account_first_name            { text_field(:placeholder => "Enter First Name") }
  account_last_name             { text_field(:placeholder => "Enter Last Name") } 
  account_email_name            { text_field(:placeholder => "Enter Email") }
  account_comp_name             { text_field(:placeholder => "Enter Company Name") }
  account_job_title             { text_field(:placeholder => "Enter Job Title") }
  account_bio                   { text_field(:placeholder => "Enter Bio") }
  account_term_of_use           { input(:id => "terms-checkbox").parent.label.span }
  account_confirm               { button(:id => "confirm-save") }
  account_save_success          { div(:id => "success-message") }

  login_linkedin_button         { link(:text => /Sign in with LinkedIn/) }
  linkedin_url                  { "linkedin.com/uas/oauth/authorize?" }
  linkedin_email_field          { text_field(:id => "session_key-oauthAuthorizeForm") }
  linkedin_pass                 { text_field(:id => "session_password-oauthAuthorizeForm") }
  linkedin_login                { input(:type => "submit" , :value => "Allow access") }

  login_gmail_button            { link(:text => /Sign in with Google/) }
  gmail_url                     { "accounts.google.com/ServiceLogin?" }
  gmail_email_field             { text_field(:id => "Email") }
  gmail_next_button             { input(:value => "Next") }
  gmail_pass                    { text_field(:id => "Passwd") }
  gmail_login                   { input(:type => "submit" , :value => "Sign in") }
  gmail_approve_access          { button(:id => "submit_approve_access") }

  forgot_password_page_title    { div(:class => "col-md-7", :text => /Reset Your Password/) }
  forgot_password_email         { div(:class => "col-md-5 col-lg-3 col-xs-12").input(:id => "member_login") }
  forgot_password_captcha       { img(:alt => "captcha") }
  forgot_password_submit_button { div(:class => "col-lg-3 col-md-3 col-sm-3 col-xs-4").input(:class => "btn btn-primary", :value => "Get instructions") }

  register                      { link(:class => "ember-view", :text => "Register.") }
  register_page_title           { div(:class => "col-lg-offset-2 col-md-offset-1 col-md-8 signin-header", :text => /Register for/) }
  register_page_username        { input(:id => "member_username") }
  register_page_password        { input(:id => "member_email") }
  register_page_email           { input(:id => "member_password") }
  register_page_signin_link     { link(:class => "ember-view", :text => "Sign in.") }
  register_page_signin_text     { div(:class => "col-md-12", :text => /Already a member?/) }
  register_page_captcha_code    { img(:alt => "captcha") }
  register_page_register_button { button(:value => /Register/) }
  register_page_faq_link        { link(:class => "ember-view", :text => "Review our FAQ.") }
  register_page_faq_text        { div(:class => "col-md-12", :text => /Have a question?/) }

  register_page_username_field  { text_field(:id => "member_username") }

  invalid_login                 { div(:text => "Invalid username, email address, or password.") }
  not_confirm_login             { div(:text => "You have to confirm your email address before continuing.")}
  #not_confirm_login             { div(:text => "Internal Server Error")}
  signin                        { link(:class => "ember-view btn btn-default" , :text => /Sign in/) }
  member_login                  { text_field(:id => "member_login") }
  member_password               { text_field(:id => "member_password") }

  #login_submit                  { button(:type => "submit") }

  #login_link                    { link(:class, "login ember-view login") }
  #login_url                     { "#{@@base_url}/n/#{@@slug}/members/sign_in" }
  login_page                     { div(:class => "row signin-body")}

  log_out                        { link(:css => ".dropdown.open .dropdown-menu .sign-out a") }

  profile_icon                   { link(:css => ".navbar .profile") }

  def login_admin(user)
    @url = @adminurl
    login!(user)
  end

  def login!(user)
    sleep 1
    return if (user.username == $logged_in_user && !signin_link.present?)
    #puts user.username
    #puts $logged_in_user
     @browser.goto @url if @browser.url != @url || !topnav.present?
    @browser.wait_until { topnav.present? }
    @browser.wait_until { !@browser.element(:css => ".loading-block").present? }
    if (user.username != $logged_in_user) && ( user_dropdown.present?)
     logout! #unless is_logged_out? # if we're logged in as someone else, logout first.
    end
   

    puts "actually logging in (#{user.username})..." if @config.verbose?

    unless @browser.url =~ /sign_in/
     @browser.goto @url
    end
    @browser.wait_until { login_body.present? }
    @browser.wait_until { login_submit.present? }
    @browser.wait_until { @browser.ready_state == "complete" }

    if user.user_ref== "social_twitter_user" || user.user_ref == "social_google_user" || user.user_ref =="social_linkedin_user" || user.user_ref =="social_facebook_user"
     @browser.wait_until { @browser.ready_state == "complete" }
    else
     @browser.wait_until { username_field.present? }
     @browser.wait_until { password_field.present? }

     username_field.set(user.username)
     password_field.set(user.password)

     login_submit.click

     @browser.wait_until { !login_submit.present? }
     @browser.wait_until { @browser.ready_state == "complete" }
     @browser.wait_until { user_dropdown.present? }
     $logged_in_user = user.username
    end
  rescue Exception => e
    @browser.ready_state
    #byebug
    puts "How did we get here?"
    raise

  end

  def logout!
  #puts "in logout"
  # if @browser.url != /sign_in/
    @browser.wait_until{ login_link.present? || user_dropdown.present?}
    if user_dropdown.present?
      @browser.execute_script("window.scrollTo(0,document.documentElement.scrollTop)")
      @browser.wait_until { !layout_loading_block.present? }
      sleep 1 # without this sleep, the following condition will be false sometimes
      # On-boarding welcome modal dialog would be prompted for admin user
      if @browser.div(:css => ".my-auto-show-modal").present?
        @browser.button(:css => ".my-auto-show-modal .btn-primary").when_present.click
        @browser.wait_until { !@browser.div(:css => ".my-auto-show-modal").present? }
      end
      user_dropdown.when_present.click
      log_out.when_present.click
      @browser.wait_until {login_link.present?}
      sleep 1 # Temp fix for 422 Unprocessed Entity error
    else
      @browser.wait_until {login_link.present?}
    end
  end

  def click_signin_link
    signin_link.click
    @browser.wait_until { login_body.present? }
  end

  def click_signin_register_link
    signin_link.click
    @browser.wait_until { login_body.present? }
    register.click
    @browser.wait_until { register_body.present? }
  end

  def check_username_field
    @browser.wait_until { member_login.present? }
  end

  def check_pass_field
    @browser.wait_until { member_password.present? }
  end

  def check_login_username_field_placeholder
    @browser.wait_until { member_login.present? }
    @browser.wait_until { login_username_placeholder.present? }
  end

  def check_login_pass_field_placeholder
    @browser.wait_until { member_password.present? }
    @browser.wait_until { login_password_placeholder.present? }
  end

  def check_signin_button
    @browser.wait_until { login_login_button.present? }
  end

  def check_login_page_title
    @browser.wait_until { login_page_title.present? }
  end

  def check_forgot_password_link
    login_forgot_password_link.click
    @browser.wait_until { password_reset_page.present? }
    @browser.wait_until { forgot_password_captcha.present? }
  end

  def check_social_login_button
    @browser.wait_until { login_facebook_button.present? }
    @browser.wait_until { login_linkedin_button.present? }
    @browser.wait_until { login_twitter_button.present? }
    @browser.wait_until { login_gmail_button.present? }
  end

  def check_register_link_on_login
    login_page_register_link.click
    @browser.wait_until { register_body.present? }
  end

  def check_register_link_text_on_login
    @browser.wait_until { login_page_register_text.present? }
  end

  def check_faq_link
    login_page_faq_link.click
    @browser.wait_until { faq_body.present? }
  end

  def check_faq_text
    @browser.wait_until { login_page_faq_text.present? }
  end

  def check_confirm_instrc_link
    login_page_confirm_instrc_link.click
    @browser.wait_until { confirm_body.present? }
  end

  def do_social_login(social_site_type)
    if (social_site_type == "Facebook")
     login_facebook_button.click
     @browser.url.include? (fb_url)
     fb_email_field.when_present.set @c.users[:social_facebook_user].email
     fb_password_field.when_present.set @c.users[:social_facebook_user].password
     fb_login.when_present.click   
     @topicdetail_page = Pages::Community::TopicDetail.new(@config)
     @about_page = Pages::Community::About.new(@config)
     @browser.wait_until { @about_page.about_widget.present? || @topicdetail_page.topic_page.present? || account_page.present?} 
     if account_page.present?
      accept_policy_warning
      if account_first_name.present?
       account_first_name.set "watir"
      end
      if account_last_name.present?
       account_last_name.set "socialfb"
      end
      if account_email_name.present?
       account_email_name.set "watirsocialfb@gmail.com"
      end
      if account_comp_name.present?
       account_comp_name.set "SAP"
      end
      if account_job_title.present?
       account_job_title.set "HR"
      end 
      if account_bio.present?
       account_bio.set "Bio set by Social Watir"
      end
      if account_term_of_use.present?
          account_term_of_use.click
      end
      account_save.click
      account_confirm.when_present.click
      @browser.wait_until{ account_save_success.present? }
     end
    end

    if (social_site_type == "Linkedin")
     login_linkedin_button.when_present.click
     @browser.url.include? (linkedin_url)
     linkedin_email_field.when_present.set @c.users[:social_linkedin_user].email
     linkedin_pass.when_present.set @c.users[:social_linkedin_user].password
     linkedin_login.when_present.click
     @topicdetail_page = Pages::Community::TopicDetail.new(@config)
     @about_page = Pages::Community::About.new(@config)
     @browser.wait_until { @about_page.about_widget.present? || @topicdetail_page.topic_page.present? || account_page.present?}
     if account_page.present?
      accept_policy_warning
      if account_first_name.present?
       account_first_name.set "watir"
      end
      if account_last_name.present?
       account_last_name.set "sociallink"
      end
      if account_email_name.present?
       account_email_name.set "watirsociallink@gmail.com"
      end
      if account_comp_name.present?
       account_comp_name.set "SAP"
      end
      if account_job_title.present?
       account_job_title.set "HR"
      end
      if account_bio.present?
       account_bio.set "Bio set by Social Watir"
      end
      if account_term_of_use.present?
          account_term_of_use.click
      end
      account_save.click
      account_confirm.when_present.click
      @browser.wait_until{ account_save_success.present? }
     end
    end

    if (social_site_type == "Google")
      login_gmail_button.when_present.click
      @browser.url.include? (gmail_url)
      gmail_email_field.when_present.set @c.users[:social_google_user].email
      gmail_next_button.click
      gmail_pass.when_present.set @c.users[:social_google_user].password
      gmail_login.when_present.click
      @topicdetail_page = Pages::Community::TopicDetail.new(@config)
      @about_page = Pages::Community::About.new(@config)
      @browser.wait_until { @about_page.about_widget.present? || @topicdetail_page.topic_page.present? || account_page.present?}
      if account_page.present?
       accept_policy_warning
       if account_user_name.present?
        account_user_name.set "watirgoogle"
       end
       if account_first_name.present?
        account_first_name.set "watir"
       end
       if account_last_name.present?
        account_last_name.set "socialtwi"
       end
       if account_email_name.present?
        account_email_name.set "watirsocial@gmail.com"
       end
       if account_comp_name.present?
        account_comp_name.set "SAP"
       end
       if account_job_title.present?
         account_job_title.set "HR"
       end
       if account_bio.present?
        account_bio.set "Bio set by Social Watir"
       end
       if account_term_of_use.present?
          account_term_of_use.click
       end
       @browser.execute_script("window.scrollBy(0,4000)")
       account_save.click
       account_confirm.when_present.click
       @browser.wait_until{ account_save_success.present? }
      end

      @topicdetail_page = Pages::Community::TopicDetail.new(@config)
      if @browser.url != @topicdetail_page.topicpage_url
       @browser.goto @topicdetail_page.topicpage_url
       @browser.wait_until { @topicdetail_page.topic_page.present?}
      end
      if gmail_approve_access.present?
       accept = gmail_approve_access
       @browser.wait_until {
        accept.present? && !accept.attribute_value("disabled") #accept button is disabled initially, therefore waiting for it to be not disabled anymore
       }

       accept.when_present.click
      end
    end

    if (social_site_type == "Twitter")
      login_twitter_button.when_present.click
      @browser.url.include? (twitter_url)
      twitter_email_field.when_present.set @c.users[:social_twitter_user].email
      twitter_pass_field.when_present.set @c.users[:social_twitter_user].password
      twitter_login.when_present.click
      @topicdetail_page = Pages::Community::TopicDetail.new(@config)
      @about_page = Pages::Community::About.new(@config)
      @browser.wait_until { @about_page.about_widget.present? || @topicdetail_page.topic_page.present? || account_page.present?}
      if account_page.present?
       accept_policy_warning
       if account_first_name.present?
        account_first_name.set "watir"
       end
       if account_last_name.present?
        account_last_name.set "socialtwi"
       end
       if account_email_name.present?
        account_email_name.set "watirsocialtwi@gmail.com"
       end
       if account_comp_name.present?
        account_comp_name.set "SAP"
       end
       if account_job_title.present?
        account_job_title.set "HR"
       end
       if account_bio.present?
        account_bio.set "Bio set by Social Watir"
       end
       if account_term_of_use.present?
          account_term_of_use.click
       end
       account_save.click
       account_confirm.when_present.click
       @browser.wait_until{ account_save_success.present? }
    end
      
      # authorize = @browser.input(:id => "allow" , :value => "Authorize app")
      # @browser.wait_until($t) {
      #   authorize.exists?
      # }
      # authorize.when_present.click

    end
    #@admin_page = Pages::Community::Admin.new(@config)
    @browser.wait_until { Pages::Community::Layout.new(@config).user_dropdown.present? }
    @browser.wait_until { user_dropdown.present? }

  end

  def check_register_page_title
    click_signin_register_link
    @browser.wait_until { register_page_title.present? }

  end

  def check_register_username_field
    click_signin_register_link
    @browser.wait_until { register_page_username.present? }
  end

  def check_register_pass_field
    click_signin_register_link
    @browser.wait_until { register_page_password.present? }
  end

  def check_register_email_field
    click_signin_register_link
    @browser.wait_until { register_page_email.present? }
  end

  def check_register_captcha_field
    click_signin_register_link
    @browser.wait_until { register_page_captcha_code.present? }
  end

  def check_register_button
    click_signin_register_link
    @browser.wait_until { register_page_register_button.present? }
  end

  def check_signin_link_from_register
    click_signin_register_link
    @browser.wait_until { register_page_signin_link.present? }
    register_page_signin_link.click
    @browser.wait_until { login_body.present? }
  end

  def check_signin_link_text_from_register
    click_signin_register_link
    @browser.wait_until { register_page_signin_text.present? }
  end

  def check_faq_link_from_register
    click_signin_register_link
    @browser.wait_until { register_page_faq_link.present? }
    register_page_faq_link.click
    @browser.wait_until { @browser.windows.size > 1 }
    @browser.windows.last.use do
      @browser.wait_until { faq_body.present? }
    end
  end

  def check_faq_link_text_from_register
    click_signin_register_link
    @browser.wait_until { register_page_faq_text.present? }
  end

  def check_invalid_username_login
    user5 = ["invalid", "password"]
    #@aboutpage = CommunityAboutPage.new(@browser)
    #about_landing($network)
    signin_link.when_present.click
    @browser.wait_until { login_body.present? }
    
    member_login.set user5[0]
    member_password.set user5[1]
    assert login_submit.present?
    login_submit.when_present.click

    @browser.wait_until {
      invalid_login.present?
    }  
  end

  def check_invalid_password_login
    user5 = ["invalid", "password"]
    signin_link.when_present.click
    @browser.wait_until { login_body.exists? }
    
    member_login.set user5[0]
    member_password.when_present.set "invalidpassword"
    assert login_submit.present?
    login_submit.when_present.click
    @browser.wait_until {
      invalid_login.present?
    }
  end

  def login_with(with, user)
    @browser.wait_until{ login_link.present? || user_dropdown.present?}
    if user_dropdown.present?
      logout!
    end
    sleep 0.5
    @browser.goto @url
    @browser.wait_until { member_login.present? }
    if with == "username"
    member_login.set user.username
    end
    if with == "email"
    member_login.set user.email
    end

    member_password.set user.password
    #@browser.screenshot.save screenshot_dir('userpwd.png')

    @browser.wait_until { login_submit.present? }
    login_submit.click


    @browser.wait_until { user_dropdown.present?}
  end

  def login_with_username_and_password(user)
    @browser.wait_until { member_login.present? }
    member_login.when_present.set user.username
    member_password.when_present.set user.password
    login_submit.when_present.click
    @browser.wait_until { @browser.ready_state == "complete" }
  end

  def login_with_email_and_password(user)
    @browser.wait_until { member_login.present? }
    member_login.when_present.set user.email
    member_password.when_present.set user.password
    login_submit.when_present.click
    @browser.wait_until { @browser.ready_state == "complete" }
  end

end