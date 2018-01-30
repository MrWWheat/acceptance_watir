require 'pages/community/ui_design/editors/base'

class PropEditors::Community::TopNavLayout < PropEditors::Base
  def initialize(browser, parent_css)
    super(browser, parent_css)
  end

  # settings format: [{type: :home_label, value: "myhome"}, {type: :cart_toggle, value: :on}]
  def change_settings(settings)
    settings.each do |s|
      case s[:type]
      when :home_label
        set_navitem_label(:home, s[:value])
      when :cart_toggle
        toggle_navitem(:home, s[:value])
      when :topics_label
        set_navitem_label(:topics, s[:value])
      when :topics_toggle
        toggle_navitem(:topics, s[:value])
      when :products_label
        set_navitem_label(:products, s[:value])
      when :products_toggle
        toggle_navitem(:products, s[:value])
      when :events_label
        set_navitem_label(:events, s[:value])
      when :events_toggle
        toggle_navitem(:events, s[:value])
      when :ideas_label
        set_navitem_label(:ideas, s[:value])
      when :ideas_toggle
        toggle_navitem(:ideas, s[:value])
      when :about_label
        set_navitem_label(:about, s[:value])
      when :about_toggle
        toggle_navitem(:about, s[:value])
      when :search_toggle
        toggle_navitem(:search, s[:value])
      else
        raise "Type #{s[:type]} not supported yet"
      end  
    end  
  end

  def navitem_name(type)
    case type
    when :home
      "Home"
    when :cart
      "Shopping cart"
    when :topics
      "Topics"
    when :products
      "Products"
    when :events
      "Events"
    when :ideas
      "Ideas"
    when :about
      "About"
    when :search
      "Search"
    else
      raise "Type #{type} not supported yet"
    end  
  end

  def navitem_label_input(type)
    @browser.wait_until { @browser.element(:css => propgroup_css_by_name(navitem_name(type))).exists? }
    @browser.text_field(:css => propgroup_css_by_name(navitem_name(type)) + " input" )
  end 

  def navitem_toggle(type)
    @browser.wait_until { @browser.element(:css => propgroup_css_by_name(navitem_name(type))).exists? }
    @browser.element(:css => propgroup_css_by_name(navitem_name(type)) + " .toggle-button" )
  end  

  def propgroup_css_by_name(name)
    pg_count = @browser.divs(:css => @parent_css + " .prop-group .prop-group").size

    result = nil

    (1..pg_count).each do |i|
      pg_css = @parent_css + " .prop-group .prop-group:nth-of-type(#{i})"

      if @browser.element(:css => pg_css + " .prop-group-title").text.downcase == name.downcase
        result = pg_css
        break
      end  
    end

    result  
  end

  def navitem_toggled_on?(type)
    navitem_toggle(type).input.checked?
  end

  def toggle_navitem(type, on_or_off)
    if on_or_off == :on
      navitem_toggle(type).when_present.click unless navitem_toggled_on?(type)
      @browser.wait_until { navitem_toggled_on?(type) }
    else
      navitem_toggle(type).when_present.click if navitem_toggled_on?(type)
      @browser.wait_until { !navitem_toggled_on?(type) }
    end
  end

  def set_navitem_label(type, value)
    navitem_label_input(type).when_present.set(value)
  end 
end  