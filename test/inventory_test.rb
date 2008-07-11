require File.dirname(__FILE__) << "/test_helper"

class InventoryTest < Test::Unit::TestCase

  context "Inventory" do
    
    setup do
      @klass = Class.new(Brigit::Inventory)
    end
    
    context "repository method" do
      should "be abstract" do
        instance = @klass.new 'a-fake-path'
        assert_raises NotImplementedError do
          instance.repositories
        end
      end
    end

  end

end