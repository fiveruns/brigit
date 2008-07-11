require 'brigit/listable'
require 'brigit/fallible'
require 'brigit/pretending'


module Brigit
  
  class Command
    include Listable
    include Fallible
    include Pretending
    
    def self.help
      @help ||= begin
        help_file = File.dirname(__FILE__) << "/../../../help/#{name}.rdoc"
        if File.file?(help_file)
          File.read(help_file) 
        else
          "Sorry, there is no documentation for this command."
        end
      end
    end
    
    attr_reader :args
    def initialize(*args)
      @args = args
    end
    
    def run
      yield parser if block_given?
      parser.parse!(args)
    end
    
    #######
    private
    #######
    
    def say(message)
      message = pretending? ? "{PRETENDING} #{message}" : message
      $stderr.puts message
    end
    
    def sh(command)
      if pretending?
        say command
      else
        system command
      end
    end
    
    def check_repo!
      raise ArgumentError, "Must be in Git repository" unless repo?
    end
    
    def parser
      @parser ||= OptionParser.new do |opts|
        opts.banner = CLI.banner + "\n---\n= Help on the `#{self.class.name}' command\n\n" + self.class.help + "\n\n== Options\n"
        opts.on_tail('-h', '--help', 'Show this message') do
          abort opts.to_s
        end
      end
    end

    def repo?
      File.directory?(File.join(Dir.pwd, '.git'))
    end
    
  end
  
end