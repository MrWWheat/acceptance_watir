require 'watir_test'
require 'pages/community/topicdetail'
require 'pages/community/login'
require 'pages/community/home'
require 'pages/community/profile'
require 'pages/community/conversation/conversation_create'
require 'pages/community/conversation/conversation_edit'
require 'byebug'

class AttachmentTest < WatirTest

  def setup
    super
    @browser = @config.browser
    @topicdetail_page = Pages::Community::TopicDetail.new(@config)
    @login_page = Pages::Community::Login.new(@config)
    @conversation_create_page = Pages::Community::ConversationCreate.new(@config)
    @conversation_edit_page = Pages::Community::ConversationEdit.new(@config)
    # @home_page = Pages::Community::Home.new(@config)
    # @profile_page = Pages::Community::Profile.new(@config)
    @convdetail_page = Pages::Community::ConversationDetail.new(@config)
    # @hybris_detail_page = Pages::Hybris::Detail.new(@config)
    # assigning @current_page helps error reporting
    #  give good contextual data
    @current_page = @topicdetail_page
    puts "[[[ #{name} ::: #{user_for_test} ]]]" if @config.verbose?
   
    @test_data_dir = File.join(@config.data_dir, "attachment")

    @topicdetail_page.start!(user_for_test)
  end

  def teardown
    super
  end

  # =============== Test Case 1 ===============
  # Summary: Admin user can upload/rename/download/delete an attachment before submit a question
  # Steps:
  # 1. Admin create a question;
  # 2. Admin upload/rename/download/delete an attachment before submit a question.
  user :network_admin
  p2
  def test_00010_operate_network_attachment
    # go to a specific topic
    @topicdetail_page.topic_detail("A Watir Topic")
    @topicdetail_page.choose_post_type("question")

    # create a new question
   
    @topicdetail_page.goto_conversation_create_page(:question)
    @browser.wait_until { @conversation_create_page.title_field.present? }
    @conversation_create_page.select_type(:question)
    @conversation_create_page.title_field.set("Test q created by Watir - #{get_timestamp}")
    @conversation_create_page.set_details([{type: :text, content: "Watir test description"}])
    
    # upload an attachment
    file_name = "test.png"
    @conversation_create_page.upload_attachment(File.join(@test_data_dir, file_name))

    assert @conversation_create_page.attachments_panel.attachments.size == 1, "Number of attachments is not 1"
    assert @conversation_create_page.attachments_panel.label_count == 1, "Number of attachments is not 1"
    assert @conversation_create_page.attachments_panel.attachments[0].name == file_name, "Attachment name is incorrect"

    # download the attachment
    file_entries_before_download = Dir.entries(@config.download_dir)

    @conversation_create_page.accept_policy_warning
    @conversation_create_page.attachments_panel.attachments[0].download

    downloaded_file = wait_file_download(@config.download_dir, file_entries_before_download, "test", wait_time=30)

    assert !downloaded_file.nil?, "Cannot find the file downloaded"
    File.delete(downloaded_file)

    # rename it
    new_attachment_name = "test-rename.png"

    @conversation_create_page.attachments_panel.attachments[0].rename(new_attachment_name)

    assert @conversation_create_page.attachments_panel.attachments[0].name == new_attachment_name, "New attachment name is incorrect"

    # delete it
    @conversation_create_page.attachments_panel.attachments[0].delete

    @browser.wait_until { @conversation_create_page.attachments_panel.attachments.size == 0 }

    assert @conversation_create_page.attachments_panel.attachments.size == 0, "Number of attachments is not 0"
  end

  # =============== Test Case 2 ===============
  # Summary: Admin user can rename/download/delete a conversation attachment in a question
  # Steps:
  # 1. Admin create a question;
  # 2. Admin upload an attachment;
  # 3. Admin submit a question;
  # 4. Admin download the attachment;
  # 5. Admin edit the question;
  # 6. Admin rename the attachment;
  # 7. Admin edit the question;
  # 8. Admin download the attachment;
  # 9. Admin delete the attachment;
  # 10. Admin save the question.
  user :network_admin
  p1
  def test_00020_operate_question_attachment
    # go to a specific topic
    @topicdetail_page.topic_detail("A Watir Topic")
    @topicdetail_page.choose_post_type("question")

    # create a new question
    @topicdetail_page.goto_conversation_create_page(:question)
    @browser.wait_until { @conversation_create_page.title_field.present? }
    @conversation_create_page.select_type(:question)
    @conversation_create_page.title_field.set("Test q created by Watir - #{get_timestamp}")
    @conversation_create_page.set_details([{type: :text, content: "Watir test description"}])
    
    # upload an attachment
    file_name = "test.png"
    @conversation_create_page.upload_attachment(File.join(@test_data_dir, file_name))

    # submit
    @conversation_create_page.submit(:question)
    @browser.wait_until { @convdetail_page.conv_content.present? }
    @browser.refresh
    @browser.wait_until { @convdetail_page.attachments_panel.attachments.size > 0 }

    # verify the attachments displayed correctly in conversation details page
    assert @convdetail_page.attachments_panel.attachments.size == 1, "Number of attachments is not 1"
    assert @convdetail_page.attachments_panel.label_count == 1, "Number of attachments is not 1"
    assert @convdetail_page.attachments_panel.attachments[0].name == file_name, "Attachment name is incorrect"

    # download the attachment
    file_entries_before_download = Dir.entries(@config.download_dir)

    @convdetail_page.attachments_panel.attachments[0].download

    downloaded_file = wait_file_download(@config.download_dir, file_entries_before_download, "test", wait_time=30)

    assert !downloaded_file.nil?, "Cannot find the file downloaded"
    File.delete(downloaded_file)

    # edit the question
    @convdetail_page.goto_edit_page

    # rename the attachment
    new_attachment_name = "test-rename.png"

    @conversation_edit_page.scroll_to_element @conversation_edit_page.attachments_panel.attachments[0].actions_arrow
    @browser.execute_script("window.scrollBy(0,-500)")
    @conversation_edit_page.attachments_panel.attachments[0].rename(new_attachment_name)

    assert @conversation_edit_page.attachments_panel.attachments[0].name == new_attachment_name, "New attachment name is incorrect"

    # download the attachment
    file_entries_before_download = Dir.entries(@config.download_dir)

    @conversation_edit_page.attachments_panel.attachments[0].download

    downloaded_file = wait_file_download(@config.download_dir, file_entries_before_download, "test-rename", wait_time=30)

    # Expected: file is downloaded successfully
    assert !downloaded_file.nil?, "Cannot find the file downloaded"
    File.delete(downloaded_file)

    # submit
    @conversation_edit_page.submit(:question)
    @browser.wait_until { @convdetail_page.conv_content.present? }
    @browser.wait_until { @convdetail_page.attachments_panel.attachments.size == 1 }

    assert @convdetail_page.attachments_panel.attachments[0].name == new_attachment_name, "New attachment name is incorrect"

    # verify rename works even after refresh web browser
    @browser.refresh
    @browser.wait_until { @convdetail_page.conv_content.present? }
    @browser.wait_until { @convdetail_page.attachments_panel.attachments.size == 1 }

    assert @convdetail_page.attachments_panel.attachments[0].name == new_attachment_name, "New attachment name is incorrect"

    # edit the question again
    @convdetail_page.goto_edit_page

    # delete the attachment
    @conversation_edit_page.scroll_to_element @conversation_edit_page.attachments_panel.attachments[0].actions_arrow
    @browser.execute_script("window.scrollBy(0,-500)")
    @conversation_edit_page.attachments_panel.attachments[0].delete

    @browser.wait_until { @conversation_edit_page.attachments_panel.attachments.size == 0 }
    assert @conversation_edit_page.attachments_panel.attachments.size == 0, "Number of attachments is not 0"

    # Expected: Attachments panel is hidden when no attachments
    @browser.wait_until { !@conversation_edit_page.attachments_panel.present? }
    assert !@conversation_edit_page.attachments_panel.present?

    # submit
    @conversation_edit_page.submit(:question)
    @browser.wait_until { @convdetail_page.conv_content.present? }
    @browser.wait_until { @convdetail_page.attachments_panel.attachments.size == 0 }
    @browser.refresh
    @browser.wait_until { @convdetail_page.attachments_panel.attachments.size == 0 }
    
    # Expected: Attachments panel is hidden when no attachments
    @browser.wait_until { !@convdetail_page.attachments_panel.present? }
    assert !@convdetail_page.attachments_panel.present?

    @convdetail_page.delete_conversation
  end 

  # =============== Test Case 3 ===============
  # Summary: Admin user can add/delete multiple attachments
  # Steps:
  # 1. Admin create a question;
  # 2. Admin upload two attachments;
  # 3. Admin submit a question;
  # 4. Admin edit the question;
  # 5. Admin delete an attachment;
  # 6. Admin add a new attachment;
  # 7. Admin save the question;
  # 8. Admin edit the question;
  # 9. Admin delete all attachment;
  # 10. Admin save the question.
  user :network_admin
  p2
  def test_00030_add_multiple_attachments
    # go to a specific topic
    @topicdetail_page.topic_detail("A Watir Topic")
    @topicdetail_page.choose_post_type("question")

    # create a new question
    @topicdetail_page.goto_conversation_create_page(:question)
    @browser.wait_until { @conversation_create_page.title_field.present? }

    @conversation_create_page.select_type(:question)
    @conversation_create_page.title_field.set("Test q created by Watir - #{get_timestamp}")
    @conversation_create_page.set_details([{type: :text, content: "Watir test description"}])

    # upload an attachment
    file1_name = "test.png"
    file1_path = File.join(@test_data_dir, file1_name)
    file2_name = "test_1.png"
    file2_path = File.join(@test_data_dir, file2_name)
    file3_name = "中文文件.png"
    file3_path = File.join(@test_data_dir, file3_name)
    @conversation_create_page.upload_attachment(file1_path)
    @conversation_create_page.upload_attachment(file2_path)

    assert @conversation_create_page.attachments_panel.attachments.size == 2, "Number of attachments is not 1"
    assert @conversation_create_page.attachments_panel.label_count == 2, "Number of attachments is not 1"
    assert @conversation_create_page.attachments_panel.attachments[0].name == file1_name, "Attachment name is incorrect"
    assert @conversation_create_page.attachments_panel.attachments[1].name == file2_name, "Attachment name is incorrect"

    # submit
    @conversation_create_page.submit(:question)
    @browser.wait_until { @convdetail_page.conv_content.present? }
    @browser.refresh # sometimes, the attachments panel is not visible unless refresh which cannot be reproduced manually
    @browser.wait_until { @convdetail_page.attachments_panel.attachments.size > 0 }

    assert @convdetail_page.attachments_panel.attachments.size == 2, "Number of attachments is not 1"

    # edit the question
    @convdetail_page.goto_edit_page

    # delete the first attachment
    @conversation_edit_page.scroll_to_element @conversation_edit_page.attachments_panel.attachments[0].actions_arrow
    @browser.execute_script("window.scrollBy(0,-500)")
    @conversation_edit_page.attachments_panel.attachments[0].delete
    @browser.wait_until { @conversation_edit_page.attachments_panel.attachments.size == 1 }
    # upload a new attachment
    @conversation_edit_page.upload_attachment(file3_path)

    @browser.wait_until { @conversation_edit_page.attachments_panel.attachments.size == 2 }
    assert @conversation_edit_page.attachments_panel.attachments.size == 2, "Number of attachments is not 2"

    # submit
    @conversation_edit_page.submit(:question)
    @browser.wait_until { @convdetail_page.attachments_panel.attachments.size == 2 }

    assert @convdetail_page.attachments_panel.attachments.size == 2, "Number of attachments is not 2"
    assert @convdetail_page.attachments_panel.attachments[0].name == file2_name, "Attachment name is incorrect"
    assert @convdetail_page.attachments_panel.attachments[1].name == file3_name, "Attachment name is incorrect"

    # edit the question again
    @convdetail_page.goto_edit_page

    # delete all attachments
    @conversation_edit_page.scroll_to_element @conversation_edit_page.attachments_panel.attachments[0].actions_arrow
    @browser.execute_script("window.scrollBy(0,-500)")
    @conversation_edit_page.attachments_panel.delete_all

    # wait until attachments panel is hidden
    @browser.wait_until { !@conversation_edit_page.attachments_panel.present? }

    # submit
    @conversation_edit_page.submit(:question)
    @browser.wait_until { @convdetail_page.attachments_panel.attachments.size == 0 }
    assert @convdetail_page.attachments_panel.attachments.size == 0, "Number of attachments is not 0"

    @convdetail_page.delete_conversation
  end

  # =============== Test Case 4 ===============
  # Summary: Admin user can add attachment with chinese name
  # Steps:
  # 1. Admin create a blog;
  # 2. Admin upload a attachment with chinese name;
  # 3. Admin submit a blog;
  # 4. Admin rename the blog;
  # 5. Admin save the blog.
  user :network_admin
  p3
  def test_00040_add_chinese_attachments
    # go to a specific topic
    @topicdetail_page.topic_detail("A Watir Topic")
    @topicdetail_page.choose_post_type("blog")

    # create a new blog
    @topicdetail_page.goto_conversation_create_page(:blog)
    @browser.wait_until { @conversation_create_page.title_field.present? }

    @conversation_create_page.select_type(:blog)
    @conversation_create_page.title_field.set("Test q created by Watir - #{get_timestamp}")
    @conversation_create_page.set_details([{type: :text, content: "Watir test description"}])

    # upload an attachment
    file_name = "中文文件.png"
    @conversation_create_page.upload_attachment(File.join(@test_data_dir, file_name))

    # submit
    @conversation_create_page.submit(:blog)
    @browser.wait_until { @convdetail_page.conv_content.present? }
    @browser.refresh # sometimes, the attachments panel is not visible unless refresh which cannot be reproduced manually
    @browser.wait_until { @convdetail_page.attachments_panel.attachments.size > 0 }

    # verify the attachments displayed correctly in conversation details page
    assert @convdetail_page.attachments_panel.attachments.size == 1, "Number of attachments is not 1"
    assert @convdetail_page.attachments_panel.label_count == 1, "Number of attachments is not 1"
    assert @convdetail_page.attachments_panel.attachments[0].name == file_name, "Attachment name is incorrect"

    # download the attachment
    file_entries_before_download = Dir.entries(@config.download_dir)

    @convdetail_page.attachments_panel.attachments[0].download

    downloaded_file = wait_file_download(@config.download_dir, file_entries_before_download, "中文文件", wait_time=30)

    assert !downloaded_file.nil?, "Cannot find the file downloaded"
    File.delete(downloaded_file)

    # edit the question
    @convdetail_page.goto_edit_page

    # rename the attachment
    new_attachment_name = "中文文件-rename.png"

    @conversation_edit_page.scroll_to_element @conversation_edit_page.attachments_panel.attachments[0].actions_arrow
    @browser.execute_script("window.scrollBy(0,-500)")
    @conversation_edit_page.attachments_panel.attachments[0].rename(new_attachment_name)

    assert @conversation_edit_page.attachments_panel.attachments[0].name == new_attachment_name, "New attachment name is incorrect"

    # submit
    @conversation_edit_page.submit(:blog)
    #@browser.wait_until { @convdetail_page.conv_content.present? }
    @browser.refresh
    @browser.wait_until { @convdetail_page.attachments_panel.attachments.size > 0 }

    assert @convdetail_page.attachments_panel.attachments[0].name == new_attachment_name, "New attachment name is incorrect"

    @convdetail_page.delete_conversation
  end 

  # =============== Test Case 5 ===============
  # Summary: [Permission] Anonymous user can only download the attachment
  # Steps:
  # 1. Admin create a question;
  # 2. Admin upload an attachment;
  # 3. Admin sign out;
  # 4. Anonymous user go to the question;
  # 5. Anonymous download the attachment.

  # =============== Test Case 6 ===============
  # Summary: [Permission] Moderator user can create/rename/download/delete attachment
  # Steps:
  # 1. Moderator create a question;
  # 2. Moderator upload an attachment;
  # 3. Moderator edit the question;
  # 4. Moderator rename the attachment;
  # 5. Moderator save the question;
  # 6. Moderator edit the question and delete the attachment, Save the question.

  # =============== Test Case 7 ===============
  # Summary: [Permission] Blogger user can create/rename/download/delete attachment
  # Steps:
  # 1. Blogger create a question;
  # 2. Blogger upload an attachment;
  # 3. Blogger edit the question;
  # 4. Blogger rename the attachment;
  # 5. Blogger save the question;
  # 6. Blogger edit the question and delete the attachment, Save the question.

  # =============== Test Case 8 ===============
  # Summary: [Permission] Blogger user can create/rename/download/delete attachment
  # Steps:
  # 1. Blogger create a question;
  # 2. Blogger upload an attachment;
  # 3. Blogger edit the question;
  # 4. Blogger rename the attachment;
  # 5. Blogger save the question;
  # 6. Blogger edit the question and delete the attachment, Save the question.

  # =============== Test Case 9 ===============
  # Summary: [Permission] Only the owner of the conversation can add attachment in it
  # Steps:

  # =============== Test Case 10 ===============
  # Summary: [Permission] Topic admin can create/rename/download/delete attachment
  # Steps:

  # =============== Test Case 11 ===============
  # Summary: [Permission] Topic moderator can create/rename/download/delete attachment
  # Steps:

  # =============== Test Case 12 ===============
  # Summary: [Permission] Topic blogger can create/rename/download/delete attachment
  # Steps:
end