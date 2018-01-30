require 'pages/community'
require 'pages/community/conversation/publish_setting'

class Pages::Community::ConversationInput < Pages::Community
  def initialize(config, options = {})
    super(config)
  end

  mention_prod_icon                 { span(:data_type => "product")}
  mention_tag_icon                  { span(:data_type => "tag")}
  mention_prod_icon_tooltip         { element(:css => ".note-editor .at-mention-tags-icons .tag-icon[data-type=product] .tooltips") }
  mention_tag_icon_tooltip          { element(:css => ".note-editor .at-mention-tags-icons .tag-icon[data-type=tag] .tooltips") }
  mention_blue_tooltip_close_btn    { span(:css => ".at-mention-tags-icons .icon-decline")}

  mention_prod_tip                  { element(:css => ".at-list-wrap .mention-tips") }
  mention_suggest_list              { ul(:class => "at-list") }
  conv_input_placeholders           { divs(:css => ".product-card-placeholder") }
  conversation_products             { divs(:css => ".note-editing-area [class*='conversation-product']") }

  # only for review
  recommend_yes_radio       { input(:css => ".recommend-label input[value=true]") }
  recommend_no_radio        { input(:css => ".recommend-label input[value=false]") }
  recommend_checkbox        { input(:css => ".recommend-label [name='recommended']") }
  # only for review
  def star_at_num(num)
    @browser.element(:css => ".star-style:nth-of-type(#{num})")
  end 

  def title_field
    @browser.text_field(:css => "#{@parent_css} #inputTitle")
  end 

  def details_field
    @browser.div(:css => "#{@parent_css} .note-editable")
  end  

  def add_attachment_btn
    @browser.button(:css => '#{@parent_css} .note-insert button[data-original-title="Add Attachment"]')
  end

  def attachment_uploader
    @browser.text_field(:css => "#{@parent_css} .file-uploader")
  end

  def blog_publish_setting_modal
    Pages::Community::PublishSetting.new(@config)
  end  

  def submit_btn
    @browser.button(:css => "#{@parent_css} .btn-primary.conversation-submit")
  end
  
  def cancel_btn
    @browser.button(:css => "#{@parent_css} .btn-primary.conversation-submit + .btn-default")
  end

  def submit_spinner
    @browser.element(:css => "#{@parent_css} .btn-primary.conversation-submit .fa-spinner")
  end  

  def attachments_panel
    AttachmentsPanel.new(@browser)
  end  

  def set_star(num)
    star_at_num(num).when_present.click
  end

  def set_recommend(recommended)
    recommend_checkbox.when_present.click if (recommended && !recommend_checkbox.attribute_value('checked') ||  \
                                              !recommended && recommend_checkbox.attribute_value('checked'))   
  end  

  def set_title(title)
  	title_field.set(title)
  end	

  # def set_details(description)
  #   @browser.execute_script('$("div.note-editable").html($("div.note-editable").html() + "' + description + '")')
  #   @browser.execute_script('$("div.note-editable").blur()') #needed to communicate the description back to the parent element. the blur events fires fine during manual creation.
  #   @browser.execute_script("window.scrollBy(0,600)")
  # end

  def set_details(contents)
    @browser.execute_script('arguments[0].focus()', details_field)

    contents.each do |content|
      case content[:type]
      when :text
        @browser.send_keys content[:content]
        @browser.send_keys :enter # workaround for EN-2719
      when :product
        @browser.wait_until { conv_input_placeholders.size == 0 }
        old_mention_prods_num = conversation_products.size
        case content[:way]
        when :key, nil
          @browser.send_keys "@"
        when :icon
          scroll_to_element mention_prod_icon
          mention_prod_icon.when_present.click
        end
        @browser.send_keys content[:hint]
        @browser.wait_until { mention_suggest_list.present?}
        mention_suggest_list.lis[0].when_present.click
        @browser.wait_until { !mention_suggest_list.present? }
        @browser.wait_until { conversation_products[0].present? }
        @browser.wait_until { conversation_products.size == old_mention_prods_num + 1 }

        sleep 2
      when :tag
        case content[:way]
        when :key, nil
          @browser.send_keys "#"
        when :icon
          scroll_to_element mention_tag_icon
          mention_tag_icon.when_present.click
        end

        if content[:hint].nil?
          @browser.send_keys content[:content]
        else
          @browser.send_keys content[:hint]
          @browser.wait_until { mention_suggest_list.present? }
          mention_suggest_list.lis[0].when_present.click
          @browser.wait_until { !mention_suggest_list.present? }
        end  
      end 
    end

    @browser.execute_script('$("div.note-editable").blur()') #needed to communicate the description back to the parent element. the blur events fires fine during manual creation.
    @browser.execute_script("window.scrollBy(0,600)")
  end  

  def upload_attachment(file)
    # show the file uploader so as to set file to it
    unless attachment_uploader.present?
      @browser.execute_script('$("div.attachment-container").css("display", "block")')
      @browser.execute_script('$("input.file-uploader").css("display", "block")')
    end

    attachments_count_pre = attachments_panel.attachments.size

    attachment_uploader.set(file)

    # hide the file uploader
    @browser.execute_script('$("input.file-uploader").css("display", "none")')

    @browser.wait_until { attachments_panel.attachments.size == (attachments_count_pre + 1) }
    @browser.wait_until { submit_btn.enabled? }
  end 

  def submit(type)
    accept_policy_warning
    submit_btn.when_present.click

    case type
    when :blog
      blog_publish_setting_modal.set
    end 

    @browser.wait_until { !submit_spinner.present? }
    # Even with the following script, there appears another issue that scrollbar disappear sometimes.
    # So, add sleep 0.5 above to workaround this.
    # workaround for the issue that "modal-backdrop fade in" show sometimes 
    # @browser.execute_script('$(".modal-backdrop.fade.in").removeClass("modal-backdrop fade in")')
  end

  # .strftime('%m/%d/%Y %l:%M %p')
  def submit_blog(publish_schedule=nil)
    accept_policy_warning
    submit_btn.when_present.click

    blog_publish_setting_modal.set(publish_schedule)

    @browser.wait_until { !submit_spinner.present? }
  end  

  def fill_in_conversation_fields(type: nil, title: nil, details: nil, attachments: nil)
    @browser.wait_until { title_field.present? }
    accept_policy_warning

    select_type(type) unless type.nil?
    title_field.set(title) unless title.nil?
    set_details(details) unless details.nil?

    # upload attachments
    attachments.each { |file| upload_attachment(file) } unless attachments.nil?
  end

  def fill_in_review_fields(title: nil, details: nil, attachments: nil, star: 5, recommended: true)
    @browser.wait_until { title_field.present? }
    accept_policy_warning

    # sometimes, some editor fields are overlapped with top navigator
    @browser.execute_script("window.scrollTo(0,document.documentElement.scrollTop)")

    # fix overlap issue
    scroll_to_element(title_field)
    @browser.execute_script("window.scrollBy(0,-200)")

    set_star(star) unless star.nil?

    title_field.set(title) unless title.nil?
    set_details(details) unless details.nil?
    
    # upload attachments
    attachments.each { |file| upload_attachment(file) } unless attachments.nil?

    set_recommend(recommended) unless recommended.nil?
  end  

  def fill_in_fields_then_submit_conversation(type: nil, title: nil, details: nil, attachments: nil)
    fill_in_conversation_fields(type: type, title: title, details: details, attachments: attachments)

    # submit
    submit(type)
  end 

  def edit_fields_then_submit_conversation(type: :question, title: nil, details: nil, attachments: nil)
    fill_in_conversation_fields(type: nil, title: title, details: details, attachments: attachments)

    submit(type)
  end  

  def fill_in_fields_then_submit_review(title: nil, details: nil, attachments: nil, star: 5, recommended: true)
    fill_in_review_fields(title: title, details: details, attachments: attachments, star: star, recommended: recommended)

    # submit
    submit(:review)
  end  

  class AttachmentsPanel
    def initialize(browser)
      @browser = browser
      @parent_css = ".attachment-container"
    end

    def delete_all_btn
      @browser.button(:css => @parent_css + " #remove_all")
    end

    def present?
      @browser.div(:css => @parent_css).present?
    end  

    def label_count
      @browser.element(:css => @parent_css + " .attachment-title").text[/\d+/].to_i
    end

    def delete_all
      delete_all_btn.click

      @browser.wait_until { !present? }
    end

    def attachments
      list_eles = @browser.lis(:css => @parent_css + " .list-group .list-group-item")

      results = []

      return [] if list_eles.size < 1

      (1..list_eles.size).each { |i|
        results.push(Attachment.new(@browser, @parent_css + " .list-group > .list-group-item:nth-child(#{i})"))
      }

      results
    end  

    class Attachment
      def initialize(browser, parent_css)
        @browser = browser
        @parent_css = parent_css
      end

      def name_field
        @browser.text_field(:css => @parent_css + " .file-title .rename-input")
      end  

      def actions_arrow
        @browser.element(:css => @parent_css + " .dropdown .icon-navigation-down-arrow")
      end

      def rename_menu_item
        @browser.element(:css => @parent_css + " .dropdown .dropdown-menu .icon-edit")
      end

      def download_menu_item
        @browser.element(:css => @parent_css + " .dropdown .dropdown-menu .icon-download")
      end

      def delete_menu_item
        @browser.element(:css => @parent_css + " .dropdown .dropdown-menu .icon-delete")
      end 

      def name
        name = nil

        return name if @browser.span(:css => @parent_css + " .file-title").when_present.text.match(/(.*) \(.*\)/).nil?

        if @browser.span(:css => @parent_css + " .file-title").when_present.text.match(/(.*) \(.*\)/).size > 0
          name = @browser.span(:css => @parent_css + " .file-title").when_present.text.match(/(.*) \(.*\)/)[1]
        else
          name
        end

        name
      end

      def rename(new_name)
        actions_arrow.when_present.click

        rename_menu_item.when_present.click

        name_field.when_present.set(new_name)
        @browser.send_keys :enter

        @browser.wait_until { name == new_name }
      end
      
      def download
        actions_arrow.when_present.click
        download_menu_item.when_present.click
      end

      def delete
        actions_arrow.when_present.click
        delete_menu_item.when_present.click
      end  
    end  
  end  
end