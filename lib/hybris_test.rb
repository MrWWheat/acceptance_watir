require 'httparty'
require 'json'

# Before you copy/paste this code, ask yourself: do i know what files i am including?
# Do i actually need to include these files?
#  What if someone puts a file in that directory that i don't expect or don't want?
#  whose fault is it that it breaks? the person who put the file in a reasonable place, or the person who included it blindly?
Dir[File.expand_path(File.dirname(__FILE__)+"/*.rb")].each do |file|
  require file unless file =~ /api_helper|watir_config|watir_test|lazy_dsl_tag_collector|test_helper|api_main/
end
Dir[File.expand_path(File.dirname(__FILE__)+"/page_objects/*.rb")].each do |file|
  require file
end
module HybrisTest
  def initialize_pages
    @home_page = ::HybrisHomePageObject.new(@browser)
    @list_page = ::HybrisProductListPageObject.new(@browser)
    @detail_page = ::HybrisProductDetailPageObject.new(@browser)
    @header_page = ::HybrisHeaderPageObject.new(@browser)
    @login_page = ::HybrisLoginPageObject.new(@browser)
    @dialog_page = ::HybrisDialogPageObject.new(@browser)
    @search_page = ::HybrisProductSearchResultPageObject.new(@browser)
    @community_page = ::HybrisCommunityPageObject.new(@browser)
    @cart_page = ::HybrisShoppingcartPageObject.new(@browser)
    @swagger_page = ::SwaggerPageObject.new(@browser)
  end

  def open_site
    #if !(@browser.url.include? $base_url)
      @home_page.open
    #end
  end

  def landing_community_adminpage
      @community_page.open_homepage
      @community_page.log_out if @community_page.logged_in?
      @community_page.login $communityadmin
      @community_page.go_to_admin
  end

  def change_theme(font)
      @community_page.change_theme_font font
  end

  def reset_theme
      @community_page.reset_theme
  end

  def log_out
    if @header_page.login?
      @header_page.log_out
    end
  end

  def api_get_cookie(resp)
    mtch = resp.headers['set-cookie'].match(/_excelsior_session=\w+\;/)[0]
  end

  def api_get_csrf_token(resp)
    csrf = resp.body.match('<meta name="csrf-token" content="(?<csrf>.*)" \/>')["csrf"]
  end

  def api_login_community(community_user)
    iframe_url = $community_base_url + "/iframe/comment"
    sign_in_url = $community_base_url + "/registered_users/sign_in.json"
    resp = HTTParty.get(iframe_url,  :verify => false)

    cookie = api_get_cookie(resp)
    crsf_token = api_get_csrf_token(resp)

    headers = {
      "Cookie" => "#{cookie}",
      "X-CSRF-Token" => "#{crsf_token}",
      "Content-Type" => "application/json"
    }

    post_data = {"registered_user": {"login": community_user[0], "password": community_user[1],"network_slug": $network_slug},"utf8": "✓"}.to_json

    rtn = HTTParty.post(sign_in_url, body: post_data, :headers => headers, :verify => false)
  end

  def break_mapping_via_ui hybris_user=nil
    if hybris_user
      login_hybris hybris_user
      @detail_page.check_loaded
    end
    if @detail_page.has_reviews?
      @detail_page.go_to_review
    elsif @detail_page.has_questions?
      @detail_page.go_to_question
    else
      puts "no link for community"
      return
    end
    sleep 5
    if @community_page.check_mapped
      @community_page.go_to_account_setting
      @community_page.break_mapping
      @community_page.log_out
    else
      puts "the user is not mapped yet"
    end
    @browser.windows.last.close
  end

  def break_mapping_via_api(hybris_user=nil, community_user=nil)
    puts "breaking mapping via api"
    rtn = api_login_community(community_user)

    json = JSON.parse(rtn.to_json)
    cookie = api_get_cookie(rtn)
    csrfToken = JSON.parse(rtn.body)['csrfToken']

    headers = {
      "Cookie" => cookie,
      "X-CSRF-Token" => csrfToken,
      "Content-Type" => "application/json"
    }

    if json['mapping_uid'] == hybris_user[0]
      uuid = json['uuid']
      break_mapping_url = "#{$community_base_url}/api/v1/OData/Members('#{uuid}')/BreakMapping()"

      response = HTTParty.post(break_mapping_url, :headers => headers, :verify => false)
      if response.code == 204
        return true
      else
        return false
      end
    elsif json['mapping_uid'] == nil
      return true
    end
  end

  def delete_review_via_api(community_user, reviewId)
    puts "deleting review via api call", reviewId
    rtn = api_login_community(community_user)

    json = JSON.parse(rtn.to_json)
    cookie = api_get_cookie(rtn)
    csrfToken = JSON.parse(rtn.body)['csrfToken']

    headers = {
      "Cookie" => cookie,
      "X-CSRF-Token" => csrfToken,
      "Content-Type" => "application/json"
    }

    delete_conversation_url = "#{$community_base_url}/api/v1/OData/Conversations('#{reviewId}')"

    response = HTTParty.delete(delete_conversation_url, :headers => headers, :verify => false)
    response.code
  end

  def check_homepage
  	@home_page.check_questions
    @home_page.check_reviews
  end

  def search_product(product)
  	@header_page.search product
    @list_page.check_loaded
  end
  
  def product_list(category_level1, category_level2)
    if !(@browser.url.include? "\/c\/")
      @header_page.go_to_list_page(category_level1,category_level2)
      @list_page.check_loaded
    end
  end

  def check_listpage
    @list_page.check_productlist_component
  end

  def product_detail(product_id)
    if !(@browser.url.include? "/p/"+product_id)
      @header_page.search product_id
      @list_page.check_loaded
      @list_page.go_to_product_detail
      begin
        @detail_page.check_loaded
      rescue
        @browser.refresh
        @detail_page.check_loaded
      end
    end
  end

  def login_hybris(hybrisuser)
    if !@header_page.login?
      @header_page.go_to_login
      @login_page.login hybrisuser
    end
  end

  def community_logout
    @community_page.log_out
  end

  def check_detailpage_with_no_content
    @detail_page.check_recent_review
    @detail_page.check_recent_question
  end

  def read_all_reviews
    @detail_page.read_all_reviews
    sleep 1
  end

  def read_all_questions
    @detail_page.read_all_questions
    sleep 1
  end

  def precondition_user_mapped(hybris_user, community_user)
    login_hybris hybris_user
    @detail_page.check_loaded
    @detail_page.ask_question_from_snippet_link
    begin
      @dialog_page.check_loaded
    rescue
      @detail_page.ask_question_from_snippet_link
      @dialog_page.check_loaded
    end
    if !@dialog_page.has_login?
      puts  "#{hybris_user} has not mapped"
      @dialog_page.login community_user
      @dialog_page.check_loaded
    end
    @browser.refresh
    log_out
    @detail_page.check_loaded
  end

  def precondition_user_not_mapped(hybris_user, community_user)
    if community_user != nil
      if !break_mapping_via_api(hybris_user,community_user)
        break_mapping_via_ui hybris_user
        log_out
        @detail_page.check_loaded
      end
    else
      break_mapping_via_ui hybris_user
      log_out
      @detail_page.check_loaded
    end
  end

  def write_review_with_hybrislogin_nomapped(hybris_user, community_user, rating, title,content)
    @detail_page.write_review_from_snippet_link
    @login_page.login hybris_user
    begin
      @dialog_page.check_loaded
    rescue
      @detail_page.write_review_from_snippet_link
      @dialog_page.check_loaded
    end
  	@dialog_page.login community_user
    create_review community_user, rating, title, content
  end

  def write_review_with_hybrislogin_mapped(hybris_user, community_user, rating, title, content)
    @detail_page.write_review_from_snippet_link
    @login_page.login hybris_user
    begin
      @dialog_page.check_loaded
    rescue
      @detail_page.write_review_from_snippet_link
      @dialog_page.check_loaded
    end
    create_review community_user, rating, title, content
  end

  def ask_question_mapped(title, content)
    @detail_page.ask_question_from_snippet_link
    create_question title, content
  end

  def ask_question_with_hybrislogin_nomapped(hybris_user, community_user, title, content)
    @detail_page.ask_question_from_snippet_link
    @login_page.login hybris_user
    begin
      @dialog_page.check_loaded
    rescue
      @detail_page.ask_question_from_snippet_link
      @dialog_page.check_loaded
    end
    @dialog_page.login community_user
    create_question title, content
  end

  def sort_reviews
    read_all_reviews
    @detail_page.sort(:oldest)
    @detail_page.sort(:newest)
  end

  def sort_questions
    read_all_questions
    @detail_page.sort(:oldest)
    @detail_page.sort(:newest)
    @detail_page.sort(:most_reply)
    @detail_page.sort(:least_reply)
  end

  def sort_blogs
    @detail_page.activate_tab(:blog)
    @detail_page.sort(:oldest)
    @detail_page.sort(:newest)
  end

  def sort_discussions
    @detail_page.activate_tab(:discussion)
    @detail_page.sort(:oldest)
    @detail_page.sort(:newest)
  end

  def sort_community_search_result
    @search_page.activate_tab(:community)
    @search_page.sort(:oldest)
    @search_page.sort(:newest)
  end

  def filter_community_search_result_by_questions
    @search_page.activate_tab(:community)
    @search_page.filter(:questions)
  end

  def filter_community_search_result_by_reviews
    @search_page.activate_tab(:community)
    @search_page.filter(:reviews)
  end

  def filter_community_search_result_by_blogs
    @search_page.activate_tab(:community)
    @search_page.filter(:blogs)
  end

  def filter_community_search_result_by_discussions
    @search_page.activate_tab(:community)
    @search_page.filter(:discussions)
  end

  def paging_community_search_result
    @search_page.activate_tab(:community)
    @search_page.paging
  end

  def paging_questions
    read_all_questions
    @detail_page.paging
  end

  def paging_reviews
    read_all_reviews
    @detail_page.paging
  end

  def paging_blogs
    @detail_page.activate_tab(:blog)
    @detail_page.paging
  end

  def paging_discussions
    @detail_page.activate_tab(:discussion)
    @detail_page.paging
  end

  def show_more_answers
    @detail_page.read_all_questions
    @detail_page.sort(:most_reply)
    @detail_page.show_more_answers
  end

  def create_question title, content
    @dialog_page.create_question(title,content)
    @detail_page.check_recent_question title
  end

  def vote_qustion
    read_all_questions
    @detail_page.vote_up
    @detail_page.vote_down
  end

  def click_helpful
    read_all_reviews
    @detail_page.click_helpful
  end

  def cover_community_user hybris_temp_user, community_user
    @detail_page.write_review_from_snippet_link
    @login_page.login hybris_temp_user
    begin
      @dialog_page.check_loaded
    rescue
      @detail_page.write_review_from_snippet_link
      @dialog_page.check_loaded
    end 
    @dialog_page.login community_user
    @dialog_page.close
    @detail_page.check_loaded
    @header_page.log_out
  end

  def create_review community_user, rating, title, content
    @dialog_page.create_review(rating,title,content)
    review_uuid = @detail_page.check_recent_review title
    if review_uuid != nil
      rc = delete_review_via_api(community_user, review_uuid)
      assert rc == 204, "failed to deleting review via api"
    else
      @detail_page.go_to_review
      @community_page.delete_post
      @browser.windows.last.close
    end
  end

  def social_login_nomapped social_type, social_user, hybris_user
    login_hybris hybris_user
    @detail_page.check_loaded
    @detail_page.ask_question_from_snippet_link
    @dialog_page.check_loaded
    @dialog_page.social_login(social_type,social_user)
    create_question "social_login-#{get_timestamp}","content-#{get_timestamp}"
    @header_page.log_out
  end

  def go_to_review_from_homepage
    @home_page.go_to_first_review
  end

  def at_mention_product_on_reply product_hint
    product_link = @community_page.at_mention_product_on_reply product_hint
    @browser.refresh
    @community_page.check_recent_mentioned_product product_link  
  end

  def edit_mention_product_on_reply product_hint
    sleep 5
    @community_page.sort_by "Newest"
    post = @browser.div(:class => "ember-view depth-1", :text=> /(Add To Cart|Buy Now)/)
    @browser.wait_until{ post.present? }
    product_link = @community_page.edit_mention_product_on_reply post, product_hint
    @browser.goto product_link
    @detail_page.check_detail_desc product_hint
    @browser.windows.last.close
  end

  def at_mention_product_on_root_post product_hint
    product_link = @community_page.at_mention_product_on_root_post product_hint
    @community_page.check_recent_mentioned_product product_link
    @browser.goto product_link
    @detail_page.check_detail_desc product_hint
    @browser.windows.last.close
  end

  def shopping_cart
    add_btn = @browser.links(:text => "Add To Cart")
    cart_item = @community_page.add_to_cart 0
    @community_page.remove_product_from_cart cart_item
    cart_item = @community_page.add_to_cart 0
    @community_page.change_product_number_in_cart cart_item, 1000
    if add_btn.count > 1
      @community_page.add_to_cart 1
    end
    products = @community_page.view_cart
    @cart_page.check_cart_items products
  end

  def verify_font_size(font)
    @home_page.check_font_size font
  end

  ########### swagger #############
  def open_swagger
    @swagger_page.open
  end
 
  def set_token token
    @swagger_page.set_oauth_token token
  end

  def get_topics_api network
    params = {
      "id": network
    }
    @swagger_page.send_api(:get_topics,params)
  end

  def post_conversation_api topic_id, title, content
    params = {
      "id": topic_id,
      "Conversation": "{\"d\":{\"HtmlContent\":\"<p>"+content+"</p>\",\"OriginalContent\":\""+content+"\",\"Title\":\""+title+"\",\"TypeTrait\":\"question\"}}"
    }
    @swagger_page.send_api(:post_conversation,params)
  end
  
  def patch_conversation_api conversation_id, title, content
    params = {
      "id": conversation_id,
      "Conversation": "{\"d\":{\"HtmlContent\":\"<p>"+content+"</p>\",\"OriginalContent\":\""+content+"\",\"Title\":\""+title+"\",\"TypeTrait\":\"question\"}}"
    }
    @swagger_page.send_api(:patch_conversation,params)
  end

  def delete_conversation_api conversation_id
    params = {
      "id": conversation_id
    }
    @swagger_page.send_api(:delete_conversation,params)
  end

  def get_response_code
    @swagger_page.response_code
  end

end