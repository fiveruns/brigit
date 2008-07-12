require 'brigit/commands/command'
require 'brigit/commands/update_command'

module Brigit
  
  class GrabCommand < Command
    
    def run
      super { |parser| add_pretend_to parser }
      matching_repositories.each do |name, location|
        if File.exists?(name)
          say "#{name}: Already exists, skipping..."
        else
          say "#{name}: Cloning from #{location} ..."
          sh "git clone '#{location}' '#{name}'"
          say "#{name}: Updating submodules ..."
          update name
        end
      end
    end
    
    #######
    private
    #######
    
    def update(name)
      if pretending?
        say "(Would update submodules for `#{name}')"
      else
        if File.directory?(name)        
          Dir.chdir name do
            UpdateCommand.new.run
          end
        else
          say "ERROR: Directory #{name} was not created; skipping..."
        end
      end      
    end
    
    def inventory
      @inventory ||= GitosisInventory.new(args.shift)
    end
    
    def all_repositories
      inventory.repositories
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
      
    
  