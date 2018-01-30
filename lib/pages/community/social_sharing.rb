require 'pages/community'
require 'pages/base'

class Pages::Community::SocialSharing < Pages::Community

  def initialize(config, options = {})
    super(config)

    @facebook_url = "https://www.facebook.com/"
    @twitter_url = "https://twitter.com"
    @linkedin_url = "https://www.linkedin.com/in/watir-sociallink-896789a5/recent-activity/"
    #due to linked in UI change, we cannot get to this page successfully. So temporarily go to the url directly.

  end

  facebook_email_field                          { text_field(:id => "email") }
  facebook_password_field                       { text_field(:id => "pass") }
  facebook_login_button                         { button(:type => "submit" , :value => "Log In") }
  facebook_sharing_content                      { div(:class => "innerWrap").text_field(:class => /textInput/)}
  facebook_sharing_submit_button                { button(:name => /CONFIRM/)}
  facebook_first_post_content                   { div(:css => "#substream_0 [class*=userContent]") }
  facebook_first_post_dropdown_btn              { div(:css => "#substream_0 [class*=uiPopover]") }
  facebook_post_image                           { div(:css => "#substream_0 [class*=ImageContainer]") }
  facebook_post_delete_btn                      { div(:class => /uiContextualLayer/).span(:text => /Delete/)}
  facebook_delete_confirm_btn                   { button(:text => /Delete Post/)}

  twitter_email_field                     { text_field(:id => "username_or_email") }
  twitter_password_field                  { text_field(:id => "password") }
  twitter_login_button                    { input(:type => "submit" , :value => "Log in and Tweet")}
  twitter_my_tweet_btn                    { div(:class => "ProfileCardStats").span(:text => "Tweets")}
  twitter_content                         { div(:class => "ProfileTimeline ")}
  twitter_post_title                      { div(:class => "js-tweet-text-container")}
  twitter_post_product_card               { div(:class => "js-macaw-cards-iframe-container card-type-summary_large_image")}
  twitter_first_post_dropdown_btn         { div(:class => "stream").div(:class => "dropdown").button}
  twitter_post_delete_btn                 { div(:class => "dropdown open").div(:class => "dropdown-menu").button(:text => "Delete Tweet")}
  twitter_delete_confirm_btn              { button(:css => ".delete-action")}

  linkedin_sign_in_link                   { link(:class => "sign-in-link")}
  linkedin_email_field                    { text_field(:name=>"session_key") }
  linkedin_password_field                 { text_field(:id => "session_password-login") }
  linkedin_login_button                   { input(:type => "submit" , :value => "Sign In") }
  linkedin_share_btn                      { input(:type => "submit" , :value => "Share")}
  linkedin_profile_tab                    { img(:class => "feed-s-identity-module__member-photo")}
  linkedin_your_activity                  { section(:class => "artdeco-container-card pv-recent-activity-section")}
  linkedin_see_all_activity               { link(:class =>"pv-recent-activity-section__see-more-inline")}
  linkedin_updates_link                   { link(:text => "Your Updates")}
  linkedin_post_content                   { element(:css => ".article")}
  linkedin_no_product_img                 { link(:class => "feed-s-no-hero-entity")}
  linkedin_post_title                     { article(:class => /image-description/).h2}
  linkedin_post_des                       { div(:class => "snippet-container").span}
  linkedin_post_sitelink                  { article(:class => /image-description/).h3}
  linkedin_header                         { div(:class => "header ")}
  linkedin_first_post_dropdown_btn        { div(:class => "feed-base-update-control-panel-trigger").span}
  linkedin_post_delete_btn                { button(:class => "option-button__delete")}
  linkedin_delete_confirm_btn             { button(:class =>"feed-s-decision-modal__confirm-button") }

  gmail_email_field                       { text_field(:id => "identifierId") }
  gmail_next_button                       { input(:value => "Next") }
  gmail_pass                              { text_field(:id => "Passwd") }
  gmail_login                             { input(:type => "submit" , :value => "Sign in") }


  def social_sharing type, content
    @email = eval(type.to_s + "_email_field")
    @password = eval(type.to_s + "_password_field")
    @user = "social_" + type.to_s + "_user"
    @login_btn = eval(type.to_s + "_login_button")

    @browser.window(:url => /#{type}.com/).when_present.use do
      linkedin_sign_in_link.when_present.click if type == :linkedin
      @email.when_present.set @c.users[@user].email
      @password.when_present.set @config.users[@user].password
      @login_btn.when_present.click
      case type
        when :facebook
          facebook_sharing_content.when_present.set content
          facebook_sharing_submit_button.when_present.click
        when :linkedin
          linkedin_share_btn.when_present.click
      end
    end
  end

  def social_sharing_check type
    case type
      when :facebook
        @browser.goto @facebook_url
        #sometimes facebook will not load the newest post immediately. So sleep for a while.
        sleep(5)
        @browser.refresh
        @browser.send_keys :escape
        @browser.send_keys :escape
        @browser.wait_until($t){ facebook_first_post_content.present? }
      when :twitter
        @browser.goto @twitter_url
        twitter_my_tweet_btn.when_present.click
        @browser.wait_until($t){ twitter_content.present? }
      when :linkedin
        @browser.goto @linkedin_url
        sleep(20)
        @browser.refresh
        begin
          @browser.wait_until ($t){ linkedin_post_content.present? }
        rescue Watir::Wait::TimeoutError => e
          puts "Failed to find post in linkedin"
          if @browser.element(:text => /continue anyway/).present?
            puts "Upgrade browser page is displayed"
            @browser.link(:text => /continue anyway/).click
            @browser.wait_until ($t){ linkedin_post_content.present? }
          else
            raise e  
          end  
        end  
    end
  end

  def social_post_delete type
    dropdown = eval(type.to_s + "_first_post_dropdown_btn")
    delete = eval(type.to_s + "_post_delete_btn")
    confirm = eval(type.to_s + "_delete_confirm_btn")
    dropdown.when_present.click
    delete.when_present.click
    if type == :linkedin
      @browser.button(:class => /confirm-button/).when_present.click
    else  
      confirm.when_present.click
    end  
  end
end