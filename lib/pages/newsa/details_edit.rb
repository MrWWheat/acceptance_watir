require 'pages/newsa/newsa'

class Pages::NewSuperAdmin::DetailsEdit < Pages::NewSuperAdmin
  def initialize(config, options = {})
    super(config)
  end

  newsa_edit_name_field             { text_field(:css => "input[placeholder='Enter community name']") }
  newsa_edit_domain_field           { text_field(:css => "input[placeholder='Enter community domain']") }
  newsa_edit_customer_id            { text_field(:css => "input[placeholder='Enter Customer Id']") }
  
  newsa_edit_nav_tabs               { lis(:css => ".nav-tabs .nav-item") }
  newsa_edit_details_tab            { link(:class => "nav-link", :text => "Details") }
  newsa_edit_features_tab           { link(:class => "nav-link", :text => "Features") }

  def feature_toggle_btn(feature_group, feature_name)
    @browser.h2(:text => feature_group).when_present.parent.div(:class => "name", :text => feature_name).when_present.parent.label
  end

  def feature_toggle_btn_at_index(feature_group, index)
    @browser.h2(:text => feature_group).when_present.parent.div(:css => ".list-table .table-row:nth-child(#{index+2})").label
  end  

  def edit(changes)
    changes.each do |c|
      case c[:field]
      when :name
        newsa_edit_name_field.set c[:value]
        @browser.wait_until { newsa_edit_name_field.value == c[:value] }
      when :domain
        newsa_edit_domain_field.set c[:value]
        @browser.wait_until { newsa_edit_domain_field.value == c[:value] }
      when :customer_id
        newsa_edit_customer_id.set c[:value]
        @browser.wait_until { newsa_edit_customer_id.value == c[:value] }
      else
        raise "Type #{c[:field]} not supported yet"  
      end  
    end

    newsa_actionbar_submit_btn.when_present.click	
  end	

  def switch_to_tab(tab)
    case tab
    when :details
      newsa_edit_details_tab.click unless newsa_edit_details_tab.when_present.class_name.include?("active")
    when :features
      newsa_edit_features_tab.click unless newsa_edit_features_tab.when_present.class_name.include?("active")
    else
      raise "tab #{tab} not supported yet"
    end  
  end 

  def feature_group(feature_type)
    feature_group = "Beta Features"
    case feature_type
    when :beta
      feature_group = "Beta Features"
    when :fun_switch
      feature_group = "Function Switch"
    else
      raise "Feature type #{feature_type} not supported yet"
    end

    feature_group
  end  

  def toggle_feature(feature_type, feature_name, on_or_off)
    feature_group = feature_group(feature_type)

    @browser.wait_until { feature_toggle_btn(feature_group, feature_name).present? }
    scroll_to_element feature_toggle_btn(feature_group, feature_name)
    # The following comment line of code will raise error "document.getElementById(...).scrollBy is not a function"
    # @browser.execute_script("document.getElementById('app').scrollBy(0,-200)")
    # @browser.execute_script("document.getElementById('app').scrollTo(0, document.getElementById('app').scrollTop - 200)")
    @browser.execute_script("arguments[0].scrollTop=arguments[0].scrollTop-200", @browser.div(:id => "app"))

    case on_or_off
    when :on
      feature_toggle_btn(feature_group, feature_name).click unless feature_toggle_btn(feature_group, feature_name).class_name.include?("toggled")
      @browser.wait_until { feature_toggle_btn(feature_group, feature_name).class_name.include?("toggled") }
    when :off
      feature_toggle_btn(feature_group, feature_name).click if feature_toggle_btn(feature_group, feature_name).class_name.include?("toggled")
      @browser.wait_until { !feature_toggle_btn(feature_group, feature_name).class_name.include?("toggled") }
    else
      raise "Incorrect param #{on_or_off}"
    end  
  end

  def toggle_feature_at_index(feature_type, index, on_or_off)
    feature_group = feature_group(feature_type)

    
    @browser.wait_until { feature_toggle_btn_at_index(feature_group, index).present? }
    scroll_to_element feature_toggle_btn_at_index(feature_group, index)
    @browser.execute_script("arguments[0].scrollTop=arguments[0].scrollTop-200", @browser.div(:id => "app"))

    case on_or_off
    when :on
      feature_toggle_btn_at_index(feature_group, index).click unless feature_toggle_btn_at_index(feature_group, index).class_name.include?("toggled")
      @browser.wait_until { feature_toggle_btn_at_index(feature_group, index).class_name.include?("toggled") }
    when :off
      feature_toggle_btn_at_index(feature_group, index).click if feature_toggle_btn_at_index(feature_group, index).class_name.include?("toggled")
      @browser.wait_until { !feature_toggle_btn_at_index(feature_group, index).class_name.include?("toggled") }
    else
      raise "Incorrect param #{on_or_off}"
    end 
  end   
end  