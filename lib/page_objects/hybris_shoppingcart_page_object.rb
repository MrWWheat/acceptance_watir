require_relative "./page_object"

class HybrisShoppingcartPageObject < PageObject

  def initialize(browser)
    super
    @cart = @browser.ul(:class => "product-list")
  end

  def check_loaded
    @browser.wait_until{ @cart.present? }
  end

  def check_cart_items products
    products.each do |product_name, product_number|
      cart_item = @cart.li(:class => "product-item",:text => /#{product_name}/)
      @browser.wait_until{ cart_item.present? }
      assert_equal product_number, cart_item.input(:name => "quantity").value.to_i
    end
  end

end