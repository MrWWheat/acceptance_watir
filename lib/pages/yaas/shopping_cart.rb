require 'pages/yaas'

class Pages::Yaas::ShoppingCart < Pages::Yaas

  def initialize(config, options = {})
    super(config)
  end

  shopping_cart_remove_btn          { button(:id => "remove-product")}
  first_item_name                   { div(:class => "product-item-name")}
  first_item_qty                    { text_field(:id => "qtyCart")}
  shopping_cart                     { div(:class => "cartContainer")}
  empty_cart                        { div(:class => "empty-cart-text")}
  continue_shopping_btn             { button(:id => "continue-shopping")}

  def clear_shopping_cart
    @browser.wait_until { shopping_cart_btn.present?}
    shopping_cart_btn.when_present.click
    @browser.wait_until { shopping_cart.present?}
    @browser.wait_until { first_item_name.present? || empty_cart.present?}
    while !empty_cart.present? do
      shopping_cart_remove_btn.when_present.click
      sleep(2)
      @browser.wait_until { first_item_name.present? || empty_cart.present?}
    end
    continue_shopping_btn.when_present.click
  end
end