require 'pages/base'
#require 'pages/community/login'

class Pages::Community < Pages::Base

  # def initialize(config)
  #   super
  # end
 # def initialize(config)
 #   @config = config
 #   @c = @config # syntactic sugar
 #   @browser = config.browser
 #   @@network_name = config.network_name
 #   @@base_url = config.base_url
 #   @@slug = config.slug
 #   self.class.register_dom_called if @config.track_dom_usage?
 # end

  def ensure_first_time_browser_boot!
    # if username or login_link are present, we know we've already booted the browser app
    #unless ( username.present? || login_link.present? )
    #  puts "first time browser boot...." if @config.verbose?
      #puts url
      @browser.goto url
      @login_page = Pages::Community::Login.new(@config)
      @browser.wait_until { @login_page.user_dropdown.present? || @login_page.login_link.present? }
      puts "browser booted" if @config.verbose?
    #end
  end

  def ensure_correct_user!(user_ref)
    case user_ref
      when :anonymous
        puts "logging out to run as anonymous..." if @config.verbose?
        logout!
      when nil
        puts "user nil"
        raise "we should not have a nil user. Why is there a nil user here?"
      else
        puts "logging in to run as #{user_ref}" if @config.verbose?
        #byebug
        @login_page = Pages::Community::Login.new(@config)
        @login_page.login!(@c.users[user_ref])
        #login!(@c.users[user_ref])
    end
  end


  def clean_up_modals!
    if @browser.div(:css => ".modal").present?
      @browser.execute_script('$( ".modal" ).modal("hide")')
    end
    @browser.wait_until { !@browser.div(:css => ".modal").present? }
    @browser.wait_until { !@browser.div(:css => ".modal-backdrop.fade").present? }
  end



  #
  # Helper methods here should be sitewide capabilities, accessible no matter what page you are on
  #
  def is_logged_in?(user)
    return false if is_logged_out?

    unless user_dropdown.present?
      @config.screenshot!("is_logged_in_" + Time.now.to_s)
      #byebug
      raise "page is not in a dom state able to determine logged in user. Please check your workflow."
    end

    @profile_page = Pages::Community::Profile.new(@config)
    @profile_page.goto_profile

    @profile_page.user_name == user.username
  end

  def is_logged_out?
    login_link.present?
  end

 # def login(user)
    #@login_page ||= Pages::Community::Login.new(@config)
  #  login(user)
 # end

    def logout!
      @browser.execute_script("window.scrollBy(0,-10000)")

      #return if is_logged_out?
      @login_page = Pages::Community::Login.new(@config)
      @browser.wait_until { @login_page.user_dropdown.present? || @login_page.login_link.present? }
      if @login_page.user_dropdown.present?
        @browser.wait_until { !@browser.element(:css => ".loading-block").present? } # later click might not work while loading
        @login_page.user_dropdown.when_present.click
        @login_page.log_out.when_present.click
        @browser.wait_until {@login_page.login_link.present?}
        sleep 1 # Temp fix for 422 Unprocessed Entity error
        # Sometimes, the current url doesn't match the current page which would break some cases.
        # So, add the following wait considering user would be redirected to Topic list page wherever user sign out.
        if !@config.gated_community?
          @browser.wait_until { @browser.div(:id => "topics").present? }
        end
     end

     # puts "actually logging out..." if @config.verbose?
     # @browser.body.present?
     # caret.when_present.click #if !username_dropdown.present?
     # @browser.wait_until { username_dropdown.present? }
     # sleep 1
     # unless logout_link.present?
     #   sleep 5
     #   puts logout_link.present?
     #   #byebug
     # end
     # @browser.wait_until { logout_link.present? }
     # logout_link.click  #From Pages::Community::Layout
     # @browser.wait_until { !logout_link.present? }
     # @browser.wait_until { login_link.present? } 
    @browser.wait_until { @browser.ready_state == "complete" }
  end

   def get_timestamp
    return Time.now.utc.to_s.gsub(/[-: ]/,'')
  end

  def accept_policy_warning
    if @browser.div(:id => "policy-warning").present?
     #  # workaround for bug EN-2499
     # @browser.execute_script("window.scrollTo(0,1000)") 
     @browser.button(:css => ".policy-warning-button button.btn-primary").when_present.click
     @browser.wait_until { !@browser.div(:id => "policy-warning").present? }
     @browser.execute_script("window.scrollTo(0,document.documentElement.scrollTop)") 
    end
  end

  def about_login(type, user)
    if @browser.url != Pages::Community::About.new(@config).about_url
     @browser.goto Pages::Community::About.new(@config).about_url
    end
    @browser.wait_until { Pages::Community::About.new(@config).about_title_row.present? }
    @login_page = Pages::Community::Login.new(@config)
    if ( (@login_page.user_dropdown.present?) || (@login_page.topnav_notification.present?))
      @login_page.logout!
    end
    
    if user == "logged"
      raise "Invalid user type! Exit.." if @c.users[type.to_sym].nil?
      login(@c.users[type.to_sym])
      #  case type
      #   when "social_facebook_user"   
      #    login(@c.users[:social_facebook_user])
      #   when "social_linkedin_user"
      #    login(@c.users[:social_linkedin_user])
      #   when "social_google_user"
      #    login(@c.users[:social_google_user])
      #   when "social_twitter_user"
      #    login(@c.users[:social_twitter_user])
      #   when "regular_user1"
      #    login(@c.users[:regular_user1])
      #   when "regular_user2"
      #    login(@c.users[:regular_user2])
      #   when "regular_user3"
      #    login(@c.users[:regular_user3])
      #   when "regular_user4"
      #    login(@c.users[:regular_user4])
      #   when "network_admin" 
      #    login(@c.users[:network_admin])
      #   when "network_moderator"
      #    login(@c.users[:network_moderator])
      #   when "network_admin2"
      #    login(@c.users[:network_admin2])
      #   when "nf_network_admin"
      #    login(@c.users[:nf_network_admin])
      #   when "nf_regular_user1"
      #    login(@c.users[:nf_regular_user1]) 
      #   when "nf_regular_user2"
      #    login(@c.users[:nf_regular_user2]) 
      #   when "nf_network_moderator"
      #    login(@c.users[:nf_network_moderator]) 
      #   else
      #   raise "Invalid user type! Exit.."
      #  end 
      @browser.goto Pages::Community::About.new(@config).about_url
      @browser.wait_until { Pages::Community::About.new(@config).about_title_row.present? }
    end
    
    if user == "visitor"
      case type
       when "anon"
       if @login_page.user_dropdown.present?
         @login_page.logout!
       end
       @browser.goto Pages::Community::About.new(@config).about_url
       @browser.wait_until { Pages::Community::About.new(@config).about_banner.present? }
       else
      raise "Invalid user type! Exit.."
      end
    end
      accept_policy_warning
  end


   def login(user)
     #puts "#{user.inspect}"
     #puts "#{$logged_in_user.inspect}"
#     @browser.goto @login_page.login_url
    #return if user == $logged_in_user
    return if (user.username == $logged_in_user && !@login_page.signin_link.present?)
    #logout! unless is_logged_out?
   # @login_page = Pages::Community::Login.new(@config)
   # if (@login_page.user_dropdown.present?)
   #  logout!
   # end
    if (user.username != $logged_in_user) && ( @login_page.user_dropdown.present?)
     logout! #unless is_logged_out? # if we're logged in as someone else, logout first.
    end
    if @login_page.login_link.present? 
       #@browser.screenshot.save screenshot_dir('login.png') #for jenkins test
       @browser.goto @login_page.login_url
       @browser.wait_until { @login_page.login_page.present? }

       if user.user_ref== "social_twitter_user" || user.user_ref == "social_google_user" || user.user_ref =="social_linkedin_user" || user.user_ref =="social_facebook_user"
        @browser.wait_until { @browser.ready_state == "complete" }
      else
        login_helper(user)
       end
     end
   end

  def login_from_widget(user)
    return if user == $logged_in_user
    signin.when_present.click
    login_helper(user)
  end

  def login_helper(user)
   @login_page = Pages::Community::Login.new(@config)
   @login_page.member_login.set user.username
   @login_page.member_password.set user.password

   @login_page.login_submit.click

   @browser.wait_until { @login_page.user_dropdown.present?}
   #@convdetail_page = Pages::Community::ConversationDetail.new(@config)
   #@browser.wait_until { !@convdetail_page.spinner.present? }
   $logged_in_user = user # save for next time
  end

  def assert test, msg = nil
  msg ||= "Failed assertion, no message given."
  #self.assertions += 1
  unless test then
    msg = msg.call if Proc === msg
    raise MiniTest::Assertion, msg
  end
  true
end

  def self.layout_class
    Pages::Community::Layout
  end


end

require 'pages/community/layout'
require 'pages/community/login'
require 'pages/community/about'
