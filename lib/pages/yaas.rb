require 'pages/base'

class Pages::Yaas < Pages::Base

  def ensure_first_time_browser_boot!
    # if username or login_link are present, we know we've already booted the browser app
    # unless ( username.present? || login_link.present? )
    #   puts "first time browser boot...." if @config.verbose?
      @browser.goto url
      @browser.wait_until { profile_link.present? || login_link.present? }
      puts "browser booted" if @config.verbose?
    # end
  end

  def ensure_correct_user!(user_ref)
    case user_ref
      when :anonymous
        puts "logging out to run as anonymous..." if @config.verbose?
        logout!
      when nil
        puts "user nil"
        logout!
        raise "we should not have a nil user. Why is there a nil user here?"
      else
        puts "logging in to run as #{user_ref}" if @config.verbose?
        login!(@c.users[user_ref])
    end
  end

  def is_logged_in?(user)
    return false if is_logged_out?
    return true
  end

  def is_logged_out?
    @browser.wait_until { (login_link.present? && !profile_link.present?) ||
        (!login_link.present? && profile_link.present?) }
    login_link.present?
  end

  def login!(user)
    @login_page = Pages::Yaas::Login.new(@config)
    @login_page.login!(user)
  end

  def logout!
    @browser.execute_script("window.scrollBy(0,-10000)")
    return if is_logged_out?

    puts "actually logging out..." if @config.verbose?

    @browser.wait_until { profile_link.present? }
    profile_link.click  #From Pages::Yaas::Layout
    logout_btn.when_present.click
    @browser.wait_until { !profile_link.present? }
    @browser.wait_until { login_link.present? }
  end

  def self.layout_class
    Pages::Yaas::Layout
  end

end

require 'pages/hybris/login'
require 'pages/yaas/layout'
