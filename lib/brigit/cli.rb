require 'ostruct'

module Brigit
  
  class CLI
    
    def parse(*args)
      parser.parse!(args)
      if (args.first && command = Command[args.shift])
        yield command.new(options, args)
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
      options.profile = Brigit.default_profile
      @parser ||= OptionParser.new do |opts|
        
        opts.banner = 'brigit COMMAND [OPTIONS] [PATH, ...]'

        opts.separator "COMMANDS:\n#{command_list}\n"
        
        opts.separator "OPTIONS:\n"
        
        opts.on('-p NAME', '--profile', 'Set profile to NAME') do |name|
          options.profile = Brigit.profiles[name]
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