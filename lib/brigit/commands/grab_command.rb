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
          if pretending?
            say "(Would update submodules for `#{name}')"
          else
            Dir.chdir name do
              UpdateCommand.new.run
            end
          end
        end
      end
    end
    
    #######
    private
    #######
    
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
      
    
  