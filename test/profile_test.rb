require File.dirname(__FILE__) << "/test_helper"

class ProfileTest < Test::Unit::TestCase
  
  context "Profile path" do
    should "find resource path" do
      profile = Brigit::Profile.new :test
      assert_equal File.expand_path('~/.brigit/profiles/test/foo'), profile.path_for('foo')
    end
  end
  
end