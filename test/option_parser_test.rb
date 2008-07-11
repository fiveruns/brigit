require File.dirname(__FILE__) << "/test_helper"

class OptionParserExtensionTest < Test::Unit::TestCase

  context "OptionParserExtension" do
    
    context "separator" do
      setup do
        @separator = "foo\nbar\nbaz"
        @opts = OptionParser.new do |opts|
          opts.separator @separator
        end
      end
      should "have not double newlines on assignment" do
        assert @opts.to_s.include?(@separator)
      end
    end

  end

end