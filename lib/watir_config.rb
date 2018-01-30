require 'yaml'
require 'chrome_driver_process'
require 'api_helper'

class WatirConfig

  # This runs when class is loaded
  def self.first_run_setup

    # Code that should run before all tests. Once.
    @@filedata = YAML.load_file(File.expand_path(File.dirname(__FILE__) + "/../config/config.yml"))

    raise "unknown landscape '#{ENV['WATIR_LANDSCAPE']}'" unless @@filedata['env'][ENV['WATIR_LANDSCAPE']]
    raise "unknown tenant '#{ENV['WATIR_SLUG']}'" unless @@filedata['env'][ENV['WATIR_LANDSCAPE']][ENV['WATIR_SLUG']]
    @@browser_type = ENV['WATIR_BROWSER']
    @@landcape = ENV['WATIR_LANDSCAPE']
    @@slug = ENV['WATIR_SLUG']

    @@tenant_info = @@filedata['env'][@@landcape][@@slug]
    @@network_name = @@filedata['env'][@@landcape][@@slug]["network"]
    @@browser_resource = WatirConfig::BrowserResource.new(@@browser_type)
  end

  def self.shutdown_browser
    @@browser_resource.close
  end

  def self.startup_browser
    @@browser_resource.open
    @@browser_resource.b.window.maximize
  end

  # persist some data across tests such as cached uuid's, etc etc
  def self.data
    @data ||= {}
  end

  attr_reader :base_url, :os, :users, :data_dir

  def initialize
    @base_url = @@tenant_info["base_url"]
    @users = UserProxy.new(@@tenant_info['users'])
    @os = WatirConfig::Os.new(RUBY_PLATFORM)
    Watir.default_timeout = @@tenant_info["timeout"]
    @screenshot_dir = File.expand_path(File.dirname(__FILE__) + "/../screenshots")
    @data_dir = File.expand_path(File.dirname(__FILE__) + "/../test/data")
    FileUtils.mkdir_p(@screenshot_dir)

    @beta_feature = Hash.new
    if @@tenant_info["beta_feature_enabled"]
      @@tenant_info["beta_feature_enabled"].each do |key|
        @beta_feature[key.downcase] = true
      end
    end
  end

  def project_root
    File.expand_path(File.dirname(__FILE__) + "/..")
  end

  def data
    WatirConfig.data
  end

  def screenshot_dir
    @screenshot_dir
  end

  def data_dir
    @data_dir
  end  

  def timeout
    @@tenant_info["timeout"].to_i
  end

  def landscape
    @@landscape
  end
  def slug
    @@slug
  end
  def browser_type
    @@browser_type
  end
  def browser
    @@browser_resource.b
  end

  def network_name
    @@network_name
    #@@tenant_info["network"]
  end

  def yaas_url
    @@tenant_info["yaas_url"]
  end

  def hybris_url
    @@tenant_info["hybris_url"]
  end

  def superadmin_url
    @@tenant_info["superadmin_url"]
  end

  def gated_community?
    @@tenant_info["gated_community"].nil? ? false : @@tenant_info["gated_community"]
  end  

  def product_id_blank
    @@tenant_info["product_id_blank"]
  end

  def product_id_many
    @@tenant_info["product_id_many"]
  end

  def product_id_write
    @@tenant_info["product_id_write"]
  end

  def beta_feature
    @beta_feature
  end

  def verbose?
    ENV.include?('VERBOSE')
  end

  def extra_whitespace?
    ENV.include?('EXTRA_WHITESPACE')
  end

  def track_dom_usage?
    ENV.include?('TRACK_DOM_USAGE')
  end

  def screenshot!(name)
    browser.screenshot.save "#{@screenshot_dir}/#{name.gsub(/[^0-9A-Za-z_]/, '')}.jpg"
  end

  def api
    @api ||= ApiHelper.new(self)
  end

  def mail_catcher_url
    @@tenant_info["mail_catcher_url"]
  end

  def mail_catcher_url_with_credit
    @@tenant_info["mail_catcher_url_with_credit"]
  end

  # for testing new super admin
  def comm_template_name
    @@tenant_info["comm_template_name"]
  end 

  def comm_template_domain
    @@tenant_info["comm_template_domain"]
  end 

  def comm_template_subdomain
    @@tenant_info["comm_template_subdomain"]
  end  

  # def user(name)
  #   @@tenant_info[name.to_s]
  # end

  def download_dir
    @@browser_resource.download_dir
  end  

  def get_timestamp
    return Time.now.utc.to_s.gsub(/[-: ]/,'')
  end

  class Os
    def initialize(ruby_platform)
      @platform = ruby_platform
    end
    def windows?
      @platform =~ /cygwin|mswin|mingw|bccwin|wince|emx/
    end
    def mac?
      @platform =~ /darwin/
    end
    def linux?
      @platform =~ /linux/
    end
  end


  class BrowserResource
    attr_reader :b
    def initialize(browser_type)
      @browser_type = browser_type
      @started = false
      @b = nil
    end
    def started?
      @started
    end

    def download_dir
      "#{Dir.pwd}/downloads"
    end  

    def open
      return if started?
      @b = case @browser_type
        when "firefox"
          profile = ::Selenium::WebDriver::Firefox::Profile.new
          profile['network.proxy.type'] = 1
          profile['network.proxy.http'] = "proxy.wdf.sap.corp"
          profile['network.proxy.http_port'] = 8080
          profile['network.proxy.ssl'] = "proxy.wdf.sap.corp"
          profile['network.proxy.ssl_port'] = 8080
          #profile['network.proxy.ssl'] = "http://proxy.wdf.sap.corp:8080"
          # profile['network.proxy.autoconfig_url'] = "http://proxy.wdf.sap.corp:8083"
          profile['network.proxy.no_proxies_on'] = "localhost, *.mo.sap.corp"
          profile['assume_untrusted_certificate_issuer'] = false
          ::Watir::Browser.new :firefox, :profile => profile


        when "ie"
          ::Watir::Browser.new :ie

        when "chrome"
          ::ChromeDriverProcess.start

          # Add this capabilities to support download test cases
          caps = { :chromeOptions => {
                      :prefs => {
                        'download.prompt_for_download' => false,
                        'download.default_directory' => download_dir
                      }
                    }
                  }
          Dir.mkdir(download_dir) unless File.exists?(download_dir)
                  
          ::Watir::Browser.new :remote, :desired_capabilities => caps, url: ::ChromeDriverProcess.remote_url
        else
          raise "Invalid browser type #{@browser_type}! Exit!"
      end
      @started = true
    end
    def close
      case @browser_type
        when "firefox"
          @b.close
        when "ie"
          @b.close
        when "chrome"
          @b.quit
      end
      @started = false
    ensure
      ::ChromeDriverProcess.exit if @browser_type == "chrome"
    end
  end

  class UserProxy
    attr_reader :users

    def initialize(data)
      @users = Hash[data.map { |ref,record| [ ref, User.new(ref, *record) ] }]
    end
    def [](user_ref)
      @users[user_ref.to_s]
    end
  end

  class User
    # user_ref, first parameter, is the key in the config hash, not the actual username
    # TODO: deprecate user_ref because ugh.
    attr_reader :user_ref, :email, :password, :username, :name, :login_type, :token
    def initialize(*paramlist)
      @user_ref, @email, @password, @username, @name, @login_type, @token = paramlist
    end
  end

  first_run_setup

end
