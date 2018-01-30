require File.expand_path(File.dirname(__FILE__) + "/page_object.rb")

class CommunityAboutPage < PageObject
 
  attr_accessor :about_widget, 
  :about_edit, 
  :about_text_widget_view_button, 
  :footer, 
  :about_text_widget, 
  :topic_page, 
  :about_banner, 
  :about_url, 
  :about_inverted_banner, 
  :about_title_row, 
  :about_breadcrumb_link, 
  :about_edit_mode

  def initialize(browser)
    super
    @url = $base_url +"/n/#{$networkslug}/about"
    @about_banner = @browser.div(:class => /widget banner about/)
    @about_banner_editmode = @browser.div(:class => /ember-view uploader-component widget banner/)# normal about")
    @about_inverted_banner = @browser.div(:class => "inverted  widget banner about")
    @about_text_widget = @browser.div(:class => "widget text")
    @about_widget = @browser.div(:class => "about-page-widgets")
    @breadcrumb_link = @browser.link(:class => "ember-view", :text => "#{$network}")
    @topic_page = @browser.div(:class => "col-sm-12 col-lg-4 col-md-4")
    @tab_title = @browser.title
    @footer = @browser.footer(:class => "ember-view")

    @about_edit = @browser.button(:class => "ember-view btn btn-default btn-sm admin-dark-btn", :text => "Edit About Page")
    @about_change_photo = @browser.file_field(:class => "ember-view ember-text-field files file photo-browse-input btn btn-default btn-sm")
    @about_edit_mode = @browser.button(:class => "btn btn-default btn-sm admin-dark-btn", :text => "ToggleTextMode")
    @about_edit_browse_new = @browser.link(:text => "browse")
    @about_edit_change =  @browser.button(:class => "btn btn-default btn-sm admin-dark-btn", :text => "Change Photo")
    @about_edit_modal = @browser.div(:class => "modal-header")
    @about_edit_file_field = @browser.file_field(:class => "ember-view ember-text-field files")
    @about_edit_selected_file = @browser.div(:class => "cropper-canvas")
    @about_img_upload = @browser.div(:class => "modal-footer").button(:class => "btn btn-primary btn-sm file-upload-select-button", :text => "Select Photo")

    @about_text_widget_edit = @browser.div(:class => " widget text can-edit")
    @about_text_widget_editing_mode = @browser.div(:class => "editing widget text can-edit")
    @about_text_widget_view_button = @browser.div(:class => "col-md-2").button(:class => "btn btn-default", :value => "View About Page")
    @about_text_widget_wysiwyg = @browser.div(:class => "wysiwyg-container")
    @about_page_text_editable = @browser.div(:class => "note-editable")
    @about_edit_mode = @browser.div(:class => " widget text can-edit")

    @about_url = $base_url +"/n/#{$networkslug}/about"
    @about_widget = @browser.div(:class => "about-page-widgets")
    @about_edit_mode = @browser.div(:class => " widget text can-edit")
    @about_breadcrumb_link = @browser.span(:class => "icon-slim-arrow-right", :text => "About")
    @about_title_row = @browser.div(:class => "row title")

  end

  def goto_about_page
  	@browser.goto @url
    @browser.wait_until($t) { @about_widget.present? }
    @abouturl = @browser.url
    if @browser.url != /about/ && @abouturl != nil
     @browser.goto @abouturl 
     @browser.wait_until($t) { @about_widget.present? }
    end
  end

  def check_about_banner
  	@browser.wait_until($t) { @about_banner.present? || @about_inverted_banner.present? } 
  end

  def check_about_page_text_widget
    if !@about_text_widget.present?
      edit_text_widget
    end
  	@browser.wait_until($t) { @about_text_widget.present? }
  end

  def check_breadcrumb_link
  	@browser.wait_until($t) { @breadcrumb_link.present? }
  	@breadcrumb_link.click
  	@browser.wait_until($t) { @topic_page.present? }
  end

  def check_browser_tab_title
  	
  	assert_match @browser.title, "#{$network}"
  end

  def check_about_page_footer
  	@browser.execute_script("window.scrollBy(0,10000)")
    @browser.wait_until($t) { @footer.present? }
  end

  def check_about_edit_button
    @browser.wait_until($t) { @about_edit.present? }
  end

  def edit_about_banner
  	aboutbannerimage1 = File.expand_path(File.dirname(__FILE__) + "/../../seeds/development/images/sapbanner2before.jpeg") 
    aboutbannerimage2 = File.expand_path(File.dirname(__FILE__) + "/../../seeds/development/images/sapbannerafter.jpeg") 
    @browser.wait_until($t) { @about_edit.present? }
    @about_edit.click
    @browser.wait_until($t) { @about_edit_mode.present?}
    if @about_edit_browse_new.present?
      @about_edit_browse_new.click
    else
     assert @about_edit_change.present?
    end
    
    if $os == "windows"
      @browser.execute_script('$(".photo-upload-browse").removeClass("photo-upload-browse")')
    end
    @about_change_photo.set aboutbannerimage1
    @browser.wait_until($t) { @about_edit_selected_file.present? }
    @about_img_upload.click
    @browser.wait_until($t) { @about_img_upload.present? != true }
    @browser.wait_until($t) { @about_banner_editmode.present? }
    @browser.goto @url
    @browser.wait_until($t) { @about_widget.present? }
    banner_image1 = @about_banner.style   
    assert_match /sapbanner2before.jpeg/, banner_image1, "background url should match sapbanner2.jpeg"

    @about_edit.click
    @browser.wait_until($t) { @about_edit_mode.present?}
    assert @about_edit_change.present?
    
    if $os == "windows"
      @browser.execute_script('$(".photo-upload-browse").removeClass("photo-upload-browse")')
    end
    @about_change_photo.set aboutbannerimage2
    @browser.wait_until($t) { @about_edit_selected_file.present? }
    @about_img_upload.click
    @browser.wait_until($t) { @about_img_upload.present? != true }
    @browser.wait_until($t) { @about_banner_editmode.present? }
    @browser.goto @url
    @browser.wait_until($t) { @about_widget.present? }
    banner_image2 = @about_banner.style   
    assert_match /after.jpeg/, banner_image2, "background url should match sapbannerafter.jpeg"
  end

  def edit_text_widget
  	text_widget = "About page text widget set by Watir - #{get_timestamp}"
    @loginpage = CommunityLoginPage.new(@browser)
    if !@loginpage.username.present?
      about_login("regular", "logged")
      goto_about_page
    end
  	@about_edit.click
    @browser.wait_until($t) { @about_edit_mode.present?}
    @about_text_widget_edit.click
    @browser.wait_until($t) { @about_edit_mode.present? }
    @browser.execute_script('$("div.note-editing-area").focus()')
    @browser.wait_until { @browser.div(:class => "editing widget text can-edit").present? }
    @browser.execute_script('$("div.note-editable").empty()')
    
    @browser.execute_script('$("div.note-editable").text('+"'"+text_widget+"')")
    
    @browser.execute_script('$("div.note-editable").blur()')
    @browser.execute_script('$("button.btn btn-default").focus()')
    
    @about_text_widget_view_button.click
    @browser.goto @about_url

    @browser.wait_until($t) { @about_text_widget.present? }
    
    @browser.refresh
    @browser.wait_until($t) { @about_text_widget.present? }
    assert @about_text_widget.text.include? text_widget
    @browser.wait_until($t) { @about_text_widget.present? }
    assert_equal @about_text_widget.text, text_widget
  end

end