require 'watir_test'
require 'pages/community/admin_reports'
require 'date'
require 'pages/community/conversationdetail'
require 'pages/community/topicdetail'
require 'pages/community/idea_detail'

class AdminReportsTest < WatirTest

  def setup
    super
    @admin_reports_page = Pages::Community::AdminReports.new(@config)
    @convdetail_page = Pages::Community::ConversationDetail.new(@config)
    @topicdetail_page = Pages::Community::TopicDetail.new(@config)
    @ideadetail_page = Pages::Community::IdeaDetail.new(@config)

    @current_date = Time.now.strftime("%Y-%m-%d")
    # assigning @current_page helps error reporting
    #  give good contextual data
    @current_page = @admin_reports_page
    puts "[[[ #{name} ::: #{user_for_test} ]]]" if @config.verbose?
    @browser = @config.browser
    @admin_reports_page.start!(user_for_test)
  end

  def teardown
    super
  end

  user :network_admin
  p1
  def test_00010_export_key_charts_page_views_report
    export_and_verify_pv_histogram_report(:daily) do |pageviews_report, page_views, dates|
      assert_all_keys({
      :period_size_csv => dates.size == 20,
      :start_date_csv => dates[0] == (Date.today - 19).to_s,
      :start_date_ui => pageviews_report.start_date == dates[0],
      :end_date_csv => dates[19] == @current_date,
      :end_date_ui => pageviews_report.end_date == @current_date,
      :page_views => page_views >= pageviews_report.total_page_views.to_i, # page view might be increased after access report and before export
      })
    end

    export_and_verify_pv_histogram_report(:weekly) do |pageviews_report, page_views, dates|
      assert_all_keys({
      :period_size_csv => dates.size == 5,
      :end_date_ui => pageviews_report.end_date == @current_date,
      :page_views => page_views >= pageviews_report.total_page_views.to_i,
      })
    end

    export_and_verify_pv_histogram_report(:monthly) do |pageviews_report, page_views, dates|
      assert_all_keys({
      :period_size_csv => dates.size == 12,
      :end_date_ui => pageviews_report.end_date == @current_date,
      :page_views => page_views >= pageviews_report.total_page_views.to_i,
      :page_views_nonzero => page_views > 0
      })
    end

    export_and_verify_pv_histogram_report(:yearly) do |pageviews_report, page_views, dates|
      assert_all_keys({
      :period_size_csv => dates.size > 0,
      :end_date_ui => pageviews_report.end_date == @current_date,
      :page_views => page_views >= pageviews_report.total_page_views.to_i,
      :page_views_nonzero => page_views > 0
      })
    end
  end

  def test_00020_export_last7days_popular_content_report
    export_and_verify_popular_pv_report(:last_7_days, :conversation) 

    export_and_verify_popular_pv_report(:last_7_days, :topic)

    unless beta_feature_enabled? "fs_ideas"
      report_page = @admin_reports_page.switch_to_tab("Key Charts", "Popular Content", "Last 7 Days")
      assert !report_page.piechart(:idea).present?
      return 
    end 

    export_and_verify_popular_pv_report(:last_7_days, :idea)
  end

  def test_00030_export_last30days_popular_content_report
    export_and_verify_popular_pv_report(:last_30_days, :conversation)
    export_and_verify_popular_pv_report(:last_30_days, :topic)

    unless beta_feature_enabled? "fs_ideas"
      report_page = @admin_reports_page.switch_to_tab("Key Charts", "Popular Content", "Last 30 Days")
      assert !report_page.piechart(:idea).present?
      return 
    end

    export_and_verify_popular_pv_report(:last_30_days, :idea)
  end

  def test_00040_export_traffic_returning_users_report
    export_and_verify_report("Traffic", "Returning Users", "Daily", "daily_returning_users_count")
    export_and_verify_report("Traffic", "Returning Users", "Weekly", "weekly_returning_users_count")
    export_and_verify_report("Traffic", "Returning Users", "Monthly", "monthly_returning_users_count")
    export_and_verify_report("Traffic", "Returning Users", "Yearly", "yearly_returning_users_count")
  end

  def test_00050_export_busi_value_comm_cta_report
    export_and_verify_report("Business Value", "Community CTA", "Weekly", "weekly_cta_count") do |downloaded_file, report_page|
      # ctas = 0
      # File.open(downloaded_file).read.each_line.with_index do |line, index|
      #   next if index == 0
      #   ctas += line.split(',')[1].match(/\d*/)[0].to_i
      # end

      # assert ctas > 0 # no data in some environments
      # assert report_page.end_date == @current_date
    end 

    export_and_verify_report("Business Value", "Community CTA", "Monthly", "monthly_cta_count") 
  end  

  def test_00060_export_busi_value_hybris_cta_report
    export_and_verify_report("Business Value", "Hybris CTA", "Weekly", "weekly_hybris_cta_count")

    export_and_verify_report("Business Value", "Hybris CTA", "Monthly", "monthly_hybris_cta_count")
  end 

  p2
  def test_00070_check_liveliness_ui
    @admin_reports_page.liveliness.click
    @browser.wait_until { @admin_reports_page.liveliness_table.present? }
    assert @admin_reports_page.liveliness_table.present?
  end

  p1
  def test_00080_export_liveliness_report
    export_and_verify_report("Liveliness", nil, nil, "new_posts_across_all_topics", nil, false)
  end 

  def test_00090_export_members_new_registered_users_report
    export_and_verify_report("Members", "New Registered Users", "Daily", "daily_registered_user_count")
    export_and_verify_report("Members", "New Registered Users", "Weekly", "weekly_registered_user_count")
    export_and_verify_report("Members", "New Registered Users", "Monthly", "monthly_registered_user_count")
    export_and_verify_report("Members", "New Registered Users", "Yearly", "yearly_registered_user_count")
  end 
  
  def test_00100_export_members_posts_growth_report
    export_and_verify_report("Members", "Posts Growth", "Weekly", "weekly_new_registered_users_post_count")
    export_and_verify_report("Members", "Posts Growth", "Monthly", "monthly_new_registered_users_post_count")
    export_and_verify_report("Members", "Posts Growth", "Yearly", "yearly_new_registered_users_post_count")
  end 

  def test_00110_export_interaction_topics_report
    export_and_verify_report("Interaction", "Topics", nil, "unique_participants_per_topic", :histogram, false)
  end 

  def test_00120_export_interaction_ideas_report
    unless beta_feature_enabled? "fs_ideas"
      report_page = @admin_reports_page.switch_to_tab("Interaction")
      assert @admin_reports_page.report_sub_navigator("Interaction").tab_at_name("Ideas & Votes", false).nil?
      return 
    end 

    export_and_verify_report("Interaction", "Ideas & Votes", "Daily", "daily_idea_vote_count")
    export_and_verify_report("Interaction", "Ideas & Votes", "Weekly", "weekly_idea_vote_count")
    export_and_verify_report("Interaction", "Ideas & Votes", "Monthly", "monthly_idea_vote_count")
    export_and_verify_report("Interaction", "Ideas & Votes", "Yearly", "yearly_idea_vote_count")
  end 

  def export_and_verify_pv_histogram_report(date_period)
    case date_period
    when :daily 
      threelayertab_name = "Daily"
    when :weekly
      threelayertab_name = "Weekly"
    when :monthly 
      threelayertab_name = "Monthly"
    when :yearly
      threelayertab_name = "Yearly"
    end  
    file_entries_before_download = Dir.entries(@config.download_dir)

    @admin_reports_page.export("Key Charts", "Page Views", threelayertab_name)
    # current_date = Time.now.strftime("%Y-%m-%d")
    downloaded_file = wait_file_download(@config.download_dir, file_entries_before_download, "#{@c.slug}_#{date_period.to_s}_page_view_count_#{@current_date}", wait_time=30)
    assert !downloaded_file.nil?, "Cannot find the file downloaded"

    pageviews_report = @admin_reports_page.report_page("Key Charts", "Page Views", threelayertab_name)

    assert pageviews_report.chart.present?

    page_views = 0
    dates = []
    File.open(downloaded_file).read.each_line.with_index do |line, index|
      next if index == 0
      page_views += line.split(',')[1].match(/\d*/)[0].to_i
      dates << line.split(',')[0]
    end

    if block_given?
        yield(pageviews_report, page_views, dates, @current_date) # for verification purpose
    end
  ensure 
    File.delete(downloaded_file) unless downloaded_file.nil?
  end 

  def export_and_verify_popular_pv_report(date_period, content_type)
    group_name = "Key Charts"
    subtab_name = "Popular Content"
    threelayertab_name = (date_period == :last_7_days) ? "Last 7 Days" : "Last 30 Days"
    date = Time.now.strftime("%Y-%m-%d")
    download_filepartname = (date_period == :last_7_days) ? "#{@c.slug}_popular_#{content_type.to_s}s_last7_days_#{date}" : "#{@c.slug}_popular_#{content_type.to_s}s_last30_days_#{date}"
    # export report
    file_entries_before_download = Dir.entries(@config.download_dir)
    piechart = @admin_reports_page.export_pageviews_piechart(group_name, subtab_name, threelayertab_name, content_type)
    downloaded_file = wait_file_download(@config.download_dir, file_entries_before_download, download_filepartname, wait_time=30)
    assert !downloaded_file.nil?, "Cannot find the file downloaded"

    unless piechart.empty?
      verify_exported_pv_piechart_csv(downloaded_file, piechart)

      old_first_page_views = piechart.first_content_views.to_i

      # go to the first link
      first_content_title =  piechart.first_content_title
      piechart.goto_first_content

      # verify the content is opened correctly
      case content_type
      when :conversation
        assert @convdetail_page.conv_title.when_present.text == first_content_title, "conv title #{@convdetail_page.conv_title.when_present.text} doesn't match #{first_content_title}"
      when :topic
        assert @topicdetail_page.topic_title.when_present.text == first_content_title
      when :idea
        assert @ideadetail_page.idea_title.when_present.text == first_content_title
      end  

      @browser.wait_until { !@convdetail_page.layout_loading_spinner.present? }
      sleep 1 # page view won't increase sometimes for latency

      # go back to admin->report to verify page views updated
      @admin_reports_page.navigate_in
      start_time = Time.now
      loop do
        @admin_reports_page.switch_to_tab(group_name, subtab_name, threelayertab_name)
        break if Time.now > (start_time + 2*60) or piechart.first_content_views.to_i > old_first_page_views
        @browser.refresh
      end  

      # verify the new page views is increased
      assert piechart.first_content_views.to_i > old_first_page_views, "Page views #{old_first_page_views} not increased after 2 minutes"
    end  
  ensure 
    File.delete(downloaded_file) unless downloaded_file.nil?
  end  

  def verify_exported_pv_piechart_csv(downloaded_file, piechart)
    page_views = 0
    File.open(downloaded_file).read.each_line.with_index do |line, index|
      next if index == 0 # skip header
      page_views += line.gsub(/\".*\"/, '').split(',')[2].match(/\d*/)[0].to_i # name might include semi-colon
    end

    assert_all_keys({
      :page_views => page_views >= piechart.total_page_views.to_i, # page view might be increased after access report and before export
      :page_views_nonzero => page_views > 0
      })
  end 

  def export_and_verify_report(group_name, subtab_name, threelayertab_name, download_filepartname, verify_chart_type=:histogram, verify_end_date_uptodate=true) 
    file_entries_before_download = Dir.entries(@config.download_dir)
    report_page = @admin_reports_page.export(group_name, subtab_name, threelayertab_name)
    downloaded_file = wait_file_download(@config.download_dir, file_entries_before_download, "#{@c.slug}_#{download_filepartname}_#{@current_date}", wait_time=30)
    assert !downloaded_file.nil?, "Cannot find the file downloaded"

    case verify_chart_type
    when :histogram
      assert report_page.chart.present?
    when :pie
      assert report_page.piechart.present?
    end  

    if block_given?
        yield(downloaded_file, report_page) # for verification purpose
    end

    assert report_page.end_date == @current_date if verify_end_date_uptodate # assert only when necessary
  ensure 
    File.delete(downloaded_file) unless downloaded_file.nil?  
  end 
end