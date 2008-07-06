require File.dirname(__FILE__) << "/test_helper"

class GitosisTest < Test::Unit::TestCase
  
  context "Gitosis" do
    setup do
      mock_gitosis!
      @gitosis = Brigit::GitosisAdmin.new(Brigit::Profile.new)
    end
    should "find all repositories" do
      assert_equal 10, @gitosis.repositories.size
    end
    should "not find duplicate repositories" do
      assert_equal @gitosis.repositories.keys.size, @gitosis.repositories.keys.uniq.size
    end
  end
  
end