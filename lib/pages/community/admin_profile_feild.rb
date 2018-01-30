require 'pages/community/admin'
require 'pages/community/home'

class Pages::Community::AdminProfileFeild < Pages::Community::Admin

  def initialize(config, options = {})
    super(config)
    @url = config.base_url+"/admin/#{@config.slug}/profile_field"
  end

  def start!(user)
   # login starting from Home page
    @home_page = Pages::Community::Home.new(@config)
    @home_page.start!(user)

    navigate_in # navigate to Admin default page
    accept_policy_warning
  end

  profile_feilds                                    { divs(:class => "profile-fields") }

  profile_save_button                               { button(:class => "btn-primary")}

  def navigate_in
    @browser.goto @url
    @browser.wait_until { profile_feilds[0].present? }
  end

  def custom_profile_feild(feild_text="", operations=nil)
    @profile_field = @browser.div(:class => "profile-fields", :text => /#{feild_text}/)
    operations.each do |index, checked|
      click_check_box index, checked
    end
    profile_save_button.when_present.click
    @browser.wait_until { toast_success_message.present? }
  end

  def click_check_box (index, checked)
    check_box = @profile_field.input(:index => index)
    check_box.click unless !( check_box.checked? ^ checked )
    @browser.wait_until { check_box.checked? == checked }
  end

  def check_available_config_of_profile_feilds
  	#  0 => show feild , 1 => require feild , 2 => always public feild
    @profile_field = @browser.div(:class => "profile-fields", :text => /First Name/)
    # checked : 1 => 0
    click_check_box 1,true
    assert (@profile_field.input(:index => 0).checked? == true)
    # checked : 2 => 1, 2 => 0
    click_check_box 2,true
    assert (@profile_field.input(:index => 1).checked? == true)
    assert (@profile_field.input(:index => 0).checked? == true)
    # unchecked : 1 => 2
    click_check_box 1,false
    assert (@profile_field.input(:index => 2).checked? == false)
    # unchecked : 0 => 1, 0 => 2
    click_check_box 0,false
    assert (@profile_field.input(:index => 1).checked? == false)
    assert (@profile_field.input(:index => 2).checked? == false)
  end

end