require 'pages/hybris'

class Pages::Hybris::List < Pages::Hybris

	def initialize(config, options = {})
    super(config)
    # @url=config.hybris_url
  end

  product_list                  { element(:class => "product__listing") }
  first_product_item            { element(:css => ".product__listing [class$=item]") }
  first_product_item_link       { link(:css => ".product__listing [class$=item] a") }
  first_product_item_5_7        { div(:class => "productListItem") }
  first_product_item_link_5_7   { div(:class => "head") }
  first_product_widget          { div(:class => "excelsior e-panel e-panel-header e-product-list-panel") }
  checkout_modal                { div(:id => "cboxContent") }
  add_shopping_cart_btn         { a(:class => "js-mini-cart-close-button") }

  def put_item_into_shpping_cart item
    # product_list.lis[item].buttons[1].click
    begin
      @browser.button(:css => proditem_css_by_index(item) + " button[class*=shopping-cart]").when_present.click
    rescue Selenium::WebDriver::Error::UnknownError
      puts "Something error happen when add to cart. Wait and try again"
      sleep 2
      @browser.button(:css => proditem_css_by_index(item) + " button[class*=shopping-cart]").when_present.click
    end
      
    @browser.wait_until($t) {checkout_modal.present?}
    add_shopping_cart_btn.when_present.click
    @browser.wait_until($t) {!checkout_modal.present?}
  end

  def go_to_shopping_cart
    checkout_div.when_present.click
    @browser.wait_until($t) {checkout_modal.present?}
    checkout_btn.when_present.click
  end

  def proditem_css_by_index(index)
    ".product__grid .product-item:nth-of-type(#{index+1})"
  end  
end