require File.dirname(__FILE__) << "/test_helper"

class ConfigParserTest < Test::Unit::TestCase
  
  attr_reader :results
  
  context "ConfigParser" do
    setup do
      @results = parser.parse(File.read(File.dirname(__FILE__) << "/fixtures/example.conf"))
    end
    should "find correct number of sections" do
      assert_equal %w(section1 section2 section3 section4), results.keys.sort
    end
    should "find options" do
      counts = { 1 => 0, 2 => 2, 3 => 2, 4 => 0}
      counts.each do |i, count|
        assert_equal count, results["section#{i}"].size
      end
    end
    should "ignore comments" do
      assert_equal %w(
                 lib/ham
                 spam/eggs
                 foo/a
                 foo/b
                 foo/c
                 foo/lib/bar
                 foo/lib/baz
                 foo/lib/quux
                 foo/doc/design), results["section3"]['items'].scan(/(\S+)/).flatten
    end
  end
  
  #######
  private
  #######

  def parser
    @parser ||= Brigit::ConfigParser.new
  end
  
end