require File.expand_path(File.dirname(__FILE__) + "/excelsior_watir_test.rb")
require File.expand_path(File.dirname(__FILE__) + "/../lib/test_helper.rb")
require File.expand_path(File.dirname(__FILE__) + "/../lib/watir_lib.rb")

class PageLoadPerformanceTest < ExcelsiorWatirTest
  include WatirLib
  PERF_CSV_FILE = File.expand_path(File.dirname(__FILE__) + "/../page_load_performance.csv")

  File.open(PERF_CSV_FILE, "w") do |csv|
    csv.puts("Topics List, Home, Single Topic, Conversation Detail")
    csv.puts("0.0, 0.0, 0.0, 0.0")
  end

  def setup
    super
    @count = 3 # number of repeat loads
    @sum = 0.0
  end

  def test_0010_topics_page_perf
    max_time = 10.0
    run_page_load_test(page_name: "Topics", max_time: max_time) { main_landing("visitor", "anon") }
    update_csv(0, total_time)
    assert_operator total_time, :<, max_time, "Topics page load time exceeds limit"
  end

  def test_0020_home_page_perf
    max_time = 12.0
    run_page_load_test(page_name: "Home", max_time: max_time) do
      home_url = "#{$base_url}/n/#{$networkslug}/home"
      @browser.goto home_url
      topic_tiles = @browser.div(class: /topic-avatar/)
      unless topic_tiles.present?
        @browser.wait_until {topic_tiles.present? }
      end
      # These elements are below the fold, so only check if they exist
      blogs = @browser.div(class: /featured_blog_posts/).div(class: /preview/)
      unless blogs.exists?
        @browser.wait_until { blogs.exists? }
      end
      questions = @browser.div(class: /featured_questions/).div(class: /preview/)
      unless questions.exists?
        @browser.wait_until { questions.exists? }
      end
      discussions = @browser.div(class: /featured_discussions/).div(class: /preview/)
      unless discussions.exists?
        @browser.wait_until { discussions.exists? }
      end
      open_questions = @browser.div(class: /home_open_questions/).div(class: /preview/)
      unless open_questions.exists?
        @browser.wait_until { open_questions.exists? }
      end
    end
    update_csv(1, total_time)
    assert_operator total_time, :<, max_time, "Home page load time exceeds limit"
  end

  def test_0030_single_topic_perf
    max_time = 10.0
    topic_url = nil
    run_page_load_test(page_name: "Topic", max_time: max_time) do
      if topic_url
        @browser.goto topic_url
      else
        main_landing("visitor", "anon")
        topic_detail("A Watir Topic")
        topic_url = @browser.url
      end
      recent_blogs = @browser.element(text: /Most Recent Blogs/)
      unless recent_blogs.exists?
        @browser.wait_until {recent_blogs.exists?}
      end
      # Get the parent element of h7 with text 'Most Recent Discussions'
      recent_discussions = @browser.element(xpath: "//h7[text()='Most Recent Discussions']/..")
      unless recent_discussions.present?
        @browser.wait_until {recent_discussions.present?}
      end
      discussion = recent_discussions.div(class: /post-body/)
      unless discussion.present?
        @browser.wait_until { discussion.present? }
      end
    end
    update_csv(2, total_time)
    assert_operator total_time, :<, max_time, "Topic page load time exceeds limit"
  end

  def test_0040_conversation_page_perf
    max_time = 12.0
    conversation_url = nil
    run_page_load_test(page_name: "Conversation", max_time: max_time) do
      if conversation_url
        @browser.goto conversation_url
      else
        $topic_uuid = nil
        main_landing("visitor", "anon")
        topic_detail("A Watir Topic")
        choose_post_type("question")
        question_in_list = @browser.div(class: /post-collection/).div(class: /post-body/)
        unless question_in_list.present?
          @browser.wait_until { question_in_list.present? }
        end
        title = "Watir Test Question1"
        conversation = @browser.link(:text => /#{title}/)
        unless conversation.present?
          @browser.execute_script("window.scrollBy(0,300)")
        end
        unless conversation.present?
          sort_by_old_in_conversation_list
        end
        unless conversation.present?
          @browser.execute_script("window.scrollBy(0,300)")
        end
        unless conversation.present?
          @browser.wait_until($t) { conversation.present? }
        end
        title = conversation.text # Change to the exact title with timestamp
        conversation_detail("question", title)
        conversation_url = @browser.url
      end
      more_link = @browser.div(class: /more-button/)
      content = @browser.div(class: /col-lg-8/).div(class: /post-content/, text: /Watir test answer1/)
      unless content.present?
        @browser.wait_until { content.present? }
      end
    end
    update_csv(3, total_time)
    assert_operator total_time, :<, max_time, "Conversation page load time exceeds limit"
  end

  def run_page_load_test(page_name:, max_time:, &load_page)
    load_page.call # skip initial load as it takes more time
    ember_page_load_time = 0
    url_load_time = 0
    dom_complete_time = 0
    content_loaded_time = 0
    @count.times do
      load_page.call
      load_secs = @browser.performance.summary[:response_time]/1000.0
      @sum += load_secs
      ember_page_load_time += get_ember_page_load_time
      url_load_time += @browser.performance.timing[:response_end] - @browser.performance.timing[:request_start]
      dom_complete_time += @browser.performance.timing[:dom_complete] - @browser.performance.timing[:response_end]
      content_loaded_time += @browser.performance.timing[:dom_content_loaded_event_end] - @browser.performance.timing[:response_end]
    end
    @load_average = @sum/@count
    @ember_page_load_average = ember_page_load_time/@count
    puts "Average load time for #{page_name} page = #{@load_average} seconds."
    puts "Average Ember page load time for #{page_name} page = #{@ember_page_load_average}."
    puts "Total #{@load_average+@ember_page_load_average}. Expected: #{max_time} seconds or less."
    # puts "URL Load time: " + (url_load_time/(@count * 1000.0)).to_s
    # puts "DOM Complete time: " + (dom_complete_time/(@count * 1000.0)).to_s
    # puts "Content Loaded time: " + (content_loaded_time/(@count * 1000.0)).to_s
  end

  def get_ember_page_load_time
    measures = @browser.execute_script("return window.performance.getEntriesByType('measure')")
    #puts "Measures: " + measures.inspect
    measure = measures.detect {|m| m["name"] == "emberPageLoadTime"}
    if measure
      measure["duration"].to_f/1000.0
    else
      0.0
    end
  end

  def total_time
    @load_average + @ember_page_load_average
  end

  def update_csv(offset, value)
    lines = File.readlines(PERF_CSV_FILE)
    File.open(PERF_CSV_FILE, "w") do |csv|
      csv.puts lines[0]
      values = lines[1].split(",")
      values[offset] = value.to_s
      csv.puts values.join(",") # update second line
    end
  end

end
