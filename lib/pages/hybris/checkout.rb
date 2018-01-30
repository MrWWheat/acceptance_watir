require 'pages/hybris'

class Pages::Hybris::Checkout < Pages::Hybris

  def initialize(config, options = {})
    super(config)
    # @url=config.hybris_url
  end

  checkout_box                    { div(:class => "checkout-steps") }
  confirm_btn                     { input(:id => "Terms1") }
  place_order_btn                 { button(:id => "placeOrder") }
  checkout_success_body         { div(:class => "checkout-success__body") }

  def place_order
    @browser.wait_until($t) {checkout_box.present?}
    confirm_btn.when_present.click
    place_order_btn.when_present.click
  end

  def get_order_number
    @browser.wait_until($t) {checkout_success_body.present?}
    checkout_success_body.b.text
  end

end