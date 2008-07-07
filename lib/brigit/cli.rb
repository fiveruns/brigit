require 'ostruct'

module Brigit
  
  class CLI
    
    def parse(*args)
      parser.parse!(args)
      if (args.first && command = Command[args.shift])
        yield command.new(options)
      else
        abort "No command given.\n#{parser}"
      end
    end
    
    def options
      @options ||= OpenStruct.new
    end
    
    #######
    private
    #######
    
    def parser
      
      @parser ||= OptionParser.new do |opts|
        
        opts.banner = %("Brigit," Submodule utilities for Git\nUSAGE: brigit COMMAND [OPTIONS])

        opts.separator "COMMANDS:\n#{command_list}\n"
        
        opts.separator "OPTIONS:\n"
        
        opts.on('-o', '--open', "Convert DOT to FORMAT  (`map' only, requires OSX & `dot' in PATH)") do
          options.open = true
        end
        
        opts.on_tail('-h', '--help', 'Show this message') do
          abort opts.to_s
        end
        
      end
    end
    
    def command_list
      Command.list.map { |command| "  * #{command.name}: #{command.help}" }.join("\n")
    end
    
  end
  
end