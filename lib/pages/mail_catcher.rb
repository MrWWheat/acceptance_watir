require 'pages/base'

class Pages::MailCatcher < Pages::Base

  def initialize(config, options = {})
    super(config)
    @url = config.hybris_url
  end

  def self.layout_class
    Pages::MailCatcher
  end

  confirm_mail                    { nav(:id => "messages") }
  confirm_content                 { table(:class => "products") }
  here_link                       { links(:text => /here/) }
  register_link                   { link(:text => /Register here/) }
  reset_pwd_link                  { link(:text => /Reset Your Password/) }
  confirm_account_link            { link(:text => /Confirm my account/) }
  mailcatcher_message_items       { trs(:css => "#messages tbody tr") }

  def goto_mail order_number
    mail_subject = "Your Order #{order_number} has been Shipped - Automated Message - DO NOT REPLY"
    get_mail_url(mail_subject)
  end

  def get_order_mails(order_number, expected_num)
    mail_subject = "Your Order #{order_number} has been Shipped - Automated Message - DO NOT REPLY"
    get_mail_urls(mail_subject, expected_num)
  end  

  def goto_review item
    @browser.wait_until($t) {confirm_content.present?}
    here_link[item].when_present.click
  end

  def goto_reset_mail register_mail
    mail_subject = "<" + register_mail + "> SAP Jam Communities reset password instructions"
    get_mail_url(mail_subject)
  end

  def goto_invitation_mail register_mail
    mail_subject = "<" + register_mail + "> SAP Jam Communities Invitation instructions"
    get_mail_url(mail_subject)
  end

  def goto_confirm_mail register_mail
    mail_subject = "<" + register_mail + "> SAP Jam Communities confirmation instructions"
    get_mail_url(mail_subject)
  end

  def get_mail_url(subject)
    @browser.wait_until($t) {confirm_mail.present?}

    begin
      @browser.wait_until(60) { !mailcatcher_message_items.find { |m| m.text.include?(subject) }.nil? } 
    rescue Watir::Wait::TimeoutError
      # sometimes, the expected mail won't appear unless refresh
      @browser.refresh
      @browser.wait_until($t) {confirm_mail.present?}
      @browser.wait_until(60) { !mailcatcher_message_items.find { |m| m.text.include?(subject) }.nil? } 
    end  

    expected_message = mailcatcher_message_items.find { |m| m.text.include?(subject) }

    raise "Cannot receive the email #{subject}" if expected_message.nil?
    message_id = expected_message.attribute_value("data-message-id")
    @browser.url + "/messages/#{message_id}.html"
  end 

  def get_mail_urls(subject, expected_num, timeout=2*60)
    @browser.wait_until($t) {confirm_mail.present?}

    expected_messages = []
    start_time = Time.now
    while ((Time.now - start_time) < timeout)
      find_start_time = Time.now
      while (Time.now - find_start_time) < 2*60 # necessary since it took long time to load all emails
        unless mailcatcher_message_items.find { |m| m.text.include?(subject) }.nil?
          break
        else
          sleep 1  
        end  
      end 

      unless mailcatcher_message_items.find { |m| m.text.include?(subject) }.nil?
        expected_messages = []
        mailcatcher_message_items.each do |m|
          if m.text.include?(subject)
            expected_messages << m

            break if expected_messages.size == expected_num
          end  
        end 
      end  

      break if expected_messages.size == expected_num

      # refresh browser if not received after 2*60 seconds later
      @browser.refresh
      @browser.wait_until { confirm_mail.present? }
    end 

    raise "Find #{expected_messages.size} emails with subject #{subject} after #{timeout} seconds. Expect #{expected_num} emails." unless expected_messages.size == expected_num
    expected_urls = []

    expected_messages.each do |m|
      message_id = m.attribute_value("data-message-id")
      expected_urls << @browser.url + "/messages/#{message_id}.html"
    end  

    expected_urls
  end 

  def confirm_email user_email
    @browser.goto @config.mail_catcher_url
    mail_link = goto_confirm_mail user_email
    @browser.goto mail_link
    confirm_account_link.when_present.click
    @browser.wait_until { @browser.h4(:text => "Your account's email is now confirmed!").present? } 
  end
end