require 'pages/community/ui_design/editors/base'

class PropEditors::Community::Image < PropEditors::Base
  def initialize(browser, parent_css)
    super(browser, parent_css)
  end

  def change_settings(settings)
    settings.each do |s|
      case s[:type]
      when :bgcolor
        set_bgcolor(s[:value])
      when :upload
        upload_image(s[:value])
        filename = File.basename(s[:value])
        @browser.wait_until { @gadget.bg_image =~ /#{filename}/ }
      when :remove
        remove_image
        @browser.wait_until { @gadget.bg_image =~ /null/ }
      else
        raise "Type #{s[:type]} not supported yet"
      end  
    end 
  end 

  def bgcolor_label
    @browser.label(:css => @parent_css + " .prop-color label")
  end

  def bgcolor_input_css
    @parent_css + " .prop-color input"
  end  

  def set_bgcolor(color)
    @browser.execute_script("$('#{bgcolor_input_css}').focus()")
    @browser.execute_script("$('#{bgcolor_input_css}').val('#{color}')")
    bgcolor_label.when_present.click # make input loose focus to save the color change
    @browser.wait_until { bgcolor_label.text == color }
  end  

  def image_uploader_css
    @parent_css + " .photo-browse-input"
  end 

  def image_uploader
    @browser.text_field(:css => image_uploader_css)
  end 

  def select_photo_btn_in_edit_photo_modal
    @browser.button(:css => @parent_css + " .file-upload-select-button")
  end  

  def upload_image(file)
    # show the file uploader so as to set file to it
    unless image_uploader.present?
      @browser.execute_script("$('#{image_uploader_css}').css('display', 'block')")
    end

    image_uploader.set(file)
    # hide the file uploader
    @browser.execute_script("$('#{image_uploader_css}').css('display', 'none')")

    sleep 1 # no response when click the button below sometimes
    select_photo_btn_in_edit_photo_modal.when_present.click
    @browser.wait_until { !select_photo_btn_in_edit_photo_modal.present? }
  end 

  def remove_image_btn
    @browser.element(:css => @parent_css).span(:text => "Remove image")
  end 

  def remove_image
    remove_image_btn.when_present.click
  end 
end  