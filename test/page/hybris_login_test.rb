require 'watir_test'
require 'pages/hybris/home'
require 'pages/hybris/list'
require 'pages/hybris/detail'
require 'pages/social_login'
require 'actions/hybris/common'
require 'actions/hybris/api'
require 'pages/community/layout'

class HybrisLoginTest < WatirTest

  def setup
    super
    @hybris_home_page = Pages::Hybris::Home.new(@config)
    @hybris_login_page = Pages::Hybris::Login.new(@config)
    @hybris_list_page = Pages::Hybris::List.new(@config)
    @hybris_detail_page = Pages::Hybris::Detail.new(@config)
    @socail_login_page = Pages::SocialLogin.new(@config)
    @common_actions = Actions::Common.new(@config)
    @api_actions = Actions::Api.new(@config)
    @community_layout_page = Pages::Community::Layout.new(@config)

    puts "[[[ #{name} ::: nil ]]]" if @config.verbose?
    @browser = @c.browser
    @hybris_home_page.start!(user_for_test)

    #@review = nil
  end

  def teardown
    super
    @hybris_detail_page.go_to_community_by_review
    @browser.window(:url => /#{@c.base_url}/).when_present.use do
      @common_actions.break_mapping
      @browser.window.close
    end
    @browser.wait_until{ @hybris_detail_page.logout_link.present? }
    @hybris_login_page.logout!
    #@api_actions.delete_review(@config.users[:network_admin], @review) if @review
  end

  user :hybris_tmp
  p1
  def test_00300_b2b_facebooklogin_nomapped
    @common_actions.go_to_product_detail @config.product_id_write
    @hybris_detail_page.go_to_community_by_review
    @browser.window(:url => /#{@c.base_url}/).when_present.use do
      if !@community_layout_page.login_link.present?
        @common_actions.break_mapping
        @browser.window.close
      end
    end
    @hybris_detail_page.social_login_nomapped :facebook
    @browser.window(:url => /facebook/).when_present.use do
      @socail_login_page.socail_login :facebook
    end
    @browser.wait_until($t) {@hybris_detail_page.question_modal.present?}
    if @browser.windows.size > 1
      @browser.windows.last.close
    end
    @hybris_detail_page.create_question
    #@review = @hybris_detail_page.get_review_uuid_by_title "title"
  end

  user :hybris_tmp
  p1
  def test_00301_b2b_twitterlogin_nomapped
    @common_actions.go_to_product_detail @config.product_id_write
    @hybris_detail_page.social_login_nomapped :twitter
    @browser.window(:url => /twitter/).when_present.use do
      @socail_login_page.socail_login :twitter
    end
    @hybris_detail_page.create_question
    #@review = @hybris_detail_page.get_review_uuid_by_title "title"
  end

  user :hybris_tmp
  p1
  def test_00302_b2b_linkedinlogin_nomapped
    @common_actions.go_to_product_detail @config.product_id_write
    @hybris_detail_page.social_login_nomapped :linkedin
    @browser.window(:url => /linkedin/).when_present.use do
      @socail_login_page.socail_login :linkedin
    end
    @hybris_detail_page.create_question
    #@review = @hybris_detail_page.get_review_uuid_by_title "title"
  end

  user :hybris_tmp
  p1
  def xtest_00303_b2b_googlelogin_nomapped
    @common_actions.go_to_product_detail @config.product_id_write
    @hybris_detail_page.social_login_nomapped :google
    @browser.window(:url => /google/).when_present.use do
      @socail_login_page.socail_login :google
    end
    @hybris_detail_page.create_question

    @review = @hybris_detail_page.get_review_uuid_by_title "title"
  end

end