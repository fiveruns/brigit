require File.dirname(__FILE__) << "/test_helper"
require 'stringio'

class CLITest < Test::Unit::TestCase
  
  class AbortedException; end

  context "Brigit::CLI" do
    
    setup do 
      @old_stderr = $stderr
      $stderr = StringIO.new
    end
    
    teardown do
      $stderr = @old_stderr
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
      assert !abort_message.empty?
    end
    
    should "have banner with version number" do
      assert Brigit::CLI.banner.include?(Brigit::Version::STRING)
    end
    
  end
  
  #######
  private
  #######
  
  def abort_message
    $stderr.rewind
    $stderr.read
  end

  def parsing(args)
    yield(Brigit::CLI.new.parse(*args), args)
  end
  alias :parse :parsing

end