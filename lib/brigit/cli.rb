require 'ostruct'

module Brigit
  
  class CLI
    
    def parse(*args)
      self.class.parser.parse!(args)
      if (args.first && command = Command[args.shift])
        yield command.new(self.class.options, *args)
      else
        abort "No command given.\n#{parser}"
      end
    end
        
    def self.usage
      parser.to_s
    end
    
    #######
    private
    #######
    
    def self.options
      @options ||= OpenStruct.new
    end
    
    def self.parser
      
      command_list = Command.list.map { |command| "  * #{command.name}: #{command.help}" }.join("\n")
      
      options.inventory = {}
      
      @parser ||= OptionParser.new do |opts|
        
        opts.banner = %(Brigit (v#{Version::STRING}) Submodule utilities for Git\nUSAGE: brigit COMMAND [OPTIONS])

        opts.separator "COMMANDS:\n#{command_list}\n"
        
        opts.separator "OPTIONS:\n"

        Inventory.list.each do |inventory|
          opts.on("-#{inventory.name[0,1]}", "--#{inventory.name} PATH", "Location of #{inventory.name} (`grab' only)") do |path|
            options.inventory[inventory] = path
          end
        end
        
        opts.on('-o', '--open', "Open with Preview.app  (`map' only, requires OSX & `dot' in PATH)") do
          options.open = true
        end
        
        opts.on('-v', '--version', "Show version") do
          STDERR.puts "Brigit v#{Version::STRING}"
          exit
        end
        
        opts.on_tail('-h', '--help', 'Show this message') do
          abort opts.to_s
        end
        
      end
    end
    
  end
  
end