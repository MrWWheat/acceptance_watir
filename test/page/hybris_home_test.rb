require 'watir_test'
require 'pages/hybris/home'
require 'actions/hybris/common'
require 'pages/community/home'
require 'pages/community/login'
require 'pages/community/admin_widget_theme'
require 'pages/hybris/shopping_cart'
require 'pages/hybris/detail'

class HybrisHomeTest < WatirTest

  def setup
    super
    @hybris_home_page = Pages::Hybris::Home.new(@config)
    @community_home_page = Pages::Community::Home.new(@config)
    @community_login_page = Pages::Community::Login.new(@config)
    @community_admintheme_page = Pages::Community::AdminWidgetTheme.new(@config)
    @community_convdetail_page = Pages::Community::ConversationDetail.new(@config)
    @hybris_shopping_cart_page = Pages::Hybris::ShoppingCart.new(@config)
    @common_actions = Actions::Common.new(@config)
    @hybris_detail_page = Pages::Hybris::Detail.new(@config)
    # assigning @current_page helps error reporting
    #  give good contextual data
    @current_page = @hybris_home_page
    puts "[[[ #{name} ::: nil ]]]" if @config.verbose?
    @browser = @c.browser
    @hybris_home_page.start!(user_for_test)
  end

  def teardown
    super
    @browser.windows.last.close if @browser.windows.size > 1
  end

  p1
  def test_00010_b2b_hybris_home_page_test
    @browser.wait_until { @hybris_home_page.question_content.exists? && @hybris_home_page.review_content.exists? }
    assert_all_keys({
      :popular_questions => @hybris_home_page.popular_questions.present?,
      :popular_reviews => @hybris_home_page.popular_reviews.present?,
      :first_question_title => @hybris_home_page.first_question_title.present?,
      :first_question_content => @hybris_home_page.first_question_content.present?,
      :first_review_title => @hybris_home_page.first_review_title.present?,
      :first_review_content => @hybris_home_page.first_review_content.present?
    })
  end

  user :anonymous
  p1
  def test_00510_b2b_reset_theme
    @browser.goto @c.base_url
    @community_login_page.login! @c.users["network_admin"]
    @common_actions.go_to_admin_page
    @community_admintheme_page.navigate_in
    @community_admintheme_page.reset_theme

    @browser.wait_until($t) {@community_admintheme_page.widget_theme_edit_btn.present?}
    preview_title_font = @community_admintheme_page.widget_sample_preview_title.when_present.style("font-size")
    preview_content_font = @community_admintheme_page.widget_sample_preview_content.when_present.style("font-size")
    assert preview_title_font == "12px", "expect preview title font size 12px, but got font size #{preview_title_font}"
    assert preview_content_font == "12px", "expect preview content font size 12px, but got font size #{preview_content_font}"

    @browser.goto @c.hybris_url
    @browser.wait_until($t) {@hybris_home_page.review_content.present?}
    real_title_font = @hybris_home_page.first_review_title.when_present.style("font-size")
    real_content_font = @hybris_home_page.first_review_content.when_present.style("font-size")
    assert real_title_font == "12px", "expect hybris title font size 12px, but got font size #{real_title_font}"
    assert real_content_font == "12px", "expect hybris content font size 12px, but got font size #{real_content_font}"

  end

  user :anonymous
  p1
  def test_00511_b2b_theme_builder_change_font
    font = "18px"
    @browser.goto @c.base_url
    @community_login_page.login! @c.users["network_admin"]
    @common_actions.go_to_admin_page
    @community_admintheme_page.navigate_in
    @community_admintheme_page.change_theme font

    @browser.wait_until($t) {@community_admintheme_page.widget_theme_edit_btn.present?}
    sleep 2
    preview_title_font = @community_admintheme_page.widget_sample_preview_title.when_present.style("font-size")
    preview_content_font = @community_admintheme_page.widget_sample_preview_content.when_present.style("font-size")
    assert preview_title_font == font, "expect preview title font size #{font}, but got font size #{preview_title_font}"
    assert preview_content_font == font, "expect preview content font size #{font}, but got font size #{preview_content_font}"

    @browser.goto @c.hybris_url
    @browser.wait_until($t) {@hybris_home_page.review_content.present?}
    real_title_font = @hybris_home_page.first_review_title.when_present.style("font-size")
    real_content_font = @hybris_home_page.first_review_content.when_present.style("font-size")
    assert real_title_font == font, "expect hybris title font size #{font}, but got font size #{real_title_font}"
    assert real_content_font == font, "expect hybris content font size #{font}, but got font size #{real_content_font}"
  end

  p1
  def test_00410_b2b_shopping_cart
    @hybris_home_page.go_to_first_review

    # clean up old data in shopping cart
    @community_convdetail_page.clean_shopping_cart

    cart_item = @community_convdetail_page.add_to_cart 0
    assert @community_convdetail_page.get_cart_total_number == 1, "add to shopping cart failed"
    @community_convdetail_page.remove_product_from_cart cart_item
    assert @community_convdetail_page.get_cart_total_number == 0, "remove from shopping cart failed"
    @browser.refresh

    cart_item = @community_convdetail_page.add_to_cart 0
    assert @community_convdetail_page.get_cart_total_number == 1
    @community_convdetail_page.change_product_number_in_cart cart_item, 1000
    assert @community_convdetail_page.get_cart_total_number == 1000, "change number in shopping cart failed"
    if @community_convdetail_page.add_to_cart_btns.count > 1
      @community_convdetail_page.add_to_cart 1
      assert @community_convdetail_page.get_cart_total_number == 1001, "add another product to shopping cart failed"
    end
    products = @community_convdetail_page.get_cart_products
    total_number = 0
    total_price = 0
    products.values.each do |a|
      total_number+=a[0]
      total_price =(total_price + a[0]*a[1]).round(2)
    end
    assert total_number == @community_convdetail_page.get_cart_total_number,"total number is not correct"
    assert total_price == @community_convdetail_page.get_cart_total_price,"total price is not correct"

    # checkout to check number
    @community_convdetail_page.open_shopping_cart_popup # workaround for bug EN-2471
    @community_convdetail_page.checkout_button.when_present.click
    @community_convdetail_page.open_shopping_cart_popup # workaround for bug EN-2471
    @browser.wait_until{ @community_convdetail_page.overnumber_cart_items.size >= 1 }
    @community_convdetail_page.overnumber_cart_items.each do |overnumber_cart_item|
      title = @community_convdetail_page.get_cart_item_title overnumber_cart_item
      @community_convdetail_page.change_product_number_in_cart overnumber_cart_item,1
      puts "#{title} out of stock, reset to 1"
    end

    # checkout finally
    products = @community_convdetail_page.get_cart_products
    @community_convdetail_page.open_shopping_cart_popup # workaround for bug EN-2471
    @community_convdetail_page.checkout_button.when_present.click
    @browser.window(:url => /cartsId/).when_present.use do
      products.each do |product_name, product_number|
        # hybris_cart_item = @hybris_shopping_cart_page.shopping_item.li(:class => "product-item",:text => /#{product_name}/)
        @browser.wait_until{ @hybris_shopping_cart_page.shopping_item_by_name(product_name).present? }
        assert product_number[0] == @hybris_shopping_cart_page.shopping_item_by_name(product_name).input(:name => "quantity").value.to_i, "The number of #{product_name} is not correct"
      end
      @browser.window.close
    end
  end

  # This test case is invalid after template selector is removed
  # def test_00020_widget_theme_template
  #   @community_admintheme_page.start!("network_admin")
  #   @community_admintheme_page.set_widget_theme_template("simplified")
  #   assert !@community_admintheme_page.widget_sample_preview_title.present?

  #   @browser.goto @c.hybris_url
  #   @common_actions.go_to_product_detail(@c.product_id_many)
  #   @browser.wait_until { @hybris_detail_page.most_recent_review.present?}
  #   assert !@hybris_detail_page.recent_review_title.present?

  #   @community_admintheme_page.start!("network_admin")
  #   @community_admintheme_page.set_widget_theme_template("original")
  #   assert @community_admintheme_page.widget_sample_preview_title.present?

  #   @browser.goto @c.hybris_url
  #   @common_actions.go_to_product_detail(@c.product_id_many)
  #   @browser.wait_until { @hybris_detail_page.most_recent_review.present?}
  #   assert @hybris_detail_page.recent_review_title.present?
  # end

end
