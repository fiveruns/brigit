require File.dirname(__FILE__) << "/test_helper"
require 'stringio'

class CLITest < Test::Unit::TestCase
  
  class AbortedException; end

  context "Brigit::CLI" do
    
    setup do 
      mock_streams!
    end
    
    teardown do
      restore_streams!
    end

    should "parse valid command" do
      parsing %w(hop) do |command, args|
        assert_kind_of Brigit::HopCommand, command
        assert command.args.empty?
      end
    end
    
    should "not parse invalid command" do
      assert_raises SystemExit do
        parse %w(this-does-not-exist)
      end
      assert !stream_output.empty?
    end
    
    should "have banner with version number" do
      assert Brigit::CLI.banner.include?(Brigit::Version::STRING)
    end
    
  end
  
  #######
  private
  #######

  def parsing(args)
    yield(Brigit::CLI.new.parse(*args), args)
  end
  alias :parse :parsing

end