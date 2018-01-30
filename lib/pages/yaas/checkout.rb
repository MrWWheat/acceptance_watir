require 'pages/yaas'

class Pages::Yaas::Checkout < Pages::Yaas

  def initialize(config, options = {})
    super(config)
  end

  checkout_form             { div(:class => "checkoutForm")}


end