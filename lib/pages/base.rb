require 'pages'
require 'watir_config'

class Pages::Base < MiniTest::Test

  attr_reader :url

  MAX_START_ITERATIONS = 5

  def initialize(config)
    @config = config
    @c = @config # syntactic sugar
    @browser = config.browser
    @@network_name = config.network_name
    @@base_url = config.base_url
    @@slug = config.slug
    @@user1 = config.users[:regular_user1]
    @@user4 = config.users[:regular_user4]
    self.class.register_dom_called if @config.track_dom_usage?
  end

  # High level initialization steps that theoretically should run during setup() of every test
  def start!(user_ref, url, wait_element = nil)
    # first, make sure we've booted the app and the dom & necessary elements are present
    ensure_first_time_browser_boot!
    # second, make sure we are logged in as the correct user (or not logged in if anonymous)
    ensure_correct_user!(user_ref)
    # third, go to the location we're expecting to start the given test
    ensure_correct_start_location!(url, wait_element)
  end

  def ensure_correct_start_location!(url, wait_element = nil)
    #ensure_correct_user!(user_ref) 
    iterations = 0
    old_url = @browser.url
    if wait_element.nil?
      @browser.goto url if old_url != url
      return
    end
    until wait_element.present? do
      @browser.goto url if old_url != url
      begin
        @browser.wait_until { wait_element.present? }
      rescue Exception => e
        puts "Browser.goto failure."
        puts "Workflow start url: #{old_url}"
        puts "  told the browser: #{url}"
        puts " browser currently: #{@browser.url}"
        puts " could not find el: #{wait_element.inspect}"
        iterations += 1
        puts "retrying (#{iterations})"
        @c.screenshot!("start_fail_" + Time.now.to_s)
        iterations += 1
        if iterations >= MAX_START_ITERATIONS
          raise
        end
      end
    end
  end


  # Ruby doesn't really allow proper abstract base classes, so raise an error if
  #  we somehow land in these methods
  def ensure_first_time_browser_boot!
    raise "Please override 'ensure_first_time_browser_boot!' in your inheriting class"
  end
  def ensure_correct_user!(user_ref)
    raise "Please override 'ensure_correct_user!' in your inheriting class"
  end

  #########################################################################################

  # 2 levels of method missing...
  # First level (page object instance level) allows us to lookup dom elements by name
  # eg, @about_page.my_dom_element

  # Second level: (DSL definition level) allows us to create and store dom lookup patterns
  # eg,
  #   my_dom_element { div(:class => 'foo') }
  #
  def self.layout_class
    raise "Please override layout_class in your inheriting class"
  end

  def layout
    @layout ||= self.class.layout_class.new(@config)
  end

  def scroll_to_element(element)
    @browser.execute_script('arguments[0].scrollIntoView();', element)
  end

  # Instance level method_missing allows us to delegate invocations to a browser object
  def method_missing(name,*args)
    if dom_lookups.include?(name)
      self.class::DOM_USAGE[name] = true if @config.track_dom_usage?
      return @browser.instance_eval(&dom_lookups[name])
    elsif layout.dom_lookups.include?(name)
      self.class.layout_class::DOM_USAGE[name] = true if @config.track_dom_usage?
      return @browser.instance_eval(&layout.dom_lookups[name])
    else
      puts "[ Warning, unknown method '#{name}' invoked, is this intended to be a dom element?"
      return super(name,*args)
    end
  end

  # Class level method_missing allows us to define dom elements by name
  def self.method_missing(name, &block)
    unless self.const_defined?(:DOM_LOOKUPS)
      self.const_set(:DOM_LOOKUPS,{})
    end
    unless self.const_defined?(:DOM_USAGE)
      self.const_set(:DOM_USAGE,{})
    end
    unless Pages::Base.const_defined?(:LAYOUTS)
      Pages::Base.const_set(:LAYOUTS,{})
    end  

    raise pretty_error("duplicate defintion of '#{name}' in #{self.name}") if self::DOM_LOOKUPS[name]
    unless self == layout_class    
      # The following code will raise error when there is duplicate name between page and layout 
      # across different products (e.g. Community and Hybris).
      # @@layout ||= layout_class.new(WatirConfig.new)
      # raise pretty_error("duplicate definition of '#{name}' in #{self.name} - already defined in #{@@layout.class.name}") if @@layout.dom_lookups.include?(name)

      Pages::Base::LAYOUTS[layout_class] = layout_class.new(WatirConfig.new) unless Pages::Base::LAYOUTS[layout_class]
      layout_of_current_prod = Pages::Base::LAYOUTS[layout_class]
      raise pretty_error("duplicate definition of '#{name}' in #{self.name} - already defined in #{layout_of_current_prod.class.name}") if layout_of_current_prod.dom_lookups.include?(name)
    end
    self::DOM_LOOKUPS[name] = block
  end


  def self.pretty_error msg
    [   "",
        "###########################################",
        "# #{msg}",
        "###########################################",
    ].join("\n")
  end

  def dom_lookups
    @dom_lookups ||= (self.class.const_defined?(:DOM_LOOKUPS) ?  self.class::DOM_LOOKUPS : {})
  end

  def self.register_dom_called
    @@called_classes ||= []
    @@called_classes << self unless @@called_classes.include?(self)
  end


  def self.report_unused_dom
    return unless WatirConfig.new.track_dom_usage?
    # Pull out layout first, since it is a special case
    if @@called_classes.include?(layout_class)
      class_dom_report(layout_class)
      @@called_classes -= [ layout_class ]
    end
    @@called_classes.each do |klass|
      class_dom_report(klass)
    end
  end
  def self.class_dom_report(klass)
    keys = klass::DOM_LOOKUPS.keys
    used_keys = klass::DOM_USAGE.keys
    report = [ klass.name ]
    if (keys - used_keys).size > 0
      report << "Dom keys: %d / %d ( %d unused )" % [used_keys.size, keys.size, (keys - used_keys).size]
      report << "Unused keys: (%s)" % (keys - used_keys).map(&:to_s).join(",")
    else
      report << "All keys used"
    end
    puts "\n" + report.join("\n  ")
  end

end
