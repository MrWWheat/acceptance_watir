require 'pages/yaas'

class Pages::Yaas::Home < Pages::Yaas

  def initialize(config, options = {})
    super(config)
    @url = config.yaas_url
  end

  first_product_link                { div(:class => "product-grid").link}
  yaas_home_page                    { div(:class => "main")}
  sign_in_btn                       { link(:id=>"login-btn")}

  def go_to_first_product_detail_page
    @browser.wait_until { first_product_link.present?}
    first_product_link.when_present.click
    @browser.wait_until { first_product_link.present?}
  end

  def goto_home_page
    @browser.wait_until { logo_homepage_btn.present?}
    logo_homepage_btn.when_present.click
    @browser.wait_until { first_product_link.present?}
  end

end