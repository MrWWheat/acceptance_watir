require File.expand_path(File.dirname(__FILE__) + "/page_object.rb")
class HybrisHeaderPageObject < PageObject

  def initialize(browser)
    super
    @url = $base_url
    @search_box = @browser.text_field(:id => "js-site-search-input")
    @search_btn = @browser.form(:name => "search_form_SearchBox").button

    @log_out = @browser.link(:href => /logout/)
    @log_in = @browser.link(:href => /login/)

    @navigation = @browser.div(:class => "nav-bottom")
  end

  def open
    @browser.goto @url
  end

  def login?
    @log_out.exist?
  end

  def log_out
    @log_out.when_present.click
    wait_for_page
  end

  def go_to_login
    @log_in.when_present.click
    wait_for_page
  end

  def search(product)
    @search_box.when_present.set product
    @search_btn.when_present.click
   	wait_for_page
  end

  def go_to_list_page(category_level1, category_level2)
    if category_level1 && category_level2
      @navigation.link(:title => /#{category_level1}/).when_present.hover
      @navigation.link(:title => /#{category_level2}/).when_present.click
    elsif category_level1
      @navigation.link(:title => /#{category_level1}/).when_present.click
    else
      @navigation.li(:class => "auto", :index => 0).when_present.click
    end
    wait_for_page
  end
  
end