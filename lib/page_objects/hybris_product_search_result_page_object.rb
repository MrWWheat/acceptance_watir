require_relative "./page_object"
require File.expand_path(File.dirname(__FILE__) + "/hybris_productlist_page_object.rb")

class HybrisProductSearchResultPageObject < HybrisProductListPageObject
	
	def initialize(browser)
    super
    @tabs = @browser.div(:id => "ex-searchTabs")
    @product_tab = @tabs.link(:text => /PRODUCTS/)
    @community_tab = @tabs.link(:text => /COMMUNITY/)
    @community_tab_count = @browser.span(:id => "ex-searchResult-count")

    @current_tab_body = @browser.div(:xpath => "//div[@class='ex-tabBody'][@style='display: block\;']")
    @sort = @current_tab_body.div(:class => "toolbar-list-sort").select_list
    @search_result_items = @browser.divs(:class => "e-post-message")
    @paging = @current_tab_body.ul(:class => "pagination")
    @paging_next = @paging.li(:class => "next")
    @paging_prev = @paging.li(:class => "prev")

    # topic refinement section
    @topic_section = @browser.link(:text => /TOPIC/)
    # topic refinement section
    @type_section = @browser.div(:class => "facetHead").link(:text => /TYPE/)
    @checkbox_all = @browser.input(:id => "ex_total")
    @label_all = @browser.element(:xpath => '//p[input[@id="ex_total"]]/label')
    @checkbox_questions = @browser.input(:id => "ex_question")
    @label_questions = @browser.element(:xpath => '//p[input[@id="ex_question"]]/label')
    @checkbox_reviews = @browser.input(:id => "ex_review")
    @label_reviews = @browser.element(:xpath => '//p[input[@id="ex_review"]]/label')
    @checkbox_blogs = @browser.input(:id => "ex_blog")
    @label_blogs = @browser.element(:xpath => '//p[input[@id="ex_blog"]]/label')
    @checkbox_discussions = @browser.input(:id => "ex_discussion")
    @label_discussions = @browser.element(:xpath => '//p[input[@id="ex_discussion"]]/label')
  end

  def get_first_item_link
    begin
      @browser.wait_until($t) { @browser.div(:class => "e-post-message", :index => 0).present? }
      @browser.div(:class => "e-post-message", :index => 0).div.link.href
    rescue Watir::Exception::UnknownObjectException
      puts "retrying to reach element"
      retry
    end
  end

  def get_last_item_link
    begin
      @browser.wait_until($t) { @browser.div(:class => "e-post-message", :index => 0).present? }
      index = @search_result_items.length - 1
      @browser.div(:class => "e-post-message", :index => index).div.link.href
    rescue Watir::Exception::UnknownObjectException
      puts "retrying to reach element"
      retry
    end
  end

  def get_current_tab_number
    s = @tabs.li(:class => "current").text
    s[/\d+/].to_i
  end

  def get_filter_number(type)
    if type == :questions
      label = @label_questions
    elsif type == :reviews
      label = @label_reviews
    elsif type == :blogs
      label = @label_blogs
    elsif type == :discussions
      label = @label_discussions
    end
    s = label.text
    s[/\d+/].to_i
  end

  def get_filter_all_number
    s = @label_all.text
    s[/\d+/].to_i
  end

  def activate_tab(tab)
    @browser.wait_until($t) { @community_tab_count.exists? }
    #wait for filter ready
    @browser.wait_until($t) { @label_all.exists? }
  	if tab == :products
  		tab_to = @product_tab
  	elsif tab == :community
  		tab_to= @community_tab
  	end
    tab_to.when_present.click
    @browser.wait_until($t) { @label_all.present? }
  end

  def sort(order)
    select_list, first_item, last_item, number, order_t = nil
    if order == :oldest
      order_t = "Oldest"
    elsif order == :newest
      order_t = "Newest"
    end
    select_list = @sort
    number = get_current_tab_number
    if select_list.selected_options[0].text != order_t && number > 1
      first_pre = get_first_item_link
      last_pre = get_last_item_link
      select_list.select order_t
      @browser.wait_until($t) { get_first_item_link != first_pre || get_last_item_link != last_pre }
    end
  end

  def filter(type)
    if type == :questions
      filter_by = @checkbox_questions
    elsif type == :reviews
      filter_by = @checkbox_reviews
    elsif type == :blogs
      filter_by = @checkbox_blogs
    elsif type == :discussions
      filter_by = @checkbox_discussions
    end

    filter_by.click
    #sleep for the number in all to change
    sleep 8
    if get_filter_all_number > 0
      @browser.wait_until($t) { get_filter_all_number != get_current_tab_number }
    end
    @checkbox_all.click
    sleep 8
    @browser.wait_until($t) { get_filter_all_number == get_current_tab_number }
  end

  def paging
    if get_current_tab_number > 20
      first_prev = get_first_item_link
      @paging_next.when_present.click
      @browser.wait_until($t) { get_first_item_link != first_prev }
      first_prev = get_first_item_link
      @paging_prev.when_present.click
      @browser.wait_until($t) { get_first_item_link != first_prev }
    end
  end

end
