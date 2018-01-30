require 'pages/yaas'

class Pages::Yaas::Detail < Pages::Yaas

  def initialize(config, options = {})
    super(config)
    @url = config.yaas_url
  end

  most_recent_question								{ div(:id => "Excelsior-Controller-SimpleQuestion-simpleQuestion") }
  question_modal                      { div(:id => "as-ask-question") }
  question_title_field                { text_field(:id => "question-area-title") }
  question_description_field          { text_field(:id => "question-area-description") }
  question_submit_btn                 { button(:id => "question-area-submitForm") }
  question_cancel_btn                 { button(:id => "excelsior-close-modal-button") }
  ask_question_btn                    { link(:id => "e-panel-footer-ask-question") }

  add_to_cart_btn                     { button(:id => "buy-button")}
  add_to_cart_massage                 { div(:class => "message ng-binding")}

  def create_question(title:"title-#{Time.now.to_i.to_s}", desc:"description-#{Time.now.to_i.to_s}")
    @browser.wait_until { question_modal.present? }
    question_title_field.when_present.set title
    question_description_field.when_present.set desc
    question_submit_btn.when_present.click

    @browser.wait_until { !question_modal.visible? && most_recent_question.when_present.p(:class => "e-post-title").present?}
    @browser.wait_until { most_recent_question.when_present.p(:class => "e-post-title").when_present.text == title }
  end
end