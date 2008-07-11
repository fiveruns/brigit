require File.dirname(__FILE__) << "/test_helper"

class BrigitTest < Test::Unit::TestCase

  context "Brigit" do
    
    context "at_dot_gitmodules method" do

      should "find directories with .gitmodules" do
        paths = []
        Brigit.at_dot_gitmodules(File.dirname(__FILE__) << "/fixtures/dotgitmodules") do |path|
          paths << path
        end
        assert_equal 2, paths.size
        assert_equal %w(dotgitmodules bar), paths.map { |path| File.basename(path) }
      end
    end
    
    context ".git path methods" do
      
      setup { locations.each { |loc| gitify!(loc) } }
      teardown { locations.each { |loc| degitify!(loc) } }
      
      context "submodule? method" do
        should "find submodule" do
          assert Brigit.submodule?(locations.last)
        end
      end

      context "parent_of method" do
        should "description" do
          parent, submodule = locations
          assert_equal parent, Brigit.parent_of(submodule)
        end
      end
      
      context "at_repos method" do
        setup { @paths = [] }
        should "find only base repos if requested" do
          find_repos(false)
          assert_equal 1, @paths.size
          assert_equal locations.first, @paths.first
        end
        should "find submodules also if requested" do
          find_repos(true)
          assert_equal locations, @paths
        end
      end
            
    end

  end
  
  #######
  private
  #######
  
  def find_repos(submodules)
    Brigit.at_repos(submodules, base) { |path| @paths << path }
  end
  
  def base
    File.expand_path(File.dirname(__FILE__) << "/fixtures/submodule_methods")
  end

  def locations
    Dir[File.join(base, '**/*')].select { |path| File.directory?(path) }
  end

end