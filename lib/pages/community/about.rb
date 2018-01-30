require 'pages/community'
require 'minitest/assertions'

class Pages::Community::About < Pages::Community

  def initialize(config, options = {})
    super(config)
    @url = config.base_url + "/n/#{config.slug}/about"
  end

  def start!(user)
    super(user, @url, about_banner)
  end
 
  about_url                      { "#{@@base_url}" + "/n/#{@@slug}/about" }
  about_banner                   { div(:class => /normal  widget banner /) }
  # about_banner                   { div(:css => ".widget.banner.about") }
  about_banner_editmode          { div(:class => /ember-view uploader-component widget banner/) }
  about_inverted_banner          { div(:class => "inverted  widget banner about") }
  about_text_widget              { div(:class => "widget text") }

  ### !
  #about_widget                   { div(:class => "about-page-widgets") }
  breadcrumb_link                { link(:class => "ember-view", :text => "#{$network}") }
  topic_page                     { div(:class => "col-sm-12 col-lg-4 col-md-4") }
  tab_title                      { title }
  #footer                         { footer(:class => "ember-view") }

  about_edit                     { button(:class => "ember-view btn btn-default btn-sm admin-dark-btn", :text => "Edit About Page") }
  about_change_photo             { file_field(:class => "ember-view ember-text-field files file photo-browse-input btn btn-default btn-sm") }

  ### !
  #about_edit_mode                { button(:class => "btn btn-default btn-sm admin-dark-btn", :text => "ToggleTextMode") }
  about_edit_browse_new          { link(:text => "browse") }
  about_edit_change              { button(:class => "btn btn-default btn-sm admin-dark-btn", :text => "Change Photo") }
  about_edit_modal               { div(:class => "modal-header") }
  about_edit_file_field          { file_field(:class => "ember-view ember-text-field files") }
  about_edit_selected_file       { div(:class => "cropper-canvas") }
  about_img_upload               { button(:css => ".modal-dialog .modal-footer .file-upload-select-button") }

  edit_photo_modal_dialog        { div(:css => ".header .modal") }
  modal_backdrop                 { div(:css => ".modal-backdrop") }

  about_text_widget_edit         { div(:class => " widget text can-edit") }
  about_text_widget_editing_mode { div(:class => "editing widget text can-edit") }
  about_text_widget_view_button  { div(:class => "col-md-2").button(:class => "btn btn-default", :value => "View About Page") }
  about_text_widget_wysiwyg      { div(:class => "wysiwyg-container") }
  about_page_text_editable       { div(:class => "note-editable") }

  ### !
  #about_edit_mode                { div(:class => " widget text can-edit") }

  about_widget                   { div(:class => "about-page-widgets") }
  about_edit_mode                { div(:class => " widget text can-edit") }
  about_breadcrumb_link          { span(:class => "icon-slim-arrow-right", :text => "About") }
  about_title_row                { div(:css => ".widget.banner .title") }

  # edit about page
  about_toggle_txt_btn           { button(:css => ".widget.banner.about .btn-toolbar .btn-group > button:nth-child(3)") }

end