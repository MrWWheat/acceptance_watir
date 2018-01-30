require 'actions/base'
require 'pages/hybris/home'
require 'pages/hybris/detail'
require 'pages/hybris/list'
# require 'pages/hybris/layout'

# require 'pages/community/layout'
require 'pages/community/conversationdetail'
require 'pages/community/profile'
require 'pages/community/settings'
require 'pages/community/admin'
require 'pages/community/login'
require 'actions/hybris/api'

class Actions::Common < Actions::Base

	def initialize(config)
		super(config)
		@hybris_layout_page = Pages::Hybris::Layout.new(@config)
		@hybris_detail_page = Pages::Hybris::Detail.new(@config)
		@hybris_list_page = Pages::Hybris::List.new(@config)
		@hybris_login_page = Pages::Hybris::Login.new(@config)

		@community_layout_page = Pages::Community::Layout.new(@config)
		@community_conversationdetail_page = Pages::Community::ConversationDetail.new(@config)
		@community_profile_page = Pages::Community::Profile.new(@config)
		@community_settings_page = Pages::Community::Settings.new(@config)
		@community_login_page = Pages::Community::Login.new(@config)
		@community_admin_page = Pages::Community::Admin.new(@config)

		@api_actions = Actions::Api.new(@config)
	end

	def search(keyword)
		@hybris_layout_page.search_box.set keyword
		@hybris_layout_page.search_btn.when_present.click
		@browser.wait_until { @hybris_list_page.first_product_item.present? }
	end

	def search_5_7(keyword)
		@hybris_layout_page.search_box.set keyword
		@hybris_layout_page.search_btn_5_7.when_present.click
		@browser.wait_until { @hybris_list_page.first_product_item_5_7.present? }
	end

	def go_to_product_detail(product_id)
		search(product_id)
		@hybris_list_page.first_product_item_link.when_present.click
		#@browser.wait_until(60) { @hybris_detail_page.most_recent_review.present? && @hybris_detail_page.most_recent_question.present? }
		@browser.wait_until(60) { @hybris_detail_page.most_recent_review.present? && !@hybris_detail_page.loading_spinner.exists? }
	end

	def go_to_product_detail_5_7(product_id)
		search_5_7(product_id)
		@hybris_list_page.first_product_item_link_5_7.when_present.click
		#@browser.wait_until(60) { @hybris_detail_page.most_recent_review.present? && @hybris_detail_page.most_recent_question.present? }
		@browser.wait_until { @hybris_detail_page.most_recent_review.present? && !@hybris_detail_page.loading_spinner.exists? }
	end

	def write_review(type=:button, rating=5, title="title", desc="description", recommended=false)
		case type
		when :button
			@hybris_detail_page.nav_to_review_tab
			@hybris_detail_page.write_review_btn.when_present.click
		when :link
			@hybris_detail_page.write_review_link.when_present.click
		when :be_first_reviewer
			@hybris_detail_page.to_be_first_review_link.when_present.click
		end

		@hybris_detail_page.create_review(rating:rating, title: title, desc:desc, recommended:recommended)

		@hybris_detail_page.get_review_uuid_by_title title
	end

	def ask_question(type=:button, title="title", desc="description")
		case type
		when :button
			@hybris_detail_page.nav_to_question_tab
			@hybris_detail_page.ask_question_btn.when_present.click
		when :link
			@hybris_detail_page.write_question_link.when_present.click
		when :be_first
			@hybris_detail_page.to_be_first_question_link.when_present.click
		end

		@hybris_detail_page.create_question(title: title, desc:desc)

	end

	def go_to_settings_page
		@browser.wait_until($t) {@community_conversationdetail_page.post_content.present?}
		@community_login_page.user_dropdown.when_present.click
		@community_login_page.dropdown_settings.when_present.click
		@community_login_page.accept_policy_warning # in case ui element overlapped by policy warning
	end

	def break_mapping
		go_to_settings_page
		@community_settings_page.break_mapping
		# @browser.wait_until($t)	{@community_profile_page.profile_edit_button.present?}
	end

	def go_to_admin_page
		@browser.wait_until($t) {@community_login_page.user_dropdown.present?}
		@community_login_page.user_dropdown.when_present.click
		@community_layout_page.dropdown_admin.when_present.click
		@browser.wait_until($t) {@community_admin_page.sidebar_present?}
	end

	def precondition_user_mapped(community_user)
		if !@hybris_detail_page.review_widget_empty?
			@hybris_detail_page.write_review_link.when_present.click

			if !@hybris_detail_page.has_login?
				@hybris_detail_page.login_community(community_user)
			end	

			@browser.wait_until($t) { @hybris_detail_page.review_cancel_btn.present? || 
									  @hybris_detail_page.prod_already_reviewed_dlg.present? }

			if @hybris_detail_page.review_cancel_btn.present?
				@hybris_detail_page.review_cancel_btn.when_present.click
			else
				# delete existing review and refresh web browser
				existing_review_id = @hybris_detail_page.get_review_uuid_from_prod_already_reviewed_dlg
				@api_actions.delete_review(@config.users[:network_admin], existing_review_id) if existing_review_id
				@browser.refresh
			end	
		elsif !@hybris_detail_page.question_widget_empty?
			@hybris_detail_page.write_question_link.when_present.click

			if !@hybris_detail_page.has_login?
				@hybris_detail_page.login_community(community_user)
			end

			@hybris_detail_page.question_cancel_btn.when_present.click
		else
		  puts "no existing reviews or questions for this product"
		  return
		end
	end
	
	def precondition_user_not_mapped
		if !@hybris_detail_page.review_widget_empty?
		  @hybris_detail_page.go_to_recent_review
		elsif !@hybris_detail_page.question_widget_empty?
		  @hybris_detail_page.go_to_recent_question
		else
		  puts "no existing reviews or questions for this product"
		  return
		end

		@browser.wait_until($t) { @community_conversationdetail_page.post_content.present? }

		if !@community_layout_page.login_link.present?
			break_mapping
		end	

		@browser.windows.last.close
		# Need to refresh hybris, otherwise authentication error happen
		@browser.refresh
	end	
end