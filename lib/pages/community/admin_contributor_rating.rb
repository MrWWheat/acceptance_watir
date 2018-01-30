require 'pages/community/admin'
require 'pages/community/home'

class Pages::Community::AdminContributorRating < Pages::Community::Admin

  def initialize(config, options = {})
    super(config)
    @url = config.base_url + "/admin/#{config.slug}/contributor_rating"
  end

  def start!(user)
    @home_page = Pages::Community::Home.new(@config)
    @home_page.start!(user)
    navigate_in
  end

  contri_rating_setup_tab_header                        { link(:id => "contributor-setup") }
  contri_rating_setup_switch_div                        { div(:css => ".contributor-rating .switch-setup:first-child") }
  contri_rating_setup_switch_checkbox                   { span(:css => ".contributor-rating .switch-setup:first-child span") }
  contri_rating_setup_switch_checkbox_input             { input(:css => ".contributor-rating .switch-setup:first-child .checkbox") }
  contri_rating_setup_display_div                       { div(:css => ".display-setup") }
  contri_rating_setup_display_options                   { divs(:css => ".display-setup .row") }
  contri_rating_setup_timeframe_div                     { div(:css => ".duration-setup") }
  contri_rating_setup_timeframe_switch_checkbox         { span(:css => ".duration-setup .switch-setup span") }
  contri_rating_setup_timeframe_switch_checkbox_input   { input(:css => ".duration-setup .switch-setup .checkbox") }
  contri_rating_setup_timeframe_options_div             { div(:css => ".duration-setup .duration-options") }
  contri_rating_setup_timeframe_options                 { divs(:css => ".duration-setup .duration-options .row") }
  contri_rating_setup_save_btn                          { button(:class => "btn btn-primary", :value => "Save")}
  contri_rating_setup_save_succ_info                    { div(:id => "notice")}

  contri_rating_points_and_ranking_tab_header           { link(:id => "contributor-points-and-ranking") }
  contri_rating_points_setup_div                        { div(:css => ".points-setup") }
  contri_rating_level_setup_div                         { div(:css => ".level-setup") }

  contri_rating_spinner                                 { element(:css => ".fa-spinner") }

  def points_events_table
    PointsEventsTable.new(@browser)
  end 

  def ranking_levels_table
    RankingLevelsTable.new(@browser)
  end 

  def navigate_in
    super

    navigate_in_from_admin_page
  end 

  def navigate_in_from_admin_page
    switch_to_sidebar_item(:contributor)
    @browser.wait_until($t) { sidebar_item(:contributor).attribute_value("class").include?("active") }
    @browser.wait_until($t) { contri_rating_setup_switch_div.present? && contri_rating_setup_switch_checkbox.present? }

    accept_policy_warning
  end  

  def switch_contri_rating(on_off)
    case on_off
    when :on
      # turn on the contributor switch if not
      contri_rating_setup_switch_checkbox.click unless contri_rating_setup_switch_checkbox_input.checked?
      @browser.wait_until { contri_rating_setup_switch_checkbox_input.checked? }    
    when :off
      # turn off the contributor switch if not
      contri_rating_setup_switch_checkbox.click if contri_rating_setup_switch_checkbox_input.checked?
      @browser.wait_until { !contri_rating_setup_switch_checkbox_input.checked? }
    end  
  end

  def switch_timeframe(on_off)
    case on_off
    when :on
      contri_rating_setup_timeframe_switch_checkbox.click unless contri_rating_setup_timeframe_switch_checkbox_input.checked?
      @browser.wait_until { contri_rating_setup_timeframe_switch_checkbox_input.checked? }  
    when :off
      contri_rating_setup_timeframe_switch_checkbox.click if contri_rating_setup_timeframe_switch_checkbox_input.checked?
      @browser.wait_until { !contri_rating_setup_timeframe_switch_checkbox_input.checked? }  
    end  
  end 

  def switch_to_tab(tab)
    case tab
      when :setup
        contri_rating_setup_tab_header.when_present.click
        @browser.wait_until($t) { contri_rating_setup_switch_div.present? && \
                                  contri_rating_setup_switch_checkbox.present? }
      when :points_and_ranking
        contri_rating_points_and_ranking_tab_header.when_present.click
        @browser.wait_until($t) { contri_rating_points_setup_div.present? }
        @browser.wait_until { !contri_rating_spinner.present? }
    end
  end

  def set_action_points(action_name,point)
    @browser.wait_until{contri_rating_points_and_ranking_points_setting.present?}
    @browser.p(:class=>"event-name",:text => "#{action_name}").parent.parent.div(:class=>"event-point").text_field.set point
    contri_rating_points_and_ranking_save_btn.when_present.click
    @browser.wait_until{contri_rating_setup_save_suc_info.present?}
  end

  def setting_option_checkbox(group, label)
    case group
    when :display
      contri_rating_setup_display_options.find { |i| i.element(:text => label).exists? }.span
    when :timeframe
      contri_rating_setup_timeframe_options.find { |i| i.element(:text => label).exists? }.input
    end
  end  

  def setting_option_checkbox_input(group, label)
    case group
    when :display
      contri_rating_setup_display_options.find { |i| i.element(:text => label).exists? }.input
    when :timeframe
      contri_rating_setup_timeframe_options.find { |i| i.element(:text => label).exists? }.input
    end
  end

  def switch_setting_option(group, label, on_off)
    case on_off
    when :on
      setting_option_checkbox(group, label).when_present.click unless setting_option_checkbox_input(group, label).checked?
      @browser.wait_until { setting_option_checkbox_input(group, label).checked? }
    when :off
      setting_option_checkbox(group, label).when_present.click if setting_option_checkbox_input(group, label).checked?
      @browser.wait_until { !setting_option_checkbox_input(group, label).checked? }
    end 
  end 

  def save
    contri_rating_setup_save_btn.when_present.click
    @browser.wait_until { toast_success_message.present? }
  end

  def event_points(event_name)
    points_events_table.event_at_name(event_name).points
  end
  
  def level_points(level_title)
    ranking_levels_table.level_at_title(level_title).points
  end  

  def set_event_points(event_name, points)
    points_events_table.event_at_name(event_name).set_points(points)
  end
  
  def set_level_points(level_title, points)
    ranking_levels_table.level_at_title(level_title).set_points(points)
  end  

  class PointsEventsTable
    def initialize(browser)
      @browser = browser
    end

    def events
      row_count = @browser.divs(:css => ".points-setup .row").size

      result = []
      (1..row_count).each do |r|
        event_count = @browser.divs(:css => ".points-setup .row:nth-of-type(#{r}) .events-setting").size
        (1..event_count).each do |e|
          result << Event.new(@browser, ".points-setup .row:nth-of-type(#{r}) .events-setting:nth-of-type(#{e})")
        end  
      end

      result 
    end

    def event_at_name(name)
      events.find { |e| e.name == name }
    end  
  end
  
  class Event
    def initialize(browser, parent_css)
      @browser = browser
      @parent_css = parent_css
    end

    def name
      @browser.element(:css => @parent_css + " .event-name").text
    end
    
    def points_input
      @browser.text_field(:css => @parent_css + " .event-point input")
    end

    def points
      points_input.when_present.value.to_i
    end

    def set_points(number)
      points_input.set(number)
    end  
  end

  class RankingLevelsTable
    def initialize(browser)
      @browser = browser
    end

    def levels
      level_count = @browser.divs(:css => ".level-setting-table .level-setting").size

      result = []
      (1..level_count).each do |i|
        result << Level.new(@browser, ".level-setting-table .level-setting:nth-of-type(#{i})")
      end

      result 
    end

    def level_at_title(title)
      levels.find { |l| l.title == title }
    end 
  end

  class Level
    def initialize(browser, parent_css)
      @browser = browser
      @parent_css = parent_css
    end
  
    def title
      @browser.element(:css => @parent_css + " .contributor-title").text
    end

    def points_input
      @browser.text_field(:css => @parent_css + " .point-input input")
    end

    def points
      points_input.value.to_i
    end

    def set_points(number)
      points_input.set(number)
    end  
  end  
end