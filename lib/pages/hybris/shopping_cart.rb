require 'pages/hybris'

class Pages::Hybris::ShoppingCart < Pages::Hybris

  def initialize(config, options = {})
    super(config)
    # @url=config.hybris_url
  end

  shopping_item                 { element(:css => ".item__list") }
  express_checkout_checkbox     { input(:class => "express-checkout-checkbox") }
  checkout_button               { button(:class => "btn btn-primary btn-block btn--continue-checkout js-continue-checkout-button") }

  def check_out
    @browser.wait_until($t) {shopping_item.present?}
    express_checkout_checkbox.when_present.click
    checkout_button.when_present.click
  end

  def shopping_item_by_name(name)
    @browser.li(:class => "item__list--item", :text => /#{name}/)
  end  
end