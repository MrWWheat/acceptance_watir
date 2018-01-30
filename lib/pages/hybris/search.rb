require 'pages/hybris'

class Pages::Hybris::Search < Pages::Hybris

	def initialize(config, options = {})
    super(config)
    # @url=config.hybris_url
  end

  tabs                              { div(:id => "ex-searchTabs") }
  product_tab                       { div(:id => "ex-searchTabs").link(:text => /PRODUCTS/) }
  community_tab                     { div(:id => "ex-searchTabs").link(:text => /COMMUNITY/) }
  community_tab_count               { span(:id => "ex-searchResult-count") }

  tab_body                          { div(:class => "ex-tabBody") }
  sort                              { div(:class => "toolbar-list-sort").select_list }
  search_result_items               { divs(:class => "e-post-message") }
  search_result_first_link          { link(:css => ".e-list li:nth-child(1) .e-post-message div:nth-child(1) > a") }
  paging                            { div(:class => "ex-tabBody").ul(:class => "pagination") }
  paging_next                       { li(:css => "#ex-searchResult .excelsior-toolbar .pagination .next") }
  paging_prev                       { li(:css => "#ex-searchResult .excelsior-toolbar .pagination .prev") }

  # topic refinement section
  topic_section                     { link(:text => /TOPIC/) }
  # topic refinement section
  type_section                      { div(:class => "facetHead").link(:text => /TYPE/) }
  checkbox_all                      { input(:id => "ex_total") }
  checkbox_questions                { input(:id => "ex_question") }
  checkbox_reviews                  { input(:id => "ex_review") }
  checkbox_blogs                    { input(:id => "ex_blog") }
  checkbox_discussions              { input(:id => "ex_discussion") }

  def activate_tab(tab)
    @browser.wait_until($t) { tab_body.exists? }
    #wait for filter ready
    @browser.wait_until($t) { checkbox_all.exists? }
    if tab == :products
      tab_to = product_tab
    elsif tab == :community
      tab_to= community_tab
    end
    tab_to.when_present.click
    @browser.wait_until($t) { checkbox_all.present? }
  end

  def sort_product(order)
    select_list, first_item, last_item, number, order_t = nil
    if order == :oldest
      order_t = "Oldest"
    elsif order == :newest
      order_t = "Newest"
    end
    select_list = sort
    number = get_current_tab_number
    if select_list.selected_options[0].text != order_t && number > 1
      first_pre = get_first_item_link
      last_pre = get_last_item_link
      select_list.select order_t
      sleep 5
      @browser.wait_until($t) { get_first_item_link != first_pre || get_last_item_link != last_pre }
    end
  end

  def get_current_tab_number
    s = tabs.li(:class => "current").text
    s[/\d+/].to_i
  end

  def get_first_item_link
    @browser.wait_until($t) { search_result_first_link.present? }
    search_result_first_link.when_present.href
  end

  def get_last_item_link
    @browser.wait_until($t) { search_result_first_link.present? }
    index = search_result_items.length - 1
    @browser.div(:class => "e-post-message", :index => index).link.href
  end

  def filter(type)

    tmp = get_current_tab_number

    if type == :questions
      filter_by = checkbox_questions
    elsif type == :reviews
      filter_by = checkbox_reviews
    elsif type == :blogs
      filter_by = checkbox_blogs
    elsif type == :discussions
      filter_by = checkbox_discussions
    end

    filter_by.click

    #wait for the tab number to change
    @browser.wait_until($t) { tmp != get_current_tab_number }
    tmp = get_current_tab_number
    if get_filter_all_number > 0
      @browser.wait_until($t) { get_filter_all_number != get_current_tab_number }
    end
    checkbox_all.click
    #wait for the tab number to change
    @browser.wait_until($t) { tmp != get_current_tab_number }
    @browser.wait_until($t) { get_filter_all_number == get_current_tab_number }
  end

  def paging
    if get_current_tab_number > 20
      first_prev = get_first_item_link
      paging_next.when_present.click
      @browser.wait_until($t) { get_first_item_link != first_prev }
      first_prev = get_first_item_link
      paging_prev.when_present.click
      @browser.wait_until($t) { get_first_item_link != first_prev }
    end
  end

  def get_filter_all_number
    s = checkbox_all.parent.label.text
    s[/\d+/].to_i
  end

  def get_current_tab_number
    s = tabs.li(:class => "current").text
    s[/\d+/].to_i
  end

end