require 'brigit/commands/command'
require 'brigit/commands/update_command'

module Brigit
  
  class GrabCommand < Command
    
    self.help = "Grab repos matching optional pattern from a gitosis-admin config"
    
    def execute!
      validate!
      matching_repositories.each do |name, location|
        if File.exists?(name)
          STDERR.puts "#{name}: Already exists, skipping..."
        else
          STDERR.puts "#{name}: Cloning from #{location} ..."
          system "git clone '#{location}' '#{name}'"
          STDERR.puts "#{name}: Updating submodules ..."
          Dir.chdir name do
            updater.execute!
          end
        end
      end
    end
    
    #######
    private
    #######
    
    def updater
      @updater ||= UpdateCommand.new(options)
    end

    def validate!
      if options.inventory.empty?
        list = Inventory.listing { |name| "--#{name}" }
        fail "Can't find list of repositories; need to set #{list}"
      end            
    end
    
    def all_repositories
      options.inventory.inject({}) do |all, (klass, path)|
        source = klass.new(path)
        all.merge(source.repositories)
      end
    end
    
    def matching_repositories
      if args.empty?
        all_repositories
      else
        matching = all_repositories.select do |name, location|
          args.any? { |arg| name.include?(arg) }
        end
        Hash[*matching.flatten]
      end
    end
    
  end
  
end
      
    
  