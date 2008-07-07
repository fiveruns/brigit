require 'brigit/listable'
require 'brigit/fallible'

module Brigit
  
  class Command
    include Listable
    include Fallible
    
    class << self
      attr_accessor :help
    end
    
    attr_reader :options, :args
    def initialize(options, *args)
      @options = options
      @args = args
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