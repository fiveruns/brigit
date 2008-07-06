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
    
    attr_reader :options, :args
    def initialize(options, args)
      @options = options
      @args = args
    end
    
    def execute!
      raise self.class.name
    end
    
  end
  
end