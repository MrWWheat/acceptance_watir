require 'watir_test'
require 'pages/api_doc/raml'
require 'pages/api_doc/devportal'

class RamlTest < WatirTest

  def setup
    super
    @raml_page = Pages::APIDoc::Raml.new(@config)
    # assigning @current_page helps error reporting
    #  give good contextual data
    puts "[[[ #{name} ::: #{user_for_test} ]]]" if @config.verbose?
    @browser = @config.browser

    @browser.goto @raml_page.url
    # @raml_page.start!
    # @raml_page.set_oauth_token @@token
  end

  def teardown
    super
  end

  p1
  def test_00010_redirect_to_devportal
    devportal_page = Pages::APIDoc::DevPortal.new(@config)

    assert @browser.url.include?(devportal_page.url)
  end 
end
