require 'pages/yaas'

class Pages::Yaas::Layout < Pages::Yaas

  def initialize(config, options = {})
    super(config)
  end

  login_section			        { div(:class => "modal-dialog") }
  login_link                { link(:id => "login-btn") }
  signin_btn                { button(:id => "sign-in-button")}
  profile_link              { link(:class => "my-profile dropdown-toggle") }
  logout_btn                { link(:id => "logout-btn")}
  logo_homepage_btn         { div(:class => "logo navbar-padding").link}

  shopping_cart_btn         { button(:id => "full-cart-btn")}
  shopping_cart_number      { button(:id => "full-cart-btn").span}

end