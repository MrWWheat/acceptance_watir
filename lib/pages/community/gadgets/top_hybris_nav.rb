require 'pages/community/gadgets/base'

class Gadgets::Community::TopHybrisNavigator < Gadgets::Base
  def initialize(config)
    super(config, ".gadget-main-menu.gadget-hybris-menu")

    # @slug = @config.slug
  end
end