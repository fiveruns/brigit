require File.dirname(__FILE__) << "/test_helper"

class CommandTest < Test::Unit::TestCase

  context "Command" do
    
    setup do
      @klass = Class.new(Brigit::Command) do
        def self.to_s
          'TestCommand'
        end
        def run
          say 'foo'
        end
      end
    end
    
    context "name class method" do
      should "return downcased version of class name" do
        assert_equal 'test', @klass.name
      end
    end
    
    context "say instance method" do
      setup do
        mock_stderr!
      end
      teardown do
        restore_stderr!
      end
      should "output message" do
        @klass.new.run
        assert stderr_output.include?('foo')        
        assert !stderr_output.include?('PRETEND')        
      end
      should "mention pretending if doing so" do
        instance = @klass.new
        instance.pretend!
        instance.run
        assert stderr_output.include?('foo')
        assert stderr_output.include?('PRETEND')
      end
    end
    
  end

end