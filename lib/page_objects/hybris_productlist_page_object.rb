require_relative "./page_object"

class HybrisProductListPageObject < PageObject

  def initialize(browser)
    super
    @product_list = @browser.ul(:class => "product-listing")
    @first_product_item = @product_list.element(:class => "product-item", :index => 0)
    @first_product_widget = @first_product_item.div(:class => "excelsior")
  end

  def check_loaded
    @browser.wait_until{ @browser.div(:id => "ex-searchTabs").present? }
  end

  def check_productlist_component
    @browser.wait_until{ @first_product_widget.present? }
    @first_product_widget.div(:class => "rating-star-bar label-right").when_present.hover
    @browser.wait_until{ @first_product_widget.div(:class => "rate-layer").present? }
  end

  def go_to_product_detail(product_id=nil)
    if product_id
      @product_list.element(:class => "product-item").link(:class => "name", :href => /product_id/).when_present.click
    else
      @product_list.element(:class => "product-item").link(:class => "name", :index => 0).when_present.click
    end
    @browser.wait_until(60) { @browser.body.present? }
  end

end