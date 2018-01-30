require File.expand_path(File.dirname(__FILE__) + "/excelsior_watir_test.rb")
require File.expand_path(File.dirname(__FILE__) + "/../lib/test_helper.rb")
require File.expand_path(File.dirname(__FILE__) + "/workflow/p1workflow.rb")


class P1Test < ExcelsiorWatirTest
	include P1workflow
end
