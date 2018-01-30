require 'pages/base'

class Pages::NewSuperAdmin < Pages::Base
  def ensure_first_time_browser_boot!
    # if username or login_link are present, we know we've already booted the browser app
    #unless ( username.present? || login_link.present? )
    #  puts "first time browser boot...." if @config.verbose?
      #puts url
      @browser.goto url
      @login_page = Pages::NewSuperAdmin::Login.new(@config)
      @browser.wait_until { @login_page.newsa_login_sign_in_btn.present? || 
                            @login_page.newsa_user_dropdown_toggle.present? }
      puts "browser booted" if @config.verbose?
    #end
  end

  def ensure_correct_user!(user_ref)
    case user_ref
      when :anonymous
        puts "logging out to run as anonymous..." if @config.verbose?
        logout
      when nil
        puts "user nil"
        raise "we should not have a nil user. Why is there a nil user here?"
      else
        puts "logging in to run as #{user_ref}" if @config.verbose?
        @login_page = Pages::NewSuperAdmin::Login.new(@config)

        if @login_page.newsa_user_dropdown_toggle.present?
          unless @login_page.newsa_user_dropdown_toggle.text.downcase == @c.users[user_ref].email
            logout
            @login_page.login(@c.users[user_ref].email, @c.users[user_ref].password)
          end  
        else
          @login_page.login(@c.users[user_ref].email, @c.users[user_ref].password)
        end  
    end
  end

  def logout
    @login_page = Pages::NewSuperAdmin::Login.new(@config)
    if @login_page.newsa_user_dropdown_toggle.present?
        @login_page.newsa_user_dropdown_toggle.click
        @login_page.newsa_user_signout_menu.when_present.click
        @browser.wait_until {@login_page.newsa_login_sign_in_btn.present?}
    else
      @browser.wait_until {@login_page.newsa_login_sign_in_btn.present?}
    end
  end  

	def self.layout_class
    Pages::NewSuperAdmin::Layout
  end
end

require 'pages/newsa/layout'
require 'pages/newsa/login'