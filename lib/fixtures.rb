module Fixtures
  def self.load(base_url = $base_url)
    url = [base_url, "watir/fixtures"].join("/")
    @@fixtures ||= HTTParty.get(url)
   # puts @@fixtures

    class << @@fixtures
      # My dig implementation
      def dig(*args)
        rv = true
        h = self

        while args.length > 0
          arg = args.shift
          rv = rv && h[arg]
          break unless rv
          h = h[arg]
        end
        h if rv
      end
    end
  end

  def self.find(*args)
    args = args.map(&:to_s)
    
    @@fixtures || load
    rv = @@fixtures.dig(*args)
    OpenStruct.new(rv)
  end
end