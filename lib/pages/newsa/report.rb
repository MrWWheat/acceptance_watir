require 'pages/newsa/newsa'

class Pages::NewSuperAdmin::Report < Pages::NewSuperAdmin
  newsa_report_export_btn             { link(:css => ".report-table-header a.btn-primary") }
  newsa_report_request_btn            { button(:text => "Request Report") }

  newsa_report_month_picker_label     { div(:css => ".month-picker .month-picker-wrapper") }

  def date_picker
    DatePicker.new(@browser, ".month-picker .month-picker-wrapper .date-popover")
  end 

  def report_table
    ReportTable.new(@browser, ".table tbody")
  end  

  def request_report(year, month)
    newsa_report_month_picker_label.when_present.click
    @browser.wait_until { date_picker.present? }
    date_picker.select_year(year)
    date_picker.select_month(month)
    sleep 0.5

    newsa_report_request_btn.when_present.click
    @browser.wait_until { !newsa_loading_spinner.present? }
  end

  def export_report
    newsa_report_export_btn.when_present.click
  end  

  class DatePicker
    def initialize(browser, parent_css)
      @browser = browser
      @parent_css = parent_css
    end

    def present?
      @browser.div(:css => @parent_css).present?
    end  
    
    def prev_btn
      @browser.element(:css => @parent_css + " .flexbox .prev")
    end  

    def next_btn
      @browser.element(:css => @parent_css + " .flexbox .next")
    end 

    def year_label
      @browser.div(:css => @parent_css + " .flexbox div")
    end 

    def current_year
      year_label.when_present.text.to_i
    end  

    def select_year(year)
      old_year = current_year
      expected_year = year.to_i
      if expected_year < old_year
        (old_year - expected_year).times do |i|
          prev_btn.when_present.click 
          @browser.wait_until { (old_year - current_year) == 1 }
        end  
      else
        (expected_year - old_year).times do |i|
          next_btn.when_present.click 
          @browser.wait_until { (current_year - old_year) == 1 }
        end 
      end 

      @browser.wait_until { current_year == expected_year } 
    end  

    def select_month(month)
      @browser.div(:css => @parent_css + " .flexbox.monthItem").div(:text => month).when_present.click
    end  
  end 

  class ReportTable
    def initialize(browser, parent_css)
      @browser = browser
      @parent_css = parent_css # .table tbody
    end  

    def rows
      result = []

      @browser.trs(:css => @parent_css + " tr").each_with_index do |item, index|
        result << ReportRow.new(@browser, @parent_css + " tr:nth-child(#{index+1})")
      end 

      result
    end 

    class ReportRow
      def initialize(browser, parent_css)
        @browser = browser
        @parent_css = parent_css # .table tbody tr:nth-child(1)
      end  

      def jcom_id
        @browser.td(:css => @parent_css + " td:nth-child(1)").when_present.text
      end 

      def name 
        @browser.td(:css => @parent_css + " td:nth-child(2)").when_present.text
      end
      
      def page_view
        @browser.td(:css => @parent_css + " td:nth-child(3)").when_present.text
      end
      
      def disk_usage
        @browser.td(:css => @parent_css + " td:nth-child(4)").when_present.text
      end  
    end  
  end
end  