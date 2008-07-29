require File.dirname(__FILE__) << "/test_helper"

class GrabCommandTest < Test::Unit::TestCase

  context "GrabCommand" do

    setup do
      mock_streams!
      @command = Brigit::GrabCommand.new
    end
    
    teardown { restore_streams! }
    
    context "update instance method" do
      setup do
        @updated = []
        flexmock(Brigit::UpdateCommand).new_instances do |mock|
          mock.should_receive(:run).and_return { @updated << Dir.pwd }
        end
      end
      should "update existing directory" do
        directory = File.join(location, 'existing_directory')
        Dir.chdir location do
          assert_nothing_raised do
            update File.basename(directory)
          end
          assert_equal 1, @updated.size
          assert @updated.include?(directory)
        end
      end
      should "gracefully ignore update on missing directory" do
        Dir.chdir location do
          assert_nothing_raised do
            update 'missing_directory'
          end
          assert stream_output.include?('skipping')
        end
      end
    end

  end
  
  #######
  private
  #######
  
  def update(name)
    @command.__send__(:update, name)
  end

  def location
    File.expand_path(File.dirname(__FILE__) << "/fixtures/grab_command")
  end

end