require 'actions'
	
class Actions::Base

	def initialize(config)
		@c = @config = config
		@browser = @c.browser
	end

  def establish_session(user)
    @config.api.establish_session(user)
  end
end
