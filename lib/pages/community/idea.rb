class Pages::Community::Idea < Pages::Community
  def initialize(config, options = {})
    super(config)
  end


  topic_input                      { text_field(:id => ("topic-auto-complete"))}
  topic_list_first_item            { ul(:class =>"dropdown-menu topic-dropdown").li}
  topic_badge_items                { div(:class => "topic-badge").links }
  topic_badge_items_delete         { spans(:css => ".topic-badge .icon-decline") }
  title_input                      { text_field(:class => "ember-text-field",:placeholder=>/title/) }
  desc_input                       { div(:class => /note-editable/) }

  new_conversation_at_list         { ul(:class => "at-list at-blog-list").li}
  new_conversation_product_item    { div(:class => "new-conversation-product")}

  submit_idea_button               { div(:class => "pull-right").button(:class => "btn-primary")}

  def new_idea( topic: [], title:"idea title - #{get_timestamp}", desc: "idea desc #{get_timestamp}", adding_product:false)
    idea_step( :topic => topic, :title => title, :desc => desc, :adding_tag => true, :adding_product => adding_product)
  end

  def edit_idea( topic: [], title:"idea title - #{get_timestamp}", desc: "idea desc #{get_timestamp}")
    # @browser.wait_until { topic_badge_items_delete[0].present? }
    # for topic_badge_item_delete in topic_badge_items_delete
    #   topic_badge_item_delete.when_present.click
    # end
    idea_step( :topic => [], :title => title, :desc => desc, :is_edit => true)
  end

  def idea_step( topic: [], title:"idea title - #{get_timestamp}", desc: "idea desc #{get_timestamp}", is_edit: false, adding_tag: false, adding_product:false)
    @browser.wait_until { topic_input.present? && title_input.present? && desc_input.present? }
    for topic_item in topic
      topic_input.when_present.set topic_item
      @browser.wait_until{ topic_list_first_item.present? }
      @browser.send_keys :enter
    end

    title_input.when_present.set title

    if is_edit
      @browser.execute_script("this.$('.note-editable div').remove()")
      @browser.execute_script("this.$('.note-editable p').remove()")
      @browser.wait_until { !new_conversation_product_item.present? }
    end
    desc_input.when_present.click
    @browser.send_keys desc

    if adding_tag
      @browser.send_keys "#ideatest"
      begin
        @browser.wait_until(3) { new_conversation_at_list.present? }
        new_conversation_at_list.when_present.click
      rescue
        @browser.send_keys :enter
      end
    end

    if adding_product
      @browser.send_keys "@powerShotA480"
      begin
        @browser.wait_until(3) { new_conversation_at_list.present? }
        new_conversation_at_list.when_present.click
        @browser.wait_until(3) { new_conversation_product_item.present? }
      rescue 
        @browser.send_keys :enter
      end
    end

    @browser.execute_script("window.scrollBy(0,1000)")
    submit_idea_button.when_present.click
  end
end
