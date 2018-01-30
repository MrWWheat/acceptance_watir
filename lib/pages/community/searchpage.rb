require 'pages/community'
require 'pages/community/gadgets/side'

class Pages::Community::Search < Pages::Community

  def initialize(config, options = {})
    super(config)

  end

  search_text_field                     { div.text_field(:class => "typeahead")}
  search_result_page                    { div(:class => "row filters search-facets")}
  search_topic_result                   { div(:class => "search-type-topic")}
  topic_filter_list                     { divs(:class => "widget")[1].ps(:class => "ember-view checkable-item") }
  type_filter_list                      { divs(:class => "widget")[2].divs(:class => "search-filter-group")}
  children_type_filter_list             { divs(:class => "widget")[2].divs(:class => "search-filter-children")}
  search_result_detail                  { divs(:class => "details")}
  results_keyword                       { p(:class => "search-results-text")}
  topnav_search_bar_paceholder          { div.input(:class => "ember-view ember-text-field typeahead form-control tt-input", :placeholder => "Search...")}
  topnav_search_icon                    { div.i(:class => "ember-view icon-search icon-search-input")}
  search_dropdown_menu                  { div.span(:class => "tt-dropdown-menu")}
  all_search_dropdown_suggestions       { divs(:class=> "tt-suggestion")}
  results_page_search                   { div(:class => "conversation-search")}
  search_cancel_icon                    { i(:class => "ember-view icon-sys-cancel-2 icon-search-input")}
  # home_page_search                      { div(:class => "row widget search")}
  home_page_search                      { div(:class => "search-form search-bar col-md-8 col-sm-12 col-xs-12 col-md-offset-2")}

  # home_page_search_cancel_icon          { div(:class => "row widget search").i(:class => "ember-view icon-sys-cancel-2 icon-search-input")}
  home_page_search_cancel_icon          { i(:class => "ember-view icon-sys-cancel-2 icon-search-input")}
  all_searched_result_items             { divs(:css => ".posts .ember-view.post")}
  sort_dropdown_toggle_link             { div(:class => "sort-search-results").span(:class => "dropdown-toggle")}
  sort_dropdown_ul                      { ul(:class => "moderator-post-actions-menu")}
  recent_search_widget                  { div(:css => ".side-gadget.gadget-recently-search:not(.gadget-related-search),.widget.recent_search") }
  related_search_widget                 { div(:css => ".gadget-related-search,.widget.related_search") }
  all_pagination_links                  { div(:class => "pagination-container").links}
  search_result_posts                   { divs(:css => ".gadget-search-result .ember-view.post") }
  search_topic_results                  { divs(:class => "search-type-topic")}
  search_no_results_text                { div(:css => ".no-results-found") }
  search_result_first_post_title_link   { link(:css => ".post .media .media-heading a") }
  search_result_first_topic_title_link  { link(:css => ".post .media .topic-detail .topic-detail-title") }
  search_result_first_event_title_link  { span(:css => ".post .media .event-title .title") }
  search_result_first_post_desc         { element(:css => ".post .media .media-heading + .ember-view") }
  search_result_first_topic_desc        { element(:css => ".post .media .topic-detail-desc") }
  search_topic_text_area                { div(:css => ".search-form.search-bar.col-md-8")}
  search_topic_text_input               { div(:css => ".search-form.search-bar.col-md-8").text_field(:class => "typeahead")}

  # action list of search results
  first_like_action_link                { div(:css => ".likeAction.likes-count-hollow")}
  first_reply_action_link               { div(:css => ".reply-count")}

  search_result_events                  { divs(:class => "event-card") }
  search_result_ideas                   { divs(:class => "ideas-container")}
  
  def recent_searches_widget
    Gadgets::Community::SideRecentSearches.new(@browser)
  end  

  def search(keyword = "watir")
    @browser.wait_until($t) { search_text_field.present? }
    search_text_field.set keyword
    @browser.send_keys :enter

    wait_results_searched_out(keyword: keyword)
  end

  def first_result_content(post_type, content_type)
    case post_type
    when :post
      content_type == :title ? search_result_first_post_title_link.when_present.text : search_result_first_post_desc.when_present.text
    when :topic
      content_type == :title ? search_result_first_topic_title_link.when_present.text : search_result_first_topic_desc.when_present.text
    when :event
      search_result_first_event_title_link.when_present.text
    else
      raise "type #{post_type} is not supported yet"
    end  
  end  

  def first_result_match?(keyword, exact_match, match_content)
    @browser.wait_until { search_result_posts.size > 0 || search_topic_results.size > 0 || search_result_events.size > 0 || search_result_ideas.size > 0 || search_no_results_text.present? }

    return false unless search_result_posts.size > 0 || search_topic_results.size > 0 || search_result_ideas.size > 0 || search_result_events.size > 0

    first_post_match?(keyword, exact_match, match_content)  ||
    first_topic_match?(keyword, exact_match, match_content) ||
    first_event_match?(keyword, exact_match, match_content) ||
    first_idea_match?(keyword, exact_match, match_content)
  end 

  def first_post_match?(keyword, exact_match, match_content)

    return false unless search_result_posts.size > 0             

    case match_content
    when :title
      exact_match ? first_result_content(:post, :title).downcase == keyword.downcase \
                  : first_result_content(:post, :title).downcase.include?(keyword.downcase)
    when :details
      exact_match ? first_result_content(:post, :desc).downcase == keyword.downcase \
                  : first_result_content(:post, :desc).downcase.include?(keyword.downcase)
    end
  end

  def first_topic_match?(keyword, exact_match, match_content)
    return false unless search_topic_results.size > 0

    case match_content
    when :title
      exact_match ? first_result_content(:topic, :title).downcase == keyword.downcase \
                  : first_result_content(:topic, :title).downcase.include?(keyword.downcase)
    when :details
      exact_match ? first_result_content(:topic, :desc).downcase == keyword.downcase \
                  : first_result_content(:topic, :desc).downcase.include?(keyword.downcase)
    end 
  end

  def first_event_match?(keyword, exact_match, match_content)
    return false unless search_result_events.size > 0

    case match_content
      when :title
        exact_match ? first_result_content(:event, :title).downcase == keyword.downcase \
                  : first_result_content(:event, :title).downcase.include?(keyword.downcase)
    end
  end

  def first_idea_match?(keyword, exact_match, match_content)
    return false unless search_result_ideas.size > 0

    case match_content
    when :title
      exact_match ? search_result_ideas[0].h4(:class => "media-heading").link.text.downcase == keyword.downcase \
        : search_result_ideas[0].h4(:class => "media-heading").link.text.downcase.include?(keyword.downcase)
    end
  end

  # For ui customization on. Ajax call instead of reloading page. 
  def wait_results_load
    sleep 2
  end

  # once 1705_chewy_resque_strategy feature is enabled, the search results might be delayed.
  # it will create a job to cache any data change to redis. The time when the job is done 
  # depends on the performance of workers.
  def wait_results_searched_out(keyword:, exact_match: false, match_content: :title, timeout: 3*60)
    wait_results_load
    @browser.wait_until { results_keyword.present? }

    start_time = Time.now
    while(!first_result_match?(keyword, exact_match, match_content))
      break if (Time.now - start_time) > timeout
      sleep 5

      @browser.refresh

      @browser.wait_until { results_keyword.present? }
    end
  end 

  def wait_results__not_searched_out(keyword:, exact_match: false, match_content: :title, timeout: 3*60)
    wait_results_load
    @browser.wait_until { results_keyword.present? }

    start_time = Time.now
    while(first_result_match?(keyword, exact_match, match_content))
      break if (Time.now - start_time) > timeout
      sleep 5
      @browser.refresh
      @browser.wait_until { results_keyword.present? }
    end
    first_result_match?(keyword, exact_match, match_content)
  end

  def results_searched_out?(keyword:, exact_match: false, match_content: :title, timeout: 3*60)
    wait_results_searched_out(keyword: keyword, exact_match: exact_match, match_content: match_content, timeout: timeout)

    # check if the first post contains the expected keyword
    first_result_match?(keyword, exact_match, match_content)
  end 

  def topnav_search_placeholder
    @browser.wait_until($t) { search_text_field.present? }
    @browser.wait_until($t) { topnav_search_bar_paceholder.present? }
  end

  def find_topnav_search_icon
    @browser.wait_until($t) { search_text_field.present? }
    @browser.wait_until($t) { topnav_search_icon.present? }
  end

  def search_dropdown(keyword = "watir")
    @browser.wait_until($t) { search_text_field.present? }
    search_text_field.set keyword
    @browser.wait_until($t) { search_dropdown_menu.present? }
  end

  def search_input_cancel_icon(keyword = "watir")
    @browser.wait_until($t) { search_text_field.present? }
    search_text_field.set keyword
    @browser.wait_until($t) { search_cancel_icon.present? }
  end

  def home_page_search_input_cancel_icon(keyword = "watir")
    @browser.wait_until($t) { home_page_search.text_field.present? }
    home_page_search.text_field.set keyword
    @browser.wait_until($t) { home_page_search.text_field.present? }
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

  def topic_filter_checkbox_click(topic_name)
    topic_index = nil
    topic_filter_list.each_with_index do |topic_item, index|
      if (topic_item.text.include?(topic_name))
        topic_index = index
        break
      end
    end
    topic_filter_list[topic_index].div(:class => "ember-view customize-checkbox").click
  end

  def type_filter_checkbox_click(type_name)
    type_index = nil
    type_filter_list.each_with_index do |type_item, index|
      if (type_item.text.include?(type_name))
        type_index = index
        break
      end
    end
    type_filter_list[type_index].div.div.click
  end

  def get_type_filter_count(type_name)
    type_filter_list.each_with_index do |type_item|
      if (type_item.text.include?(type_name))
        return type_item.div.text.gsub(/\D/,'')
        break
      end
    end
  end

  def type_filter_children_checkbox_click(children_type_name)
    children_type_filter_list.each_with_index do |type_item, index|
      if (type_item.text.include?(children_type_name))
        children_type_filter_list[index].divs.each_with_index do |type_item|
          if type_item.text.gsub(/[^a-zA-Z]/,'').include? children_type_name
            type_item.div.click
            break
          end
        end
        break
      end
    end
  end

  def get_children_type_filter_count(children_type_name)
    children_type_filter_list.each_with_index do |type_item, index|
      if (type_item.text.include?(children_type_name))
        children_type_filter_list[index].divs.each_with_index do |type_item|
          if type_item.text.gsub(/[^a-zA-Z]/,'') == (children_type_name)
            return type_item.text.gsub(/\D/,'')
            break
          end
        end
        break
      end
    end
  end

  def universal_search_from_list_page(keyword)
    begin
      @browser.wait_until(5) { search_topic_text_area.present? && search_topic_text_input.present? }
      search_topic_text_input.set keyword
      @browser.send_keys :enter
    rescue
      puts "Customization not support"
      skip
    end
  end

  def search_type_filter(type)
    case type
    when :all
      search_type_filter_panel.typegroup_at_name("All")
    when :topics
      search_type_filter_panel.typegroup_at_name("Topics")
    when :event
      search_type_filter_panel.typegroup_at_name("Event")
    when :ideas
      search_type_filter_panel.typegroup_at_name("Ideas")
    when :questions
      search_type_filter_panel.typegroup_at_name("Questions")
    when :unanswered
      search_type_filter_panel.typegroup_at_name("Questions").subtype_at_name("Unanswered")
    when :answered
      search_type_filter_panel.typegroup_at_name("Questions").subtype_at_name("Answered")
    when :featured_q
      search_type_filter_panel.typegroup_at_name("Questions").subtype_at_name("Featured Questions")
    when :blogs
      search_type_filter_panel.typegroup_at_name("Blogs")
    when :featured_b 
      search_type_filter_panel.typegroup_at_name("Blogs").subtype_at_name("Featured Blogs")
    when :reviews
      search_type_filter_panel.typegroup_at_name("Reviews")
    else
      raise "Type #{type} not supported yet"
    end  
  end  

  def search_type_filter_panel
    SearchTypeFilterPanel.new(@browser, true)
  end  

  class SearchTypeFilterPanel
    def initialize(browser, betaon)
      @browser = browser
      @betaon = betaon
      @css_betaon = ".gadget-search-filter-type .side-gadget-content"
      @css_betaoff = ".search-filters.widget > .row:nth-child(2) .hidden-sm:nth-child(1) .widget"
      @browser.wait_until { @browser.div(:css => @css_betaon).present? || @browser.div(:css => @css_betaoff).present? }
      
      # @parent_css = @browser.div(:css => @css_betaon).present? ? @css_betaon : @css_betaoff
      @parent_css = betaon ? @css_betaon : @css_betaoff
    end

    def typegroups
      count = @browser.divs(:css => @parent_css + " .search-filter-group").size

      result = []

      (1..count).each do |i|
        result << SearchTypeGroup.new(@browser, @parent_css + " > div:nth-of-type(#{i})")
      end

      result
    end

    def typegroup_at_name(name)
      typegroups.find { |s| s.label.downcase.include?(name.downcase) }
    end  
    
    class SearchType
      def initialize(browser, parent_css)
        @browser = browser
        @parent_css = parent_css
      end

      def checkbox_input
        @browser.input(:css => @parent_css + " input")
      end
      
      def checkbox_label
        @browser.label(:css => @parent_css + " label")
      end

      def checked?
        checkbox_input.checked?
      end

      def check
        checkbox_label.when_present.click unless checked?
      end

      def uncheck
        checkbox_label.when_present.click if checked?
      end 

      def label
        @browser.span(:css => @parent_css + " span").text
      end

      def results_count
        label.gsub(/\D/,'')
      end 
    end  

    class SearchTypeGroup < SearchType
      def initialize(browser, group_css)
        @group_css = group_css
        super(browser, @group_css + " .search-filter-parent")
      end

      def element
        @browser.span(:css => @parent_css + " .search-filter-item")
      end
        
      # override base class
      def label
        element.text
      end

      def collapsed?
        element.when_present.class_name.include?("collapsed")
      end 

      def expand
        if collapsed?
          @browser.execute_script('arguments[0].scrollIntoView();', element)
          @browser.execute_script("window.scrollBy(0,-200)")
          element.click
        end
      end  
        
      def subtypes
        count = @browser.divs(:css => @group_css + " .search-filter-children div").size

        result = []

        (1..count).each do |i|
          result << SearchType.new(@browser, @group_css + " .search-filter-children > div:nth-of-type(#{i})")
        end

        result  
      end

      def subtype_at_name(name)
        subtypes.find { |s| s.label.include?(name) }
      end 
    end 
  end  
end