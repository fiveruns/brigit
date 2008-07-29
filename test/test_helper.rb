require 'test/unit'
require 'rubygems'
require 'Shoulda'
require 'flexmock/test_unit'

require File.dirname(__FILE__) << "/../lib/brigit"

class Test::Unit::TestCase
  
  def gitify!(location, origin = nil)
    Dir.chdir location do
      `git init; git add .; git commit -a -m 'For test'`
      if origin
        `git remote add origin '#{origin}'`
      end
    end
  end
  
  def degitify!(location)
    FileUtils.rm_rf File.join(location, '.git') rescue nil
  end
  
  def mock_streams!
    @old_output = $terminal.instance_variable_get(:@output)
    $terminal.instance_variable_set(:@output, StringIO.new)
    @old_stderr = $stderr
    $stderr = StringIO.new
  end
  
  def restore_streams!
    $terminal.instance_variable_set(:@output, @old_output)
    $stderr = @old_stderr
  end
  
  def stream_output
    output = $terminal.instance_variable_get(:@output)
    output.rewind
    $stderr.rewind
    output.read << $stderr.read
  end
  
end