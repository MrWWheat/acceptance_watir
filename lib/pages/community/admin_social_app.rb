
class Pages::Community::AdminSocialApp < Pages::Community::Admin

  def initialize(config, options = {})
    super(config)
    @url = config.base_url + "/admin/#{config.slug}/social_apps"
  end

  def start!(user)
    super(user, @url, admin_home_content)
  end

  social_form                         { div(:id =>"social_app_form")}
  provider_items                      { div(:class =>"admin-grid").divs(:class => "row")}
  toggle_btns                         { labels(:class => "toggle-button")}

  def turn_on_off_btn_click(provider)
    provider_items.each_with_index do |item, index|
      if (item.text.include?(provider))
        type_index = index
        toggle_btns[index-1].when_present.click
        break
      end
    end


  end


end