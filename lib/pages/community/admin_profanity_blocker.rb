require 'pages/community/admin'
require 'pages/community/home'

class Pages::Community::AdminProfanityBlocker < Pages::Community::Admin

  def initialize(config, options = {})
    super(config)
    @url = config.base_url + "/admin/#{@config.slug}/profanity_blocker"
  end

  def start!(user)
    @home_page = Pages::Community::Home.new(@config)
    @home_page.start!(user)

    navigate_in
  end

  admin_content_mod              { div(:class => "panel-heading", :text => /Content Administration/) }
  admin_profanity_blocker        { link(:href => /profanity_blocker/) }

  profanity_disable_btn             { button(:id => "profanity_disable_btn") }
  profanity_enable_btn              { button(:id => "profanity_enable_btn")} 

  dialog                          { div(:id => "profanity-upload-success") }

  def navigate_in
    super
    scroll_to_element admin_accordion_toggle_integrations
    switch_to_sidebar_item(:profanity_blocker)
    
    @browser.wait_until($t) { profanity_disable_btn.present? || profanity_enable_btn.present? }
  end

  def enable_profanity_blocker (networkslug, enable)
    @browser.wait_until{ admin_profanity_blocker.present? }
    import = @browser.file_field(:class => /profanity-import-input/)
    if enable
      if profanity_enable_btn.present?
        profanity_enable_btn.when_present.click
      end 
      @browser.wait_until($t) {import.exists?}
      import.set(File.expand_path(File.dirname(__FILE__)+"../../../../seeds/development/files/blocklist.csv"))
      @browser.wait_until($t) { dialog.present? }
      dialog.button.when_present.click
    else
      if profanity_disable_btn.present?
        profanity_disable_btn.when_present.click 
      end
      @browser.wait_until($t) {!import.exists?}
    end

    # add for debug why the settings don't take effect sometimes
    @config.screenshot!("profanity_blocker_setting" + Time.now.to_s)
  end
 
end