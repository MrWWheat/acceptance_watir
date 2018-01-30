require 'pages/community'

class Pages::Community::PublishSetting < Pages::Community
  def initialize(config, options = {})
    super(config)
  end

  ps_modal_dlg               { div(:id => "delayed-publish-modal") }
  ps_now_radio_btn           { text_field(:css => "#delayed-publish-modal #publish_choose_now") }
  ps_later_radio_btn         { text_field(:css => "#delayed-publish-modal #publish_choose_later") }
  ps_time_input              { text_field(:css => "#delayed-publish-modal .date input") }
  ps_submit_btn              { button(:css => "#delayed-publish-modal .modal-footer .btn-primary") }
  ps_cancel_btn              { button(:css => "#delayed-publish-modal .modal-footer .btn-default") }

  def set(publish_schedule=nil)
    sleep 0.5 # workaround for the issue that "modal-backdrop fade in" show sometimes
    @browser.wait_until { ps_modal_dlg.present? }

    if publish_schedule.nil?
      ps_now_radio_btn.click unless ps_now_radio_btn.when_present.attribute_value("checked")
      @browser.wait_until { ps_now_radio_btn.attribute_value("checked") }
    else
      ps_later_radio_btn.click unless ps_later_radio_btn.when_present.attribute_value("checked")
      @browser.wait_until { ps_later_radio_btn.attribute_value("checked") }
      @browser.wait_until { !ps_time_input.class_name.include?("disabled") }
      ps_time_input.set publish_schedule
    end  

    ps_submit_btn.when_present.click
    @browser.wait_until { !ps_modal_dlg.present? }
  end  
end