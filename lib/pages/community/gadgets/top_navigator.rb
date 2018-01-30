require 'pages/community/gadgets/base'

class Gadgets::Community::TopNavigator < Gadgets::Base
  def initialize(config)
    super(config, ".gadget-main-menu")

    @slug = @config.slug
  end

  def home_link
    @browser.link(:css => @gadget_css + " .nav-list-menu a[href='/n/#{@slug}/home']")
  end

  def topics_link
    @browser.link(:css => @gadget_css + " .nav-list-menu a[href='/n/#{@slug}']")
  end

  def products_link
    @browser.link(:css => @gadget_css + " .nav-list-menu a[href='/n/#{@slug}/products']")
  end

  def events_link
    @browser.link(:css => @gadget_css + " .nav-list-menu a[href='/n/#{@slug}/events']")
  end

  def ideas_link
    @browser.link(:css => @gadget_css + " .nav-list-menu a[href='/n/#{@slug}/ideas']")
  end  

  def about_link
    @browser.link(:css => @gadget_css + " .nav-list-menu a[href='/n/#{@slug}/about']")
  end

  def search_box
    @browser.div(:css => @gadget_css + " .gadget-nav-search-box")
  end

  def shopping_cart
    @browser.div(:css => @gadget_css + " .nav-cart")
  end 
end