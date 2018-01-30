require 'yaml'
require 'byebug'
require 'httparty'

class APITestConfig
  # This runs when class is loaded
  def self.first_run_setup
    # Code that should run before all tests. Once.
    @@filedata = YAML.load_file(File.expand_path(File.dirname(__FILE__) + "/../../config/config.yml"))
    @@testdata = YAML.load_file(File.expand_path(File.dirname(__FILE__) + "/../../test/api/data/config.yml"))

    raise "unknown landscape '#{ENV['LANDSCAPE']}'" unless @@filedata['env'][ENV['LANDSCAPE']]
    raise "unknown tenant '#{ENV['SLUG']}'" unless @@filedata['env'][ENV['LANDSCAPE']][ENV['SLUG']]

    raise "unknown landscape '#{ENV['LANDSCAPE']}'" unless @@testdata['env'][ENV['LANDSCAPE']]
    raise "unknown tenant '#{ENV['SLUG']}'" unless @@testdata['env'][ENV['LANDSCAPE']][ENV['SLUG']]

    @@landscape = ENV['LANDSCAPE']
    @@slug = ENV['SLUG']

    @@tenant_info = @@filedata['env'][@@landscape][@@slug]
    @@api_test_data = @@testdata['env'][@@landscape][@@slug]
  end

  # persist some data across tests such as cached uuid's, etc etc
  def self.data
    @data ||= {}
  end

  attr_reader :base_url, :users, :api_data, :data_dir

  def initialize
    @base_url = @@tenant_info["base_url"]
    @users = UserProxy.new(@@tenant_info['users'])
    @api_data = @@api_test_data
    @data_dir = File.expand_path(File.dirname(__FILE__) + "/data/")

    Airborne.configure do |config|
      config.base_url = @base_url
    end
  end

  def project_root
    File.expand_path(File.dirname(__FILE__) + "/..")
  end

  def data
    WatirConfig.data
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

  def network_name
    @@tenant_info["network"]
  end

  def verbose?
    ENV.include?('VERBOSE')
  end

  # def user(name)
  #   @@tenant_info[name.to_s]
  # end

  def get_timestamp
    return Time.now.utc.to_s.gsub(/[-: ]/,'')
  end

  def access_token
    get_access_token_by_user(:network_admin)
  end

  def access_token_of_moderater
    get_access_token_by_user(:network_moderator)
  end

  def get_access_token_by_user(user)
    headers = { 'Content-Type' => 'application/json', 'Accept' => 'application/json' }
    @app_id = @api_data['application_id']
    @sec_id = @api_data['secret_id']
    @username = @users[user].username
    @password = @users[user].password

    url = "#{base_url}/oauth/token?grant_type=password&client_id=#{@app_id}&client_secret=#{@sec_id}&username=#{@username}&password=#{@password}"
    response = HTTParty.post(url, body: nil, headers: headers, :verify => false)
    return JSON.parse(response.body)['access_token'] if response.code == 200
    return nil
  end

  def user_headers(user)
    {:Authorization => "Bearer #{get_access_token_by_user(user)}",
     :Accept => "application/json", 
     :content_type => "application/json", 
     :verify_ssl => false}
  end 

  class UserProxy
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
    attr_reader :user_ref, :email, :password, :username, :name, :login_type
    def initialize(*paramlist)
      @user_ref, @email, @password, @username, @name, @login_type = paramlist
    end
  end

  first_run_setup
end
