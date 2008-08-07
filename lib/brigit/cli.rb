require 'ostruct'

module Brigit
  
  class CLI
    
    def parse(*args)
      if !args.empty? && (command = Command[args.shift])
        command.new(*args)
      else
        abort "No command given.\n\n#{self.class.usage}"
      end
    end
    
    def self.banner
      %{Brigit (v#{Version::STRING}) Submodule utilities for Git}
    end
        
    def self.usage
      lines = [
        banner,
        %{COMMANDS: (`COMMAND --help' for documentation)},
        *Command.list.map { |cmd| "  #{cmd.name}" }.sort
      ]
      lines.join "\n"
    end
    
  end
  
end