require File.expand_path(File.dirname(__FILE__) + "/page_object.rb")
class HybrisCommunityPageObject < PageObject

  def initialize(browser)
    super
    @url = $community_base_url

    #login page
    @sign_in_link = @browser.link(:class => "login ember-view login", :text => "Sign In")
    @user_name = @browser.text_field(:id => "member_login")
    @password = @browser.text_field(:id => "member_password")
    @sign_in_btn = @browser.input(:class => "btn btn-primary", :value => "Sign in")

    #header
    @user = @browser.link(:class => "dropdown-toggle username")
    @log_in = @browser.link(:class => "login ember-view login")
    @account_settings = @browser.link(:text => "Account settings")
    @log_out = @browser.link(:text => "Sign Out")

    #account setting
    @mapping_off = @browser.button(:class => "btn btn-sm btn-default mapToggle", :text => "OFF")
    @save = @browser.input(:type => "submit")

    #conversation
    @submit = @browser.button(:text => /Submit/)
    @reply_textarea = @browser.textarea(:id => "wmd-input")
    @root_post = @browser.div(:class => /root-post depth-0/)
    @root_open_menu = @root_post.div(:class => "dropdown pull-right")
    @root_menu = @root_post.ul(:class => "dropdown-menu")
    @sort = @browser.span(:class => "dropdown-toggle", :text => /Sorted by/)
    @sort_menu = @browser.div(:class => "pull-right sort-by dropdown")

    #widget
    @widget = @browser.div(:class => "widget recent_mention_products")
    @ask_question_link = @browser.link(:text => "Ask a New Question")

    #create/edit root post
    @input_title = @browser.text_field(:id => "inputTitle")
    @input_content = @browser.div(:class => "note-editable panel-body")

    #shopping cart
    @shopping_cart_icon = @browser.div(:class => "drop-menu nav-cart")
    @checkout_button = @browser.link(:class => "checkout-btn")

    #Admin functions entry
    @admin_page_link = @browser.div(:class=>"dropdown open").link(:href => "/admin/#{$network_slug}")

    @widget_theme_entry = @browser.link(:class => "ember-view", :text => "Widget Theme")
    @ecom_integration_entry = @browser.link(:class => "ember-view", :text => "E-commerce Integration")
    @oauth_configuration_entry = @browser.link(:class => "ember-view", :text => "OAuth Configuration")

    #theme builder
    @widget_theme_edit_button = @browser.link(:class => "btn btn-primary", :text => "Edit Widget Theme")
    @widget_theme_sample_preview = @browser.div(:id => "Excelsior-Controller-SimpleReview-preview-example")
    @widget_sample_preview_title = @browser.p(:class => "e-post-title ellipsis")
    @widget_sample_preview_content = @browser.div(:class => "e-post-content")

    @header_font = @browser.select_list(:id => "widget-header-font")
    @header_font_size = @browser.select_list(:id => "widget-header-font-size")
    @body_font = @browser.select_list(:id => "widget-body-font")
    @body_font_size = @browser.select_list(:id => "widget-body-font-size")
    @button_font = @browser.select_list(:id => "widget-button-font")
    @button_font_size = @browser.select_list(:id => "widget-button-font-size")
    @button_size = @browser.select_list(:id => "widget-button-size")

    @review_teaser = @browser.label(:class => "component-button btn btn-default active", :text => "Review Teaser")
    @review_tab = @browser.label(:class => "component-button btn btn-default active", :text => "Review Tab")
    @qa_teaser = @browser.label(:class => "component-button btn btn-default active", :text => "Q&A Teaser")
    @question_tab = @browser.label(:class => "component-button btn btn-default active", :text => "Question Tab")
    @homepage_review = @browser.label(:class => "component-button btn btn-default active", :text => "Home Page Review")
    @homepage_qa = @browser.label(:class => "component-button btn btn-default active", :text => "Home Page Q&A")
    @discussion_tab = @browser.label(:class => "component-button btn btn-default active", :text => "Discussion Tab")
    @blog_tab = @browser.label(:class => "component-button btn btn-default active", :text => "Blog Tab")
    @product_card = @browser.label(:class => "component-button btn btn-default active", :text => "Product Card")

    @publish_btn = @browser.button(:class => "btn tool-btn btn-primary", :text => "Publish")
    @get_code_btn = @browser.button(:class => "btn tool-btn btn-default", :text => "Get Code")
    @save_btn = @browser.button(:class => "btn tool-btn btn-default", :text => "Save")
    @reset_btn = @browser.button(:class => "btn tool-btn btn-default", :text => "Reset")
    @exit_btn = @browser.button(:class => "btn tool-btn btn-default", :text => "Exit")

    @modal_publish_btn = @browser.div(:id => "publish-modal-footer").button(:class => "btn btn-primary", :text => "Publish")
    @modal_cancel_btn = @browser.div(:id => "publish-modal-footer").button(:class => "btn btn-default", :text => "Cancel")
    @modal_copy_btn = @browser.div(:class => "modal-content").button(:class => "btn-primary", :text => "Copy")
    @modal_save_copy_btn = @browser.div(:class => "modal-content").button(:class => "btn-default", :text => "Save a Copy")
    @modal_cancel_btn = @browser.div(:class => "modal-content").button(:class => "btn-default", :text => "Cancel")
  end

  def open_homepage
    @browser.goto @url
  end

  def go_to_admin
    @browser.goto $community_base_url + "admin/#{$network_slug}"
  end

  def go_to_admin_component(component)
    case component
    when "theme_builder"
      @widget_theme_entry.when_present.click
    when "ecom_integration_entry"
      @ecom_integration_entry.when_present.click
    when "oauth_configuration_entry"
      @oauth_configuration_entry.when_present.click
    else
      raise "Invalid component options #{component}"
    end
  end

  def login(user)
    @browser.goto @url + "n/#{$network_slug}/members/sign_in"
    @browser.wait_until{ @user_name.present? }
    @user_name.when_present.focus
    @user_name.set user[0]
    @password.when_present.focus
    @password.set user[1]
    @sign_in_btn.click
    @browser.wait_until{ @browser.link(:class => "dropdown-toggle username").present? }
  end

  def check_loaded
  	@browser.wait_until{ @browser.div(:id => "chicago").present? }
  end

  def check_mapped
  	!@log_in.exist?
  end

  def check_user user_name
  	assert @user.text == user_name
  end

  def delete_post
    @root_open_menu.when_present.click
    @root_menu.link(:text =>/Delete/).when_present.click
    @browser.button(:text => /Delete Post/).when_present.click
    @browser.wait_until { @browser.div(:class => "topic-filters").present? }
  end

  def go_to_account_setting
    @browser.wait_until{ @user.present? }
    @browser.goto $community_base_url + "n/#{$network_slug}/members/edit"
    @browser.wait_until{ @browser.h3(:text => "Account Settings").present? }
  end

  def break_mapping
  	if @mapping_off.exist?
      @browser.execute_script('arguments[0].scrollIntoView();', @mapping_off)
  		@mapping_off.when_present.click
    	assert @mapping_off.class_name.include? "active"
      @browser.execute_script('arguments[0].scrollIntoView();', @save)
    	@save.when_present.click
    	@browser.wait_until{@browser.button(:text => "Edit Profile").present?}
    else
	   	puts "This user is not mapped or the break mapping feature is not opened"
    end
  end

  def at_mention_product_on_reply product_hint
    reply_text = "reply by Watir - #{get_timestamp}"
    root = @browser.div(:class => "ember-view response media", :index => 0)
    card_on_reply(root, reply_text, product_hint)
  end

  def edit_mention_product_on_reply (post, product_hint)
    edit_text = "Edited - #{get_timestamp}"
    @browser.execute_script('arguments[0].scrollIntoView();', post)
    post.span(:class => "dropdown-toggle").when_present.click
    post.link(:text => "Edit").when_present.click
    @browser.wait_until($t) { post.textarea().present? }
    @browser.wait_until($t) { post.div(:class => "product-mention-wrap").present?}
    card_on_reply(post,edit_text,product_hint) 
  end

  def card_on_reply(post, reply_text, product_hint)
    mention_text = reply_text + "@" + product_hint
    post.textarea.when_present.focus
    @browser.send_keys mention_text
    @browser.wait_until($t) {post.div(:class => "at-list-wrap").present?}
    @browser.wait_until($t) {post.p(:class => "at-list-title").present?}
    sleep 5 # work around for EN-1950
    @browser.send_keys :enter
    preview = post.div(:class => "wmd-preview")
    @browser.wait_until($t) {preview.present?}
    @browser.wait_until($t) {preview.div(:class => "conversation-product", :text=>/#{product_hint}/).present?}
    submit = @browser.button(:text => /Submit/)
    @browser.wait_until{submit.present?}
    @browser.execute_script('arguments[0].scrollIntoView();', submit)
    submit.when_present.click
    post_created = @browser.div(:class => "depth-1", :text => /#{reply_text}/)
    post_card_created = post_created.p(:class => "product-title",:text => /#{product_hint}/)
    sort_by "Newest"
    @browser.wait_until($t) { post_created.present? }
    @browser.wait_until($t) { post_card_created.present? }
    post_card_created.link.href  
  end

  def at_mention_product_on_root_post product_hint
    go_to_create_root_post
    title_text = "title by Watir - #{get_timestamp}"
    content_text = "content by Watir - #{get_timestamp}"
    mention_text = content_text + "@" + product_hint
    @input_title.when_present.focus
    @input_title.set title_text
    @input_content.when_present.focus
    @browser.send_keys mention_text
    @browser.wait_until($t) {@browser.ul(:class => "at-list").present?}
    @browser.wait_until($t) {@browser.p(:class => "at-list-title").present?}
    @browser.send_keys :enter
    card_preview = @browser.div(:class => "conversation-product")
    @browser.wait_until($t) { card_preview.present?}
    text = card_preview.p(:class => "product-title").text
    @browser.execute_script('arguments[0].scrollIntoView();', @submit)
    @submit.when_present.click
    post = @browser.div(:class => "post-content", :text => /#{text}/)
    post_card = post.div(:class => "conversation-product")
    @browser.wait_until($t) { post.present? }
    @browser.wait_until($t) { post_card.present? }
    post_card.link.href
  end

  def go_to_create_root_post
    @browser.wait_until($t) {@browser.div(:class => "widget featured_topics").present?}
    @browser.wait_until($t) {@browser.div(:class => "widget popular_discussions").present?}
    sleep 8
    @ask_question_link.when_present.click
  end

  def check_recent_mentioned_product(first_link, seq=0)
    @browser.wait_until($t) { @widget.li(:index => seq).link.present? }
    assert first_link.include? @widget.li(:index => seq).link.href
  end

  def sort_by option
    if @sort.present?
      @sort.when_present.click
      @browser.wait_until($t) { @sort_menu.present?}
      @sort_menu.link(:text => option).click
      @browser.wait_until { @sort.text.include? option}
      @browser.wait_until { @browser.div(:class => /ember-view depth-1/).exists? }
    end
  end

  def add_to_cart product_seq_or_name
    card = nil
    if product_seq_or_name.is_a? Integer   
      card = @browser.div(:class => "conversation-product",:index => product_seq_or_name)
    else
      card = @browser.div(:class => "conversation-product",:text => /#{product_seq_or_name}/)
    end
    @browser.wait_until{ card.present? }
    @browser.execute_script('arguments[0].scrollIntoView();', card)
    product_name = card.p(:class => "product-title").text
    cart_number = @shopping_cart_icon.text.to_i
    card.link(:class => "btn btn-primary").when_present.click
    @browser.execute_script('arguments[0].scrollIntoView();', @shopping_cart_icon)
    @browser.wait_until { @shopping_cart_icon.text.to_i == cart_number + 1 }
    @shopping_cart_icon.when_present.hover
    cart_item = @browser.li(:class => "cart-popup-item", :text => /#{product_name}/)
    @browser.wait_until { cart_item.present? }
    cart_item
  end

  def change_product_number_in_cart cart_item, number
    item_number = get_cart_item_number cart_item
    total_number = get_cart_total_number
    # work round for alert bug, instead cart_item.text_field.set number
    cart_item.text_field.when_present.double_click
    @browser.send_keys :backspace
    @browser.send_keys number

    total_change_number = get_cart_total_number
    assert item_number-number == total_number-total_change_number
  end

  def remove_product_from_cart cart_item
    item_number = get_cart_item_number cart_item
    total_number = get_cart_total_number
    cart_item.link(:class => "cart-del").when_present.click
    @browser.wait_until{ !cart_item.present? }
    total_change_number = get_cart_total_number
    assert_equal item_number, total_number-total_change_number
  end

  def view_cart
    products = check_total_item_price
    @checkout_button.when_present.click
    sleep 5
    overnumber_cart_items = @browser.lis(:class => "cart-popup-item error")
    if overnumber_cart_items.count > 0
      overnumber_cart_items.each do |overnumber_cart_item|
        title = get_cart_item_title overnumber_cart_item
        change_product_number_in_cart overnumber_cart_item,1
        puts "#{title} out of stock, reset to 1"
      end
      products = check_total_item_price
      @checkout_button.when_present.click
    end
    @browser.wait_until{ @browser.windows.last.use.url.include? ("cartsId")}
    @browser.windows.last.use
    products
  end

  def check_total_item_price
    cart_items = @browser.lis(:class => "cart-popup-item")
    total_number,total_price = 0,0
    products = Hash.new
    cart_items.each do |cart_item|
      title = get_cart_item_title cart_item
      item_number = get_cart_item_number cart_item
      item_price = get_cart_item_price cart_item
      total_number = total_number + item_number
      total_price = (total_price + item_number*item_price).round(2)
      products[title] = item_number
    end
    assert_equal total_number, get_cart_total_number
    assert_equal total_price, get_cart_total_price
    products
  end

  def get_cart_item_title cart_item
    cart_item.div(:class => "cart-item-title").text
  end

  def get_cart_item_number cart_item
    cart_item.input.value.to_i
  end

  def get_cart_item_price cart_item
    price = cart_item.div(:class => "cart-item-price").inner_html
    price.delete(',')[/\d(\d+|\.)+/].to_f
  end

  def get_cart_total_number
    total_number = @browser.div(:class => "drop-menu-header").link.inner_html
    total_number[/\d+/].to_i
  end

  def get_cart_total_price
    total_price = @browser.div(:class => "drop-menu-footer").h5.inner_html
    total_price.delete(',')[/\d(\d+|\.)+/].to_f
  end

  def change_theme_font(font)
    go_to_admin_component "theme_builder"
    @browser.wait_until{ @widget_theme_sample_preview.present? }
    @widget_theme_edit_button.when_present.click

    @header_font_size.when_present.select(font)
    @body_font_size.when_present.select(font)

    @publish_btn.when_present.click
    @modal_publish_btn.when_present.click
    @browser.wait_until{ @widget_theme_sample_preview.present? }
    sleep 2
    assert @widget_sample_preview_title.style("font-size") == font, "header font size expect #{font}, but got #{@widget_sample_preview_title.style('font-size')}"
    assert @widget_sample_preview_content.style("font-size") == font, "content font size expect #{font}, but got #{@widget_sample_preview_content.style('font-size')}"
  end

  def reset_theme
    go_to_admin_component "theme_builder"
    @browser.wait_until{ @widget_theme_sample_preview.present? }
    @widget_theme_edit_button.when_present.click
    sleep 3
    @reset_btn.when_present.click

    @publish_btn.when_present.click
    @modal_publish_btn.when_present.click
    @browser.wait_until{ @widget_theme_sample_preview.present? }
    sleep 3
    assert @widget_sample_preview_title.style("font-size") == "12px", "header font size expect 12px, but got #{@widget_sample_preview_title.style('font-size')}"
    assert @widget_sample_preview_content.style("font-size") == "12px", "content font size expect 12px, but got #{@widget_sample_preview_content.style('font-size')}"
  end

  def logged_in?
    @browser.link(:class => "dropdown-toggle username").present?
  end

  def log_out
    sleep 2
  	@user.when_present.click
    sleep 2
  	@log_out.when_present.click
  	sleep 2
  	@browser.wait_until{ @log_in.present? }
  end
end