require 'pages/hybris'

class Pages::Hybris::Layout < Pages::Hybris
  
  def initialize(config, options = {})
    super(config)
  end

  username				              { li(:class => "logged_in") }
  # search_box          	        { text_field(:id => "js-site-search-input") }
  search_box          	        { text_field(:placeholder => "I'm looking for") }
  search_btn          	        { form(:name => "search_form_SearchBox").button }
  search_btn_5_7                { button(:class => "siteSearchSubmit")}
  logout_link                   { link(:href => /logout/) }
  login_link                    { link(:href => /login/) }
  # logout_link  			            { link(:css => ".nav-top a[href$='logout']") }
  # login_link   			            { link(:css => ".nav-top a[href$='login']") }
  navigation_bar      	        { div(:class => "navigationbarcollectioncomponent") }

  checkout_btn                  { a(:class => "mini-cart-checkout-button") }
  checkout_div                  { divs(:class => "nav-cart")[1] }

  excelsior_homepage  	        { div(:class => "excelsior-homepage") }

end