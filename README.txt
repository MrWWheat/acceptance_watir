Watir Tests
===========

Preparation
-----------
bundle install - Assuming you use rvm, this will install into a gemset "watir".
Please see .ruby-gemset file.

Run Tests
---------
rake 'watir:test[instance,slug,browser]' - This will run all tests.
e.g. rake 'watir:test[stage,nike,chrome]'
rake 'watir:test[instance,slug,browser]' TEST="filename" - this will run one test file.
e.g. rake 'watir:test[stage,nike,chrome]' TEST="test/page/about_test.rb"
TESTOPTS=someopts can also be passed to rake test. This can contain
ruby options. If omitted, the -v option is passed in for a verbose listing.

You can also run one test file at a time using testrb or ruby command.

Guidelines for writing tests
----------------------------
Create test files. One file per web page or feature. More the better.
Test file names should end in _test.rb.

Put common code into test/test_helper2.rb or include a file in test/test_helper2.rb.

Please see test/page/XXX_test.rb for reference.

Since it is usually required to run tests in a fixed sequence,
tests are run in name order, sorted ascending alphabetically. 
The test names have numbers so they run in number order.

Leave gaps in the test numbers to allow inserting tests. 
Also notice the 000 before the number -- sorting is
alphabetical, not numeric. The maximum test number can be 99999
in each file. Numbers can repeat across files.

Please resist putting all your tests into one file. One file per test
suite is fine. You may need to use the setup method in your file.
For example, if you need testA and testB from another file to
run before the first test in a new file, just paste the content of testA and
testB as methods in the new file (without asserts) and call them from
setup method in the example.
