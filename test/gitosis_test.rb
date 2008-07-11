require File.dirname(__FILE__) << "/test_helper"

class GitosisTest < Test::Unit::TestCase

  context "Gitosis" do

    setup do
      gitify!(location, url('gitosis-admin'))
      @gitosis = Brigit::GitosisInventory.new(location)
    end
    
    teardown do
      degitify!(location)
    end

    should "find all repos" do
      assert_equal 4, @gitosis.repositories.size
    end
    
    should "find correct URLs for repos" do
      @gitosis.repositories.each do |name, location|
        assert_equal url(name), location
      end
    end

  end
  
  #######
  private
  #######
  
  def url(name)
    "foo@foo.com:#{name}.git"
  end
  
  def location
    File.dirname(__FILE__) << "/fixtures/gitosis-admin"
  end

end