require 'test/unit'
require 'rubygems'
require 'Shoulda'
require 'flexmock/test_unit'

require File.dirname(__FILE__) << "/../lib/brigit"


class Test::Unit::TestCase
  
  def mock_gitosis!
    flexmock(Brigit::Profile).new_instances do |mock|
      mock.should_receive(:path_for).and_return(File.dirname(__FILE__) << "/fixtures/gitosis-admin")
    end
    flexmock(Brigit::GitosisAdmin).new_instances do |mock|
      mock.should_receive(:update).and_return(true)
    end
  end
  
end