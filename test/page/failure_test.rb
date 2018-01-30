require 'watir_test'

class FailureTest < WatirTest

  def test_PROFILE_120_check_new_activity_feed
    raise "needs api"
  end

  def test_PROFILE_260_edit_pic_modal
    raise "element unclickable. is 250 leaving bad state?"
  end

  def test_PROFILE_280_edit_profile_pic
    raise "needs api"
  end

  def test_PROFILE_290_delete_profile_pic
    raise "needs api"
  end

  def test_LOGOUT_LINK_sign_out_class
    raise "needs consistency"
  end
  def test_ADMIN_LINK_sign_out_class
    raise "needs to be added, also consistency"
  end

  def test_ADMIN_030_redundant
    raise "it's the same link as in 020"
  end

  def test_ADMIN_css_selectors
    raise "admin left navbar links need css selectors"
  end

  def test_ADMIN_TOPIC_80_i18n_fail
    raise "need i81n support for testing ... ?"
  end

  def test_ADMIN_TOPIC_60_modal_dialogue_semantic_css_on_buttons
    raise "cancel topic edits has no semantic css, fix topic_edit_cancel_modal_cleanup! helper method"
  end

  def test_ADMIN_HOME_130_css_markup_fail
    raise "no semantic markup on view/edit buttons"
  end

  def test_ADMIN_HOME_140_actual_homepage_semantic_markup
    raise "admin's 'edit home page' button on regular homepage needs semantic css"
  end
end if ENV['SHOW_FAIL_LOG']