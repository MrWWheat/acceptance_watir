require 'pages/community/home'
require 'date'

class Pages::Community::IdeaList < Pages::Community
  def initialize(config, options = {})
    super(config)
    @url = config.base_url + "/n/#{@config.slug}/ideas"
  end

  def start! (user)
    @home_page = Pages::Community::Home.new(@config)
    @home_page.start!(user)

    navigate_in
  end
  idea_container                   { div(:class => "ideas-container")}
  empty_idea_text                  { h4(:class => "empty-container-text")}
  idea_items                       { ul(:class => "items").lis}
  first_idea_item                  { ul(:class => "items").lis[0]}
  first_idea_item_title            { ul(:class => "items").lis[0].h4(:class => "media-heading").link}
  first_idea_item_desc             { ul(:class => "items").lis[0].div(:class => "description").p}
  first_idea_item_topic            { ul(:class => "items").lis[0].div(:class => "pre-heading").link}
  first_idea_item_vote_up_button   { divs(:class => "votes-side")[0].links[0]}
  first_idea_item_vote_down_button { divs(:class => "votes-side")[0].links[1]}

  new_idea_button                  { div(:class => "normal-view").link(:class => "btn-primary pull-right")}

  # filter button
  sort_by                          { button(:text => /Sorted by:/) }
  sort_by_most_vote                { link(:text => "Most Votes")}
  sort_by_least_vote               { link(:text => "Least Votes")}
  sort_by_newest                   { link(:text => "Newest")}
  sort_by_oldest                   { link(:text => "Oldest")}

  idea_items_date                  { divs(:css => ".table-cell.body span")}
  idea_items_vote                  { divs(:css =>(".votes-side .counts"))}
  # status change filter
  status_change_button             { buttons(:class => "status")[0]}
  status_change_button_text        { buttons(:class => "status")[0].spans[0]}
  stauts_change_list               { div(:class => "status-menu").ul}

  #decline modal
  decline_modal_desc_text          { div(:class => "modal-body").textarea}
  decline_modal_submit_button      { div(:class => "modal-footer").button(:class => "btn-primary")}

  def navigate_in
    @browser.goto @url
    @browser.wait_until { idea_container.present? }
    wait_until_idea_load
  end

  def wait_until_idea_load
    @browser.wait_until{ empty_idea_text.present? || first_idea_item.present? }
  end

  def new_idea
    new_idea_button.when_present.click
  end

  def filter (filter_name, check_status=false)
    wait_until_idea_load
    sort_by.when_present.click
    case filter_name
    when :most_vote
      sort_by_most_vote.when_present.click
    when :least_vote
      sort_by_least_vote.when_present.click
    when :newest
      sort_by_newest.when_present.click
    when :oldest
      sort_by_oldest.when_present.click
    else
      return false
    end
    return check_ideas_by_filter_name filter_name, check_status
  end

  def check_ideas_by_filter_name (filter_name, check_status)
    wait_until_idea_load
    if idea_items_vote.size <= 1 
      return true
    end

    case filter_name
      when :most_vote
        size = idea_items_vote.size > 5 ? 5 : idea_items_vote.size
        for i in 1..size-1
          if idea_items_vote[i].text.to_i > idea_items_vote[i - 1].text.to_i
            return false
          end
        end
      when :least_vote
        size = idea_items_vote.size > 5 ? 5 : idea_items_vote.size
        for i in 1..size-1
          if idea_items_vote[i].text.to_i < idea_items_vote[i - 1].text.to_i
            return false
          end
        end
      when :newest
        size = idea_items_date.size > 10 ? 5 : (idea_items_date.size / 2)
        for i in 1..size-1
          if (idea_submited_time (idea_items_date[2 * i].text)) > (idea_submited_time (idea_items_date[2 * i - 2].text))
            return false
          end
        end
      when :oldest
        size = idea_items_date.size > 10 ? 5 : (idea_items_date.size / 2)
        for i in 1..size-1
          if (idea_submited_time (idea_items_date[2 * i].text)) < (idea_submited_time (idea_items_date[2 * i - 2].text))
            return false
          end
        end
    end
    return (!check_status || filter_name != :newest) || status_change_button.when_present.text != "Submitted" || change_idea_status
  end

  def change_idea_status 
    wait_until_idea_load
    if idea_items_vote.size < 1 
      return true
    end
    for i in 0..4
      @browser.wait_until { status_change_button.present? && status_change_button_text.present? }
      status_change_button.when_present.click
      @browser.wait_until { stauts_change_list.links[i].present? }
      current_status = status_change_button_text.when_present.attribute_value("innerText")
      status = stauts_change_list.links[i].when_present.text
      stauts_change_list.links[i].when_present.click
      # click decline
      if i == 4 
        @browser.wait_until { decline_modal_submit_button.present? && decline_modal_desc_text.present? }
        desc = "idea decline in #{get_timestamp} "
        decline_modal_desc_text.when_present.set desc
        decline_modal_submit_button.when_present.click
      end
      @browser.wait_until {status == status_change_button_text.when_present.attribute_value("innerText")}
    end
    if i != 4
      reset_idea_status current_status
    end
    return true
  end

  def reset_idea_status (current_status)
    status_obj = { 0 => "Submitted", 1 => "In Progress", 2 => "Completed", 3 => "Under Consideration", 4 => "Accepted"}
    stauts_change_list.links[status_obj.key(current_status)].when_present.click
    @browser.wait_until {status == status_change_button_text.when_present.attribute_value("innerText")}
  end

  def idea_submited_time (time_text)
    begin
      time_text = Date.strptime("{ #{time_text} }", "{ %b %d, %Y }").to_s
    rescue
      time_text = Time.new.strftime("%Y-%m-%d")# + format_idea_submited_time(time_text)
    end
    return time_text
  end


  def vote_for_idea (is_voted: false, vote_up: true, current_status: nil) # if is_voted == false , current_status is invalid
    @browser.wait_until { idea_items_vote[0].present? && first_idea_item_vote_up_button.present? && first_idea_item_vote_down_button.present?}
    vote_count = idea_items_vote[0].text.to_i
    if vote_up
      first_idea_item_vote_up_button.when_present.click
    else
      first_idea_item_vote_down_button.when_present.click
    end
    result = 0
    if !is_voted
      result = vote_up ? 1 : -1
    else
      if current_status == "up"
        result = vote_up ? -1 : -2
      elsif current_status == "down"
        result = vote_up ? 2 : 1
      end
    end
    @browser.wait_until {idea_items_vote[0].text.to_i == (vote_count + result) }
  end

  # def format_idea_submited_time(time_text)
  #   begin
  #     current_time = Time.new.strftime("%H %M").split(/ /)
  #     current_time[0] = current_time[0].to_i + 24
  #     current_time[1] = current_time[1].to_i

  #     time_text_arr = time_text.split(/ /)
  #     if time_text_arr[-2] == /day/
  #       current_time[0] -= 24;
  #     elsif time_text_arr[-2] == /hours/
  #       current_time[0] -= time_text_arr[0] == /an/ ? 1 : time_text_arr[0].to_i
  #     elsif time_text_arr[-2] == "minutes"
  #       current_time[1] -= time_text_arr[0] == /a/ ? 1 : time_text_arr[0].to_i
  #     else
  #     end
  #     return "-#{current_time[0]}-#{current_time[1]}"
  #   rescue
  #     return ""
  #   end
  # end
end
