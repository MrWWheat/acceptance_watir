require 'pages/community/ui_design/editors/base'

class PropEditors::Community::Text < PropEditors::Base
  def initialize(browser, parent_css)
    super(browser, parent_css)
  end

  # settings format: [{type: :font, value: "Helvetica"}, {type: :bold, value: :on}]
  def change_settings(settings)
    settings.each do |s|
      case s[:type]
      when :font
        select_font(s[:value])
      when :bold, :italic, :underline
        toggle_font_style(s[:type], s[:value])
      when :size
        set_font_size(s[:value])
      when :color
        set_color(s[:value])
      when :charstyle
        select_charstyle(s[:value])
      when :height
        set_line_height(s[:value])
      else
        raise "Type #{s[:type]} not supported yet"
      end  
    end  
  end  

  def background_label
    @browser.label(:css => propitem_css_by_name("Background:") + " label")
  end

  def set_background(color)
    color_input_css = propitem_css_by_name("Background:") + " input:first"
    @browser.execute_script("$('#{color_input_css}').focus()")
    @browser.execute_script("$('#{color_input_css}').val('#{color}')")
    background_label.when_present.click
    @browser.wait_until { background_label.text == color }
  end

  def style_type
    @browser.select_list(:css => @parent_css + " .styling-header select")
  end

  def select_style(style)
    style_type.when_present.select_value(style)
    @browser.wait_until { style_type.value == style }
  end

  def font_select
    @browser.select_list(:css => propitem_css_by_name("Font:") + " select")
  end	

  def propitem_css_by_name(name)
    
  	pi_count = @browser.divs(:css => @parent_css + " .prop-item").size

    result = nil

    (1..pi_count).each do |i|
      pi_css = @parent_css + " .prop-item:nth-of-type(#{i})"
      
      next unless @browser.element(:css => pi_css + " .title").exist?
      
      if @browser.element(:css => pi_css + " .title").text.downcase == name.downcase
        
        result = pi_css
        break
      end  
    end

    raise "Cannot find prop #{name}" if result.nil?

    result
  end

  def select_font(font)
    font_select.when_present.select_value(font)
    @browser.wait_until { font_select.value == font }
  end

  def font_style(type)
    case type
    when :bold
      @browser.span(:css => @parent_css + " .font-style .bold")
    when :italic
      @browser.span(:css => @parent_css + " .font-style .italic")
    when :underline
      @browser.span(:css => @parent_css + " .font-style .underline")
    end
  end

  def font_style_toggled_on?(type)
    font_style(type).class_name.include?("active")
  end  
  	
  def toggle_font_style(type, on_or_off)
    if on_or_off == :on
      font_style(type).click unless font_style_toggled_on?(type)
      @browser.wait_until { font_style_toggled_on?(type) }
    else
      font_style(type).click if font_style_toggled_on?(type)
      @browser.wait_until { !font_style_toggled_on?(type) }
    end  
  end	

  def font_size_input
    @browser.text_field(:css => propitem_css_by_name("Size:") + " input")
  end

  def set_font_size(size)
    font_size_input.set(size)
    @browser.wait_until { font_size_input.value.to_i == size }
  end

  def color_label
    @browser.label(:css => propitem_css_by_name("Color:") + " label")
  end

  def set_color(color)
    color_input_css = propitem_css_by_name("Color:") + " input:first"
    @browser.execute_script("$('#{color_input_css}').focus()")
    @browser.execute_script("$('#{color_input_css}').val('#{color}')")
    color_label.when_present.click
    @browser.wait_until { color_label.text == color }
  end

  def charstyle_select
    @browser.select_list(:css => propitem_css_by_name("Character Style:") + " select")
  end

  def select_charstyle(style)
    charstyle_select.select_value(style.downcase)
    @browser.wait_until { charstyle_select.value.downcase == style.downcase }
  end

  def line_height_input
    @browser.text_field(:css => propitem_css_by_name("Line Height:") + " input")
  end

  def set_line_height(height)
    line_height_input.set(height)
    @browser.wait_until { line_height_input.value.to_i == height }
  end  
end