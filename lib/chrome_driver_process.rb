# A helper class to automatically manage the chromedriver processe(s) needed
# when the suite is started. The client no longer needs to pass the port number
# and manage the port numbers across several build jobs.
require 'open3'

class ChromeDriverProcess
  @@port_range = 9812..9899  
  @@current_pids = []
  @@current_port = nil

  def self.pid_alive?(pid)
    !!Process.kill(0, pid) rescue false
  end

  class << self 
    def start
      port = @@current_port = find_available_port
      chromedriver_command = "chromedriver --port=#{port} --log-path=#{log_path}"
      chromedriver_command << " --verbose" if ENV.has_key?("CHROMEDRIVER_VERBOSE_LOGGING")

      # http://ruby-doc.org/core-2.2.0/Process.html#method-c-spawn

      child_pid = Process.spawn(chromedriver_command)
      Process.detach(child_pid)

      raise "Failed to start chromedriver" unless ChromeDriverProcess.pid_alive?(child_pid)

      @@current_pids << child_pid

      command = "nc -vz 127.0.0.1 #{port}"
      sleep 1 until Open3.capture2e(command).first.scan(/succeeded!|open/).any?
    end
    
    def log_path
      (ENV["USER"] == "jenkins") ? "#{ENV['HOME']}/workspace/#{ENV['JOB_NAME']}/chromedriver.log" : "/tmp/chromedriver.log"
    end

    def find_available_port
      used_ports = case RUBY_PLATFORM
        when /linux/
          (
            `ps aux | grep [c]hromedriver`.scan(/--port=(\d+)/).flatten.map(&:to_i) +
            `netstat -anp | grep LISTEN | cut -c 21-44 | cut -d: -f 2`.split.map(&:to_i)
          ).sort
        when /darwin/
          `ps aux | grep [c]hromedriver`.scan(/--port=(\d+)/).flatten.map(&:to_i)
      end

      available_ports = (@@port_range.to_a - used_ports)

      raise "no available ports left" if available_ports.empty?

      return available_ports.sample
    end

    def current_pids
      @@current_pids
    end

    def exit

      # http://ruby-doc.org/core-2.2.0/Process.html#method-c-spawn
      # try a graceful TERM before KILL
      puts `ps aux | grep [c]hromedriver`
      puts current_pids.inspect
      current_pids.each do |pid|
        puts "Attempting to terminate: #{pid}, on port #{current_port}"
        Process.kill("TERM", pid) || Process.kill("KILL", pid)
        Process.detach(pid)
      end
    end

    def current_port
      @@current_port
    end

    def remote_url
      "http://localhost:#{current_port}"
    end
  end
end
