require File.dirname(__FILE__) << "/test_helper"


class FallibleTest < Test::Unit::TestCase

  context "Fallible" do
    
    setup do 
      @klass = Class.new
      @klass.send(:include, Brigit::Fallible)
      mock_stderr!
    end
    
    teardown do
      restore_stderr!
    end
    
    context "fail method" do
      setup do
        @failed = "you totally failed"
      end
      should "output CLI banner and message" do
        assert_raises SystemExit do
          @klass.new.fail @failed
          assert stderr_output.include?(Brigit::CLI.banner)
          assert stderr_output.include?(@failed)
        end
      end
    end

  end

end