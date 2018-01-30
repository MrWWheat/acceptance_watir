require File.expand_path(File.dirname(__FILE__) + "/page_object.rb")

class CommunitySearchPage < PageObject
  attr_accessor :results_keyword,
  :topnav_search_bar_paceholder,
  :topnav_search_icon,
  :search_dropdown,
  :search_cancel_icon,
  :search_text_field,
  :sort_dropdown_toggle_link,
  :sort_dropdown_ul,
  :search_result_page,
  :search_post,
  :search_placeholder_text,
  :search_dropdown,
  :search_result_posts,
  :search_result_posts_of_search_universal,
  :search_topic_result,
  :search_result_detail

  def self.top_nav_search_bar(browser) #search bar on the top nav
    new(browser, "search-form search-bar")
  end

  def self.any_page_search_bar(browser) #search bar on home, about, topics etc pages
    new(browser, "row widget search")
  end

  def self.results_page_search_bar(browser) #search bar on search results page
    new(browser, "conversation-search")
  end

  def initialize(browser, class_name)
    @browser = browser    
    @scope = @browser.div(:class => class_name)  

    @search_text_field = @scope.text_field(:class => "typeahead")
    @topnav_search_bar_paceholder = @scope.input(:class => "ember-view ember-text-field typeahead form-control tt-input", :placeholder => "Search...")
    @topnav_search_icon = @scope.i(:class => "ember-view icon-search icon-search-input")
    @search_dropdown = @scope.span(:class => "tt-dropdown-menu")
    @search_cancel_icon = @browser.i(:class => "ember-view icon-sys-cancel-2 icon-search-input")

    @search_result_page = @browser.div(:class => "row filters search-facets")
    @results_keyword = @browser.p(:class => "search-results-text") #this contains the text like: 20 results found for: "watir"

    @sort_dropdown_toggle_link = @browser.div(:class => "sort-search-results").span(:class => "dropdown-toggle")        
    @sort_dropdown_ul = @browser.ul(:class => "moderator-post-actions-menu")

    @search_result_posts = @browser.divs(:class => "post")
    @search_result_posts_of_search_universal = @browser.divs(:class => "ember-view post")
    @search_topic_result = @browser.div(:class => "search-type-topic")

    @search_result_detail = @browser.div(:class => "ember-view post").divs(:class => "details")

  end

  def recent_search_widget
    @browser.div(:class => "widget recent_search" , :text => /Recent Searches/)
  end

  def related_search_widget
    @browser.div(:class => "widget related_search" , :text => /Related Searches/)
  end

  def search(keyword = "watir")
    @browser.wait_until($t) { @search_text_field.present? }
    @search_text_field.set keyword
    @browser.send_keys :enter    
    @browser.wait_until { @search_result_page.present? }
  end

  def search_dropdown(keyword = "watir")
    @browser.wait_until($t) { @search_text_field.present? }
    @search_text_field.set keyword
    @browser.wait_until($t) { @search_dropdown.present? }    
  end

  def search_input_cancel_icon(keyword = "watir")
    @browser.wait_until($t) { @search_text_field.present? }
    @search_text_field.set keyword
    @browser.wait_until($t) { @search_cancel_icon.present? }  
  end

  def click_sort_dropdown_option_newest
    click_sort_dropdown_option(1)
  end

  def click_sort_dropdown_option_oldest
    click_sort_dropdown_option(2)
  end

  def click_sort_dropdown_option_relevance
    click_sort_dropdown_option(3)
  end


  def click_sort_dropdown_option(number = 0) # 0 = first, 1 = second, 2= third
    # Newest
    # Oldest
    # Relevance

    sort_dropdown_toggle_link.when_present.click
    dropdown_option = sort_dropdown_ul.lis[number]
    dropdown_option.when_present.click
    @browser.wait_until { search_result_page.present? }
  end

  def previous_page_link
    all_pagination_links[0]
  end

  def first_page_link
    all_pagination_links[1]
  end

  def page_link_number1
    all_pagination_links[2]
  end

  def page_link_number2
    all_pagination_links[3]
  end

  def last_page_link
    all_pagination_links[-2]
  end

  def next_page_link
    all_pagination_links[-1]
  end

  def all_pagination_links
    @browser.div(:class => "pagination-container").links
  end

  def all_search_dropdown_suggestions
    @scope.divs(:class=> "tt-suggestion")
  end

  def all_searched_result_items
    @browser.div(:class => "posts").divs(:class => "media")
    
    #@browser.divs(:class => "post media")     ---------1602 code--------------
  end

  def all_searched_result_items_of_search_universal
    @browser.div(:class => "posts").divs(:class => "ember-view post")
  end

  def topnav_search_placeholder
    @browser.wait_until($t) { @search_text_field.present? }
    @browser.wait_until($t) { @topnav_search_bar_paceholder.present? }
  end

  def find_topnav_search_icon
    @browser.wait_until($t) { @search_text_field.present? }
    @browser.wait_until($t) { @topnav_search_icon.present? }
  end

  def topic_filter_checkbox_click(topic_name)
    topic_index = nil
    @browser.divs(:class => "widget")[1].ps(:class => "ember-view checkable-item").each_with_index do |topic_item, index|
      if (topic_item.text.include?(topic_name))
        topic_index = index
        break
      end
    end
    @browser.divs(:class => "widget")[1].ps(:class => "ember-view checkable-item")[topic_index].div(:class => "ember-view customize-checkbox").click
  end

  def type_filter_checkbox_click(type_name)
    type_index = nil
    @browser.divs(:class => "widget")[2].divs(:class => "search-filter-group").each_with_index do |type_item, index|
      if (type_item.text.include?(type_name))
        type_index = index
        break
      end
    end
    @browser.divs(:class => "widget")[2].divs(:class => "search-filter-group")[type_index].div.div.click
  end

  def get_type_filter_count(type_name)
    @browser.divs(:class => "widget")[2].divs(:class => "search-filter-group").each_with_index do |type_item|
      if (type_item.text.include?(type_name))
        return type_item.div.text.gsub(/\D/,'')
        break
      end
    end
  end

  def type_filter_children_checkbox_click(children_type_name)
    @browser.divs(:class => "widget")[2].divs(:class => "search-filter-children").each_with_index do |type_item, index|
      if (type_item.text.include?(children_type_name))
        @browser.divs(:class => "widget")[2].divs(:class => "search-filter-children")[index].divs.each_with_index do |type_item|
          if type_item.text.gsub(/[^a-zA-Z]/,'') == (children_type_name)
            type_item.div.click
            break
          end
        end
        break
      end
    end
  end

  def get_children_type_filter_count(children_type_name)
    @browser.divs(:class => "widget")[2].divs(:class => "search-filter-children").each_with_index do |type_item, index|
      if (type_item.text.include?(children_type_name))
        @browser.divs(:class => "widget")[2].divs(:class => "search-filter-children")[index].divs.each_with_index do |type_item|
          if type_item.text.gsub(/[^a-zA-Z]/,'') == (children_type_name)
            return type_item.text.gsub(/\D/,'')
            break
          end
        end
        break
      end
    end
  end

end


