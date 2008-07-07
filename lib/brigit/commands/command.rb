module Brigit
  
  class Command
    
    def self.[](name)
      list.detect { |command| command.name == name }
    end
    
    def self.inherited(klass)
      list << klass
    end
    
    def self.list
      @list ||= []
    end
    
    def self.name
      to_s.sub(/^.+::(.+?)Command$/, '\1').downcase
    end
    
    class << self
      attr_accessor :help
    end
    
    attr_reader :options
    def initialize(options)
      @options = options
    end
    
    def execute!
      raise ArgumentError, "Must be in Git repository" unless repo?
    end
    
    #######
    private
    #######

    def repo?
      File.directory?(File.join(Dir.pwd, '.git'))
    end
    
  end
  
end